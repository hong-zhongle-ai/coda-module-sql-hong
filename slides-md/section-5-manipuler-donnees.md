# 🔧 Manipuler les données

## 🎯 Objectifs du cours

- Comprendre et maîtriser l'insertion de données avec `INSERT`
- Apprendre à filtrer les résultats avec `WHERE` et les opérateurs logiques
- Utiliser les fonctions d'agrégation (COUNT, MIN, MAX, AVG, SUM)
- Trier les résultats avec `ORDER BY`
- Modifier les données existantes avec `UPDATE`
- Supprimer des données avec `DELETE`
- Comprendre les contraintes de clés étrangères et les options de suppression

---

## ➕ INSERT : Insérer des données

### 📚 Théorie : Qu'est-ce qu'INSERT ?

La commande `INSERT` est l'une des opérations fondamentales en SQL. Elle permet d'**ajouter de nouvelles lignes** dans une table existante.

**Quand utiliser INSERT ?**
- Créer un nouvel enregistrement (ex: nouvel étudiant, nouveau cours)
- Ajouter des données de test
- Importer des données depuis un fichier
- Initialiser une base de données

**Points importants** :
- Vous devez respecter les contraintes de la table (NOT NULL, UNIQUE, FOREIGN KEY)
- Les colonnes auto-incrémentées (SERIAL) sont gérées automatiquement
- L'ordre des colonnes dans `INSERT INTO` doit correspondre à l'ordre des valeurs dans `VALUES`

### 📝 Syntaxe de base

```sql
INSERT INTO nom_table (colonne1, colonne2, colonne3, ...)
VALUES (valeur1, valeur2, valeur3, ...);
```

**Composants** :
- `INSERT INTO nom_table` : Table cible
- `(colonne1, colonne2, ...)` : Liste des colonnes (optionnel si toutes les colonnes)
- `VALUES (...)` : Liste des valeurs correspondantes

### 🎯 Mini-exemple

```sql
-- Structure de la table etudiant
CREATE TABLE student.etudiant (
    id_etudiant SERIAL PRIMARY KEY,      -- Auto-incrémenté
    nom VARCHAR(255) NOT NULL,
    prenom VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    date_naissance DATE NOT NULL,
    id_etablissement INT NOT NULL
);

-- Insertion d'un nouvel étudiant
INSERT INTO student.etudiant (nom, prenom, email, date_naissance, id_etablissement)
VALUES ('Martin', 'Sophie', 'sophie.martin@coda-school.com', '2002-03-15', 1);
```

**Résultat** : Un nouvel étudiant est ajouté avec `id_etudiant` généré automatiquement.

### 📖 Règles importantes pour INSERT

#### 1. Ordre des colonnes

L'ordre des colonnes dans `INSERT INTO` doit correspondre à l'ordre des valeurs dans `VALUES` :

```sql
-- ✅ Correct
INSERT INTO student.etudiant (nom, prenom, email, date_naissance, id_etablissement)
VALUES ('Dupont', 'Jean', 'jean@email.com', '2001-05-12', 1);

-- ❌ Erreur : ordre incorrect (date_naissance et nom inversés)
INSERT INTO student.etudiant (nom, prenom, email, date_naissance, id_etablissement)
VALUES ('2001-05-12', 'Jean', 'jean@email.com', 'Dupont', 1);
```

#### 2. Colonnes auto-incrémentées (SERIAL)

Ne **jamais** inclure les colonnes `SERIAL` dans un INSERT :

```sql
-- ✅ Correct : id_etudiant est généré automatiquement
INSERT INTO student.etudiant (nom, prenom, email, date_naissance, id_etablissement)
VALUES ('Martin', 'Sophie', 'sophie@email.com', '2002-03-15', 1);

-- ❌ Erreur : ne pas spécifier id_etudiant
INSERT INTO student.etudiant (id_etudiant, nom, prenom, email, date_naissance, id_etablissement)
VALUES (1, 'Martin', 'Sophie', 'sophie@email.com', '2002-03-15', 1);
```

#### 3. Valeurs par défaut (DEFAULT)

Si une colonne a une valeur par défaut définie, vous pouvez l'omettre :

