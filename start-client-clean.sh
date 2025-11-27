#!/bin/bash

echo "═══════════════════════════════════════════════════════════════"
echo "  Lancement du Client GUI (sans warnings AWT)"
echo "═══════════════════════════════════════════════════════════════"
echo ""

cd /home/corentinfay/Bureau/RestRepo/Client

# Lancer avec suppression des warnings sun.awt
mvn spring-boot:run 2>&1 | grep -v "sun.awt.X11" | grep -v "Nonexistent button"

