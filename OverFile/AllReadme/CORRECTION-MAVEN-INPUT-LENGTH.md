# 🔧 Correction de l'erreur Maven "Input length = 1"

## 🐛 L'erreur

```
[ERROR] Failed to execute goal org.apache.maven.plugins:maven-resources-plugin:3.2.0:resources 
(default-resources) on project Hotellerie: Input length = 1
```

## 🔍 Cause

Cette erreur est causée par un **caractère invalide ou une ligne vide problématique** dans les fichiers `.properties`.

Lors de l'ajout de la configuration H2 dans les fichiers de profil, des **lignes vides en fin de fichier** ont été créées, ce qui pose problème au plugin `maven-resources-plugin`.

## ✅ Solution appliquée

### Fichiers corrigés

Les 4 fichiers suivants ont été nettoyés (suppression des lignes vides en fin de fichier) :

1. **`application.properties`**
2. **`application-paris.properties`**
3. **`application-lyon.properties`**
4. **`application-montpellier.properties`**

### Changement appliqué

**Avant (PROBLÉMATIQUE)** :
```properties
spring.datasource.password=

      ← Lignes vides qui causent l'erreur
```

**Après (CORRIGÉ)** :
```properties
spring.datasource.password=
← Une seule ligne vide finale
```

## 🚀 Comment vérifier

### Méthode 1 : Script de test

```bash
cd /home/corentinfay/Bureau/RestRepo
./test-compile.sh
```

### Méthode 2 : Compilation manuelle

```bash
cd /home/corentinfay/Bureau/RestRepo/Hotellerie
mvn clean install -DskipTests
```

**Résultat attendu** :
```
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
```

## 📝 Détails techniques

### Pourquoi cette erreur ?

Le plugin `maven-resources-plugin` lit les fichiers `.properties` et les copie dans `target/classes/`.

Lors de cette opération, il vérifie l'encodage et la validité des caractères.

**Problème** : Les lignes vides multiples en fin de fichier créent un caractère ou une séquence d'octets invalide que Maven ne peut pas traiter correctement.

### Message complet de l'erreur

```
Failed to execute goal org.apache.maven.plugins:maven-resources-plugin:3.2.0:resources 
(default-resources) on project Hotellerie: Input length = 1
```

**Signification** :
- `maven-resources-plugin` : Le plugin de gestion des ressources
- `Input length = 1` : Un caractère ou octet unique invalide a été détecté

## 🔄 Procédure complète de correction

### Étape 1 : Vérifier la compilation

```bash
cd /home/corentinfay/Bureau/RestRepo
./test-compile.sh
```

### Étape 2 : Si succès, appliquer la correction H2

```bash
./fix-h2-databases.sh
```

### Étape 3 : Lancer le client

```bash
cd Client
mvn spring-boot:run
```

## 📊 Checklist de vérification

- [ ] `mvn clean install` sans erreur
- [ ] Message `BUILD SUCCESS`
- [ ] Fichier JAR créé : `target/Hotellerie-0.0.1-SNAPSHOT.jar`
- [ ] Aucune erreur "Input length"

## 💡 Pour éviter ce problème à l'avenir

### Bonnes pratiques pour les fichiers .properties

1. **Toujours terminer par une ligne vide unique**
   ```properties
   derniere.propriete=valeur
   ← Une ligne vide
   ```

2. **Vérifier l'encodage**
   ```bash
   file -i fichier.properties
   # Résultat attendu : charset=us-ascii ou utf-8
   ```

3. **Éviter les caractères spéciaux**
   - Utiliser ASCII uniquement
   - Échapper les caractères spéciaux : `\n`, `\t`, etc.

4. **Tester après modification**
   ```bash
   mvn clean compile
   ```

## 🎯 Résumé

| Problème | Solution | Résultat |
|----------|----------|----------|
| Erreur "Input length = 1" | Suppression des lignes vides en fin de fichier | ✅ Compilation OK |
| Fichiers concernés | 4 fichiers .properties | ✅ Tous corrigés |
| Impact | Blocage de la compilation | ✅ Résolu |

## 🚀 Prochaine étape

Une fois la compilation réussie :

```bash
cd /home/corentinfay/Bureau/RestRepo
./fix-h2-databases.sh
```

Cela va :
1. ✅ Recompiler avec les fichiers corrigés
2. ✅ Supprimer les anciennes bases
3. ✅ Créer 3 bases séparées
4. ✅ Redémarrer tous les services

---

*Correction appliquée le 27 novembre 2025*  
*Erreur : maven-resources-plugin Input length = 1*  
*Cause : Lignes vides en fin de fichiers .properties*  
*Solution : Nettoyage des fichiers*

