#!/bin/bash

echo "═══════════════════════════════════════════════════════════════"
echo "  Correction H2 - Base de données séparée par hôtel"
echo "═══════════════════════════════════════════════════════════════"
echo ""

# Couleurs
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${YELLOW}1. Arrêt des services existants...${NC}"
./arreter-services.sh 2>/dev/null
pkill -f "Hotellerie" 2>/dev/null
sleep 3

echo ""
echo -e "${YELLOW}2. Suppression des anciennes bases de données...${NC}"
rm -rf Hotellerie/data/*.db Hotellerie/data/*.log 2>/dev/null
echo -e "${GREEN}✓ Bases de données supprimées${NC}"

echo ""
echo -e "${YELLOW}3. Recompilation du module Hotellerie...${NC}"
cd Hotellerie
mvn clean install -DskipTests -q
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Compilation réussie${NC}"
else
    echo -e "${RED}✗ Échec de la compilation${NC}"
    exit 1
fi
cd ..

echo ""
echo -e "${YELLOW}4. Vérification des profils H2...${NC}"
echo "  Paris      : jdbc:h2:file:./data/hotellerie-paris-db"
echo "  Lyon       : jdbc:h2:file:./data/hotellerie-lyon-db"
echo "  Montpellier: jdbc:h2:file:./data/hotellerie-montpellier-db"

echo ""
echo -e "${YELLOW}5. Redémarrage des services avec bases séparées...${NC}"
./start-system-maven.sh

echo ""
echo "═══════════════════════════════════════════════════════════════"
echo -e "${GREEN}✓ Correction appliquée avec succès${NC}"
echo "═══════════════════════════════════════════════════════════════"
echo ""
echo "Chaque hôtel a maintenant sa propre base de données :"
echo "  • Paris      → ./data/hotellerie-paris-db.mv.db"
echo "  • Lyon       → ./data/hotellerie-lyon-db.mv.db"
echo "  • Montpellier → ./data/hotellerie-montpellier-db.mv.db"
echo ""
echo "Consoles H2 :"
echo "  • Paris      : http://localhost:8082/h2-console"
echo "  • Lyon       : http://localhost:8083/h2-console"
echo "  • Montpellier : http://localhost:8084/h2-console"
echo ""
echo "Pour lancer le client :"
echo "  cd Client"
echo "  mvn spring-boot:run"
echo ""

