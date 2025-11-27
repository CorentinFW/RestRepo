#!/bin/bash

echo "═══════════════════════════════════════════════════════════════"
echo "  Correction de la compilation Hotellerie"
echo "═══════════════════════════════════════════════════════════════"
echo ""

cd /home/corentinfay/Bureau/RestRepo/Hotellerie

# 1. Sauvegarder l'ancien fichier
echo "1. Sauvegarde du fichier..."
cp src/main/java/org/tp1/hotellerie/service/HotelService.java \
   src/main/java/org/tp1/hotellerie/service/HotelService.java.old

# 2. Supprimer toutes les lignes vides en fin de fichier
echo "2. Nettoyage du fichier..."
# Utiliser awk pour supprimer les lignes vides en fin
awk 'NF > 0 {p=1} p' src/main/java/org/tp1/hotellerie/service/HotelService.java > /tmp/HotelService_temp.java

# Ajouter une seule ligne vide à la fin
echo "" >> /tmp/HotelService_temp.java

# Remplacer le fichier
mv /tmp/HotelService_temp.java src/main/java/org/tp1/hotellerie/service/HotelService.java

echo "   Fichier nettoyé : $(wc -l src/main/java/org/tp1/hotellerie/service/HotelService.java | cut -d' ' -f1) lignes"

# 3. Nettoyer le cache Maven
echo ""
echo "3. Nettoyage du cache Maven..."
rm -rf target/
mvn clean -q

# 4. Compiler
echo ""
echo "4. Compilation..."
mvn compile -DskipTests -q

if [ $? -eq 0 ]; then
    echo ""
    echo "═══════════════════════════════════════════════════════════════"
    echo "  ✅ COMPILATION RÉUSSIE"
    echo "═══════════════════════════════════════════════════════════════"
    echo ""

    # 5. Installer
    echo "5. Installation du JAR..."
    mvn install -DskipTests -q

    if [ $? -eq 0 ]; then
        echo "   ✅ JAR installé : target/Hotellerie-0.0.1-SNAPSHOT.jar"
        echo ""
        echo "Vous pouvez maintenant lancer :"
        echo "  cd .."
        echo "  ./rest-persistant.sh"
    else
        echo "   ✗ Erreur lors de l'installation"
        exit 1
    fi
else
    echo ""
    echo "═══════════════════════════════════════════════════════════════"
    echo "  ❌ COMPILATION ÉCHOUÉE"
    echo "═══════════════════════════════════════════════════════════════"
    echo ""
    echo "Erreurs détaillées :"
    mvn compile -DskipTests 2>&1 | grep -A 2 "ERROR"
    exit 1
fi

