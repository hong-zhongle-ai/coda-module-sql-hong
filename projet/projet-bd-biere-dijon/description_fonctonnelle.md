Projet de Base de Données : Analyse des Prix des Bières

1. Objectif du Projet

Ce projet a pour but de constituer une base de données structurée recensant les prix des bières vendues dans différents bars, eux-mêmes situés dans divers quartiers.

2. Structure des Données

Le système repose sur 4 tables principales et leurs paramètres respectifs :

Les Bars : Contient le nom et l'identification de l'établissement.

Les Bières : Catalogue des produits (Nom, Degré d'alcool, Catégorie/Marque).

Les Quartiers : Indique la localisation géographique des bars.

Les Prix : La donnée tarifaire, qui dépend spécifiquement de chaque bar.

3.Relations entre les Entités

La logique relationnelle est la suivante :

Le Prix est lié à la fois à une Bière et à un Bar (un même produit peut avoir un prix différent selon le lieu).

Le Bar est directement rattaché à un Quartier.

4.Objectifs Futurs

L'utilisation de ce SQL vise à permettre :

Une meilleure analyse du marché (comparaison des coûts par zone géographique).

Une optimisation des sorties (définir ses soirées en fonction du budget et de la localisation).