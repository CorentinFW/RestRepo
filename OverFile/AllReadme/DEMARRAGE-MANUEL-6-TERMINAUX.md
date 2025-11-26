# 🚀 SOLUTION DÉFINITIVE - Démarrage Manuel (6 Terminaux)

## ⚠️ Le Script Automatique A Des Problèmes

Le script `start-system-complete-gui.sh` ne démarre pas correctement les services backend en arrière-plan.

**SOLUTION : Démarrage manuel dans 6 terminaux séparés**

---

## ✅ MÉTHODE QUI FONCTIONNE À 100%

### Ouvrir 6 Terminaux

**Terminal 1, 2, 3** : Les Hôtels  
**Terminal 4, 5** : Les Agences  
**Terminal 6** : Le Client GUI

---

## 📋 COMMANDES À EXÉCUTER

### Terminal 1 : Hôtel Paris

```bash
cd /home/corentinfay/Bureau/RestRepo/Hotellerie
java -jar target/Hotellerie-0.0.1-SNAPSHOT.jar --spring.profiles.active=paris
```

**Attendre de voir :**
```
Started HotellerieApplication in X seconds
```

---

### Terminal 2 : Hôtel Lyon

```bash
cd /home/corentinfay/Bureau/RestRepo/Hotellerie
java -jar target/Hotellerie-0.0.1-SNAPSHOT.jar --spring.profiles.active=lyon
```

**Attendre de voir :**
```
Started HotellerieApplication in X seconds
```

---

### Terminal 3 : Hôtel Montpellier

```bash
cd /home/corentinfay/Bureau/RestRepo/Hotellerie
java -jar target/Hotellerie-0.0.1-SNAPSHOT.jar --spring.profiles.active=montpellier
```

**Attendre de voir :**
```
Started HotellerieApplication in X seconds
```

---

### Terminal 4 : Agence 1 (Paris Voyages)

```bash
cd /home/corentinfay/Bureau/RestRepo/Agence
java -jar target/Agence-0.0.1-SNAPSHOT.jar --spring.profiles.active=agence1
```

**Attendre de voir :**
```
Started AgenceApplication in X seconds
```

---

### Terminal 5 : Agence 2 (Sud Réservations)

```bash
cd /home/corentinfay/Bureau/RestRepo/Agence
java -jar target/Agence-0.0.1-SNAPSHOT.jar --spring.profiles.active=agence2
```

**Attendre de voir :**
```
Started AgenceApplication in X seconds
```

---

### Terminal 6 : Client GUI

**Attendre que les 5 services soient démarrés (message "Started..." visible dans chaque terminal)**

Puis lancer :

```bash
cd /home/corentinfay/Bureau/RestRepo/Client
MAVEN_OPTS="-Djava.awt.headless=false" mvn spring-boot:run \
  -Dspring-boot.run.arguments="--gui" \
  -Dspring-boot.run.jvmArguments="-Djava.awt.headless=false"
```

**OU plus simple avec le JAR :**

```bash
cd /home/corentinfay/Bureau/RestRepo/Client
java -Djava.awt.headless=false -jar target/Client-0.0.1-SNAPSHOT.jar --gui
```

---

## ✅ Résultat

**Une fenêtre graphique Swing s'ouvre !**

**Dans la console de l'interface :**
```
[19:XX:XX] ✓ Connexion établie: Multi-Agence REST Client
```

**Faire une recherche Lyon → 10 chambres apparaissent !**

---

## 🎯 Vérification des Services

### Dans un 7ème terminal (optionnel)

```bash
# Vérifier que les 5 services tournent
ps aux | grep 'java.*jar' | grep -E '(paris|lyon|montpellier|agence)'
```

**Résultat attendu : 5 lignes**

### Tester les ports

```bash
# Tester les hôtels
curl http://localhost:8082/api/hotel/chambres
curl http://localhost:8083/api/hotel/chambres
curl http://localhost:8084/api/hotel/chambres

# Tester les agences
curl -X POST http://localhost:8081/api/agence/chambres/rechercher \
  -H "Content-Type: application/json" \
  -d '{"dateArrive":"2025-12-01","dateDepart":"2025-12-05"}'
```

