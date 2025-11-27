#!/bin/bash

echo "═══════════════════════════════════════════════════════════════"
echo "  Correction du bug de réservation - Recompilation"
echo "═══════════════════════════════════════════════════════════════"
echo ""

# Couleurs
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}1. Arrêt des services existants...${NC}"
./arreter-services.sh 2>/dev/null
sleep 2

echo ""
echo -e "${YELLOW}2. Recompilation du module Hotellerie...${NC}"
cd Hotellerie
mvn clean install -DskipTests
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Compilation réussie${NC}"
else
    echo "✗ Échec de la compilation"
    exit 1
fi
cd ..

echo ""
echo -e "${YELLOW}3. Redémarrage des services...${NC}"
./start-system-maven.sh

echo ""
echo "═══════════════════════════════════════════════════════════════"
echo -e "${GREEN}✓ Services redémarrés avec la correction${NC}"
echo "═══════════════════════════════════════════════════════════════"
echo ""
echo "Pour lancer le client graphique :"
echo "  cd Client"
echo "  mvn spring-boot:run"
echo ""
echo "Documentation : CORRECTION-BUG-RESERVATION.md"
echo ""

