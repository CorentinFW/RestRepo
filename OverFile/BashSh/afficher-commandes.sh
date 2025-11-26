#!/bin/bash

# Script qui affiche les commandes à exécuter dans 6 terminaux

cat << 'EOF'
╔═══════════════════════════════════════════════════════════════╗
║                                                               ║
║     DÉMARRAGE MANUEL - 6 TERMINAUX                           ║
║                                                               ║
╚═══════════════════════════════════════════════════════════════╝

⚠️  Le script automatique a des problèmes avec nohup/background.

✅  SOLUTION : Démarrer manuellement dans 6 terminaux séparés.

══════════════════════════════════════════════════════════════

📋  INSTRUCTIONS :

1. Ouvrez 6 terminaux (Ctrl+Alt+T × 6)
2. Copiez-collez les commandes ci-dessous dans chaque terminal
3. Attendez que chaque service affiche "Started..."
4. L'interface GUI s'ouvre dans le terminal 6

══════════════════════════════════════════════════════════════

🖥️  TERMINAL 1 : Hôtel Paris
══════════════════════════════════════════════════════════════
cd /home/corentinfay/Bureau/RestRepo/Hotellerie
java -jar target/Hotellerie-0.0.1-SNAPSHOT.jar --spring.profiles.active=paris

══════════════════════════════════════════════════════════════

🖥️  TERMINAL 2 : Hôtel Lyon
══════════════════════════════════════════════════════════════
cd /home/corentinfay/Bureau/RestRepo/Hotellerie
java -jar target/Hotellerie-0.0.1-SNAPSHOT.jar --spring.profiles.active=lyon

══════════════════════════════════════════════════════════════

🖥️  TERMINAL 3 : Hôtel Montpellier
══════════════════════════════════════════════════════════════
cd /home/corentinfay/Bureau/RestRepo/Hotellerie
java -jar target/Hotellerie-0.0.1-SNAPSHOT.jar --spring.profiles.active=montpellier

══════════════════════════════════════════════════════════════

🖥️  TERMINAL 4 : Agence 1 (Paris Voyages)
══════════════════════════════════════════════════════════════
cd /home/corentinfay/Bureau/RestRepo/Agence
java -jar target/Agence-0.0.1-SNAPSHOT.jar --spring.profiles.active=agence1

══════════════════════════════════════════════════════════════

🖥️  TERMINAL 5 : Agence 2 (Sud Réservations)
══════════════════════════════════════════════════════════════
cd /home/corentinfay/Bureau/RestRepo/Agence
java -jar target/Agence-0.0.1-SNAPSHOT.jar --spring.profiles.active=agence2

══════════════════════════════════════════════════════════════

🖥️  TERMINAL 6 : Client GUI (LANCER EN DERNIER !)
══════════════════════════════════════════════════════════════
⏳  ATTENDRE que les 5 autres terminaux affichent "Started..."
    Puis exécuter :

cd /home/corentinfay/Bureau/RestRepo/Client
java -Djava.awt.headless=false -jar target/Client-0.0.1-SNAPSHOT.jar --gui

══════════════════════════════════════════════════════════════

✅  RÉSULTAT : Une fenêtre graphique Swing s'ouvre !

🔍  TESTER : Recherchez "Lyon" → 10 chambres apparaissent !

══════════════════════════════════════════════════════════════

🛑  POUR ARRÊTER : Ctrl+C dans chaque terminal

EOF

