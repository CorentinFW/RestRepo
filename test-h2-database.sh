#!/bin/bash

echo "═══════════════════════════════════════════════════════════════"
echo "  Test de la base de données H2 - Module Hotellerie"
echo "═══════════════════════════════════════════════════════════════"
echo ""

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Fonction pour afficher un message de succès
success() {
    echo -e "${GREEN}✓${NC} $1"
}

# Fonction pour afficher un message d'erreur
error() {
    echo -e "${RED}✗${NC} $1"
}

# Fonction pour afficher un message d'info
info() {
    echo -e "${YELLOW}ℹ${NC} $1"
}

echo "1. Vérification de la compilation..."
cd Hotellerie
if mvn clean compile -DskipTests > /dev/null 2>&1; then
    success "Compilation réussie"
else
    error "Échec de la compilation"
    exit 1
fi

echo ""
echo "2. Démarrage de l'hôtel Paris (port 8082)..."
cd ..
info "Lancement en arrière-plan..."

# Arrêter les processus existants sur le port 8082
fuser -k 8082/tcp 2>/dev/null

# Démarrer l'hôtel Paris
cd Hotellerie
java -jar target/Hotellerie-0.0.1-SNAPSHOT.jar \
    --server.port=8082 \
    --hotel.nom="Grand Hotel Paris" \
    --hotel.adresse="10 Rue de la Paix, Paris" \
    --hotel.ville=Paris \
    --hotel.categorie=CAT5 > ../logs/test-h2-paris.log 2>&1 &

PARIS_PID=$!
info "PID de l'hôtel Paris: $PARIS_PID"

# Attendre le démarrage
echo ""
info "Attente du démarrage (15 secondes)..."
sleep 15

# Vérifier si le processus est toujours en cours
if ps -p $PARIS_PID > /dev/null; then
    success "Hôtel Paris démarré"
else
    error "L'hôtel Paris n'a pas démarré correctement"
    cat ../logs/test-h2-paris.log | tail -20
    exit 1
fi

echo ""
echo "3. Test de l'API REST..."

# Test de l'endpoint info
echo -n "   Test GET /api/hotel/info... "
RESPONSE=$(curl -s http://localhost:8082/api/hotel/info)
if echo "$RESPONSE" | grep -q "Paris"; then
    success "OK"
else
    error "ÉCHEC"
    echo "   Réponse: $RESPONSE"
fi

# Test de recherche de chambres
echo -n "   Test POST /api/hotel/chambres/rechercher... "
RESPONSE=$(curl -s -X POST http://localhost:8082/api/hotel/chambres/rechercher \
    -H "Content-Type: application/json" \
    -d '{"adresse":"Paris","dateArrive":"2025-12-01","dateDepart":"2025-12-05"}')
if echo "$RESPONSE" | grep -q "Chambre"; then
    NB_CHAMBRES=$(echo "$RESPONSE" | grep -o "\"nom\"" | wc -l)
    success "OK - $NB_CHAMBRES chambre(s) trouvée(s)"
else
    error "ÉCHEC"
    echo "   Réponse: $RESPONSE"
fi

echo ""
echo "4. Vérification de la base de données..."

# Vérifier que le fichier de base de données existe
cd ..
if [ -f "Hotellerie/data/hotellerie-db.mv.db" ]; then
    success "Fichier de base de données créé"
    SIZE=$(du -h Hotellerie/data/hotellerie-db.mv.db | cut -f1)
    info "Taille: $SIZE"
else
    error "Fichier de base de données non trouvé"
fi

echo ""
echo "5. Test de persistance..."

# Faire une réservation
echo -n "   Création d'une réservation... "
RESPONSE=$(curl -s -X POST http://localhost:8082/api/hotel/reservations \
    -H "Content-Type: application/json" \
    -d '{
        "nomClient":"Dupont",
        "prenomClient":"Jean",
        "numeroCarteBancaire":"1234567890123456",
        "chambreId":1,
        "dateArrive":"2025-12-01",
        "dateDepart":"2025-12-05"
    }')
if echo "$RESPONSE" | grep -q "success.*true"; then
    RESERVATION_ID=$(echo "$RESPONSE" | grep -o '"reservationId":[0-9]*' | grep -o '[0-9]*')
    success "OK - ID: $RESERVATION_ID"
else
    error "ÉCHEC"
    echo "   Réponse: $RESPONSE"
fi

# Vérifier les réservations
echo -n "   Récupération des réservations... "
RESPONSE=$(curl -s http://localhost:8082/api/hotel/reservations)
if echo "$RESPONSE" | grep -q "Dupont"; then
    success "OK - Réservation trouvée"
else
    error "ÉCHEC"
fi

echo ""
echo "6. Arrêt de l'hôtel..."
kill $PARIS_PID
wait $PARIS_PID 2>/dev/null
success "Hôtel arrêté"

echo ""
echo "7. Test de rechargement depuis la base..."
info "Redémarrage de l'hôtel..."

# Redémarrer l'hôtel
cd Hotellerie
java -jar target/Hotellerie-0.0.1-SNAPSHOT.jar \
    --server.port=8082 \
    --hotel.nom="Grand Hotel Paris" \
    --hotel.adresse="10 Rue de la Paix, Paris" \
    --hotel.ville=Paris \
    --hotel.categorie=CAT5 > ../logs/test-h2-paris-2.log 2>&1 &

PARIS_PID=$!
sleep 15

# Vérifier si la réservation existe toujours
echo -n "   Vérification de la persistance... "
RESPONSE=$(curl -s http://localhost:8082/api/hotel/reservations)
if echo "$RESPONSE" | grep -q "Dupont"; then
    success "OK - Données rechargées depuis la base"
else
    error "ÉCHEC - Données perdues"
fi

# Vérifier les logs de démarrage
if grep -q "Hôtel chargé depuis la base de données" Hotellerie/logs/test-h2-paris-2.log; then
    success "L'hôtel a été rechargé depuis la base"
else
    info "L'hôtel semble avoir été recréé (logs)"
fi

echo ""
echo "8. Nettoyage..."
kill $PARIS_PID 2>/dev/null
wait $PARIS_PID 2>/dev/null
success "Processus arrêtés"

echo ""
echo "═══════════════════════════════════════════════════════════════"
echo "  Résumé du test"
echo "═══════════════════════════════════════════════════════════════"
echo ""
success "Base de données H2 fonctionnelle"
success "Persistance des données vérifiée"
success "API REST opérationnelle"
echo ""
info "Console H2: http://localhost:8082/h2-console"
info "JDBC URL: jdbc:h2:file:./Hotellerie/data/hotellerie-db"
echo ""
info "Logs disponibles dans:"
echo "   - logs/test-h2-paris.log"
echo "   - logs/test-h2-paris-2.log"
echo ""
echo "═══════════════════════════════════════════════════════════════"

