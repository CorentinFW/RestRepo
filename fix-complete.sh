#!/bin/bash

echo "═══════════════════════════════════════════════════════════════"
echo "  Correction complète - Recréation des fichiers properties"
echo "═══════════════════════════════════════════════════════════════"
echo ""

cd /home/corentinfay/Bureau/RestRepo

# Arrêter les services
echo "1. Arrêt des services..."
./arreter-services.sh 2>/dev/null
pkill -f "Hotellerie" 2>/dev/null
sleep 2

# Sauvegarder les anciens fichiers
echo ""
echo "2. Sauvegarde des anciens fichiers properties..."
mkdir -p Hotellerie/src/main/resources/backup
cp Hotellerie/src/main/resources/application*.properties Hotellerie/src/main/resources/backup/ 2>/dev/null

# Recréer application-paris.properties
echo ""
echo "3. Recréation des fichiers properties..."
cat > Hotellerie/src/main/resources/application-paris.properties << 'EOFPARIS'
server.port=8082
spring.application.name=Hotellerie-Paris

# Informations de l'hotel Paris
hotel.ville=Paris
hotel.nom=Grand Hotel Paris
hotel.adresse=10 Rue de la Paix, Paris
hotel.categorie=CAT5

# Base de donnees H2 specifique a Paris
spring.datasource.url=jdbc:h2:file:./data/hotellerie-paris-db
spring.datasource.driverClassName=org.h2.Driver
spring.datasource.username=sa
spring.datasource.password=
EOFPARIS
echo "  ✓ application-paris.properties"

# Recréer application-lyon.properties
cat > Hotellerie/src/main/resources/application-lyon.properties << 'EOFLYON'
server.port=8083
spring.application.name=Hotellerie-Lyon

# Informations de l'hotel Lyon
hotel.ville=Lyon
hotel.nom=Hotel Lyon Centre
hotel.adresse=25 Place Bellecour, Lyon
hotel.categorie=CAT4

# Base de donnees H2 specifique a Lyon
spring.datasource.url=jdbc:h2:file:./data/hotellerie-lyon-db
spring.datasource.driverClassName=org.h2.Driver
spring.datasource.username=sa
spring.datasource.password=
EOFLYON
echo "  ✓ application-lyon.properties"

# Recréer application-montpellier.properties
cat > Hotellerie/src/main/resources/application-montpellier.properties << 'EOFMONT'
server.port=8084
spring.application.name=Hotellerie-Montpellier

# Informations de l'hotel Montpellier
hotel.ville=Montpellier
hotel.nom=Hotel Mediterranee
hotel.adresse=15 Rue de la Loge, Montpellier
hotel.categorie=CAT3

# Base de donnees H2 specifique a Montpellier
spring.datasource.url=jdbc:h2:file:./data/hotellerie-montpellier-db
spring.datasource.driverClassName=org.h2.Driver
spring.datasource.username=sa
spring.datasource.password=
EOFMONT
echo "  ✓ application-montpellier.properties"

# Nettoyer application.properties
cat > Hotellerie/src/main/resources/application.properties << 'EOFMAIN'
server.port=8082
spring.application.name=Hotellerie

# Configuration REST API
spring.mvc.pathmatch.matching-strategy=ant_path_matcher

# Configuration Jackson (JSON)
spring.jackson.serialization.indent-output=true
spring.jackson.serialization.write-dates-as-timestamps=false

# Configuration Swagger/OpenAPI
springdoc.api-docs.path=/api-docs
springdoc.swagger-ui.path=/swagger-ui.html

# Configuration H2 Database (commune)
spring.datasource.driverClassName=org.h2.Driver
spring.datasource.username=sa
spring.datasource.password=

# Configuration JPA/Hibernate
spring.jpa.database-platform=org.hibernate.dialect.H2Dialect
spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=true
spring.jpa.properties.hibernate.format_sql=true

# Console H2
spring.h2.console.enabled=true
spring.h2.console.path=/h2-console
EOFMAIN
echo "  ✓ application.properties"

# Supprimer anciennes bases
echo ""
echo "4. Suppression des anciennes bases..."
rm -rf Hotellerie/data/*.db Hotellerie/data/*.log 2>/dev/null
echo "  ✓ Bases supprimées"

# Compilation
echo ""
echo "5. Compilation..."
cd Hotellerie
mvn clean install -DskipTests -q

if [ $? -eq 0 ]; then
    echo "  ✅ BUILD SUCCESS"
    cd ..

    echo ""
    echo "6. Redémarrage des services..."
    ./start-system-maven.sh

    echo ""
    echo "═══════════════════════════════════════════════════════════════"
    echo "  ✅ Correction appliquée avec succès !"
    echo "═══════════════════════════════════════════════════════════════"
    echo ""
    echo "Bases de données créées :"
    echo "  • Paris      → ./data/hotellerie-paris-db"
    echo "  • Lyon       → ./data/hotellerie-lyon-db"
    echo "  • Montpellier → ./data/hotellerie-montpellier-db"
    echo ""
    echo "Pour lancer le client :"
    echo "  cd Client"
    echo "  mvn spring-boot:run"
    echo ""
else
    echo "  ❌ BUILD FAILURE"
    cd ..
    echo ""
    echo "Vérifiez les logs dans : Hotellerie/target/maven-*.log"
    echo "Ou relancez avec : cd Hotellerie && mvn clean install -DskipTests"
    exit 1
fi

