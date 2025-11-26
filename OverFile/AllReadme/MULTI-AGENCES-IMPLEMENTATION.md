# 🏢 Système Multi-Agences - Documentation Complète

## 📋 Vue d'ensemble

Le système a été transformé pour supporter **plusieurs agences** avec les caractéristiques suivantes :

### ✨ Nouvelles fonctionnalités

1. **2 Agences indépendantes** avec des coefficients de prix différents
2. **Hôtels partagés** entre agences (Lyon est commun aux 2 agences)
3. **Client multi-agences** qui agrège les résultats de toutes les agences
4. **Affichage de l'agence** pour chaque chambre dans le CLI
5. **Visibilité de toutes les chambres**, même celles proposées par plusieurs agences

---

## 🏗️ Architecture du système

```
┌─────────────────────────────────────────────────────────────┐
│                         CLIENT                              │
│                  (MultiAgenceRestClient)                    │
│              Agrège 2 agences en parallèle                  │
└─────────────┬───────────────────────────┬───────────────────┘
              │                           │
              ▼                           ▼
    ┌─────────────────┐         ┌─────────────────┐
    │   AGENCE 1      │         │   AGENCE 2      │
    │ Paris Voyages   │         │ Sud Réservations│
    │   Port: 8081    │         │   Port: 8085    │
    │   Coef: 1.15    │         │   Coef: 1.20    │
    └────┬──────┬─────┘         └────┬──────┬─────┘
         │      │                    │      │
         ▼      ▼                    ▼      ▼
    ┌──────┐ ┌──────┐            ┌──────┐ ┌──────┐
    │Paris │ │Lyon  │            │Lyon  │ │Montp.│
    │:8082 │ │:8083 │◄───────────│:8083 │ │:8084 │
    └──────┘ └──────┘   commun   └──────┘ └──────┘
```

### 📊 Configuration détaillée

| Composant | Port | Détails |
|-----------|------|---------|
| **Hôtel Paris** | 8082 | Connecté à Agence 1 uniquement |
| **Hôtel Lyon** | 8083 | ⭐ **Connecté aux 2 agences** (hôtel partagé) |
| **Hôtel Montpellier** | 8084 | Connecté à Agence 2 uniquement |
| **Agence 1** (Paris Voyages) | 8081 | Coef: 1.15 - Hôtels: Paris + Lyon |
| **Agence 2** (Sud Réservations) | 8085 | Coef: 1.20 - Hôtels: Lyon + Montpellier |
| **Client** | - | Connecté aux 2 agences |

---

## 🔧 Modifications techniques

### 1. **Agence** - Support multi-instances

#### Fichiers créés :
- `application-agence1.properties` : Configuration Agence 1
- `application-agence2.properties` : Configuration Agence 2

#### Modifications dans `MultiHotelRestClient.java` :
```java
@Value("${agence.nom:Agence Inconnue}")
private String agenceNom;

@Value("${agence.coefficient:1.0}")
private float agenceCoefficient;
```

- ✅ Application du coefficient sur le prix de chaque chambre
- ✅ Ajout du nom de l'agence à chaque chambre
- ✅ Chargement dynamique des hôtels configurés

#### Modifications dans `ChambreDTO.java` :
```java
private String agenceNom;  // Nouveau champ
```

### 2. **Client** - Agrégation multi-agences

#### Fichier créé :
- `MultiAgenceRestClient.java` : Client REST qui interroge plusieurs agences en parallèle

#### Configuration `application.properties` :
```properties
agence1.url=http://localhost:8081
agence2.url=http://localhost:8085
```

#### Fonctionnalités :
- ✅ **Recherche parallèle** dans toutes les agences (CompletableFuture)
- ✅ **Agrégation des résultats** avec conservation des doublons
- ✅ **Affichage de l'origine** (nom de l'agence) pour chaque chambre
- ✅ **Réservation intelligente** vers la bonne agence

#### Modifications dans `ClientCLIRest.java` :
```java
@Autowired
private MultiAgenceRestClient agenceRestClient;  // Au lieu d'AgenceRestClient
```

- ✅ Affichage du nom de l'agence pour chaque chambre
- ✅ Format de prix amélioré (2 décimales)
- ✅ Bannière mise à jour "CLIENT MULTI-AGENCES"

---

## 🚀 Démarrage du système

### Option 1 : Démarrage complet automatique

```bash
cd /home/corentinfay/Bureau/RestRepo
./start-multi-agences.sh
```

Ce script démarre automatiquement :
1. Les 3 hôtels (Paris, Lyon, Montpellier)
2. L'Agence 1 (Paris Voyages)
3. L'Agence 2 (Sud Réservations)
4. Le Client

### Option 2 : Démarrage manuel

```bash
# 1. Démarrer les hôtels
./start-hotel.sh

# 2. Démarrer l'Agence 1
./start-agence1.sh

# 3. Démarrer l'Agence 2
./start-agence2.sh

# 4. Démarrer le Client
./start-client.sh
```

### 🛑 Arrêter tous les services

```bash
pkill -f 'java.*Hotellerie'
pkill -f 'java.*Agence'
```

