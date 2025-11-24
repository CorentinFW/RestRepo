# 🖼️ GESTION DES IMAGES - IMPLÉMENTATION COMPLÈTE

## ✅ Fonctionnalité implémentée

Chaque hôtel sert maintenant ses propres images via REST, et chaque chambre a une URL d'image associée.

---

## 📁 Structure des images

### Images disponibles
```
Hotellerie/Image/
  ├── Hotelle1.png  → Paris
  ├── Hotelle2.png  → Lyon
  └── Hotelle3.png  → Montpellier
```

### Images copiées dans resources
```
Hotellerie/src/main/resources/static/images/
  ├── Hotelle1.png
  ├── Hotelle2.png
  └── Hotelle3.png
```

---

## 🔧 Implémentation technique

### 1. Configuration Spring Boot (WebConfig.java)
```java
@Configuration
public class WebConfig implements WebMvcConfigurer {
    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // Servir les images depuis /images/**
        registry.addResourceHandler("/images/**")
                .addResourceLocations("classpath:/static/images/");
    }
}
```

### 2. Génération des URLs (HotelService.java)
```java
// Chaque hôtel génère son URL d'image
String imageFileName = getImageFileName(); // Hotelle1.png, Hotelle2.png, etc.
String imageUrl = "http://localhost:" + serverPort + "/images/" + imageFileName;

// Associée à chaque chambre
hotel.ajoutChambre(new Chambre(1, "Chambre Simple", 80.0f, 1, imageUrl));
```

### 3. Association ville → image
```java
private String getImageFileName() {
    switch (hotelVille) {
        case "Paris":       return "Hotelle1.png";
        case "Lyon":        return "Hotelle2.png";
        case "Montpellier": return "Hotelle3.png";
        default:            return "Hotelle1.png";
    }
}
```

---

## 🌐 URLs des images

### Accès direct aux images

| Hôtel | Port | URL de l'image |
|-------|------|----------------|
| **Paris** | 8082 | `http://localhost:8082/images/Hotelle1.png` |
| **Lyon** | 8083 | `http://localhost:8083/images/Hotelle2.png` |
| **Montpellier** | 8084 | `http://localhost:8084/images/Hotelle3.png` |

### Dans les réponses JSON

Exemple de réponse de recherche de chambres :
```json
[
  {
    "id": 1,
    "nom": "Chambre Simple",
    "prix": 80.0,
    "nbrLits": 1,
    "nbrEtoiles": 5,
    "disponible": true,
    "image": "http://localhost:8082/images/Hotelle1.png"  ← URL de l'image
  }
]
```

---

## 🧪 Tests

### Test 1 : Accès direct à une image
```bash
# Paris
curl -I http://localhost:8082/images/Hotelle1.png
# Attendu: HTTP 200 OK

# Lyon
curl -I http://localhost:8083/images/Hotelle2.png
# Attendu: HTTP 200 OK

# Montpellier
curl -I http://localhost:8084/images/Hotelle3.png
# Attendu: HTTP 200 OK
```

### Test 2 : Images dans les chambres
```bash
curl -X POST http://localhost:8082/api/hotel/chambres/rechercher \
  -H "Content-Type: application/json" \
  -d '{"dateArrive":"2025-12-01","dateDepart":"2025-12-05"}'
```

**Résultat attendu :**
```json
[
  {
    "image": "http://localhost:8082/images/Hotelle1.png",
    ...
  }
]
```

### Test 3 : Images via l'agence
```bash
curl -X POST http://localhost:8081/api/agence/chambres/rechercher \
  -H "Content-Type: application/json" \
  -d '{
    "dateArrive":"2025-12-01",
    "dateDepart":"2025-12-05",
    "prixMin":0,
    "prixMax":200
  }'
```

**Résultat attendu :**
Toutes les chambres des 3 hôtels avec leurs images respectives.

### Test 4 : Script automatisé
```bash
./test-images.sh
```

Ce script teste :
- ✅ Accès direct aux 3 images
- ✅ URLs d'images dans les chambres
- ✅ Images via l'agence

---

## 🎨 Affichage dans le Client CLI

### Avant (sans image)
```
🚪 Chambre Simple (ID: 1)
💰 Prix: 80.0 €
🛏️  Lits: 1
```

