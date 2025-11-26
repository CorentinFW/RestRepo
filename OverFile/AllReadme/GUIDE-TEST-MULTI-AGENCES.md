# 🚀 Guide de Test - Système Multi-Agences

## ✅ Étape 1 : Démarrer le système complet

```bash
cd /home/corentinfay/Bureau/RestRepo
./start-multi-agences.sh
```

Le système va démarrer dans cet ordre :
1. ⏳ 3 Hôtels (Paris, Lyon, Montpellier) - 5 secondes
2. ⏳ Agence 1 (Paris Voyages) - 3 secondes
3. ⏳ Agence 2 (Sud Réservations) - 3 secondes
4. ✅ Client (interface CLI)

**Temps total de démarrage : ~15 secondes**

---

## 🧪 Étape 2 : Tester la recherche multi-agences

### Test 1 : Recherche simple

Dans le CLI du client :

```
Votre choix: 1

Adresse (ville/rue) [optionnel]: (appuyer sur Entrée)
Date d'arrivée (YYYY-MM-DD): 2025-12-01
Date de départ (YYYY-MM-DD): 2025-12-05
Prix minimum [optionnel, Enter pour ignorer]: (appuyer sur Entrée)
Prix maximum [optionnel, Enter pour ignorer]: (appuyer sur Entrée)
Nombre d'étoiles (1-6) [optionnel, Enter pour ignorer]: (appuyer sur Entrée)
Nombre de lits minimum [optionnel, Enter pour ignorer]: (appuyer sur Entrée)
```

### ✅ Résultat attendu

Vous devriez voir :
- **Chambres de Paris** via Agence 1 uniquement (coef 1.15)
- **Chambres de Lyon** via Agence 1 ET Agence 2 (2 fois la même chambre avec prix différents)
- **Chambres de Montpellier** via Agence 2 uniquement (coef 1.20)

**Exemple :**
```
─── Chambre 1 ───
  🏨 Hôtel: Hôtel Paris
  📍 Adresse: Paris
  🏢 Agence: Agence Paris Voyages
  🚪 Chambre: Suite Présidentielle (ID: 1)
  💰 Prix: 287.50 €    ← Prix original 250€ × 1.15
  🛏️  Lits: 2
  🖼️  Image: http://localhost:8082/images/paris-hotel.jpg

─── Chambre 2 ───
  🏨 Hôtel: Hôtel Lyon
  📍 Adresse: Lyon
  🏢 Agence: Agence Paris Voyages
  🚪 Chambre: Chambre Deluxe (ID: 3)
  💰 Prix: 172.50 €    ← Prix original 150€ × 1.15
  🛏️  Lits: 2
  🖼️  Image: http://localhost:8083/images/lyon-hotel.jpg

─── Chambre 3 ───
  🏨 Hôtel: Hôtel Lyon
  📍 Adresse: Lyon
  🏢 Agence: Agence Sud Reservations    ← MÊME HÔTEL, AGENCE DIFFÉRENTE
  🚪 Chambre: Chambre Deluxe (ID: 3)
  💰 Prix: 180.00 €    ← Prix original 150€ × 1.20 (plus cher !)
  🛏️  Lits: 2
  🖼️  Image: http://localhost:8083/images/lyon-hotel.jpg

─── Chambre 4 ───
  🏨 Hôtel: Hôtel Montpellier
  📍 Adresse: Montpellier
  🏢 Agence: Agence Sud Reservations
  🚪 Chambre: Chambre Standard (ID: 5)
  💰 Prix: 96.00 €    ← Prix original 80€ × 1.20
  🛏️  Lits: 1
  🖼️  Image: http://localhost:8084/images/montpellier-hotel.jpg
```

---

## 🎯 Étape 3 : Vérifier les coefficients

### 📊 Calculs attendus

Si une chambre de Lyon coûte **150€** à la base :

| Agence | Coefficient | Prix affiché | Calcul |
|--------|-------------|--------------|--------|
| Agence 1 (Paris Voyages) | 1.15 | **172.50 €** | 150 × 1.15 |
| Agence 2 (Sud Réservations) | 1.20 | **180.00 €** | 150 × 1.20 |

**Différence : 7.50 €** 💰

---

## 🏨 Étape 4 : Tester la réservation

### Réserver via Agence 1 (moins cher)

```
Votre choix: 2

Numéro de la chambre à réserver (1-X): 2    ← Chambre Lyon via Agence 1

Nom: Dupont
Prénom: Jean
Numéro de carte bancaire: 1234567890123456
Date d'arrivée (YYYY-MM-DD): 2025-12-01
Date de départ (YYYY-MM-DD): 2025-12-05

Confirmer la réservation ? (o/n): o
```

### ✅ Résultat attendu

