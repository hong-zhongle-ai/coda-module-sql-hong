# 🏗️ Fondamentaux du SQL

## 🎯 Objectifs du cours

- Comprendre la structure d'une base de données (tables, colonnes, lignes)
- Découvrir les types de données SQL
- Maîtriser les clés primaires et étrangères
- Apprendre à créer des tables avec CREATE TABLE
- Comprendre les relations entre tables

---

## 📊 Tables, colonnes, lignes : rappel fondamental

### Qu'est-ce qu'une table ?

Une **table** est comme un **tableau Excel** :
- Elle stocke des données de manière structurée
- Elle a un nom unique dans la base de données
- Elle contient des lignes et des colonnes

### Exemple : La table `etudiant`

```
┌────────────┬─────────┬─────────┬──────────────────────┬─────────────────┬──────────────────┐
│id_etudiant │   nom   │ prenom  │        email         │ date_naissance  │ id_etablissement │
├────────────┼─────────┼─────────┼──────────────────────┼─────────────────┼──────────────────┤
│     1      │ Dupont  │  Jean   │ etudiant1@coda.com   │   2001-05-12    │        1         │
│     2      │ Martin  │ Sophie  │ etudiant2@coda.com   │   2002-08-23    │        2         │
│     3      │ Bernard │  Lucas  │ etudiant3@coda.com   │   2000-11-30    │        1         │
└────────────┴─────────┴─────────┴──────────────────────┴─────────────────┴──────────────────┘
```

---

## 📐 Les trois composants

### 1️⃣ **TABLE** = Le conteneur
- Nom : `etudiant`
- Fonction : Stocker tous les étudiants

### 2️⃣ **COLONNE** = Les propriétés
- `id_etudiant`, `nom`, `prenom`, `email`, `date_naissance`, `id_etablissement`
- Chaque colonne a un **type de données** spécifique

### 3️⃣ **LIGNE** (ou enregistrement) = Une entrée
- Chaque ligne représente **un étudiant**
- Exemple : Jean Dupont est une ligne

---

## 🎨 Types de données SQL

Les types de données définissent **ce qu'on peut stocker** dans une colonne.

### Types numériques

| Type | Description | Exemple |
|------|-------------|---------|
| `INTEGER` ou `INT` | Nombres entiers | 42, -10, 2024 |
| `SERIAL` | Entier auto-incrémenté | 1, 2, 3, 4... |
| `NUMERIC(p,s)` | Nombres décimaux précis<br/>p = précision totale, s = décimales | 15.75, 18.50 |
| `REAL` / `FLOAT` | Nombres à virgule flottante | 3.14159 |

**Exemple d'usage** :
```sql
id_etudiant SERIAL          -- 1, 2, 3, 4...
id_etablissement INT        -- 1, 2, 3...
valeur NUMERIC(5,2)        -- 15.75 (5 chiffres au total, 2 après la virgule)
                           -- Permet: 0.00 à 999.99 (3 chiffres avant, 2 après)
```

---

## 📝 Types de texte

| Type | Description | Exemple |
|------|-------------|---------|
| `VARCHAR(n)` | Texte de longueur variable (max n) | 'Dupont', 'Sophie' |
| `CHAR(n)` | Texte de longueur fixe | 'FR', 'US' |
| `TEXT` | Texte de longueur illimitée | Long paragraphe... |

**Exemple d'usage** :
```sql
nom VARCHAR(255)           -- "Dupont" (max 255 caractères)
prenom VARCHAR(255)        -- "Jean"
email VARCHAR(255)         -- "jean.dupont@email.com"
adresse TEXT               -- Texte long sans limite
```

> 💡 **VARCHAR vs TEXT** : VARCHAR(255) limite la longueur, TEXT n'a pas de limite

---

## 📅 Types date et temps

| Type | Description | Exemple |
|------|-------------|---------|
| `DATE` | Date (année-mois-jour) | 2001-05-12 |
| `TIME` | Heure (heure:minute:seconde) | 14:30:00 |
| `TIMESTAMP` | Date + heure | 2024-11-19 14:30:00 |



**Exemple d'usage** :
```sql
date_naissance DATE        -- 2001-05-12
date_inscription DATE      -- 2024-09-01
date_note DATE            -- 2024-10-15
```
## Other
| `BOOLEAN` | Vrai ou faux | TRUE, FALSE |

