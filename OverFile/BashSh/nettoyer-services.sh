#!/bin/bash

# Script pour nettoyer tous les services et libérer les ports

echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║                                                               ║"
echo "║     NETTOYAGE DE TOUS LES SERVICES                           ║"
echo "║                                                               ║"
echo "╚═══════════════════════════════════════════════════════════════╝"
echo ""

echo "🛑 Arrêt de tous les services Java..."
echo ""

# Arrêter tous les processus Java liés au projet
pkill -f 'java.*Hotellerie' 2>/dev/null && echo "✓ Services Hotellerie arrêtés" || echo "○ Aucun service Hotellerie actif"
pkill -f 'java.*Agence' 2>/dev/null && echo "✓ Services Agence arrêtés" || echo "○ Aucun service Agence actif"
pkill -f 'java.*Client' 2>/dev/null && echo "✓ Client arrêté" || echo "○ Aucun client actif"

echo ""
echo "⏳ Attente de libération des ports (3 secondes)..."
sleep 3

echo ""
echo "🔍 Vérification des ports..."
echo ""

# Vérifier les ports
PORTS_USED=0

for port in 8081 8082 8083 8084 8085; do
    if lsof -i :$port >/dev/null 2>&1; then
        echo "❌ Port $port encore utilisé par:"
        lsof -i :$port | tail -1
        PORTS_USED=1
    else
        echo "✓ Port $port libre"
    fi
done

echo ""

if [ $PORTS_USED -eq 1 ]; then
    echo "⚠️  ATTENTION : Certains ports sont encore utilisés"
    echo ""
    echo "Solutions:"
    echo "1. Attendre quelques secondes et relancer ce script"
    echo "2. Tuer manuellement les processus:"
    echo "   kill -9 <PID>"
    echo ""
    exit 1
else
    echo "✅ TOUS LES PORTS SONT LIBRES"
    echo ""
    echo "Vous pouvez maintenant démarrer les services:"
    echo "   ./afficher-commandes.sh"
    echo ""
fi