---

## 🛑 Pour Arrêter

**Dans chaque terminal, appuyer sur Ctrl+C**

Ou dans un terminal séparé :
```bash
pkill -f 'java.*Hotellerie'
pkill -f 'java.*Agence'
pkill -f 'java.*Client'
```

**Ou utiliser le script de nettoyage :**
```bash
./nettoyer-services.sh
```

---

## ⚠️ ERREUR FRÉQUENTE : "Adresse déjà utilisée"

### Symptôme

```
java.net.BindException: Adresse déjà utilisée
```

### Cause

Un service tourne déjà sur le port, ou un ancien processus n'est pas terminé.

### Solution Rapide

```bash
# 1. Nettoyer tous les services
cd /home/corentinfay/Bureau/RestRepo
./nettoyer-services.sh

# 2. Attendre 5 secondes
sleep 5

# 3. Redémarrer les services (6 terminaux)
./afficher-commandes.sh
```

**📖 Guide complet :** Voir `DEPANNAGE-ADRESSE-UTILISEE.md`

---

## 💡 Pourquoi Cette Méthode Fonctionne

- ✅ **Services visibles** : Vous voyez les logs de chaque service
- ✅ **Pas de problème nohup** : Les processus restent attachés au terminal
- ✅ **Débogage facile** : Si un service plante, vous voyez l'erreur
- ✅ **Contrôle total** : Vous démarrez un service à la fois

---

## 📊 Ordre de Démarrage

1. **Les 3 hôtels** (terminaux 1, 2, 3) → Attendre "Started..."
2. **Les 2 agences** (terminaux 4, 5) → Attendre "Started..."
3. **Le client GUI** (terminal 6)

**Temps total : ~30 secondes**

---

## ✅ Vérification Finale

### Dans l'interface GUI

**1. Console affiche :**
```
✓ Connexion établie
```

**2. Recherche Lyon :**
- Ville : Lyon
- Dates : 2025-12-01 → 2025-12-05
- Cliquer "🔍 Rechercher"

**3. Console affiche :**
```
🔍 Recherche dans 2 agences...
✓ [http://localhost:8081] Trouvé 5 chambre(s)
✓ [http://localhost:8085] Trouvé 5 chambre(s)
✓ 10 chambre(s) trouvée(s)
```

**4. Tableau affiche 10 chambres Lyon !** ✅

---

## 📝 Résumé des Commandes

```bash
# Terminal 1
cd /home/corentinfay/Bureau/RestRepo/Hotellerie
java -jar target/Hotellerie-0.0.1-SNAPSHOT.jar --spring.profiles.active=paris

# Terminal 2
cd /home/corentinfay/Bureau/RestRepo/Hotellerie
java -jar target/Hotellerie-0.0.1-SNAPSHOT.jar --spring.profiles.active=lyon

# Terminal 3
cd /home/corentinfay/Bureau/RestRepo/Hotellerie
java -jar target/Hotellerie-0.0.1-SNAPSHOT.jar --spring.profiles.active=montpellier

# Terminal 4
cd /home/corentinfay/Bureau/RestRepo/Agence
java -jar target/Agence-0.0.1-SNAPSHOT.jar --spring.profiles.active=agence1

# Terminal 5
cd /home/corentinfay/Bureau/RestRepo/Agence
java -jar target/Agence-0.0.1-SNAPSHOT.jar --spring.profiles.active=agence2

# Terminal 6 (attendre que les 5 autres affichent "Started")
cd /home/corentinfay/Bureau/RestRepo/Client
java -Djava.awt.headless=false -jar target/Client-0.0.1-SNAPSHOT.jar --gui
```

---

## 🎉 Cette Méthode FONCTIONNE TOUJOURS !

**Pas de script qui échoue**  
**Pas de services qui ne démarrent pas**  
**Vous voyez tout ce qui se passe**  
**Contrôle total**

---

**Ouvrez 6 terminaux et lancez les commandes ci-dessus !** 🚀