---

## 🔑 Clé primaire : rôle et création

### Qu'est-ce qu'une clé primaire (PRIMARY KEY) ?

Une **clé primaire** est une colonne (ou un groupe de colonnes) qui :
- ✅ Identifie **UNIQUEMENT** chaque ligne de la table
- ✅ Ne peut **JAMAIS** être vide (NOT NULL)
- ✅ Ne peut **JAMAIS** être dupliquée
- ✅ Est souvent un nombre auto-incrémenté

> 🎯 **Analogie** : C'est comme un numéro de carte d'identité unique pour chaque enregistrement

---

## 🔐 Exemples de clés primaires

### Dans la table `etudiant` :

```sql
CREATE TABLE student.etudiant (
    id_etudiant SERIAL PRIMARY KEY,  -- ← Clé primaire
    nom VARCHAR(255) NOT NULL,
    prenom VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL
);
```

**Pourquoi `id_etudiant` ?**
- ✅ Unique pour chaque étudiant
- ✅ Auto-incrémenté (SERIAL)
- ✅ Jamais NULL
- ✅ Simple (un seul champ)

---

## 🆔 Autres exemples de clés primaires

### Table `cours` :
```sql
id_cours SERIAL PRIMARY KEY
```

### Table `etablissement` :
```sql
id_etablissement SERIAL PRIMARY KEY
```

### Table `note` :
```sql
id_note SERIAL PRIMARY KEY
```

> 💡 **Convention** : Souvent nommée `id_nom_de_table`

---

## 🔗 Clé étrangère : relations entre tables

### Qu'est-ce qu'une clé étrangère (FOREIGN KEY) ?

Une **clé étrangère** est une colonne qui :
- 📌 Fait référence à la **clé primaire** d'une autre table
- 🔗 Crée une **relation** entre deux tables
- ✅ Garantit l'**intégrité référentielle** (pas de données orphelines)

> 🎯 **Analogie** : C'est comme un lien hypertexte qui pointe vers une autre page

---

## 🔗 Exemple : Relation Etablissement ↔ Etudiant

### Schéma de la relation :

```
┌─────────────────────────┐
│    etablissement        │
├─────────────────────────┤
│ id_etablissement (PK)   │◄──┐
│ nom                     │   │
│ adresse                 │   │
└─────────────────────────┘   │
                              │ FOREIGN KEY
                              │
┌─────────────────────────┐   │
│    etudiant             │   │
├─────────────────────────┤   │
│ id_etudiant (PK)        │   │
│ nom                     │   │
│ prenom                  │   │
│ email                   │   │
│ date_naissance          │   │
│ id_etablissement (FK)   │───┘
└─────────────────────────┘
```

**Signification** : Chaque étudiant appartient à UN établissement

---

## 📝 Code SQL de la relation

```sql
CREATE TABLE student.etablissement (
    id_etablissement SERIAL PRIMARY KEY,
    nom VARCHAR(255) NOT NULL,
    adresse TEXT NOT NULL
);

CREATE TABLE student.etudiant (
    id_etudiant SERIAL PRIMARY KEY,
    nom VARCHAR(255) NOT NULL,
    prenom VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    date_naissance DATE NOT NULL,
    id_etablissement INT NOT NULL,
    
    -- ⬇️ Déclaration de la clé étrangère
    FOREIGN KEY (id_etablissement) 
        REFERENCES student.etablissement(id_etablissement)
);
```

---

## 🔍 Anatomie de FOREIGN KEY

```sql
FOREIGN KEY (id_etablissement)           -- ← Colonne dans cette table
    REFERENCES etablissement(id_etablissement)  -- ← Table et colonne référencées
```

**Ce que ça garantit** :
- ❌ On ne peut pas ajouter un étudiant avec `id_etablissement = 999` si l'établissement 999 n'existe pas
- ❌ On ne peut pas supprimer un établissement s'il a encore des étudiants
- ✅ L'intégrité des données est préservée

---

## 🔗 Relations dans notre base codaSchool

### Relation 1 : Etudiant → Etablissement
```sql
FOREIGN KEY (id_etablissement) 
    REFERENCES etablissement(id_etablissement)
```
**Type** : Many-to-One (plusieurs étudiants, un établissement)

