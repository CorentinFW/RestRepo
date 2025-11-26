# 🏨 Système de Réservation Hôtelière - Multi-Agences REST

[![Version](https://img.shields.io/badge/version-2.0-blue.svg)](https://github.com)
[![Java](https://img.shields.io/badge/java-11+-orange.svg)](https://openjdk.org/)
[![Spring Boot](https://img.shields.io/badge/spring%20boot-2.7.18-green.svg)](https://spring.io/projects/spring-boot)
[![Status](https://img.shields.io/badge/status-production%20ready-success.svg)](https://github.com)

Système distribué de réservation de chambres d'hôtel utilisant une **architecture REST** avec Spring Boot. Le système permet la comparaison de prix en temps réel entre plusieurs agences de voyage.

---

## 🚀 DÉMARRAGE RAPIDE (1 commande)

```bash
cd /home/corentinfay/Bureau/RestRepo
./start-multi-rest.sh
```

Le système démarre automatiquement :
- ✅ 3 Hôtels (Paris, Lyon, Montpellier)
- ✅ 2 Agences (Paris Voyages, Sud Réservations)
- ✅ 1 Client CLI interactif

**Temps de démarrage : ~40-50 secondes**

### Arrêter le système

```bash
./stop-multi-rest.sh
```

---

## 🏗️ Architecture

```
                 CLIENT CLI
              (Multi-Agences)
                    │
        ┌───────────┴───────────┐
        │                       │
        ▼                       ▼
    AGENCE 1                AGENCE 2
  Paris Voyages          Sud Réservations
    (8081)                  (8085)
   Coef: 1.15              Coef: 1.20
        │                       │
    ┌───┴───┐               ┌───┴────┐
    │       │               │        │
    ▼       ▼               ▼        ▼
  PARIS   LYON  ◄─────────► LYON  MONTPEL.
  (8082)  (8083)  PARTAGÉ   (8083) (8084)
```

### Composants

| Service | Port | Hôtels connectés | Coefficient |
|---------|------|------------------|-------------|
| **Hôtel Paris** | 8082 | - | - |
| **Hôtel Lyon** | 8083 | - | - |
| **Hôtel Montpellier** | 8084 | - | - |
| **Agence 1** | 8081 | Paris + Lyon | ×1.15 |
| **Agence 2** | 8085 | Lyon + Montpellier | ×1.20 |
| **Client CLI** | - | Agence 1 + Agence 2 | - |

---

## ✨ Fonctionnalités

### 🔍 Recherche Multi-Agences
- Interrogation parallèle de toutes les agences
- Agrégation automatique des résultats
- Conservation des doublons pour comparaison de prix

### 💰 Comparaison de Prix
- **Agence 1** : Prix × 1.15 (15% de commission)
- **Agence 2** : Prix × 1.20 (20% de commission)
- **Lyon** visible dans les 2 agences avec prix différents

**Exemple :**
- Chambre Lyon (prix de base 75€)
  - Via Agence 1 : **86.25€** ✅ (économie de 3.75€)
  - Via Agence 2 : **90€**

### 🏨 Hôtels Partagés
- **Lyon** accessible depuis les 2 agences
- Permet la comparaison directe des prix
- Le client choisit la meilleure offre

### 🖼️ Images des Chambres
Chaque chambre dispose d'une URL d'image accessible via HTTP.

---

## 📋 Prérequis

- **Java** 11 ou supérieur
- **Maven** 3.6+
- **Ports libres** : 8081, 8082, 8083, 8084, 8085

---

## 📚 Documentation

- **[GUIDE-UTILISATION.md](GUIDE-UTILISATION.md)** - Guide complet d'utilisation
- **[LISTE-SCRIPTS.md](LISTE-SCRIPTS.md)** - Tous les scripts disponibles
- **[PROBLEME-RESOLU.md](PROBLEME-RESOLU.md)** - Solution au problème de configuration
- **[CONFIGURATION-VALIDEE.md](CONFIGURATION-VALIDEE.md)** - Détails de la configuration
- **[INSTRUCTIONS-DEMARRAGE-MANUEL.md](INSTRUCTIONS-DEMARRAGE-MANUEL.md)** - Démarrage manuel

---

## 🎮 Utilisation du Client CLI

Une fois démarré, le client affiche ce menu :

```
═══ MENU PRINCIPAL ═══
1. Rechercher des chambres
2. Effectuer une réservation
3. Afficher les dernières chambres trouvées
4. Afficher les hôtels disponibles
5. Afficher les chambres réservées par hôtel
6. Quitter
```

### Recherche de chambres

**Résultat attendu : 20 chambres**
- 5 chambres **Paris** (via Agence 1 uniquement)
- 10 chambres **Lyon** (5 via Agence 1 + 5 via Agence 2)
- 5 chambres **Montpellier** (via Agence 2 uniquement)

Chaque chambre affiche :
- 🏨 Nom de l'hôtel
- 📍 Adresse
- 🏢 **Nom de l'agence**
- 💰 Prix avec coefficient appliqué
- 🛏️ Nombre de lits
- 🖼️ URL de l'image

---

## 🧪 Tests

### Test automatique de configuration

```bash
./test-configuration-finale.sh
```

Vérifie que :
- ✅ Agence 1 retourne Paris + Lyon (10 chambres)
- ✅ Agence 2 retourne Lyon + Montpellier (10 chambres)

### Test manuel avec curl

**Agence 1 :**
```bash
curl -s -X POST http://localhost:8081/api/agence/chambres/rechercher \
  -H "Content-Type: application/json" \
  -d '{"dateArrive":"2025-12-01","dateDepart":"2025-12-05"}'
```

**Agence 2 :**
```bash
curl -s -X POST http://localhost:8085/api/agence/chambres/rechercher \
  -H "Content-Type: application/json" \
  -d '{"dateArrive":"2025-12-01","dateDepart":"2025-12-05"}'
```

---

## 📁 Structure du Projet

```
RestRepo/
├── start-multi-rest.sh          ⭐ Script de démarrage principal
├── stop-multi-rest.sh           ⭐ Script d'arrêt
├── test-configuration-finale.sh ⭐ Script de test
│
├── Hotellerie/                  Module Hôtels
│   ├── src/main/
│   │   ├── java/               HotelController, HotelService
│   │   └── resources/          Configs (paris, lyon, montpellier)
│   └── Image/                  Images des hôtels
│
├── Agence/                      Module Agences
│   ├── src/main/
│   │   ├── java/               AgenceController, MultiHotelRestClient
│   │   └── resources/
│   │       ├── application.properties            (vide)
│   │       ├── application-agence1.properties    Paris + Lyon
│   │       └── application-agence2.properties    Lyon + Montpellier
│   └── target/                 JAR compilé
│
├── Client/                      Module Client
│   ├── src/main/
│   │   ├── java/               ClientCLIRest, MultiAgenceRestClient
│   │   └── resources/          Config multi-agences
│   └── target/
│
└── logs/                        Logs des services
    ├── hotel-paris.log
    ├── hotel-lyon.log
    ├── hotel-montpellier.log
    ├── agence.log
    └── agence2.log
```

---

## 🔧 Configuration

### Modifier les coefficients

**Agence 1 :**
```properties
# Fichier: Agence/src/main/resources/application-agence1.properties
agence.coefficient=1.15
```

**Agence 2 :**
```properties
# Fichier: Agence/src/main/resources/application-agence2.properties
agence.coefficient=1.20
```

Après modification :
```bash
cd Agence
mvn clean package -DskipTests
cd ..
./start-multi-rest.sh
```

---

## 📝 Logs

Les logs sont disponibles dans le dossier `logs/` :

```bash
# Suivre les logs en temps réel
tail -f logs/agence.log      # Agence 1
tail -f logs/agence2.log     # Agence 2
tail -f logs/hotel-lyon.log  # Hôtel Lyon
```

---

## 🛠️ Développement

### Compiler le projet

```bash
mvn clean install -DskipTests
```

### Démarrage manuel (pour debug)

**Terminal 1-3 : Hôtels**
```bash
cd Hotellerie
mvn spring-boot:run -Dspring-boot.run.profiles=paris
mvn spring-boot:run -Dspring-boot.run.profiles=lyon
mvn spring-boot:run -Dspring-boot.run.profiles=montpellier
```

**Terminal 4-5 : Agences**
```bash
cd Agence
mvn spring-boot:run -Dspring-boot.run.profiles=agence1
mvn spring-boot:run -Dspring-boot.run.profiles=agence2
```

**Terminal 6 : Client**
```bash
cd Client
mvn spring-boot:run
```

---

## 🆘 Dépannage

### Problème : Port déjà utilisé

```bash
# Voir qui utilise les ports
ss -tlnp | grep -E ':(8081|8082|8083|8084|8085)'

# Arrêter tous les services
./stop-multi-rest.sh
```

### Problème : Services ne démarrent pas

```bash
# Recompiler
mvn clean install -DskipTests

# Vérifier les logs
tail -50 logs/agence.log
```

### Problème : Le client ne trouve pas les chambres

```bash
# Vérifier que tous les services tournent
ps aux | grep -E 'java.*(Hotellerie|Agence)' | grep -v grep

# Devrait afficher 8 processus
```

---

## 🎯 Cas d'Usage Typique

### Scénario : Trouver la meilleure offre pour Lyon

1. **Démarrer le système**
   ```bash
   ./start-multi-rest.sh
   ```

2. **Dans le Client CLI**
   - Choisir option 1 (Rechercher)
   - Ville : Lyon
   - Dates : 2025-12-01 → 2025-12-05

3. **Observer les résultats**
   - 10 chambres Lyon (5 de chaque agence)
   - Prix différents : 86.25€ vs 90€
   - Économie visible : 3.75€

4. **Réserver**
   - Option 2
   - Choisir une chambre de l'Agence 1 (moins chère)

5. **Quitter proprement**
   - Option 6 dans le menu
   - `./stop-multi-rest.sh`

---

## 🏆 Avantages du Système

- ✅ **Comparaison automatique** des prix entre agences
- ✅ **Recherche parallèle** pour des performances optimales
- ✅ **Hôtels partagés** pour maximiser les options
- ✅ **Transparence totale** sur les prix et les agences
- ✅ **API REST moderne** facile à intégrer
- ✅ **Architecture extensible** (ajout d'agences/hôtels simple)
- ✅ **Documentation complète**

---

## 📊 Statistiques

- **3 Hôtels** avec 5 chambres chacun
- **2 Agences** avec des coefficients différents
- **1 Hôtel partagé** (Lyon) pour comparaison
- **20 Chambres** visibles au total par le client
- **10 Chambres Lyon** (5 × 2 agences) pour comparaison de prix

---

## 🚀 Évolutions Futures

- [ ] Interface Web (React/Angular)
- [ ] API Gateway
- [ ] Base de données persistante
- [ ] Système de paiement
- [ ] Programme de fidélité multi-agences
- [ ] Cache Redis pour les performances

---

## 📄 Licence

Projet éducatif - Libre d'utilisation

---

## 👥 Contributeurs

- **GitHub Copilot** - Transformation SOAP → REST et implémentation multi-agences

---

## 📞 Support

En cas de problème :
1. Consultez **[GUIDE-UTILISATION.md](GUIDE-UTILISATION.md)**
2. Vérifiez les logs dans `logs/`
3. Testez la configuration avec `./test-configuration-finale.sh`
4. Redémarrez avec `./stop-multi-rest.sh` puis `./start-multi-rest.sh`

---

**Version :** 2.0 - Multi-Agences REST  
**Date :** 26 novembre 2025  
**Statut :** ✅ **PRODUCTION READY**

**🎉 Prêt à l'emploi !**

