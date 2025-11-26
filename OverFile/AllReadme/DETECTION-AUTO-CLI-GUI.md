# ✅ DÉTECTION AUTOMATIQUE CLI/GUI

## 🎯 Solution au Problème HeadlessException

Le client peut maintenant **détecter automatiquement** l'environnement et choisir entre :
- **GUI (Interface Graphique)** si un serveur X11 est disponible
- **CLI (Ligne de Commande)** si pas d'environnement graphique

---

## 🔧 Fonctionnement

### Détection Automatique

**Fichier :** `Client/src/main/java/org/tp1/client/ClientApplication.java`

```java
boolean isHeadless = GraphicsEnvironment.isHeadless();
boolean hasDisplay = System.getenv("DISPLAY") != null;

if (isHeadless) {
    // → Mode CLI
    ClientCLIRest cli = context.getBean(ClientCLIRest.class);
    cli.run();
} else {
    // → Mode GUI
    ClientGUI gui = context.getBean(ClientGUI.class);
    gui.run();
}
```

### Conditions

| Environnement | Mode Choisi |
|---------------|-------------|
| **Serveur X11 disponible** | ✅ GUI (Interface Graphique) |
| **Pas de serveur X11** | ✅ CLI (Ligne de Commande) |
| **SSH sans X11 forwarding** | ✅ CLI |
| **SSH avec X11 forwarding (-X)** | ✅ GUI |
| **Machine locale avec GUI** | ✅ GUI |

---

## 🚀 Utilisation

### Démarrage Normal (Automatique)

```bash
cd /home/corentinfay/Bureau/RestRepo
./start-multi-rest.sh
```

**Le système choisit automatiquement :**
- 🖥️ **GUI** si environnement graphique disponible
- ⌨️ **CLI** si pas d'environnement graphique

### Forcer le Mode CLI

```bash
cd /home/corentinfay/Bureau/RestRepo/Client
mvn spring-boot:run -Dspring-boot.run.arguments="--cli"
```

### Forcer le Mode GUI

```bash
cd /home/corentinfay/Bureau/RestRepo/Client
mvn spring-boot:run -Dspring-boot.run.arguments="--gui"
```

---

## 📊 Messages de Démarrage

### Mode GUI (Détecté)

```
╔═══════════════════════════════════════════════════════════════╗
║           MODE GUI - Interface Graphique                      ║
╚═══════════════════════════════════════════════════════════════╝

✓ Environnement graphique disponible
  → Ouverture de l'interface Swing...
```

### Mode CLI (Détecté)

```
╔═══════════════════════════════════════════════════════════════╗
║           MODE CLI - Interface Ligne de Commande             ║
╚═══════════════════════════════════════════════════════════════╝

ℹ️  Environnement sans interface graphique détecté
   → Utilisation du mode CLI
```

---

## 🎮 Interface CLI (Ligne de Commande)

Si le mode CLI est activé, vous verrez :

```
═══ MENU PRINCIPAL ═══
1. Rechercher des chambres
2. Effectuer une réservation
3. Afficher les dernières chambres trouvées
4. Afficher les hôtels disponibles
5. Afficher les chambres réservées par hôtel
6. Quitter

Votre choix: _
```

**Navigation :**
- Tapez le numéro de votre choix
- Suivez les instructions à l'écran
- Toutes les fonctionnalités sont disponibles

---

## 🖥️ Interface GUI (Graphique)

Si le mode GUI est activé, une **fenêtre Swing** s'ouvre avec :
- Formulaire de recherche
- Tableau interactif des résultats
- Console de logs
- Menus et raccourcis clavier

---

## 🛠️ Configuration de X11 (Pour GUI)

### Sur Votre Machine Locale

**Linux/Ubuntu :**
```bash
# Vérifier si X11 fonctionne
echo $DISPLAY
# Devrait afficher quelque chose comme :0

# Si vide, lancer X11
startx  # ou gdm / lightdm selon votre système
```

**macOS :**
```bash
# Installer XQuartz si pas déjà fait
brew install --cask xquartz

# Lancer XQuartz
open -a XQuartz

# Définir DISPLAY
export DISPLAY=:0
```

**Windows (WSL2) :**
```bash
# Installer un serveur X (VcXsrv, Xming, etc.)
# Puis définir DISPLAY
export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}'):0
```

### Via SSH avec X11 Forwarding

```bash
# Se connecter avec -X pour activer X11 forwarding
ssh -X user@server

# Ou avec -Y (trusted X11 forwarding)
ssh -Y user@server

# Vérifier que DISPLAY est défini
echo $DISPLAY
# Devrait afficher quelque chose comme localhost:10.0
```

---

## 📝 Arguments de Ligne de Commande

### --cli (Force le mode CLI)

```bash
mvn spring-boot:run -Dspring-boot.run.arguments="--cli"
```