---

## 📝 Logs

Les logs sont disponibles dans le dossier `logs/` :

- `logs/hotel-paris.log` : Logs de l'hôtel Paris
- `logs/hotel-lyon.log` : Logs de l'hôtel Lyon
- `logs/hotel-montpellier.log` : Logs de l'hôtel Montpellier
- `logs/agence1.log` : Logs de l'Agence 1
- `logs/agence2.log` : Logs de l'Agence 2

---

## 💡 Exemple d'utilisation

### Cas d'usage : Recherche de chambres

1. Le client recherche des chambres pour le 2025-12-01 au 2025-12-05
2. Le système interroge **les 2 agences en parallèle**
3. Résultats :

```
─── Chambre 1 ───
  🏨 Hôtel: Hôtel Paris
  📍 Adresse: Paris
  🏢 Agence: Agence Paris Voyages
  🚪 Chambre: Suite Présidentielle (ID: 1)
  💰 Prix: 287.50 € (250€ × 1.15)
  🛏️  Lits: 2

─── Chambre 2 ───
  🏨 Hôtel: Hôtel Lyon
  📍 Adresse: Lyon
  🏢 Agence: Agence Paris Voyages
  🚪 Chambre: Chambre Deluxe (ID: 3)
  💰 Prix: 172.50 € (150€ × 1.15)
  🛏️  Lits: 2

─── Chambre 3 ───
  🏨 Hôtel: Hôtel Lyon
  📍 Adresse: Lyon
  🏢 Agence: Agence Sud Réservations
  🚪 Chambre: Chambre Deluxe (ID: 3)
  💰 Prix: 180.00 € (150€ × 1.20)
  🛏️  Lits: 2

─── Chambre 4 ───
  🏨 Hôtel: Hôtel Montpellier
  📍 Adresse: Montpellier
  🏢 Agence: Agence Sud Réservations
  🚪 Chambre: Chambre Standard (ID: 5)
  💰 Prix: 96.00 € (80€ × 1.20)
  🛏️  Lits: 1
```

### 📊 Observations

- ✅ **Chambre 2 et 3** : Même chambre de Lyon proposée par **2 agences différentes**
- ✅ **Prix différents** : 172.50€ (Agence 1) vs 180.00€ (Agence 2)
- ✅ Le client voit **toutes les options** et peut choisir la meilleure offre

---

## 🎯 Avantages du système multi-agences

1. **Comparaison de prix** : Même chambre avec différents prix selon l'agence
2. **Plus de choix** : Accès à tous les hôtels de toutes les agences
3. **Performance** : Recherche parallèle (CompletableFuture)
4. **Transparence** : Affichage clair de l'origine (agence)
5. **Scalabilité** : Facile d'ajouter une 3ème, 4ème agence...

---

## 🔍 Tests recommandés

### Test 1 : Vérifier les coefficients
- Rechercher une chambre
- Vérifier que les prix sont différents pour la même chambre Lyon
- Agence 1 : prix × 1.15
- Agence 2 : prix × 1.20

### Test 2 : Hôtels uniques
- Vérifier que Paris n'apparaît que via Agence 1
- Vérifier que Montpellier n'apparaît que via Agence 2

### Test 3 : Hôtel partagé
- Vérifier que Lyon apparaît 2 fois (une fois par agence)
- Avec des prix différents

### Test 4 : Réservation
- Réserver une chambre depuis Agence 1
- Réserver une chambre depuis Agence 2
- Vérifier que les réservations arrivent au bon hôtel

---

## 📦 Fichiers de scripts créés

| Script | Description |
|--------|-------------|
| `start-agence1.sh` | Démarre l'Agence 1 sur le port 8081 |
| `start-agence2.sh` | Démarre l'Agence 2 sur le port 8085 |
| `start-multi-agences.sh` | Démarre tout le système (3 hôtels + 2 agences + client) |

---

## 🏆 Résumé des changements

### Agence (Backend)
- ✅ 2 fichiers de configuration (agence1, agence2)
- ✅ Support du coefficient de prix
- ✅ Ajout du nom d'agence aux chambres
- ✅ Chargement dynamique des hôtels

### Client (Frontend CLI)
- ✅ Nouveau `MultiAgenceRestClient`
- ✅ Agrégation parallèle de plusieurs agences
- ✅ Affichage de l'origine (agence) pour chaque chambre
- ✅ Conservation des doublons (même chambre, agences différentes)

### Scripts
- ✅ `start-agence1.sh`
- ✅ `start-agence2.sh`
- ✅ `start-multi-agences.sh`

---

## 🎉 Conclusion

Le système est maintenant **multi-agences** avec :
- ✅ 2 agences fonctionnelles avec des coefficients différents
- ✅ 1 hôtel partagé entre les 2 agences (Lyon)
- ✅ Client qui voit toutes les chambres de toutes les agences
- ✅ Affichage clair de l'agence pour chaque chambre
- ✅ Possibilité de comparer les prix

**Le système est prêt à être testé !** 🚀

---

**Date de modification :** 2025-11-26

