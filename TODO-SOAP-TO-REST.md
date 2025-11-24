# 📋 TODO Liste : Transformation SOAP → REST

## 🎯 Vue d'ensemble

Transformation d'un système de réservation hôtelière de **SOAP Spring Boot** vers **REST Spring Boot** tout en conservant la structure du projet (3 modules : Hotellerie, Agence, Client).

---

## 📊 Architecture Cible

```
┌─────────────┐
│   CLIENT    │  (CLI)
│  (Spring)   │  Interface en ligne de commande
└──────┬──────┘
       │ REST API (HTTP/JSON)
       ↓
┌─────────────┐
│   AGENCE    │  (Port: 8081)
│  (Spring)   │  Agrège les résultats des hôtels
│             │  Endpoints REST exposés + Clients REST
└──────┬──────┘
       │ REST API (HTTP/JSON)
       ├─────────────┬─────────────┐
       ↓             ↓             ↓
┌──────────┐  ┌──────────┐  ┌──────────┐
│  HÔTEL   │  │  HÔTEL   │  │  HÔTEL   │
│  Paris   │  │  Lyon    │  │Montpellier│
│ (8082)   │  │ (8083)   │  │  (8084)  │
│REST API  │  │REST API  │  │REST API  │
└──────────┘  └──────────┘  └──────────┘
```

---

## 🏗️ MODULE 1 : HOTELLERIE (Service REST des Hôtels) ✅ TERMINÉ

### ✅ Étape 1.1 : Mise à jour des dépendances Maven ✅
- [x] **Fichier** : `Hotellerie/pom.xml`
- [x] Remplacer `spring-boot-starter-web-services` par `spring-boot-starter-web`
- [x] Supprimer les dépendances SOAP :
  - `wsdl4j`
  - `jaxb-api`, `jaxb-impl`, `jaxb-core` (si non utilisé ailleurs)
- [x] Supprimer le plugin `maven-jaxb2-plugin`
- [x] Ajouter (optionnel) : `spring-boot-starter-validation` pour validation
- [x] Ajouter (optionnel) : `springdoc-openapi-ui` pour documentation Swagger

### ✅ Étape 1.2 : Supprimer les fichiers SOAP/XSD ✅
- [x] **Dossier** : `Hotellerie/src/main/resources/xsd/` → Supprimer `hotel.xsd`
- [x] **Dossier** : `Hotellerie/src/main/resources/wsdl/` → Supprimer si existe
- [x] **Dossier** : `Hotellerie/target/generated-sources/jaxb/` → Sera recréé au build

### ✅ Étape 1.3 : Créer les DTOs REST ✅
- [x] **Nouveau fichier** : `Hotellerie/src/main/java/org/tp1/hotellerie/dto/ChambreDTO.java`
  - Contient : id, nom, prix, nbrLits, nbrEtoiles, disponible, image
- [x] **Nouveau fichier** : `Hotellerie/src/main/java/org/tp1/hotellerie/dto/RechercheRequest.java`
  - Contient : adresse, dateArrive, dateDepart, prixMin, prixMax, nbrEtoile, nbrLits
- [x] **Nouveau fichier** : `Hotellerie/src/main/java/org/tp1/hotellerie/dto/ReservationRequest.java`
  - Contient : chambreId, dateArrive, dateDepart, nomClient, prenomClient, numeroCarteBancaire
- [x] **Nouveau fichier** : `Hotellerie/src/main/java/org/tp1/hotellerie/dto/ReservationResponse.java`
  - Contient : reservationId, message, success
- [x] **Nouveau fichier** : `Hotellerie/src/main/java/org/tp1/hotellerie/dto/HotelInfoDTO.java`
  - Contient : nom, adresse, ville, telephone

### ✅ Étape 1.4 : Créer le RestController pour l'Hôtel ✅
- [x] **Nouveau fichier** : `Hotellerie/src/main/java/org/tp1/hotellerie/controller/HotelController.java`
- [x] Annotations : `@RestController`, `@RequestMapping("/api/hotel")`
- [x] **Endpoints à créer** :
  - `GET /api/hotel/info` → Retourne les infos de l'hôtel ✅ Testé
  - `POST /api/hotel/chambres/rechercher` → Recherche de chambres ✅ Testé
  - `POST /api/hotel/reservations` → Créer une réservation ✅ Testé
  - `GET /api/hotel/reservations` → Lister toutes les réservations ✅
  - `GET /api/hotel/chambres/{id}` → Détails d'une chambre ✅

