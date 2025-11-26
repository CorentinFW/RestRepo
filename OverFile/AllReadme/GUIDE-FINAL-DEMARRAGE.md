# ✅ GUIDE COMPLET - Démarrage du Système

## 🎯 Ce Qu'il Fallait Faire AVANT

**PROBLÈME :** Le script `start-system-complete-gui.sh` ne fonctionnait pas car les modules **n'étaient pas compilés** !

**SOLUTION :** Il faut **compiler d'abord**, puis démarrer.

---

## 🚀 PROCÉDURE COMPLÈTE (2 Étapes)

### ÉTAPE 1 : Compilation (À Faire UNE SEULE FOIS)

```bash
cd /home/corentinfay/Bureau/RestRepo
./compile-all.sh
```

**Ce script compile :**
- ✅ Hotellerie (module hôtels)
- ✅ Agence (module agences)
- ✅ Client (interface graphique)

**Temps : ~10 secondes**

**Résultat :**
```
✅ Hotellerie compilé avec succès
✅ Agence compilé avec succès
✅ Client compilé avec succès

✅ TOUS LES MODULES SONT COMPILÉS
```

---

### ÉTAPE 2 : Démarrage du Système

```bash
cd /home/corentinfay/Bureau/RestRepo
./start-system-complete-gui.sh
```

**Ce script démarre :**
1. ✅ Les 3 hôtels (Paris, Lyon, Montpellier)
2. ✅ Les 2 agences (Agence 1, Agence 2)
3. ✅ L'interface graphique

**Temps : ~1 minute**

---

## 📋 Résumé des Commandes

### Première Fois (Compilation + Démarrage)

```bash
cd /home/corentinfay/Bureau/RestRepo

# 1. Compiler (une seule fois)
./compile-all.sh

# 2. Démarrer le système
./start-system-complete-gui.sh
```

### Les Fois Suivantes (Démarrage Uniquement)

```bash
cd /home/corentinfay/Bureau/RestRepo
./start-system-complete-gui.sh
```

**Note :** Vous n'avez besoin de recompiler que si vous modifiez le code source.

---

## ✅ Vérification

### Après la Compilation

Vérifier que les JARs existent :
```bash
ls -lh Hotellerie/target/*.jar
ls -lh Agence/target/*.jar
ls -lh Client/target/*.jar
```

**Résultat attendu :** 6 fichiers JAR (2 par module)

### Après le Démarrage

**1. L'interface graphique s'ouvre**

**2. Dans la console de l'interface :**
```
[HH:mm:ss] ✓ Connexion établie: Multi-Agence REST Client
```

**3. Faire une recherche :**
- Ville : Lyon
- Dates : 2025-12-01 → 2025-12-05
- Cliquer "🔍 Rechercher"

**4. Résultat :**
```
[HH:mm:ss] 🔍 Recherche de chambres...
[HH:mm:ss]    Critères: adresse=Lyon, dates=2025-12-01 → 2025-12-05
[HH:mm:ss]    Appel du client REST...
[HH:mm:ss] 🔍 Recherche dans 2 agences en parallèle...
[HH:mm:ss] ✓ [http://localhost:8081] Trouvé 5 chambre(s)
[HH:mm:ss] ✓ [http://localhost:8085] Trouvé 5 chambre(s)
[HH:mm:ss]    Réponse reçue: 10 chambre(s)
[HH:mm:ss] ✓ 10 chambre(s) trouvée(s)
```

**5. Le tableau affiche les 10 chambres Lyon !**

---

## 🛑 Arrêter le Système

### Fermer l'Interface

Cliquez sur la croix (X) de la fenêtre.

### Arrêter les Services Backend

```bash
pkill -f 'java.*Agence'
pkill -f 'java.*Hotellerie'
```

---

## 📊 Architecture Complète

```
┌─────────────────────────────────────────┐
│   ÉTAPE 1 : COMPILATION (Une fois)      │
├─────────────────────────────────────────┤
│                                         │
│  ./compile-all.sh                       │
│       │                                 │
│       ├─> Compile Hotellerie           │
│       ├─> Compile Agence               │
│       └─> Compile Client                │
│                                         │
│  Crée les JARs dans target/             │
└─────────────────────────────────────────┘
              ↓
┌─────────────────────────────────────────┐
│   ÉTAPE 2 : DÉMARRAGE (À chaque fois)   │
├─────────────────────────────────────────┤
│                                         │
│  ./start-system-complete-gui.sh         │
│       │                                 │
│       ├─> Démarre Hôtel Paris (8082)   │
│       ├─> Démarre Hôtel Lyon (8083)    │
│       ├─> Démarre Hôtel Montp. (8084)  │
│       ├─> Démarre Agence 1 (8081)      │
│       ├─> Démarre Agence 2 (8085)      │
│       └─> Ouvre Interface GUI           │
│                                         │
│  Tout fonctionne !                      │
└─────────────────────────────────────────┘
```

---

## 🔍 Dépannage

### Si la Compilation Échoue

```bash
# Nettoyer et recompiler
cd Hotellerie
mvn clean
cd ../Agence
mvn clean
cd ../Client
mvn clean
cd ..

# Recompiler
./compile-all.sh
```

### Si le Démarrage Échoue

**1. Vérifier que les JARs existent :**
```bash
ls -lh Agence/target/*.jar
```

**Si aucun fichier → Recompiler :**
```bash
./compile-all.sh
```

**2. Vérifier qu'aucun service ne tourne déjà :**
```bash
pkill -f 'java.*Agence'
pkill -f 'java.*Hotellerie'
```

**3. Relancer :**
```bash
./start-system-complete-gui.sh
```

---

## 📝 Scripts Disponibles

| Script | Usage | Quand |
|--------|-------|-------|
| **compile-all.sh** | Compile tous les modules | Une fois / Après modif code |
| **start-system-complete-gui.sh** | Démarre tout le système | À chaque utilisation |
| **start-gui-swing.sh** | Lance uniquement la GUI | Si services déjà actifs |

---

## ✅ RÉSUMÉ FINAL

### Pourquoi Ça Ne Marchait Pas Avant

❌ Les modules n'étaient **pas compilés**  
❌ Les fichiers JAR n'existaient pas  
❌ Le script de démarrage ne pouvait pas lancer les services

### Ce Qu'il Fallait Faire

✅ **Compiler d'abord** avec `./compile-all.sh`  
✅ **Puis démarrer** avec `./start-system-complete-gui.sh`

### Maintenant

✅ **Tout est compilé**  
✅ **Vous pouvez lancer** : `./start-system-complete-gui.sh`  
✅ **L'interface s'ouvre et trouve les 20 chambres !**

---

## 🚀 COMMANDES FINALES

```bash
# Aller dans le projet
cd /home/corentinfay/Bureau/RestRepo

# Démarrer le système complet
./start-system-complete-gui.sh

# Attendre ~1 minute
# → L'interface s'ouvre
# → Rechercher "Lyon"
# → 10 chambres apparaissent !
```

**C'est parti !** 🎉

---

**Date :** 26 novembre 2025  
**Scripts créés :**
- ✅ compile-all.sh (compilation)
- ✅ start-system-complete-gui.sh (démarrage complet)

**Étapes :**
1. Compiler : `./compile-all.sh` ✅ (FAIT)
2. Démarrer : `./start-system-complete-gui.sh` ← À FAIRE MAINTENANT

