#!/bin/bash

echo "════════════════════════════════════════════════════════════"
echo "   TEST DE CONFIGURATION DES AGENCES"
echo "════════════════════════════════════════════════════════════"
echo ""

# Attendre que les services soient prêts
echo "⏳ Attente du démarrage complet des services (45 secondes)..."
sleep 45

echo ""
echo "═══ TEST AGENCE 1 (Paris Voyages) ═══"
echo "Doit être connectée à: Paris + Lyon UNIQUEMENT"
echo ""

RESULT1=$(curl -s -X POST http://localhost:8081/api/agence/chambres/rechercher \
  -H "Content-Type: application/json" \
  -d '{"dateArrive":"2025-12-01","dateDepart":"2025-12-05"}' 2>/dev/null)

if [ -z "$RESULT1" ]; then
    echo "❌ ERREUR: Agence 1 ne répond pas"
else
    HOTELS1=$(echo "$RESULT1" | grep -o '"hotelNom":"[^"]*"' | sort -u | sed 's/"hotelNom":"/  - /g' | sed 's/"//g')
    COUNT1=$(echo "$RESULT1" | grep -o '"id":[0-9]*' | wc -l)

    echo "✅ Agence 1 répond"
    echo "📊 Nombre de chambres: $COUNT1"
    echo "🏨 Hôtels connectés:"
    echo "$HOTELS1"

    if echo "$HOTELS1" | grep -q "Paris" && echo "$HOTELS1" | grep -q "Lyon" && ! echo "$HOTELS1" | grep -q "Montpellier"; then
        echo "✅ CONFIGURATION CORRECTE: Paris + Lyon uniquement"
    else
        echo "❌ CONFIGURATION INCORRECTE"
    fi
fi

echo ""
echo "═══ TEST AGENCE 2 (Sud Réservations) ═══"
echo "Doit être connectée à: Montpellier + Lyon UNIQUEMENT"
echo ""

RESULT2=$(curl -s -X POST http://localhost:8085/api/agence/chambres/rechercher \
  -H "Content-Type: application/json" \
  -d '{"dateArrive":"2025-12-01","dateDepart":"2025-12-05"}' 2>/dev/null)

if [ -z "$RESULT2" ]; then
    echo "❌ ERREUR: Agence 2 ne répond pas"
else
    HOTELS2=$(echo "$RESULT2" | grep -o '"hotelNom":"[^"]*"' | sort -u | sed 's/"hotelNom":"/  - /g' | sed 's/"//g')
    COUNT2=$(echo "$RESULT2" | grep -o '"id":[0-9]*' | wc -l)

    echo "✅ Agence 2 répond"
    echo "📊 Nombre de chambres: $COUNT2"
    echo "🏨 Hôtels connectés:"
    echo "$HOTELS2"

    if echo "$HOTELS2" | grep -q "Montpellier" && echo "$HOTELS2" | grep -q "Lyon" && ! echo "$HOTELS2" | grep -q "Grand Hotel Paris"; then
        echo "✅ CONFIGURATION CORRECTE: Montpellier + Lyon uniquement"
    else
        echo "❌ CONFIGURATION INCORRECTE"
    fi
fi

echo ""
echo "════════════════════════════════════════════════════════════"
echo "   RÉSUMÉ"
echo "════════════════════════════════════════════════════════════"
echo ""
echo "Agence 1 (Paris Voyages)  → Paris + Lyon"
echo "Agence 2 (Sud Réservations) → Montpellier + Lyon"
echo ""
echo "Hôtel partagé: Lyon (visible dans les 2 agences)"
echo ""