```sql
-- Table inscription avec DEFAULT NOW()
CREATE TABLE student.inscription (
    id_inscription SERIAL PRIMARY KEY,
    id_etudiant INT NOT NULL,
    id_cours INT NOT NULL,
    date_inscription DATE NOT NULL DEFAULT NOW()
);

-- ✅ On peut omettre date_inscription
INSERT INTO student.inscription (id_etudiant, id_cours)
VALUES (1, 10);
-- date_inscription prendra automatiquement la date du jour (NOW())
```

#### 4. Contraintes à respecter

- **NOT NULL** : Toutes les colonnes marquées NOT NULL doivent avoir une valeur
- **UNIQUE** : Les valeurs doivent être uniques (ex: email)
- **FOREIGN KEY** : Les valeurs doivent exister dans la table référencée (ex: id_etablissement)

---

## 🔍 WHERE : Filtrer les résultats

### 📚 Théorie : Qu'est-ce que WHERE ?

La clause `WHERE` est **essentielle** en SQL. Elle permet de **filtrer** les lignes retournées par une requête selon des conditions spécifiques.

**Pourquoi utiliser WHERE ?**
- Limiter les résultats à des critères précis
- Éviter de charger toutes les données (performance)
- Trouver des enregistrements spécifiques
- Appliquer des conditions métier

**Principe** : `WHERE` évalue une condition pour chaque ligne. Seules les lignes où la condition est `TRUE` sont retournées.

### 📝 Syntaxe

```sql
SELECT colonnes
FROM nom_table
WHERE condition;
```

**Ordre d'exécution** :
1. PostgreSQL lit toutes les lignes de la table
2. Pour chaque ligne, évalue la condition WHERE
3. Retourne uniquement les lignes où la condition est vraie

> 💡 **Pensez à WHERE comme à "où..." ou "qui..."** : "Où le nom est 'Dupont'", "Qui a plus de 18 ans", etc.

### 🎯 Opérateurs de comparaison

| Opérateur | Signification | Exemple | Description |
|-----------|---------------|---------|-------------|
| `=` | Égal à | `nom = 'Dupont'` | Correspondance exacte |
| `!=` ou `<>` | Différent de | `nom != 'Dupont'` | Tous sauf cette valeur |
| `>` | Supérieur à | `valeur > 15` | Strictement supérieur |
| `<` | Inférieur à | `valeur < 10` | Strictement inférieur |
| `>=` | Supérieur ou égal | `valeur >= 15` | Supérieur ou égal |
| `<=` | Inférieur ou égal | `valeur <= 10` | Inférieur ou égal |
| `BETWEEN` | Entre deux valeurs | `valeur BETWEEN 10 AND 15` | Plage inclusive |
| `IN` | Dans une liste | `nom IN ('Dupont', 'Martin')` | Correspond à une des valeurs |
| `LIKE` | Correspondance de motif | `email LIKE '%@gmail.com'` | Recherche de pattern |
| `IS NULL` | Est NULL | `email IS NULL` | Vérifie si la valeur est NULL |
| `IS NOT NULL` | N'est pas NULL | `email IS NOT NULL` | Vérifie si la valeur existe |

### 🎯 Mini-exemple

```sql
-- Trouver tous les étudiants de l'établissement 1
SELECT nom, prenom, email
FROM student.etudiant
WHERE id_etablissement = 1;
```

**Résultat** : Tous les étudiants de l'établissement n°1 (CODA Dijon)

### 📖 Opérateurs logiques

Pour combiner plusieurs conditions, utilisez les opérateurs logiques :

#### AND (ET)

Les **deux** conditions doivent être vraies :

```sql
SELECT *
FROM student.etudiant
WHERE nom = 'Dupont' AND id_etablissement = 1;
```

**Résultat** : Les Dupont qui sont dans l'établissement 1

#### OR (OU)

**Au moins une** condition doit être vraie :

```sql
SELECT *
FROM student.etudiant
WHERE nom = 'Dupont' OR nom = 'Martin';
```

**Résultat** : Tous les Dupont ET tous les Martin

#### NOT (NON)

Inverse la condition :

```sql
SELECT *
FROM student.etudiant
WHERE NOT id_etablissement = 1;
```

**Résultat** : Tous les étudiants SAUF ceux de l'établissement 1

