# 🏨 Système de Réservation d'Hôtels - REST + H2 - VERSION FINALE

> **✅ Système opérationnel - Tous les bugs corrigés**  
> Date : 27 novembre 2025

---

## 🚀 Démarrage ultra-rapide

### Étape 1 : Démarrer les services
```bash
cd /home/corentinfay/Bureau/RestRepo
./fix-complete.sh
```
*Attend 1-2 minutes que tout démarre*

### Étape 2 : Lancer le client
```bash
cd /home/corentinfay/Bureau/RestRepo
./start-client-clean.sh
```

### Étape 3 : Utiliser
1. Rechercher des chambres (Lyon, 01/12→05/12/2025)
2. Réserver ✅
3. Vérifier dans la console H2

---

## ✅ Bugs identifiés et corrigés

| # | Bug | Symptôme | Solution | Doc |
|---|-----|----------|----------|-----|
| 1 | Erreur Maven | `Input length = 1` | Recréation fichiers .properties | `SOLUTION-FINALE-MAVEN.md` |
| 2 | Hôtel non trouvé | "Hôtel non trouvé" (409) | 3 bases H2 séparées | `CORRECTION-CRITIQUE-H2.md` |
| 3 | Chambre non trouvée | "Chambre non trouvée" (409) | Recherche par ID BD | `CORRECTION-BUG-RESERVATION.md` |
| 4 | Warning AWT | `Nonexistent button 4` | Normal - ignorable | `WARNING-AWT-X11.md` |

**Tous corrigés** ✅

---

## 📁 Structure du projet

```
RestRepo/
├── Hotellerie/              # Services hôteliers (8082-8084)
│   ├── data/               # 3 bases H2 séparées ✨
│   │   ├── hotellerie-paris-db.mv.db
│   │   ├── hotellerie-lyon-db.mv.db
│   │   └── hotellerie-montpellier-db.mv.db
│   └── src/main/resources/
│       ├── application-paris.properties      ✨ Base séparée
│       ├── application-lyon.properties       ✨ Base séparée
│       └── application-montpellier.properties ✨ Base séparée
├── Agence/                  # Services agences (8081, 8085)
├── Client/                  # Interface Swing
├── logs/                    # Logs des services
│
├── fix-complete.sh          ⭐ Script principal
├── start-client-clean.sh    ⭐ Lance le client sans warnings
├── start-system-maven.sh    # Démarre backend
└── arreter-services.sh      # Arrête tout
```

---

## 🎯 Fonctionnalités

### ✅ Opérationnelles

- [x] Recherche multi-hôtels
- [x] Recherche multi-agences
- [x] Réservation avec persistance H2
- [x] Affichage des images
- [x] Coefficients de prix par agence
- [x] Détection conflits de réservation
- [x] Interface graphique Swing
- [x] Consoles H2 pour chaque hôtel

### 🗄️ Base de données

Chaque hôtel a **sa propre base H2** :

| Hôtel | Port | Base de données | Console H2 |
|-------|------|-----------------|------------|
| Paris | 8082 | `hotellerie-paris-db` | http://localhost:8082/h2-console |
| Lyon | 8083 | `hotellerie-lyon-db` | http://localhost:8083/h2-console |
| Montpellier | 8084 | `hotellerie-montpellier-db` | http://localhost:8084/h2-console |

**Connexion H2** :
- JDBC URL : `jdbc:h2:file:./data/hotellerie-{ville}-db`
- User : `sa`
- Password : *(vide)*

---

## 🛠️ Scripts disponibles

| Script | Usage | Description |
|--------|-------|-------------|
| **fix-complete.sh** | `./fix-complete.sh` | ⭐ Correction complète + démarrage (RESET BDD) |
| **rest-persistant.sh** | `./rest-persistant.sh` | 🔄 Redémarrage AVEC conservation des données |
| **start-client-clean.sh** | `./start-client-clean.sh` | Lance client sans warnings |
| **start-system-maven.sh** | `./start-system-maven.sh` | Démarre backend uniquement |
| **arreter-services.sh** | `./arreter-services.sh` | Arrête tous les services |

---

## 📚 Documentation complète

### 🐛 Corrections de bugs

| Fichier | Sujet |
|---------|-------|
| `SOLUTION-FINALE-MAVEN.md` | Erreur Maven "Input length = 1" |
| `CORRECTION-CRITIQUE-H2.md` | Bases H2 partagées → séparées |
| `CORRECTION-BUG-RESERVATION.md` | Bug réservation par ID |
| `WARNING-AWT-X11.md` | Warning AWT (ignorable) |

### 📖 Guides

| Fichier | Sujet |
|---------|-------|
| `IMPLEMENTATION-H2-COMPLETE.md` | Guide complet base H2 |
| `GUIDE-IMPLEMENTATION-H2.md` | Configuration technique H2 |
| `GUIDE-REST-PERSISTANT.md` | 🔄 Redémarrage avec persistance |
| `DEMARRAGE-RAPIDE-H2.md` | Quick start |

---

## 🧪 Tests de vérification

### Test 1 : Bases de données séparées

```bash
ls -lh Hotellerie/data/
```
**Attendu** : 3 fichiers `.mv.db`

### Test 2 : Contenu des bases

**Paris** :
```sql
-- Console H2 : http://localhost:8082/h2-console
SELECT * FROM hotels;
-- Résultat : Grand Hotel Paris
```

