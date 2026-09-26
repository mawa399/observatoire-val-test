-- Étape 4 : contrôles qualité
DROP TABLE IF EXISTS qualite.anomalies;
CREATE TABLE qualite.anomalies (
  id            serial PRIMARY KEY,
  table_source  text NOT NULL,
  id_objet      text,
  controle      text NOT NULL,
  detail        text,
  date_controle timestamptz DEFAULT now()
);

CREATE OR REPLACE FUNCTION qualite.controler_ventes()
RETURNS integer LANGUAGE plpgsql AS $$
DECLARE n integer;
BEGIN
  DELETE FROM qualite.anomalies WHERE table_source = 'source.ventes';

  INSERT INTO qualite.anomalies (table_source, id_objet, controle, detail)
  SELECT 'source.ventes', id_vente, 'surface_manquante', NULL
  FROM source.ventes WHERE surface_m2 IS NULL OR surface_m2 <= 0;

  INSERT INTO qualite.anomalies (table_source, id_objet, controle, detail)
  SELECT 'source.ventes', id_vente, 'coordonnees_manquantes', NULL
  FROM source.ventes WHERE longitude IS NULL OR latitude IS NULL;

  INSERT INTO qualite.anomalies (table_source, id_objet, controle, detail)
  SELECT 'source.ventes', id_vente, 'prix_aberrant', prix_eur::text
  FROM source.ventes WHERE prix_eur < 10000 OR prix_eur > 5000000;

  INSERT INTO qualite.anomalies (table_source, id_objet, controle, detail)
  SELECT 'source.ventes', id_vente, 'doublon', count(*)::text || ' occurrences'
  FROM source.ventes GROUP BY id_vente HAVING count(*) > 1;

  -- code INSEE absent du référentiel ET absent de la table de passage
  INSERT INTO qualite.anomalies (table_source, id_objet, controle, detail)
  SELECT 'source.ventes', v.id_vente, 'code_insee_inconnu', v.code_insee
  FROM source.ventes v
  LEFT JOIN ref.communes c ON c.insee = v.code_insee
  LEFT JOIN ref.passage_cog p ON p.code_ancien = v.code_insee
  WHERE c.insee IS NULL AND p.code_ancien IS NULL;

  -- code INSEE ancien, récupérable via la table de passage
  INSERT INTO qualite.anomalies (table_source, id_objet, controle, detail)
  SELECT 'source.ventes', v.id_vente, 'code_insee_ancien', v.code_insee || ' -> ' || p.code_nouveau
  FROM source.ventes v JOIN ref.passage_cog p ON p.code_ancien = v.code_insee;

  SELECT count(*) INTO n FROM qualite.anomalies WHERE table_source = 'source.ventes';
  RETURN n;
END $$;

-- Géométries invalides des zones de projet
INSERT INTO qualite.anomalies (table_source, id_objet, controle, detail)
SELECT 'source.zones_projet', id_zone, 'geometrie_invalide', ST_IsValidReason(geom)
FROM source.zones_projet WHERE NOT ST_IsValid(geom);

SELECT qualite.controler_ventes();

-- Synthèse
SELECT table_source, controle, count(*) AS nb
FROM qualite.anomalies GROUP BY 1, 2 ORDER BY 1, 2;
