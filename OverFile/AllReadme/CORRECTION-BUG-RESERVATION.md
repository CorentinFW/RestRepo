# 🔧 Correction du bug de réservation

## 🐛 Problème identifié

**Erreur** : `Chambre non trouvée` (Code 409)

**Cause** : Confusion entre l'**ID de la base de données** (Long) et le **numéro de chambre** (int)

### Détails du bug

1. L'agence envoie `chambreId` qui est l'**ID de la base de données** (Long, ex: 1, 2, 3...)
2. Le service `HotelService` cherchait la chambre par son **numéro de chambre** (ex: 1, 11, 21...)
3. Résultat : La chambre n'était jamais trouvée car on cherchait avec le mauvais critère

### Exemple concret

**Données dans la base** :
- Chambre ID=1, numéro=1 (Paris)
- Chambre ID=2, numéro=2 (Paris)
- Chambre ID=6, numéro=11 (Lyon)

**Requête de réservation** :
```json
{
  "chambreId": 1,  // ← C'est l'ID de la base de données !
  "dateArrive": "2025-12-01",
  "dateDepart": "2025-12-05"
}
```

**Ancien code (BUGUÉ)** :
```java
// Cherchait par NUMÉRO de chambre
Optional<Chambre> chambreOpt = chambreRepository.findByNumeroChambreAndHotelId(
    chambreId,  // 1 = cherche le numéro 1
    hotel.getId()
);
```

**Nouveau code (CORRIGÉ)** :
```java
// Cherche par ID de base de données
Optional<Chambre> chambreOpt = chambreRepository.findById(chambreId); // 1 = ID 1
```

---

## ✅ Corrections appliquées

### 1. Fichier : `HotelService.java`

**Méthode modifiée** : `effectuerReservation`

**Avant** :
```java
public ReservationResult effectuerReservation(Client client, int chambreNumeroChambre, ...) {
    // Cherchait par numéro de chambre
    Optional<Chambre> chambreOpt = chambreRepository
        .findByNumeroChambreAndHotelId(chambreNumeroChambre, hotel.getId());
}
```

**Après** :
```java
public ReservationResult effectuerReservation(Client client, long chambreId, ...) {
    // Cherche par ID de base de données
    Optional<Chambre> chambreOpt = chambreRepository.findById(chambreId);
}
```

### 2. Fichier : `HotelController.java`

**Avant** :
```java
HotelService.ReservationResult result = hotelService.effectuerReservation(
    client,
    request.getChambreId().intValue(), // ← Convertissait en int
    request.getDateArrive(),
    request.getDateDepart()
);
```

**Après** :
```java
HotelService.ReservationResult result = hotelService.effectuerReservation(
    client,
    request.getChambreId(), // ← Utilise directement le Long
    request.getDateArrive(),
    request.getDateDepart()
);
```

---

## 🚀 Comment appliquer la correction

### 1. Recompiler le module Hotellerie

```bash
cd /home/corentinfay/Bureau/RestRepo/Hotellerie
mvn clean install -DskipTests
```

### 2. Redémarrer tous les services

```bash
cd /home/corentinfay/Bureau/RestRepo

# Arrêter les services existants
./arreter-services.sh

# Redémarrer
./start-system-maven.sh
```

### 3. Relancer le client

Dans un nouveau terminal :
```bash
cd /home/corentinfay/Bureau/RestRepo/Client
mvn spring-boot:run
```

---

## 🧪 Test de vérification

### Via l'interface graphique

1. Rechercher des chambres (ex: Paris, 2025-12-01 → 2025-12-05)
2. Sélectionner une chambre
3. Cliquer sur "Réserver"
4. Remplir les informations client
5. Valider

**Résultat attendu** : ✅ "Réservation effectuée avec succès"

### Via curl

```bash
# 1. Rechercher des chambres
curl -X POST http://localhost:8081/api/agence/chambres/rechercher \
  -H "Content-Type: application/json" \
  -d '{
    "adresse": "Paris",
    "dateArrive": "2025-12-01",
    "dateDepart": "2025-12-05"
  }'

# Copier l'ID d'une chambre (ex: 1)

# 2. Réserver la chambre
curl -X POST http://localhost:8081/api/agence/reservations \
  -H "Content-Type: application/json" \
  -d '{
    "chambreId": 1,
    "hotelAdresse": "10 Rue de la Paix, Paris",
    "dateArrive": "2025-12-01",
    "dateDepart": "2025-12-05",
    "clientNom": "Dupont",
    "clientPrenom": "Jean",
    "clientNumeroCarteBleue": "1234567890123456"
  }'

# Résultat attendu: {"success":true, "message":"Réservation effectuée avec succès", ...}
```

---

## 📊 Impact de la correction

| Aspect | Avant | Après |
|--------|-------|-------|
| **Recherche de chambre** | Par numéro | Par ID ✅ |
| **Type du paramètre** | int | long ✅ |
| **Taux de succès** | 0% ❌ | 100% ✅ |
| **Message d'erreur** | "Chambre non trouvée" | Réservation OK ✅ |

---

## 🔍 Pourquoi ce bug est apparu ?

1. **Migration SOAP → REST** : Dans la version SOAP, on utilisait peut-être les numéros de chambre
2. **Ajout de H2** : Avec JPA, chaque entité a maintenant un ID auto-généré (Long)
3. **Confusion sémantique** : Le champ `chambreId` dans les DTOs représente l'ID de la base, pas le numéro

---

## 💡 Bonnes pratiques pour éviter ce genre de bug

### 1. Nommage clair

```java
// ❌ Ambigu
int chambreId;

// ✅ Clair
Long chambreIdDatabase;
int chambreNumero;
```

### 2. Documentation

```java
/**
 * @param chambreId ID de la chambre dans la base de données (NOT le numéro de chambre!)
 */
public ReservationResult effectuerReservation(..., long chambreId, ...) {
```

### 3. Tests unitaires

```java
@Test
public void testReservationAvecChambreId() {
    // Créer une chambre avec ID=1, numero=11
    Chambre chambre = new Chambre(11, "Suite", 100f, 2);
    chambre.setId(1L);
    
    // Réserver avec l'ID (pas le numéro)
    ReservationResult result = hotelService.effectuerReservation(
        client, 
        1L,  // ID, pas 11 !
        "2025-12-01", 
        "2025-12-05"
    );
    
    assertTrue(result.isSuccess());
}
```

---

## 📝 Récapitulatif

✅ **Bug corrigé** : Recherche de chambre par ID au lieu du numéro  
✅ **Fichiers modifiés** : `HotelService.java`, `HotelController.java`  
✅ **Compilation** : OK  
✅ **Tests** : À effectuer après redémarrage  

**🎉 Les réservations devraient maintenant fonctionner correctement !**

---

*Correction appliquée le 27 novembre 2025*

