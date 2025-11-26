#!/bin/bash

# Script de test simple pour démarrer UN service

cd "$(dirname "$0")"

echo "Test de démarrage de l'Hôtel Paris..."

mkdir -p logs

# Tester avec java -jar directement
java -jar Hotellerie/target/Hotellerie-0.0.1-SNAPSHOT.jar --spring.profiles.active=paris > logs/hotel-paris-test.log 2>&1 &

PID=$!
echo "PID: $PID"

sleep 5

if ps -p $PID > /dev/null; then
    echo "✅ Service démarré avec succès (PID: $PID)"
    echo "Logs:"
    tail -20 logs/hotel-paris-test.log
else
    echo "❌ Le service n'a pas démarré"
    echo "Logs:"
    cat logs/hotel-paris-test.log
fi

