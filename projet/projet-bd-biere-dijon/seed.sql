INSERT INTO DISTRICT (location_id, city, address) VALUES
(1, 'Paris', 'Montmartre'),
(2, 'Paris', 'Le Marais'),
(3, 'Paris', 'Bastille'),
(4, 'Paris', 'Quartier Latin'),
(5, 'Lyon', 'Vieux Lyon'),
(6, 'Lyon', 'Croix-Rousse'),
(7, 'Lyon', 'Confluence'),
(8, 'Bordeaux', 'Saint-Pierre'),
(9, 'Bordeaux', 'Les Chartrons'),
(10, 'Lille', 'Vieux Lille');

-- --- 20 BARS (2 par quartier en moyenne) ---
INSERT INTO bar (bar_id, location_id, nom) VALUES
-- Paris
(1, 1, 'Le Vrai Paris'), (2, 1, 'Chez Ammad'),
(3, 2, 'La Belle Hortense'), (4, 2, 'Le Sherry Butt'),
(5, 3, 'Moonshiner'), (6, 3, 'Bluebird'),
(7, 4, 'Le Piano Vache'), (8, 4, 'The Bombardier'),
-- Lyon
(9, 5, 'Les Fleurs du Malt'), (10, 5, 'BerthoM'),
(11, 6, 'Le Paddy''s Corner'), (12, 6, 'Dikkenek'),
(13, 7, 'Le Sucre'), (14, 7, 'Selcius'),
-- Bordeaux
(15, 8, 'Apollo Bar'), (16, 8, 'Vintage Bar'),
(17, 9, 'La Cervoiserie'), (18, 9, 'Le Zytho'),
-- Lille
(19, 10, 'La Capsule'), (20, 10, 'Le Dandy');

-- --- 40 BIÈRES ---
INSERT INTO BEER (beer_id, name, brand, degree) VALUES
-- Classiques / Lagers
(1, 'Heineken', 'Heineken', 5.0), (2, '1664', 'Kronenbourg', 5.5), 
(3, 'Stella Artois', 'AB InBev', 5.2), (4, 'Carlsberg', 'Carlsberg', 5.0),
(5, 'Jupiler', 'AB InBev', 5.2), (6, 'Peroni', 'Asahi', 5.1),
-- Belges Fortes
(7, 'Duvel', 'Duvel Moortgat', 8.5), (8, 'Chouffe', 'Achouffe', 8.0),
(9, 'Delirium Tremens', 'Huyghe', 8.5), (10, 'Chimay Bleue', 'Chimay', 9.0),
(11, 'Westmalle Tripel', 'Westmalle', 9.5), (12, 'Karmeliet', 'Bosteels', 8.4),
(13, 'Orval', 'Orval', 6.2), (14, 'Rochefort 10', 'Rochefort', 11.3),
(15, 'Kwak', 'Bosteels', 8.4), (16, 'Cuvée des Trolls', 'Dubuisson', 7.0),
-- IPA & Craft
(17, 'Punk IPA', 'BrewDog', 5.6), (18, 'Elvis Juice', 'BrewDog', 6.5),
(19, 'Brooklyn IPA', 'Brooklyn Brewery', 6.9), (20, 'Lagunitas IPA', 'Lagunitas', 6.2),
(21, 'Goose Island IPA', 'Goose Island', 5.9), (22, 'Hazy Jane', 'BrewDog', 5.0),
(23, 'Stone IPA', 'Stone Brewing', 6.9), (24, 'Jack Hammer', 'BrewDog', 7.2),
-- Stouts & Brunes
(25, 'Guinness Draught', 'Diageo', 4.2), (26, 'Leffe Brune', 'AB InBev', 6.5),
(27, 'Pelforth Brune', 'Heineken', 6.5), (28, 'Oatmeal Stout', 'Samuel Smith', 5.0),
-- Blanches
(29, 'Hoegaarden', 'AB InBev', 4.9), (30, 'Blanche de Namur', 'Du Bocq', 4.5),
(31, '1664 Blanc', 'Kronenbourg', 5.0), (32, 'Blue Moon', 'MillerCoors', 5.4),
-- Allemandes & Divers
(33, 'Paulaner Hefe-Weißbier', 'Paulaner', 5.5), (34, 'Franziskaner', 'Spaten', 5.0),
(35, 'Weihenstephaner', 'Weihenstephan', 5.4), (36, 'Desperados', 'Heineken', 5.9),
(37, 'Corona', 'AB InBev', 4.5), (38, 'Budweiser', 'AB InBev', 5.0),
(39, 'Kilkenny', 'Diageo', 4.3), (40, 'Grimbergen Blonde', 'Grimbergen', 6.7);

