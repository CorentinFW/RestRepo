# ✅ SOLUTION - Interface Fonctionne Mais Pas de Données

## 🐛 Le Problème

L'interface graphique s'ouvre correctement, mais :
- ❌ Aucune chambre trouvée lors des recherches
- ❌ Impossible de se connecter aux agences

**Cause :** Les **services backend** (hôtels et agences) ne sont **pas démarrés** !

---

## ✅ Solution : Démarrer le Système Complet

### 🚀 Commande Unique (RECOMMANDÉ)

```bash
cd /home/corentinfay/Bureau/RestRepo
./start-system-complete-gui.sh
```

**Ce script fait TOUT automatiquement :**

1. ✅ Démarre les 3 hôtels (Paris, Lyon, Montpellier)
2. ✅ Démarre les 2 agences (Agence 1 et 2)
3. ✅ Attend que tout soit prêt
4. ✅ Ouvre l'interface graphique
5. ✅ Tout fonctionne !

---

## 📊 Ce Qui Se Passe

```
┌─ Démarrage Automatique ────────────────────┐
│                                             │
│  1. 🏨 Hôtel Paris (8082)      → 10 sec    │
│  2. 🏨 Hôtel Lyon (8083)       → 10 sec    │
│  3. 🏨 Hôtel Montpellier (8084)→ 10 sec    │
│                                             │
│  4. 🏢 Agence 1 (8081)         → 10 sec    │
│  5. 🏢 Agence 2 (8085)         → 10 sec    │
│                                             │
│  6. ⏳ Attente stabilisation   → 15 sec    │
│                                             │
│  7. 🎨 Interface GUI           → S'ouvre   │
│                                             │
└─────────────────────────────────────────────┘
```

**Temps total : ~1 minute**

---

## ✅ Vérification

### Dans l'Interface GUI

**1. Connexion aux agences**
```
Console :
[HH:mm:ss] ✓ Connexion établie: Multi-Agence REST Client
```

**2. Recherche de chambres**
- Remplir : Ville "Lyon", Dates "2025-12-01" → "2025-12-05"
- Cliquer sur "🔍 Rechercher"
- **Résultat attendu : 20 chambres**
  - 5 Paris (Agence 1)
  - 10 Lyon (5 + 5)
  - 5 Montpellier (Agence 2)

---

## 🔧 Démarrage Manuel (Alternative)

Si vous préférez démarrer service par service :

### Terminal 1 : Hôtels

```bash
cd /home/corentinfay/Bureau/RestRepo/Hotellerie

# Paris
mvn spring-boot:run -Dspring-boot.run.profiles=paris
```

### Terminal 2 : Hôtel Lyon

```bash
cd /home/corentinfay/Bureau/RestRepo/Hotellerie
mvn spring-boot:run -Dspring-boot.run.profiles=lyon
```

### Terminal 3 : Hôtel Montpellier

```bash
cd /home/corentinfay/Bureau/RestRepo/Hotellerie
mvn spring-boot:run -Dspring-boot.run.profiles=montpellier
```

### Terminal 4 : Agence 1

```bash
cd /home/corentinfay/Bureau/RestRepo/Agence
mvn spring-boot:run -Dspring-boot.run.profiles=agence1
```

### Terminal 5 : Agence 2

```bash
cd /home/corentinfay/Bureau/RestRepo/Agence
mvn spring-boot:run -Dspring-boot.run.profiles=agence2
```

### Terminal 6 : Client GUI

```bash
cd /home/corentinfay/Bureau/RestRepo
./start-gui-swing.sh
```

---

## 📝 Services Requis

| Service | Port | Statut Requis |
|---------|------|---------------|
| Hôtel Paris | 8082 | ✅ Doit tourner |
| Hôtel Lyon | 8083 | ✅ Doit tourner |
| Hôtel Montpellier | 8084 | ✅ Doit tourner |
| Agence 1 | 8081 | ✅ Doit tourner |
| Agence 2 | 8085 | ✅ Doit tourner |
| **Client GUI** | - | Lance après les autres |

---

## 🛑 Arrêter le Système

```bash
# Arrêter tous les services backend
pkill -f 'java.*Agence'
pkill -f 'java.*Hotellerie'

# L'interface GUI se ferme normalement avec la croix
```

---

## 🔍 Diagnostic

### Vérifier que les services tournent

```bash
ps aux | grep -E 'Agence|Hotellerie' | grep java | grep -v grep
```

**Résultat attendu : 5 lignes** (3 hôtels + 2 agences)

### Tester les services

```bash
# Test Hôtel Paris
curl http://localhost:8082/api/hotel/chambres

# Test Agence 1
curl -X POST http://localhost:8081/api/agence/chambres/rechercher \
  -H "Content-Type: application/json" \
  -d '{"dateArrive":"2025-12-01","dateDepart":"2025-12-05"}'
```

---

## ✅ Résumé

### Problème
❌ Interface GUI s'ouvre mais ne trouve aucune chambre

### Cause
❌ Services backend (hôtels + agences) pas démarrés

### Solution
✅ **Utiliser le script complet :**

```bash
./start-system-complete-gui.sh
```

**Ce script démarre TOUT dans le bon ordre !**

---

## 🎯 Exemple d'Utilisation Complète

**1. Démarrer le système**
```bash
cd /home/corentinfay/Bureau/RestRepo
./start-system-complete-gui.sh
```

**2. Attendre l'ouverture de la fenêtre** (~1 minute)

**3. Dans l'interface GUI**
- Menu Actions → Rechercher des chambres (Ctrl+R)
- Ou remplir le formulaire directement
- Ville : Lyon
- Dates : 2025-12-01 → 2025-12-05
- Cliquer "🔍 Rechercher"

**4. Résultat**
```
✓ 20 chambre(s) trouvée(s)

Tableau avec :
- 5 chambres Paris
- 10 chambres Lyon (dont 5 en doublon)
- 5 chambres Montpellier
```

**5. Réserver**
- Sélectionner une chambre (clic)
- Double-clic ou bouton "📝 Réserver"
- Remplir le formulaire
- OK

**6. Confirmation**
```
✓ Réservation confirmée!
ID: ...
```

---

**Fichier créé :** `start-system-complete-gui.sh`  
**Commande :** `./start-system-complete-gui.sh`  
**Temps :** ~1 minute pour tout démarrer  
**Résultat :** ✅ Tout fonctionne !

