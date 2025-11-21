# ⚡ Performance et fiabilité

## 🎯 Objectifs du cours

- Comprendre le rôle des index pour améliorer les performances
- Utiliser EXPLAIN pour analyser les requêtes
- Créer et gérer des index
- Comprendre les transactions (BEGIN, COMMIT, ROLLBACK)
- Garantir la cohérence des données avec les transactions

---

## 🔧 Prérequis : Setup du schéma de performance

### 📚 Théorie : Pourquoi un schéma séparé ?

Pour cette section, nous utilisons un **schéma séparé** (`performance`) avec **beaucoup de données** pour démontrer l'impact des index sur les performances.

**Volume de données** :
- 100 000 clients
- 10 000 produits
- 1 000 000 commandes
- 5 000 000 lignes de détails de commande

Ce volume permet de voir clairement la différence entre une requête lente (sans index) et une requête rapide (avec index).

### 📝 Instructions de setup

#### Étape 1 : Vérifier que Docker est lancé

```bash
docker-compose ps
```

Assurez-vous que le conteneur `postgres` est en cours d'exécution.

#### Étape 2 : Exécuter le script de seed

```bash
docker-compose exec -T postgres psql -U codaSchoolUser -d codaSchool < scripts/seed-performance.sql
```

**Ce que fait le script** :
1. ✅ Crée le schéma `performance` s'il n'existe pas
2. ✅ Supprime les tables existantes (pour pouvoir refaire)
3. ✅ Crée 4 tables : `client`, `produit`, `commande`, `commande_detail`
4. ✅ Génère 10 000 clients
5. ✅ Génère 1 000 produits
6. ✅ Génère 100 000 commandes
7. ✅ Génère 500 000 lignes de détails de commande

**Temps d'exécution estimé** : 10-20 minutes selon la machine

#### Étape 3 : Vérifier que les données sont créées

```sql
-- Se connecter à la base
docker-compose exec postgres psql -U codaSchoolUser -d codaSchool

-- Vérifier les statistiques
SELECT 
    'Clients' as table_name, COUNT(*) as nombre_lignes 
FROM performance.client
UNION ALL
SELECT 'Produits', COUNT(*) FROM performance.produit
UNION ALL
SELECT 'Commandes', COUNT(*) FROM performance.commande
UNION ALL
SELECT 'Détails commande', COUNT(*) FROM performance.commande_detail;
```

**Résultat attendu** :
```
table_name        | nombre_lignes
------------------+---------------
Clients           |        100000
Produits          |         10000
Commandes         |       1000000
Détails commande  |       5000000
```

#### Étape 4 : Vérifier qu'il n'y a pas d'index

```sql
-- Lister les index du schéma performance
SELECT 
    tablename,
    indexname,
    indexdef
FROM pg_indexes
WHERE schemaname = 'performance'
ORDER BY tablename, indexname;
```

**Résultat attendu** : Seulement les index automatiques (PRIMARY KEY), pas d'index supplémentaires.

### ⚠️ Important

- **Le script peut être exécuté plusieurs fois** : Il supprime et recrée tout à chaque fois
- **Les données sont générées aléatoirement** : Les résultats des requêtes peuvent varier légèrement
- **Utilisez le schéma `performance`** : Toutes les requêtes de cette section utilisent `performance.table_name`

### ✅ Vous êtes prêt !

Une fois le setup terminé, vous pouvez commencer les exercices sur les index et les transactions.

---

## 📊 Index : Qu'est-ce que c'est ?

### 📚 Théorie : Le problème de performance

Sans index, PostgreSQL doit **parcourir toutes les lignes** d'une table pour trouver les données (scan séquentiel). Sur de grandes tables, c'est **très lent**.

**Analogie** : Un index est comme l'index d'un livre :
- Sans index : Vous lisez toutes les pages pour trouver un mot
- Avec index : Vous allez directement à la page grâce à l'index

### 📚 Théorie : Comment fonctionne un index ?

Un **index** est une structure de données qui permet de trouver rapidement les lignes correspondant à une valeur.

