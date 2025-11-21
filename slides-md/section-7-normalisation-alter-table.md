# 🏗️ Architecture propre et évolution du schéma

## 🎯 Objectifs du cours

- Comprendre les formes normales (1NF, 2NF, 3NF)
- Identifier les problèmes de conception (redondance, anomalies)
- Appliquer la normalisation pour améliorer un schéma
- Utiliser ALTER TABLE pour modifier une table existante

---

## 🤔 Pourquoi normaliser ?

### 📚 Théorie : Le problème de la redondance

Dans une base de données mal conçue :
- **Redondance** : Mêmes données répétées plusieurs fois
- **Anomalies d'insertion** : Difficulté à insérer certaines données
- **Anomalies de mise à jour** : Risque d'incohérence
- **Anomalies de suppression** : Perte accidentelle de données

**Exemple** :
```
Table commande (MAUVAIS)
┌─────────────┬──────────────┬──────────────┐
│ id_commande │ nom_client   │ produit      │
├─────────────┼──────────────┼──────────────┤
│ 1           │ Dupont       │ Laptop       │
│ 1           │ Dupont       │ Souris       │ ← Redondance
└─────────────┴──────────────┴──────────────┘
```

**Solution** : Normaliser en plusieurs tables

---

## 📊 Formes normales : 1NF, 2NF, 3NF

### 📚 Théorie : Qu'est-ce que la normalisation ?

La **normalisation** organise les données pour :
- ✅ Éliminer la redondance
- ✅ Réduire les anomalies
- ✅ Améliorer l'intégrité

**Formes normales** :
- **1NF** : Valeurs atomiques, pas de doublons
- **2NF** : Pas de dépendances partielles
- **3NF** : Pas de dépendances transitives

---

## 1️⃣ Première Forme Normale (1NF)

### 📚 Théorie

Une table est en **1NF** si :
1. ✅ Chaque colonne contient des **valeurs atomiques** (indivisibles)
2. ✅ Chaque ligne est **unique**
3. ✅ L'ordre des lignes n'a pas d'importance

### ❌ Exemple : Violation 1NF

```sql
-- ❌ MAUVAIS : Valeurs multiples
CREATE TABLE commande (
    id_commande INT PRIMARY KEY,
    produits VARCHAR(500)  -- ❌ "Laptop, Souris, Clavier"
);
```

**Problèmes** : Impossible de chercher/compteur un produit facilement

### ✅ Solution : 1NF

```sql
-- ✅ BON : Une valeur par cellule
CREATE TABLE commande (
    id_commande INT,
    id_ligne INT,
    produit VARCHAR(255),
    PRIMARY KEY (id_commande, id_ligne)
);
```

---

## 2️⃣ Deuxième Forme Normale (2NF)

### 📚 Théorie

Une table est en **2NF** si :
1. ✅ Elle est en **1NF**
2. ✅ Toutes les colonnes non-clés dépendent de la **clé primaire complète**

**Dépendance partielle** : Une colonne dépend d'une partie de la clé primaire.

### ❌ Exemple : Violation 2NF

```sql
-- ❌ MAUVAIS : Dépendance partielle
CREATE TABLE commande_detail (
    id_commande INT,
    id_produit INT,
    nom_client VARCHAR(255),  -- ❌ Dépend de id_commande seulement
    quantite INT,
    PRIMARY KEY (id_commande, id_produit)
);
```

**Problème** : `nom_client` répété pour chaque produit

### ✅ Solution : 2NF

```sql
-- ✅ Table commande
CREATE TABLE commande (
    id_commande INT PRIMARY KEY,
    nom_client VARCHAR(255)
);

-- ✅ Table commande_detail
CREATE TABLE commande_detail (
    id_commande INT,
    id_produit INT,
    quantite INT,
    PRIMARY KEY (id_commande, id_produit),
    FOREIGN KEY (id_commande) REFERENCES commande(id_commande)
);
```

---

## 3️⃣ Troisième Forme Normale (3NF)

### 📚 Théorie

Une table est en **3NF** si :
1. ✅ Elle est en **2NF**
2. ✅ Aucune colonne non-clé ne dépend d'une autre colonne non-clé

**Dépendance transitive** : Une colonne dépend d'une autre colonne qui n'est pas la clé primaire.

### ❌ Exemple : Violation 3NF