#### Combinaisons complexes

Vous pouvez combiner plusieurs opérateurs avec des parenthèses :

```sql
SELECT *
FROM student.etudiant
WHERE (nom = 'Dupont' OR nom = 'Martin') AND id_etablissement = 1;
```

**Résultat** : Les Dupont ou Martin qui sont dans l'établissement 1

### 📅 WHERE avec dates

Les dates en PostgreSQL suivent le format ISO : `'YYYY-MM-DD'`

```sql
-- Trouver les étudiants nés après 2002
SELECT nom, prenom, date_naissance
FROM student.etudiant
WHERE date_naissance > '2002-12-31';

-- Trouver les étudiants nés en 2001
SELECT nom, prenom, date_naissance
FROM student.etudiant
WHERE date_naissance >= '2001-01-01' 
  AND date_naissance < '2002-01-01';
```

---

## 🔢 Fonctions d'agrégation

### 📚 Théorie : Qu'est-ce qu'une fonction d'agrégation ?

Les fonctions d'agrégation **calculent une valeur unique** à partir d'un ensemble de lignes. Elles permettent de faire des **statistiques** sur vos données.

**Caractéristiques** :
- Elles prennent plusieurs lignes en entrée
- Elles retournent une seule valeur (un seul résultat)
- Elles ignorent les valeurs `NULL` (sauf `COUNT(*)`)
- Elles sont souvent utilisées avec `GROUP BY` (vu plus tard)

**Fonctions d'agrégation principales** :

| Fonction | Description | Type de données |
|----------|-------------|-----------------|
| `COUNT()` | Compte le nombre de lignes | Tous types |
| `MIN()` | Trouve la valeur minimale | Numérique, texte, date |
| `MAX()` | Trouve la valeur maximale | Numérique, texte, date |
| `AVG()` | Calcule la moyenne | Numérique uniquement |
| `SUM()` | Calcule la somme | Numérique uniquement |

### 📊 COUNT : Compter les lignes

**Théorie** : `COUNT()` compte le nombre de lignes qui correspondent à votre requête.

**Syntaxe** :
- `COUNT(*)` : Compte toutes les lignes (y compris celles avec NULL)
- `COUNT(colonne)` : Compte les lignes où la colonne n'est pas NULL

```sql
-- Compter tous les étudiants
SELECT COUNT(*)
FROM student.etudiant;

-- Compter avec condition
SELECT COUNT(*)
FROM student.etudiant
WHERE id_etablissement = 1;
```

### 📈 MIN et MAX : Minimum et Maximum

**Théorie** : `MIN()` et `MAX()` trouvent respectivement la valeur la plus petite et la plus grande.

**Utilisation** :
- Sur des nombres : trouve le min/max numérique
- Sur des dates : trouve la date la plus ancienne/récente
- Sur du texte : trouve le premier/dernier selon l'ordre alphabétique

```sql
-- Note minimale
SELECT MIN(valeur) AS note_minimum
FROM student.note;

-- Note maximale
SELECT MAX(valeur) AS note_maximum
FROM student.note;

-- Date de naissance la plus ancienne
SELECT MIN(date_naissance) AS date_plus_ancienne
FROM student.etudiant;
```

### 📊 AVG : Moyenne

**Théorie** : `AVG()` calcule la moyenne arithmétique d'une colonne numérique.

**Important** :
- Ignore les valeurs NULL
- Retourne un nombre décimal
- Utilisez `ROUND()` pour arrondir le résultat

```sql
-- Moyenne des notes
SELECT AVG(valeur) AS moyenne_notes
FROM student.note;

-- Moyenne arrondie à 2 décimales
SELECT ROUND(AVG(valeur), 2) AS moyenne_notes
FROM student.note;
```

### 📋 Alias avec AS

**Théorie** : Un alias permet de **renommer** une colonne dans le résultat pour améliorer la lisibilité.

**Syntaxe** :
```sql
SELECT colonne AS nom_alias
FROM table;
```

**Exemple** :
```sql
-- Sans alias
SELECT COUNT(*) FROM student.etudiant;
-- Résultat : count
--            -----
--            2000

-- Avec alias
SELECT COUNT(*) AS nombre_etudiants FROM student.etudiant;
-- Résultat : nombre_etudiants
--            ----------------
--            2000
```

