1.
SELECT 
    d.address AS Quartier,
    ROUND(AVG(p.price), 2) AS Prix_Moyen
FROM 
    DISTRICT d
JOIN 
    bar b ON d.location_id = b.location_id
JOIN 
    PRICE p ON b.bar_id = p.bar_id
GROUP BY 
     d.address
ORDER BY 
    Prix_Moyen DESC;

2.
   SELECT 
    b.nom AS Bar,
    be.name AS Biere,
    be.degree AS Degre,
    p.price AS Prix
FROM 
    PRICE p
JOIN 
    BEER be ON p.beer_id = be.beer_id
JOIN 
    bar b ON p.bar_id = b.bar_id
WHERE 
    be.degree BETWEEN 5.0 AND 8.0 
ORDER BY 
    p.price ASC,
    be.degree DESC ;

ps je ne sais pas ce que IPA veut dire mais google me dit que ce sont des biere entre 5 et 8 degree

3. SELECT 
    be.name AS Biere,
    COUNT(p.bar_id) AS Nombre_de_Bars
FROM 
    BEER be
JOIN 
    PRICE p ON be.beer_id = p.beer_id
GROUP BY 
    be.beer_id
HAVING 
    COUNT(p.bar_id) >= 5
ORDER BY 
    Nombre_de_Bars DESC;

4.
SELECT 
    b.nom AS Bar,
    MIN(p.price) AS Prix_Le_Plus_Bas
FROM 
    bar b
JOIN 
    PRICE p ON b.bar_id = p.bar_id
GROUP BY 
    b.bar_id, b.nom
HAVING 
    MIN(p.price) >= 6.00
ORDER BY 
    Prix_Le_Plus_Bas DESC;