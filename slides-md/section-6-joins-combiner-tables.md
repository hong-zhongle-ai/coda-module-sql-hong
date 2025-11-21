# 🔗 JOIN : Combiner plusieurs tables

## 🎯 Objectifs du cours

- Comprendre pourquoi et comment combiner plusieurs tables
- Maîtriser INNER JOIN pour les correspondances
- Découvrir LEFT JOIN, RIGHT JOIN, FULL JOIN
- Utiliser les alias de tables efficacement
- Gérer les ambiguïtés de colonnes
- Filtrer et trier les résultats de JOIN
- Éviter les erreurs courantes (produit cartésien, ambiguïtés)

---

## 🤔 Pourquoi combiner des tables ?

### 📚 Théorie : Le problème des données dispersées

Dans une base de données relationnelle, les données sont **normalisées** et réparties dans plusieurs tables pour éviter la redondance. Cependant, pour répondre à des questions métier, nous avons souvent besoin de **combiner** ces tables.

**Exemple de problème** :
```
Table etudiant          Table note              Table cours
┌─────────────┐        ┌─────────────┐         ┌─────────────┐
│ id_etudiant │        │ id_note     │         │ id_cours    │
│ nom         │        │ id_etudiant │─────────│ titre       │
│ prenom      │        │ id_cours    │─────────│ categorie   │
│ email       │        │ valeur      │         └─────────────┘
└─────────────┘        └─────────────┘
```

**Question** : Comment afficher le nom de l'étudiant avec sa note et le titre du cours ?

**Réponse** : Utiliser `JOIN` pour combiner les tables en une seule requête !

### 📖 Relations entre tables

Les tables sont reliées par des **clés étrangères** (FOREIGN KEY) qui référencent des **clés primaires** (PRIMARY KEY) :

```
etudiant (1) ────────< (N) note
cours (1) ───────────< (N) note
etablissement (1) ────< (N) etudiant
```

**Types de relations** :
- **1-N** (Un à Plusieurs) : Un étudiant a plusieurs notes
- **N-N** (Plusieurs à Plusieurs) : Un étudiant suit plusieurs cours, un cours a plusieurs étudiants

---

## 🔗 Qu'est-ce qu'un JOIN ?

### 📚 Théorie : Principe des jointures

Un **JOIN** permet de **combiner** les lignes de plusieurs tables en une seule requête en se basant sur une condition de correspondance.

**Comment ça marche ?**
1. PostgreSQL prend chaque ligne de la première table
2. Pour chaque ligne, il cherche les lignes correspondantes dans la deuxième table
3. Il combine les lignes qui matchent selon la condition `ON`
4. Il retourne le résultat combiné

**Avantages** :
- ✅ Évite la duplication de données (normalisation)
- ✅ Permet de répondre à des questions complexes
- ✅ Maintient l'intégrité des données
- ✅ Optimise le stockage

---

## 📊 Types de JOIN

### 📚 Théorie : Les différents types de jointures

PostgreSQL supporte plusieurs types de JOIN, chacun avec un comportement différent :

| Type | Description | Résultat | Quand l'utiliser |
|------|-------------|----------|------------------|
| **INNER JOIN** | Intersection | Lignes qui matchent dans les deux tables | Quand on veut uniquement les correspondances |
| **LEFT JOIN** | Toutes les lignes de gauche | Toutes les lignes de gauche + correspondances à droite | Quand on veut toutes les lignes de gauche, même sans correspondance |
| **RIGHT JOIN** | Toutes les lignes de droite | Toutes les lignes de droite + correspondances à gauche | Rarement utilisé (préférer LEFT JOIN inversé) |
| **FULL JOIN** | Union complète | Toutes les lignes des deux tables | Quand on veut toutes les lignes des deux tables |

### 🎯 Schéma conceptuel

```
Table A          Table B
┌─────┐          ┌─────┐
│  1  │          │  3  │
│  2  │          │  4  │
│  3  │          │  5  │
└─────┘          └─────┘
```

**INNER JOIN** : Résultat = {3} (seulement les correspondances)  
**LEFT JOIN** : Résultat = {1, 2, 3} (tout A + correspondances B)  
**RIGHT JOIN** : Résultat = {3, 4, 5} (tout B + correspondances A)  
**FULL JOIN** : Résultat = {1, 2, 3, 4, 5} (tout A + tout B)

---

## 🎯 INNER JOIN : L'intersection

### 📚 Théorie : Qu'est-ce qu'INNER JOIN ?

