# 🔧 CORRECTION CRITIQUE : Base de données H2 séparée par hôtel

## 🐛 Le problème RÉEL

### Erreurs constatées
1. ❌ **"Hôtel non trouvé"** lors de la réservation
2. ❌ Seul l'hôtel Montpellier (Méditerranée) se lance
3. ❌ Les autres hôtels ne démarrent pas correctement

### Cause racine

**TOUS les hôtels utilisaient la MÊME base de données H2 !**

```
application.properties (COMMUN À TOUS) :
spring.datasource.url=jdbc:h2:file:./data/hotellerie-db
                                            ^^^^^^^^^
                                    MÊME FICHIER POUR TOUS !
```

### Séquence du problème

```
1. Hotel Paris démarre (port 8082)
   ↓
   Crée ./data/hotellerie-db
   ↓
   Enregistre "Grand Hotel Paris" dans la table hotels

2. Hotel Lyon démarre (port 8083)
   ↓
   Ouvre ./data/hotellerie-db (LA MÊME BASE !)
   ↓
   Trouve "Grand Hotel Paris" déjà existant
   ↓
   ❌ Ne crée pas "Hotel Lyon Centre"
   ↓
   Lyon pense être Paris !

3. Hotel Montpellier démarre (port 8084)
   ↓
   Ouvre ./data/hotellerie-db (TOUJOURS LA MÊME !)
   ↓
   Trouve "Grand Hotel Paris" ou "Hotel Lyon Centre"
   ↓
   ❌ Ne crée pas "Hotel Mediterranee"
   ↓
   Montpellier est confus !

4. Client cherche à réserver à Lyon
   ↓
   L'agence cherche "25 Place Bellecour, Lyon"
   ↓
   ❌ "Hôtel non trouvé" car la base ne contient que Paris !
```

---

## ✅ La solution

### Chaque hôtel doit avoir SA PROPRE base de données

**Avant (BUGGÉ)** :
```
application.properties (commun)
└── spring.datasource.url=jdbc:h2:file:./data/hotellerie-db
```

**Après (CORRIGÉ)** :
```
application-paris.properties
└── spring.datasource.url=jdbc:h2:file:./data/hotellerie-paris-db

application-lyon.properties
└── spring.datasource.url=jdbc:h2:file:./data/hotellerie-lyon-db

application-montpellier.properties
└── spring.datasource.url=jdbc:h2:file:./data/hotellerie-montpellier-db
```

### Fichiers modifiés

#### 1. `application-paris.properties`
```properties
server.port=8082
spring.application.name=Hotellerie-Paris

hotel.ville=Paris
hotel.nom=Grand Hotel Paris
hotel.adresse=10 Rue de la Paix, Paris
hotel.categorie=CAT5

# ✅ BASE DE DONNÉES SÉPARÉE
spring.datasource.url=jdbc:h2:file:./data/hotellerie-paris-db
spring.datasource.driverClassName=org.h2.Driver
spring.datasource.username=sa
spring.datasource.password=
```

#### 2. `application-lyon.properties`
```properties
server.port=8083
spring.application.name=Hotellerie-Lyon

hotel.ville=Lyon
hotel.nom=Hotel Lyon Centre
hotel.adresse=25 Place Bellecour, Lyon
hotel.categorie=CAT4

# ✅ BASE DE DONNÉES SÉPARÉE
spring.datasource.url=jdbc:h2:file:./data/hotellerie-lyon-db
spring.datasource.driverClassName=org.h2.Driver
spring.datasource.username=sa
spring.datasource.password=
```

#### 3. `application-montpellier.properties`
```properties
server.port=8084
spring.application.name=Hotellerie-Montpellier

hotel.ville=Montpellier
hotel.nom=Hotel Mediterranee
hotel.adresse=15 Rue de la Loge, Montpellier
hotel.categorie=CAT3

# ✅ BASE DE DONNÉES SÉPARÉE
spring.datasource.url=jdbc:h2:file:./data/hotellerie-montpellier-db
spring.datasource.driverClassName=org.h2.Driver
spring.datasource.username=sa
spring.datasource.password=
```

---

## 🚀 Comment appliquer la correction

### Méthode automatique (RECOMMANDÉE)

```bash
cd /home/corentinfay/Bureau/RestRepo
./fix-h2-databases.sh
```

Ce script va :
1. ✅ Arrêter tous les services
2. ✅ Supprimer les anciennes bases
3. ✅ Recompiler Hotellerie
4. ✅ Redémarrer avec les nouvelles bases séparées

### Méthode manuelle

```bash
# 1. Arrêter tout
cd /home/corentinfay/Bureau/RestRepo
./arreter-services.sh
pkill -f "Hotellerie"

# 2. Supprimer anciennes bases
rm -rf Hotellerie/data/*.db Hotellerie/data/*.log

# 3. Recompiler
cd Hotellerie
mvn clean install -DskipTests

# 4. Redémarrer
cd ..
./start-system-maven.sh

# 5. Lancer le client (nouveau terminal)
cd Client
mvn spring-boot:run
```

