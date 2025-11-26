# 📜 SCRIPTS DISPONIBLES

Voici tous les scripts shell créés pour gérer votre système Multi-Agences REST.

---

## 🚀 SCRIPTS DE DÉMARRAGE

### `start-multi-rest.sh` ⭐ (RECOMMANDÉ)

**Démarre tout le système automatiquement dans le bon ordre.**

```bash
./start-multi-rest.sh
```

**Ce qu'il fait :**
1. Démarre les 3 hôtels (Paris, Lyon, Montpellier)
2. Démarre l'Agence 1 (Paris Voyages)
3. Démarre l'Agence 2 (Sud Réservations)
4. Ouvre le Client CLI en mode interactif

**Durée :** ~40-50 secondes

---

### `start-hotels.sh`

**Démarre uniquement les 3 hôtels en arrière-plan.**

```bash
./start-hotels.sh
```

Utile si vous voulez démarrer les services séparément.

---

### `start-agence1.sh`

**Démarre l'Agence 1 (Paris Voyages).**

```bash
./start-agence1.sh
```

Configuration : Paris + Lyon, coefficient 1.15

---

### `start-agence2.sh`

**Démarre l'Agence 2 (Sud Réservations).**

```bash
./start-agence2.sh
```

Configuration : Lyon + Montpellier, coefficient 1.20

---

## 🛑 SCRIPTS D'ARRÊT

### `stop-multi-rest.sh` ⭐ (RECOMMANDÉ)

**Arrête tous les services proprement.**

```bash
./stop-multi-rest.sh
```

**Ce qu'il fait :**
- Arrête le client
- Arrête les 2 agences
- Arrête les 3 hôtels

---

## 🧪 SCRIPTS DE TEST

### `test-configuration-finale.sh` ⭐

**Vérifie que chaque agence est bien connectée aux bons hôtels.**

```bash
./test-configuration-finale.sh
```

**Résultat attendu :**
```
✅ CONFIGURATION CORRECTE: Paris + Lyon uniquement (Agence 1)
✅ CONFIGURATION CORRECTE: Lyon + Montpellier uniquement (Agence 2)
```

---

### `test-agences-hotels.sh`

**Version alternative du test de configuration.**

```bash
./test-agences-hotels.sh
```

---

### `test-hotellerie.sh`

**Teste le module Hotellerie (si disponible).**

```bash
./test-hotellerie.sh
```

---

### `test-images.sh`

**Teste que les images des chambres sont accessibles.**

```bash
./test-images.sh
```

---

## 🔧 AUTRES SCRIPTS

### `start-multi-agences.sh`

**Version alternative du script de démarrage (peut avoir des problèmes avec le client en arrière-plan).**

```bash
./start-multi-agences.sh
```

⚠️ **Préférez `start-multi-rest.sh`**

---

### `start-rest-system.sh`

**Ancien script de démarrage.**

```bash
./start-rest-system.sh
```

⚠️ **Préférez `start-multi-rest.sh`**

---

### `start-system-soap.sh`

**Script de l'ancienne version SOAP (obsolète).**

❌ **Ne pas utiliser - Le projet est maintenant en REST**

---

### `start-robuste.sh`

**Script de l'ancienne version avec gestion d'erreurs.**

```bash
./start-robuste.sh
```

---

## 📊 RÉCAPITULATIF - SCRIPTS À UTILISER

| Besoin | Script | Commande |
|--------|--------|----------|
| **Démarrer tout** | `start-multi-rest.sh` | `./start-multi-rest.sh` |
| **Arrêter tout** | `stop-multi-rest.sh` | `./stop-multi-rest.sh` |
| **Tester la config** | `test-configuration-finale.sh` | `./test-configuration-finale.sh` |
| **Démarrer seulement les hôtels** | `start-hotels.sh` | `./start-hotels.sh` |
| **Démarrer Agence 1** | `start-agence1.sh` | `./start-agence1.sh` |
| **Démarrer Agence 2** | `start-agence2.sh` | `./start-agence2.sh` |

---

## 🎯 WORKFLOW RECOMMANDÉ

### 1. Premier démarrage

```bash
# Compiler le projet
mvn clean install -DskipTests

# Démarrer le système
./start-multi-rest.sh
```

### 2. Utilisation quotidienne

```bash
# Démarrer
./start-multi-rest.sh

# ... Utiliser le client CLI ...

# Arrêter proprement
./stop-multi-rest.sh
```

### 3. Vérification après modifications

```bash
# Recompiler
mvn clean package -DskipTests

# Arrêter
./stop-multi-rest.sh

# Redémarrer
./start-multi-rest.sh

# Tester
./test-configuration-finale.sh
```

---

## 🔍 DÉTAILS DES SCRIPTS PRINCIPAUX

### start-multi-rest.sh

**Ordre de démarrage :**
1. Hôtel Paris (8082) → attend 5s
2. Hôtel Lyon (8083) → attend 5s
3. Hôtel Montpellier (8084) → attend 10s
4. Agence 1 (8081) → attend 8s
5. Agence 2 (8085) → attend 8s
6. Client CLI (mode interactif)

**PID sauvegardés :**
Les PIDs de tous les processus sont affichés pour un arrêt manuel si nécessaire.

**Logs :**
- `logs/hotel-paris.log`
- `logs/hotel-lyon.log`
- `logs/hotel-montpellier.log`
- `logs/agence.log`
- `logs/agence2.log`

---

### stop-multi-rest.sh

**Ordre d'arrêt :**
1. Client CLI
2. Agences (1 et 2)
3. Hôtels (Paris, Lyon, Montpellier)

**Méthode :**
Utilise `pkill` avec des patterns spécifiques pour cibler chaque service.

---

### test-configuration-finale.sh

**Tests effectués :**
1. Requête POST à l'Agence 1
2. Extraction des noms d'hôtels
3. Vérification : Paris ✓, Lyon ✓, Montpellier ✗
4. Requête POST à l'Agence 2
5. Extraction des noms d'hôtels
6. Vérification : Paris ✗, Lyon ✓, Montpellier ✓

---

## 💡 ASTUCES

### Rendre tous les scripts exécutables

```bash
chmod +x *.sh
```

### Voir les scripts disponibles

```bash
ls -lh *.sh
```

### Créer un alias

Ajoutez dans votre `~/.bashrc` :

```bash
alias start-rest='cd /home/corentinfay/Bureau/RestRepo && ./start-multi-rest.sh'
alias stop-rest='cd /home/corentinfay/Bureau/RestRepo && ./stop-multi-rest.sh'
```

Puis :
```bash
source ~/.bashrc
start-rest  # Démarre tout
stop-rest   # Arrête tout
```

---

## 🆘 EN CAS DE PROBLÈME

### Script ne démarre pas

```bash
# Vérifier les permissions
ls -l start-multi-rest.sh

# Si pas exécutable
chmod +x start-multi-rest.sh
```

### Services ne s'arrêtent pas

```bash
# Forcer l'arrêt
pkill -9 -f java

# Vérifier
ps aux | grep java | grep -v grep
```

### Ports déjà utilisés

```bash
# Voir qui utilise les ports
ss -tlnp | grep -E ':(8081|8082|8083|8084|8085)'

# Libérer les ports
./stop-multi-rest.sh
```

---

**Date de création :** 26 novembre 2025  
**Version :** 2.0 - Multi-Agences REST  
**Scripts principaux :** 3 (start-multi-rest, stop-multi-rest, test-configuration-finale)