`INNER JOIN` retourne **uniquement** les lignes qui ont une correspondance dans les deux tables. C'est le type de JOIN le plus utilisé.

**Caractéristiques** :
- Retourne seulement les lignes où la condition `ON` est vraie
- Ignore les lignes sans correspondance
- C'est le JOIN par défaut (on peut écrire juste `JOIN`)

**Quand utiliser INNER JOIN ?**
- Quand on veut uniquement les données qui existent dans les deux tables
- Pour éviter les valeurs NULL dans les résultats
- Pour des requêtes où toutes les correspondances sont nécessaires

### 📝 Syntaxe

```sql
SELECT colonnes
FROM table1
INNER JOIN table2 ON table1.colonne = table2.colonne;
```

**Composants** :
- `FROM table1` : Table principale (gauche)
- `INNER JOIN table2` : Table à joindre (droite)
- `ON condition` : Condition de jointure (OBLIGATOIRE)

> 💡 **Note** : `INNER` est optionnel. `JOIN` = `INNER JOIN`

### 🎯 Mini-exemple

```sql
SELECT 
    e.nom,
    e.prenom,
    n.valeur AS note
FROM student.etudiant e
INNER JOIN student.note n ON e.id_etudiant = n.id_etudiant;
```

**Résultat** : Toutes les combinaisons étudiant-note qui existent (uniquement les étudiants qui ont des notes)

---

## 🔍 Alias de tables

### 📚 Théorie : Pourquoi utiliser des alias ?

Les alias permettent de **renommer temporairement** une table dans une requête pour :
- **Raccourcir** les noms de tables longs
- **Améliorer la lisibilité** des requêtes
- **Éviter les ambiguïtés** quand plusieurs tables ont des colonnes avec le même nom

**Convention** : Utiliser des alias courts et clairs (1-3 lettres) :
- `e` pour `etudiant`
- `n` pour `note`
- `c` pour `cours`
- `etab` pour `etablissement`
- `i` pour `inscription`

### 📝 Syntaxe

```sql
FROM table1 alias1
JOIN table2 alias2 ON alias1.colonne = alias2.colonne
```

### 🎯 Mini-exemple

```sql
-- Sans alias (long et verbeux)
SELECT student.etudiant.nom, student.note.valeur
FROM student.etudiant
INNER JOIN student.note ON student.etudiant.id_etudiant = student.note.id_etudiant;

-- Avec alias (court et lisible)
SELECT e.nom, n.valeur
FROM student.etudiant e
INNER JOIN student.note n ON e.id_etudiant = n.id_etudiant;
```

---

## 📚 JOINs multiples

### 📚 Théorie : Joindre plusieurs tables

Vous pouvez joindre **plusieurs tables** dans une seule requête. PostgreSQL joint les tables de **gauche à droite** :

1. D'abord, il joint la première et la deuxième table
2. Ensuite, il joint le résultat avec la troisième table
3. Et ainsi de suite...

**Ordre d'exécution** :
```sql
FROM table1
JOIN table2 ON condition1    -- Étape 1 : Joint table1 et table2
JOIN table3 ON condition2    -- Étape 2 : Joint le résultat avec table3
```

**Important** : Chaque JOIN nécessite une condition `ON` !

### 🎯 Mini-exemple : Étudiants avec leurs cours

```sql
SELECT 
    e.nom,
    e.prenom,
    c.titre AS cours
FROM student.etudiant e
INNER JOIN student.inscription i ON e.id_etudiant = i.id_etudiant
INNER JOIN student.cours c ON i.id_cours = c.id_cours;
```

**Explication** :
1. Joint `etudiant` avec `inscription` (via `id_etudiant`)
2. Joint le résultat avec `cours` (via `id_cours`)

**Résultat** : Tous les étudiants avec leurs cours inscrits

---

## 🔍 Gérer les ambiguïtés de colonnes

### 📚 Théorie : Le problème des noms identiques

Quand plusieurs tables ont une colonne avec le **même nom**, PostgreSQL ne sait pas laquelle utiliser. Il faut **préciser** la table avec l'alias.

**Exemple de problème** :
- Table `etudiant` a une colonne `nom`
- Table `etablissement` a aussi une colonne `nom`
- Si on écrit juste `SELECT nom`, PostgreSQL ne sait pas laquelle prendre

**Solution** : Toujours préfixer avec l'alias : `e.nom` ou `etab.nom`

### 🎯 Mini-exemple

