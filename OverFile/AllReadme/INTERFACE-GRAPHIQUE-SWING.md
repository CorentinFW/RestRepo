# 🎨 INTERFACE GRAPHIQUE SWING - NOUVELLE FONCTIONNALITÉ

## 🎉 CLI Remplacé par une Interface Graphique !

Le client en ligne de commande (CLI) a été **remplacé par une interface graphique moderne** utilisant **Java Swing**.

---

## ✨ Nouvelle Interface

### Vue d'ensemble

L'application dispose maintenant d'une **fenêtre graphique** complète avec :

```
┌─────────────────────────────────────────────────────────┐
│  Système de Réservation Multi-Agences            [_][□][X]│
├─────────────────────────────────────────────────────────┤
│  Fichier   Actions   Aide                              │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  ┌─ Recherche de Chambres ─────────────────────────┐   │
│  │ Adresse: [________]  Date arrivée: [__________]│   │
│  │ Date départ: [____]  Prix min: [__] max: [___]│   │
│  │ Étoiles: [__]  Lits: [__]                       │   │
│  │                            [🗑 Effacer][🔍 Rechercher] │
│  └──────────────────────────────────────────────────┘   │
│                                                          │
│  ┌─ Résultats de Recherche ───────────────────────┐   │
│  │ ID │ Chambre │ Hôtel │ Adresse │ Agence │ Prix│   │
│  │────┼─────────┼───────┼─────────┼────────┼────│   │
│  │ 1  │ Simple  │ Paris │ 10 Rue  │ Ag.1   │ 92€│   │
│  │ 11 │ Standard│ Lyon  │ 25 Place│ Ag.1   │86.25│   │
│  │ ...│         │       │         │        │    │   │
│  │            [📝 Réserver la chambre sélectionnée]    │
│  └──────────────────────────────────────────────────┘   │
│                                                          │
│  ┌─ Console ──────────────────────────────────────┐   │
│  │ [17:54:00] ✓ Connexion établie                 │   │
│  │ [17:54:15] 🔍 Recherche de chambres...         │   │
│  │ [17:54:16] ✓ 20 chambre(s) trouvée(s)         │   │
│  └──────────────────────────────────────────────────┘   │
│                                                          │
│  Prêt                                                    │
└─────────────────────────────────────────────────────────┘
```

---

## 📋 Fonctionnalités de l'Interface

### 🔍 Recherche de Chambres

**Panneau de recherche avec champs :**
- Adresse (ville)
- Date d'arrivée (YYYY-MM-DD)
- Date de départ (YYYY-MM-DD)
- Prix minimum et maximum
- Nombre d'étoiles
- Nombre de lits minimum

**Boutons :**
- 🔍 **Rechercher** - Lance la recherche
- 🗑 **Effacer** - Efface tous les champs

### 📊 Tableau des Résultats

**Colonnes affichées :**
- ID de la chambre
- Nom de la chambre
- Nom de l'hôtel
- Adresse
- Agence
- Prix (€)
- Nombre de lits
- Image (icône)

**Actions :**
- **Clic simple** : Sélectionne une chambre
- **Double-clic** : Ouvre la fenêtre de réservation
- **Bouton Réserver** : Réserve la chambre sélectionnée

### 📝 Fenêtre de Réservation

Une **boîte de dialogue** s'ouvre avec :
- Nom
- Prénom
- Numéro de carte bancaire
- Date d'arrivée (pré-remplie)
- Date de départ (pré-remplie)
- Prix total

**Boutons :** OK / Annuler

### 📊 Console

**Affiche les logs en temps réel :**
- Connexions
- Recherches
- Réservations
- Erreurs

**Format :** `[HH:mm:ss] Message`

### 📍 Barre de Statut

**Affiche l'état actuel :**
- "Prêt"
- "Recherche en cours..."
- "X résultat(s)"
- "Réservation en cours..."
- Etc.

---

## 🎮 Menu de l'Application

### Menu Fichier
- **Quitter** - Ferme l'application

### Menu Actions
- **Rechercher des chambres** (Ctrl+R)
- **Réserver une chambre** (Ctrl+B)
- **Voir les réservations** (Ctrl+V)
- **Hôtels disponibles**

### Menu Aide
- **À propos** - Informations sur l'application

---

## 🚀 Lancement de l'Interface Graphique

### Méthode 1 : Script de démarrage

```bash
cd /home/corentinfay/Bureau/RestRepo
./start-multi-rest.sh
```

Le script démarre automatiquement :
1. Les 3 hôtels
2. Les 2 agences
3. **L'interface graphique** (fenêtre Swing)

### Méthode 2 : Démarrage manuel

```bash
cd /home/corentinfay/Bureau/RestRepo/Client
mvn spring-boot:run
```

Une fenêtre graphique s'ouvre automatiquement.

---

## 💡 Utilisation

### Scénario 1 : Rechercher et Réserver

1. **Remplir les critères** de recherche
   - Exemple : Ville "Lyon", dates "2025-12-01" à "2025-12-05"

2. **Cliquer sur "🔍 Rechercher"**
   - La console affiche : "🔍 Recherche de chambres..."
   - Les résultats apparaissent dans le tableau

3. **Sélectionner une chambre** dans le tableau
   - Clic simple pour sélectionner

4. **Double-cliquer ou cliquer sur "📝 Réserver"**
   - Une fenêtre de réservation s'ouvre

5. **Remplir les informations**
   - Nom, prénom, carte, dates

6. **Cliquer sur "OK"**
   - La console affiche : "📝 Réservation en cours..."
   - Un message de confirmation apparaît

### Scénario 2 : Voir les Réservations

1. **Menu Actions** → **Voir les réservations** (ou Ctrl+V)

