#!/bin/bash

# Démarrer l'Agence 2 (Sud Réservations)
echo "🚀 Démarrage de l'Agence 2 (Sud Réservations) sur le port 8085..."

cd "$(dirname "$0")/Agence"

# Compiler le projet si nécessaire
if [ ! -f "target/Agence-0.0.1-SNAPSHOT.jar" ]; then
    echo "📦 Compilation du projet Agence..."
    mvn clean package -DskipTests
fi

# Démarrer avec le profil agence2
java -jar target/Agence-0.0.1-SNAPSHOT.jar --spring.profiles.active=agence2 > ../logs/agence2.log 2>&1 &
AGENCE2_PID=$!

echo "✅ Agence 2 démarrée (PID: $AGENCE2_PID)"
echo "   Nom: Agence Sud Réservations"
echo "   Port: 8085"
echo "   Coefficient: 1.20"
echo "   Hôtels: Lyon, Montpellier"
echo "   Logs: logs/agence2.log"
echo ""