```sql
-- ❌ ERREUR : Ambiguïté sur "nom"
SELECT nom
FROM student.etudiant e
INNER JOIN student.etablissement etab ON e.id_etablissement = etab.id_etablissement;

-- ✅ CORRECT : Préciser la table avec l'alias
SELECT e.nom AS nom_etudiant, etab.nom AS nom_etablissement
FROM student.etudiant e
INNER JOIN student.etablissement etab ON e.id_etablissement = etab.id_etablissement;
```

---

## 📊 LEFT JOIN : Toutes les lignes de gauche

### 📚 Théorie : Qu'est-ce qu'LEFT JOIN ?

`LEFT JOIN` retourne **toutes les lignes** de la table de gauche (première table), même s'il n'y a **pas de correspondance** dans la table de droite.

**Caractéristiques** :
- Toutes les lignes de la table de gauche sont incluses
- Les lignes sans correspondance ont `NULL` dans les colonnes de la table de droite
- Utile pour trouver les "éléments orphelins" (sans correspondance)

**Quand utiliser LEFT JOIN ?**
- Quand on veut toutes les lignes de gauche, même sans correspondance
- Pour trouver les éléments qui n'ont pas de correspondance (`WHERE table2.colonne IS NULL`)
- Pour inclure tous les éléments d'une catégorie, même ceux sans données associées

### 📝 Syntaxe

```sql
SELECT colonnes
FROM table1
LEFT JOIN table2 ON table1.colonne = table2.colonne;
```

### 🎯 Mini-exemple : Tous les étudiants, même sans notes

```sql
SELECT 
    e.nom,
    e.prenom,
    n.valeur AS note
FROM student.etudiant e
LEFT JOIN student.note n ON e.id_etudiant = n.id_etudiant;
```

**Résultat** :
- ✅ Tous les étudiants sont affichés
- ✅ Les étudiants **sans notes** ont `NULL` dans la colonne `note`

**Exemple de résultat** :
```
nom      | prenom | note
---------|--------|------
Dupont   | Jean   | 15.50
Martin   | Sophie | 18.00
Bernard  | Lucas  | NULL  ← Pas de note
```

### 📖 Cas d'usage : Trouver les éléments sans correspondance

**Trouver les étudiants sans notes** :

```sql
SELECT 
    e.nom,
    e.prenom
FROM student.etudiant e
LEFT JOIN student.note n ON e.id_etudiant = n.id_etudiant
WHERE n.id_note IS NULL;
```

**Résultat** : Uniquement les étudiants qui n'ont **aucune note**

**Trouver les cours sans étudiants inscrits** :

```sql
SELECT 
    c.titre AS cours
FROM student.cours c
LEFT JOIN student.inscription i ON c.id_cours = i.id_cours
WHERE i.id_inscription IS NULL;
```

**Résultat** : Les cours auxquels **personne n'est inscrit**

---

## ➡️ RIGHT JOIN : Toutes les lignes de droite

### 📚 Théorie : Qu'est-ce qu'RIGHT JOIN ?

`RIGHT JOIN` retourne **toutes les lignes** de la table de droite (deuxième table), même s'il n'y a **pas de correspondance** dans la table de gauche.

**Caractéristiques** :
- Toutes les lignes de la table de droite sont incluses
- Les lignes sans correspondance ont `NULL` dans les colonnes de la table de gauche
- **Rarement utilisé** : on préfère inverser l'ordre et utiliser LEFT JOIN

**Quand utiliser RIGHT JOIN ?**
- Pratiquement jamais ! Il est préférable d'inverser l'ordre des tables et d'utiliser LEFT JOIN pour plus de clarté

### 📝 Syntaxe

```sql
SELECT colonnes
FROM table1
RIGHT JOIN table2 ON table1.colonne = table2.colonne;
```

### 🎯 Mini-exemple

```sql
SELECT 
    e.nom,
    e.prenom,
    n.valeur AS note
FROM student.etudiant e
RIGHT JOIN student.note n ON e.id_etudiant = n.id_etudiant;
```

**Résultat** :
- ✅ Toutes les notes sont affichées
- ✅ Les notes **sans étudiant** (cas théorique) auraient `NULL` dans nom/prenom

> 💡 **Note** : RIGHT JOIN est rarement utilisé. On préfère inverser l'ordre et utiliser LEFT JOIN pour plus de clarté.

---

## 🔄 FULL JOIN : Union complète

