# 🔄 Script de redémarrage avec persistance - `rest-persistant.sh`

## 🎯 Objectif

Redémarrer tous les services (hôtels + agences) **SANS supprimer les bases de données H2**, pour conserver toutes les réservations existantes.

## 📋 Ce que fait le script

### Étapes

1. ✅ **Arrête** tous les services (Hotellerie, Agence)
2. ✅ **Vérifie** la présence des bases de données existantes
3. ✅ **Recompile** les modules (Hotellerie, Agence) au cas où
4. ✅ **Redémarre** tous les services
5. ✅ **Affiche** l'état des bases de données

### Ce qui est CONSERVÉ

- ✅ Toutes les bases de données H2 (`.mv.db`)
- ✅ Toutes les réservations
- ✅ Tous les clients enregistrés
- ✅ Toutes les chambres

### Ce qui est RECHARGÉ

- 🔄 Les services Java (nouvelles instances)
- 🔄 Les connexions réseau
- 🔄 Les logs

---

## 🚀 Utilisation

### Commande

```bash
cd /home/corentinfay/Bureau/RestRepo
./rest-persistant.sh
```

### Quand l'utiliser ?

| Situation | Utiliser |
|-----------|----------|
| Après une modification du code | ✅ `rest-persistant.sh` |
| Après un arrêt des services | ✅ `rest-persistant.sh` |
| Pour tester les réservations persistantes | ✅ `rest-persistant.sh` |
| Première installation | ❌ `fix-complete.sh` |
| Problème de bases corrompues | ❌ `fix-complete.sh` |
| Reset complet nécessaire | ❌ `fix-complete.sh` |

---

## 📊 Exemple d'utilisation

### Scénario : Conserver les réservations après redémarrage

```bash
# 1. Faire des réservations via le client
cd Client
mvn spring-boot:run
# ... faire 3 réservations ...
# Fermer le client

# 2. Arrêter tous les services
cd ..
./arreter-services.sh

# 3. Redémarrer SANS perdre les données
./rest-persistant.sh

# 4. Relancer le client
cd Client
mvn spring-boot:run

# 5. Vérifier : les 3 réservations sont toujours là ! ✅
```

---

## 🔍 Sortie du script

### Affichage type

```
═══════════════════════════════════════════════════════════════
  Redémarrage avec persistance des données
═══════════════════════════════════════════════════════════════

⚠️  Les bases de données H2 seront CONSERVÉES
    Les réservations existantes resteront en place

1. Arrêt des services...
  ✓ Services arrêtés

2. Vérification des bases de données existantes...
  ✓ Base Paris trouvée (156K)
  ✓ Base Lyon trouvée (148K)
  ✓ Base Montpellier trouvée (140K)

  ✅ Toutes les bases de données sont présentes
     Les données seront rechargées au démarrage

3. Recompilation des modules...
  → Hotellerie...
    ✓ Hotellerie compilé
  → Agence...
    ✓ Agence compilé

4. Redémarrage des services...
[Logs de démarrage...]

═══════════════════════════════════════════════════════════════
  ✅ Services redémarrés avec données persistantes
═══════════════════════════════════════════════════════════════

📊 État des bases de données :

  Paris (8082)      : 156K
    Console H2 : http://localhost:8082/h2-console
    JDBC URL   : jdbc:h2:file:./data/hotellerie-paris-db

  Lyon (8083)       : 148K
    Console H2 : http://localhost:8083/h2-console
    JDBC URL   : jdbc:h2:file:./data/hotellerie-lyon-db

  Montpellier (8084): 140K
    Console H2 : http://localhost:8084/h2-console
    JDBC URL   : jdbc:h2:file:./data/hotellerie-montpellier-db

💡 Les réservations existantes ont été rechargées depuis la base

Pour lancer le client :
  cd Client
  mvn spring-boot:run
```

---

## 🆚 Comparaison des scripts

