-- =========================================
-- Script de seed pour démonstration de performance
-- Base de données : codaSchool
-- Schéma : performance (nouveau schéma créé dans la même base)
-- Volume : 100 000+ lignes pour tester les index
-- =========================================
--
-- 📋 INSTRUCTIONS D'UTILISATION
-- =========================================
-- 
-- Option 1 : Avec Docker Compose (recommandé)
-- ---------------------------------------------
-- docker-compose exec -T postgres psql -U codaSchoolUser -d codaSchool < scripts/seed-performance.sql
--
-- Option 2 : Avec psql directement
-- ----------------------------------
-- 1. Se connecter à la base de données codaSchool :
--    psql -h localhost -U codaSchoolUser -d codaSchool
--
-- 2. Exécuter ce script :
--    \i scripts/seed-performance.sql
--    ou
--    psql -h localhost -U codaSchoolUser -d codaSchool -f scripts/seed-performance.sql
--
-- 3. Le script va :
--    - Créer le schéma "performance" s'il n'existe pas
--    - Créer 4 tables (client, produit, commande, commande_detail)
--    - Générer 100 000 clients
--    - Générer 10 000 produits
--    - Générer 1 000 000 commandes
--    - Générer 5 000 000 lignes de détails de commande
--
-- 4. Temps d'exécution estimé : 10-20 minutes selon la machine
--
-- 5. Pour vérifier les données :
--    SELECT COUNT(*) FROM performance.client;
--    SELECT COUNT(*) FROM performance.commande;
-- =========================================

-- Créer le schéma performance s'il n'existe pas
CREATE SCHEMA IF NOT EXISTS performance;

-- Utiliser le schéma performance
SET search_path TO performance;

-- =========================================
-- Supprimer les tables si elles existent (pour pouvoir refaire)
-- =========================================

DROP TABLE IF EXISTS performance.commande_detail CASCADE;
DROP TABLE IF EXISTS performance.commande CASCADE;
DROP TABLE IF EXISTS performance.produit CASCADE;
DROP TABLE IF EXISTS performance.client CASCADE;

-- =========================================
-- Créer des tables de test pour la performance
-- =========================================

-- Table client (100 000 clients)
CREATE TABLE performance.client (
    id_client SERIAL PRIMARY KEY,
    nom VARCHAR(255) NOT NULL,
    prenom VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    ville VARCHAR(255) NOT NULL,
    code_postal VARCHAR(10) NOT NULL,
    date_inscription DATE NOT NULL
);

-- Table produit (10 000 produits)
CREATE TABLE performance.produit (
    id_produit SERIAL PRIMARY KEY,
    nom VARCHAR(255) NOT NULL,
    categorie VARCHAR(100) NOT NULL,
    prix NUMERIC(10,2) NOT NULL,
    stock INT NOT NULL
);

-- Table commande (1 000 000 commandes)
CREATE TABLE performance.commande (
    id_commande SERIAL PRIMARY KEY,
    id_client INT NOT NULL,
    date_commande DATE NOT NULL,
    montant_total NUMERIC(10,2) NOT NULL,
    statut VARCHAR(50) NOT NULL,
    ville_livraison VARCHAR(255) NOT NULL
);

-- Table commande_detail (5 000 000 lignes de détails)
CREATE TABLE performance.commande_detail (
    id_detail SERIAL PRIMARY KEY,
    id_commande INT NOT NULL,
    id_produit INT NOT NULL,
    quantite INT NOT NULL,
    prix_unitaire NUMERIC(10,2) NOT NULL,
    FOREIGN KEY (id_commande) REFERENCES performance.commande(id_commande),
    FOREIGN KEY (id_produit) REFERENCES performance.produit(id_produit)
);

-- =========================================
-- Générer 100 000 clients
-- =========================================
DO $$
DECLARE
    noms TEXT[] := ARRAY['Dupont', 'Martin', 'Bernard', 'Petit', 'Durand', 'Leroy', 'Moreau', 'Simon', 
                         'Laurent', 'Michel', 'Garcia', 'Roux', 'David', 'Bertrand', 'Morel', 'Fournier',
                         'Girard', 'Bonnet', 'Blanc', 'Rousseau', 'Vincent', 'Muller', 'Lefebvre', 'Mercier'];
    prenoms TEXT[] := ARRAY['Jean', 'Sophie', 'Lucas', 'Emma', 'Thomas', 'Chloé', 'Alexandre', 'Léa',
                            'Hugo', 'Clara', 'Louis', 'Camille', 'Nathan', 'Sarah', 'Paul', 'Julie'];
    villes TEXT[] := ARRAY['Paris', 'Lyon', 'Marseille', 'Toulouse', 'Nice', 'Nantes', 'Strasbourg', 'Montpellier',
                           'Bordeaux', 'Lille', 'Rennes', 'Reims', 'Saint-Étienne', 'Toulon', 'Grenoble', 'Dijon'];
    i INTEGER;