---

## 🔄 ORDER BY : Trier les résultats

### 📚 Théorie : Qu'est-ce qu'ORDER BY ?

La clause `ORDER BY` permet de **trier** les résultats selon une ou plusieurs colonnes dans un ordre spécifique.

**Pourquoi trier ?**
- Afficher les données dans un ordre logique
- Trouver les meilleurs/pires résultats
- Organiser l'affichage pour l'utilisateur
- Préparer les données pour un traitement ultérieur

**Ordre d'exécution** : `ORDER BY` s'exécute **après** `WHERE` et **avant** `LIMIT`.

### 📝 Syntaxe

```sql
SELECT colonnes
FROM table
ORDER BY colonne [ASC|DESC];
```

**Options** :
- `ASC` : Croissant (par défaut) - A à Z, 1 à 10, dates anciennes à récentes
- `DESC` : Décroissant - Z à A, 10 à 1, dates récentes à anciennes

### 🎯 Mini-exemple

```sql
-- Trier les étudiants par nom (ordre alphabétique)
SELECT nom, prenom, email
FROM student.etudiant
ORDER BY nom;

-- Trier les notes du plus haut au plus bas
SELECT *
FROM student.note
ORDER BY valeur DESC;
```

### 📖 Tri sur plusieurs colonnes

Vous pouvez trier sur plusieurs colonnes. PostgreSQL trie d'abord par la première colonne, puis par la deuxième en cas d'égalité :

```sql
SELECT nom, prenom, date_naissance
FROM student.etudiant
ORDER BY nom, prenom;
```

**Résultat** : Tri d'abord par nom, puis par prénom (pour les noms identiques)

### 🔗 ORDER BY + LIMIT : Les meilleurs résultats

Combiner `ORDER BY` et `LIMIT` permet de trouver les "top N" résultats :

```sql
-- Les 10 meilleures notes
SELECT *
FROM student.note
ORDER BY valeur DESC
LIMIT 10;
```

---

## ✏️ UPDATE : Modifier les données

### 📚 Théorie : Qu'est-ce qu'UPDATE ?

La commande `UPDATE` permet de **modifier** des données existantes dans une table.

