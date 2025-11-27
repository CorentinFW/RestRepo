# 🎯 Démarrage Rapide - Système avec Base de Données H2

> **⚠️ IMPORTANT** : Un bug de réservation a été corrigé le 27/11/2025.  
> Consultez `CORRECTION-BUG-RESERVATION.md` pour les détails.

## 🚀 Quick Start (3 étapes)

### 1. Compiler les projets (après correction)
```bash
cd /home/corentinfay/Bureau/RestRepo
cd Hotellerie && mvn clean install && cd ..
cd Agence && mvn clean install && cd ..
cd Client && mvn clean install && cd ..
```

### 2. Démarrer tous les services
```bash
./start-system-maven.sh
```

### 3. Lancer le client graphique
Dans un nouveau terminal :
```bash
cd Client
mvn spring-boot:run
```

---

## 📚 Documentation disponible

| Fichier | Description | Utilisez pour |
|---------|-------------|---------------|
| **IMPLEMENTATION-H2-COMPLETE.md** | Documentation complète H2 | Comprendre l'architecture |
| **GUIDE-IMPLEMENTATION-H2.md** | Guide technique détaillé | Configuration avancée |
| **test-h2-database.sh** | Script de test | Vérifier le fonctionnement |

---

## 🔍 Accès rapides

### Console H2 (base de données)
- **Paris** : http://localhost:8082/h2-console
- **Lyon** : http://localhost:8083/h2-console
- **Montpellier** : http://localhost:8084/h2-console

**Connexion** :
- JDBC URL : `jdbc:h2:file:./data/hotellerie-db`
- User : `sa`
- Password : *(vide)*

### API REST (documentation)
- **Paris** : http://localhost:8082/swagger-ui.html
- **Lyon** : http://localhost:8083/swagger-ui.html
- **Montpellier** : http://localhost:8084/swagger-ui.html
- **Agence 1** : http://localhost:8081/swagger-ui.html
- **Agence 2** : http://localhost:8085/swagger-ui.html

---

## ✅ Vérification rapide

### Test manuel
```bash
# 1. Rechercher des chambres
curl -X POST http://localhost:8081/api/agence/chambres/rechercher \
  -H "Content-Type: application/json" \
  -d '{"adresse":"Paris","dateArrive":"2025-12-01","dateDepart":"2025-12-05"}'

# 2. Faire une réservation
curl -X POST http://localhost:8082/api/hotel/reservations \
  -H "Content-Type: application/json" \
  -d '{
    "nomClient":"Test",
    "prenomClient":"User",
    "numeroCarteBancaire":"1234567890123456",
    "chambreId":1,
    "dateArrive":"2025-12-01",
    "dateDepart":"2025-12-05"
  }'

# 3. Vérifier les réservations
curl http://localhost:8082/api/hotel/reservations
```

### Test automatisé
```bash
./test-h2-database.sh
```

---

## 🛠️ Commandes utiles

### Appliquer la correction et redémarrer (RECOMMANDÉ)
```bash
./fix-and-restart.sh
```

### Arrêter tous les services
```bash
./arreter-services.sh
```

### Voir les logs
```bash
tail -f logs/hotel-paris.log
tail -f logs/agence1.log
```

### Nettoyer et recompiler
```bash
cd Hotellerie && mvn clean install
cd ../Agence && mvn clean install
cd ../Client && mvn clean install
```

### Réinitialiser la base de données
```bash
rm -rf Hotellerie/data
# Au prochain démarrage, la base sera recréée
```

---

## ❓ Problèmes fréquents

### Les services ne démarrent pas
```bash
# Vérifier les ports
netstat -tuln | grep -E '808[0-9]'

# Tuer les processus existants
pkill -f "Hotellerie\|Agence"

# Redémarrer
./start-system-maven.sh
```

### Le client ne trouve pas les chambres
1. Vérifier que tous les services sont démarrés
2. Vérifier les dates (arrivée < départ)
3. Consulter `logs/agence1.log` et `logs/hotel-*.log`

### Console H2 inaccessible
1. Vérifier que le service est démarré : `curl http://localhost:8082/actuator/health`
2. Vérifier `application.properties` : `spring.h2.console.enabled=true`

---

## 📦 Structure du projet

```
RestRepo/
├── Hotellerie/           # Service hôtelier (ports 8082-8084)
│   ├── data/            # ← NOUVEAU : Base de données H2
│   └── target/          # JARs compilés
├── Agence/              # Service agence (ports 8081, 8085)
│   └── target/
├── Client/              # Interface graphique Swing
│   └── target/
├── logs/                # Fichiers de logs
├── OverFile/            # Archives (anciens README, scripts)
├── start-system-maven.sh         # Démarrage complet
├── arreter-services.sh           # Arrêt des services
├── test-h2-database.sh          # Tests H2
└── IMPLEMENTATION-H2-COMPLETE.md # Doc complète
```

---

## 🎓 En savoir plus

Consultez **IMPLEMENTATION-H2-COMPLETE.md** pour :
- Architecture détaillée de la base de données
- Exemples de requêtes SQL avancées
- Guide de dépannage complet
- Statistiques et métriques du projet

---

**Bon développement ! 🚀**

