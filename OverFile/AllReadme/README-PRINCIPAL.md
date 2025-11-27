# 🏨 Système de Réservation d'Hôtels - REST avec H2

> **Version finale avec base de données H2 et correction du bug de réservation**

## 🚀 Démarrage ultra-rapide

### Option 1 : Script automatique (RECOMMANDÉ)
```bash
cd /home/corentinfay/Bureau/RestRepo
./fix-and-restart.sh
```

### Option 2 : Démarrage manuel
```bash
# 1. Recompiler Hotellerie (obligatoire après correction)
cd /home/corentinfay/Bureau/RestRepo/Hotellerie
mvn clean install -DskipTests

# 2. Démarrer tous les services
cd ..
./start-system-maven.sh

# 3. Lancer le client (dans un nouveau terminal)
cd Client
mvn spring-boot:run
```

---

## ✅ Vérification rapide

Une fois le client lancé :

1. **Rechercher** : Ville = Paris, Dates = 01/12/2025 → 05/12/2025
2. **Résultat** : Vous devriez voir 5 chambres
3. **Réserver** : Cliquer sur une chambre, puis "Réserver"
4. **Succès** : ✅ "Réservation effectuée avec succès"

---

## 📚 Documentation

| Fichier | Contenu | Quand consulter |
|---------|---------|-----------------|
| **CORRECTION-BUG-RESERVATION.md** | Détails du bug corrigé | En cas de problème de réservation |
| **DEMARRAGE-RAPIDE-H2.md** | Guide de démarrage complet | Pour les commandes détaillées |
| **IMPLEMENTATION-H2-COMPLETE.md** | Documentation H2 | Pour comprendre la base de données |
| **GUIDE-IMPLEMENTATION-H2.md** | Guide technique | Pour la configuration avancée |

---

## 🐛 Bug corrigé (27/11/2025)

**Problème** : Erreur "Chambre non trouvée" lors de la réservation  
**Cause** : Confusion entre ID de base de données et numéro de chambre  
**Solution** : Recherche par ID au lieu du numéro  

➡️ **Voir `CORRECTION-BUG-RESERVATION.md` pour les détails**

---

## 🔍 Accès rapides

### Console H2 (visualiser la base de données)
- Paris : http://localhost:8082/h2-console
- Lyon : http://localhost:8083/h2-console
- Montpellier : http://localhost:8084/h2-console

**Connexion** : `jdbc:h2:file:./data/hotellerie-db` / User: `sa` / Pass: *(vide)*

### API REST (documentation Swagger)
- Hôtels : http://localhost:808X/swagger-ui.html (X = 2, 3, 4)
- Agences : http://localhost:8081/swagger-ui.html et http://localhost:8085/swagger-ui.html

---

## 🛠️ Commandes utiles

```bash
# Arrêter tous les services
./arreter-services.sh

# Voir les logs
tail -f logs/hotel-paris.log
tail -f logs/agence1.log

# Réinitialiser la base de données
rm -rf Hotellerie/data
```

---

## 📦 Architecture

```
RestRepo/
├── Hotellerie/           # Services hôteliers (ports 8082-8084)
│   ├── data/            # Base de données H2 (NOUVEAU)
│   └── src/             # Code source
├── Agence/              # Services agences (ports 8081, 8085)
│   └── src/
├── Client/              # Interface graphique Swing
│   └── src/
├── logs/                # Logs des services
├── fix-and-restart.sh          # Script de correction
├── start-system-maven.sh       # Démarrage complet
└── arreter-services.sh         # Arrêt des services
```

---

## ✨ Fonctionnalités

- ✅ Recherche de chambres disponibles
- ✅ Réservation avec persistance en base H2
- ✅ Multi-agences (2 agences)
- ✅ Multi-hôtels (3 hôtels: Paris, Lyon, Montpellier)
- ✅ Interface graphique Swing
- ✅ Gestion des images de chambres
- ✅ Coefficients de prix par agence
- ✅ Détection des conflits de réservation

---

## 🎓 Technologies utilisées

- **Backend** : Spring Boot 2.7.18, REST API
- **Base de données** : H2 (mode fichier)
- **Persistance** : Spring Data JPA, Hibernate
- **Frontend** : Java Swing
- **Documentation** : Swagger/OpenAPI
- **Build** : Maven

---

## 💡 Astuces

### Tester la persistance

1. Faire une réservation
2. Arrêter tous les services : `./arreter-services.sh`
3. Redémarrer : `./start-system-maven.sh`
4. Relancer le client
5. Vérifier que la réservation existe toujours via Console H2

### Voir les données en base

```sql
-- Dans la console H2
SELECT * FROM reservations;
SELECT * FROM chambres;
SELECT * FROM clients;
```

### Debug

Si un service ne démarre pas :
```bash
# Vérifier les ports utilisés
netstat -tuln | grep 808

# Tuer les processus zombies
pkill -f "Hotellerie\|Agence"

# Relancer
./start-system-maven.sh
```

---

## 📞 En cas de problème

1. ✅ Vérifier que la correction a été appliquée : `ls -la fix-and-restart.sh`
2. ✅ Recompiler : `cd Hotellerie && mvn clean install`
3. ✅ Consulter les logs : `tail -f logs/*.log`
4. ✅ Lire `CORRECTION-BUG-RESERVATION.md`

---

## 🎉 Statut du projet

| Composant | Statut |
|-----------|--------|
| **Base de données H2** | ✅ Opérationnelle |
| **API REST** | ✅ Fonctionnelle |
| **Réservations** | ✅ Corrigées (27/11/2025) |
| **Interface graphique** | ✅ Opérationnelle |
| **Persistance** | ✅ Testée |
| **Documentation** | ✅ Complète |

**🏆 Le système est prêt à l'emploi !**

---

*Dernière mise à jour : 27 novembre 2025*  
*Version : 2.0 (avec correction bug réservation)*