### Relation 2 : Inscription → Etudiant
```sql
FOREIGN KEY (id_etudiant) 
    REFERENCES etudiant(id_etudiant)
```

### Relation 3 : Inscription → Cours
```sql
FOREIGN KEY (id_cours) 
    REFERENCES cours(id_cours)
```

**Type** : Many-to-Many (plusieurs étudiants ↔ plusieurs cours)

---

## 🏗️ CREATE TABLE expliqué ligne par ligne

### Syntaxe générale :

```sql
CREATE TABLE nom_schema.nom_table (
    colonne1 TYPE CONTRAINTES,
    colonne2 TYPE CONTRAINTES,
    ...
    CONTRAINTES_DE_TABLE
);
```

---

## 📚 Exemple complet : Table Cours

```sql
CREATE TABLE student.cours (
    id_cours SERIAL PRIMARY KEY,
    titre VARCHAR(255) NOT NULL,
    categorie VARCHAR(100) NOT NULL
);
```

### Décortiquons ligne par ligne :

---

## 1️⃣ CREATE TABLE student.cours

```sql
CREATE TABLE student.cours (
```

- `CREATE TABLE` : Commande pour créer une nouvelle table
- `student` : Nom du schéma (namespace)
- `cours` : Nom de la table
- `(` : Début de la définition des colonnes

---

## 2️⃣ id_cours SERIAL PRIMARY KEY

```sql
    id_cours SERIAL PRIMARY KEY,
```

- `id_cours` : Nom de la colonne
- `SERIAL` : Type auto-incrémenté (1, 2, 3, 4...)
- `PRIMARY KEY` : Identifiant unique de la table
- `,` : Séparateur entre colonnes

**Résultat** : Clé primaire qui s'incrémente automatiquement

> 🔍 **Sous le capot : Ce que PostgreSQL génère réellement**
> 
> Quand vous écrivez `SERIAL`, PostgreSQL crée automatiquement :
> 
> ```sql
> id_cours integer NOT NULL DEFAULT nextval('student.cours_id_cours_seq'::regclass)
> ```
> 
> **Décortiquons cette syntaxe** :
> - `integer` : Type de base (entier)
> - `NOT NULL` : La valeur ne peut pas être vide
> - `DEFAULT nextval(...)` : Valeur par défaut = prochaine valeur de la séquence
> - `'student.cours_id_cours_seq'` : Nom de la séquence auto-générée
> - `::regclass` : Cast PostgreSQL pour référencer un objet système
> 
> **En résumé** : `SERIAL` est un **raccourci** qui crée automatiquement une séquence et l'utilise comme valeur par défaut. C'est plus simple à écrire que la syntaxe complète !

---

## 3️⃣ titre VARCHAR(255) NOT NULL

```sql
    titre VARCHAR(255) NOT NULL,
```

- `titre` : Nom de la colonne
- `VARCHAR(255)` : Texte variable (max 255 caractères)
- `NOT NULL` : Cette colonne est **obligatoire**
- `,` : Séparateur

**Exemples de valeurs** : "Introduction aux Bases de Données", "Machine Learning Fondamentaux"

---

## 4️⃣ categorie VARCHAR(100) NOT NULL

```sql
    categorie VARCHAR(100) NOT NULL
```

- `categorie` : Nom de la colonne
- `VARCHAR(100)` : Texte variable (max 100 caractères)
- `NOT NULL` : Cette colonne est **obligatoire**
- **Pas de virgule** : c'est la dernière colonne !

**Exemples de valeurs** : "Informatique", "Data Science", "Management"

---

## 🔍 Syntaxe PostgreSQL complète : Ce que vous voyez dans pgAdmin

Quand vous regardez la définition d'une table dans pgAdmin ou avec `\d+`, PostgreSQL affiche la syntaxe complète :

```sql
id_cours integer NOT NULL DEFAULT nextval('student.cours_id_cours_seq'::regclass),
titre character varying(255) COLLATE pg_catalog."default" NOT NULL,
categorie character varying(100) COLLATE pg_catalog."default" NOT NULL,
CONSTRAINT cours_pkey PRIMARY KEY (id_cours)
```

### Décortiquons chaque partie :

