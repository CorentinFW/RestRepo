# 🖥️ GUIDE POUR LANCER L'INTERFACE GRAPHIQUE

Vous avez installé xorg, voici comment lancer l'interface graphique (GUI) :

---

## 🎯 MÉTHODE RAPIDE (RECOMMANDÉE)

### Si vous êtes déjà sur un bureau graphique (GNOME, KDE, XFCE...)

**1. Ouvrez un terminal dans votre environnement graphique**
   - Clic droit sur le bureau → Terminal
   - Ou Ctrl+Alt+T

**2. Lancez directement :**
```bash
cd /home/corentinfay/Bureau/RestRepo/Client
mvn spring-boot:run -Dspring-boot.run.arguments="--gui"
```

**3. Une fenêtre Swing s'ouvre !** 🎉

---

## 🔧 SI VOUS ÊTES EN MODE TEXTE (TTY)

### Option 1 : Démarrer votre environnement de bureau

**Identifier votre gestionnaire d'affichage :**
```bash
# Vérifier quel gestionnaire est installé
systemctl list-unit-files | grep -E 'gdm|lightdm|sddm'
```

**Démarrer le gestionnaire :**
```bash
# Pour GNOME
sudo systemctl start gdm3

# Pour XFCE/LXDE
sudo systemctl start lightdm

# Pour KDE
sudo systemctl start sddm
```

**Puis connectez-vous à votre session graphique !**

---

### Option 2 : Utiliser startx (Simple mais basique)

**1. Créer un fichier .xinitrc si nécessaire :**
```bash
echo "exec xterm" > ~/.xinitrc
```

**2. Démarrer X11 :**
```bash
startx
```

**3. Dans la fenêtre xterm qui s'ouvre :**
```bash
cd /home/corentinfay/Bureau/RestRepo/Client
mvn spring-boot:run -Dspring-boot.run.arguments="--gui"
```

---

## ✅ ALTERNATIVE : UTILISER LE SCRIPT launch-gui.sh

**Lancer simplement :**
```bash
cd /home/corentinfay/Bureau/RestRepo
./launch-gui.sh
```

Ce script :
- ✓ Vérifie que X11 est disponible
- ✓ Configure DISPLAY automatiquement
- ✓ Lance la GUI
- ✓ Vous guide si X11 n'est pas actif

---

## 🎮 MÉTHODE ALTERNATIVE : MODE CLI

**Si vous préférez rester en mode terminal** (toutes les fonctionnalités sont disponibles) :

```bash
cd /home/corentinfay/Bureau/RestRepo
./start-multi-rest.sh
```

Le mode CLI offre **exactement les mêmes fonctionnalités** que la GUI !

---

## 📊 COMPARAISON

| Méthode | Quand l'utiliser |
|---------|------------------|
| **GUI sur bureau existant** | ✅ Si vous avez déjà un bureau (GNOME, KDE...) |
| **startx** | ⚠️ Si en mode texte, pour X11 minimal |
| **systemctl start gdm3** | ⚠️ Si en mode texte, pour bureau complet |
| **CLI** | ✅ Toujours fonctionne, simple et efficace |

---

## 🔍 DIAGNOSTIC

### Vérifier si X11 est actif

```bash
echo $DISPLAY
# Devrait afficher :0 ou :1

xdpyinfo
# Devrait afficher des infos sur X11
```

### Si DISPLAY est vide

```bash
export DISPLAY=:0
```

---

## ⚡ SOLUTION RAPIDE POUR TESTER

**Sur votre bureau actuel, ouvrez un terminal et lancez :**

```bash
cd /home/corentinfay/Bureau/RestRepo/Client
export DISPLAY=:0
mvn spring-boot:run -Dspring-boot.run.arguments="--gui"
```

**Une fenêtre devrait s'ouvrir !** 🎨

---

## 🆘 EN CAS DE PROBLÈME

### Erreur "can't open display"

```bash
# Définir DISPLAY
export DISPLAY=:0

# Vérifier que X11 tourne
ps aux | grep Xorg

# Si rien, démarrer X11
sudo systemctl start gdm3
# ou
startx
```

### L'application reste en CLI

```bash
# Forcer le mode GUI
cd /home/corentinfay/Bureau/RestRepo/Client
mvn spring-boot:run -Dspring-boot.run.arguments="--gui"
```

---

## 📝 RÉSUMÉ SIMPLE

**Vous êtes sur un bureau graphique ?**
→ Ouvrez un terminal et lancez : `./launch-gui.sh`

**Vous êtes en mode texte (TTY) ?**
→ Lancez d'abord : `sudo systemctl start gdm3` (ou lightdm/sddm)
→ Puis connectez-vous graphiquement
→ Ouvrez un terminal et lancez : `./launch-gui.sh`

**Vous préférez rester en terminal ?**
→ Lancez : `./start-multi-rest.sh` (mode CLI, tout fonctionne !)

---

**Date :** 26 novembre 2025  
**Fichier créé :** launch-gui.sh  
**Commande simple :** `./launch-gui.sh`

