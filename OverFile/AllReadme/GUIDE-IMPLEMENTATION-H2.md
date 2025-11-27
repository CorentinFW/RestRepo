# Guide d'implémentation de la base de données H2

## ⚠️ CORRECTION CRITIQUE APPLIQUÉE (27/11/2025)

> **IMPORTANT** : Une erreur de configuration critique a été corrigée.  
> Tous les hôtels partageaient la même base de données !  
> Consultez `CORRECTION-CRITIQUE-H2.md` pour les détails.

## ✅ STATUT : Implémentation corrigée et testée

### Configuration H2 (CORRIGÉE)

Chaque hôtel a maintenant **sa propre base de données** :

- **Paris** : `./data/hotellerie-paris-db`
- **Lyon** : `./data/hotellerie-lyon-db`
- **Montpellier** : `./data/hotellerie-montpellier-db`

## 📋 Résumé des modifications

J'ai mis en place une base de données H2 pour sauvegarder les chambres et réservations de chaque hôtel avec persistance dans un fichier.

## 🔧 Modifications effectuées

### 1. **Dépendances Maven ajoutées** (`Hotellerie/pom.xml`)
- `h2` : Base de données H2
- `spring-boot-starter-data-jpa` : Spring Data JPA pour la persistance

### 2. **Configuration H2** (`Hotellerie/src/main/resources/application-*.properties`)

**Fichier commun** (`application.properties`) :
```properties
# Configuration JPA/Hibernate (commune à tous)
spring.jpa.database-platform=org.hibernate.dialect.H2Dialect
spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=true
spring.h2.console.enabled=true
spring.h2.console.path=/h2-console
```

**Par profil** (⚠️ CRITIQUE : Bases séparées !) :

`application-paris.properties` :
```properties
spring.datasource.url=jdbc:h2:file:./data/hotellerie-paris-db
spring.datasource.driverClassName=org.h2.Driver
spring.datasource.username=sa
spring.datasource.password=
```

`application-lyon.properties` :
```properties
spring.datasource.url=jdbc:h2:file:./data/hotellerie-lyon-db
spring.datasource.driverClassName=org.h2.Driver
spring.datasource.username=sa
spring.datasource.password=
```

`application-montpellier.properties` :
```properties
spring.datasource.url=jdbc:h2:file:./data/hotellerie-montpellier-db
spring.datasource.driverClassName=org.h2.Driver
spring.datasource.username=sa
spring.datasource.password=
```

### 3. **Entités JPA créées**

Toutes les classes du modèle ont été converties en entités JPA :

#### `Client.java`
- Table : `clients`
- Champs : `id` (Long, auto-généré), `nom`, `prenom`, `numero_carte_bleue`

#### `Hotel.java`
- Table : `hotels`
- Champs : `id` (Long, auto-généré), `nom`, `adresse`, `type` (enum)
- Relations : 
  - `@OneToMany` avec `Chambre`
  - `@OneToMany` avec `Reservation`

#### `Chambre.java`
- Table : `chambres`
- Champs : `id` (Long, auto-généré), `numero_chambre`, `nom`, `prix`, `nbr_de_lit`, `image_url`
- Relations :
  - `@ManyToOne` avec `Hotel`

#### `Reservation.java`
- Table : `reservations`
- Champs : `id` (Long, auto-généré), `numero_reservation`, `date_arrive`, `date_depart`
- Relations :
  - `@ManyToOne` avec `Client`
  - `@ManyToOne` avec `Chambre`
  - `@ManyToOne` avec `Hotel`

### 4. **Repositories créés**

Des repositories Spring Data JPA ont été créés pour chaque entité :

- `HotelRepository` : Recherche par nom, adresse, comptage de chambres/réservations
- `ChambreRepository` : Recherche par hôtel, numéro, prix, nombre de lits
- `ReservationRepository` : Recherche par hôtel, chambre, client, détection de chevauchements de dates
- `ClientRepository` : Recherche par nom, prénom, numéro de carte

### 5. **Service adapté** (`HotelService.java`)

Le service a été modifié pour :
- Injecter les repositories via `@Autowired`
- Charger l'hôtel depuis la base au démarrage (si existant)
- Créer l'hôtel et les chambres (si nouveau)
- Utiliser les repositories pour toutes les opérations CRUD
- Gérer les transactions avec `@Transactional`