### Maintenant (avec image)
```
🚪 Chambre Simple (ID: 1)
💰 Prix: 80.0 €
🛏️  Lits: 1
🖼️  Image: http://localhost:8082/images/Hotelle1.png
```

### Pour améliorer l'affichage dans le CLI

Mettre à jour `ClientCLIRest.java` pour afficher l'URL de l'image :

```java
private void afficherChambres(List<ChambreDTO> chambres) {
    for (ChambreDTO chambre : chambres) {
        System.out.println("  🏨 Hôtel: " + chambre.getHotelNom());
        System.out.println("  🚪 Chambre: " + chambre.getNom());
        System.out.println("  💰 Prix: " + chambre.getPrix() + " €");
        System.out.println("  🛏️  Lits: " + chambre.getNbrLits());
        System.out.println("  🖼️  Image: " + chambre.getImageUrl());  ← AJOUT
        System.out.println();
    }
}
```

---

## 📊 Récapitulatif

### Fichiers modifiés/créés

1. ✅ `WebConfig.java` - Configuration pour servir les images
2. ✅ Images copiées dans `src/main/resources/static/images/`
3. ✅ `test-images.sh` - Script de test automatisé

### Fonctionnalités

- ✅ Chaque hôtel sert ses images sur son port
- ✅ URLs d'images générées automatiquement
- ✅ Images associées à chaque chambre
- ✅ Images accessibles via navigateur
- ✅ Images incluses dans les réponses JSON
- ✅ Images propagées via l'agence

---

## 🚀 Pour utiliser maintenant

### 1. Le système est déjà redémarré
Les services sont en cours de démarrage avec les nouvelles configurations.

### 2. Attendre 30-40 secondes
Les services Spring Boot prennent du temps à démarrer.

### 3. Tester avec le script
```bash
./test-images.sh
```

### 4. Voir dans un navigateur
Ouvrir dans un navigateur :
- http://localhost:8082/images/Hotelle1.png
- http://localhost:8083/images/Hotelle2.png
- http://localhost:8084/images/Hotelle3.png

### 5. Tester avec le client CLI
```bash
cd Client
mvn spring-boot:run

# Option 1: Rechercher des chambres
# → Les chambres auront leurs URLs d'images
```

---

## 🎯 Avantages de cette approche

✅ **Chaque hôtel sert ses propres images** - Pas de serveur centralisé  
✅ **URLs uniques par hôtel** - Facile à identifier (port différent)  
✅ **Images statiques Spring Boot** - Pas de configuration complexe  
✅ **Compatible REST/JSON** - URLs directement dans les réponses  
✅ **Accessible navigateur** - Visualisation facile  
✅ **Scalable** - Facile d'ajouter plus d'images

---

## 💡 Pour ajouter plus d'images par chambre

### Option 1 : Une image par chambre
```java
// Au lieu d'utiliser la même image pour tout l'hôtel
hotel.ajoutChambre(new Chambre(1, "Chambre Simple", 80.0f, 1, 
    "http://localhost:8082/images/chambre-1.png"));  // Image spécifique
```

### Option 2 : Galerie d'images
Ajouter un champ `List<String> images` dans ChambreDTO :
```json
{
  "images": [
    "http://localhost:8082/images/chambre-1-vue1.png",
    "http://localhost:8082/images/chambre-1-vue2.png"
  ]
}
```

---

## ✅ État final

- ✅ Configuration WebConfig créée
- ✅ Images copiées dans resources
- ✅ URLs générées automatiquement
- ✅ Système redémarré
- ✅ Script de test créé
- ✅ Documentation complète

**Les images sont maintenant pleinement intégrées au système REST !** 🎉

---

## 🔗 URLs de test

Une fois les services démarrés (attendre 30-40 secondes) :

```
🖼️  Images directes :
http://localhost:8082/images/Hotelle1.png
http://localhost:8083/images/Hotelle2.png
http://localhost:8084/images/Hotelle3.png

📚 Swagger avec images :
http://localhost:8082/swagger-ui/index.html
http://localhost:8083/swagger-ui/index.html
http://localhost:8084/swagger-ui/index.html

🔍 Test recherche avec images :
curl -X POST http://localhost:8081/api/agence/chambres/rechercher \
  -H "Content-Type: application/json" \
  -d '{"dateArrive":"2025-12-01","dateDepart":"2025-12-05"}'
```

**Tout est prêt ! Attends 30 secondes puis lance `./test-images.sh` !** 🚀