#### 1️⃣ `id_cours integer NOT NULL DEFAULT nextval(...)`
- `integer` : Type entier (équivalent à `INT`)
- `NOT NULL` : La valeur est obligatoire
- `DEFAULT nextval(...)` : Valeur par défaut = prochaine valeur de la séquence
- `'student.cours_id_cours_seq'` : Nom de la séquence créée automatiquement par `SERIAL`
- `::regclass` : Cast PostgreSQL pour référencer un objet système (la séquence)

> 💡 **En écriture simple** : `id_cours SERIAL PRIMARY KEY`

#### 2️⃣ `titre character varying(255) COLLATE pg_catalog."default" NOT NULL`
- `character varying(255)` : Équivalent à `VARCHAR(255)` (texte variable, max 255 caractères)
- `COLLATE pg_catalog."default"` : Règles de tri et comparaison par défaut
  - **`COLLATE`** = "collation" en français = règles qui définissent comment les caractères sont :
    - **Comparés** : `'a' = 'A'` ? (selon la collation)
    - **Triés** : `'a'` vient avant `'b'` ? (ordre alphabétique)
    - **Classés** : Comment gérer les accents (`é` vs `e`) ?
  - **`pg_catalog."default"`** = règles par défaut du système PostgreSQL
    - Généralement basé sur la locale du système (français, anglais, etc.)
    - `pg_catalog` = schéma système de PostgreSQL
    - `"default"` = collation par défaut
  - **En pratique** : Vous pouvez ignorer cette partie dans 99% des cas
    - PostgreSQL l'ajoute automatiquement
    - Vous n'avez pas besoin de l'écrire dans vos CREATE TABLE
- `NOT NULL` : La valeur est obligatoire

> 💡 **En écriture simple** : `titre VARCHAR(255) NOT NULL`

> 🔍 **Exemple concret de COLLATE** :
> 
> Avec `COLLATE "fr_FR"` (français) :
> ```sql
> SELECT * FROM cours ORDER BY titre;
> -- Résultat : "École" vient avant "Zoo" (les accents sont pris en compte)
> ```
> 
> Avec `COLLATE "C"` (ASCII simple) :
> ```sql
> SELECT * FROM cours ORDER BY titre;
> -- Résultat : "Zoo" vient avant "École" (les caractères accentués sont triés différemment)
> ```
> 
> **`pg_catalog."default"`** utilise généralement les règles de votre système, ce qui convient dans la plupart des cas.

#### 3️⃣ `categorie character varying(100) COLLATE pg_catalog."default" NOT NULL`
- Même principe que `titre`, mais avec une limite de 100 caractères

> 💡 **En écriture simple** : `categorie VARCHAR(100) NOT NULL`

#### 4️⃣ `CONSTRAINT cours_pkey PRIMARY KEY (id_cours)`
- `CONSTRAINT cours_pkey` : Nom explicite de la contrainte (généré automatiquement)
  - Format : `nom_table_pkey` (ici `cours_pkey`)
- `PRIMARY KEY (id_cours)` : Définit `id_cours` comme clé primaire

> 💡 **En écriture simple** : `id_cours SERIAL PRIMARY KEY` (définit tout en une ligne)

### 📝 Résumé : Syntaxe simple vs Syntaxe PostgreSQL

| Ce que vous écrivez | Ce que PostgreSQL génère |
|---------------------|---------------------------|
| `id_cours SERIAL PRIMARY KEY` | `id_cours integer NOT NULL DEFAULT nextval(...), CONSTRAINT cours_pkey PRIMARY KEY (id_cours)` |
| `titre VARCHAR(255) NOT NULL` | `titre character varying(255) COLLATE pg_catalog."default" NOT NULL` |
| `categorie VARCHAR(100) NOT NULL` | `categorie character varying(100) COLLATE pg_catalog."default" NOT NULL` |

**Conclusion** : Utilisez la syntaxe simple (`SERIAL`, `VARCHAR`) dans vos scripts SQL. La syntaxe complète est affichée par PostgreSQL pour information, mais vous n'avez pas besoin de l'écrire manuellement !

---

## 🌍 COLLATE : Qu'est-ce que c'est et à quoi ça sert ?

### Définition

**COLLATE** (collation en français) définit les **règles de comparaison et de tri** des chaînes de caractères. C'est important pour :