**Lyon** :
```sql
-- Console H2 : http://localhost:8083/h2-console
SELECT * FROM hotels;
-- Résultat : Hotel Lyon Centre
```

**Montpellier** :
```sql
-- Console H2 : http://localhost:8084/h2-console
SELECT * FROM hotels;
-- Résultat : Hotel Mediterranee
```

### Test 3 : Réservation complète

1. Lancer : `./start-client-clean.sh`
2. Rechercher à Lyon (01/12→05/12)
3. **Attendu** : 5 chambres ✅
4. Réserver une chambre
5. **Attendu** : "Réservation effectuée avec succès !" ✅
6. Console H2 Lyon : `SELECT * FROM reservations;`
7. **Attendu** : 1 réservation ✅

---

## 💡 Astuces

### Redémarrer en conservant les réservations

```bash
./rest-persistant.sh
```

Ce script redémarre tout **SANS supprimer les bases H2**.  
Parfait pour tester la persistance ou développer avec des données de test.

### Réinitialiser tout

```bash
./arreter-services.sh
rm -rf Hotellerie/data/*.db
./fix-complete.sh
```

### Voir les logs en temps réel

```bash
tail -f logs/hotel-paris.log
tail -f logs/agence1.log
```

### Vérifier les ports utilisés

```bash
netstat -tuln | grep -E '808[0-9]'
```

### Tuer les processus zombies

```bash
pkill -f "Hotellerie\|Agence"
```

---

## 🎓 Technologies utilisées

| Composant | Version | Rôle |
|-----------|---------|------|
| Spring Boot | 2.7.18 | Framework backend |
| H2 Database | 2.1.214 | Base de données embarquée |
| Spring Data JPA | 2.7.18 | ORM / Persistance |
| Hibernate | 5.6.15 | Implémentation JPA |
| Java Swing | Java 25 | Interface graphique |
| Maven | 3.x | Build tool |

---

## 📊 Architecture

```
┌─────────────┐
│   Client    │ (Swing GUI)
│  Port: N/A  │
└──────┬──────┘
       │ REST
       │
   ┌───▼────────────────────────────┐
   │                                │
┌──▼─────────┐              ┌──────▼──────┐
│  Agence 1  │              │  Agence 2   │
│ Port: 8081 │              │ Port: 8085  │
└──┬──────┬──┘              └──┬──────┬───┘
   │      │                    │      │
   │      └──────┬─────────────┘      │
   │             │                    │
┌──▼──────┐  ┌──▼──────┐  ┌──────────▼─┐
│ Paris   │  │ Lyon    │  │Montpellier │
│8082     │  │8083     │  │8084        │
│paris-db │  │lyon-db  │  │mont-db     │
└─────────┘  └─────────┘  └────────────┘
```

---

## ⚠️ Notes importantes

### Warning AWT/X11

Si vous voyez :
```
WARN sun.awt.X11.XToolkit : Exception on Toolkit thread
java.lang.IllegalArgumentException: Nonexistent button 4
```

**C'est normal** - lié à Linux X11. **Aucun impact**. Voir `WARNING-AWT-X11.md`.

### Première réservation

La première réservation peut prendre quelques secondes (initialisation JPA).

### Redémarrage

Après un redémarrage du système, relancez :
```bash
./fix-complete.sh
```

---

## 🎉 Statut final

| Composant | Statut |
|-----------|--------|
| **Backend (Hôtels)** | ✅ Opérationnel |
| **Backend (Agences)** | ✅ Opérationnel |
| **Frontend (Client)** | ✅ Opérationnel |
| **Base de données H2** | ✅ 3 bases séparées |
| **Recherche** | ✅ Fonctionne |
| **Réservation** | ✅ Fonctionne |
| **Persistance** | ✅ Testée |
| **Images** | ✅ Affichées |
| **Bugs** | ✅ Tous corrigés |

---

## 🏆 Récapitulatif du projet

### Parcours

1. ✅ Migration SOAP → REST
2. ✅ Implémentation H2/JPA
3. ✅ Correction bug bases partagées
4. ✅ Correction bug réservation
5. ✅ Correction erreur Maven
6. ✅ Interface graphique Swing
7. ✅ Multi-agences avec coefficients

### Résultat

**Un système de réservation d'hôtels complet, fonctionnel et persistant !**

- 3 hôtels indépendants avec leurs bases H2
- 2 agences avec coefficients différents
- Interface graphique intuitive
- Persistance des données garantie
- Documentation exhaustive

---

## 📞 Support

### En cas de problème

1. Consulter la doc appropriée (voir tableau ci-dessus)
2. Vérifier les logs : `tail -f logs/*.log`
3. Relancer : `./fix-complete.sh`
4. Vérifier les ports : `netstat -tuln | grep 808`

### Commandes de diagnostic

```bash
# Services actifs
ps aux | grep -E "Hotellerie|Agence"

# Ports utilisés
netstat -tuln | grep -E '808[0-9]'

# Bases de données
ls -lh Hotellerie/data/

# Logs récents
tail -50 logs/hotel-paris.log
```

---

## 🎊 C'EST TERMINÉ !

**Votre système est opérationnel.**

**Pour démarrer** :
```bash
./fix-complete.sh
# Attendre 1-2 minutes
./start-client-clean.sh
```

**Bon développement !** 🚀

---

*Documentation finale - 27 novembre 2025*  
*Version : 3.0 (Tous bugs corrigés)*  
*Statut : Production Ready ✅*

