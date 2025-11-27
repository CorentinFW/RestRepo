# 📜 Guide des Scripts - Système de Réservation

## 🎯 Vue d'ensemble

Le système dispose de **5 scripts principaux** pour gérer le cycle de vie des services.

---

## 🚀 Scripts disponibles

### 1. `fix-complete.sh` - Installation / Reset complet

**Commande** :
```bash
./fix-complete.sh
```

**Fonction** :
- Recrée tous les fichiers `.properties`
- **SUPPRIME** les bases de données H2
- Recompile tous les modules
- Redémarre tous les services

**Utiliser quand** :
- ✅ Première installation
- ✅ Reset complet nécessaire
- ✅ Bases corrompues
- ✅ Problème de configuration

**Résultat** : Système vierge avec bases vides.

---

### 2. `rest-persistant.sh` - Redémarrage normal ⭐

**Commande** :
```bash
./rest-persistant.sh
```

**Fonction** :
- Arrête tous les services
- **CONSERVE** les bases de données H2
- Recompile les modules
- Redémarre tous les services
- Affiche l'état des bases

**Utiliser quand** :
- ✅ Redémarrage quotidien
- ✅ Après modification du code
- ✅ Test de la persistance
- ✅ Développement avec données de test

**Résultat** : Services redémarrés, toutes les données conservées.

---

### 3. `start-system-maven.sh` - Démarrage simple

**Commande** :
```bash
./start-system-maven.sh
```

**Fonction** :
- Lance directement les JARs compilés
- **Pas de recompilation**
- **Pas de vérification**

**Utiliser quand** :
- ✅ Démarrage rapide
- ✅ Aucune modification du code
- ✅ Services arrêtés proprement

**Résultat** : Démarrage rapide, données conservées.

---

### 4. `start-client-clean.sh` - Client sans warnings

**Commande** :
```bash
./start-client-clean.sh
```

**Fonction** :
- Lance le client Swing
- Filtre les warnings AWT/X11

**Utiliser quand** :
- ✅ Lancer le client
- ✅ Présentation / démo
- ✅ Logs propres souhaités

**Résultat** : Interface graphique sans warnings.

---

### 5. `arreter-services.sh` - Arrêt propre

**Commande** :
```bash
./arreter-services.sh
```

**Fonction** :
- Arrête tous les processus Hotellerie
- Arrête tous les processus Agence
- **Conserve** les bases de données

**Utiliser quand** :
- ✅ Fin de journée
- ✅ Avant maintenance
- ✅ Avant modification importante

**Résultat** : Tous les services arrêtés, données intactes.

---

## 🔄 Workflows recommandés

### Workflow 1 : Installation initiale

```bash
# 1. Installation complète
./fix-complete.sh
# Attendre 1-2 minutes

# 2. Lancer le client
./start-client-clean.sh
```

### Workflow 2 : Développement quotidien

```bash
# Matin
./rest-persistant.sh

# Développer dans le code...
# Modifier Hotellerie/src/...

# Tester
./rest-persistant.sh
./start-client-clean.sh

# Soir
./arreter-services.sh
```

### Workflow 3 : Test de persistance

```bash
# 1. Démarrer
./rest-persistant.sh

# 2. Créer des données
./start-client-clean.sh
# → Faire 5 réservations
# → Fermer

# 3. Arrêter
./arreter-services.sh

# 4. Redémarrer
./rest-persistant.sh

# 5. Vérifier
./start-client-clean.sh
# → Les 5 réservations sont là ✅
```

### Workflow 4 : Démonstration

```bash
# Avant la démo : préparer les données
./rest-persistant.sh
./start-client-clean.sh
# → Créer des réservations réalistes
# → Fermer

# Pendant la démo
./rest-persistant.sh
./start-client-clean.sh
# → Les données sont présentes ✅
```

---

## 📊 Tableau comparatif

| Script | Supprime BDD | Recompile | Redémarre | Temps | Usage |
|--------|--------------|-----------|-----------|-------|-------|
| `fix-complete.sh` | ✅ Oui | ✅ Oui | ✅ Oui | ~2 min | Reset |
| `rest-persistant.sh` | ❌ Non | ✅ Oui | ✅ Oui | ~1 min | Normal |
| `start-system-maven.sh` | ❌ Non | ❌ Non | ✅ Oui | ~30s | Rapide |
| `start-client-clean.sh` | N/A | ❌ Non | ✅ Client | ~20s | Client |
| `arreter-services.sh` | ❌ Non | N/A | ❌ Arrêt | ~5s | Stop |