**Quand utiliser UPDATE ?**
- Corriger une erreur dans les données
- Mettre à jour des informations (ex: changement d'email)
- Appliquer des transformations (ex: augmenter toutes les notes)
- Synchroniser des données

**⚠️ ATTENTION CRITIQUE** : Sans `WHERE`, **TOUTES** les lignes de la table seront modifiées !

### 📝 Syntaxe

```sql
UPDATE nom_table
SET colonne1 = nouvelle_valeur1,
    colonne2 = nouvelle_valeur2,
    colonne3 = nouvelle_valeur3
WHERE condition;
```

**Composants** :
- `UPDATE nom_table` : Table à modifier
- `SET colonne = valeur` : Nouvelle valeur pour chaque colonne
- `WHERE condition` : **OBLIGATOIRE** pour limiter les modifications

### 🎯 Mini-exemple

```sql
-- Modifier l'email d'un étudiant spécifique
UPDATE student.etudiant
SET email = 'nouveau.email@coda-school.com'
WHERE id_etudiant = 1;
```

**Résultat** : L'email de l'étudiant n°1 est mis à jour

### 📖 Modifier plusieurs colonnes

Vous pouvez modifier plusieurs colonnes en une seule requête :

```sql
UPDATE student.etudiant
SET nom = 'Dupont',
    prenom = 'Jean-Pierre',
    email = 'jean-pierre.dupont@coda-school.com'
WHERE id_etudiant = 1;
```

### 📖 Utiliser des expressions

Vous pouvez utiliser des expressions dans `SET` :

```sql
-- Augmenter toutes les notes de 1 point (sauf celles à 20)
UPDATE student.note
SET valeur = valeur + 1
WHERE valeur < 20;
```

**Résultat** : Toutes les notes inférieures à 20 sont augmentées de 1 point

> 💡 **Note** : Les notes à 20 restent à 20 (condition `valeur < 20`)

### ⚠️ Précautions importantes

#### ❌ DANGER : UPDATE sans WHERE

```sql
-- ⚠️ DANGEREUX : Modifie TOUS les étudiants !
UPDATE student.etudiant
SET email = 'test@email.com';
```

**Résultat** : TOUS les étudiants auront le même email !

#### ✅ Toujours utiliser WHERE

```sql
-- ✅ SÉCURISÉ : Modifie uniquement l'étudiant n°1
UPDATE student.etudiant
SET email = 'test@email.com'
WHERE id_etudiant = 1;
```

**Bonnes pratiques** :
1. Toujours tester avec `SELECT` avant de faire `UPDATE`
2. Utiliser `WHERE` avec une clé primaire quand possible
3. Vérifier le nombre de lignes affectées après l'UPDATE

---

## 🗑️ DELETE : Supprimer des données

### 📚 Théorie : Qu'est-ce que DELETE ?

La commande `DELETE` permet de **supprimer définitivement** des lignes d'une table.

**Quand utiliser DELETE ?**
- Supprimer des données obsolètes
- Nettoyer des données de test
- Supprimer des enregistrements erronés
- Appliquer des règles métier (ex: suppression après X jours)

**⚠️ ATTENTION CRITIQUE** : Sans `WHERE`, **TOUTES** les lignes de la table seront supprimées !

**⚠️ Action irréversible** : Une fois supprimées, les données sont perdues (sauf sauvegarde)

### 📝 Syntaxe

```sql
DELETE FROM nom_table
WHERE condition;
```

**Composants** :
- `DELETE FROM nom_table` : Table à modifier
- `WHERE condition` : **OBLIGATOIRE** pour limiter les suppressions

### 🎯 Mini-exemple

```sql
-- Supprimer un étudiant spécifique
DELETE FROM student.etudiant
WHERE id_etudiant = 1;
```

**Résultat** : L'étudiant n°1 est supprimé

### ⚠️ Précautions importantes

#### ❌ DANGER : DELETE sans WHERE

```sql
-- ⚠️ DANGEREUX : Supprime TOUS les étudiants !
DELETE FROM student.etudiant;
```

**Résultat** : TOUS les étudiants sont supprimés !

#### ✅ Toujours utiliser WHERE

```sql
-- ✅ SÉCURISÉ : Supprime uniquement l'étudiant n°1
DELETE FROM student.etudiant
WHERE id_etudiant = 1;
```

**Bonnes pratiques** :
1. **Toujours** tester avec `SELECT` avant de faire `DELETE`
2. Utiliser `WHERE` avec une clé primaire quand possible
3. Vérifier le nombre de lignes affectées après le DELETE
4. Faire des sauvegardes régulières

### 🔗 Contraintes de clés étrangères

**Problème** : Par défaut, PostgreSQL **empêche** la suppression d'un enregistrement si des enregistrements enfants y sont liés (contrainte FOREIGN KEY).

**Exemple** :
```sql
-- ❌ ERREUR : Impossible de supprimer l'étudiant n°1
DELETE FROM student.etudiant
WHERE id_etudiant = 1;
```

**Erreur retournée** :
```
ERROR: update or delete on table "etudiant" violates foreign key constraint
DETAIL: Key (id_etudiant)=(1) is still referenced from table "note".
```

**Raison** : L'étudiant n°1 a des notes associées, donc on ne peut pas le supprimer.

### 📖 Options de suppression : ON DELETE

Lors de la création d'une table avec une clé étrangère, vous pouvez définir le comportement lors de la suppression :

#### ON DELETE RESTRICT (par défaut)

Empêche la suppression si des enregistrements enfants existent :

```sql
FOREIGN KEY (id_etudiant) 
    REFERENCES student.etudiant(id_etudiant)
    ON DELETE RESTRICT
```

**Comportement** : ❌ Erreur si on essaie de supprimer un étudiant qui a des notes

#### ON DELETE CASCADE

Supprime automatiquement tous les enregistrements enfants :

```sql
FOREIGN KEY (id_etudiant) 
    REFERENCES student.etudiant(id_etudiant)
    ON DELETE CASCADE
```

**Comportement** : ✅ Supprime l'étudiant ET toutes ses notes/inscriptions automatiquement

**⚠️ Dangereux** : Action irréversible, toutes les données liées sont perdues

#### ON DELETE SET NULL

Met la clé étrangère à `NULL` au lieu de supprimer :

```sql
FOREIGN KEY (id_etudiant) 
    REFERENCES student.etudiant(id_etudiant)
    ON DELETE SET NULL
```

**Comportement** : Si l'étudiant est supprimé, `id_etudiant` dans les notes devient `NULL` (la note reste mais sans étudiant)

### 📖 Quand utiliser chaque option ?

#### ✅ Utiliser RESTRICT (défaut) quand :
- Les données enfants doivent être protégées
- Vous voulez un contrôle explicite des suppressions
- Les données enfants ont de la valeur indépendamment du parent

#### ✅ Utiliser CASCADE quand :
- Les données enfants n'ont **pas de sens** sans le parent
- Exemple : Les notes d'un étudiant n'ont pas de sens si l'étudiant n'existe plus

#### ✅ Utiliser SET NULL quand :
- Les données enfants doivent **persister** mais peuvent perdre la référence
- Exemple : L'historique des commandes doit rester même si le client est supprimé

---

## 🔄 Ordre d'exécution des clauses SQL

### 📚 Théorie : Ordre logique d'exécution

PostgreSQL exécute les clauses SQL dans un ordre spécifique. Comprendre cet ordre est crucial pour écrire des requêtes correctes.

**Ordre d'exécution** :

```sql
SELECT colonnes                    -- 5. Que sélectionner ?
FROM table                         -- 1. De quelle table ?
WHERE condition                    -- 2. Filtrer les lignes
GROUP BY colonne                   -- 3. Grouper (vu plus tard)
HAVING condition                   -- 4. Filtrer les groupes (vu plus tard)
ORDER BY colonne [ASC|DESC]        -- 6. Trier les résultats
LIMIT nombre;                      -- 7. Limiter le nombre
```

**Exemple complet** :

```sql
SELECT nom, prenom, date_naissance
FROM student.etudiant
WHERE id_etablissement = 1
ORDER BY nom ASC
LIMIT 10;
```

**Étapes d'exécution** :
1. `FROM` : Lit la table `etudiant`
2. `WHERE` : Filtre uniquement les étudiants de l'établissement 1
3. `SELECT` : Sélectionne nom, prenom, date_naissance
4. `ORDER BY` : Trie par nom (A à Z)
5. `LIMIT` : Limite à 10 résultats

---

## 🧪 Exercices pratiques

> 💡 **Important** : Les solutions se trouvent dans le fichier `correction/section-5-manipuler-donnees.md`

### Niveau 1 : INSERT et SELECT

1. **Insérer un nouvel étudiant**
   - Insérez un nouvel étudiant dans l'établissement 1 avec les informations suivantes :
     - Nom : "Nouveau"
     - Prénom : "Etudiant"
     - Email : "nouveau.etudiant@coda-school.com"
     - Date de naissance : "2003-06-20"

2. **Afficher les étudiants d'un établissement**
   - Affichez tous les étudiants de l'établissement 1 (CODA Dijon)
   - Affichez uniquement leur nom, prénom et email

3. **Filtrer par date**
   - Affichez les étudiants nés après le 31 décembre 2002
   - Affichez leur nom, prénom et date de naissance

### Niveau 2 : WHERE et fonctions d'agrégation

4. **Recherche par nom**
   - Trouvez tous les étudiants nommés "Dupont"
   - Affichez leur nom, prénom, email et établissement

5. **Compter les étudiants**
   - Comptez le nombre total d'étudiants
   - Comptez le nombre d'étudiants dans l'établissement 1
   - Comptez le nombre d'étudiants dans l'établissement 2

6. **Statistiques sur les notes**
   - Calculez la moyenne, le minimum et le maximum des notes
   - Affichez le résultat avec des alias appropriés (moyenne_notes, note_minimum, note_maximum)

7. **Filtrer les notes**
   - Trouvez toutes les notes supérieures à 15
   - Trouvez toutes les notes inférieures à 10
   - Comptez le nombre de notes supérieures à 15

### Niveau 3 : ORDER BY et manipulations

8. **Les meilleures notes**
   - Affichez les 10 meilleures notes (triées de la plus haute à la plus basse)
   - Affichez les 5 notes les plus faibles

9. **Les étudiants les plus jeunes et les plus âgés**
   - Affichez les 5 étudiants les plus jeunes (dates de naissance les plus récentes)
   - Affichez les 5 étudiants les plus âgés (dates de naissance les plus anciennes)

10. **Modifier des données**
    - Trouvez d'abord un étudiant avec `SELECT` (par exemple, celui avec l'ID 1)
    - Modifiez son email en "nouveau.email@coda-school.com"
    - Vérifiez la modification avec un `SELECT`

