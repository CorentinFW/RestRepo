# 🚀 INSTRUCTIONS DE DÉMARRAGE MANUEL

## Problème résolu : Configuration des agences

Les fichiers de configuration sont **déjà corrects** :

✅ **Agence 1 (Paris Voyages)** - Connectée à :
- Hôtel Paris (8082)
- Hôtel Lyon (8083)

✅ **Agence 2 (Sud Réservations)** - Connectée à :
- Hôtel Lyon (8083)
- Hôtel Montpellier (8084)

---

## 📝 DÉMARRAGE MANUEL (Méthode recommandée)

### Étape 1 : Ouvrir 5 terminaux

Vous aurez besoin de **5 terminaux distincts** :

---

### Terminal 1 : Hôtel Paris

```bash
cd /home/corentinfay/Bureau/RestRepo/Hotellerie
mvn spring-boot:run -Dspring-boot.run.profiles=paris
```

**Attendez de voir :**
```
Started HotellerieApplication in X seconds
Tomcat started on port(s): 8082 (http)
```

---

### Terminal 2 : Hôtel Lyon

```bash
cd /home/corentinfay/Bureau/RestRepo/Hotellerie
mvn spring-boot:run -Dspring-boot.run.profiles=lyon
```

**Attendez de voir :**
```
Started HotellerieApplication in X seconds
Tomcat started on port(s): 8083 (http)
```

---

### Terminal 3 : Hôtel Montpellier

```bash
cd /home/corentinfay/Bureau/RestRepo/Hotellerie
mvn spring-boot:run -Dspring-boot.run.profiles=montpellier
```

**Attendez de voir :**
```
Started HotellerieApplication in X seconds
Tomcat started on port(s): 8084 (http)
```

---

### Terminal 4 : Agence 1 (Paris Voyages)

**IMPORTANT :** Attendez que les 3 hôtels soient démarrés avant de lancer l'agence !

```bash
cd /home/corentinfay/Bureau/RestRepo/Agence
mvn spring-boot:run -Dspring-boot.run.profiles=agence1
```

**Vous devriez voir :**
```
═══════════════════════════════════════════
  Agence Paris Voyages - Configuration REST
  Coefficient de prix: 1.15
  Nombre d'hôtels: 2
  - Hôtel Paris: http://localhost:8082
  - Hôtel Lyon: http://localhost:8083
═══════════════════════════════════════════
Started AgenceApplication in X seconds
Tomcat started on port(s): 8081 (http)
```

✅ **Vérifiez bien que SEULEMENT Paris et Lyon sont listés !**

---

### Terminal 5 : Agence 2 (Sud Réservations)

```bash
cd /home/corentinfay/Bureau/RestRepo/Agence
mvn spring-boot:run -Dspring-boot.run.profiles=agence2
```

**Vous devriez voir :**
```
═══════════════════════════════════════════
  Agence Sud Reservations - Configuration REST
  Coefficient de prix: 1.20
  Nombre d'hôtels: 2
  - Hôtel Lyon: http://localhost:8083
  - Hôtel Montpellier: http://localhost:8084
═══════════════════════════════════════════
Started AgenceApplication in X seconds
Tomcat started on port(s): 8085 (http)
```

✅ **Vérifiez bien que SEULEMENT Lyon et Montpellier sont listés !**

---

## ✅ VÉRIFICATION DES CONFIGURATIONS

### Terminal 6 (pour les tests) :

#### Test 1 : Agence 1 ne doit retourner QUE Paris + Lyon (10 chambres)

```bash
curl -s -X POST http://localhost:8081/api/agence/chambres/rechercher \
  -H "Content-Type: application/json" \
  -d '{"dateArrive":"2025-12-01","dateDepart":"2025-12-05"}' | \
  python3 -m json.tool | grep -E '"hotelNom"|"agenceNom"' | head -20
```

**Résultat attendu :**
```json
"hotelNom": "Grand Hotel Paris",
"agenceNom": "Agence Paris Voyages",
...
"hotelNom": "Hotel Lyon Centre",
"agenceNom": "Agence Paris Voyages",
```

✅ **Vous devez voir UNIQUEMENT "Grand Hotel Paris" et "Hotel Lyon Centre"**
❌ **Vous NE DEVEZ PAS voir "Hotel Mediterranee"**

---

#### Test 2 : Agence 2 ne doit retourner QUE Lyon + Montpellier (10 chambres)

