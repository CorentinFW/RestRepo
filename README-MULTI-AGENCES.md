# 🏨 Système de Réservation Hôtelière - Architecture Multi-Agences REST

[![Version](https://img.shields.io/badge/version-2.0-blue.svg)](https://github.com)
[![Status](https://img.shields.io/badge/status-production%20ready-success.svg)](https://github.com)
[![Java](https://img.shields.io/badge/java-11+-orange.svg)](https://openjdk.org/)
[![Spring Boot](https://img.shields.io/badge/spring%20boot-2.7.18-green.svg)](https://spring.io/projects/spring-boot)

Système distribué de réservation de chambres d'hôtel utilisant une **architecture REST** avec Spring Boot. Le système permet la comparaison de prix en temps réel entre plusieurs agences de voyage.

---

## 🚀 DÉMARRAGE RAPIDE (30 secondes)

### Option 1 : Script tout-en-un (Recommandé)

```bash
cd /home/corentinfay/Bureau/RestRepo
./start-multi-agences.sh
```

**Note :** Le client CLI échouera car il n'a pas d'entrée standard. Lancez-le manuellement dans un autre terminal (voir Option 2).

### Option 2 : Démarrage manuel (Recommandé pour le CLI)

**Terminal 1 - Services Backend :**
```bash
# Démarrer les 3 hôtels
./start-hotels.sh

# Attendre 15 secondes puis démarrer les agences
./start-agence1.sh
./start-agence2.sh
```

**Terminal 2 - Client CLI :**
```bash
cd Client
./start-client.sh
```

### Vérification

```bash
# Vérifier que tous les services tournent
ps aux | grep -E 'java.*(Hotellerie|Agence)' | grep -v grep

# Vérifier les ports
ss -tlnp | grep -E ':(8081|8082|8083|8084|8085)'
```

**Résultat attendu :** 5 ports en écoute (3 hôtels + 2 agences)

---

## 🏗️ Architecture du Système

```
                    ┌─────────────────┐
                    │   CLIENT CLI    │
                    │  (Multi-Agence) │
                    │   Agrégation    │
                    └────────┬────────┘
                             │
                    Requêtes parallèles (REST)
                             │
            ┌────────────────┴────────────────┐
            │                                 │
            ▼                                 ▼
    ┌──────────────┐                  ┌──────────────┐
    │  AGENCE 1    │                  │  AGENCE 2    │
    │Paris Voyages │                  │Sud Réserv.   │
    │   :8081      │                  │   :8085      │
    │ Coef: 1.15   │                  │ Coef: 1.20   │
    └──────┬───────┘                  └───────┬──────┘
           │                                  │
           │ REST                      REST   │
           │                                  │
    ┌──────┴──────┐                    ┌──────┴──────┐
    │             │                    │             │
    ▼             ▼                    ▼             ▼
┌────────┐   ┌────────┐          ┌────────┐   ┌────────┐
│ PARIS  │   │ LYON   │◄─────────│ LYON   │   │MONTPEL.│
│ :8082  │   │ :8083  │  PARTAGÉ │ :8083  │   │ :8084  │
│5 chambr│   │5 chambr│          │5 chambr│   │5 chambr│
└────────┘   └────────┘          └────────┘   └────────┘
```

### Composants

| Composant | Port | Rôle | Coefficient |
|-----------|------|------|-------------|
| **Hôtel Paris** | 8082 | Service REST - Gestion des chambres | - |
| **Hôtel Lyon** | 8083 | Service REST - Gestion des chambres | - |
| **Hôtel Montpellier** | 8084 | Service REST - Gestion des chambres | - |
| **Agence 1** (Paris Voyages) | 8081 | Agrège Paris + Lyon | ×1.15 |
| **Agence 2** (Sud Réservations) | 8085 | Agrège Lyon + Montpellier | ×1.20 |
| **Client CLI** | - | Interface utilisateur | - |

---

## ✨ Fonctionnalités

### 🔍 Recherche Multi-Agences

- Interrogation **parallèle** de toutes les agences
- **Agrégation automatique** des résultats
- **Conservation des doublons** pour comparaison de prix
- Affichage de l'**agence d'origine** pour chaque chambre

### 💰 Comparaison de Prix

Chaque agence applique son propre coefficient :
- **Agence 1** : Prix × 1.15 (15% de commission)
- **Agence 2** : Prix × 1.20 (20% de commission)

**Exemple :**
- Chambre Lyon - Prix de base : **75€**
- Via Agence 1 : **86.25€** ✅ (économie de 3.75€)
- Via Agence 2 : **90€**

### 🏨 Hôtels Partagés

**Lyon** est connecté aux deux agences :
- Les chambres apparaissent **2 fois** dans les résultats
- Permet la **comparaison directe** des prix
- Le client choisit la **meilleure offre**

### 🖼️ Images des Chambres

Chaque chambre dispose d'une URL d'image :
- `http://localhost:8082/images/Hotelle1.png` (Paris)
- `http://localhost:8083/images/Hotelle2.png` (Lyon)
- `http://localhost:8084/images/Hotelle3.png` (Montpellier)

---

## 🎯 Utilisation

### Interface CLI

Le client offre 6 options :

```
═══ MENU PRINCIPAL ═══
1. Rechercher des chambres
2. Effectuer une réservation
3. Afficher les dernières chambres trouvées
4. Afficher les hôtels disponibles
5. Afficher les chambres réservées par hôtel
6. Quitter
```

#### Option 1 : Rechercher des chambres

```
Adresse (ville/rue) [optionnel]: Lyon
Date d'arrivée (YYYY-MM-DD): 2025-12-01
Date de départ (YYYY-MM-DD): 2025-12-05
Prix minimum [optionnel]: 50
Prix maximum [optionnel]: 100
Nombre d'étoiles (1-6) [optionnel]: 
Nombre de lits minimum [optionnel]: 2
```

**Résultat :** Liste de toutes les chambres correspondantes avec leur agence et leur prix.

#### Option 2 : Effectuer une réservation

Après avoir recherché des chambres, sélectionnez le numéro de chambre et remplissez vos informations.

### API REST

#### Rechercher des chambres

**Agence 1 :**
```bash
curl -X POST http://localhost:8081/api/agence/chambres/rechercher \
  -H "Content-Type: application/json" \
  -d '{
    "dateArrive": "2025-12-01",
    "dateDepart": "2025-12-05",
    "adresse": "Lyon",
    "prixMin": 50,
    "prixMax": 150
  }'
```

**Agence 2 :**
```bash
curl -X POST http://localhost:8085/api/agence/chambres/rechercher \
  -H "Content-Type: application/json" \
  -d '{
    "dateArrive": "2025-12-01",
    "dateDepart": "2025-12-05"
  }'
```

#### Effectuer une réservation

```bash
curl -X POST http://localhost:8081/api/agence/reserver \
  -H "Content-Type: application/json" \
  -d '{
    "idChambre": 11,
    "hotelUrl": "http://localhost:8083",
    "dateArrive": "2025-12-01",
    "dateDepart": "2025-12-05",
    "nomClient": "Jean Dupont",
    "emailClient": "jean.dupont@email.com"
  }'
```

#### Consulter les réservations

```bash
# Par hôtel
curl http://localhost:8081/api/agence/chambres/reservees?hotelUrl=http://localhost:8083

# Toutes les réservations
curl http://localhost:8081/api/agence/chambres/reservees
```

---

## 📊 Structure du Projet

```
RestRepo/
├── Hotellerie/               # Module Hôtels
│   ├── src/main/java/
│   │   └── org/tp1/hotellerie/
│   │       ├── controller/   # HotelController (REST)
│   │       ├── dto/          # ChambreDTO, RechercheRequest
│   │       ├── model/        # Chambre, Hotel
│   │       └── service/      # HotelService
│   ├── src/main/resources/
│   │   ├── application-paris.properties
│   │   ├── application-lyon.properties
│   │   └── application-montpellier.properties
│   └── Image/                # Images des hôtels
│
├── Agence/                   # Module Agences
│   ├── src/main/java/
│   │   └── org/tp1/agence/
│   │       ├── controller/   # AgenceController (REST)
│   │       ├── dto/          # ChambreDTO, ReservationRequest
│   │       ├── rest/         # MultiHotelRestClient
│   │       └── service/      # AgenceService
│   └── src/main/resources/
│       ├── application-agence1.properties
│       └── application-agence2.properties
│
├── Client/                   # Module Client
│   ├── src/main/java/
│   │   └── org/tp1/client/
│   │       ├── cli/          # ClientCLIRest
│   │       ├── dto/          # ChambreDTO, RechercheRequest
│   │       └── rest/         # MultiAgenceRestClient
│   └── src/main/resources/
│       └── application.properties
│
├── logs/                     # Logs des services
├── start-hotels.sh           # Démarre les 3 hôtels
├── start-agence1.sh          # Démarre l'Agence 1
├── start-agence2.sh          # Démarre l'Agence 2
├── start-multi-agences.sh    # Démarre tout le système
└── Documentation/
    ├── DEMARRAGE-RAPIDE.md
    ├── LIVRAISON-MULTI-AGENCES.md
    ├── MULTI-AGENCES-IMPLEMENTATION.md
    ├── GUIDE-TEST-MULTI-AGENCES.md
    └── RECAP-FINAL.md
```

---

## 🧪 Tests

### Test automatique

```bash
# Test de l'architecture multi-agences
./test-multi-agences.sh
```

### Tests manuels

**Test 1 : Vérifier les services**
```bash
curl http://localhost:8082/api/hotel/chambres
curl http://localhost:8083/api/hotel/chambres
curl http://localhost:8084/api/hotel/chambres
```

**Test 2 : Comparer les prix**
```bash
# Agence 1 (coef 1.15)
curl -s -X POST http://localhost:8081/api/agence/chambres/rechercher \
  -H "Content-Type: application/json" \
  -d '{"dateArrive":"2025-12-01","dateDepart":"2025-12-05"}' | \
  python3 -m json.tool | grep -A 3 '"prix"'

# Agence 2 (coef 1.20)
curl -s -X POST http://localhost:8085/api/agence/chambres/rechercher \
  -H "Content-Type: application/json" \
  -d '{"dateArrive":"2025-12-01","dateDepart":"2025-12-05"}' | \
  python3 -m json.tool | grep -A 3 '"prix"'
```

---

## 🛑 Arrêt du Système

```bash
# Arrêter tous les services
pkill -f 'java.*Hotellerie'
pkill -f 'java.*Agence'
pkill -f 'java.*Client'

# Vérifier que tout est arrêté
ps aux | grep -E 'java.*(Hotellerie|Agence|Client)' | grep -v grep
```

---

## 📝 Logs

Les logs sont disponibles dans le dossier `logs/` :

```bash
# Hôtels
tail -f logs/hotel-paris.log
tail -f logs/hotel-lyon.log
tail -f logs/hotel-montpellier.log

# Agences
tail -f logs/agence.log        # Agence 1
tail -f logs/agence2.log       # Agence 2
```

---

## 🔧 Configuration

### Modifier les coefficients

**Fichier :** `Agence/src/main/resources/application-agence1.properties`
```properties
agence.coefficient=1.15
agence.nom=Agence Paris Voyages
```

**Fichier :** `Agence/src/main/resources/application-agence2.properties`
```properties
agence.coefficient=1.20
agence.nom=Agence Sud Reservations
```

### Ajouter une 3ème agence

1. Créer `application-agence3.properties`
2. Créer `start-agence3.sh`
3. Ajouter l'URL dans `Client/src/main/resources/application.properties`
4. Recompiler et redémarrer

---

## 📚 Documentation Complète

- **[DEMARRAGE-RAPIDE.md](DEMARRAGE-RAPIDE.md)** - Guide de démarrage rapide
- **[LIVRAISON-MULTI-AGENCES.md](LIVRAISON-MULTI-AGENCES.md)** - Livraison complète du projet
- **[MULTI-AGENCES-IMPLEMENTATION.md](MULTI-AGENCES-IMPLEMENTATION.md)** - Documentation technique détaillée
- **[GUIDE-TEST-MULTI-AGENCES.md](GUIDE-TEST-MULTI-AGENCES.md)** - Guide de test pas à pas
- **[RECAP-FINAL.md](RECAP-FINAL.md)** - Récapitulatif complet du projet

---

## 🎯 Cas d'Usage

### Scénario : Rechercher la meilleure offre pour Lyon

1. **Client lance une recherche**
   - Dates : 2025-12-01 → 2025-12-05
   - Ville : Lyon

2. **Système interroge les 2 agences en parallèle**
   - Agence 1 : 5 chambres (Lyon × coef 1.15)
   - Agence 2 : 5 chambres (Lyon × coef 1.20)

3. **Client compare les résultats**
   - Chambre Standard : 86.25€ (Agence 1) vs 90€ (Agence 2)
   - **Économie : 3.75€** ✅

4. **Client réserve via l'Agence 1**

---

## 🏆 Avantages du Système

- ✅ **Comparaison de prix automatique** entre plusieurs agences
- ✅ **Recherche parallèle** pour des performances optimales
- ✅ **Hôtels partagés** pour maximiser les options
- ✅ **Transparence totale** : agence et prix affichés clairement
- ✅ **API REST moderne** et facile à intégrer
- ✅ **Architecture extensible** : ajout d'agences/hôtels simple
- ✅ **Documentation complète** et guides de test

---

## 🚀 Évolutions Futures

### Court terme
- [ ] Ajouter une 3ème agence
- [ ] Filtrage par agence préférée
- [ ] Système de notation des agences

### Moyen terme
- [ ] Interface Web (React/Angular)
- [ ] API Gateway
- [ ] Cache Redis pour les performances

### Long terme
- [ ] Base de données persistante
- [ ] Système de paiement
- [ ] Programme de fidélité multi-agences
- [ ] Notifications en temps réel

---

## 👥 Auteurs

**GitHub Copilot** - Transformation SOAP → REST et implémentation multi-agences

---

## 📄 Licence

Projet éducatif - Libre d'utilisation

---

## 📞 Support

En cas de problème :
1. Vérifier que tous les ports sont libres (8081-8085)
2. Consulter les logs dans le dossier `logs/`
3. Redémarrer les services avec les scripts fournis

---

**Version :** 2.0 - Multi-Agences REST  
**Date :** 26 novembre 2025  
**Statut :** ✅ **PRODUCTION READY**

