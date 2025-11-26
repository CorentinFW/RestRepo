# 🏨 Système de Réservation Multi-Agences - Interface Graphique

## 🚀 DÉMARRAGE RAPIDE (1 Commande)

```bash
./start-system-maven.sh
```

**Temps : ~20 secondes → Une fenêtre graphique s'ouvre avec 20 chambres disponibles !**

**Pour arrêter :**
```bash
./arreter-services.sh
```

---

## 📋 Prérequis

- ✅ Java 11+ 
- ✅ Maven 3.6+
- ✅ Ubuntu avec interface graphique (ou tout OS avec X11)

---

## 🎯 Architecture

```
CLIENT GUI (Interface Swing)
      │
      ├──> AGENCE 1 (Paris Voyages - 8081)
      │    ├─> Hôtel Paris (8082)
      │    └─> Hôtel Lyon (8083)
      │
      └──> AGENCE 2 (Sud Réservations - 8085)
           ├─> Hôtel Lyon (8083) [Partagé]
           └─> Hôtel Montpellier (8084)
```

**Résultat :** 20 chambres disponibles (5 Paris + 10 Lyon + 5 Montpellier)

---

## 🎮 Utilisation de l'Interface

### Démarrage

```bash
./start-system-maven.sh
```

**Le script démarre automatiquement :**
- Les 3 hôtels (Paris, Lyon, Montpellier)
- Les 2 agences (Agence 1, Agence 2)
- L'interface graphique Swing

### Recherche de Chambres

1. Remplir le formulaire (ville, dates, critères)
2. Cliquer sur "🔍 Rechercher"
3. Les résultats apparaissent dans le tableau

**Exemple :**
- Ville : Lyon
- Dates : 2025-12-01 → 2025-12-05
- **Résultat : 10 chambres**

### Afficher les Images

**Cliquer sur l'icône 🖼 dans le tableau**

→ Une fenêtre s'ouvre avec l'image de la chambre en grand format !

### Réservation

1. Sélectionner une chambre dans le tableau
2. Double-cliquer ou bouton "📝 Réserver"
3. Remplir le formulaire client
4. Valider

### Arrêter le Système

```bash
./arreter-services.sh
```

### Menus

- **Fichier** → Quitter
- **Actions** → Rechercher (Ctrl+R), Réserver (Ctrl+B), Voir réservations (Ctrl+V)
- **Aide** → À propos

---

## 📂 Structure du Projet

```
RestRepo/
├── compile-all.sh                    ⭐ Compiler tous les modules
├── start-system-complete-gui.sh      ⭐ Démarrer tout le système
├── GUIDE-FINAL-DEMARRAGE.md          📖 Guide complet
│
├── Hotellerie/                       🏨 Module Hôtels
│   └── target/Hotellerie-*.jar
│
├── Agence/                           🏢 Module Agences  
│   └── target/Agence-*.jar
│
├── Client/                           🖥️ Interface Graphique
│   └── target/Client-*.jar
│
├── logs/                             📝 Logs des services
│   ├── hotel-paris.log
│   ├── hotel-lyon.log
│   ├── hotel-montpellier.log
│   ├── agence.log
│   └── agence2.log
│
└── OverFile/                         📁 Documentation archivée
    ├── AllReadme/                    📚 Tous les .md
    └── BashSh/                       🔧 Scripts archivés
```

---

## ✨ Fonctionnalités

### Interface Graphique Swing

- ✅ Formulaire de recherche graphique
- ✅ Tableau interactif des résultats
- ✅ Réservation en quelques clics
- ✅ Console de logs en temps réel
- ✅ Menus et raccourcis clavier
- ✅ Comparaison de prix multi-agences

### Multi-Agences

- ✅ 2 agences interrogées en parallèle
- ✅ Comparaison de prix automatique
- ✅ Hôtel Lyon partagé entre les 2 agences
- ✅ Coefficients différents (1.15 vs 1.20)

### Données

