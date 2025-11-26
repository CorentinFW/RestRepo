# ✅ DIAGNOSTIC - Services Fonctionnent, Problème dans la GUI

## 🎯 Situation Actuelle

### ✅ Ce Qui Fonctionne

**TOUS les services backend fonctionnent parfaitement :**

```
Test effectué avec curl et RestTemplate :
✓ Agence 1 (8081) répond au ping
✓ Agence 1 retourne 5 chambres Lyon
✓ Hôtel Paris (8082) retourne 5 chambres
✓ Les APIs REST fonctionnent à 100%
```

### ❓ Ce Qui Ne Fonctionne Pas

**L'interface graphique ne montre pas les chambres.**

---

## 🔍 DIAGNOSTIC À FAIRE

### Dans l'Interface GUI

**Quand vous ouvrez l'interface et faites une recherche, que voyez-vous ?**

#### Scénario 1 : Console Vide ou Erreur de Connexion

**Console affiche :**
```
✗ Erreur: Connection refused
```

**→ Solution :** Le client ne trouve pas les agences.

**Vérifier :** Les URLs dans `Client/src/main/resources/application.properties`

---

#### Scénario 2 : Aucune Chambre Trouvée

**Console affiche :**
```
✓ 0 chambre(s) trouvée(s)
```

**→ Solution :** Les agences répondent mais retournent une liste vide.

**Cause possible :** 
- Filtres trop restrictifs
- Dates invalides
- Problème de parsing des réponses

---

#### Scénario 3 : Erreur dans la Console

**Console affiche :**
```
✗ Erreur: <message d'erreur>
```

**→ Solution :** Lire le message d'erreur pour comprendre.

---

## ✅ TESTS À FAIRE MAINTENANT

### Test 1 : Vérifier la Console de l'Interface

**1. Ouvrir l'interface GUI** (Terminal 6)

**2. Regarder la console en bas**

**3. Noter ce qui est affiché au démarrage**

**Attendu :**
```
[HH:mm:ss] ✓ Interface graphique chargée
[HH:mm:ss] ✓ Connexion établie: Agence REST opérationnelle | Agence REST opérationnelle |
```

**Si vous voyez :**
```
[HH:mm:ss] ✗ Erreur: ...
```

**→ Problème de connexion, continuer ci-dessous.**

---

### Test 2 : Recherche Simple

**Dans l'interface GUI :**

1. **Formulaire de recherche :**
   - Adresse : **Lyon**
   - Date arrivée : **2025-12-01**
   - Date départ : **2025-12-05**
   - (Laisser les autres champs vides)

2. **Cliquer sur "🔍 Rechercher"**

3. **Observer la console :**

**Console devrait afficher :**
```
[HH:mm:ss] 🔍 Recherche de chambres...
[HH:mm:ss]    Critères: adresse=Lyon, dates=2025-12-01 → 2025-12-05
[HH:mm:ss]    Appel du client REST...
[HH:mm:ss] 🔍 Recherche dans 2 agences en parallèle...
[HH:mm:ss] ✓ [http://localhost:8081] Trouvé 5 chambre(s)
[HH:mm:ss] ✓ [http://localhost:8085] Trouvé 5 chambre(s)
[HH:mm:ss]    Réponse reçue: 10 chambre(s)
[HH:mm:ss] ✓ 10 chambre(s) trouvée(s)
```

**Si vous voyez :**
```
[HH:mm:ss] ✗ [http://localhost:8081] Erreur: Connection refused
```

**→ L'agence ne tourne pas ou le client utilise les mauvaises URLs.**

---

### Test 3 : Vérifier les URLs du Client

**Fichier :** `Client/src/main/resources/application.properties`

**Contenu attendu :**
```properties
agence1.url=http://localhost:8081
agence2.url=http://localhost:8085
```

**Vérifier :**
```bash
cat /home/corentinfay/Bureau/RestRepo/Client/src/main/resources/application.properties
```

**Si les URLs sont incorrectes → Les corriger et recompiler :**
```bash
cd Client
mvn clean package -DskipTests
```

---

## 🎯 Actions Immédiates

### 1. Regarder la Console GUI

**Lancer le client et REGARDER la console en bas de l'interface.**

**Noter EXACTEMENT ce qui est affiché.**

---

### 2. Faire une Recherche et Noter

**Faire une recherche Lyon et NOTER ce qui s'affiche dans la console.**

---

### 3. M'envoyer les Messages

**Copier-coller les messages de la console ici.**

**Exemples de ce qu'il faut copier :**
```
[HH:mm:ss] Message 1
[HH:mm:ss] Message 2
[HH:mm:ss] Message 3
```

---

## 🔧 Solutions Possibles

### Problème A : "Connection refused"

**Cause :** Les agences ne sont pas démarrées ou pas sur les bons ports.

**Solution :**
```bash
# Vérifier les services
ps aux | grep 'java.*jar' | grep -E '(Agence|Hotellerie)'

# Vérifier les ports
lsof -i :8081
lsof -i :8085
```

---

### Problème B : "0 chambre trouvée"

**Cause :** Les agences répondent mais retournent une liste vide.

**Solution :** 
1. Tester avec curl :
```bash
curl -X POST http://localhost:8081/api/agence/chambres/rechercher \
  -H "Content-Type: application/json" \
  -d '{"dateArrive":"2025-12-01","dateDepart":"2025-12-05","adresse":"Lyon"}'
```

2. Si curl retourne des chambres mais pas la GUI → Problème de parsing dans le client.

---

### Problème C : URLs Incorrectes

**Vérifier :**
```bash
grep 'agence.*url' /home/corentinfay/Bureau/RestRepo/Client/src/main/resources/application.properties
```

**Devrait afficher :**
```
agence1.url=http://localhost:8081
agence2.url=http://localhost:8085
```

**Si différent → Corriger et recompiler.**

---

## 📋 Checklist de Diagnostic

- [ ] Les 5 services backend tournent (ps aux | grep java)
- [ ] Les ports répondent (curl localhost:8081/8082/8083/8084/8085)
- [ ] Le test Java fonctionne ✅ (déjà fait)
- [ ] L'interface GUI s'ouvre
- [ ] La console GUI affiche des messages
- [ ] Les messages de la console sont copiés ici

---

## 🚀 Prochaine Étape

**LANCEZ le client GUI et REGARDEZ la console en bas.**

**Puis FAITES une recherche et NOTEZ tout ce qui s'affiche.**

**Envoyez-moi les messages de la console pour que je puisse diagnostiquer le vrai problème !**

---

**Test prouvé fonctionnel :** ✅ Services backend 100% opérationnels  
**À vérifier :** Console de l'interface GUI  
**Action requise :** Noter les messages de la console