11. **Supprimer des données**
    - Trouvez d'abord une note avec `SELECT` (par exemple, une note inférieure à 5)
    - Supprimez cette note spécifique
    - Vérifiez la suppression avec un `SELECT`

### Niveau 4 : Exercices avancés

12. **Statistiques complètes sur les âges**
    - Calculez l'âge de chaque étudiant (utilisez `EXTRACT(YEAR FROM AGE(date_naissance))`)
    - Trouvez l'âge minimum, maximum et moyen de tous les étudiants
    - Affichez toutes ces statistiques en une seule requête

13. **Recherche avec plusieurs conditions**
    - Trouvez les étudiants qui sont dans l'établissement 1 ET qui sont nés après 2002
    - Trouvez les étudiants qui sont dans l'établissement 1 OU l'établissement 2

14. **Modifier plusieurs colonnes**
    - Modifiez à la fois le nom, le prénom et l'email d'un étudiant spécifique
    - Vérifiez les modifications

15. **Recherche d'étudiants spécifiques**
    - Trouvez un étudiant nommé "Gauthier" avec le prénom "Laurent"
    - Trouvez un étudiant nommé "Thirion" avec le prénom "Yoan"
    - Affichez leurs informations complètes

16. **Notes parfaites et très faibles**
    - Trouvez toutes les notes égales à 20 (notes parfaites)
    - Trouvez toutes les notes inférieures à 1
    - Comptez le nombre de notes parfaites

