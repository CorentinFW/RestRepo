#!/bin/bash

echo "🔄 Redémarrage rapide du système REST..."

# Arrêter tous les services
pkill -f "Hotellerie.*spring-boot:run" 2>/dev/null
pkill -f "Agence.*spring-boot:run" 2>/dev/null
sleep 2

# Créer logs
mkdir -p logs

echo "🏨 Démarrage des hôtels..."
cd /home/corentinfay/Bureau/RestRepo/Hotellerie
mvn spring-boot:run -Dspring-boot.run.profiles=paris > ../logs/hotel-paris.log 2>&1 &
sleep 3
mvn spring-boot:run -Dspring-boot.run.profiles=lyon > ../logs/hotel-lyon.log 2>&1 &
sleep 3
mvn spring-boot:run -Dspring-boot.run.profiles=montpellier > ../logs/hotel-montpellier.log 2>&1 &
sleep 5

echo "🏢 Démarrage de l'agence..."
cd /home/corentinfay/Bureau/RestRepo/Agence
mvn spring-boot:run > ../logs/agence.log 2>&1 &
sleep 10

echo "✅ Système redémarré !"
echo ""
echo "Services:"
echo "  🏨 Paris:       http://localhost:8082/api/hotel/info"
echo "  🏨 Lyon:        http://localhost:8083/api/hotel/info"
echo "  🏨 Montpellier: http://localhost:8084/api/hotel/info"
echo "  🏢 Agence:      http://localhost:8081/api/agence/ping"
echo ""
echo "Pour le client: cd Client && mvn spring-boot:run"



cd Client && mvn spring-boot:run
