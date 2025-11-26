#!/bin/bash

# Script pour lancer le client en mode GUI avec X11

echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║                                                               ║"
echo "║     LANCEMENT CLIENT GUI - Configuration X11                 ║"
echo "║                                                               ║"
echo "╚═══════════════════════════════════════════════════════════════╝"
echo ""

# Étape 1 : Vérifier si X11 est installé
if ! command -v X &> /dev/null && ! command -v Xorg &> /dev/null; then
    echo "❌ ERREUR: X11/Xorg n'est pas installé"
    echo ""
    echo "Installation:"
    echo "  sudo apt install xorg"
    echo ""
    exit 1
fi

echo "✓ X11/Xorg installé"
echo ""

# Étape 2 : Configurer DISPLAY
if [ -z "$DISPLAY" ]; then
    echo "⚙️  Configuration de DISPLAY..."
    export DISPLAY=:0
    echo "   DISPLAY=$DISPLAY"
else
    echo "✓ DISPLAY déjà défini: $DISPLAY"
fi
echo ""

# Étape 3 : Vérifier si un serveur X tourne
if ! xdpyinfo &>/dev/null; then
    echo "⚠️  Aucun serveur X actif"
    echo ""
    echo "╔═══════════════════════════════════════════════════════════════╗"
    echo "║  MÉTHODE 1 : Utiliser votre session graphique existante      ║"
    echo "╚═══════════════════════════════════════════════════════════════╝"
    echo ""
    echo "Si vous êtes déjà sur un bureau graphique (GNOME, KDE, XFCE...):"
    echo ""
    echo "1. Ouvrez un terminal dans votre environnement graphique"
    echo "2. Lancez directement:"
    echo "   cd /home/corentinfay/Bureau/RestRepo/Client"
    echo "   mvn spring-boot:run -Dspring-boot.run.arguments=\"--gui\""
    echo ""
    echo "╔═══════════════════════════════════════════════════════════════╗"
    echo "║  MÉTHODE 2 : Démarrer un serveur X (Avancé)                  ║"
    echo "╚═══════════════════════════════════════════════════════════════╝"
    echo ""
    echo "Si vous êtes en mode texte (TTY), vous pouvez démarrer X11:"
    echo ""
    echo "Option A - Démarrer votre gestionnaire de bureau:"
    echo "   sudo systemctl start gdm3        # Pour GNOME"
    echo "   sudo systemctl start lightdm     # Pour XFCE/LXDE"
    echo "   sudo systemctl start sddm        # Pour KDE"
    echo ""
    echo "Option B - Démarrer X11 minimal (terminal graphique):"
    echo "   startx"
    echo ""
    echo "╔═══════════════════════════════════════════════════════════════╗"
    echo "║  MÉTHODE 3 : Utiliser le mode CLI (Recommandé)               ║"
    echo "╚═══════════════════════════════════════════════════════════════╝"
    echo ""
    echo "Le mode CLI fonctionne sans interface graphique et offre"
    echo "TOUTES les mêmes fonctionnalités que la GUI !"
    echo ""
    echo "Pour lancer en mode CLI:"
    echo "   cd /home/corentinfay/Bureau/RestRepo"
    echo "   ./start-multi-rest.sh"
    echo ""
    echo "Ou forcer le CLI:"
    echo "   cd /home/corentinfay/Bureau/RestRepo/Client"
    echo "   mvn spring-boot:run -Dspring-boot.run.arguments=\"--cli\""
    echo ""
    exit 1
fi

# Si on arrive ici, X11 est disponible
echo "✓ Serveur X actif et accessible"
echo ""

# Étape 4 : Lancer le client en mode GUI
echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║  LANCEMENT DE L'INTERFACE GRAPHIQUE                          ║"
echo "╚═══════════════════════════════════════════════════════════════╝"
echo ""

cd "$(dirname "$0")/Client"

echo "🚀 Démarrage du client en mode GUI..."
echo ""

# Forcer le mode GUI
mvn spring-boot:run -Dspring-boot.run.arguments="--gui"

echo ""
echo "═══════════════════════════════════════════════════════════════"
echo "   Client GUI fermé"
echo "═══════════════════════════════════════════════════════════════"

