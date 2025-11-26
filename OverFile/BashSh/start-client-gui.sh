#!/bin/bash

# Script pour lancer le client GUI en mode graphique local

echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║                                                               ║"
echo "║     LANCEMENT CLIENT GUI - MODE GRAPHIQUE                     ║"
echo "║                                                               ║"
echo "╚═══════════════════════════════════════════════════════════════╝"
echo ""

# Vérifier si DISPLAY est défini
if [ -z "$DISPLAY" ]; then
    echo "⚠️  Variable DISPLAY non définie"
    echo "   Tentative de configuration automatique..."
    export DISPLAY=:0
    echo "   DISPLAY=$DISPLAY"
    echo ""
fi

# Vérifier la disponibilité de X11
if ! xdpyinfo &>/dev/null; then
    echo "❌ ERREUR: Aucun serveur X11 disponible"
    echo ""
    echo "Solutions possibles:"
    echo "  1. Si vous êtes en SSH, utilisez 'ssh -X' pour activer X11 forwarding"
    echo "  2. Si vous êtes sur votre machine locale, assurez-vous qu'un serveur X est actif"
    echo "  3. Utilisez le mode CLI au lieu de GUI (voir ci-dessous)"
    echo ""
    echo "Pour revenir au CLI:"
    echo "  - Modifier Client/src/main/java/org/tp1/client/ClientApplication.java"
    echo "  - Remplacer ClientGUI par ClientCLIRest"
    echo "  - Recompiler avec: cd Client && mvn clean package -DskipTests"
    echo ""
    exit 1
fi

echo "✓ Serveur X11 détecté"
echo ""

cd "$(dirname "$0")/Client"

echo "🚀 Lancement du client GUI..."
echo ""

mvn spring-boot:run

echo ""
echo "═══════════════════════════════════════════════════════════════"
echo "   Client GUI fermé"
echo "═══════════════════════════════════════════════════════════════"