### 📚 Théorie : Qu'est-ce qu'FULL JOIN ?

`FULL JOIN` retourne **toutes les lignes** des deux tables, avec `NULL` là où il n'y a pas de correspondance.

**Caractéristiques** :
- Toutes les lignes des deux tables sont incluses
- Les correspondances sont combinées
- Les lignes sans correspondance ont `NULL` dans les colonnes de l'autre table

**Quand utiliser FULL JOIN ?**
- Quand on veut toutes les données des deux tables
- Pour des analyses complètes incluant tous les éléments
- Pour trouver les éléments orphelins des deux côtés

### 📝 Syntaxe

```sql
SELECT colonnes
FROM table1
FULL JOIN table2 ON table1.colonne = table2.colonne;
```

### 🎯 Mini-exemple

```sql
SELECT 
    e.nom,
    e.prenom,
    n.valeur AS note
FROM student.etudiant e
FULL JOIN student.note n ON e.id_etudiant = n.id_etudiant;
```

**Résultat** :
- ✅ Tous les étudiants (même sans notes)
- ✅ Toutes les notes (même sans étudiants - cas théorique)

---

## 🔍 WHERE avec JOIN

### 📚 Théorie : Filtrer après la jointure

Vous pouvez utiliser `WHERE` pour **filtrer** les résultats après la jointure. Le filtre s'applique **après** que les tables sont jointes.

**Ordre d'exécution** :
1. `FROM` : Sélectionne les tables
2. `JOIN` : Joint les tables
3. `WHERE` : Filtre les résultats combinés
4. `SELECT` : Sélectionne les colonnes
5. `ORDER BY` : Trie les résultats

### 🎯 Mini-exemple

```sql
SELECT 
    e.nom,
    e.prenom,
    n.valeur AS note
FROM student.etudiant e
INNER JOIN student.note n ON e.id_etudiant = n.id_etudiant
WHERE n.valeur > 15;
```

**Résultat** : Uniquement les étudiants avec des notes supérieures à 15

---

## 📊 ORDER BY avec JOIN

### 📚 Théorie : Trier les résultats combinés

Vous pouvez utiliser `ORDER BY` pour **trier** les résultats après la jointure, comme avec une requête simple.

**Ordre d'exécution** :
1. Joint les tables
2. Filtre avec WHERE (si présent)
3. Trie avec ORDER BY
4. Limite avec LIMIT (si présent)

### 🎯 Mini-exemple

```sql
SELECT 
    e.nom,
    e.prenom,
    c.titre AS cours,
    n.valeur AS note
FROM student.etudiant e
INNER JOIN student.note n ON e.id_etudiant = n.id_etudiant
INNER JOIN student.cours c ON n.id_cours = c.id_cours
ORDER BY n.valeur DESC;
```

**Résultat** : Notes triées de la plus haute à la plus basse

---

## ⚠️ Erreurs courantes avec JOIN

### 📚 Théorie : Les pièges à éviter

### 1. Oublier la condition ON

**Erreur** : Produit cartésien (toutes les combinaisons possibles)

```sql
-- ❌ ERREUR : Pas de condition de jointure
SELECT e.nom, n.valeur
FROM student.etudiant e
INNER JOIN student.note n;
```

**Conséquence** : Si vous avez 2000 étudiants et 1000 notes, vous obtiendrez **2 000 000 de lignes** (2000 × 1000) !

**Solution** : Toujours spécifier la condition `ON`

### 2. Mauvais alias

```sql
-- ❌ ERREUR : Alias non défini
SELECT etudiant.nom, n.valeur
FROM student.etudiant e
INNER JOIN student.note n ON e.id_etudiant = n.id_etudiant;
```

**Solution** : Utiliser l'alias défini : `e.nom` au lieu de `etudiant.nom`

### 3. Ambiguïté de colonnes

```sql
-- ❌ ERREUR : Ambiguïté sur "nom"
SELECT nom
FROM student.etudiant e
INNER JOIN student.etablissement etab ON e.id_etablissement = etab.id_etablissement;
```

**Solution** : Préciser avec l'alias : `e.nom` ou `etab.nom`

---

## 📋 Bonnes pratiques avec JOIN

### ✅ DO (À faire)

- ✅ Utiliser des alias courts et clairs (`e`, `n`, `c`, `etab`)
- ✅ Toujours spécifier la condition `ON`
- ✅ Préfixer les colonnes avec l'alias (`e.nom`, `n.valeur`)
- ✅ Tester avec `LIMIT` sur de grandes tables
- ✅ Utiliser `LEFT JOIN` si on veut toutes les lignes de gauche
- ✅ Utiliser des alias cohérents dans tout le projet

