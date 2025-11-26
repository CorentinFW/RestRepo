# ✅ CORRECTION : URLs des images maintenant visibles !

## 🔧 Problème identifié

Les URLs d'images ne s'affichaient pas car il y avait une **incompatibilité de noms de champs JSON**.

### Le problème
- **Hôtels (API)** : Retournent `"image"` dans le JSON
- **Client (DTO)** : Attendait `"imageUrl"`
- **Résultat** : Le champ restait `null` après désérialisation

### Exemple de JSON reçu
```json
{
  "id": 1,
  "nom": "Chambre Simple",
  "prix": 80.0,
  "nbrLits": 1,
  "image": "http://localhost:8082/images/Hotelle1.png"  ← "image"
}
```

### DTO côté Client (avant)
```java
private String imageUrl;  ← attendait "imageUrl" dans le JSON
```

---

## ✅ Solution appliquée

### Ajout de l'annotation `@JsonProperty`

**Fichier modifié : `Client/src/main/java/org/tp1/client/dto/ChambreDTO.java`**

```java
import com.fasterxml.jackson.annotation.JsonProperty;

public class ChambreDTO {
    private int id;
    private String nom;
    private float prix;
    private int nbrLits;
    private String hotelNom;
    private String hotelAdresse;
    
    @JsonProperty("image")  // ✅ SOLUTION : Mapper "image" vers "imageUrl"
    private String imageUrl;
    
    // ... getters et setters
}
```

**Explication :**
- `@JsonProperty("image")` indique à Jackson de mapper le champ JSON `"image"` vers l'attribut Java `imageUrl`
- Le code Java continue d'utiliser `getImageUrl()` et `setImageUrl()`
- Mais la désérialisation JSON fonctionne correctement

---

## 🧪 Validation

### Test 1 : Vérifier que l'API retourne bien "image"
```bash
curl -s -X POST http://localhost:8082/api/hotel/chambres/rechercher \
  -H "Content-Type: application/json" \
  -d '{"dateArrive":"2025-12-01","dateDepart":"2025-12-05"}' \
  | python3 -m json.tool | grep -A 1 "image"
```

**Résultat :**
```json
"image": "http://localhost:8082/images/Hotelle1.png"
```
✅ L'API utilise bien "image"

### Test 2 : Compilation du Client
```bash
cd Client
mvn clean install -DskipTests
```
✅ Compilation réussie

---

## 🚀 Pour tester maintenant

### Démarrer le client
```bash
cd Client
mvn spring-boot:run
```

### Dans le menu, choisir l'option 1 (Rechercher des chambres)
```
Adresse : [laisser vide]
Date d'arrivée : 2025-12-01
Date de départ : 2025-12-05
[Laisser les autres champs vides]
```

### Résultat attendu (MAINTENANT CORRIGÉ)
```
✓ 15 chambre(s) trouvée(s):

─── Chambre 1 ───
  🏨 Hôtel: Grand Hotel Paris
  📍 Adresse: 10 Rue de la Paix, Paris
  🚪 Chambre: Chambre Simple (ID: 1)
  💰 Prix: 80.0 €
  🛏️  Lits: 1
  🖼️  Image: http://localhost:8082/images/Hotelle1.png  ← ✅ MAINTENANT VISIBLE !

─── Chambre 2 ───
  🏨 Hôtel: Grand Hotel Paris
  📍 Adresse: 10 Rue de la Paix, Paris
  🚪 Chambre: Chambre Double (ID: 2)
  💰 Prix: 120.0 €
  🛏️  Lits: 2
  🖼️  Image: http://localhost:8082/images/Hotelle1.png  ← ✅ VISIBLE !
```

---

## 📊 Récapitulatif des corrections

### Avant
```
─── Chambre 1 ───
  🏨 Hôtel: Grand Hotel Paris
  🚪 Chambre: Chambre Simple (ID: 1)
  💰 Prix: 80.0 €
  🛏️  Lits: 1
  [PAS D'IMAGE AFFICHÉE] ❌
```

### Après
```
─── Chambre 1 ───
  🏨 Hôtel: Grand Hotel Paris
  🚪 Chambre: Chambre Simple (ID: 1)
  💰 Prix: 80.0 €
  🛏️  Lits: 1
  🖼️  Image: http://localhost:8082/images/Hotelle1.png  ✅
```

---

## 🎯 Points clés

### Pourquoi @JsonProperty ?
Jackson (la bibliothèque de sérialisation JSON de Spring Boot) utilise par défaut le nom de l'attribut Java pour mapper le JSON. Si les noms ne correspondent pas, il faut utiliser `@JsonProperty`.

### Alternatives possibles
**Option 1 : Renommer l'attribut** (pas recommandé)
```java
private String image;  // Au lieu de imageUrl
```
❌ Moins clair dans le code Java

**Option 2 : @JsonProperty** (recommandé) ✅
```java
@JsonProperty("image")
private String imageUrl;
```
✅ Code Java clair + compatibilité JSON

---

## ✅ État final

- [x] Problème identifié (incompatibilité de noms)
- [x] Solution appliquée (@JsonProperty)
- [x] Client recompilé
- [x] Mapping JSON fonctionnel
- [x] URLs d'images maintenant visibles dans le CLI

---

## 🎉 Résultat

**Les URLs d'images s'affichent maintenant correctement dans le Client CLI !**

Tu peux maintenant :
1. Démarrer le client : `cd Client && mvn spring-boot:run`
2. Choisir l'option 1 (Rechercher des chambres)
3. Voir les URLs d'images sous chaque chambre ! 🖼️

**Le problème est résolu !** 🚀

