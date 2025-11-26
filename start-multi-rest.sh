#!/bin/bash

# Script de démarrage complet du système Multi-Agences REST
# Architecture: 3 Hôtels + 2 Agences + 1 Client

echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║                                                               ║"
echo "║   DÉMARRAGE DU SYSTÈME DE RÉSERVATION MULTI-AGENCES REST     ║"
echo "║                                                               ║"
echo "╚═══════════════════════════════════════════════════════════════╝"
echo ""

# Créer le dossier logs s'il n'existe pas
mkdir -p logs

# Fonction pour afficher une barre de progression
wait_with_progress() {
    local duration=$1
    local message=$2
    echo -n "$message"
    for i in $(seq 1 $duration); do
        echo -n "."
        sleep 1
    done
    echo " ✓"
}

echo "═══════════════════════════════════════════════════════════════"
echo "   ÉTAPE 1/4 : Démarrage des 3 Hôtels"
echo "═══════════════════════════════════════════════════════════════"
echo ""

cd "$(dirname "$0")/Hotellerie"

# Démarrer Hôtel Paris (8082)
echo "🏨 Démarrage de l'Hôtel Paris (Port 8082)..."
nohup mvn spring-boot:run -Dspring-boot.run.profiles=paris > ../logs/hotel-paris.log 2>&1 &
PARIS_PID=$!
echo "   ✓ PID: $PARIS_PID"
sleep 5

# Démarrer Hôtel Lyon (8083)
echo "🏨 Démarrage de l'Hôtel Lyon (Port 8083)..."
nohup mvn spring-boot:run -Dspring-boot.run.profiles=lyon > ../logs/hotel-lyon.log 2>&1 &
LYON_PID=$!
echo "   ✓ PID: $LYON_PID"
sleep 5

# Démarrer Hôtel Montpellier (8084)
echo "🏨 Démarrage de l'Hôtel Montpellier (Port 8084)..."
nohup mvn spring-boot:run -Dspring-boot.run.profiles=montpellier > ../logs/hotel-montpellier.log 2>&1 &
MONT_PID=$!
echo "   ✓ PID: $MONT_PID"

wait_with_progress 10 "⏳ Attente du démarrage complet des hôtels"

echo ""
echo "═══════════════════════════════════════════════════════════════"
echo "   ÉTAPE 2/4 : Démarrage de l'Agence 1 (Paris Voyages)"
echo "═══════════════════════════════════════════════════════════════"
echo ""

cd ../Agence

echo "🏢 Démarrage de l'Agence 1 (Port 8081)..."
echo "   Configuration: Paris + Lyon"
echo "   Coefficient: 1.15"
nohup java -jar target/Agence-0.0.1-SNAPSHOT.jar --spring.profiles.active=agence1 > ../logs/agence.log 2>&1 &
AGENCE1_PID=$!
echo "   ✓ PID: $AGENCE1_PID"

wait_with_progress 8 "⏳ Attente du démarrage de l'Agence 1"

echo ""
echo "═══════════════════════════════════════════════════════════════"
echo "   ÉTAPE 3/4 : Démarrage de l'Agence 2 (Sud Réservations)"
echo "═══════════════════════════════════════════════════════════════"
echo ""

echo "🏢 Démarrage de l'Agence 2 (Port 8085)..."
echo "   Configuration: Lyon + Montpellier"
echo "   Coefficient: 1.20"
nohup java -jar target/Agence-0.0.1-SNAPSHOT.jar --spring.profiles.active=agence2 > ../logs/agence2.log 2>&1 &
AGENCE2_PID=$!
echo "   ✓ PID: $AGENCE2_PID"

wait_with_progress 8 "⏳ Attente du démarrage de l'Agence 2"

echo ""
echo "═══════════════════════════════════════════════════════════════"
echo "   ÉTAPE 4/4 : Démarrage du Client CLI"
echo "═══════════════════════════════════════════════════════════════"
echo ""

cd ../Client

echo "💻 Lancement du Client Multi-Agences..."
echo "   Connecté à: Agence 1 (8081) + Agence 2 (8085)"
echo ""
echo "⚠️  Le client va s'ouvrir dans ce terminal"
echo "⚠️  Utilisez Ctrl+C pour quitter le client"
echo ""
sleep 3

# Démarrer le client en mode interactif (premier plan)
mvn spring-boot:run

# Si le client se termine, afficher un message
echo ""
echo "═══════════════════════════════════════════════════════════════"
echo "   Client fermé"
echo "═══════════════════════════════════════════════════════════════"
echo ""
echo "Les services backend continuent de tourner en arrière-plan:"
echo "   🏨 Hôtel Paris       (PID: $PARIS_PID)"
echo "   🏨 Hôtel Lyon        (PID: $LYON_PID)"
echo "   🏨 Hôtel Montpellier (PID: $MONT_PID)"
echo "   🏢 Agence 1          (PID: $AGENCE1_PID)"
echo "   🏢 Agence 2          (PID: $AGENCE2_PID)"
echo ""
echo "📝 Logs disponibles dans: logs/"
echo ""
echo "🛑 Pour arrêter tous les services:"
echo "   pkill -f 'java.*Hotellerie'"
echo "   pkill -f 'java.*Agence'"
echo ""

