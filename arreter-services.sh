#!/bin/bash

# Script pour arrêter tous les services

echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║                                                               ║"
echo "║     ARRÊT DE TOUS LES SERVICES                               ║"
echo "║                                                               ║"
echo "╚═══════════════════════════════════════════════════════════════╝"
echo ""

echo "🛑 Arrêt des services Maven..."
echo ""

# Arrêter les processus Maven
pkill -f 'maven.*Hotellerie' && echo "✓ Hôtels Maven arrêtés" || echo "○ Aucun hôtel Maven actif"
pkill -f 'maven.*Agence' && echo "✓ Agences Maven arrêtées" || echo "○ Aucune agence Maven active"

# Arrêter aussi les processus JAR (au cas où)
pkill -f 'java.*jar.*Hotellerie' && echo "✓ Hôtels JAR arrêtés" || echo "○ Aucun hôtel JAR actif"
pkill -f 'java.*jar.*Agence' && echo "✓ Agences JAR arrêtées" || echo "○ Aucune agence JAR active"

echo ""
echo "⏳ Attente de l'arrêt complet (3 secondes)..."
sleep 3

echo ""
echo "🔍 Vérification des ports..."
echo ""

PORTS_USED=0

for port in 8081 8082 8083 8084 8085; do
    if lsof -i :$port >/dev/null 2>&1; then
        echo "⚠️  Port $port encore utilisé"
        PORTS_USED=1
    else
        echo "✓ Port $port libre"
    fi
done

echo ""

if [ $PORTS_USED -eq 1 ]; then
    echo "⚠️  Certains ports sont encore utilisés"
    echo "   Attendez quelques secondes ou forcez l'arrêt:"
    echo "   pkill -9 -f 'maven.*Hotellerie'"
    echo "   pkill -9 -f 'maven.*Agence'"
    echo ""
else
    echo "✅ TOUS LES SERVICES SONT ARRÊTÉS"
    echo ""
    echo "Vous pouvez maintenant relancer:"
    echo "   ./start-system-maven.sh"
    echo ""
fi

