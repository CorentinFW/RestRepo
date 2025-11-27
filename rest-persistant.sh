#!/bin/bash

echo "═══════════════════════════════════════════════════════════════"
echo "  Redémarrage avec persistance des données"
echo "═══════════════════════════════════════════════════════════════"
echo ""
echo "⚠️  Les bases de données H2 seront CONSERVÉES"
echo "    Les réservations existantes resteront en place"
echo ""

cd /home/corentinfay/Bureau/RestRepo

# Arrêter les services
echo "1. Arrêt des services..."
./arreter-services.sh 2>/dev/null
pkill -f "Hotellerie" 2>/dev/null
pkill -f "Agence" 2>/dev/null
sleep 3
echo "  ✓ Services arrêtés"

# Vérifier que les bases existent
echo ""
echo "2. Vérification des bases de données existantes..."
BASES_TROUVEES=0

if [ -f "Hotellerie/data/hotellerie-paris-db.mv.db" ]; then
    TAILLE_PARIS=$(du -h Hotellerie/data/hotellerie-paris-db.mv.db | cut -f1)
    echo "  ✓ Base Paris trouvée ($TAILLE_PARIS)"
    BASES_TROUVEES=$((BASES_TROUVEES + 1))
fi

if [ -f "Hotellerie/data/hotellerie-lyon-db.mv.db" ]; then
    TAILLE_LYON=$(du -h Hotellerie/data/hotellerie-lyon-db.mv.db | cut -f1)
    echo "  ✓ Base Lyon trouvée ($TAILLE_LYON)"
    BASES_TROUVEES=$((BASES_TROUVEES + 1))
fi

if [ -f "Hotellerie/data/hotellerie-montpellier-db.mv.db" ]; then
    TAILLE_MONT=$(du -h Hotellerie/data/hotellerie-montpellier-db.mv.db | cut -f1)
    echo "  ✓ Base Montpellier trouvée ($TAILLE_MONT)"
    BASES_TROUVEES=$((BASES_TROUVEES + 1))
fi

if [ $BASES_TROUVEES -eq 0 ]; then
    echo ""
    echo "⚠️  ATTENTION : Aucune base de données trouvée !"
    echo "    Première exécution ? Les bases seront créées."
    echo ""
elif [ $BASES_TROUVEES -lt 3 ]; then
    echo ""
    echo "⚠️  ATTENTION : Seulement $BASES_TROUVEES base(s) trouvée(s) sur 3"
    echo "    Les bases manquantes seront créées."
    echo ""
else
    echo ""
    echo "  ✅ Toutes les bases de données sont présentes"
    echo "     Les données seront rechargées au démarrage"
    echo ""
fi

# Recompilation (au cas où il y aurait eu des modifications)
echo "3. Recompilation des modules..."
echo "  → Hotellerie..."
cd Hotellerie
mvn clean package -DskipTests -q > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "    ✓ Hotellerie compilé"
else
    echo "    ✗ Erreur compilation Hotellerie"
    cd ..
    exit 1
fi
cd ..

echo "  → Agence..."
cd Agence
mvn clean package -DskipTests -q > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "    ✓ Agence compilé"
else
    echo "    ✗ Erreur compilation Agence"
    cd ..
    exit 1
fi
cd ..

# Redémarrage des services
echo ""
echo "4. Redémarrage des services..."
./OverFile/BashSh/start-system-maven.sh

echo ""
echo "═══════════════════════════════════════════════════════════════"
echo "  ✅ Services redémarrés avec données persistantes"
echo "═══════════════════════════════════════════════════════════════"
echo ""
echo "📊 État des bases de données :"
echo ""

# Afficher les statistiques des bases
if [ -f "Hotellerie/data/hotellerie-paris-db.mv.db" ]; then
    echo "  Paris (8082)      : $(du -h Hotellerie/data/hotellerie-paris-db.mv.db | cut -f1)"
    echo "    Console H2 : http://localhost:8082/h2-console"
    echo "    JDBC URL   : jdbc:h2:file:./data/hotellerie-paris-db"
fi

if [ -f "Hotellerie/data/hotellerie-lyon-db.mv.db" ]; then
    echo ""
    echo "  Lyon (8083)       : $(du -h Hotellerie/data/hotellerie-lyon-db.mv.db | cut -f1)"
    echo "    Console H2 : http://localhost:8083/h2-console"
    echo "    JDBC URL   : jdbc:h2:file:./data/hotellerie-lyon-db"
fi

if [ -f "Hotellerie/data/hotellerie-montpellier-db.mv.db" ]; then
    echo ""
    echo "  Montpellier (8084): $(du -h Hotellerie/data/hotellerie-montpellier-db.mv.db | cut -f1)"
    echo "    Console H2 : http://localhost:8084/h2-console"
    echo "    JDBC URL   : jdbc:h2:file:./data/hotellerie-montpellier-db"
fi

echo ""
echo "💡 Les réservations existantes ont été rechargées depuis la base"
echo ""
echo "Pour lancer le client :"
echo "  cd Client"
echo "  mvn spring-boot:run"
echo ""
echo "Pour voir les réservations existantes :"
echo "  Accédez à une console H2 et exécutez :"
echo "  SELECT * FROM reservations;"
echo ""

