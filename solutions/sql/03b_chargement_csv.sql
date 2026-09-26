-- Étape 3b : CSV -> tables créées à l'étape 2
-- Depuis Docker : docker compose exec -w /kit postgis psql -U admin -d observatoire -f solutions/sql/03b_chargement_csv.sql
-- NULL '' : une cellule vide devient NULL
\copy source.ventes FROM 'data/ventes.csv' WITH (FORMAT csv, HEADER, DELIMITER ';', NULL '')
\copy source.logements_sociaux FROM 'data/logements_sociaux.csv' WITH (FORMAT csv, HEADER, DELIMITER ';')
\copy ref.passage_cog FROM 'data/passage_cog.csv' WITH (FORMAT csv, HEADER, DELIMITER ';')

SELECT 'ref.communes' AS table_, count(*) FROM ref.communes
UNION ALL SELECT 'source.zones_projet', count(*) FROM source.zones_projet
UNION ALL SELECT 'source.ventes', count(*) FROM source.ventes
UNION ALL SELECT 'source.logements_sociaux', count(*) FROM source.logements_sociaux
UNION ALL SELECT 'ref.passage_cog', count(*) FROM ref.passage_cog;