### ✅ Étape 1.5 : Adapter le Service existant ✅
- [x] **Fichier** : `Hotellerie/src/main/java/org/tp1/hotellerie/soap/HotelService.java`
- [x] Renommer en `HotelService.java` et déplacer vers `service/`
- [x] Supprimer les dépendances aux classes générées SOAP
- [x] Ajouter annotation `@Service`
- [x] Conserver la logique métier (recherche, réservation)

### ✅ Étape 1.6 : Supprimer la configuration SOAP ✅
- [x] **Fichier** : `Hotellerie/src/main/java/org/tp1/hotellerie/soap/WebServiceConfig.java`
- [x] Supprimer complètement ce fichier
- [x] **Fichier** : `Hotellerie/src/main/java/org/tp1/hotellerie/soap/HotelEndpoint.java`
- [x] Supprimer complètement ce fichier

### ✅ Étape 1.7 : Configurer les propriétés REST ✅
- [x] **Fichier** : `Hotellerie/src/main/resources/application.properties`
- [x] Supprimer les configurations SOAP
- [x] Conserver : `server.port`, `spring.application.name`
- [x] Ajouter (optionnel) : configurations CORS, Jackson

### ✅ Étape 1.8 : Test du module Hotellerie ✅
- [x] Compiler : `cd Hotellerie && mvn clean install`
- [x] Démarrer : `mvn spring-boot:run -Dspring-boot.run.profiles=paris`
- [x] Tester avec cURL ou Postman :
  ```bash
  curl http://localhost:8082/api/hotel/info
  # Swagger UI : http://localhost:8082/swagger-ui/index.html
  ```

---

## 🏗️ MODULE 2 : AGENCE (Service REST Agence + Client REST vers Hôtels)

### ✅ Étape 2.1 : Mise à jour des dépendances Maven
- [ ] **Fichier** : `Agence/pom.xml`
- [ ] Remplacer `spring-boot-starter-web-services` par `spring-boot-starter-web`
- [ ] Supprimer les dépendances SOAP :
  - `wsdl4j`
  - `jaxb-api`, `jaxb-impl`, `jaxb-core`
- [ ] Supprimer les plugins JAXB (`jaxb2-maven-plugin`)
- [ ] Ajouter : `spring-boot-starter-webflux` (pour RestTemplate ou WebClient)

### ✅ Étape 2.2 : Supprimer les fichiers SOAP/XSD/WSDL
- [ ] **Dossier** : `Agence/src/main/resources/xsd/` → Supprimer `agence.xsd`, `hotel.xsd`
- [ ] **Dossier** : `Agence/src/main/resources/wsdl/` → Supprimer `hotel.wsdl`
- [ ] **Dossier** : `Agence/target/generated-sources/jaxb/` → Sera recréé au build

### ✅ Étape 2.3 : Réutiliser/Adapter les DTOs existants
- [ ] **Fichier** : `Agence/src/main/java/org/tp1/agence/dto/ChambreDTO.java`
- [ ] Vérifier qu'il correspond au format REST (JSON)
- [ ] **Fichier** : `Agence/src/main/java/org/tp1/agence/dto/RechercheRequest.java`
- [ ] Adapter si nécessaire pour REST
- [ ] **Fichier** : `Agence/src/main/java/org/tp1/agence/dto/ReservationRequest.java`
- [ ] Adapter si nécessaire pour REST
- [ ] **Fichier** : `Agence/src/main/java/org/tp1/agence/dto/ReservationResponse.java`
- [ ] Adapter si nécessaire pour REST

### ✅ Étape 2.4 : Créer le RestController pour l'Agence
- [ ] **Nouveau fichier** : `Agence/src/main/java/org/tp1/agence/controller/AgenceController.java`
- [ ] Annotations : `@RestController`, `@RequestMapping("/api/agence")`
- [ ] **Endpoints à créer** :
  - `GET /api/agence/ping` → Test de connexion
  - `POST /api/agence/chambres/rechercher` → Recherche agrégée dans tous les hôtels
  - `POST /api/agence/reservations` → Créer une réservation dans un hôtel
  - `GET /api/agence/reservations/{hotel}` → Réservations par hôtel

