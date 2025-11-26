#!/bin/bash

# Script de compilation de tous les modules

echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║                                                               ║"
echo "║     COMPILATION DE TOUS LES MODULES                          ║"
echo "║                                                               ║"
echo "╚═══════════════════════════════════════════════════════════════╝"
echo ""

cd "$(dirname "$0")"

# Fonction pour compiler un module
compile_module() {
    local module=$1
    echo "═══════════════════════════════════════════════════════════════"
    echo "   Compilation: $module"
    echo "═══════════════════════════════════════════════════════════════"
    echo ""

    cd "$module"
    mvn clean package -DskipTests

    if [ $? -eq 0 ]; then
        echo ""
        echo "✅ $module compilé avec succès"
        echo ""
    else
        echo ""
        echo "❌ Erreur lors de la compilation de $module"
        echo ""
        exit 1
    fi

    cd ..
}

# Compiler dans l'ordre
compile_module "Hotellerie"
compile_module "Agence"
compile_module "Client"

echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║                                                               ║"
echo "║     ✅ TOUS LES MODULES SONT COMPILÉS                         ║"
echo "║                                                               ║"
echo "╚═══════════════════════════════════════════════════════════════╝"
echo ""
echo "Vous pouvez maintenant lancer:"
echo "   ./start-system-complete-gui.sh"
echo ""

