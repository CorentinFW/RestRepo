#!/bin/bash

# Script de démarrage complet du système multi-agences avec Maven

echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║                                                               ║"
echo "║   DÉMARRAGE SYSTÈME MULTI-AGENCES - VERSION MAVEN             ║"
echo "║                                                               ║"
echo "╚═══════════════════════════════════════════════════════════════╝"
echo ""

# Créer le dossier logs
mkdir -p logs

# Arrêter les anciens services
echo "🛑 Arrêt des services existants..."
pkill -f 'maven.*Hotellerie' 2>/dev/null
pkill -f 'maven.*Agence' 2>/dev/null
pkill -f 'java.*Hotellerie' 2>/dev/null
pkill -f 'java.*Agence' 2>/dev/null
sleep 2
echo ""

echo "═══════════════════════════════════════════════════════════════"
echo "   ÉTAPE 1/4 : Démarrage des 3 Hôtels (Maven)"
echo "═══════════════════════════════════════════════════════════════"
echo ""

cd "$(dirname "$0")"

# Hôtel Paris
echo "🏨 Démarrage Hôtel Paris (Port 8082)..."
cd Hotellerie
mvn spring-boot:run -Dspring-boot.run.profiles=paris > ../logs/hotel-paris.log 2>&1 &
PARIS_PID=$!
cd ..
echo "   PID: $PARIS_PID"
sleep 5

# Hôtel Lyon
echo "🏨 Démarrage Hôtel Lyon (Port 8083)..."
cd Hotellerie
mvn spring-boot:run -Dspring-boot.run.profiles=lyon > ../logs/hotel-lyon.log 2>&1 &
LYON_PID=$!
cd ..
echo "   PID: $LYON_PID"
sleep 5

# Hôtel Montpellier
echo "🏨 Démarrage Hôtel Montpellier (Port 8084)..."
cd Hotellerie
mvn spring-boot:run -Dspring-boot.run.profiles=montpellier > ../logs/hotel-montpellier.log 2>&1 &
MONTPELLIER_PID=$!
cd ..
echo "   PID: $MONTPELLIER_PID"
sleep 5

echo ""
echo "═══════════════════════════════════════════════════════════════"
echo "   ÉTAPE 2/4 : Démarrage Agence 1 (Paris Voyages)"
echo "═══════════════════════════════════════════════════════════════"
echo ""

echo "🏢 Démarrage Agence 1 (Port 8081)..."
echo "   Configuration: Paris + Lyon | Coefficient: 1.15"
cd Agence
mvn spring-boot:run -Dspring-boot.run.profiles=agence1 > ../logs/agence1.log 2>&1 &
AGENCE1_PID=$!
cd ..
echo "   PID: $AGENCE1_PID"
sleep 5

echo ""
echo "═══════════════════════════════════════════════════════════════"
echo "   ÉTAPE 3/4 : Démarrage Agence 2 (Sud Réservations)"
echo "═══════════════════════════════════════════════════════════════"
echo ""

echo "🏢 Démarrage Agence 2 (Port 8085)..."
echo "   Configuration: Lyon + Montpellier | Coefficient: 1.20"
cd Agence
mvn spring-boot:run -Dspring-boot.run.profiles=agence2 > ../logs/agence2.log 2>&1 &
AGENCE2_PID=$!
cd ..
echo "   PID: $AGENCE2_PID"
sleep 5

echo ""
echo "✅ Services backend démarrés !"
echo ""
echo "   🏨 Hôtels : Paris ($PARIS_PID), Lyon ($LYON_PID), Montpellier ($MONTPELLIER_PID)"
echo "   🏢 Agences : Agence 1 ($AGENCE1_PID), Agence 2 ($AGENCE2_PID)"
echo ""
echo "📝 Logs disponibles dans: logs/"
echo "   - hotel-paris.log"
echo "   - hotel-lyon.log"
echo "   - hotel-montpellier.log"
echo "   - agence1.log"
echo "   - agence2.log"
echo ""

# Attendre que les services soient vraiment prêts
echo "⏳ Attente que les services soient complètement prêts (20 secondes)..."
sleep 20
echo ""

echo "═══════════════════════════════════════════════════════════════"
echo "   ÉTAPE 4/4 : Lancement Interface Graphique"
echo "═══════════════════════════════════════════════════════════════"
echo ""

cd Client

echo "🚀 Ouverture de l'interface graphique..."
echo ""
echo "💡 Conseil: Regardez les logs en temps réel avec:"
echo "   tail -f logs/hotel-paris.log"
echo "   tail -f logs/agence1.log"
echo ""

# Lancer le client GUI
MAVEN_OPTS="-Djava.awt.headless=false" mvn spring-boot:run \
  -Dspring-boot.run.arguments="--gui" \
  -Dspring-boot.run.jvmArguments="-Djava.awt.headless=false"

# Quand le client se ferme
echo ""
echo "═══════════════════════════════════════════════════════════════"
echo "   Interface fermée"
echo "═══════════════════════════════════════════════════════════════"
echo ""
echo "ℹ️  Les services backend continuent de tourner en arrière-plan"
echo ""
echo "🛑 Pour arrêter tous les services:"
echo "   ./arreter-services.sh"
echo ""
echo "   Ou manuellement:"
echo "   pkill -f 'maven.*Hotellerie'"
echo "   pkill -f 'maven.*Agence'"
echo ""

