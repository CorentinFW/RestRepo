#!/bin/bash

echo "════════════════════════════════════════════════════════════"
echo "   TEST FINAL - CONFIGURATION DES AGENCES"
echo "════════════════════════════════════════════════════════════"
echo ""

echo "⏳ Attente que les services soient complètement prêts (10 secondes)..."
sleep 10

echo ""
echo "═══ TEST AGENCE 1 (Paris Voyages - Port 8081) ═══"
echo ""

RESULT1=$(curl -s -X POST http://localhost:8081/api/agence/chambres/rechercher \
  -H "Content-Type: application/json" \
  -d '{"dateArrive":"2025-12-01","dateDepart":"2025-12-05"}')

if [ -z "$RESULT1" ]; then
    echo "❌ ERREUR: Agence 1 ne répond pas"
else
    echo "Réponse reçue de l'Agence 1"

    # Compter les chambres
    COUNT1=$(echo "$RESULT1" | grep -o '"id"' | wc -l)
    echo "📊 Nombre de chambres: $COUNT1"

    # Extraire les noms d'hôtels uniques
    echo "🏨 Hôtels dans la réponse:"
    echo "$RESULT1" | grep -o '"hotelNom":"[^"]*"' | sort -u | sed 's/"hotelNom":"/  ✓ /g' | sed 's/"//g'

    # Vérifier la configuration
    echo ""
    HAS_PARIS=$(echo "$RESULT1" | grep -c "Grand Hotel Paris" || echo "0")
    HAS_LYON=$(echo "$RESULT1" | grep -c "Hotel Lyon Centre" || echo "0")
    HAS_MONT=$(echo "$RESULT1" | grep -c "Hotel Mediterranee" || echo "0")

    if [ "$HAS_PARIS" -gt "0" ] && [ "$HAS_LYON" -gt "0" ] && [ "$HAS_MONT" -eq "0" ]; then
        echo "✅ ✅ ✅ CONFIGURATION CORRECTE: Paris + Lyon UNIQUEMENT"
        echo "   ✓ Paris trouvé"
        echo "   ✓ Lyon trouvé"
        echo "   ✓ Montpellier ABSENT (correct)"
    else
        echo "❌ CONFIGURATION INCORRECTE"
        echo "   Paris: $HAS_PARIS chambres"
        echo "   Lyon: $HAS_LYON chambres"
        echo "   Montpellier: $HAS_MONT chambres (devrait être 0)"
    fi
fi

echo ""
echo "═══ TEST AGENCE 2 (Sud Réservations - Port 8085) ═══"
echo ""

RESULT2=$(curl -s -X POST http://localhost:8085/api/agence/chambres/rechercher \
  -H "Content-Type: application/json" \
  -d '{"dateArrive":"2025-12-01","dateDepart":"2025-12-05"}')

if [ -z "$RESULT2" ]; then
    echo "❌ ERREUR: Agence 2 ne répond pas"
else
    echo "Réponse reçue de l'Agence 2"

    # Compter les chambres
    COUNT2=$(echo "$RESULT2" | grep -o '"id"' | wc -l)
    echo "📊 Nombre de chambres: $COUNT2"

    # Extraire les noms d'hôtels uniques
    echo "🏨 Hôtels dans la réponse:"
    echo "$RESULT2" | grep -o '"hotelNom":"[^"]*"' | sort -u | sed 's/"hotelNom":"/  ✓ /g' | sed 's/"//g'

    # Vérifier la configuration
    echo ""
    HAS_PARIS2=$(echo "$RESULT2" | grep -c "Grand Hotel Paris" || echo "0")
    HAS_LYON2=$(echo "$RESULT2" | grep -c "Hotel Lyon Centre" || echo "0")
    HAS_MONT2=$(echo "$RESULT2" | grep -c "Hotel Mediterranee" || echo "0")

    if [ "$HAS_LYON2" -gt "0" ] && [ "$HAS_MONT2" -gt "0" ] && [ "$HAS_PARIS2" -eq "0" ]; then
        echo "✅ ✅ ✅ CONFIGURATION CORRECTE: Lyon + Montpellier UNIQUEMENT"
        echo "   ✓ Lyon trouvé"
        echo "   ✓ Montpellier trouvé"
        echo "   ✓ Paris ABSENT (correct)"
    else
        echo "❌ CONFIGURATION INCORRECTE"
        echo "   Paris: $HAS_PARIS2 chambres (devrait être 0)"
        echo "   Lyon: $HAS_LYON2 chambres"
        echo "   Montpellier: $HAS_MONT2 chambres"
    fi
fi

echo ""
echo "════════════════════════════════════════════════════════════"
echo "   RÉSUMÉ FINAL"
echo "════════════════════════════════════════════════════════════"
echo ""
echo "Architecture attendue:"
echo "  🏢 Agence 1 (Paris Voyages)    → Paris + Lyon"
echo "  🏢 Agence 2 (Sud Réservations) → Lyon + Montpellier"
echo ""
echo "Hôtel partagé: Lyon (visible dans les 2 agences)"
echo ""
echo "Total chambres vues par le client: 20"
echo "  - 5 Paris (via Agence 1)"
echo "  - 10 Lyon (5 via Agence 1 + 5 via Agence 2)"
echo "  - 5 Montpellier (via Agence 2)"
echo ""