### ❌ DON'T (À éviter)

- ❌ Oublier la condition `ON` (produit cartésien)
- ❌ Utiliser des noms de tables complets partout
- ❌ Créer des ambiguïtés de colonnes
- ❌ Faire trop de JOINs dans une seule requête (max 3-4 recommandé)
- ❌ Utiliser RIGHT JOIN (préférer LEFT JOIN inversé)

---

## 📊 GROUP BY : Regrouper les données

### 📚 Théorie : Qu'est-ce que GROUP BY ?

`GROUP BY` permet de **regrouper** les lignes qui ont la même valeur dans une ou plusieurs colonnes, puis d'appliquer une fonction d'agrégation sur chaque groupe.

**Quand utiliser GROUP BY ?**
- Calculer des statistiques par catégorie (moyenne par cours, nombre par établissement)
- Regrouper des données similaires
- Faire des analyses par groupe
- Générer des rapports agrégés

**Principe** : GROUP BY crée des groupes de lignes ayant les mêmes valeurs dans les colonnes spécifiées, puis applique les fonctions d'agrégation sur chaque groupe.

### 📝 Syntaxe

```sql
SELECT colonne, fonction_agregation(colonne)
FROM table
GROUP BY colonne;
```

**Règle importante** : Toutes les colonnes non-agrégées dans SELECT doivent être dans GROUP BY.

### 🎯 Mini-exemple : Nombre de notes par étudiant

```sql
SELECT 
    id_etudiant,
    COUNT(*) AS nombre_notes
FROM student.note
GROUP BY id_etudiant;
```

**Résultat** : Pour chaque étudiant, le nombre de notes qu'il a

### 📖 Avec JOIN : Nombre de notes par étudiant avec nom

```sql
SELECT 
    e.nom,
    e.prenom,
    COUNT(n.id_note) AS nombre_notes
FROM student.etudiant e
LEFT JOIN student.note n ON e.id_etudiant = n.id_etudiant
GROUP BY e.id_etudiant, e.nom, e.prenom
ORDER BY nombre_notes DESC;
```

**Résultat** : Nombre de notes par étudiant, trié du plus au moins

**Important** : Toutes les colonnes non-agrégées (`e.nom`, `e.prenom`) doivent être dans `GROUP BY`.

---

## 🔍 HAVING : Filtrer les groupes

### 📚 Théorie : Qu'est-ce que HAVING ?

`HAVING` permet de **filtrer les groupes** après le GROUP BY, comme `WHERE` filtre les lignes avant le GROUP BY.

**Différence WHERE vs HAVING** :
- **WHERE** : Filtre les **lignes individuelles** avant le GROUP BY
- **HAVING** : Filtre les **groupes** après le GROUP BY

**Quand utiliser HAVING ?**
- Filtrer sur des fonctions d'agrégation (moyenne > 15, nombre > 10)
- Exclure des groupes qui ne répondent pas aux critères
- Appliquer des conditions sur les résultats agrégés

### 📝 Syntaxe

```sql
SELECT colonne, fonction_agregation(colonne)
FROM table
GROUP BY colonne
HAVING condition;
```

### 🎯 Mini-exemple : Cours avec moyenne supérieure à 15

```sql
SELECT 
    c.titre AS cours,
    ROUND(AVG(n.valeur), 2) AS moyenne_notes
FROM student.cours c
LEFT JOIN student.note n ON c.id_cours = n.id_cours
GROUP BY c.id_cours, c.titre
HAVING AVG(n.valeur) > 15
ORDER BY moyenne_notes DESC;
```

**Résultat** : Uniquement les cours dont la moyenne est supérieure à 15

---

## 🔄 WHERE vs HAVING : La différence

### 📚 Théorie : Ordre d'exécution

**WHERE** : Filtre les lignes **AVANT** le GROUP BY

```sql
SELECT 
    c.titre AS cours,
    AVG(n.valeur) AS moyenne_notes
FROM student.cours c
LEFT JOIN student.note n ON c.id_cours = n.id_cours
WHERE n.valeur > 10  -- ← Filtre les notes individuelles
GROUP BY c.id_cours, c.titre;
```

**Résultat** : Moyenne calculée uniquement sur les notes > 10

**HAVING** : Filtre les groupes **APRÈS** le GROUP BY