```sql
-- ❌ MAUVAIS : Dépendance transitive
CREATE TABLE etudiant (
    id_etudiant INT PRIMARY KEY,
    id_etablissement INT,
    nom_etablissement VARCHAR(255)  -- ❌ Dépend de id_etablissement
);
```

**Problème** : `nom_etablissement` répété pour chaque étudiant

### ✅ Solution : 3NF

```sql
-- ✅ Table etablissement
CREATE TABLE etablissement (
    id_etablissement INT PRIMARY KEY,
    nom VARCHAR(255)
);

-- ✅ Table etudiant
CREATE TABLE etudiant (
    id_etudiant INT PRIMARY KEY,
    id_etablissement INT,
    FOREIGN KEY (id_etablissement) REFERENCES etablissement(id_etablissement)
);
```

---

## 📊 Exemple complet : Mauvais vs Bon design

### ❌ Table mal conçue

```sql
-- ❌ Violations 1NF, 2NF, 3NF
CREATE TABLE commande_complete (
    id_commande INT PRIMARY KEY,
    nom_client VARCHAR(255),
    produits VARCHAR(500),              -- ❌ 1NF
    nom_ville VARCHAR(255)              -- ❌ 3NF
);
```

### ✅ Design normalisé

```sql
-- ✅ Table client
CREATE TABLE client (
    id_client INT PRIMARY KEY,
    nom VARCHAR(255),
    id_ville INT,
    FOREIGN KEY (id_ville) REFERENCES ville(id_ville)
);

-- ✅ Table ville
CREATE TABLE ville (
    id_ville INT PRIMARY KEY,
    nom_ville VARCHAR(255)
);

-- ✅ Table commande
CREATE TABLE commande (
    id_commande INT PRIMARY KEY,
    id_client INT,
    FOREIGN KEY (id_client) REFERENCES client(id_client)
);

-- ✅ Table commande_detail
CREATE TABLE commande_detail (
    id_commande INT,
    id_produit INT,
    quantite INT,
    PRIMARY KEY (id_commande, id_produit),
    FOREIGN KEY (id_commande) REFERENCES commande(id_commande)
);
```

---

## 🔧 ALTER TABLE : Modifier une table

### 📚 Théorie

`ALTER TABLE` permet de modifier la structure d'une table :
- Ajouter/Supprimer des colonnes
- Modifier le type d'une colonne
- Ajouter/Supprimer des contraintes
- Renommer une colonne ou une table

**⚠️ ATTENTION** : Certaines opérations sont irréversibles !

---

## ➕ ADD COLUMN : Ajouter une colonne

```sql
ALTER TABLE nom_table
ADD COLUMN nom_colonne type_donnees [contraintes];
```

**Exemple** :
```sql
ALTER TABLE student.etudiant
ADD COLUMN telephone VARCHAR(20);

ALTER TABLE student.etudiant
ADD COLUMN date_inscription DATE NOT NULL DEFAULT CURRENT_DATE;
```

---

## ➖ DROP COLUMN : Supprimer une colonne

```sql
ALTER TABLE nom_table
DROP COLUMN nom_colonne;
```

**Exemple** :
```sql
ALTER TABLE student.etudiant
DROP COLUMN telephone;
```

**⚠️ ATTENTION** : Opération irréversible ! Les données sont perdues.

---

## 🔄 ALTER COLUMN : Modifier une colonne

```sql
-- Changer le type
ALTER TABLE nom_table
ALTER COLUMN nom_colonne TYPE nouveau_type;

-- Ajouter valeur par défaut
ALTER TABLE nom_table
ALTER COLUMN nom_colonne SET DEFAULT valeur;

-- Rendre obligatoire
ALTER TABLE nom_table
ALTER COLUMN nom_colonne SET NOT NULL;

-- Permettre NULL
ALTER TABLE nom_table
ALTER COLUMN nom_colonne DROP NOT NULL;
```

**Exemple** :
```sql
ALTER TABLE student.etudiant
ALTER COLUMN email TYPE VARCHAR(320);

ALTER TABLE student.etudiant
ALTER COLUMN telephone SET NOT NULL;
```

---

## 🔀 RENAME : Renommer

```sql
-- Renommer une colonne
ALTER TABLE nom_table
RENAME COLUMN ancien_nom TO nouveau_nom;

-- Renommer une table
ALTER TABLE ancien_nom_table
RENAME TO nouveau_nom_table;
```

**Exemple** :
```sql
ALTER TABLE student.etudiant
RENAME COLUMN telephone TO numero_telephone;
```

---

