# 🔧 BashSh - Scripts Shell du Projet

Ce dossier contient **tous les scripts shell** du projet (sauf les scripts principaux gardés à la racine).

---

## 📋 Contenu

### Scripts de Démarrage
- **start-agence1.sh** - Démarre l'Agence 1 (Paris Voyages)
- **start-agence2.sh** - Démarre l'Agence 2 (Sud Réservations)
- **start-hotels.sh** - Démarre les 3 hôtels
- **start-multi-agences.sh** - Ancienne version du démarrage multi-agences
- **start-rest-system.sh** - Démarrage système REST
- **start-robuste.sh** - Démarrage avec gestion d'erreurs
- **start-system-soap.sh** - Ancien système SOAP (obsolète)
- **stop-multi-rest.sh** - Arrête tous les services

### Scripts de Test
- **test-agences-hotels.sh** - Test de configuration des agences
- **test-configuration-finale.sh** - Test final de configuration
- **test-hotellerie.sh** - Test du module Hotellerie
- **test-images.sh** - Test des images

### Autres Scripts
- **restart-system.sh** - Redémarrage du système
- **run.sh** - Script de lancement générique

---

## ⭐ Scripts Principaux (Restés à la Racine)

Ces scripts sont les **plus importants** et restent à la racine pour un accès facile :

### À la racine du projet :
- **start-multi-rest.sh** - ⭐ Script principal de démarrage
- **apply-fix-doublons.sh** - ⭐ Application du correctif doublons

---

## 📖 Description des Scripts

### start-agence1.sh
Démarre l'Agence 1 (Paris Voyages) sur le port 8081.
- Hôtels : Paris + Lyon
- Coefficient : 1.15

### start-agence2.sh
Démarre l'Agence 2 (Sud Réservations) sur le port 8085.
- Hôtels : Lyon + Montpellier
- Coefficient : 1.20

### start-hotels.sh
Démarre les 3 hôtels en arrière-plan :
- Paris (8082)
- Lyon (8083)
- Montpellier (8084)

### stop-multi-rest.sh
Arrête proprement tous les services du système.

### test-configuration-finale.sh
Teste que chaque agence est bien connectée aux bons hôtels.
- Agence 1 → Paris + Lyon
- Agence 2 → Lyon + Montpellier

---

## 🚀 Utilisation Recommandée

### Pour démarrer le système :
Utilisez le script principal à la **racine** :
```bash
cd /home/corentinfay/Bureau/RestRepo
./start-multi-rest.sh
```

### Pour tester la configuration :
```bash
./OverFile/BashSh/test-configuration-finale.sh
```

### Pour arrêter le système :
```bash
./OverFile/BashSh/stop-multi-rest.sh
```

---

## 📊 Statistiques

- **Total de scripts :** 14
- **Scripts de démarrage :** 7
- **Scripts de test :** 4
- **Autres :** 3

---

**Localisation :** `/home/corentinfay/Bureau/RestRepo/OverFile/BashSh/`
**Scripts actifs principaux :** À la racine du projet

