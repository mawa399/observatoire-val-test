-- Étape 6 : indicateurs publiés (schéma diffusion)
CREATE INDEX IF NOT EXISTS communes_geom_idx ON ref.communes USING GIST (geom);
ANALYZE ref.communes; ANALYZE travail.ventes;

-- 6.1 Prix médian au m² par commune et par année
DROP MATERIALIZED VIEW IF EXISTS diffusion.indic_prix_commune;
CREATE MATERIALIZED VIEW diffusion.indic_prix_commune AS
SELECT c.insee, c.nom, v.annee,
       count(*)                                                  AS nb_ventes,
       round(percentile_cont(0.5) WITHIN GROUP (ORDER BY v.prix_m2)::numeric) AS prix_m2_median,
       c.geom::geometry(MultiPolygon, 2154)                      AS geom
FROM ref.communes c
JOIN travail.ventes v ON v.code_insee = c.insee
GROUP BY c.insee, c.nom, c.geom, v.annee;
CREATE UNIQUE INDEX ON diffusion.indic_prix_commune (insee, annee);
CREATE INDEX ON diffusion.indic_prix_commune USING GIST (geom);

-- 6.2 Taux de logements sociaux
DROP MATERIALIZED VIEW IF EXISTS diffusion.indic_logement_social;
CREATE MATERIALIZED VIEW diffusion.indic_logement_social AS
SELECT c.insee, c.nom, l.annee, l.nb_residences_principales, l.nb_logements_sociaux,
       round(100.0 * l.nb_logements_sociaux / l.nb_residences_principales, 1) AS taux_ls,
       c.geom::geometry(MultiPolygon, 2154) AS geom
FROM ref.communes c
JOIN travail.logements_sociaux l ON l.code_insee = c.insee;
CREATE UNIQUE INDEX ON diffusion.indic_logement_social (insee, annee);
CREATE INDEX ON diffusion.indic_logement_social USING GIST (geom);

-- 6.3 Ventes (points) et zones de projet publiables
CREATE OR REPLACE VIEW diffusion.ventes AS
SELECT id_vente, date_vente, annee, code_insee, type_local, surface_m2, prix_eur, prix_m2, geom
FROM travail.ventes;

DROP MATERIALIZED VIEW IF EXISTS diffusion.zones_projet;
CREATE MATERIALIZED VIEW diffusion.zones_projet AS
SELECT z.id_zone, z.nom, z.type_zone, z.nb_logements_prevus,
       string_agg(DISTINCT c.nom, ', ' ORDER BY c.nom) AS communes_concernees,
       (SELECT count(*) FROM travail.ventes v WHERE ST_DWithin(v.geom, z.geom, 500)) AS nb_ventes_500m,
       z.geom
FROM travail.zones_projet z
JOIN ref.communes c ON ST_Intersects(c.geom, z.geom)
GROUP BY z.id_zone, z.nom, z.type_zone, z.nb_logements_prevus, z.geom;
CREATE UNIQUE INDEX ON diffusion.zones_projet (id_zone);

GRANT SELECT ON ALL TABLES IN SCHEMA diffusion TO geoserver_ro;

-- 6.4 Vérifier l'usage de l'index
EXPLAIN ANALYZE
SELECT c.nom, count(*) FROM ref.communes c
JOIN travail.ventes v ON ST_Intersects(c.geom, v.geom)
GROUP BY c.nom;