- ✅ 3 hôtels (Paris, Lyon, Montpellier)
- ✅ 5 chambres par hôtel
- ✅ 20 chambres visibles au total
- ✅ Images des chambres

---

## 🛑 Arrêter le Système

### Fermer l'Interface

Cliquer sur la croix (X) de la fenêtre.

### Arrêter les Services Backend

```bash
pkill -f 'java.*Agence'
pkill -f 'java.*Hotellerie'
```

---

## 📖 Documentation

- **GUIDE-FINAL-DEMARRAGE.md** - Guide complet de démarrage
- **OverFile/AllReadme/** - Toute la documentation du projet
- **DIAGNOSTIC-COMPLET-CLIENT.md** - Diagnostic et dépannage

---

## 🔧 Développement

### Démarrage avec Maven (Recommandé)

**Un seul script pour tout :**
```bash
./start-system-maven.sh
```

**Logs dans :** `logs/*.log`

---

### Démarrage Manuel (6 Terminaux)

**Pour développement/débogage avec logs visibles :**

```bash
# Afficher les commandes
./afficher-commandes.sh

# Puis dans 6 terminaux :
# Terminal 1-3 : Les 3 hôtels avec Maven
# Terminal 4-5 : Les 2 agences avec Maven  
# Terminal 6 : Le client GUI
```

---

### Recompiler Après Modifications

```bash
./compile-all.sh
```

---

## ✅ Test de Fonctionnement

### Test 1 : Recherche Lyon

**Critères :**
- Ville : Lyon
- Dates : 2025-12-01 → 2025-12-05

**Résultat attendu :** 10 chambres

### Test 2 : Recherche Paris

**Critères :**
- Ville : Paris
- Dates : 2025-12-01 → 2025-12-05

**Résultat attendu :** 5 chambres (via Agence 1 uniquement)

### Test 3 : Recherche Sans Critère

**Critères :**
- Aucun critère
- Dates : 2025-12-01 → 2025-12-05

**Résultat attendu :** 20 chambres

---

## 🐛 Dépannage

### Problème : "Aucune chambre trouvée"

**Cause :** Services backend pas démarrés

**Solution :**
```bash
# Vérifier les services
ps aux | grep -E 'java.*Agence|java.*Hotellerie' | grep -v grep

# Si vide, relancer
./start-system-complete-gui.sh
```

### Problème : "BUILD FAILURE"

**Cause :** Erreur de compilation

**Solution :**
```bash
# Nettoyer et recompiler
cd Hotellerie && mvn clean && cd ..
cd Agence && mvn clean && cd ..
cd Client && mvn clean && cd ..
./compile-all.sh
```

### Problème : "HeadlessException"

**Cause :** Mode headless activé

**Solution :** Déjà corrigé dans le code. Si persiste :
```bash
export DISPLAY=:0
./start-system-complete-gui.sh
```

---

## 📊 Ports Utilisés

| Service | Port | Description |
|---------|------|-------------|
| Hôtel Paris | 8082 | 5 chambres |
| Hôtel Lyon | 8083 | 5 chambres |
| Hôtel Montpellier | 8084 | 5 chambres |
| Agence 1 | 8081 | Paris + Lyon (coef 1.15) |
| Agence 2 | 8085 | Lyon + Montpellier (coef 1.20) |

---

## 🎉 Version

- **Version :** 2.0 - Interface Graphique Swing
- **Date :** 26 novembre 2025
- **Architecture :** REST avec Spring Boot
- **Interface :** Java Swing
- **Statut :** ✅ Production Ready

---

## 🚀 COMMANDES ESSENTIELLES

```bash
# Démarrer le système complet (Maven)
./start-system-maven.sh

# Arrêter tous les services
./arreter-services.sh

# Voir les logs en temps réel
tail -f logs/hotel-paris.log
tail -f logs/agence1.log

# Nettoyer les services et ports
./nettoyer-services.sh

# Compiler tous les modules (si modifications)
./compile-all.sh
```

---

**Prêt à utiliser !** 🎨✨

