#!/bin/bash

# Script complet pour démarrer le système avec interface graphique

echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║                                                               ║"
echo "║   DÉMARRAGE COMPLET - SYSTÈME MULTI-AGENCES + GUI             ║"
echo "║                                                               ║"
echo "╚═══════════════════════════════════════════════════════════════╝"
echo ""

# Créer le dossier logs
mkdir -p logs

# Fonction pour attendre
wait_service() {
    echo -n "   Attente démarrage"
    for i in {1..10}; do
        sleep 1
        echo -n "."
    done
    echo " ✓"
}

# Arrêter les anciens services
echo "🛑 Arrêt des services existants..."
pkill -f 'java.*Agence' 2>/dev/null
pkill -f 'java.*Hotellerie' 2>/dev/null
sleep 2
echo ""

echo "═══════════════════════════════════════════════════════════════"
echo "   ÉTAPE 1/4 : Démarrage des 3 Hôtels"
echo "═══════════════════════════════════════════════════════════════"
echo ""

cd "$(dirname "$0")"

# Hôtel Paris
echo "🏨 Démarrage Hôtel Paris (Port 8082)..."
nohup java -jar Hotellerie/target/Hotellerie-0.0.1-SNAPSHOT.jar --spring.profiles.active=paris > logs/hotel-paris.log 2>&1 &
wait_service

# Hôtel Lyon
echo "🏨 Démarrage Hôtel Lyon (Port 8083)..."
nohup java -jar Hotellerie/target/Hotellerie-0.0.1-SNAPSHOT.jar --spring.profiles.active=lyon > logs/hotel-lyon.log 2>&1 &
wait_service

# Hôtel Montpellier
echo "🏨 Démarrage Hôtel Montpellier (Port 8084)..."
nohup java -jar Hotellerie/target/Hotellerie-0.0.1-SNAPSHOT.jar --spring.profiles.active=montpellier > logs/hotel-montpellier.log 2>&1 &
wait_service

echo ""
echo "═══════════════════════════════════════════════════════════════"
echo "   ÉTAPE 2/4 : Démarrage Agence 1 (Paris Voyages)"
echo "═══════════════════════════════════════════════════════════════"
echo ""

echo "🏢 Démarrage Agence 1 (Port 8081)..."
echo "   Configuration: Paris + Lyon | Coefficient: 1.15"
nohup java -jar Agence/target/Agence-0.0.1-SNAPSHOT.jar --spring.profiles.active=agence1 > logs/agence.log 2>&1 &
wait_service

echo ""
echo "═══════════════════════════════════════════════════════════════"
echo "   ÉTAPE 3/4 : Démarrage Agence 2 (Sud Réservations)"
echo "═══════════════════════════════════════════════════════════════"
echo ""

echo "🏢 Démarrage Agence 2 (Port 8085)..."
echo "   Configuration: Lyon + Montpellier | Coefficient: 1.20"
nohup java -jar Agence/target/Agence-0.0.1-SNAPSHOT.jar --spring.profiles.active=agence2 > logs/agence2.log 2>&1 &
wait_service

echo ""
echo "✅ Services backend démarrés !"
echo ""
echo "   🏨 Hôtels : Paris (8082), Lyon (8083), Montpellier (8084)"
echo "   🏢 Agences : Agence 1 (8081), Agence 2 (8085)"
echo ""
echo "📝 Logs disponibles dans: logs/"
echo ""

# Attendre que les services soient vraiment prêts
echo "⏳ Attente que les services soient complètement prêts (15 secondes)..."
sleep 15
echo ""
echo ""
echo "═══════════════════════════════════════════════════════════════"
echo "   ÉTAPE 4/4 : Lancement Interface Graphique"
echo "═══════════════════════════════════════════════════════════════"
echo ""

cd Client

echo "🚀 Ouverture de l'interface graphique..."
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
echo "   pkill -f 'java.*Agence'"
echo "   pkill -f 'java.*Hotellerie'"
echo ""