-- --- 150 PRIX (Répartition logique) ---
-- On distribue environ 7 à 8 bières par bar pour arriver à 150
INSERT INTO PRICE (bar_id, beer_id, price) VALUES
-- Bar 1 (Paris - Montmartre - Touristique)
(1, 1, 7.50), (1, 2, 7.50), (1, 7, 9.50), (1, 25, 8.50), (1, 17, 9.00), (1, 29, 8.00), (1, 37, 8.00), (1, 40, 8.00),
-- Bar 2 (Paris - Montmartre)
(2, 1, 6.50), (2, 8, 8.00), (2, 9, 8.50), (2, 16, 7.50), (2, 33, 8.00), (2, 36, 7.00), (2, 5, 6.50),
-- Bar 3 (Paris - Marais - Chic)
(3, 19, 9.50), (3, 20, 9.50), (3, 21, 9.00), (3, 10, 10.00), (3, 11, 10.50), (3, 25, 9.00), (3, 13, 9.50),
-- Bar 4 (Paris - Marais)
(4, 17, 9.00), (4, 18, 9.50), (4, 23, 10.00), (4, 24, 10.00), (4, 1, 7.00), (4, 3, 7.50), (4, 32, 8.50),
-- Bar 5 (Paris - Bastille - Spéakeasy/Cher)
(5, 7, 9.00), (5, 9, 9.00), (5, 12, 9.50), (5, 14, 11.00), (5, 25, 8.50), (5, 20, 9.00), (5, 2, 7.00), (5, 39, 8.50),
-- Bar 6 (Paris - Bastille)
(6, 17, 8.50), (6, 22, 8.50), (6, 19, 9.00), (6, 21, 9.00), (6, 6, 7.50), (6, 31, 7.50), (6, 40, 8.00),
-- Bar 7 (Paris - Quartier Latin - Etudiant)
(7, 1, 6.00), (7, 2, 6.00), (7, 5, 6.00), (7, 8, 7.50), (7, 16, 7.00), (7, 29, 6.50), (7, 36, 7.00), (7, 15, 8.00),
-- Bar 8 (Paris - Pub Anglais)
(8, 25, 7.50), (8, 39, 7.50), (8, 28, 8.00), (8, 17, 8.50), (8, 3, 7.00), (8, 4, 7.00), (8, 26, 7.50),
-- Bar 9 (Lyon - Vieux Lyon - Spécialiste Bière)
(9, 7, 8.00), (9, 8, 7.50), (9, 9, 8.00), (9, 10, 8.50), (9, 11, 9.00), (9, 12, 8.50), (9, 13, 8.00), (9, 14, 9.50), (9, 15, 8.50),
-- Bar 10 (Lyon - Vieux Lyon)
(10, 17, 7.50), (10, 20, 8.00), (10, 29, 6.50), (10, 30, 7.00), (10, 33, 7.50), (10, 34, 7.50), (10, 35, 7.50),
-- Bar 11 (Lyon - Croix-Rousse - Pub Irlandais)
(11, 25, 7.00), (11, 39, 7.00), (11, 1, 6.00), (11, 2, 6.00), (11, 16, 7.00), (11, 8, 7.50), (11, 26, 7.00),
-- Bar 12 (Lyon - Croix-Rousse)
(12, 7, 7.50), (12, 12, 8.00), (12, 15, 8.00), (12, 40, 6.50), (12, 5, 6.00), (12, 36, 6.50), (12, 37, 6.50),
-- Bar 13 (Lyon - Confluence - Rooftop/Cher)
(13, 37, 8.00), (13, 36, 8.00), (13, 1, 7.00), (13, 31, 7.50), (13, 17, 8.50), (13, 19, 9.00), (13, 20, 9.00),
-- Bar 14 (Lyon - Confluence)
(14, 3, 7.00), (14, 6, 7.00), (14, 4, 7.00), (14, 29, 7.50), (14, 30, 7.50), (14, 16, 8.00), (14, 8, 8.50),
-- Bar 15 (Bordeaux - Saint-Pierre)
(15, 1, 6.00), (15, 2, 6.00), (15, 27, 6.50), (15, 25, 7.00), (15, 17, 7.50), (15, 12, 8.00), (15, 7, 8.00),
-- Bar 16 (Bordeaux - Saint-Pierre)
(16, 25, 6.50), (16, 26, 6.50), (16, 8, 7.00), (16, 16, 6.50), (16, 29, 6.50), (16, 5, 6.00), (16, 3, 6.00), (16, 38, 6.00),
-- Bar 17 (Bordeaux - Chartrons - Cave à bière)
(17, 7, 7.50), (17, 9, 8.00), (17, 10, 8.50), (17, 11, 9.00), (17, 14, 9.50), (17, 17, 7.50), (17, 19, 8.00), (17, 24, 8.50),
-- Bar 18 (Bordeaux - Chartrons)
(18, 20, 7.50), (18, 21, 7.00), (18, 22, 7.00), (18, 33, 7.00), (18, 35, 7.50), (18, 1, 6.00), (18, 6, 6.50),
-- Bar 19 (Lille - Vieux Lille - Le Nord)
(19, 7, 7.00), (19, 8, 6.50), (19, 12, 7.50), (19, 15, 7.50), (19, 16, 6.50), (19, 27, 6.00), (19, 40, 6.50), (19, 10, 8.00),
-- Bar 20 (Lille - Vieux Lille)
(20, 17, 7.50), (20, 18, 8.00), (20, 19, 8.50), (20, 25, 7.00), (20, 13, 7.50), (20, 31, 6.50), (20, 5, 6.00);