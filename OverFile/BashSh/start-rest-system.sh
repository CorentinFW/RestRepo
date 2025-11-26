#!/bin/bash

# Script pour démarrer tout le système REST
# Usage: ./start-rest-system.sh

echo "=========================================="
echo "🚀 Démarrage du Système de Réservation REST"
echo "=========================================="
echo ""

# Couleurs
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

# Vérifier si Maven est installé
if ! command -v mvn &> /dev/null; then
    echo "❌ Maven n'est pas installé"
    exit 1
fi

echo -e "${YELLOW}📦 Compilation des modules...${NC}"
echo ""

# Compiler Hotellerie
echo -e "${CYAN}[1/3] Compilation Hotellerie...${NC}"
cd Hotellerie && mvn clean install -DskipTests -q
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Hotellerie compilé${NC}"
else
    echo "❌ Erreur compilation Hotellerie"
    exit 1
fi
cd ..

# Compiler Agence
echo -e "${CYAN}[2/3] Compilation Agence...${NC}"
cd Agence && mvn clean install -DskipTests -q
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Agence compilé${NC}"
else
    echo "❌ Erreur compilation Agence"
    exit 1
fi
cd ..

# Compiler Client
echo -e "${CYAN}[3/3] Compilation Client...${NC}"
cd Client && mvn clean install -DskipTests -q
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Client compilé${NC}"
else
    echo "❌ Erreur compilation Client"
    exit 1
fi
cd ..

echo ""
echo -e "${GREEN}✅ Tous les modules sont compilés${NC}"
echo ""

# Créer les dossiers de logs
mkdir -p logs

echo -e "${YELLOW}🏨 Démarrage des hôtels...${NC}"

# Démarrer Paris
echo "  → Démarrage Hôtel Paris (port 8082)..."
cd Hotellerie
mvn spring-boot:run -Dspring-boot.run.profiles=paris > ../logs/hotel-paris.log 2>&1 &
PARIS_PID=$!
cd ..
sleep 2

# Démarrer Lyon
echo "  → Démarrage Hôtel Lyon (port 8083)..."
cd Hotellerie
mvn spring-boot:run -Dspring-boot.run.profiles=lyon > ../logs/hotel-lyon.log 2>&1 &
LYON_PID=$!
cd ..
sleep 2

# Démarrer Montpellier
echo "  → Démarrage Hôtel Montpellier (port 8084)..."
cd Hotellerie
mvn spring-boot:run -Dspring-boot.run.profiles=montpellier > ../logs/hotel-montpellier.log 2>&1 &
MONTPELLIER_PID=$!
cd ..

echo -e "${GREEN}✅ Hôtels démarrés${NC}"
echo "   Paris: PID $PARIS_PID"
echo "   Lyon: PID $LYON_PID"
echo "   Montpellier: PID $MONTPELLIER_PID"
echo ""

# Attendre que les hôtels soient prêts
echo -e "${YELLOW}⏳ Attente du démarrage des hôtels (15 secondes)...${NC}"
sleep 15

# Démarrer l'Agence
echo -e "${YELLOW}🏢 Démarrage de l'Agence (port 8081)...${NC}"
cd Agence
mvn spring-boot:run > ../logs/agence.log 2>&1 &
AGENCE_PID=$!
cd ..

echo -e "${GREEN}✅ Agence démarrée${NC}"
echo "   PID: $AGENCE_PID"
echo ""

# Attendre que l'agence soit prête
echo -e "${YELLOW}⏳ Attente du démarrage de l'agence (15 secondes)...${NC}"
sleep 15

echo ""
echo "=========================================="
echo -e "${GREEN}✅ Système démarré avec succès !${NC}"
echo "=========================================="
echo ""
echo "Services actifs:"
echo "  🏨 Hôtel Paris:       http://localhost:8082/api/hotel/info"
echo "  🏨 Hôtel Lyon:        http://localhost:8083/api/hotel/info"
echo "  🏨 Hôtel Montpellier: http://localhost:8084/api/hotel/info"
echo "  🏢 Agence:            http://localhost:8081/api/agence/ping"
echo ""
echo "Swagger UI:"
echo "  📚 Paris:             http://localhost:8082/swagger-ui/index.html"
echo "  📚 Lyon:              http://localhost:8083/swagger-ui/index.html"
echo "  📚 Montpellier:       http://localhost:8084/swagger-ui/index.html"
echo "  📚 Agence:            http://localhost:8081/swagger-ui/index.html"
echo ""
echo "Logs disponibles dans: ./logs/"
echo ""
echo "Pour démarrer le client CLI:"
echo "  cd Client && mvn spring-boot:run"
echo ""
echo "Pour arrêter tous les services:"
echo "  pkill -f 'Hotellerie.*spring-boot:run'"
echo "  pkill -f 'Agence.*spring-boot:run'"
echo ""