---

## 🎯 Arbre de décision

```
Besoin de démarrer ?
│
├─ Première fois ?
│  └─ OUI → ./fix-complete.sh
│
├─ Reset complet ?
│  └─ OUI → ./fix-complete.sh
│
├─ Modification du code ?
│  └─ OUI → ./rest-persistant.sh
│
├─ Garder les données ?
│  └─ OUI → ./rest-persistant.sh
│
└─ Démarrage simple ?
   └─ OUI → ./start-system-maven.sh

Client ?
└─ ./start-client-clean.sh

Arrêter ?
└─ ./arreter-services.sh
```

---

## 💡 Cas d'usage détaillés

### Cas 1 : Développement d'une nouvelle fonctionnalité

```bash
# 1. Démarrer avec données de test
./rest-persistant.sh

# 2. Modifier le code
# Hotellerie/src/.../MonNouveau.java

# 3. Tester
./rest-persistant.sh  # Recompile + redémarre
./start-client-clean.sh

# 4. Si OK
git add .
git commit -m "Nouvelle fonctionnalité"

# 5. Si KO
# Corriger le code
./rest-persistant.sh
```

### Cas 2 : Correction de bug

```bash
# 1. Reproduire le bug
./rest-persistant.sh
./start-client-clean.sh
# → Créer une réservation problématique

# 2. Arrêter
./arreter-services.sh

# 3. Corriger le code
# Modifier le fichier concerné

# 4. Tester avec les MÊMES données
./rest-persistant.sh  # Les données du bug sont conservées
./start-client-clean.sh
# → Vérifier que le bug est corrigé
```

### Cas 3 : Problème technique

```bash
# Si les services ne répondent plus
./arreter-services.sh
pkill -f "Hotellerie\|Agence"  # Force kill
./rest-persistant.sh

# Si bases corrompues
./arreter-services.sh
rm -rf Hotellerie/data/*.db
./fix-complete.sh
```

---

## 🔍 Vérifications après chaque script

### Après `fix-complete.sh`

```bash
# Vérifier les bases créées
ls -lh Hotellerie/data/
# → hotellerie-paris-db.mv.db
# → hotellerie-lyon-db.mv.db
# → hotellerie-montpellier-db.mv.db

# Vérifier les services
curl http://localhost:8082/api/hotel/info
curl http://localhost:8083/api/hotel/info
curl http://localhost:8084/api/hotel/info
```

### Après `rest-persistant.sh`

```bash
# Vérifier les bases conservées
ls -lh Hotellerie/data/
# → Taille > 0K pour chaque base

# Vérifier les réservations
# Console H2 : http://localhost:808X/h2-console
# SQL : SELECT COUNT(*) FROM reservations;
```

---

## 📚 Documentation associée

| Fichier | Contenu |
|---------|---------|
| `GUIDE-REST-PERSISTANT.md` | Guide du script rest-persistant |
| `README-FINAL.md` | Guide complet du projet |
| `SOLUTION-FINALE-MAVEN.md` | Correction erreur Maven |
| `CORRECTION-CRITIQUE-H2.md` | Problème bases partagées |

---

## 🚨 Dépannage

### Script ne démarre pas

```bash
# Vérifier les permissions
ls -l *.sh
# Si pas exécutable
chmod +x *.sh
```

### "Port already in use"

```bash
# Arrêter proprement
./arreter-services.sh

# Force kill
pkill -f "Hotellerie\|Agence"

# Vérifier
netstat -tuln | grep -E '808[0-9]'
```

### "Erreur compilation"

```bash
# Voir l'erreur complète
cd Hotellerie
mvn clean compile
# Corriger l'erreur
cd ..
./rest-persistant.sh
```

---

## 🎉 Résumé

### Scripts essentiels

1. **`fix-complete.sh`** → Une fois (installation)
2. **`rest-persistant.sh`** → Tous les jours (développement)
3. **`start-client-clean.sh`** → À chaque test (client)

### Commande rapide du jour

```bash
# Démarrer le système avec vos données
./rest-persistant.sh

# Lancer le client
./start-client-clean.sh
```

**C'est tout !** 🚀

---

*Guide créé le 27 novembre 2025*  
*Version : 1.0 - Tous scripts documentés*

