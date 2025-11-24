#!/bin/bash

# Script de test pour le module Hotellerie REST API
# Usage: ./test-hotellerie.sh [port]

PORT=${1:-8082}
BASE_URL="http://localhost:$PORT/api/hotel"

echo "======================================"
echo "🧪 Tests API REST - Module Hotellerie"
echo "======================================"
echo "Port: $PORT"
echo "Base URL: $BASE_URL"
echo ""

# Couleurs
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test 1: GET /api/hotel/info
echo -e "${YELLOW}Test 1: GET /api/hotel/info${NC}"
RESPONSE=$(curl -s -w "\n%{http_code}" "$BASE_URL/info")
HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
BODY=$(echo "$RESPONSE" | sed '$d')

if [ "$HTTP_CODE" -eq 200 ]; then
    echo -e "${GREEN}✅ Succès (HTTP $HTTP_CODE)${NC}"
    echo "$BODY" | python3 -m json.tool
else
    echo -e "${RED}❌ Échec (HTTP $HTTP_CODE)${NC}"
fi
echo ""

# Test 2: POST /api/hotel/chambres/rechercher
echo -e "${YELLOW}Test 2: POST /api/hotel/chambres/rechercher${NC}"
RESPONSE=$(curl -s -w "\n%{http_code}" -X POST "$BASE_URL/chambres/rechercher" \
  -H "Content-Type: application/json" \
  -d '{
    "adresse": "Paris",
    "dateArrive": "2025-12-01",
    "dateDepart": "2025-12-05",
    "prixMin": 50,
    "prixMax": 200
  }')
HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
BODY=$(echo "$RESPONSE" | sed '$d')

if [ "$HTTP_CODE" -eq 200 ]; then
    echo -e "${GREEN}✅ Succès (HTTP $HTTP_CODE)${NC}"
    NB_CHAMBRES=$(echo "$BODY" | python3 -c "import sys, json; print(len(json.load(sys.stdin)))")
    echo "Nombre de chambres trouvées: $NB_CHAMBRES"
    echo "$BODY" | python3 -m json.tool | head -20
else
    echo -e "${RED}❌ Échec (HTTP $HTTP_CODE)${NC}"
fi
echo ""

# Test 3: POST /api/hotel/reservations
echo -e "${YELLOW}Test 3: POST /api/hotel/reservations${NC}"
RESPONSE=$(curl -s -w "\n%{http_code}" -X POST "$BASE_URL/reservations" \
  -H "Content-Type: application/json" \
  -d '{
    "chambreId": 1,
    "dateArrive": "2025-12-10",
    "dateDepart": "2025-12-15",
    "nomClient": "Test",
    "prenomClient": "User",
    "numeroCarteBancaire": "1234567890123456"
  }')
HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
BODY=$(echo "$RESPONSE" | sed '$d')

if [ "$HTTP_CODE" -eq 201 ]; then
    echo -e "${GREEN}✅ Succès (HTTP $HTTP_CODE)${NC}"
    echo "$BODY" | python3 -m json.tool
else
    echo -e "${RED}❌ Échec (HTTP $HTTP_CODE)${NC}"
fi
echo ""

# Test 4: GET /api/hotel/reservations
echo -e "${YELLOW}Test 4: GET /api/hotel/reservations${NC}"
RESPONSE=$(curl -s -w "\n%{http_code}" "$BASE_URL/reservations")
HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
BODY=$(echo "$RESPONSE" | sed '$d')

if [ "$HTTP_CODE" -eq 200 ]; then
    echo -e "${GREEN}✅ Succès (HTTP $HTTP_CODE)${NC}"
    NB_RESERVATIONS=$(echo "$BODY" | python3 -c "import sys, json; print(len(json.load(sys.stdin)))")
    echo "Nombre de réservations: $NB_RESERVATIONS"
else
    echo -e "${RED}❌ Échec (HTTP $HTTP_CODE)${NC}"
fi
echo ""

# Test 5: GET /api/hotel/chambres/1
echo -e "${YELLOW}Test 5: GET /api/hotel/chambres/1${NC}"
RESPONSE=$(curl -s -w "\n%{http_code}" "$BASE_URL/chambres/1")
HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
BODY=$(echo "$RESPONSE" | sed '$d')

if [ "$HTTP_CODE" -eq 200 ]; then
    echo -e "${GREEN}✅ Succès (HTTP $HTTP_CODE)${NC}"
    echo "$BODY" | python3 -m json.tool
else
    echo -e "${RED}❌ Échec (HTTP $HTTP_CODE)${NC}"
fi
echo ""

# Test 6: Swagger UI
echo -e "${YELLOW}Test 6: Swagger UI${NC}"
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" "http://localhost:$PORT/swagger-ui/index.html")

if [ "$HTTP_CODE" -eq 200 ]; then
    echo -e "${GREEN}✅ Swagger UI accessible (HTTP $HTTP_CODE)${NC}"
    echo "URL: http://localhost:$PORT/swagger-ui/index.html"
else
    echo -e "${RED}❌ Swagger UI non accessible (HTTP $HTTP_CODE)${NC}"
fi
echo ""

echo "======================================"
echo "🎉 Tests terminés"
echo "======================================"

