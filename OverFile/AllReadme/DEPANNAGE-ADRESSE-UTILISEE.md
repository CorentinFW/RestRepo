# 🔧 DÉPANNAGE - Erreur "Adresse déjà utilisée"

## ❌ L'Erreur

```
Caused by: java.net.BindException: Adresse déjà utilisée
```

**Signification :** Le port que le service essaie d'utiliser est **déjà occupé** par un autre processus.

---

## 🎯 Cause du Problème

### Scénarios possibles :

1. **Un service tourne déjà** sur ce port
2. **Ancien processus non terminé** après un crash
3. **Démarrage rapide** après arrêt (port pas encore libéré)
4. **Autre application** utilise le même port

---

## ✅ SOLUTION RAPIDE

### Étape 1 : Nettoyer Tous les Services

```bash
cd /home/corentinfay/Bureau/RestRepo
./nettoyer-services.sh
```

**Ce script :**
- ✅ Arrête tous les services (Hotellerie, Agence, Client)
- ✅ Attend 3 secondes
- ✅ Vérifie que tous les ports sont libres
- ✅ Affiche le statut de chaque port

---

### Étape 2 : Relancer les Services

**Après avoir nettoyé, relancez :**

```bash
./afficher-commandes.sh
```

**Puis suivez les instructions pour ouvrir 6 terminaux.**

---

## 🔍 Diagnostic Manuel

### Vérifier Quel Port Pose Problème

L'erreur apparaît quand vous démarrez un service. Identifiez le port :

| Service | Port | Commande |
|---------|------|----------|
| Hôtel Paris | 8082 | `lsof -i :8082` |
| Hôtel Lyon | 8083 | `lsof -i :8083` |
| Hôtel Montpellier | 8084 | `lsof -i :8084` |
| Agence 1 | 8081 | `lsof -i :8081` |
| Agence 2 | 8085 | `lsof -i :8085` |

**Exemple :**
```bash
lsof -i :8082
```

**Si le port est utilisé, vous verrez :**
```
COMMAND   PID  USER   FD   TYPE DEVICE SIZE/OFF NODE NAME
java    12345  user   45u  IPv6 123456      0t0  TCP *:8082 (LISTEN)
```

---

## 🛑 Solutions

### Solution 1 : Arrêter le Processus (RECOMMANDÉ)

```bash
# Arrêter tous les services du projet
pkill -f 'java.*Hotellerie'
pkill -f 'java.*Agence'
pkill -f 'java.*Client'

# Attendre 3 secondes
sleep 3
```

---

### Solution 2 : Tuer le Processus Spécifique

**Si `lsof` montre un processus, notez le PID et :**

```bash
kill -9 <PID>
```

**Exemple :**
```bash
kill -9 12345
```

---

### Solution 3 : Changer le Port (Si Conflit Externe)

**Si un autre programme utilise le port, modifiez la configuration :**

**Pour l'hôtel Paris (8082) :**

Éditez `Hotellerie/src/main/resources/application-paris.properties` :
```properties
server.port=8092  # Au lieu de 8082
```

**Puis recompilez :**
```bash
cd Hotellerie
mvn clean package -DskipTests
```

---

## 📋 Procédure Complète de Redémarrage

### 1. Tout Arrêter

```bash
cd /home/corentinfay/Bureau/RestRepo
./nettoyer-services.sh
```

### 2. Vérifier Que Tout Est Libre

```bash
# Aucune ligne ne doit apparaître
lsof -i :8081 -i :8082 -i :8083 -i :8084 -i :8085
```

### 3. Attendre 3-5 Secondes

```bash
sleep 5
```

### 4. Redémarrer les Services

```bash
./afficher-commandes.sh
```

**Puis ouvrir 6 terminaux et copier-coller les commandes.**

---

## ⚠️ Erreurs Courantes

### Erreur 1 : "Aucune commande lsof trouvée"

**Installer lsof :**
```bash
sudo apt install lsof
```

---

### Erreur 2 : Le Service Se Ferme Immédiatement

**Vérifier les logs pour voir l'erreur réelle :**

```bash
# Pour l'hôtel Paris par exemple
java -jar Hotellerie/target/Hotellerie-0.0.1-SNAPSHOT.jar --spring.profiles.active=paris
```

**Lire l'erreur qui s'affiche.**

---

### Erreur 3 : Port Toujours Utilisé Après pkill

**Attendre plus longtemps :**
```bash
pkill -f 'java.*Hotellerie'
sleep 10  # Attendre 10 secondes
```

**Ou forcer l'arrêt :**
```bash
pkill -9 -f 'java.*Hotellerie'
```

---

## 🎯 Ordre de Démarrage Correct

### Important : Ne Jamais Démarrer 2 Fois le Même Service !

**Scénario problématique :**
```bash
# Terminal 1
java -jar Hotellerie/target/Hotellerie-0.0.1-SNAPSHOT.jar --spring.profiles.active=paris

# Terminal 2 (PAR ERREUR, même commande)
java -jar Hotellerie/target/Hotellerie-0.0.1-SNAPSHOT.jar --spring.profiles.active=paris
# ❌ ERREUR : Adresse déjà utilisée
```

**Solution :** Vérifier dans quel terminal vous êtes avant de lancer une commande.

---

## ✅ Checklist de Démarrage

Avant de démarrer les services, vérifier :

- [ ] Aucun service ne tourne : `ps aux | grep 'java.*jar'`
- [ ] Tous les ports sont libres : `./nettoyer-services.sh`
- [ ] Vous avez 6 terminaux ouverts
- [ ] Les JARs sont compilés : `ls -lh */target/*.jar`

**Si tout est OK → Démarrer les 6 services dans l'ordre !**

---

## 📊 Résumé

### Problème
❌ `java.net.BindException: Adresse déjà utilisée`

### Cause
❌ Un service tourne déjà sur le port

### Solution
```bash
# 1. Nettoyer
./nettoyer-services.sh

# 2. Attendre
sleep 5

# 3. Redémarrer
./afficher-commandes.sh
# Puis suivre les instructions
```

---

## 📝 Scripts Créés

- ✅ **nettoyer-services.sh** - Arrête tous les services et vérifie les ports
- ✅ Ce guide de dépannage

---

**En cas de problème persistant, utilisez `./nettoyer-services.sh` avant chaque démarrage !** 🔧