**Utilisation :**
- Forcer le CLI même si GUI disponible
- Préférence personnelle pour le terminal
- Serveur sans GUI mais avec X11 installé

### --gui (Force le mode GUI)

```bash
mvn spring-boot:run -Dspring-boot.run.arguments="--gui"
```

**Utilisation :**
- Tenter d'utiliser GUI même en environnement headless
- ⚠️ Causera HeadlessException si pas de X11

---

## 🔍 Diagnostic

### Vérifier l'Environnement

```bash
# Vérifier si X11 est disponible
echo $DISPLAY

# Tester X11
xdpyinfo

# Vérifier Java headless
java -Djava.awt.headless=true --version
```

### Résultats

| Commande | Résultat | Mode |
|----------|----------|------|
| `echo $DISPLAY` | `:0` ou `localhost:10.0` | GUI possible |
| `echo $DISPLAY` | (vide) | CLI automatique |
| `xdpyinfo` | Affiche infos X11 | GUI possible |
| `xdpyinfo` | Erreur "can't open display" | CLI automatique |

---

## 📊 Comparaison CLI vs GUI

| Aspect | CLI | GUI |
|--------|-----|-----|
| **Environnement requis** | Terminal | X11/Serveur graphique |
| **Facilité d'utilisation** | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| **Navigation** | Séquentielle (menu) | Libre (clic) |
| **Visualisation** | Liste textuelle | Tableau interactif |
| **SSH** | ✅ Fonctionne toujours | ⚠️ Nécessite -X |
| **Consommation mémoire** | Faible | Moyenne |
| **Accessibilité** | Serveurs | Desktop |

---

## ✅ Avantages de la Détection Automatique

1. **✅ Pas de configuration manuelle**
   - Le système choisit automatiquement

2. **✅ Fonctionne partout**
   - Desktop → GUI
   - Serveur → CLI
   - SSH sans -X → CLI
   - SSH avec -X → GUI

3. **✅ Pas de crash**
   - Plus de HeadlessException
   - Toujours un mode disponible

4. **✅ Flexibilité**
   - Arguments --cli / --gui pour forcer
   - Choix de l'utilisateur respecté

5. **✅ Expérience optimale**
   - GUI quand disponible (plus agréable)
   - CLI en fallback (toujours fonctionnel)

---

## 🎯 Cas d'Usage

### Cas 1 : Développement Local

**Environnement :** Machine locale avec GUI

**Résultat :**
```
✓ Environnement graphique disponible
→ Interface Swing s'ouvre
```

### Cas 2 : Serveur de Production

**Environnement :** Serveur Linux sans X11

**Résultat :**
```
ℹ️  Environnement sans interface graphique détecté
→ Mode CLI activé
```

### Cas 3 : SSH avec X11 Forwarding

**Environnement :** `ssh -X user@server`

**Résultat :**
```
✓ Environnement graphique disponible (forwarding)
→ Interface Swing s'ouvre sur votre machine locale
```

### Cas 4 : SSH sans X11

**Environnement :** `ssh user@server`

**Résultat :**
```
ℹ️  Environnement sans interface graphique détecté
→ Mode CLI activé
```

---

## 📚 Fichiers Modifiés

### ClientApplication.java

**Ajouté :**
- Détection de l'environnement graphique
- Logique de choix CLI/GUI
- Support des arguments --cli / --gui
- Messages informatifs au démarrage

**Code clé :**
```java
boolean isHeadless = GraphicsEnvironment.isHeadless();
boolean hasDisplay = System.getenv("DISPLAY") != null;

if (forceCLI || (isHeadless && !forceGUI)) {
    // Mode CLI
    ClientCLIRest cli = context.getBean(ClientCLIRest.class);
    cli.run();
} else {
    // Mode GUI
    ClientGUI gui = context.getBean(ClientGUI.class);
    gui.run();
}
```

---

## ✅ RÉSUMÉ

### Problème Résolu

❌ **Avant :** HeadlessException si pas de serveur X11  
✅ **Après :** Détection automatique et choix du mode approprié

### Solution

🔄 **Détection automatique** de l'environnement  
🖥️ **GUI** si serveur X11 disponible  
⌨️ **CLI** si pas d'environnement graphique  
🎛️ **Arguments** --cli / --gui pour forcer un mode

### Résultat

- ✅ **Fonctionne partout** (desktop, serveur, SSH)
- ✅ **Pas de crash** (plus de HeadlessException)
- ✅ **Expérience optimale** (GUI quand possible, CLI en fallback)
- ✅ **Flexible** (choix manuel possible)

---

**Date :** 26 novembre 2025  
**Problème :** HeadlessException en environnement sans X11  
**Solution :** Détection automatique CLI/GUI  
**Statut :** ✅ **RÉSOLU ET TESTÉ**