```bash
curl -s -X POST http://localhost:8085/api/agence/chambres/rechercher \
  -H "Content-Type: application/json" \
  -d '{"dateArrive":"2025-12-01","dateDepart":"2025-12-05"}' | \
  python3 -m json.tool | grep -E '"hotelNom"|"agenceNom"' | head -20
```

**Résultat attendu :**
```json
"hotelNom": "Hotel Lyon Centre",
"agenceNom": "Agence Sud Reservations",
...
"hotelNom": "Hotel Mediterranee",
"agenceNom": "Agence Sud Reservations",
```

✅ **Vous devez voir UNIQUEMENT "Hotel Lyon Centre" et "Hotel Mediterranee"**
❌ **Vous NE DEVEZ PAS voir "Grand Hotel Paris"**

---

#### Test 3 : Compter les chambres

**Agence 1 :**
```bash
curl -s -X POST http://localhost:8081/api/agence/chambres/rechercher \
  -H "Content-Type: application/json" \
  -d '{"dateArrive":"2025-12-01","dateDepart":"2025-12-05"}' | \
  python3 -m json.tool | grep -c '"id"'
```

**Résultat attendu : 10** (5 Paris + 5 Lyon)

**Agence 2 :**
```bash
curl -s -X POST http://localhost:8085/api/agence/chambres/rechercher \
  -H "Content-Type: application/json" \
  -d '{"dateArrive":"2025-12-01","dateDepart":"2025-12-05"}' | \
  python3 -m json.tool | grep -c '"id"'
```

**Résultat attendu : 10** (5 Lyon + 5 Montpellier)

---

## 🎯 TESTER AVEC LE CLIENT CLI

### Terminal 7 : Client CLI

```bash
cd /home/corentinfay/Bureau/RestRepo/Client
mvn spring-boot:run
```

**Menu :**
1. Rechercher des chambres
2. Dates : 2025-12-01 → 2025-12-05

**Résultat attendu :**
- ✅ **20 chambres** au total
- ✅ **5 chambres de Paris** (via Agence 1 uniquement)
- ✅ **10 chambres de Lyon** (5 via Agence 1 + 5 via Agence 2) - **DOUBLONS**
- ✅ **5 chambres de Montpellier** (via Agence 2 uniquement)

**Exemple d'affichage attendu :**

```
─── Chambre 1 ───
  🏨 Hôtel: Grand Hotel Paris
  🏢 Agence: Agence Paris Voyages
  💰 Prix: 92,00 €
  
─── Chambre 6 ───
  🏨 Hôtel: Hotel Lyon Centre
  🏢 Agence: Agence Paris Voyages
  💰 Prix: 86,25 €
  
─── Chambre 11 ───
  🏨 Hôtel: Hotel Lyon Centre
  🏢 Agence: Agence Sud Reservations
  💰 Prix: 90,00 €
  
─── Chambre 16 ───
  🏨 Hôtel: Hotel Mediterranee
  🏢 Agence: Agence Sud Reservations
  💰 Prix: 54,00 €
```

---

## 🛑 ARRÊTER PROPREMENT

Dans chaque terminal, faites `Ctrl+C` pour arrêter le service.

---

## 📝 RÉSUMÉ DE LA CONFIGURATION

| Service | Port | Configuration | Hôtels connectés |
|---------|------|---------------|------------------|
| Hôtel Paris | 8082 | `application-paris.properties` | - |
| Hôtel Lyon | 8083 | `application-lyon.properties` | - |
| Hôtel Montpellier | 8084 | `application-montpellier.properties` | - |
| **Agence 1** | 8081 | `application-agence1.properties` | **Paris + Lyon** |
| **Agence 2** | 8085 | `application-agence2.properties` | **Lyon + Montpellier** |

---

## ✅ CONFIRMATION QUE C'EST BON

Vérifiez que dans les logs de démarrage des agences, vous voyez bien :

**Agence 1 :**
```
Nombre d'hôtels: 2
- Hôtel Paris: http://localhost:8082
- Hôtel Lyon: http://localhost:8083
```

**Agence 2 :**
```
Nombre d'hôtels: 2
- Hôtel Lyon: http://localhost:8083
- Hôtel Montpellier: http://localhost:8084
```

Si c'est le cas, **tout est parfait !** 🎉

---

**Date :** 26 novembre 2025  
**Version :** 2.0 - Multi-Agences REST (Configuration correcte)  
**Statut :** ✅ Configuration validée

