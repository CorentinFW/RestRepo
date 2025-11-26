# 🚀 GUIDE D'UTILISATION - Système Multi-Agences REST

## 📋 Prérequis

- Java 11 ou supérieur
- Maven installé
- Ports libres : 8081, 8082, 8083, 8084, 8085

---

## 🎯 DÉMARRAGE RAPIDE (1 commande)

```bash
cd /home/corentinfay/Bureau/RestRepo
./start-multi-rest.sh
```

**Ce qui se passe :**
1. ⏳ Démarrage des 3 hôtels (Paris, Lyon, Montpellier) - ~20 secondes
2. ⏳ Démarrage de l'Agence 1 (Paris Voyages) - ~8 secondes
3. ⏳ Démarrage de l'Agence 2 (Sud Réservations) - ~8 secondes
4. 💻 Ouverture du Client CLI dans le terminal

**Temps total : ~40-50 secondes**

---

## 🛑 ARRÊT DU SYSTÈME

```bash
cd /home/corentinfay/Bureau/RestRepo
./stop-multi-rest.sh
```

Ou manuellement :
```bash
pkill -f 'java.*Hotellerie'
pkill -f 'java.*Agence'
pkill -f 'ClientApplication'
```

---

## 🎮 UTILISATION DU CLIENT CLI

Une fois le client démarré, vous verrez ce menu :

```
═══ MENU PRINCIPAL ═══
1. Rechercher des chambres
2. Effectuer une réservation
3. Afficher les dernières chambres trouvées
4. Afficher les hôtels disponibles
5. Afficher les chambres réservées par hôtel
6. Quitter
```

### Option 1 : Rechercher des chambres

**Exemple :**
```
Adresse (ville/rue) [optionnel]: Lyon
Date d'arrivée (YYYY-MM-DD): 2025-12-01
Date de départ (YYYY-MM-DD): 2025-12-05
Prix minimum [optionnel]: 
Prix maximum [optionnel]: 
Nombre d'étoiles (1-6) [optionnel]: 
Nombre de lits minimum [optionnel]: 2
```

**Résultat attendu : 20 chambres**
- 5 chambres Paris (Agence 1)
- 10 chambres Lyon (5 via Agence 1 + 5 via Agence 2)
- 5 chambres Montpellier (Agence 2)

### Option 2 : Effectuer une réservation

Après avoir recherché des chambres, choisissez un numéro de chambre et remplissez :
- Nom du client
- Email du client

---

## 🏗️ ARCHITECTURE DU SYSTÈME

```
CLIENT CLI
    │
    ├─► AGENCE 1 (Paris Voyages - 8081)
    │   ├─► Hôtel Paris (8082)
    │   └─► Hôtel Lyon (8083) ◄─┐
    │                            │ PARTAGÉ
    └─► AGENCE 2 (Sud Réservations - 8085)
        ├─► Hôtel Lyon (8083) ◄─┘
        └─► Hôtel Montpellier (8084)
```

**Coefficients de prix :**
- Agence 1 : ×1.15 (commission 15%)
- Agence 2 : ×1.20 (commission 20%)

**Lyon est partagé** → Le client peut comparer les prix !

---

## 🧪 TESTS MANUELS (optionnel)

### Vérifier la configuration des agences

```bash
cd /home/corentinfay/Bureau/RestRepo
./test-configuration-finale.sh
```

### Tester l'API REST directement

**Agence 1 (doit retourner Paris + Lyon) :**
```bash
curl -s -X POST http://localhost:8081/api/agence/chambres/rechercher \
  -H "Content-Type: application/json" \
  -d '{"dateArrive":"2025-12-01","dateDepart":"2025-12-05"}' | \
  python3 -m json.tool | grep '"hotelNom"' | sort -u
```

**Résultat attendu :**
```
"hotelNom": "Grand Hotel Paris",
"hotelNom": "Hotel Lyon Centre",
```

**Agence 2 (doit retourner Lyon + Montpellier) :**
```bash
curl -s -X POST http://localhost:8085/api/agence/chambres/rechercher \
  -H "Content-Type: application/json" \
  -d '{"dateArrive":"2025-12-01","dateDepart":"2025-12-05"}' | \
  python3 -m json.tool | grep '"hotelNom"' | sort -u
```

**Résultat attendu :**
```
"hotelNom": "Hotel Lyon Centre",
"hotelNom": "Hotel Mediterranee",
```

---

## 📝 LOGS

Les logs sont disponibles dans le dossier `logs/` :

```bash
# Voir les logs des hôtels
tail -f logs/hotel-paris.log
tail -f logs/hotel-lyon.log
tail -f logs/hotel-montpellier.log

# Voir les logs des agences
tail -f logs/agence.log      # Agence 1
tail -f logs/agence2.log     # Agence 2
```

---

## 🔧 DÉPANNAGE

### Problème : Port déjà utilisé

```bash
# Vérifier les ports en cours d'utilisation
ss -tlnp | grep -E ':(8081|8082|8083|8084|8085)'

# Arrêter tous les services
./stop-multi-rest.sh

# Relancer
./start-multi-rest.sh
```

### Problème : Services ne démarrent pas

```bash
# Vérifier les logs
tail -50 logs/hotel-paris.log
tail -50 logs/agence.log

# Recompiler le projet
cd /home/corentinfay/Bureau/RestRepo
mvn clean install -DskipTests

# Relancer
./start-multi-rest.sh
```

### Problème : Le client ne trouve aucune chambre

Vérifiez que tous les services sont démarrés :
```bash
ps aux | grep -E 'java.*(Hotellerie|Agence)' | grep -v grep
```

Vous devriez voir **8 processus** (3 hôtels × 2 + 2 agences = 8).

---

## 💡 ASTUCES

### Relancer uniquement le client

Si les services backend tournent déjà :

```bash
cd /home/corentinfay/Bureau/RestRepo/Client
mvn spring-boot:run
```

### Voir les processus en cours

```bash
ps aux | grep -E 'java.*(Hotellerie|Agence)' | grep -v grep
```

### Nettoyer les logs

```bash
rm -f logs/*.log
```

---

## 📊 EXEMPLE D'UTILISATION COMPLÈTE

### Scénario : Trouver la meilleure offre pour Lyon

1. **Lancer le système :**
   ```bash
   ./start-multi-rest.sh
   ```

2. **Dans le Client CLI, choisir l'option 1 (Rechercher)**
   - Adresse : Lyon
   - Dates : 2025-12-01 → 2025-12-05

3. **Observer les résultats :**
   - Lyon via Agence 1 : **86.25€** (coef 1.15)
   - Lyon via Agence 2 : **90€** (coef 1.20)
   - **Économie : 3.75€** avec Agence 1 !

4. **Réserver via l'option 2**
   - Choisir une chambre Lyon de l'Agence 1
   - Remplir les informations client

5. **Quitter proprement :**
   - Option 6 dans le menu
   - Puis : `./stop-multi-rest.sh`

---

## 🎯 RÉCAPITULATIF DES COMMANDES

| Action | Commande |
|--------|----------|
| **Démarrer tout** | `./start-multi-rest.sh` |
| **Arrêter tout** | `./stop-multi-rest.sh` |
| **Tester la config** | `./test-configuration-finale.sh` |
| **Voir les logs** | `tail -f logs/agence.log` |
| **Nettoyer** | `rm -f logs/*.log` |

---

**Version :** 2.0 - Multi-Agences REST  
**Date :** 26 novembre 2025  
**Statut :** ✅ Opérationnel

