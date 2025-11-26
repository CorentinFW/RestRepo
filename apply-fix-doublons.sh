#!/bin/bash

# Script pour appliquer le correctif des doublons de réservations

echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║                                                               ║"
echo "║     APPLICATION DU CORRECTIF - DOUBLONS DE RÉSERVATIONS      ║"
echo "║                                                               ║"
echo "╚═══════════════════════════════════════════════════════════════╝"
echo ""

echo "📋 Correctif appliqué :"
echo "   - Déduplication des réservations de chambres"
echo "   - Fini les doublons pour les chambres de Lyon"
echo ""

echo "═══════════════════════════════════════════════════════════════"
echo "   ÉTAPE 1/3 : Arrêt des services en cours"
echo "═══════════════════════════════════════════════════════════════"
echo ""

pkill -f 'ClientApplication' 2>/dev/null && echo "✓ Client arrêté" || echo "○ Client non actif"
sleep 2

echo ""
echo "═══════════════════════════════════════════════════════════════"
echo "   ÉTAPE 2/3 : Recompilation du module Client"
echo "═══════════════════════════════════════════════════════════════"
echo ""

cd "$(dirname "$0")/Client"
echo "📦 Compilation en cours..."
mvn clean package -DskipTests > /tmp/client-compile.log 2>&1

if [ $? -eq 0 ]; then
    echo "✅ Compilation réussie"
else
    echo "❌ Erreur de compilation"
    echo "   Voir les détails : /tmp/client-compile.log"
    exit 1
fi

echo ""
echo "═══════════════════════════════════════════════════════════════"
echo "   ÉTAPE 3/3 : Redémarrage du système"
echo "═══════════════════════════════════════════════════════════════"
echo ""

cd ..
./start-multi-rest.sh

echo ""
echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║                                                               ║"
echo "║     ✅ CORRECTIF APPLIQUÉ AVEC SUCCÈS                         ║"
echo "║                                                               ║"
echo "╚═══════════════════════════════════════════════════════════════╝"
echo ""
echo "🧪 Pour tester :"
echo "   1. Option 1 : Rechercher des chambres Lyon"
echo "   2. Option 2 : Réserver une chambre Lyon"
echo "   3. Option 5 : Afficher les réservations"
echo "   4. Vérifier : La chambre n'apparaît qu'UNE SEULE fois ✅"
echo ""
echo "📝 Voir FIX-DOUBLONS-RESERVATIONS.md pour plus de détails"
echo ""