BEGIN
    FOR i IN 1..100000 LOOP
        INSERT INTO performance.client (nom, prenom, email, ville, code_postal, date_inscription)
        VALUES (
            noms[(i % array_length(noms, 1)) + 1],
            prenoms[(i % array_length(prenoms, 1)) + 1],
            'client' || i || '@example.com',
            villes[(i % array_length(villes, 1)) + 1],
            LPAD((70000 + (i % 9999))::TEXT, 5, '0'),
            DATE '2020-01-01' + (RANDOM() * 1500)::INTEGER
        );
    END LOOP;
END $$;

-- =========================================
-- Générer 10 000 produits
-- =========================================
DO $$
DECLARE
    categories TEXT[] := ARRAY['Électronique', 'Vêtements', 'Alimentaire', 'Maison', 'Sport', 'Loisirs', 'Livres', 'Jardin'];
    produits_electronique TEXT[] := ARRAY['Laptop', 'Smartphone', 'Tablette', 'Écran', 'Souris', 'Clavier', 'Webcam', 'Casque'];
    produits_vetements TEXT[] := ARRAY['T-shirt', 'Pantalon', 'Veste', 'Chaussures', 'Chapeau', 'Gants', 'Écharpe', 'Sweat'];
    produits_alimentaire TEXT[] := ARRAY['Pâtes', 'Riz', 'Légumes', 'Fruits', 'Fromage', 'Pain', 'Lait', 'Œufs'];
    i INTEGER;
    categorie TEXT;
    nom_produit TEXT;
BEGIN
    FOR i IN 1..10000 LOOP
        categorie := categories[(i % array_length(categories, 1)) + 1];
        
        CASE categorie
            WHEN 'Électronique' THEN
                nom_produit := produits_electronique[(i % array_length(produits_electronique, 1)) + 1] || ' ' || i;
            WHEN 'Vêtements' THEN
                nom_produit := produits_vetements[(i % array_length(produits_vetements, 1)) + 1] || ' ' || i;
            WHEN 'Alimentaire' THEN
                nom_produit := produits_alimentaire[(i % array_length(produits_alimentaire, 1)) + 1] || ' ' || i;
            ELSE
                nom_produit := 'Produit ' || i;
        END CASE;
        
        INSERT INTO performance.produit (nom, categorie, prix, stock)
        VALUES (
            nom_produit,
            categorie,
            ROUND((RANDOM() * 990 + 10)::NUMERIC, 2),  -- Prix entre 10 et 1000
            (RANDOM() * 1000)::INTEGER  -- Stock entre 0 et 1000
        );
    END LOOP;
END $$;

-- =========================================
-- Générer 1 000 000 commandes
-- =========================================
DO $$
DECLARE
    statuts TEXT[] := ARRAY['En attente', 'Confirmée', 'Expédiée', 'Livrée', 'Annulée'];
    villes TEXT[] := ARRAY['Paris', 'Lyon', 'Marseille', 'Toulouse', 'Nice', 'Nantes', 'Strasbourg', 'Montpellier'];
    i INTEGER;
BEGIN
    FOR i IN 1..1000000 LOOP
        INSERT INTO performance.commande (id_client, date_commande, montant_total, statut, ville_livraison)
        VALUES (
            1 + (RANDOM() * 99999)::INTEGER,  -- Client aléatoire entre 1 et 100000
            DATE '2023-01-01' + (RANDOM() * 730)::INTEGER,  -- Date entre 2023 et 2024
            ROUND((RANDOM() * 990 + 10)::NUMERIC, 2),  -- Montant entre 10 et 1000
            statuts[(i % array_length(statuts, 1)) + 1],
            villes[(i % array_length(villes, 1)) + 1]
        );
    END LOOP;
END $$;

-- =========================================
-- Générer 5 000 000 lignes de détails de commande
-- =========================================
DO $$
DECLARE
    i INTEGER;
    commande_id INTEGER;
    produit_id INTEGER;
BEGIN
    FOR i IN 1..5000000 LOOP
        commande_id := 1 + (RANDOM() * 999999)::INTEGER;  -- Commande aléatoire entre 1 et 1000000
        produit_id := 1 + (RANDOM() * 9999)::INTEGER;     -- Produit aléatoire entre 1 et 10000
        
        INSERT INTO performance.commande_detail (id_commande, id_produit, quantite, prix_unitaire)
        VALUES (
            commande_id,
            produit_id,
            1 + (RANDOM() * 9)::INTEGER,  -- Quantité entre 1 et 10
            ROUND((RANDOM() * 990 + 10)::NUMERIC, 2)  -- Prix entre 10 et 1000
        );
    END LOOP;
END $$;

-- =========================================
-- Statistiques finales
-- =========================================
SELECT 
    'Clients' as table_name, COUNT(*) as nombre_lignes FROM performance.client
UNION ALL
SELECT 'Produits', COUNT(*) FROM performance.produit
UNION ALL
SELECT 'Commandes', COUNT(*) FROM performance.commande
UNION ALL
SELECT 'Détails commande', COUNT(*) FROM performance.commande_detail;

-- =========================================
-- Message de confirmation
-- =========================================
DO $$
BEGIN
    RAISE NOTICE '✅ Seed terminé avec succès !';
    RAISE NOTICE '📊 Données générées dans le schéma "performance"';
    RAISE NOTICE '💡 Utilisez EXPLAIN ANALYZE pour tester les performances';
END $$;