---

## 🔍 Vérification

### 1. Vérifier que 3 bases sont créées

```bash
ls -lh Hotellerie/data/
```

**Résultat attendu** :
```
hotellerie-paris-db.mv.db
hotellerie-lyon-db.mv.db
hotellerie-montpellier-db.mv.db
```

### 2. Vérifier les consoles H2

**Paris** : http://localhost:8082/h2-console
- JDBC URL : `jdbc:h2:file:./data/hotellerie-paris-db`
- Requête : `SELECT * FROM hotels;`
- **Résultat attendu** : 1 ligne avec "Grand Hotel Paris"

**Lyon** : http://localhost:8083/h2-console
- JDBC URL : `jdbc:h2:file:./data/hotellerie-lyon-db`
- Requête : `SELECT * FROM hotels;`
- **Résultat attendu** : 1 ligne avec "Hotel Lyon Centre"

**Montpellier** : http://localhost:8084/h2-console
- JDBC URL : `jdbc:h2:file:./data/hotellerie-montpellier-db`
- Requête : `SELECT * FROM hotels;`
- **Résultat attendu** : 1 ligne avec "Hotel Mediterranee"

### 3. Test de réservation

Via l'interface graphique :
1. Rechercher à **Lyon** (25 Place Bellecour)
2. Dates : 01/12/2025 → 05/12/2025
3. Résultat : ✅ **5 chambres trouvées**
4. Réserver une chambre
5. Résultat : ✅ **"Réservation effectuée avec succès"**

---

## 📊 Avant / Après

| Aspect | Avant ❌ | Après ✅ |
|--------|---------|----------|
| **Bases de données** | 1 partagée | 3 séparées |
| **Hôtels en base Paris** | Paris seulement | Paris seulement |
| **Hôtels en base Lyon** | Paris (erreur!) | Lyon seulement |
| **Hôtels en base Montpellier** | Paris (erreur!) | Montpellier seulement |
| **Recherche Lyon** | "Hôtel non trouvé" | ✅ Chambres trouvées |
| **Réservation Lyon** | ❌ Échec 409 | ✅ Succès |

---

## 🧠 Pourquoi ce bug ?

### 1. Configuration initiale

Lors de l'ajout de H2, la configuration a été mise dans `application.properties` (fichier commun), au lieu d'être dans chaque profil.

### 2. Spring Boot profiles

Spring Boot charge :
1. `application.properties` (commun)
2. `application-{profile}.properties` (spécifique)

Les propriétés du profil **écrasent** celles du commun, SAUF si elles ne sont pas redéfinies !

### 3. Résultat

```
Paris   : Charge application.properties + application-paris.properties
          → Utilise datasource du commun (hotellerie-db)

Lyon    : Charge application.properties + application-lyon.properties
          → Utilise AUSSI datasource du commun (hotellerie-db) ❌

Montpellier : Charge application.properties + application-montpellier.properties
              → Utilise AUSSI datasource du commun (hotellerie-db) ❌
```

---

## 💡 Bonne pratique

### Configuration par profil

Pour des instances multiples avec JPA :
- ✅ **TOUJOURS** définir la datasource dans chaque profil
- ✅ Utiliser des noms de fichiers uniques
- ✅ Tester l'isolation des données

### Exemple de structure

```
application.properties
  → Configuration commune (JPA, Hibernate, etc.)
  → PAS de datasource.url

application-paris.properties
  → datasource.url spécifique
  → Configuration Paris

application-lyon.properties
  → datasource.url spécifique
  → Configuration Lyon
```

---

## 📝 Checklist de validation

Après avoir lancé `./fix-h2-databases.sh` :

- [ ] 3 fichiers `.mv.db` créés dans `Hotellerie/data/`
- [ ] Console H2 Paris montre "Grand Hotel Paris"
- [ ] Console H2 Lyon montre "Hotel Lyon Centre"
- [ ] Console H2 Montpellier montre "Hotel Mediterranee"
- [ ] Recherche à Paris trouve 5 chambres
- [ ] Recherche à Lyon trouve 5 chambres
- [ ] Recherche à Montpellier trouve 5 chambres
- [ ] Réservation à Lyon fonctionne
- [ ] Logs montrent 3 hôtels distincts

---

## 🎉 Conclusion

Le problème n'était **PAS** dans le code de réservation (celui-ci était correct), mais dans la **configuration H2** qui faisait partager la même base à tous les hôtels.

Avec cette correction :
- ✅ Chaque hôtel a sa propre base
- ✅ Les données sont isolées
- ✅ Les réservations fonctionnent
- ✅ Pas de conflits d'adresse

**🚀 Lancez `./fix-h2-databases.sh` et tout devrait fonctionner !**

---

*Correction appliquée le 27 novembre 2025*  
*Problème identifié : Configuration H2 partagée*  
*Solution : Bases de données séparées par profil*

