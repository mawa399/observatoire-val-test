-- Étape 5 : données nettoyées dans le schéma travail
DROP TABLE IF EXISTS travail.ventes CASCADE;
CREATE TABLE travail.ventes AS
SELECT DISTINCT ON (v.id_vente)
  v.id_vente,
  v.date_vente,
  extract(year FROM v.date_vente)::smallint AS annee,
  COALESCE(p.code_nouveau, v.code_insee)     AS code_insee,   -- ramené au COG 2026
  v.code_insee                               AS code_insee_origine,
  v.type_local,
  v.surface_m2,
  v.prix_eur,
  round(v.prix_eur / v.surface_m2)           AS prix_m2,
  ST_Transform(ST_SetSRID(ST_MakePoint(v.longitude, v.latitude), 4326), 2154)::geometry(Point, 2154) AS geom
FROM source.ventes v
LEFT JOIN ref.passage_cog p ON p.code_ancien = v.code_insee
WHERE v.surface_m2 > 0
  AND v.longitude IS NOT NULL AND v.latitude IS NOT NULL
  AND v.prix_eur BETWEEN 10000 AND 5000000
ORDER BY v.id_vente;

ALTER TABLE travail.ventes ADD PRIMARY KEY (id_vente);
CREATE INDEX ON travail.ventes USING GIST (geom);
CREATE INDEX ON travail.ventes (code_insee, annee);

-- Contrôle de cohérence : le code INSEE déclaré correspond-il à la commune où tombe le point ?
SELECT v.id_vente, v.code_insee AS code_declare, c.insee AS code_spatial
FROM travail.ventes v
JOIN ref.communes c ON ST_Intersects(c.geom, v.geom)
WHERE c.insee <> v.code_insee;

-- Règle de gestion : en cas d'écart, la localisation fait foi
UPDATE travail.ventes v SET code_insee = c.insee
FROM ref.communes c
WHERE ST_Intersects(c.geom, v.geom) AND c.insee <> v.code_insee;

-- Zones de projet réparées
DROP TABLE IF EXISTS travail.zones_projet;
CREATE TABLE travail.zones_projet AS
SELECT id_zone, nom, type_zone, nb_logements_prevus,
       ST_Multi(ST_CollectionExtract(ST_MakeValid(geom), 3))::geometry(MultiPolygon, 2154) AS geom
FROM source.zones_projet;
ALTER TABLE travail.zones_projet ADD PRIMARY KEY (id_zone);
CREATE INDEX ON travail.zones_projet USING GIST (geom);

-- Logements sociaux ramenés au COG 2026 (on additionne l'ancienne commune)
DROP TABLE IF EXISTS travail.logements_sociaux;
CREATE TABLE travail.logements_sociaux AS
SELECT l.annee,
       COALESCE(p.code_nouveau, l.code_insee) AS code_insee,
       sum(l.nb_residences_principales)       AS nb_residences_principales,
       sum(l.nb_logements_sociaux)            AS nb_logements_sociaux
FROM source.logements_sociaux l
LEFT JOIN ref.passage_cog p ON p.code_ancien = l.code_insee
GROUP BY 1, 2;
ALTER TABLE travail.logements_sociaux ADD PRIMARY KEY (annee, code_insee);