```sql
SELECT 
    c.titre AS cours,
    AVG(n.valeur) AS moyenne_notes
FROM student.cours c
LEFT JOIN student.note n ON c.id_cours = n.id_cours
GROUP BY c.id_cours, c.titre
HAVING AVG(n.valeur) > 10;  -- ← Filtre les moyennes
```

**Résultat** : Uniquement les cours dont la moyenne est > 10

### 📊 Comparaison WHERE vs HAVING

| Aspect | WHERE | HAVING |
|--------|-------|--------|
| **Quand** | Avant GROUP BY | Après GROUP BY |
| **Filtre** | Les lignes individuelles | Les groupes |
| **Utilise** | Colonnes de la table | Fonctions d'agrégation |
| **Exemple** | `WHERE valeur > 10` | `HAVING AVG(valeur) > 10` |

---

## 📊 Fonctions d'agrégation avec GROUP BY

### 📚 Théorie : Fonctions d'agrégation principales

| Fonction | Description | Exemple |
|----------|-------------|---------|
| `COUNT()` | Compter les lignes | `COUNT(*)` ou `COUNT(colonne)` |
| `SUM()` | Somme des valeurs | `SUM(valeur)` |
| `AVG()` | Moyenne | `AVG(valeur)` |
| `MIN()` | Minimum | `MIN(valeur)` |
| `MAX()` | Maximum | `MAX(valeur)` |

**Note** : `COUNT(*)` compte toutes les lignes, `COUNT(colonne)` compte les lignes où la colonne n'est pas NULL.

### 🎯 Mini-exemple : Statistiques complètes par cours

```sql
SELECT 
    c.titre AS cours,
    COUNT(n.id_note) AS nombre_notes,
    ROUND(AVG(n.valeur), 2) AS moyenne_notes,
    MIN(n.valeur) AS note_minimum,
    MAX(n.valeur) AS note_maximum
FROM student.cours c
LEFT JOIN student.note n ON c.id_cours = n.id_cours
GROUP BY c.id_cours, c.titre
ORDER BY moyenne_notes DESC;
```

**Résultat** : Statistiques complètes pour chaque cours (nombre, moyenne, min, max)

---

## ⚠️ Erreurs courantes avec GROUP BY

### 📚 Théorie : Les pièges à éviter

### 1. Oublier une colonne dans GROUP BY

```sql
-- ❌ ERREUR : "nom" n'est pas dans GROUP BY
SELECT nom, COUNT(*)
FROM student.etudiant
GROUP BY id_etudiant;

-- ✅ CORRECT : Toutes les colonnes non-agrégées sont dans GROUP BY
SELECT nom, prenom, COUNT(*)
FROM student.etudiant
GROUP BY id_etudiant, nom, prenom;
```

**Règle** : Si vous sélectionnez une colonne sans fonction d'agrégation, elle **doit** être dans `GROUP BY`.

### 2. Utiliser WHERE avec fonction d'agrégation

```sql
-- ❌ ERREUR : WHERE ne peut pas utiliser AVG()
SELECT c.titre, AVG(n.valeur)
FROM student.cours c
LEFT JOIN student.note n ON c.id_cours = n.id_cours
WHERE AVG(n.valeur) > 15;  -- ❌ Erreur !

-- ✅ CORRECT : Utiliser HAVING
SELECT c.titre, AVG(n.valeur)
FROM student.cours c
LEFT JOIN student.note n ON c.id_cours = n.id_cours
GROUP BY c.id_cours, c.titre
HAVING AVG(n.valeur) > 15;
```

### 3. Mélanger colonnes agrégées et non-agrégées sans GROUP BY

```sql
-- ❌ ERREUR : Mélange colonne normale et fonction d'agrégation
SELECT nom, COUNT(*)
FROM student.etudiant;

-- ✅ CORRECT : Utiliser GROUP BY
SELECT nom, COUNT(*)
FROM student.etudiant
GROUP BY nom;
```

---

## 📋 Ordre d'exécution des clauses SQL avec GROUP BY

### 📚 Théorie : Ordre logique d'exécution

PostgreSQL exécute les clauses SQL dans un ordre spécifique. Avec GROUP BY, l'ordre est :

```sql
SELECT colonnes                    -- 6. Que sélectionner ?
FROM table                         -- 1. De quelle table ?
WHERE condition                    -- 2. Filtrer les lignes
GROUP BY colonnes                  -- 3. Regrouper
HAVING condition                   -- 4. Filtrer les groupes
ORDER BY colonne                   -- 5. Trier
LIMIT nombre;                      -- 7. Limiter
```