**Types d'index** :
- **B-tree** (par défaut) : Pour la plupart des cas (recherches, tri, comparaisons)
- **Hash** : Pour les égalités exactes
- **GIN, GiST** : Pour les types complexes (tableaux, texte, géométrie)

**Avantages** :
- ✅ Recherche très rapide
- ✅ Tri accéléré
- ✅ JOINs plus efficaces

**Inconvénients** :
- ❌ Prend de l'espace disque
- ❌ Ralentit les INSERT/UPDATE/DELETE (l'index doit être mis à jour)

---

## 🔍 EXPLAIN : Analyser les performances

### 📚 Théorie : Qu'est-ce qu'EXPLAIN ?

`EXPLAIN` montre le **plan d'exécution** d'une requête : comment PostgreSQL va exécuter la requête.

**Syntaxe** :
```sql
EXPLAIN SELECT ...;
```

**EXPLAIN ANALYZE** : Exécute la requête et montre les temps réels :
```sql
EXPLAIN ANALYZE SELECT ...;
```

### 📚 Théorie : Types de scans

| Type de scan | Description | Performance |
|--------------|-------------|-------------|
| **Seq Scan** | Parcourt toutes les lignes | ❌ Très lent sur grandes tables |
| **Index Scan** | Utilise un index | ✅ Rapide |
| **Bitmap Index Scan** | Utilise un index avec plusieurs valeurs | ✅ Rapide |

---

## 🐌 Démonstration : Requête lente sans index

### 📚 Préparation : Tables avec beaucoup de données

Pour cette démonstration, nous utilisons des tables avec **beaucoup de données** :
- `client` : 100 000 clients
- `commande` : 1 000 000 commandes
- `commande_detail` : 5 000 000 lignes de détails

**Note** : Utilisez le fichier `scripts/seed-performance.sql` pour générer ces données dans le schéma `performance` de la base `codaSchool`.

### ⚠️ Important : Le cache PostgreSQL

**Problème** : PostgreSQL met en cache les données en mémoire. Après la première exécution, les requêtes suivantes sont **beaucoup plus rapides** même sans index car les données sont déjà en cache.

**Exemple réel** :
- **1ère requête** (sans cache) : ~500 ms
- **2ème requête** (avec cache) : ~40 ms
- **Avec index** : ~1-3 ms

**Solution** : Pour avoir des mesures réalistes, il faut vider le cache entre les tests.

### 🐌 Requête lente : Recherche sans index

**⚠️ Important** : Exécutez cette requête **juste après avoir vidé le cache** (`DISCARD PLANS;`) pour avoir des mesures réalistes.

**Requête simple** (pour commencer) :
```sql
-- Rechercher les commandes d'un client spécifique
SELECT 
    c.nom,
    c.prenom,
    co.date_commande,
    co.montant_total
FROM performance.client c
INNER JOIN performance.commande co ON c.id_client = co.id_client
WHERE c.email = 'client5000@example.com';
```

**Requête complexe** (montre vraiment la différence) :
```sql
-- Statistiques détaillées : commandes livrées par ville avec agrégations
SELECT 
    c.ville,
    co.statut,
    COUNT(DISTINCT co.id_commande) AS nombre_commandes,
    COUNT(cd.id_detail) AS nombre_lignes_detail,
    SUM(co.montant_total) AS montant_total,
    AVG(co.montant_total) AS montant_moyen,
    MIN(co.date_commande) AS premiere_commande,
    MAX(co.date_commande) AS derniere_commande
FROM performance.client c
INNER JOIN performance.commande co ON c.id_client = co.id_client
LEFT JOIN performance.commande_detail cd ON co.id_commande = cd.id_commande
WHERE co.statut = 'Livrée'
  AND co.date_commande >= '2023-06-01'
  AND c.ville IN ('Paris', 'Lyon', 'Marseille')
GROUP BY c.ville, co.statut
HAVING COUNT(DISTINCT co.id_commande) > 10
ORDER BY montant_total DESC;
```

Cette requête complexe combine :
- ✅ Plusieurs JOINs (client → commande → commande_detail)
- ✅ Filtres multiples (statut, date, ville)
- ✅ Agrégations (COUNT, SUM, AVG, MIN, MAX)
- ✅ GROUP BY et HAVING
- ✅ ORDER BY

**Sans index** : Cette requête sera **très lente** car elle doit scanner toutes les tables.

**Analyse avec EXPLAIN** (requête complexe) :

```sql
-- Vider le cache d'abord
DISCARD PLANS;

-- Puis analyser la requête complexe
EXPLAIN ANALYZE
SELECT 
    c.ville,
    co.statut,
    COUNT(DISTINCT co.id_commande) AS nombre_commandes,
    COUNT(cd.id_detail) AS nombre_lignes_detail,
    SUM(co.montant_total) AS montant_total,
    AVG(co.montant_total) AS montant_moyen
FROM performance.client c
INNER JOIN performance.commande co ON c.id_client = co.id_client
LEFT JOIN performance.commande_detail cd ON co.id_commande = cd.id_commande
WHERE co.statut = 'Livrée'
  AND co.date_commande >= '2023-06-01'
  AND c.ville IN ('Paris', 'Lyon', 'Marseille')
GROUP BY c.ville, co.statut
HAVING COUNT(DISTINCT co.id_commande) > 10
ORDER BY montant_total DESC;
```

**Résultat attendu (SANS INDEX, SANS CACHE)** :
```
QUERY PLAN
---------------------------------------------------------------------------
GroupAggregate  (cost=XXXXX.XX..XXXXX.XX rows=XX width=XX) (actual time=XXXX.XXX..XXXX.XXX rows=XX loops=1)
  Group Key: c.ville, co.statut
  Filter: (count(DISTINCT co.id_commande) > 10)
  Rows Removed by Filter: XX
  ->  Sort  (cost=XXXXX.XX..XXXXX.XX rows=XXXXX width=XX) (actual time=XXXX.XXX..XXXX.XXX rows=XXXXX loops=1)
        Sort Key: c.ville, co.statut
        Sort Method: external merge  Disk: XXXXkB
        ->  Hash Right Join  (cost=XXXX.XX..XXXXX.XX rows=XXXXX width=XX) (actual time=XXX.XXX..XXXX.XXX rows=XXXXX loops=1)
              Hash Cond: (cd.id_commande = co.id_commande)
              ->  Seq Scan on commande_detail cd  (cost=0.00..XXXXX.XX rows=XXXXX width=XX) (actual time=XX.XXX..XXX.XXX rows=XXXXX loops=1)
              ->  Hash  (cost=XXXX.XX..XXXX.XX rows=XXXXX width=XX) (actual time=XXX.XXX..XXX.XXX rows=XXXXX loops=1)
                    Buckets: XXXX  Batches: X  Memory Usage: XXXkB
                    ->  Hash Join  (cost=XXXX.XX..XXXX.XX rows=XXXXX width=XX) (actual time=XXX.XXX..XXX.XXX rows=XXXXX loops=1)
                          Hash Cond: (co.id_client = c.id_client)
                          ->  Seq Scan on commande co  (cost=0.00..XXXX.XX rows=XXXXX width=XX) (actual time=XX.XXX..XXX.XXX rows=XXXXX loops=1)
                                Filter: ((statut = 'Livrée'::text) AND (date_commande >= '2023-06-01'::date))
                                Rows Removed by Filter: XXXXX
                          ->  Hash  (cost=XXXX.XX..XXXX.XX rows=XXXXX width=XX) (actual time=XX.XXX..XX.XXX rows=XXXXX loops=1)
                                Buckets: XXXX  Batches: X  Memory Usage: XXXkB
                                ->  Seq Scan on client c  (cost=0.00..XXXX.XX rows=XXXXX width=XX) (actual time=XX.XXX..XX.XXX rows=XXXXX loops=1)
                                      Filter: (ville = ANY ('{Paris,Lyon,Marseille}'::text[]))
                                      Rows Removed by Filter: XXXXX
Planning Time: X.XXX ms
Execution Time: 2000-5000 ms  ← TRÈS LENT (sans index, sans cache)
```

**Résultat avec cache (2ème exécution)** :
```
Execution Time: 200-500 ms  ← Plus rapide grâce au cache, mais toujours des Seq Scan !
```

**Problèmes identifiés (requête complexe)** :
- ❌ **Seq Scan** sur `client` : Parcourt 100 000 lignes pour filtrer par ville
- ❌ **Seq Scan** sur `commande` : Parcourt 1 000 000 lignes pour filtrer par statut et date
- ❌ **Seq Scan** sur `commande_detail` : Parcourt 5 000 000 lignes pour le JOIN
- ❌ **Sort Method: external merge Disk** : Tri sur disque (très lent)
- ❌ **Execution Time** : 
  - **Sans cache** : 2000-5000 ms (2-5 secondes !)
  - **Avec cache** : 200-500 ms - mais toujours des Seq Scan
  - **Avec index** : 10-50 ms - Index Scan direct

---

## 🔄 Vider le cache pour des mesures réalistes

### 📚 Théorie : Pourquoi vider le cache ?

Pour comparer équitablement les performances avec et sans index, il faut vider le cache PostgreSQL entre les tests. Sinon, le cache fausse les résultats.

### 📝 Comment vider le cache

**Option 1 : Vider le cache avec SQL** (recommandé)
```sql
-- Vider le cache des plans d'exécution et des données en mémoire
DISCARD PLANS;

-- Ou vider tout (plans, séquences, temporaires)
DISCARD ALL;
```

**Option 2 : Redémarrer PostgreSQL** (le plus simple mais plus long)
```bash
docker-compose restart postgres
```

**Option 3 : Utiliser une nouvelle connexion** (simple)
```sql
-- Se déconnecter
\q

-- Se reconnecter (le cache est partiellement vidé)
docker-compose exec postgres psql -U codaSchoolUser -d codaSchool
```

**💡 Commande rapide pour vider le cache** :
```sql
DISCARD PLANS;
```

Cette commande vide le cache des plans d'exécution, ce qui force PostgreSQL à recalculer le plan d'exécution et à recharger les données depuis le disque.

### 💡 Bonne pratique

Pour des mesures réalistes :
1. ✅ Vider le cache (redémarrer PostgreSQL)
2. ✅ Exécuter la requête **sans index** et noter le temps
3. ✅ Créer les index
4. ✅ Vider le cache à nouveau
5. ✅ Exécuter la même requête **avec index** et comparer

---

## ⚡ Solution : Créer des index

### 📚 Théorie : Créer un index

**Syntaxe** :
```sql
CREATE INDEX nom_index ON table (colonne);
```

**Index unique** :
```sql
CREATE UNIQUE INDEX nom_index ON table (colonne);
```

**Index composite** (plusieurs colonnes) :
```sql
CREATE INDEX nom_index ON table (colonne1, colonne2);
```

### ⚡ Créer les index nécessaires

```sql
-- Index sur email (pour la recherche de client)
CREATE INDEX idx_client_email ON performance.client(email);

-- Index sur ville (pour filtrer par ville)
CREATE INDEX idx_client_ville ON performance.client(ville);

-- Index sur id_client dans commande (pour le JOIN)
CREATE INDEX idx_commande_client ON performance.commande(id_client);

-- Index composite sur statut et date (pour les filtres combinés)
CREATE INDEX idx_commande_statut_date ON performance.commande(statut, date_commande);

-- Index sur id_commande dans commande_detail (pour le JOIN)
CREATE INDEX idx_commande_detail_commande ON performance.commande_detail(id_commande);
```

**Note** : Les index composites sont particulièrement efficaces pour les requêtes avec plusieurs filtres.

---

## 🚀 Démonstration : Requête rapide avec index

### 🚀 Même requête complexe après création des index

```sql
-- Vider le cache d'abord
DISCARD PLANS;

-- Puis analyser la requête complexe avec index
EXPLAIN ANALYZE
SELECT 
    c.ville,
    co.statut,
    COUNT(DISTINCT co.id_commande) AS nombre_commandes,
    COUNT(cd.id_detail) AS nombre_lignes_detail,
    SUM(co.montant_total) AS montant_total,
    AVG(co.montant_total) AS montant_moyen
FROM performance.client c
INNER JOIN performance.commande co ON c.id_client = co.id_client
LEFT JOIN performance.commande_detail cd ON co.id_commande = cd.id_commande
WHERE co.statut = 'Livrée'
  AND co.date_commande >= '2023-06-01'
  AND c.ville IN ('Paris', 'Lyon', 'Marseille')
GROUP BY c.ville, co.statut
HAVING COUNT(DISTINCT co.id_commande) > 10
ORDER BY montant_total DESC;
```

**Résultat attendu (AVEC INDEX)** :
```
QUERY PLAN
---------------------------------------------------------------------------
GroupAggregate  (cost=XXXX.XX..XXXX.XX rows=XX width=XX) (actual time=XX.XXX..XX.XXX rows=XX loops=1)
  Group Key: c.ville, co.statut
  Filter: (count(DISTINCT co.id_commande) > 10)
  ->  Sort  (cost=XXXX.XX..XXXX.XX rows=XXXX width=XX) (actual time=XX.XXX..XX.XXX rows=XXXX loops=1)
        Sort Key: c.ville, co.statut
        Sort Method: quicksort  Memory: XXXkB  ← Tri en mémoire (rapide)
        ->  Hash Right Join  (cost=XXX.XX..XXXX.XX rows=XXXX width=XX) (actual time=X.XXX..XX.XXX rows=XXXX loops=1)
              Hash Cond: (cd.id_commande = co.id_commande)
              ->  Index Scan using idx_commande_detail_commande on commande_detail cd  (cost=0.XX..XXX.XX rows=XXXX width=XX) (actual time=X.XXX..X.XXX rows=XXXX loops=1)
              ->  Hash  (cost=XXX.XX..XXX.XX rows=XXXX width=XX) (actual time=X.XXX..X.XXX rows=XXXX loops=1)
                    Buckets: XXXX  Batches: X  Memory Usage: XXXkB
                    ->  Hash Join  (cost=XXX.XX..XXX.XX rows=XXXX width=XX) (actual time=X.XXX..X.XXX rows=XXXX loops=1)
                          Hash Cond: (co.id_client = c.id_client)
                          ->  Index Scan using idx_commande_statut_date on commande co  (cost=0.XX..XXX.XX rows=XXXX width=XX) (actual time=X.XXX..X.XXX rows=XXXX loops=1)
                                Index Cond: ((statut = 'Livrée'::text) AND (date_commande >= '2023-06-01'::date))
                          ->  Hash  (cost=XXX.XX..XXX.XX rows=XXXX width=XX) (actual time=X.XXX..X.XXX rows=XXXX loops=1)
                                Buckets: XXXX  Batches: X  Memory Usage: XXXkB
                                ->  Index Scan using idx_client_ville on client c  (cost=0.XX..XXX.XX rows=XXXX width=XX) (actual time=X.XXX..X.XXX rows=XXXX loops=1)
                                      Index Cond: (ville = ANY ('{Paris,Lyon,Marseille}'::text[]))
Planning Time: X.XXX ms
Execution Time: 10-50 ms  ← TRÈS RAPIDE !
```

**Améliorations** :
- ✅ **Index Scan** partout : Plus de Seq Scan !
- ✅ **Sort Method: quicksort Memory** : Tri en mémoire au lieu du disque
- ✅ **Execution Time** : 
  - **Sans index (sans cache)** : 2000-5000 ms (2-5 secondes)
  - **Sans index (avec cache)** : 200-500 ms
  - **Avec index** : 10-50 ms
- ✅ **Performance** : 40x à 500x plus rapide ! 🚀

**Différence flagrante** : De plusieurs secondes à quelques dizaines de millisecondes !

---

## 📊 Comparaison : Avant vs Après index

### Exemple de requête complexe

```sql
-- Trouver toutes les commandes "Livrée" d'un client spécifique
SELECT 
    c.nom,
    c.prenom,
    co.date_commande,
    co.montant_total,
    co.ville_livraison
FROM performance.client c
INNER JOIN performance.commande co ON c.id_client = co.id_client
WHERE c.email = 'client5000@example.com'
  AND co.statut = 'Livrée'
  AND co.date_commande >= '2023-06-01'
ORDER BY co.date_commande DESC;
```

**Sans index (sans cache)** :
- Seq Scan sur `client` : ~100 000 lignes parcourues
- Seq Scan sur `commande` : ~1 000 000 lignes parcourues
- **Temps d'exécution** : 500-2000 ms - TRÈS LENT !

**Sans index (avec cache)** :
- Seq Scan toujours, mais données en mémoire
- **Temps d'exécution** : 40-100 ms - Plus rapide mais toujours un scan complet

**Avec index** :
- Index Scan sur `client` : 1 ligne trouvée directement
- Index Scan sur `commande` : Seulement les lignes correspondantes
- **Temps d'exécution** : 1-5 ms - TRÈS RAPIDE !

**Gain de performance** : 
- Sans cache : 100x à 2000x plus rapide
- Avec cache : 8x à 100x plus rapide

---

## 🔧 Gérer les index

### 📚 Théorie : Lister les index

```sql
-- Voir tous les index d'une table
SELECT 
    indexname,
    indexdef
FROM pg_indexes
WHERE schemaname = 'performance' 
  AND tablename = 'commande';
```

### 📚 Théorie : Supprimer un index

```sql
DROP INDEX nom_index;
```

**Exemple** :
```sql
DROP INDEX performance.idx_commande_statut;
```

### 📚 Théorie : Quand créer un index ?

**✅ Créer un index quand** :
- Colonne souvent utilisée dans WHERE
- Colonne utilisée dans JOIN
- Colonne utilisée dans ORDER BY
- Table avec beaucoup de données (> 10 000 lignes)

**❌ Ne PAS créer d'index quand** :
- Table très petite (< 1000 lignes)
- Colonne rarement utilisée
- Colonne modifiée très souvent (INSERT/UPDATE fréquents)

---

## 🔄 Transactions : BEGIN, COMMIT, ROLLBACK

### 📚 Théorie : Qu'est-ce qu'une transaction ?

Une **transaction** est un ensemble d'opérations SQL qui doivent être exécutées **toutes ensemble** ou **aucune**.

**Propriétés ACID** :
- **Atomicité** : Tout ou rien
- **Cohérence** : Les données restent cohérentes
- **Isolation** : Les transactions ne se voient pas mutuellement
- **Durabilité** : Les modifications sont permanentes après COMMIT

### 📚 Théorie : Syntaxe des transactions

```sql
BEGIN;          -- Démarre une transaction
-- Opérations SQL
COMMIT;         -- Valide toutes les modifications
-- ou
ROLLBACK;       -- Annule toutes les modifications
```

---

## 📝 Exemples de transactions

### 🎯 Exemple 1 : Transfert d'argent

```sql
BEGIN;

-- Débiter le compte A
UPDATE compte SET solde = solde - 100 WHERE id = 1;

-- Créditer le compte B
UPDATE compte SET solde = solde + 100 WHERE id = 2;

-- Si tout est OK
COMMIT;

-- Si erreur, annuler
-- ROLLBACK;
```

**Sans transaction** : Si la deuxième opération échoue, l'argent est perdu !

### 🎯 Exemple 2 : Créer une commande avec détails

```sql
BEGIN;

-- Créer la commande
INSERT INTO performance.commande (id_client, date_commande, montant_total, statut, ville_livraison)
VALUES (1, CURRENT_DATE, 150.00, 'En attente', 'Paris')
RETURNING id_commande;

-- Créer les détails
INSERT INTO performance.commande_detail (id_commande, id_produit, quantite, prix_unitaire)
VALUES 
    (LASTVAL(), 10, 2, 50.00),
    (LASTVAL(), 20, 1, 50.00);

-- Si tout est OK
COMMIT;

-- Si erreur (ex: produit en rupture de stock)
-- ROLLBACK;
```

**Sans transaction** : On pourrait avoir une commande sans détails !

---

## ⚠️ Gestion des erreurs dans les transactions

### 📚 Théorie : ROLLBACK automatique

Si une erreur survient dans une transaction, PostgreSQL fait un **ROLLBACK automatique**.

**Exemple** :
```sql
BEGIN;

INSERT INTO performance.commande (id_client, date_commande, montant_total, statut, ville_livraison)
VALUES (1, CURRENT_DATE, 150.00, 'En attente', 'Paris');

-- ❌ Erreur : violation de contrainte
INSERT INTO performance.commande_detail (id_commande, id_produit, quantite, prix_unitaire)
VALUES (999999, 1, 1, 10.00);  -- id_commande n'existe pas

-- PostgreSQL fait automatiquement ROLLBACK
-- La première INSERT est annulée aussi
```

---

## 🧪 Exercices pratiques

> 💡 **Important** : Les solutions se trouvent dans le fichier `correction/section-8-performance-index-transactions.md`

### Niveau 1 : Analyser les performances

1. **Utiliser EXPLAIN**
   - Exécutez une requête simple sur la table `performance.commande`
   - Utilisez `EXPLAIN ANALYZE` pour voir le plan d'exécution
   - Identifiez les "Seq Scan" (scans séquentiels lents)

2. **Identifier les requêtes lentes**
   - Trouvez une requête qui fait un scan séquentiel
   - Notez le temps d'exécution
   - Identifiez les colonnes utilisées dans WHERE/JOIN

3. **Comparer avant/après index**
   - Exécutez `EXPLAIN ANALYZE` sur une requête
   - Créez un index approprié
   - Ré-exécutez `EXPLAIN ANALYZE` et comparez les temps

### Niveau 2 : Créer des index

4. **Index simple**
   - Créez un index sur la colonne `email` de la table `performance.client`
   - Testez une requête avec `WHERE email = ...`
   - Vérifiez avec EXPLAIN que l'index est utilisé

5. **Index composite**
   - Créez un index composite sur `(id_client, date_commande)` dans la table `performance.commande`
   - Testez une requête avec ces deux colonnes dans WHERE
   - Vérifiez l'utilisation de l'index

6. **Index pour JOIN**
   - Créez un index sur `id_client` dans la table `performance.commande`
   - Testez un JOIN entre `performance.client` et `performance.commande`
   - Vérifiez l'amélioration de performance

### Niveau 3 : Transactions

7. **Transaction simple**
   - Créez une transaction qui insère une commande et ses détails
   - Utilisez COMMIT pour valider
   - Testez avec ROLLBACK pour annuler

8. **Gestion d'erreur**
   - Créez une transaction avec une opération qui échoue
   - Observez le ROLLBACK automatique
   - Vérifiez que les modifications précédentes sont annulées

---

## 📋 Récapitulatif

### Index

| Concept | Description | Syntaxe |
|---------|-------------|---------|
| **Index** | Structure pour accélérer les recherches | `CREATE INDEX idx ON table (colonne)` |
| **Index unique** | Garantit l'unicité | `CREATE UNIQUE INDEX idx ON table (colonne)` |
| **Index composite** | Sur plusieurs colonnes | `CREATE INDEX idx ON table (col1, col2)` |
| **EXPLAIN** | Affiche le plan d'exécution | `EXPLAIN SELECT ...` |
| **EXPLAIN ANALYZE** | Exécute et montre les temps | `EXPLAIN ANALYZE SELECT ...` |

### Transactions

| Commande | Description | Usage |
|----------|-------------|-------|
| **BEGIN** | Démarre une transaction | `BEGIN;` |
| **COMMIT** | Valide les modifications | `COMMIT;` |
| **ROLLBACK** | Annule les modifications | `ROLLBACK;` |

### Bonnes pratiques

- ✅ Créer des index sur les colonnes souvent utilisées dans WHERE/JOIN
- ✅ Utiliser EXPLAIN pour analyser les performances
- ✅ Utiliser des transactions pour les opérations multiples
- ✅ Toujours COMMIT ou ROLLBACK explicitement
- ✅ Ne pas créer trop d'index (ralentit les INSERT/UPDATE)

---

## 💡 Ce qu'on a appris

✅ Comprendre le rôle des index pour améliorer les performances  
✅ Utiliser EXPLAIN pour analyser les requêtes  
✅ Créer et gérer des index  
✅ Identifier les requêtes lentes (Seq Scan)  
✅ Améliorer les performances avec des index appropriés  
✅ Utiliser les transactions (BEGIN, COMMIT, ROLLBACK)  
✅ Garantir la cohérence des données avec les transactions  

