#!/bin/bash

# Script pour démarrer le système complet avec 2 agences
# Architecture:
# - 3 Hôtels: Paris (8082), Lyon (8083), Montpellier (8084)
# - 2 Agences: Agence1 (8081) connectée à Paris+Lyon, Agence2 (8085) connectée à Lyon+Montpellier
# - 1 Client qui agrège les 2 agences

echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║   DÉMARRAGE DU SYSTÈME DE RÉSERVATION - MULTI-AGENCES        ║"
echo "╚═══════════════════════════════════════════════════════════════╝"
echo ""

# Créer le dossier logs s'il n'existe pas
mkdir -p logs

# Étape 1: Démarrer les 3 hôtels
echo "═══ ÉTAPE 1/4: Démarrage des Hôtels ═══"
./start-hotels.sh

# Étape 2: Démarrer l'Agence 1
echo ""
echo "═══ ÉTAPE 2/4: Démarrage de l'Agence 1 ═══"
./start-agence1.sh
sleep 3

# Étape 3: Démarrer l'Agence 2
echo ""
echo "═══ ÉTAPE 3/4: Démarrage de l'Agence 2 ═══"
./start-agence2.sh
sleep 3

# Étape 4: Démarrer le Client
echo ""
echo "═══ ÉTAPE 4/4: Démarrage du Client ═══"
cd Client
./start-client.sh

echo ""
echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║   ✅ SYSTÈME DÉMARRÉ AVEC SUCCÈS                              ║"
echo "╚═══════════════════════════════════════════════════════════════╝"
echo ""
echo "📊 ARCHITECTURE:"
echo "   🏨 Hôtels:"
echo "      - Paris       : http://localhost:8082"
echo "      - Lyon        : http://localhost:8083"
echo "      - Montpellier : http://localhost:8084"
echo ""
echo "   🏢 Agences:"
echo "      - Agence 1 (Paris Voyages)      : http://localhost:8081 (coef: 1.15)"
echo "        └─ Hôtels: Paris, Lyon"
echo "      - Agence 2 (Sud Réservations)   : http://localhost:8085 (coef: 1.20)"
echo "        └─ Hôtels: Lyon, Montpellier"
echo ""
echo "   💻 Client: Connecté aux 2 agences"
echo ""
echo "📝 Logs disponibles dans le dossier: logs/"
echo ""
echo "🛑 Pour arrêter tous les services:"
echo "   pkill -f 'java.*Hotellerie'"
echo "   pkill -f 'java.*Agence'"
echo ""

