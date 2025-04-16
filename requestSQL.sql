/*
# afficher toute la table 
SELECT * FROM fr_carburant.prix_carburant_fr

# Afficher qlq colonnes
SELECT adresse, prix_sp95, ville, latitude, longitude, code_departement 
FROM fr_carburant.prix_carburant_fr 

# Trouver le prix MIN/MAX du SP95
SELECT MIN(prix_sp95) AS min_prix_sp95,
MAX(prix_sp95) AS max_prix_sp95
from fr_carburant.prix_carburant_fr

# Renommer les colonnes 
AlTER TABLE fr_carburant.prix_carburant_fr
RENAME  

# afficher les stations essence du dep 83 
SELECT adresse, prix_sp95, ville, latitude, longitude, code_departement 
FROM fr_carburant.prix_carburant_fr
WHERE code_departement='83'

# compter les stations essence du dep 83 
SELECT COUNT(id) As num_station_sp95
FROM fr_carburant.prix_carburant_fr
WHERE code_departement='83'

# les stations du dep 83 qui ont du sp95
SELECT adresse, prix_sp95, ville, latitude, longitude, code_departement 
FROM fr_carburant.prix_carburant_fr
WHERE code_departement='83' AND prix_sp95 IS NOT NULL

# la stations du dep 83 la moins cher pour sp95
SELECT adresse, prix_sp95, ville, latitude, longitude, code_departement 
FROM fr_carburant.prix_carburant_fr
WHERE code_departement='83' AND prix_sp95 IS NOT NULL
ORDER BY prix_sp95 ASC
LIMIT 1
*/

# lat et lon de mon adresse lat=x, lon=y normalement if faut remplacer x et y par les valeurs numérique exact, vous pouvez utiliser votre coordonnées sinon vous pouvez voir les résultats sur le dashboard :) 
WITH lat_long_geopoint AS (
  SELECT   
    adresse, 
    ville ,
    prix_sp95,
    code_postal,
    ST_GEOGPOINT(x,y) AS adressegeo_reference,
    ST_GEOGPOINT(longitude, latitude) AS adressegeo_station
  FROM fr_carburant.prix_carburant_fr
  WHERE prix_sp95 IS NOT NULL
    AND code_departement= '13' 
)
SELECT 
  CONCAT(adresse, ' ', code_postal, ' ', ville) AS adresse_complete,
  ville,
  ROUND(prix_sp95 , 2) AS prix_sp95,
  ROUND(ST_DISTANCE(adressegeo_reference, adressegeo_station)/1000,2) AS distance_en_km
FROM lat_long_geopoint
ORDER BY distance_en_km ASC 
