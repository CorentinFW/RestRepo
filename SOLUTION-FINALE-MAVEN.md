# 🔧 SOLUTION FINALE - Erreur Maven "Input length = 1"

## 🎯 Problème

L'erreur `Input length = 1` persiste malgré les corrections précédentes. Cela indique un problème d'encodage plus profond dans les fichiers `.properties`.

## ✅ Solution définitive

### Script de correction complet

Un nouveau script **`fix-complete.sh`** a été créé qui :

1. ✅ Arrête tous les services
2. ✅ Sauvegarde les anciens fichiers
3. ✅ **Recrée complètement** les 4 fichiers `.properties` avec un encodage propre
4. ✅ Supprime les anciennes bases de données
5. ✅ Compile le projet
6. ✅ Redémarre tous les services

### Commande à exécuter

```bash
cd /home/corentinfay/Bureau/RestRepo
./fix-complete.sh
```

Ce script **RECRÉE** tous les fichiers properties depuis zéro avec la commande `cat`, garantissant un encodage ASCII propre.

---

## 📝 Contenu des fichiers recréés

### `application-paris.properties`
```properties
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
```

### `application-lyon.properties`
```properties
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
```

### `application-montpellier.properties`
```properties
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
```

### `application.properties` (fichier commun - nettoyé)
```properties
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
```

---

## 🚀 Utilisation

### Étape 1 : Lancer le script de correction

```bash
cd /home/corentinfay/Bureau/RestRepo
./fix-complete.sh
```

**Le script va** :
- Recréer tous les fichiers `.properties` avec un encodage propre
- Compiler le projet (devrait réussir maintenant)
- Démarrer les 3 hôtels + 2 agences

### Étape 2 : Attendre le démarrage

Attendez environ **30-45 secondes** que tous les services démarrent.

### Étape 3 : Lancer le client

Dans un **nouveau terminal** :
```bash
cd /home/corentinfay/Bureau/RestRepo/Client
mvn spring-boot:run
```

### Étape 4 : Tester

1. **Rechercher** à Lyon (25 Place Bellecour)
2. Dates : 01/12/2025 → 05/12/2025
3. **Résultat attendu** : 5 chambres trouvées ✅
4. **Réserver** une chambre
5. **Résultat attendu** : "Réservation effectuée avec succès !" ✅

---

## 🔍 Vérification

### Vérifier les bases de données

```bash
ls -lh /home/corentinfay/Bureau/RestRepo/Hotellerie/data/
```

**Vous devriez voir** :
```
hotellerie-paris-db.mv.db
hotellerie-lyon-db.mv.db
hotellerie-montpellier-db.mv.db
```

### Consoles H2

- **Paris** : http://localhost:8082/h2-console
  - JDBC : `jdbc:h2:file:./data/hotellerie-paris-db`
  - SQL : `SELECT * FROM hotels;` → "Grand Hotel Paris"

- **Lyon** : http://localhost:8083/h2-console
  - JDBC : `jdbc:h2:file:./data/hotellerie-lyon-db`
  - SQL : `SELECT * FROM hotels;` → "Hotel Lyon Centre"

- **Montpellier** : http://localhost:8084/h2-console
  - JDBC : `jdbc:h2:file:./data/hotellerie-montpellier-db`
  - SQL : `SELECT * FROM hotels;` → "Hotel Mediterranee"

---

## 💡 Pourquoi cette solution fonctionne

### Problème original

Les fichiers `.properties` contenaient des caractères ou séquences d'octets invisibles qui causaient l'erreur `Input length = 1` lors de la phase `maven-resources-plugin`.

### Approche précédente

Modification des fichiers existants → Les caractères problématiques persistaient dans l'encodage.

### Nouvelle approche

**Recréation complète** des fichiers avec `cat` et heredoc (`<< 'EOF'`) :
- ✅ Encodage ASCII pur garanti
- ✅ Pas de caractères cachés
- ✅ Fin de fichier propre (un seul LF)

---

## 📊 Récapitulatif des corrections

| Problème | Solution | Script | Statut |
|----------|----------|--------|--------|
| Erreur Maven "Input length = 1" | Recréation fichiers | `fix-complete.sh` | ✅ |
| Bases H2 partagées | Datasource séparée | `fix-complete.sh` | ✅ |
| Bug réservation | Recherche par ID | (déjà corrigé) | ✅ |

---

## 🎯 Si le problème persiste encore

### Option 1 : Compilation manuelle pour voir l'erreur

```bash
cd /home/corentinfay/Bureau/RestRepo/Hotellerie
mvn clean compile -DskipTests -e
```

Regardez attentivement le message d'erreur complet.

### Option 2 : Vérifier l'encodage

```bash
cd Hotellerie/src/main/resources
file -i application-paris.properties
```

**Résultat attendu** : `charset=us-ascii` ou `charset=utf-8`

### Option 3 : Recréer manuellement

Si vraiment ça bloque, supprimez et recréez un fichier à la fois :

```bash
cd Hotellerie/src/main/resources
rm application-paris.properties

cat > application-paris.properties << 'EOF'
server.port=8082
spring.application.name=Hotellerie-Paris
hotel.ville=Paris
hotel.nom=Grand Hotel Paris
hotel.adresse=10 Rue de la Paix, Paris
hotel.categorie=CAT5
spring.datasource.url=jdbc:h2:file:./data/hotellerie-paris-db
spring.datasource.driverClassName=org.h2.Driver
spring.datasource.username=sa
spring.datasource.password=
EOF

# Tester
cd ../../../..
mvn -f Hotellerie/pom.xml clean compile
```

---

## 🎉 Résumé

**Un seul script résout tout** :

```bash
./fix-complete.sh
```

**Puis dans un autre terminal** :
```bash
cd Client
mvn spring-boot:run
```

**Et testez vos réservations !** 🚀

---

*Solution finale créée le 27 novembre 2025*  
*Erreur : maven-resources-plugin Input length = 1*  
*Solution : Recréation complète des fichiers properties*  
*Script : fix-complete.sh*