```
✓ Réservation effectuée avec succès!
  ID de réservation: 1
  Message: Réservation confirmée pour Chambre Deluxe
```

La réservation est envoyée à **Agence 1**, qui la transmet à **Hôtel Lyon**.

---

## 📋 Étape 5 : Afficher les chambres réservées

```
Votre choix: 5
```

### ✅ Résultat attendu

```
═══ CHAMBRES RÉSERVÉES PAR HÔTEL ═══

🏨 Hôtel Lyon
──────────────────────────────────────────────────
  🚪 Chambre Deluxe (ID: 3)
     💰 Prix: 172.50 €
     🛏️  Lits: 2
     🏢 Agence: Agence Paris Voyages    ← Réservé via Agence 1
     🖼️  Image: http://localhost:8083/images/lyon-hotel.jpg

✓ Total: 1 chambre(s) réservée(s)
```

---

## 🔍 Étape 6 : Vérifier les logs

### Logs des agences

```bash
# Agence 1
tail -f logs/agence1.log

# Agence 2
tail -f logs/agence2.log
```

### ✅ Ce que vous devriez voir

**Dans agence1.log :**
```
═══════════════════════════════════════════
  Agence Paris Voyages - Configuration REST
  Coefficient de prix: 1.15
  Nombre d'hôtels: 2
  - Hôtel Paris: http://localhost:8082
  - Hôtel Lyon: http://localhost:8083
═══════════════════════════════════════════
```

**Dans agence2.log :**
```
═══════════════════════════════════════════
  Agence Sud Reservations - Configuration REST
  Coefficient de prix: 1.20
  Nombre d'hôtels: 2
  - Hôtel Lyon: http://localhost:8083
  - Hôtel Montpellier: http://localhost:8084
═══════════════════════════════════════════
```

---

## 🎓 Points clés à vérifier

### ✅ Checklist de validation

- [ ] **Hôtel Paris** : Visible uniquement via Agence 1
- [ ] **Hôtel Lyon** : Visible via Agence 1 ET Agence 2 (doublons)
- [ ] **Hôtel Montpellier** : Visible uniquement via Agence 2
- [ ] **Coefficients** : Prix différents pour la même chambre Lyon
- [ ] **Affichage agence** : Nom de l'agence visible pour chaque chambre
- [ ] **Réservation** : Fonctionne via l'agence sélectionnée
- [ ] **Images** : URLs d'images affichées correctement

---

## 🛑 Arrêter le système

```bash
# Arrêter tous les services Java
pkill -f 'java.*Hotellerie'
pkill -f 'java.*Agence'

# Ou redémarrer complètement
./start-multi-agences.sh
```

---

## 🐛 En cas de problème

### Problème : Le client ne se connecte pas aux agences

**Solution :**
```bash
# Vérifier que les agences sont démarrées
ps aux | grep java

# Vérifier les ports
netstat -tuln | grep -E '8081|8085'

# Redémarrer les agences
pkill -f 'java.*Agence'
./start-agence1.sh
./start-agence2.sh
```

### Problème : Pas de chambres trouvées

**Solution :**
```bash
# Vérifier que les hôtels sont démarrés
ps aux | grep Hotellerie

# Vérifier les ports des hôtels
netstat -tuln | grep -E '8082|8083|8084'

# Redémarrer les hôtels
pkill -f 'java.*Hotellerie'
./start-hotel.sh
```

### Problème : Erreur de compilation

**Solution :**
```bash
# Recompiler tous les projets
cd Agence && mvn clean package -DskipTests
cd ../Client && mvn clean package -DskipTests
cd ../Hotellerie && mvn clean package -DskipTests
```

---

## 📊 Architecture résumée

```
CLIENT (MultiAgenceRestClient)
    │
    ├─── Agence 1 (8081, coef: 1.15)
    │       ├─── Paris (8082)
    │       └─── Lyon (8083) ◄─┐
    │                           │ PARTAGÉ
    └─── Agence 2 (8085, coef: 1.20)
            ├─── Lyon (8083) ◄─┘
            └─── Montpellier (8084)
```

---

## 🎉 Succès !

Si vous pouvez :
1. ✅ Voir des chambres de 3 hôtels différents
2. ✅ Voir Lyon apparaître 2 fois (une fois par agence)
3. ✅ Voir des prix différents pour la même chambre Lyon
4. ✅ Voir le nom de l'agence pour chaque chambre
5. ✅ Effectuer une réservation

**Le système multi-agences fonctionne parfaitement !** 🚀

---

**Prochaines étapes possibles :**
- Ajouter une 3ème agence
- Modifier les coefficients
- Ajouter plus d'hôtels partagés
- Implémenter un système de notation/avis

**Date :** 2025-11-26

