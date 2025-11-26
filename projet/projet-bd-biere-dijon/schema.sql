--creation de la table des quartier
CREATE TABLE DISTRICT (
    location_id INT PRIMARY KEY,
    city VARCHAR(100),
    address VARCHAR(255)
);

--creation de la tables des bieres
CREATE TABLE BEER (
    beer_id INT PRIMARY KEY,
    name VARCHAR(100),
    brand VARCHAR(100),
    degree DECIMAL(4, 2) 
)

--creation de la teble des bars
--lier a la table des quartier
CREATE TABLE bar (
    bar_id INT PRIMARY KEY,
    location_id INT,
    nom VARCHAR(100),
    CONSTRAINT fk_bar_district
        FOREIGN KEY (location_id) 
        REFERENCES DISTRICT(location_id)
);

--creation de la table de prix
--lier a la table des bars et des biere
CREATE TABLE PRICE (
    bar_id INT,
    beer_id INT,
    price DECIMAL(10, 2),
    
    -- Composite Primary Key: The combination of bar and beer must be unique
    PRIMARY KEY (bar_id, beer_id),
    
    -- Foreign Key to bar
    CONSTRAINT fk_price_bar
        FOREIGN KEY (bar_id) 
        REFERENCES bar(bar_id),
        
    -- Foreign Key to BEER
    CONSTRAINT fk_price_beer
        FOREIGN KEY (beer_id) 
        REFERENCES BEER(beer_id)
);