-- Étape 3b : CSV -> tables créées à l'étape 2
-- À exécuter dans SQL Shell (psql), connecté à la base observatoire :
--   \i 'C:/Users/User/Desktop/Formation_Data_Engineer_SIG_ALS/kit-val-test/solutions/sql/03b_chargement_csv.sql'
-- \copy est une commande psql : elle ne fonctionne pas dans le Query Tool de pgAdmin.
-- TRUNCATE vide les tables d'abord : le script est rejouable (\copy ajoute à la suite).
TRUNCATE source.ventes, source.logements_sociaux, ref.passage_cog;
\copy source.ventes FROM 'C:/Users/User/Desktop/Formation_Data_Engineer_SIG_ALS/kit-val-test/data/ventes.csv' WITH (FORMAT csv, HEADER, DELIMITER ';', NULL '', ENCODING 'UTF8')
\copy source.logements_sociaux FROM 'C:/Users/User/Desktop/Formation_Data_Engineer_SIG_ALS/kit-val-test/data/logements_sociaux.csv' WITH (FORMAT csv, HEADER, DELIMITER ';', NULL '', ENCODING 'UTF8')
\copy ref.passage_cog FROM 'C:/Users/User/Desktop/Formation_Data_Engineer_SIG_ALS/kit-val-test/data/passage_cog.csv' WITH (FORMAT csv, HEADER, DELIMITER ';', NULL '', ENCODING 'UTF8')

SELECT 'ref.communes' AS table_, count(*) FROM ref.communes
UNION ALL SELECT 'source.zones_projet', count(*) FROM source.zones_projet
UNION ALL SELECT 'source.ventes', count(*) FROM source.ventes
UNION ALL SELECT 'source.logements_sociaux', count(*) FROM source.logements_sociaux
UNION ALL SELECT 'ref.passage_cog', count(*) FROM ref.passage_cog;