### 🎯 Exemple complet

```sql
SELECT 
    c.titre,
    AVG(n.valeur) AS moyenne
FROM student.cours c
LEFT JOIN student.note n ON c.id_cours = n.id_cours
WHERE n.valeur IS NOT NULL
GROUP BY c.id_cours, c.titre
HAVING AVG(n.valeur) > 10
ORDER BY moyenne DESC
LIMIT 10;
```

**Étapes d'exécution** :
1. `FROM` : Lit les tables cours et note
2. `WHERE` : Filtre les notes non NULL
3. `GROUP BY` : Regroupe par cours
4. `HAVING` : Filtre les cours avec moyenne > 10
5. `ORDER BY` : Trie par moyenne décroissante
6. `SELECT` : Sélectionne titre et moyenne
7. `LIMIT` : Limite à 10 résultats

---

## 🧪 Exercices pratiques

> 💡 **Important** : Les solutions se trouvent dans le fichier `correction/section-6-joins-combiner-tables.md`

### Niveau 1 : JOINs simples

1. **Étudiants avec leur établissement**
   - Affichez tous les étudiants avec le nom de leur établissement
   - Affichez nom, prénom, email et nom de l'établissement

2. **Notes avec détails**
   - Affichez toutes les notes avec le nom de l'étudiant et le titre du cours
   - Affichez nom, prénom, titre du cours et valeur de la note

3. **Inscriptions avec détails**
   - Affichez tous les étudiants inscrits avec le titre de leur cours
   - Affichez nom, prénom, titre du cours et date d'inscription

### Niveau 2 : LEFT JOIN

4. **Étudiants sans notes**
   - Trouvez tous les étudiants qui n'ont aucune note
   - Affichez leur nom, prénom et email

5. **Cours sans inscriptions**
   - Trouvez tous les cours auxquels personne n'est inscrit
   - Affichez le titre et la catégorie de ces cours

6. **Tous les étudiants avec leurs notes**
   - Affichez tous les étudiants avec leurs notes (même ceux sans notes)
   - Les étudiants sans notes doivent avoir NULL dans la colonne note

### Niveau 3 : JOINs multiples

7. **Notes complètes avec tous les détails**
   - Affichez nom, prénom, établissement, cours et note pour toutes les notes
   - Utilisez des alias appropriés pour chaque table

8. **Les meilleures notes**
   - Trouvez les 5 meilleures notes avec tous les détails
   - Affichez nom, prénom, établissement, cours et note
   - Triez par note décroissante

9. **Statistiques par établissement**
   - Affichez le nom de chaque établissement avec le nombre d'étudiants
   - Utilisez LEFT JOIN pour inclure les établissements sans étudiants

### Niveau 4 : GROUP BY et HAVING

10. **Nombre de notes par étudiant**
    - Comptez le nombre de notes pour chaque étudiant
    - Affichez nom, prénom et nombre de notes
    - Triez par nombre de notes décroissant

11. **Moyenne des notes par cours**
    - Calculez la moyenne des notes pour chaque cours
    - Affichez le titre du cours et la moyenne arrondie à 2 décimales
    - Triez par moyenne décroissante

12. **Cours avec moyenne supérieure à 15**
    - Trouvez les cours dont la moyenne des notes est supérieure à 15
    - Utilisez HAVING pour filtrer les groupes
    - Affichez le titre du cours et la moyenne

13. **Cours avec au moins 10 notes**
    - Trouvez les cours ayant au moins 10 notes
    - Affichez le titre du cours et le nombre de notes
    - Utilisez HAVING pour filtrer

14. **Statistiques complètes par cours**
    - Pour chaque cours, calculez :
      - Le nombre de notes
      - La moyenne
      - La note minimum
      - La note maximum
    - Affichez uniquement les cours ayant au moins une note

### Niveau 5 : Exercices avancés

15. **Étudiants avec toutes leurs informations**
    - Affichez nom, prénom, établissement, cours suivis et notes pour un étudiant spécifique
    - Utilisez plusieurs JOINs pour combiner toutes les tables

16. **Cours avec statistiques complètes**
    - Affichez chaque cours avec :
      - Le nombre d'étudiants inscrits
      - Le nombre de notes
      - La moyenne des notes
    - Utilisez LEFT JOIN pour inclure les cours sans inscriptions
    - Utilisez GROUP BY pour regrouper par cours

