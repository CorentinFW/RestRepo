# 🚀 GUIDE DE DÉMARRAGE RAPIDE - Système Multi-Agences REST

## ✅ Le système est opérationnel !

Tous les services sont démarrés et fonctionnent correctement :

### 📊 Services en cours d'exécution

| Service | Port | Statut | URL |
|---------|------|--------|-----|
| 🏨 **Hôtel Paris** | 8082 | ✅ EN LIGNE | http://localhost:8082 |
| 🏨 **Hôtel Lyon** | 8083 | ✅ EN LIGNE | http://localhost:8083 |
| 🏨 **Hôtel Montpellier** | 8084 | ✅ EN LIGNE | http://localhost:8084 |
| 🏢 **Agence 1 - Paris Voyages** | 8081 | ✅ EN LIGNE | http://localhost:8081 |
| 🏢 **Agence 2 - Sud Réservations** | 8085 | ✅ EN LIGNE | http://localhost:8085 |

---

## 🎯 Comment utiliser le système

### Option 1 : Interface CLI (Recommandée)

Le client CLI a été démarré automatiquement. Si vous voulez le relancer :

```bash
cd /home/corentinfay/Bureau/RestRepo/Client
./start-client.sh
```

**Menu principal :**
1. **Rechercher des chambres** - Compare les prix entre les 2 agences
2. **Effectuer une réservation** - Réserve une chambre
3. **Afficher les dernières chambres trouvées** - Revoit les résultats
4. **Afficher les hôtels disponibles** - Liste les hôtels
5. **Afficher les chambres réservées par hôtel** - Historique
6. **Quitter**

### Option 2 : API REST directe

#### Rechercher des chambres (Agence 1)

```bash
curl -X POST http://localhost:8081/api/agence/chambres/rechercher \
  -H "Content-Type: application/json" \
  -d '{"dateArrive":"2025-12-01","dateDepart":"2025-12-05"}'
```

#### Rechercher des chambres (Agence 2)

```bash
curl -X POST http://localhost:8085/api/agence/chambres/rechercher \
  -H "Content-Type: application/json" \
  -d '{"dateArrive":"2025-12-01","dateDepart":"2025-12-05"}'
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

---

## 🔍 Tester la différence de prix entre agences

### Chambre Lyon - Chambre Standard (ID: 11)

**Agence 1 (coef 1.15) :**
```bash
curl -s -X POST http://localhost:8081/api/agence/chambres/rechercher \
  -H "Content-Type: application/json" \
  -d '{"dateArrive":"2025-12-01","dateDepart":"2025-12-05"}' | \
  python3 -m json.tool | grep -A 8 '"id": 11'
```

**Résultat attendu :** Prix = 86.25€ (75€ × 1.15)

**Agence 2 (coef 1.20) :**
```bash
curl -s -X POST http://localhost:8085/api/agence/chambres/rechercher \
  -H "Content-Type: application/json" \
  -d '{"dateArrive":"2025-12-01","dateDepart":"2025-12-05"}' | \
  python3 -m json.tool | grep -A 8 '"id": 11'
```

**Résultat attendu :** Prix = 90€ (75€ × 1.20)

**💰 Économie : 3.75€ en choisissant l'Agence 1 !**

---

## 🎨 Architecture en fonctionnement

```
         CLIENT CLI
         (Multi-Agence)
              │
      ┌───────┴────────┐
      │                │
      ▼                ▼
  AGENCE 1         AGENCE 2
  (8081)           (8085)
  Coef: 1.15       Coef: 1.20
      │                │
  ┌───┴───┐        ┌───┴───┐
  │       │        │       │
  ▼       ▼        ▼       ▼
PARIS   LYON     LYON   MONTPEL.
(8082)  (8083)   (8083)  (8084)
        └──────────┘
         (Partagé)
```

---

## 🛑 Arrêter le système

### Arrêter tous les services

```bash
pkill -f 'java.*Hotellerie'
pkill -f 'java.*Agence'
pkill -f 'java.*Client'
```

### Vérifier que tout est arrêté

```bash
ps aux | grep -E 'java.*(Hotellerie|Agence|Client)' | grep -v grep
```

Si rien n'apparaît, tout est arrêté ✅

---

## 🔄 Redémarrer le système complet

```bash
cd /home/corentinfay/Bureau/RestRepo
./start-multi-agences.sh
```

**Le script démarre automatiquement dans cet ordre :**
1. Les 3 hôtels (Paris, Lyon, Montpellier)
2. L'Agence 1 (Paris Voyages)
3. L'Agence 2 (Sud Réservations)
4. Le Client CLI

**Temps de démarrage :** ~30-40 secondes

---

## 📝 Logs disponibles

```bash
# Hôtels
tail -f logs/hotel-paris.log
tail -f logs/hotel-lyon.log
tail -f logs/hotel-montpellier.log

# Agences
tail -f logs/agence.log       # Agence 1
tail -f logs/agence2.log      # Agence 2
```

---

## ✨ Fonctionnalités testées et validées

- ✅ **3 hôtels** sur ports 8082, 8083, 8084
- ✅ **2 agences** avec coefficients différents
- ✅ **Hôtel partagé** (Lyon) entre les 2 agences
- ✅ **Recherche multi-agences** en parallèle
- ✅ **Images** associées aux chambres
- ✅ **Réservations** fonctionnelles
- ✅ **Prix différenciés** selon l'agence
- ✅ **Affichage du nom de l'agence** pour chaque chambre

---

## 🎯 Cas d'usage typique

### Scénario : Chercher la meilleure offre pour Lyon

1. **Lancer le client CLI** : `cd Client && ./start-client.sh`
2. **Option 1** : Rechercher des chambres
3. **Dates** : 2025-12-01 → 2025-12-05
4. **Observer** : Les chambres de Lyon apparaissent 2 fois
   - Via Agence 1 à **86.25€** (coef 1.15)
   - Via Agence 2 à **90€** (coef 1.20)
5. **Choisir** : Réserver via Agence 1 pour économiser

**Résultat : Économie de 3.75€ par nuit !** 💰

---

## 📚 Documentation complète

- **LIVRAISON-MULTI-AGENCES.md** : Livraison complète du projet
- **MULTI-AGENCES-IMPLEMENTATION.md** : Documentation technique
- **GUIDE-TEST-MULTI-AGENCES.md** : Guide de test détaillé
- **README.md** : Documentation générale

---

## 🏆 Statut du projet

### ✅ SYSTÈME OPÉRATIONNEL

Tous les services sont démarrés et fonctionnent correctement. Le système est prêt pour :
- ✅ Tests manuels
- ✅ Tests automatisés
- ✅ Démonstrations
- ✅ Développement de nouvelles fonctionnalités

---

**Date :** 26 novembre 2025  
**Version :** 2.0 - Multi-Agences REST  
**Statut :** ✅ PRODUCTION READY

