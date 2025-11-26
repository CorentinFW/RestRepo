#!/bin/bash

# Démarrer l'Agence 1 (Paris Voyages)

echo "🚀 Démarrage de l'Agence 1 (Paris Voyages) sur le port 8081..."

cd "$(dirname "$0")/Agence"

# Compiler le projet si nécessaire
if [ ! -f "target/Agence-0.0.1-SNAPSHOT.jar" ]; then
    echo "📦 Compilation du projet Agence..."
    mvn clean package -DskipTests
fi

# Démarrer avec le profil agence1
java -jar target/Agence-0.0.1-SNAPSHOT.jar --spring.profiles.active=agence1 > ../logs/agence.log 2>&1 &
AGENCE1_PID=$!

echo "✅ Agence 1 démarrée (PID: $AGENCE1_PID)"
echo "   Nom: Agence Paris Voyages"
echo "   Port: 8081"
echo "   Coefficient: 1.15"
echo "   Hôtels: Paris, Lyon"
echo "   Logs: logs/agence.log"
echo ""
