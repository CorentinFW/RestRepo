#!/bin/bash

# Script pour démarrer les 3 hôtels en arrière-plan

echo "🏨 Démarrage des 3 hôtels..."

cd "$(dirname "$0")/Hotellerie"

# Démarrer Hôtel Paris (8082)
echo "  ✓ Hôtel Paris (8082)..."
mvn spring-boot:run -Dspring-boot.run.profiles=paris > ../logs/hotel-paris.log 2>&1 &
sleep 5

# Démarrer Hôtel Lyon (8083)
echo "  ✓ Hôtel Lyon (8083)..."
mvn spring-boot:run -Dspring-boot.run.profiles=lyon > ../logs/hotel-lyon.log 2>&1 &
sleep 5

# Démarrer Hôtel Montpellier (8084)
echo "  ✓ Hôtel Montpellier (8084)..."
mvn spring-boot:run -Dspring-boot.run.profiles=montpellier > ../logs/hotel-montpellier.log 2>&1 &
sleep 5

echo "✅ Les 3 hôtels sont démarrés"

