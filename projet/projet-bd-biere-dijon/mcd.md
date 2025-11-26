erDiagram
    DISTRICT ||--|{ bar : "located in"

   bar ||--|{ PRICE : "sets"

    BEER ||--|{ PRICE : "costs"

    DISTRICT {
        int location_id PK
        varchar city
        varchar address
    }

    bar {
        int bar_id PK
        int location_id FK
        varchar nom
    }

    BEER {
        int beer_id PK
        varchar name
        varchar brand
        decimal degree
    }

    PRICE {
        int bar_id PK, FK
        int beer_id PK, FK
        decimal price
    }
﻿

 
 
 
 