1. **Le tri** (`ORDER BY`) : Comment ordonner les textes ?
2. **La comparaison** (`WHERE`, `=`, `<`, `>`) : Comment comparer les textes ?
3. **La recherche** (`LIKE`, `ILIKE`) : Comment chercher dans les textes ?

### Exemples concrets

#### Exemple 1 : Tri avec accents

```sql
-- Données de test
CREATE TABLE test (nom VARCHAR(50));
INSERT INTO test VALUES ('École'), ('Zoo'), ('école'), ('zoo');

-- Avec COLLATE français (fr_FR)
SELECT * FROM test ORDER BY nom COLLATE "fr_FR";
-- Résultat : École, Zoo, école, zoo
-- (Les majuscules avant les minuscules, les accents respectés)

-- Avec COLLATE C (ASCII simple)
SELECT * FROM test ORDER BY nom COLLATE "C";
-- Résultat : Zoo, zoo, École, école
-- (Ordre ASCII : Z < e < é)
```

#### Exemple 2 : Comparaison insensible à la casse

```sql
-- Avec COLLATE par défaut (sensible à la casse)
SELECT * FROM cours WHERE titre = 'introduction';
-- Ne trouve pas "Introduction" (I majuscule)

-- Avec COLLATE insensible à la casse
SELECT * FROM cours WHERE titre COLLATE "en_US" = 'introduction';
-- Trouve "Introduction" (selon la collation)
```

### `pg_catalog."default"` : Qu'est-ce que c'est ?

- **`pg_catalog`** = schéma système de PostgreSQL (contient les objets internes)
- **`"default"`** = collation par défaut du système
- **Résultat** : Utilise les règles de tri/comparaison de votre système d'exploitation

**En pratique** :
- Sur un système français : règles françaises (accents, casse)
- Sur un système anglais : règles anglaises (ASCII)
- Généralement : **vous n'avez pas besoin de vous en préoccuper**

### Quand utiliser COLLATE explicitement ?

**Cas où vous devez spécifier COLLATE** :

1. **Base de données multilingue** : Données en français ET en arabe
2. **Tri spécifique** : Besoin d'un tri particulier (ex: tri numérique dans du texte)
3. **Compatibilité** : Migration depuis un autre SGBD avec des règles différentes

**Exemple** :
```sql
-- Créer une colonne avec une collation spécifique
CREATE TABLE produits (
    nom VARCHAR(100) COLLATE "fr_FR" NOT NULL
);

-- Ou utiliser COLLATE dans une requête
SELECT * FROM cours 
ORDER BY titre COLLATE "C";
```

### 📝 Résumé

| Concept | Signification | À retenir |
|---------|---------------|-----------|
| **COLLATE** | Règles de tri et comparaison | Définit comment les textes sont comparés/triés |
| **`pg_catalog."default"`** | Collation par défaut du système | Généralement français ou anglais selon votre OS |
| **En pratique** | PostgreSQL l'ajoute automatiquement | Vous n'avez pas besoin de l'écrire dans vos CREATE TABLE |

> 💡 **Pour 99% des cas** : Ignorez `COLLATE pg_catalog."default"`. PostgreSQL le gère automatiquement et c'est parfait pour la plupart des applications !

---

## 5️⃣ Fermeture

```sql
);
```

- `)` : Fin de la définition des colonnes
- `;` : Fin de la commande SQL

---

## 📊 Exemple plus complexe : Table Note

```sql
CREATE TABLE student.note (
    id_note SERIAL PRIMARY KEY,
    id_etudiant INT NOT NULL,
    id_cours INT NOT NULL,
    valeur NUMERIC(4,2) NOT NULL CHECK (valeur >= 0 AND valeur <= 20),
    date_note DATE NOT NULL DEFAULT NOW(),

    FOREIGN KEY (id_etudiant) REFERENCES student.etudiant(id_etudiant),
    FOREIGN KEY (id_cours) REFERENCES student.cours(id_cours)
);
```

---

## 🔍 Analyse détaillée : Table Note

### Clé primaire
```sql
id_note SERIAL PRIMARY KEY
```
Identifiant unique de chaque note

### Clés étrangères
```sql
id_etudiant INT NOT NULL
id_cours INT NOT NULL
```
Références vers les tables `etudiant` et `cours`

