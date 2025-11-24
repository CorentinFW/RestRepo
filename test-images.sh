#!/bin/bash

echo "=========================================="
echo "🖼️  Test des images des hôtels"
echo "=========================================="
echo ""

# Attendre que les services soient prêts
echo "⏳ Attente du démarrage complet (30 secondes)..."
sleep 30

# Couleurs
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo ""
echo "Test 1: Accès direct aux images"
echo "================================"

# Test Paris
echo -n "🏨 Paris (Hotelle1.png): "
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8082/images/Hotelle1.png)
if [ "$HTTP_CODE" -eq 200 ]; then
    echo -e "${GREEN}✅ OK (HTTP $HTTP_CODE)${NC}"
    echo "   URL: http://localhost:8082/images/Hotelle1.png"
else
    echo -e "${RED}❌ Échec (HTTP $HTTP_CODE)${NC}"
fi

# Test Lyon
echo -n "🏨 Lyon (Hotelle2.png): "
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8083/images/Hotelle2.png)
if [ "$HTTP_CODE" -eq 200 ]; then
    echo -e "${GREEN}✅ OK (HTTP $HTTP_CODE)${NC}"
    echo "   URL: http://localhost:8083/images/Hotelle2.png"
else
    echo -e "${RED}❌ Échec (HTTP $HTTP_CODE)${NC}"
fi

# Test Montpellier
echo -n "🏨 Montpellier (Hotelle3.png): "
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8084/images/Hotelle3.png)
if [ "$HTTP_CODE" -eq 200 ]; then
    echo -e "${GREEN}✅ OK (HTTP $HTTP_CODE)${NC}"
    echo "   URL: http://localhost:8084/images/Hotelle3.png"
else
    echo -e "${RED}❌ Échec (HTTP $HTTP_CODE)${NC}"
fi

echo ""
echo "Test 2: URLs d'images dans les chambres"
echo "========================================"

# Test Paris
echo "🏨 Paris - Recherche de chambres:"
RESPONSE=$(curl -s -X POST http://localhost:8082/api/hotel/chambres/rechercher \
  -H "Content-Type: application/json" \
  -d '{"dateArrive":"2025-12-01","dateDepart":"2025-12-05"}')

if echo "$RESPONSE" | python3 -c "import sys,json; d=json.load(sys.stdin); print('   Image:', d[0]['image'])" 2>/dev/null; then
    echo -e "${GREEN}   ✅ Les chambres ont des URLs d'images${NC}"
else
    echo -e "${RED}   ❌ Pas d'image dans les chambres${NC}"
fi

echo ""
echo "Test 3: Images via l'agence"
echo "============================"

RESPONSE=$(curl -s -X POST http://localhost:8081/api/agence/chambres/rechercher \
  -H "Content-Type: application/json" \
  -d '{"dateArrive":"2025-12-01","dateDepart":"2025-12-05","prixMin":0,"prixMax":200}')

NB_CHAMBRES=$(echo "$RESPONSE" | python3 -c "import sys,json; print(len(json.load(sys.stdin)))" 2>/dev/null)

if [ ! -z "$NB_CHAMBRES" ]; then
    echo -e "${GREEN}✅ $NB_CHAMBRES chambre(s) trouvée(s) via l'agence${NC}"
    echo "$RESPONSE" | python3 -c "import sys,json; chambres=json.load(sys.stdin); [print(f\"   - {c['nom']} ({c['hotelNom']}): {c.get('imageUrl', 'Pas d\'image')}\") for c in chambres[:3]]" 2>/dev/null
else
    echo -e "${RED}❌ Erreur lors de la recherche via l'agence${NC}"
fi

echo ""
echo "=========================================="
echo "🎉 Tests terminés"
echo "=========================================="
echo ""
echo "Pour voir les images dans un navigateur:"
echo "  http://localhost:8082/images/Hotelle1.png"
echo "  http://localhost:8083/images/Hotelle2.png"
echo "  http://localhost:8084/images/Hotelle3.png"