## 📊 Structure de la base de données

### Table `hotels`
```sql
CREATE TABLE hotels (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(255) NOT NULL,
    adresse VARCHAR(255) NOT NULL,
    type VARCHAR(50) NOT NULL
);
```

### Table `chambres`
```sql
CREATE TABLE chambres (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    numero_chambre INT NOT NULL,
    nom VARCHAR(255) NOT NULL,
    prix FLOAT NOT NULL,
    nbr_de_lit INT NOT NULL,
    image_url VARCHAR(500),
    hotel_id BIGINT NOT NULL,
    FOREIGN KEY (hotel_id) REFERENCES hotels(id)
);
```

### Table `clients`
```sql
CREATE TABLE clients (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(255) NOT NULL,
    prenom VARCHAR(255) NOT NULL,
    numero_carte_bleue VARCHAR(50) NOT NULL
);
```

### Table `reservations`
```sql
CREATE TABLE reservations (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    numero_reservation INT NOT NULL,
    date_arrive DATE NOT NULL,
    date_depart DATE NOT NULL,
    client_id BIGINT NOT NULL,
    chambre_id BIGINT NOT NULL,
    hotel_id BIGINT NOT NULL,
    FOREIGN KEY (client_id) REFERENCES clients(id),
    FOREIGN KEY (chambre_id) REFERENCES chambres(id),
    FOREIGN KEY (hotel_id) REFERENCES hotels(id)
);
```

## 🚀 Utilisation

### 1. **Recompiler le projet**

```bash
cd /home/corentinfay/Bureau/RestRepo/Hotellerie
mvn clean install
```

### 2. **Lancer les services**

```bash
cd /home/corentinfay/Bureau/RestRepo
./start-system-maven.sh
```

### 3. **Accéder à la console H2**

Pour chaque hôtel, vous pouvez accéder à la console H2 :

- **Hôtel Paris** : http://localhost:8082/h2-console
- **Hôtel Lyon** : http://localhost:8083/h2-console  
- **Hôtel Montpellier** : http://localhost:8084/h2-console

**Paramètres de connexion :**

**Paris** :
- JDBC URL : `jdbc:h2:file:./data/hotellerie-paris-db`
- User Name : `sa`
- Password : *(laisser vide)*

**Lyon** :
- JDBC URL : `jdbc:h2:file:./data/hotellerie-lyon-db`
- User Name : `sa`
- Password : *(laisser vide)*

**Montpellier** :
- JDBC URL : `jdbc:h2:file:./data/hotellerie-montpellier-db`
- User Name : `sa`
- Password : *(laisser vide)*

### 4. **Données persistées**

Les données sont sauvegardées dans des fichiers **séparés par hôtel** :
- `Hotellerie/data/hotellerie-paris-db.mv.db` (Paris)
- `Hotellerie/data/hotellerie-lyon-db.mv.db` (Lyon)
- `Hotellerie/data/hotellerie-montpellier-db.mv.db` (Montpellier)

**Important :** À chaque démarrage, le système :
1. Vérifie si l'hôtel existe dans **sa propre base**
2. Si oui : charge les données existantes (chambres + réservations)
3. Si non : crée l'hôtel et initialise les chambres

## 🔍 Avantages de cette implémentation

✅ **Persistance** : Les données survivent aux redémarrages  
✅ **Intégrité** : Les relations entre entités sont gérées par la base  
✅ **Performance** : Requêtes optimisées avec Spring Data JPA  
✅ **Traçabilité** : Toutes les réservations et clients sont conservés  
✅ **Évolutivité** : Facile d'ajouter de nouvelles tables ou relations  
✅ **Debug** : Console H2 pour inspecter les données  

## 📝 Remarques

- La base H2 est en mode fichier, donc chaque instance d'hôtel a sa propre base
- Les ID sont auto-générés et commencent à 1
- Les dates de réservation sont stockées au format DATE
- Les chambres sont chargées en EAGER pour éviter les problèmes de lazy loading
- Les réservations sont chargées en LAZY pour optimiser les performances

## 🔄 Prochaines étapes possibles

- Ajouter une interface web pour visualiser les réservations
- Implémenter un système de recherche avancé
- Ajouter des statistiques (taux d'occupation, revenus, etc.)
- Créer des rapports au format PDF
- Implémenter un système de notifications par email