2. **Une fenêtre s'ouvre** avec la liste des réservations par hôtel

3. **Cliquer sur "OK"** pour fermer

### Scénario 3 : Voir les Hôtels

1. **Menu Actions** → **Hôtels disponibles**

2. **Une fenêtre affiche** la liste des hôtels

---

## 🎨 Avantages de l'Interface Graphique

### Par rapport au CLI :

| Aspect | CLI | GUI Swing |
|--------|-----|-----------|
| **Facilité d'utilisation** | ⭐⭐ | ⭐⭐⭐⭐⭐ |
| **Visualisation** | Texte seulement | Tableau interactif |
| **Sélection** | Numéro à taper | Clic de souris |
| **Navigation** | Séquentielle | Libre |
| **Multitâche** | Non | Oui (fenêtres) |
| **Ergonomie** | Basique | Moderne |
| **Accessibilité** | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ |

### Fonctionnalités ajoutées :

1. ✅ **Tri des colonnes** - Clic sur les en-têtes
2. ✅ **Sélection visuelle** - Clic sur les lignes
3. ✅ **Double-clic rapide** - Pour réserver
4. ✅ **Raccourcis clavier** - Ctrl+R, Ctrl+B, Ctrl+V
5. ✅ **Console temps réel** - Logs visibles
6. ✅ **Barre de statut** - État de l'application
7. ✅ **Fenêtres modales** - Pour réservations/infos
8. ✅ **Async** - Interface reste réactive

---

## 🔧 Architecture Technique

### Classe Principale

**Fichier :** `Client/src/main/java/org/tp1/client/gui/ClientGUI.java`

**Composants Swing utilisés :**
- `JFrame` - Fenêtre principale
- `JTable` - Tableau des résultats
- `JTextField` - Champs de saisie
- `JTextArea` - Console
- `JButton` - Boutons d'action
- `JMenuBar` - Barre de menu
- `JOptionPane` - Boîtes de dialogue
- `SwingWorker` - Tâches asynchrones

### Modification de ClientApplication

**Fichier :** `Client/src/main/java/org/tp1/client/ClientApplication.java`

**Changement :**
```java
// Avant (CLI)
ClientCLIRest cli = context.getBean(ClientCLIRest.class);
cli.run();

// Après (GUI)
ClientGUI gui = context.getBean(ClientGUI.class);
gui.run();
```

### SwingWorker pour l'Async

**Toutes les opérations réseau** utilisent `SwingWorker` :
- Recherche de chambres
- Réservations
- Récupération des réservations
- Liste des hôtels

**Avantage :** L'interface reste réactive pendant les appels réseau.

---

## 📊 Comparaison Avant/Après

### Avant (CLI)

```
═══ MENU PRINCIPAL ═══
1. Rechercher des chambres
2. Effectuer une réservation
...
Votre choix: _
```

**Problèmes :**
- Navigation séquentielle
- Pas de visualisation globale
- Pas de retour en arrière facile
- Saisie manuelle obligatoire

### Après (GUI)

**Fenêtre graphique moderne avec :**
- ✅ Tout visible en même temps
- ✅ Formulaire de recherche toujours accessible
- ✅ Résultats dans un tableau
- ✅ Actions par boutons et menus
- ✅ Console de logs intégrée
- ✅ Barre de statut

---

## 🎯 Fichiers Modifiés/Créés

### Nouveaux Fichiers

| Fichier | Description |
|---------|-------------|
| `Client/src/main/java/org/tp1/client/gui/ClientGUI.java` | Interface graphique Swing |

### Fichiers Modifiés

| Fichier | Modification |
|---------|--------------|
| `Client/src/main/java/org/tp1/client/ClientApplication.java` | Lance GUI au lieu de CLI |

### Fichiers Conservés (Non Supprimés)

| Fichier | Statut |
|---------|--------|
| `Client/src/main/java/org/tp1/client/cli/ClientCLIRest.java` | ⚠️ Conservé mais non utilisé |

---

## 🚀 Pour Utiliser la GUI

### Étape 1 : Compiler

```bash
cd /home/corentinfay/Bureau/RestRepo/Client
mvn clean package -DskipTests
```

### Étape 2 : Démarrer le système

```bash
cd /home/corentinfay/Bureau/RestRepo
./start-multi-rest.sh
```

**Une fenêtre graphique s'ouvre !** 🎉

### Étape 3 : Utiliser l'interface

1. Remplir les critères de recherche
2. Cliquer sur "🔍 Rechercher"
3. Sélectionner une chambre
4. Double-cliquer ou "📝 Réserver"

---

## 💡 Astuces

### Raccourcis Clavier

- **Ctrl+R** : Rechercher
- **Ctrl+B** : Réserver
- **Ctrl+V** : Voir réservations

### Navigation Rapide

- **Tab** : Passer au champ suivant
- **Enter** : Valider un formulaire
- **Double-clic** : Réserver rapidement

### Console

- **Scroll automatique** : Vers le bas
- **Horodatage** : [HH:mm:ss]
- **Icônes** : ✓ (succès), ✗ (erreur), 🔍 (recherche), etc.

---

## ✅ Résumé

### Avant
❌ Interface CLI texte uniquement
❌ Navigation séquentielle
❌ Pas de visualisation globale

### Après
✅ **Interface graphique moderne**
✅ **Tableau interactif**
✅ **Menus et raccourcis**
✅ **Console de logs intégrée**
✅ **Opérations asynchrones**
✅ **Fenêtres modales**

---

**Date :** 26 novembre 2025  
**Version :** 2.0 - Interface Graphique Swing  
**Technologie :** Java Swing + Spring Boot  
**Statut :** ✅ **FONCTIONNEL**

