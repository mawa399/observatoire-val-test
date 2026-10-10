-- =========================================================
-- Étape 5.1 : ventes nettoyées, géolocalisées, au COG 2026
-- =========================================================
DROP TABLE IF EXISTS travail.ventes CASCADE;                      -- ① CASCADE

CREATE TABLE travail.ventes AS
SELECT DISTINCT ON (v.id_vente)                                   -- ② DISTINCT ON
  v.id_vente,
  v.date_vente,
  extract(year FROM v.date_vente)::smallint AS annee,             -- ③ year
  COALESCE(p.code_nouveau, v.code_insee)     AS code_insee,       -- ④ COALESCE
  v.code_insee                               AS code_insee_origine, -- ⑤ code_insee_origine
  v.type_local,
  v.surface_m2,
  v.prix_eur,
  round(v.prix_eur / v.surface_m2)           AS prix_m2,          -- ⑥ /
  ST_Transform(
    ST_SetSRID(ST_MakePoint(v.longitude, v.latitude), 4326),      -- ⑦ longitude ⑧ latitude ⑨ 4326
    2154                                                          -- ⑩ 2154
  )::geometry(Point, 2154)                   AS geom
FROM source.ventes v
LEFT JOIN ref.passage_cog p ON p.code_ancien = v.code_insee       -- ⑪ code_ancien
WHERE v.surface_m2 > 0                                            -- ⑫ 0
  AND v.longitude IS NOT NULL
  AND v.latitude IS NOT NULL                                      -- ⑬ IS NOT NULL
  AND v.prix_eur BETWEEN 10000 AND 5000000                        -- ⑭ 10000 ⑮ 5000000
ORDER BY v.id_vente;                                              -- ⑯ id_vente

-- Clé primaire et index
ALTER TABLE travail.ventes ADD PRIMARY KEY (id_vente);            -- ⑰ PRIMARY KEY
CREATE INDEX ON travail.ventes USING GIST (geom);                 -- ⑱ GIST
CREATE INDEX ON travail.ventes (code_insee, annee);


-- 5.2 a. Ventes dont le code déclaré ne correspond pas à la commune où tombe le point
SELECT v.id_vente,
       v.code_insee AS code_declare,
       c.insee      AS code_spatial
FROM travail.ventes v
JOIN ref.communes c ON ST_Intersects(c.geom, v.geom)   -- ① ST_Intersects
WHERE c.insee <> v.code_insee;                         -- ② <>


-- 5.2 b. Règle de gestion : la localisation fait foi
UPDATE travail.ventes v
SET code_insee = c.insee
FROM ref.communes c
WHERE ST_Intersects(c.geom, v.geom)
  AND c.insee <> v.code_insee;