---

## 📋 Récapitulatif

| Commande | Fonction | Exemple |
|----------|----------|---------|
| **INSERT** | Ajouter des données | `INSERT INTO etudiant VALUES (...)` |
| **SELECT** | Consulter des données | `SELECT * FROM etudiant` |
| **WHERE** | Filtrer les résultats | `WHERE nom = 'Dupont'` |
| **COUNT** | Compter les lignes | `SELECT COUNT(*) FROM etudiant` |
| **MIN/MAX** | Minimum/Maximum | `SELECT MIN(valeur) FROM note` |
| **AVG** | Moyenne | `SELECT AVG(valeur) FROM note` |
| **ORDER BY** | Trier les résultats | `ORDER BY nom ASC` |
| **LIMIT** | Limiter le nombre | `LIMIT 10` |
| **UPDATE** | Modifier des données | `UPDATE etudiant SET email = '...'` |
| **DELETE** | Supprimer des données | `DELETE FROM etudiant WHERE id = 1` |
| **ON DELETE RESTRICT** | Empêche suppression si enfants existent | `ON DELETE RESTRICT` (défaut) |
| **ON DELETE CASCADE** | Suppression automatique des enfants | `ON DELETE CASCADE` |
| **ON DELETE SET NULL** | Met FK à NULL au lieu de supprimer | `ON DELETE SET NULL` |

---

## 💡 Ce qu'on a appris

✅ Insérer des données avec INSERT  
✅ Filtrer avec WHERE et les opérateurs logiques (AND, OR, NOT)  
✅ Utiliser les fonctions d'agrégation (COUNT, MIN, MAX, AVG)  
✅ Trier les résultats avec ORDER BY  
✅ Combiner ORDER BY et LIMIT pour trouver les meilleurs résultats  
✅ Modifier les données avec UPDATE  
✅ Supprimer les données avec DELETE  
✅ Comprendre les contraintes de clés étrangères  
✅ ON DELETE RESTRICT, CASCADE, SET NULL : options de suppression  
✅ ⚠️ Toujours utiliser WHERE avec UPDATE et DELETE !  
✅ Ordre d'exécution des clauses SQL
