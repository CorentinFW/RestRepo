# ✅ RETOUR AU SYSTÈME MAVEN - Démarrage Simplifié

## 🎯 Nouveau Système de Démarrage

Au lieu de lancer les JARs manuellement dans 6 terminaux, vous pouvez maintenant utiliser **Maven directement** avec un script automatique !

---

## 🚀 COMMANDE UNIQUE

```bash
cd /home/corentinfay/Bureau/RestRepo
./start-system-maven.sh
```

**Ce script fait TOUT automatiquement :**
1. ✅ Arrête les anciens services
2. ✅ Démarre les 3 hôtels avec Maven
3. ✅ Démarre les 2 agences avec Maven
4. ✅ Attend que tout soit prêt (20 secondes)
5. ✅ Ouvre l'interface graphique
6. ✅ **C'est tout !**

---

## 📊 Comparaison des Méthodes

### Ancienne Méthode (6 Terminaux)

**❌ Complexe :**
- Ouvrir 6 terminaux
- Copier-coller 6 commandes
- Attendre manuellement
- Lancer le client en dernier

**✅ Avantages :**
- Logs visibles en temps réel
- Contrôle total

---

### Nouvelle Méthode (Script Maven)

**✅ Simple :**
```bash
./start-system-maven.sh
```

**✅ Avantages :**
- Une seule commande
- Tout démarre automatiquement
- Logs dans des fichiers (logs/)
- Services en arrière-plan

**❌ Inconvénient :**
- Logs dans des fichiers (pas dans le terminal)

---

## 📝 Logs des Services

Les logs de tous les services sont dans le dossier `logs/` :

```
logs/
├── hotel-paris.log        → Hôtel Paris (8082)
├── hotel-lyon.log         → Hôtel Lyon (8083)
├── hotel-montpellier.log  → Hôtel Montpellier (8084)
├── agence1.log            → Agence 1 (8081)
└── agence2.log            → Agence 2 (8085)
```

### Voir les Logs en Temps Réel

```bash
# Hôtel Paris
tail -f logs/hotel-paris.log

# Agence 1
tail -f logs/agence1.log

# Tous les hôtels en même temps
tail -f logs/hotel-*.log

# Toutes les agences
tail -f logs/agence*.log
```

---

## 🛑 Arrêter Tous les Services

```bash
./arreter-services.sh
```

**Ce script :**
- ✅ Arrête tous les services Maven
- ✅ Vérifie que les ports sont libres
- ✅ Affiche le statut

---

## 🎮 Utilisation Complète

### 1. Démarrer le Système

```bash
cd /home/corentinfay/Bureau/RestRepo
./start-system-maven.sh
```

**Résultat :**
- Les 5 services démarrent en arrière-plan
- L'interface graphique s'ouvre automatiquement
- Vous pouvez utiliser l'application !

---

### 2. Utiliser l'Interface

**Rechercher des chambres :**
- Ville : Lyon
- Dates : 2025-12-01 → 2025-12-05
- Cliquer "🔍 Rechercher"
- **10 chambres apparaissent !**

**Voir les images :**
- Cliquer sur 🖼 dans le tableau
- L'image s'affiche en grand !

**Réserver :**
- Double-cliquer sur une chambre
- Remplir le formulaire
- Valider

---

### 3. Fermer l'Interface

**Cliquer sur X**

**Les services continuent de tourner en arrière-plan !**

---

### 4. Arrêter Tous les Services

```bash
./arreter-services.sh
```

---

## 🔍 Vérification

### Voir les Services Actifs

```bash
ps aux | grep -E 'maven.*(Hotellerie|Agence)' | grep -v grep
```

**Résultat attendu : 5 lignes** (3 hôtels + 2 agences)

---

### Tester les Ports

```bash
# Vérifier les ports
lsof -i :8081  # Agence 1
lsof -i :8082  # Hôtel Paris
lsof -i :8083  # Hôtel Lyon
lsof -i :8084  # Hôtel Montpellier
lsof -i :8085  # Agence 2
```

---

### Tester les APIs

```bash
# Ping Agence 1
curl http://localhost:8081/api/agence/ping

# Chambres Hôtel Paris
curl -X POST http://localhost:8082/api/hotel/chambres/rechercher \
  -H "Content-Type: application/json" \
  -d '{"dateArrive":"2025-12-01","dateDepart":"2025-12-05"}'
```

---

## 💡 Astuces

### Relancer Après un Crash

```bash
# Arrêter proprement
./arreter-services.sh

# Attendre 5 secondes
sleep 5

# Relancer
./start-system-maven.sh
```

---

### Voir les Logs d'un Service Qui Ne Démarre Pas

```bash
# Voir les dernières lignes
tail -50 logs/hotel-paris.log

# Suivre en temps réel
tail -f logs/hotel-paris.log
```

---

### Démarrer Sans l'Interface (Services Seulement)

**Modifier `start-system-maven.sh` :**

Commenter les lignes du client à la fin :
```bash
# cd Client
# MAVEN_OPTS="-Djava.awt.headless=false" mvn spring-boot:run ...
echo "Services démarrés, interface non lancée"
```

Puis lancer :
```bash
./start-system-maven.sh
```

**Les services tournent, pas l'interface.**

Pour lancer l'interface plus tard :
```bash
cd Client
MAVEN_OPTS="-Djava.awt.headless=false" mvn spring-boot:run \
  -Dspring-boot.run.arguments="--gui" \
  -Dspring-boot.run.jvmArguments="-Djava.awt.headless=false"
```

---

## 📋 Scripts Disponibles

| Script | Description |
|--------|-------------|
| **start-system-maven.sh** | Démarre tout avec Maven (NOUVEAU) |
| **arreter-services.sh** | Arrête tous les services |
| **nettoyer-services.sh** | Nettoie et vérifie les ports |
| **compile-all.sh** | Compile tous les modules |
| ~~start-system-complete-gui.sh~~ | Ancienne version (avec JARs) |

---

## 🎯 Quelle Méthode Choisir ?

### Méthode Maven (Script Automatique)

**✅ Recommandée pour :**
- Utilisation normale
- Démarrage rapide
- Pas besoin de voir les logs en temps réel

**Commande :**
```bash
./start-system-maven.sh
```

---

### Méthode 6 Terminaux (Manuelle)

**✅ Recommandée pour :**
- Développement
- Débogage
- Voir les logs en temps réel dans les terminaux

**Commande :**
```bash
./afficher-commandes.sh
# Puis suivre les instructions
```

---

## ✅ Résumé

### Avant (6 Terminaux)

**Commandes :**
```bash
# Terminal 1
cd Hotellerie && java -jar target/...jar --spring.profiles.active=paris

# Terminal 2
cd Hotellerie && java -jar target/...jar --spring.profiles.active=lyon

# ... (4 autres terminaux)
```

**❌ Compliqué, 6 terminaux à gérer**

---

### Maintenant (Script Maven)

**Commande :**
```bash
./start-system-maven.sh
```

**✅ Simple, tout automatique !**

---

## 🚀 LANCEZ MAINTENANT

```bash
cd /home/corentinfay/Bureau/RestRepo
./start-system-maven.sh
```

**Attendez ~20 secondes → L'interface s'ouvre → Profitez !** 🎉

---

## 🛑 Pour Arrêter

```bash
./arreter-services.sh
```

---

**Date :** 26 novembre 2025  
**Méthode :** Démarrage avec Maven (mvn spring-boot:run)  
**Scripts :** start-system-maven.sh + arreter-services.sh  
**Statut :** ✅ **PRÊT À UTILISER**