---

### Valeur de la note
```sql
valeur NUMERIC(5,2) NOT NULL CHECK (valeur >= 0 AND valeur <= 20)
```

**Décortiquons** :
- `NUMERIC(5,2)` : Type numérique avec **précision fixe**
  - **5** = nombre total de chiffres (précision)
  - **2** = nombre de chiffres après la virgule (échelle)
  - **3** = nombre de chiffres avant la virgule (5 - 2 = 3)
  - **Exemples valides** : `18.75`, `20.00`, `0.50`, `15.25`
  - **Exemples invalides** : `123.45` (6 chiffres), `18.750` (3 décimales)
  - **Plage possible** : de `-999.99` à `999.99` (mais limité à 0-20 par CHECK)

> 💡 **Pourquoi NUMERIC(5,2) et pas NUMERIC(4,2) ?**
> 
> Pour des notes entre **0 et 20**, `NUMERIC(4,2)` serait **suffisant** :
> - `NUMERIC(4,2)` = 2 chiffres avant + 2 décimales → plage : `-99.99` à `99.99`
> - `NUMERIC(5,2)` = 3 chiffres avant + 2 décimales → plage : `-999.99` à `999.99`
> 
> **Pourquoi utiliser (5,2) alors ?**
> - ✅ **Flexibilité future** : Si on veut étendre à d'autres systèmes de notation (ex: 0-100)
> - ✅ **Cohérence** : Même précision pour différents types de valeurs numériques
> - ✅ **Performance** : La différence de stockage est négligeable
> 
> **En pratique** : Les deux fonctionnent pour des notes 0-20, mais `NUMERIC(4,2)` est plus "serré" et adapté au besoin exact.
- `NOT NULL` : Obligatoire
- `CHECK (...)` : **Contrainte de validation**
  - La note doit être entre 0 et 20
  - ❌ Impossible d'insérer -5 ou 25

---

### Date avec valeur par défaut
```sql
date_note DATE NOT NULL DEFAULT NOW()
```

**Décortiquons** :
- `DATE` : Type date
- `NOT NULL` : Obligatoire
- `DEFAULT NOW()` : Si on ne spécifie pas de date, utilise la date du jour

> 💡 **Pratique** : On n'a pas besoin de saisir la date manuellement !

---

### Relations (contraintes de table)
```sql
FOREIGN KEY (id_etudiant) REFERENCES student.etudiant(id_etudiant),
FOREIGN KEY (id_cours) REFERENCES student.cours(id_cours)
```

**Ce que ça signifie** :
- Une note doit être liée à un étudiant existant
- Une note doit être liée à un cours existant
- Garantit l'intégrité des données

---

## 🎓 Exemple : Table Inscription (relation N-N)

```sql
CREATE TABLE student.inscription (
    id_inscription SERIAL PRIMARY KEY,
    id_etudiant INT NOT NULL,
    id_cours INT NOT NULL,
    date_inscription DATE NOT NULL DEFAULT NOW(),

    FOREIGN KEY (id_etudiant) REFERENCES student.etudiant(id_etudiant),
    FOREIGN KEY (id_cours) REFERENCES student.cours(id_cours),

    -- Contrainte d'unicité
    UNIQUE (id_etudiant, id_cours)
);
```

---

## 🔐 Contrainte UNIQUE

```sql
UNIQUE (id_etudiant, id_cours)
```

**Signification** :
- ✅ Un étudiant peut s'inscrire à plusieurs cours
- ✅ Un cours peut avoir plusieurs étudiants
- ❌ Un étudiant ne peut PAS s'inscrire **deux fois** au même cours

**Exemple** :
```sql
-- ✅ OK : Jean s'inscrit à "SQL"
INSERT INTO inscription (id_etudiant, id_cours) VALUES (1, 10);

-- ❌ ERREUR : Jean essaie de s'inscrire à nouveau à "SQL"
INSERT INTO inscription (id_etudiant, id_cours) VALUES (1, 10);
```

---

## 🛡️ Les contraintes SQL

### NOT NULL
```sql
nom VARCHAR(255) NOT NULL
```
La colonne **doit** avoir une valeur

### UNIQUE
```sql
email VARCHAR(255) UNIQUE
```
Toutes les valeurs doivent être **différentes**