### ✅ Étape 2.5 : Créer le Client REST pour les Hôtels
- [ ] **Nouveau fichier** : `Agence/src/main/java/org/tp1/agence/client/HotelRestClient.java`
- [ ] Utiliser `RestTemplate` ou `WebClient` (Spring WebFlux)
- [ ] **Méthodes à créer** :
  - `getHotelInfo(String baseUrl)` → Appel GET `/api/hotel/info`
  - `rechercherChambres(String baseUrl, RechercheRequest request)` → POST `/api/hotel/chambres/rechercher`
  - `effectuerReservation(String baseUrl, ReservationRequest request)` → POST `/api/hotel/reservations`
  - `getReservations(String baseUrl)` → GET `/api/hotel/reservations`

### ✅ Étape 2.6 : Créer le Client Multi-Hôtels
- [ ] **Nouveau fichier** : `Agence/src/main/java/org/tp1/agence/client/MultiHotelRestClient.java`
- [ ] Annotation : `@Component`
- [ ] Configurer les URLs des hôtels (Paris, Lyon, Montpellier)
- [ ] Méthode pour interroger tous les hôtels en parallèle (avec CompletableFuture)
- [ ] Agréger les résultats

### ✅ Étape 2.7 : Adapter le Service Agence
- [ ] **Fichier** : `Agence/src/main/java/org/tp1/agence/service/AgenceService.java`
- [ ] Remplacer l'injection de `MultiHotelSoapClient` par `MultiHotelRestClient`
- [ ] Adapter les appels pour utiliser REST au lieu de SOAP
- [ ] Conserver la logique d'agrégation

### ✅ Étape 2.8 : Supprimer la configuration SOAP
- [ ] **Fichier** : `Agence/src/main/java/org/tp1/agence/config/AgenceWebServiceConfig.java`
- [ ] Supprimer complètement ce fichier
- [ ] **Fichier** : `Agence/src/main/java/org/tp1/agence/endpoint/AgenceEndpoint.java`
- [ ] Supprimer complètement ce fichier
- [ ] **Fichiers** : `Agence/src/main/java/org/tp1/agence/client/HotelSoapClient.java`
- [ ] Supprimer tous les anciens clients SOAP

### ✅ Étape 2.9 : Créer la configuration REST
- [ ] **Nouveau fichier** : `Agence/src/main/java/org/tp1/agence/config/RestClientConfig.java`
- [ ] Créer un Bean `RestTemplate` ou `WebClient`
- [ ] Configurer timeouts, intercepteurs si nécessaire

### ✅ Étape 2.10 : Configurer les propriétés REST
- [ ] **Fichier** : `Agence/src/main/resources/application.properties`
- [ ] Supprimer les configurations SOAP
- [ ] Ajouter les URLs des hôtels :
  ```properties
  hotel.paris.url=http://localhost:8082
  hotel.lyon.url=http://localhost:8083
  hotel.montpellier.url=http://localhost:8084
  ```

### ✅ Étape 2.11 : Test du module Agence
- [ ] Compiler : `cd Agence && mvn clean install`
- [ ] S'assurer que les hôtels sont démarrés
- [ ] Démarrer : `mvn spring-boot:run`
- [ ] Tester avec cURL :
  ```bash
  curl http://localhost:8081/api/agence/ping
  ```

---

## 🏗️ MODULE 3 : CLIENT (CLI avec Client REST vers Agence)

### ✅ Étape 3.1 : Mise à jour des dépendances Maven
- [ ] **Fichier** : `Client/pom.xml`
- [ ] Remplacer `spring-boot-starter-web-services` par `spring-boot-starter-web`
- [ ] Supprimer les dépendances SOAP :
  - `wsdl4j`
  - `jaxb-api`, `jaxb-impl`, `jaxb-core`
- [ ] Supprimer le plugin `maven-jaxb2-plugin`
- [ ] Conserver : `jline` (pour CLI)