| Script | Supprime BDD | Recrée fichiers | Usage |
|--------|--------------|-----------------|-------|
| **fix-complete.sh** | ✅ Oui | ✅ Oui | Première installation / Reset complet |
| **rest-persistant.sh** | ❌ Non | ❌ Non | Redémarrage quotidien / Test persistance |
| **start-system-maven.sh** | ❌ Non | ❌ Non | Simple démarrage (pas de recompilation) |

---

## 🧪 Test de la persistance

### Test complet

```bash
# 1. Démarrer avec bases vides
./fix-complete.sh

# 2. Lancer le client et faire 2 réservations
cd Client
mvn spring-boot:run
# Faire 2 réservations à Lyon
# Fermer le client

# 3. Vérifier dans H2
# Accéder à http://localhost:8083/h2-console
# JDBC : jdbc:h2:file:./data/hotellerie-lyon-db
# SQL : SELECT COUNT(*) FROM reservations;
# Résultat : 2

# 4. Redémarrer SANS supprimer les bases
cd ..
./rest-persistant.sh

# 5. Vérifier à nouveau dans H2
# SQL : SELECT COUNT(*) FROM reservations;
# Résultat : 2 ✅ (données conservées !)

# 6. Relancer le client
cd Client
mvn spring-boot:run
# Les 2 réservations sont visibles ✅
```

---

## 💡 Cas d'usage avancés

### Développement avec données de test

```bash
# 1. Créer des données de test
./fix-complete.sh
cd Client
mvn spring-boot:run
# Créer 10 réservations variées
# Fermer

# 2. Développer sur le code
cd ../Hotellerie/src/main/java/...
# Modifier le code
# Sauvegarder

# 3. Tester avec les données existantes
cd ../..
./rest-persistant.sh
# Les 10 réservations de test sont toujours là ✅
```

### Démonstration client

```bash
# Avant la démo : préparer des données
./rest-persistant.sh
cd Client
mvn spring-boot:run
# Créer des réservations réalistes
# Fermer

# Pendant la démo
./rest-persistant.sh  # Redémarre proprement
cd Client
mvn spring-boot:run
# Les données de démo sont là ✅
```

---

## 🔧 Dépannage

### Problème : "Aucune base trouvée"

**Cause** : Première exécution ou bases supprimées.

**Solution** :
```bash
./fix-complete.sh  # Créer les bases
```

### Problème : "Erreur compilation"

**Cause** : Erreur dans le code source.

**Solution** :
```bash
# Vérifier l'erreur
cd Hotellerie
mvn clean compile

# Corriger le code
# Relancer
cd ..
./rest-persistant.sh
```

### Problème : Les données ne se chargent pas

**Cause** : Base corrompue ou logs d'erreur.

**Solution** :
```bash
# Vérifier les logs
tail -f logs/hotel-*.log

# Si corrompu, reset
./fix-complete.sh
```

---

## 📋 Checklist de vérification

Après avoir lancé `rest-persistant.sh` :

- [ ] Message "✅ Services redémarrés avec données persistantes"
- [ ] 3 bases trouvées (Paris, Lyon, Montpellier)
- [ ] Taille des bases > 0K
- [ ] Logs montrent "✓ Hôtel chargé depuis la base"
- [ ] Console H2 accessible
- [ ] SQL `SELECT * FROM reservations;` retourne les données

---

## 🎯 Résumé

### Le script `rest-persistant.sh` est parfait pour :

✅ Redémarrer après un arrêt  
✅ Tester le code avec des données existantes  
✅ Démontrer la persistance H2  
✅ Développement quotidien  
✅ Conserver les réservations de test  

### N'utilisez PAS ce script pour :

❌ Première installation → `fix-complete.sh`  
❌ Reset complet → `fix-complete.sh`  
❌ Bases corrompues → `fix-complete.sh`  

---

## 🚀 Commandes rapides

```bash
# Redémarrage normal (avec données)
./rest-persistant.sh

# Reset complet (sans données)
./fix-complete.sh

# Arrêt propre
./arreter-services.sh

# Client
cd Client && mvn spring-boot:run
```

---

*Script créé le 27 novembre 2025*  
*Fonctionnalité : Redémarrage avec persistance des données H2*  
*Fichier : rest-persistant.sh*