### CHECK
```sql
valeur NUMERIC(5,2) CHECK (valeur >= 0 AND valeur <= 20)
```
Validation personnalisée

---

### DEFAULT
```sql
date_inscription DATE DEFAULT NOW()
```
Valeur par défaut si non spécifiée

### PRIMARY KEY
```sql
id_etudiant SERIAL PRIMARY KEY
```
Unique + Not Null + Index

### FOREIGN KEY
```sql
FOREIGN KEY (id_etablissement) REFERENCES etablissement(id_etablissement)
```
Relation vers une autre table

---

## 📊 Schéma complet de notre base

```
┌─────────────────┐
│  etablissement  │
│  (6 lignes)     │
└────────┬────────┘
         │ 1
         │
         │ N
┌────────┴────────┐         ┌─────────────────┐
│    etudiant     │         │     cours       │
│  (2000 lignes)  │         │  (100 lignes)   │
└────────┬────────┘         └────────┬────────┘
         │                           │
         │ N                     N   │
         │                           │
         └────────┐     ┌────────────┘
                  │     │
              ┌───┴─────┴───┐
              │ inscription │
              │ (1000 lignes)│
              └──────────────┘
                     │
                     │
              ┌──────┴──────┐
              │    note     │
              │ (1000 lignes)│
              └─────────────┘
```

---

## 🔢 Types de relations

### 1-N (One to Many)
**Exemple** : Un établissement a plusieurs étudiants
```
etablissement (1) ─────< (N) etudiant
```

### N-N (Many to Many)
**Exemple** : Plusieurs étudiants ↔ plusieurs cours
```
etudiant (N) >───< inscription >───< (N) cours
```

> 💡 Pour une relation N-N, on utilise une **table de liaison** (ici : `inscription`)

---

## 🧪 Exercices pratiques

### Niveau 1 : Compréhension

1. Combien de colonnes a la table `etudiant` ?
2. Quel est le type de données de `date_naissance` ?
3. Quelle est la clé primaire de la table `cours` ?
4. Quelle colonne de `etudiant` est une clé étrangère ?

### Niveau 2 : Analyse

5. Pourquoi utilise-t-on SERIAL pour les clés primaires ?
6. Que se passe-t-il si on essaie d'ajouter un étudiant avec un `id_etablissement` qui n'existe pas ?
7. Pourquoi la table `inscription` a-t-elle une contrainte UNIQUE sur (id_etudiant, id_cours) ?

---

### Niveau 3 : Création

8. Créez une table `professeur` avec :
   - `id_professeur` (clé primaire)
   - `nom` (obligatoire, max 255 caractères)
   - `prenom` (obligatoire, max 255 caractères)
   - `specialite` (max 100 caractères)
   - `date_embauche` (date, obligatoire)

9. Créez une table `salle` avec :
   - `id_salle` (clé primaire)
   - `numero` (texte court, obligatoire, unique)
   - `capacite` (entier, obligatoire)
   - `batiment` (texte)

---

## 📋 Récapitulatif

| Concept | Description | Exemple |
|---------|-------------|---------|
| **Table** | Conteneur de données | `etudiant`, `cours` |
| **Colonne** | Propriété/Attribut | `nom`, `prenom`, `email` |
| **Ligne** | Un enregistrement | Un étudiant spécifique |
| **PRIMARY KEY** | Identifiant unique | `id_etudiant` |
| **FOREIGN KEY** | Lien vers autre table | `id_etablissement` |
| **NOT NULL** | Obligatoire | `nom VARCHAR(255) NOT NULL` |
| **UNIQUE** | Valeurs différentes | `email VARCHAR(255) UNIQUE` |
| **CHECK** | Validation | `CHECK (valeur >= 0)` |
| **DEFAULT** | Valeur par défaut | `DEFAULT NOW()` |

---

## 💡 Ce qu'on a appris

✅ Structure d'une base de données (tables, colonnes, lignes)  
✅ Types de données SQL (numériques, texte, dates)  
✅ Clés primaires pour identifier uniquement chaque ligne  
✅ Clés étrangères pour relier les tables  
✅ CREATE TABLE pour créer des tables  
✅ Contraintes pour garantir l'intégrité des données  
✅ Relations entre tables (1-N, N-N)  

