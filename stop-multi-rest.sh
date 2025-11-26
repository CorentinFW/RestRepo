#!/bin/bash

# Script d'arrêt complet du système Multi-Agences REST

echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║                                                               ║"
echo "║      ARRÊT DU SYSTÈME DE RÉSERVATION MULTI-AGENCES REST      ║"
echo "║                                                               ║"
echo "╚═══════════════════════════════════════════════════════════════╝"
echo ""

echo "🛑 Arrêt des services en cours..."
echo ""

# Arrêter le client
echo "💻 Arrêt du Client..."
pkill -f 'ClientApplication' 2>/dev/null && echo "   ✓ Client arrêté" || echo "   ○ Client non actif"

# Arrêter les agences
echo "🏢 Arrêt des Agences..."
pkill -f 'java.*Agence.*8081' 2>/dev/null && echo "   ✓ Agence 1 arrêtée" || echo "   ○ Agence 1 non active"
pkill -f 'java.*Agence.*8085' 2>/dev/null && echo "   ✓ Agence 2 arrêtée" || echo "   ○ Agence 2 non active"

# Arrêter les hôtels
echo "🏨 Arrêt des Hôtels..."
pkill -f 'Hotellerie.*paris' 2>/dev/null && echo "   ✓ Hôtel Paris arrêté" || echo "   ○ Hôtel Paris non actif"
pkill -f 'Hotellerie.*lyon' 2>/dev/null && echo "   ✓ Hôtel Lyon arrêté" || echo "   ○ Hôtel Lyon non actif"
pkill -f 'Hotellerie.*montpellier' 2>/dev/null && echo "   ✓ Hôtel Montpellier arrêté" || echo "   ○ Hôtel Montpellier non actif"

sleep 2

echo ""
echo "✅ Tous les services ont été arrêtés"
echo ""
echo "📝 Les logs sont conservés dans: logs/"
echo ""