17. **Recherche d'étudiants spécifiques**
    - Trouvez un étudiant nommé "Gauthier" avec le prénom "Laurent"
    - Affichez toutes ses informations : établissement, cours suivis et notes
    - Trouvez un étudiant nommé "Thirion" avec le prénom "Yoan"
    - Affichez toutes ses informations également

18. **Notes parfaites et très faibles**
    - Trouvez toutes les notes égales à 20 (notes parfaites)
    - Affichez nom, prénom, cours et note
    - Trouvez toutes les notes inférieures à 1
    - Affichez les mêmes informations

19. **Établissements avec statistiques complètes**
    - Pour chaque établissement, calculez :
      - Le nombre d'étudiants
      - Le nombre de cours suivis (via inscriptions)
      - Le nombre de notes
      - La moyenne des notes
    - Utilisez LEFT JOIN et GROUP BY
    - Triez par moyenne des notes décroissante

20. **Moyenne des notes par établissement**
    - Calculez la moyenne des notes pour chaque établissement
    - Affichez uniquement les établissements ayant une moyenne supérieure à 12
    - Utilisez HAVING pour filtrer

---

## 📋 Récapitulatif

### Types de JOIN

| Type JOIN | Description | Quand l'utiliser | Syntaxe |
|-----------|-------------|------------------|---------|
| **INNER JOIN** | Intersection | Correspondances uniquement | `FROM t1 JOIN t2 ON t1.id = t2.id` |
| **LEFT JOIN** | Toutes les lignes de gauche | Inclure toutes les lignes de gauche | `FROM t1 LEFT JOIN t2 ON t1.id = t2.id` |
| **RIGHT JOIN** | Toutes les lignes de droite | Rarement utilisé | `FROM t1 RIGHT JOIN t2 ON t1.id = t2.id` |
| **FULL JOIN** | Union complète | Toutes les lignes des deux tables | `FROM t1 FULL JOIN t2 ON t1.id = t2.id` |

### GROUP BY et HAVING

| Concept | Description | Exemple |
|---------|-------------|---------|
| **GROUP BY** | Regrouper les données | `GROUP BY colonne` |
| **HAVING** | Filtrer les groupes | `HAVING AVG(valeur) > 10` |
| **COUNT()** | Compter les lignes | `COUNT(*)` |
| **AVG()** | Moyenne | `AVG(valeur)` |
| **MIN()/MAX()** | Minimum/Maximum | `MIN(valeur)`, `MAX(valeur)` |

### Règles importantes

**JOIN** :
- ✅ Toujours spécifier la condition `ON`
- ✅ Utiliser des alias courts et clairs
- ✅ Préfixer les colonnes avec l'alias
- ✅ Tester avec LIMIT sur de grandes tables

**GROUP BY** :
- ✅ Toutes les colonnes non-agrégées doivent être dans GROUP BY
- ✅ Utiliser WHERE pour filtrer les lignes avant GROUP BY
- ✅ Utiliser HAVING pour filtrer les groupes après GROUP BY
- ✅ Ne pas utiliser de fonctions d'agrégation dans WHERE

---

## 💡 Ce qu'on a appris

✅ Pourquoi combiner plusieurs tables avec JOIN  
✅ INNER JOIN pour les correspondances  
✅ LEFT JOIN pour inclure toutes les lignes de gauche  
✅ RIGHT JOIN et FULL JOIN (moins utilisés)  
✅ Utiliser des alias pour simplifier les requêtes  
✅ Gérer les ambiguïtés de colonnes  
✅ Joindre plusieurs tables en une seule requête  
✅ Filtrer et trier les résultats de JOIN  
✅ Regrouper les données avec GROUP BY  
✅ Filtrer les groupes avec HAVING  
✅ Différencier WHERE (filtre lignes) et HAVING (filtre groupes)  
✅ Utiliser les fonctions d'agrégation (COUNT, AVG, MIN, MAX)  
✅ Éviter les erreurs courantes (produit cartésien, ambiguïtés, colonnes manquantes dans GROUP BY)  
✅ Bonnes pratiques pour écrire des requêtes efficaces  

---

## 🚀 Prochaines étapes

Dans les prochains cours, nous verrons :

- **Sous-requêtes** : Requêtes dans les requêtes
- **Vues** : Sauvegarder des requêtes complexes
- **Index** : Optimiser les performances
- **Transactions** : Gérer les opérations multiples