### ✅ Étape 3.2 : Supprimer les fichiers WSDL
- [ ] **Dossier** : `Client/src/main/resources/wsdl/` → Supprimer `agence.wsdl`
- [ ] **Dossier** : `Client/target/generated-sources/` → Sera nettoyé au build

### ✅ Étape 3.3 : Créer les DTOs REST (côté client)
- [ ] **Nouveau fichier** : `Client/src/main/java/org/tp1/client/dto/ChambreDTO.java`
- [ ] **Nouveau fichier** : `Client/src/main/java/org/tp1/client/dto/RechercheRequest.java`
- [ ] **Nouveau fichier** : `Client/src/main/java/org/tp1/client/dto/ReservationRequest.java`
- [ ] **Nouveau fichier** : `Client/src/main/java/org/tp1/client/dto/ReservationResponse.java`
- [ ] **Nouveau fichier** : `Client/src/main/java/org/tp1/client/dto/HotelChambreDTO.java`
- [ ] Copier/adapter depuis le module Agence

### ✅ Étape 3.4 : Créer le Client REST pour l'Agence
- [ ] **Nouveau fichier** : `Client/src/main/java/org/tp1/client/rest/AgenceRestClient.java`
- [ ] Utiliser `RestTemplate` ou `WebClient`
- [ ] Annotation : `@Component`
- [ ] **Méthodes à créer** :
  - `ping()` → GET `/api/agence/ping`
  - `rechercherChambres(RechercheRequest request)` → POST `/api/agence/chambres/rechercher`
  - `effectuerReservation(ReservationRequest request)` → POST `/api/agence/reservations`
  - `getReservationsParHotel(String hotelNom)` → GET `/api/agence/reservations/{hotel}`

### ✅ Étape 3.5 : Adapter le CLI
- [ ] **Fichier** : `Client/src/main/java/org/tp1/client/cli/ClientCLISoap.java`
- [ ] Renommer en `ClientCLIRest.java`
- [ ] Remplacer l'injection de `AgenceSoapClient` par `AgenceRestClient`
- [ ] Adapter tous les appels pour utiliser REST
- [ ] Conserver l'interface utilisateur CLI

### ✅ Étape 3.6 : Supprimer la configuration SOAP
- [ ] **Fichier** : `Client/src/main/java/org/tp1/client/config/SoapClientConfig.java`
- [ ] Supprimer complètement ce fichier
- [ ] **Fichier** : `Client/src/main/java/org/tp1/client/soap/AgenceSoapClient.java`
- [ ] Supprimer complètement ce fichier

### ✅ Étape 3.7 : Créer la configuration REST
- [ ] **Nouveau fichier** : `Client/src/main/java/org/tp1/client/config/RestClientConfig.java`
- [ ] Créer un Bean `RestTemplate` ou `WebClient`
- [ ] Configurer l'URL de l'agence

### ✅ Étape 3.8 : Configurer les propriétés REST
- [ ] **Fichier** : `Client/src/main/resources/application.properties`
- [ ] Supprimer les configurations SOAP
- [ ] Ajouter :
  ```properties
  agence.url=http://localhost:8081
  ```

### ✅ Étape 3.9 : Test du module Client
- [ ] Compiler : `cd Client && mvn clean install`
- [ ] S'assurer que l'agence et les hôtels sont démarrés
- [ ] Démarrer : `mvn spring-boot:run`
- [ ] Tester le menu CLI

---

## 🔧 MODULE 4 : SCRIPTS ET DOCUMENTATION

### ✅ Étape 4.1 : Créer les scripts de démarrage REST
- [ ] **Nouveau fichier** : `start-rest-system.sh`
- [ ] Adapter `start-robuste.sh` pour REST (pas de génération WSDL)
- [ ] Créer `start-hotel-rest.sh` (démarre les 3 hôtels)

### ✅ Étape 4.2 : Mettre à jour le README principal
- [ ] **Fichier** : `README.md`
- [ ] Changer "Architecture SOAP" → "Architecture REST"
- [ ] Mettre à jour le diagramme d'architecture (REST au lieu de SOAP)
- [ ] Remplacer les exemples cURL pour REST
- [ ] Mettre à jour les URLs des endpoints
- [ ] Ajouter exemples JSON de requêtes/réponses