## 🔗 ADD/DROP CONSTRAINT : Gérer les contraintes

```sql
-- Ajouter une contrainte
ALTER TABLE nom_table
ADD CONSTRAINT nom_contrainte TYPE (colonne);

-- Supprimer une contrainte
ALTER TABLE nom_table
DROP CONSTRAINT nom_contrainte;
```

**Exemple** :
```sql
-- Ajouter UNIQUE
ALTER TABLE student.etudiant
ADD CONSTRAINT unique_email UNIQUE (email);

-- Ajouter CHECK
ALTER TABLE student.note
ADD CONSTRAINT check_note CHECK (valeur >= 0 AND valeur <= 20);

-- Ajouter FOREIGN KEY
ALTER TABLE student.etudiant
ADD CONSTRAINT fk_etablissement 
FOREIGN KEY (id_etablissement) 
REFERENCES student.etablissement(id_etablissement);

-- Supprimer
ALTER TABLE student.etudiant
DROP CONSTRAINT unique_email;
```

---

## ⚠️ Précautions avec ALTER TABLE

1. **Sauvegarder avant modification**
   ```sql
   CREATE TABLE student.etudiant_backup AS 
   SELECT * FROM student.etudiant;
   ```

2. **Tester sur un environnement de développement**

3. **Vérifier les dépendances** avant suppression

4. **Modifications peuvent échouer** si :
   - Des données violent la nouvelle contrainte
   - Des clés étrangères référencent la colonne
   - Des index existent sur la colonne

---

## 🧪 Exercices pratiques

> 💡 **Important** : Les solutions se trouvent dans le fichier `correction/section-7-normalisation-alter-table.md`

### Niveau 1 : Comprendre la normalisation

1. **Identifier les violations 1NF**
   - Analysez une table avec des colonnes contenant plusieurs valeurs
   - Proposez une solution pour la normaliser en 1NF

2. **Identifier les violations 2NF**
   - Analysez une table avec des dépendances partielles
   - Proposez une solution pour la normaliser en 2NF

3. **Identifier les violations 3NF**
   - Analysez une table avec des dépendances transitives
   - Proposez une solution pour la normaliser en 3NF

### Niveau 2 : ALTER TABLE

4. **Ajouter des colonnes**
   - Ajoutez une colonne `telephone` à la table `student.etudiant`
   - Ajoutez une colonne `date_creation` avec une valeur par défaut

5. **Modifier des colonnes**
   - Modifiez le type de la colonne `email` pour supporter plus de caractères
   - Ajoutez une contrainte NOT NULL sur une colonne

6. **Gérer les contraintes**
   - Ajoutez une contrainte UNIQUE sur la colonne `email`
   - Ajoutez une contrainte CHECK sur une colonne numérique

### Niveau 3 : Normalisation complète

7. **Normaliser une table mal conçue**
   - Partez d'une table avec violations 1NF, 2NF et 3NF
   - Créez un schéma normalisé en plusieurs tables

8. **Évolution d'un schéma**
   - Partez d'une table simple
   - Utilisez ALTER TABLE pour l'enrichir progressivement

---

## 📋 Récapitulatif

### Formes normales

| Forme | Description | Règle principale |
|-------|-------------|------------------|
| **1NF** | Première Forme Normale | Valeurs atomiques, pas de doublons |
| **2NF** | Deuxième Forme Normale | Pas de dépendances partielles |
| **3NF** | Troisième Forme Normale | Pas de dépendances transitives |

### ALTER TABLE

| Action | Syntaxe |
|--------|---------|
| **ADD COLUMN** | `ALTER TABLE t ADD COLUMN c TYPE` |
| **DROP COLUMN** | `ALTER TABLE t DROP COLUMN c` |
| **ALTER COLUMN** | `ALTER TABLE t ALTER COLUMN c TYPE` |
| **RENAME COLUMN** | `ALTER TABLE t RENAME COLUMN c1 TO c2` |
| **ADD CONSTRAINT** | `ALTER TABLE t ADD CONSTRAINT ...` |
| **DROP CONSTRAINT** | `ALTER TABLE t DROP CONSTRAINT ...` |

---

## 💡 Ce qu'on a appris

✅ Comprendre les principes de normalisation (1NF, 2NF, 3NF)  
✅ Identifier les violations et les corriger  
✅ Utiliser ALTER TABLE pour modifier une table  
✅ Ajouter/Supprimer des colonnes et contraintes  
✅ Évoluer un schéma de base de données  
