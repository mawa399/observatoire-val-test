-- =========================================================
-- Étape 4.1 : exploration des erreurs dans les données brutes
-- =========================================================

-- Q1. Ventes sans surface (attendu : 3)
SELECT id_vente, surface_m2
FROM source.ventes
WHERE surface_m2 IS NULL;

-- Q2. Ventes sans coordonnées (attendu : 1)
SELECT id_vente, longitude, latitude
FROM source.ventes
WHERE longitude IS NULL OR latitude IS NULL;

-- Q3. Prix aberrants : < 10 000 € ou > 5 000 000 € (attendu : 2)
SELECT id_vente, type_local, surface_m2, prix_eur
FROM source.ventes
WHERE prix_eur < 10000 OR prix_eur > 5000000;

-- Q4. Identifiants en double (attendu : V0201, 2 fois)
SELECT id_vente, count(*) AS nb
FROM source.ventes
GROUP BY id_vente
HAVING count(*) > 1;

-- Q5a. Codes INSEE absents du référentiel (attendu : 35907 et 35999)
SELECT DISTINCT v.code_insee
FROM source.ventes v
LEFT JOIN ref.communes c ON c.insee = v.code_insee
WHERE c.insee IS NULL;

-- Q5b. Diagnostic : code ancien récupérable ou vraie erreur ?
SELECT v.code_insee,
       count(*) AS nb_ventes,
       p.code_nouveau,
       CASE WHEN p.code_ancien IS NOT NULL THEN 'récupérable'
            ELSE 'erreur' END AS diagnostic
FROM source.ventes v
LEFT JOIN ref.communes c    ON c.insee = v.code_insee
LEFT JOIN ref.passage_cog p ON p.code_ancien = v.code_insee
WHERE c.insee IS NULL
GROUP BY v.code_insee, p.code_nouveau, p.code_ancien;

-- Q6. Géométries invalides des zones de projet (attendu : Z04, Self-intersection)
SELECT id_zone, nom, ST_IsValidReason(geom) AS raison
FROM source.zones_projet
WHERE NOT ST_IsValid(geom);