### ✅ Étape 4.3 : Mettre à jour les READMEs des modules
- [ ] **Fichier** : `Hotellerie/README.md`
- [ ] Documenter les endpoints REST
- [ ] Exemples cURL/Postman
- [ ] **Fichier** : `Agence/README.md`
- [ ] Documenter les endpoints REST
- [ ] Exemples d'appels
- [ ] **Fichier** : `Client/README.md`
- [ ] Mettre à jour pour REST

### ✅ Étape 4.4 : Ajouter la documentation API (Optionnel)
- [ ] Ajouter Swagger/OpenAPI dans chaque module
- [ ] Configurer les annotations `@Operation`, `@ApiResponse`
- [ ] Accéder à Swagger UI :
  - Hotellerie : http://localhost:8082/swagger-ui.html
  - Agence : http://localhost:8081/swagger-ui.html

---

## 🧪 MODULE 5 : TESTS COMPLETS

### ✅ Étape 5.1 : Test de bout en bout
- [ ] Démarrer les 3 hôtels (Paris, Lyon, Montpellier)
- [ ] Démarrer l'agence
- [ ] Démarrer le client CLI
- [ ] Effectuer une recherche complète
- [ ] Effectuer une réservation
- [ ] Vérifier les logs de chaque module

### ✅ Étape 5.2 : Tests unitaires (Optionnel)
- [ ] Créer des tests REST pour `HotelController`
- [ ] Créer des tests REST pour `AgenceController`
- [ ] Utiliser `@WebMvcTest` et `MockMvc`

### ✅ Étape 5.3 : Tests d'intégration (Optionnel)
- [ ] Créer des tests avec `TestRestTemplate`
- [ ] Tester les appels REST entre modules

---

## 📋 CHECKLIST FINALE

### Avant de commencer
- [ ] Faire un backup du projet SOAP : `cp -r RestRepo RestRepo-SOAP-backup`
- [ ] Créer une branche Git : `git checkout -b soap-to-rest-migration`

### Ordre d'exécution recommandé
1. ✅ **HOTELLERIE** (base du système)
2. ✅ **AGENCE** (dépend de Hotellerie)
3. ✅ **CLIENT** (dépend de Agence)
4. ✅ **SCRIPTS** et **DOCUMENTATION**
5. ✅ **TESTS**

### Vérifications finales
- [ ] Tous les modules compilent sans erreur
- [ ] Aucune dépendance SOAP restante dans les `pom.xml`
- [ ] Aucun fichier `.wsdl` ou `.xsd` dans `/resources/`
- [ ] Les 3 hôtels démarrent sur les bons ports
- [ ] L'agence démarre et communique avec les hôtels
- [ ] Le client CLI fonctionne complètement
- [ ] La documentation est à jour

---

## 🎓 Points d'attention

### Différences SOAP vs REST
| Aspect | SOAP | REST |
|--------|------|------|
| **Format** | XML | JSON |
| **Contrat** | WSDL (contrat strict) | Optionnel (OpenAPI) |
| **Classes** | Générées par JAXB | DTOs manuels (ou Jackson) |
| **Endpoints** | `@Endpoint` + `@PayloadRoot` | `@RestController` + `@RequestMapping` |
| **Client** | `WebServiceGatewaySupport` | `RestTemplate` ou `WebClient` |
| **Config** | `WebServiceConfig` | Configuration minimale |

### Avantages de la migration REST
- ✅ Plus simple et plus léger
- ✅ Format JSON natif pour le web
- ✅ Meilleure compatibilité avec les frameworks modernes
- ✅ Pas besoin de générer des classes depuis XSD/WSDL
- ✅ Debugging plus facile (JSON lisible)
- ✅ Support natif dans tous les navigateurs

### Structure conservée
- ✅ Même architecture 3-tiers (Client → Agence → Hôtels)
- ✅ Même logique métier (recherche, réservation)
- ✅ Même interface CLI
- ✅ Même données (Hotel, Chambre, Reservation)

---

## 📞 Support

Si vous bloquez sur une étape :
1. Vérifiez que l'étape précédente est complète
2. Consultez les logs Spring Boot
3. Testez avec cURL ou Postman avant de passer à l'étape suivante

---

**Bonne migration ! 🚀**

