#!/bin/bash

# Script de lancement de l'interface graphique Swing
# Force le mode non-headless

echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║                                                               ║"
echo "║     LANCEMENT INTERFACE GRAPHIQUE SWING                       ║"
echo "║                                                               ║"
echo "╚═══════════════════════════════════════════════════════════════╝"
echo ""

cd "$(dirname "$0")/Client"

echo "🚀 Lancement du client avec interface Swing..."
echo ""

# Lancer avec l'argument pour forcer la GUI
MAVEN_OPTS="-Djava.awt.headless=false" mvn spring-boot:run -Dspring-boot.run.arguments="--gui" -Dspring-boot.run.jvmArguments="-Djava.awt.headless=false"

echo ""
echo "═══════════════════════════════════════════════════════════════"
echo "   Application fermée"
echo "═══════════════════════════════════════════════════════════════"

