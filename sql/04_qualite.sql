-- =========================================================
-- Étape 4.2 : table des anomalies et contrôle automatique
-- =========================================================

-- 1. La table qui enregistre chaque anomalie détectée
DROP TABLE IF EXISTS qualite.anomalies;
CREATE TABLE qualite.anomalies (
  id            serial PRIMARY KEY,         -- numéro automatique
  table_source  text NOT NULL,              -- table contrôlée
  id_objet      text,                       -- identifiant de la ligne en erreur
  controle      text NOT NULL,              -- type de contrôle
  detail        text,                       -- précision (valeur, raison…)
  date_controle timestamptz DEFAULT now()   -- date et heure du contrôle
);

-- 2. La fonction qui refait tous les contrôles sur les ventes
CREATE OR REPLACE FUNCTION qualite.controler_ventes()
RETURNS integer
LANGUAGE plpgsql
AS $$
DECLARE
  n integer;
BEGIN
  -- On efface les anomalies du contrôle précédent (rejouable)
  DELETE FROM qualite.anomalies WHERE table_source = 'source.ventes';

  -- Surface manquante ou nulle
  INSERT INTO qualite.anomalies (table_source, id_objet, controle, detail)
  SELECT 'source.ventes', id_vente, 'surface_manquante', NULL
  FROM source.ventes
  WHERE surface_m2 IS NULL OR surface_m2 <= 0;

  -- Coordonnées manquantes
  INSERT INTO qualite.anomalies (table_source, id_objet, controle, detail)
  SELECT 'source.ventes', id_vente, 'coordonnees_manquantes', NULL
  FROM source.ventes
  WHERE longitude IS NULL OR latitude IS NULL;

  -- Prix aberrant
  INSERT INTO qualite.anomalies (table_source, id_objet, controle, detail)
  SELECT 'source.ventes', id_vente, 'prix_aberrant', prix_eur::text
  FROM source.ventes
  WHERE prix_eur < 10000 OR prix_eur > 5000000;

  -- Doublon d'identifiant
  INSERT INTO qualite.anomalies (table_source, id_objet, controle, detail)
  SELECT 'source.ventes', id_vente, 'doublon', count(*)::text || ' occurrences'
  FROM source.ventes
  GROUP BY id_vente
  HAVING count(*) > 1;

  -- Code INSEE inconnu : ni dans le référentiel, ni dans la table de passage
  INSERT INTO qualite.anomalies (table_source, id_objet, controle, detail)
  SELECT 'source.ventes', v.id_vente, 'code_insee_inconnu', v.code_insee
  FROM source.ventes v
  LEFT JOIN ref.communes c    ON c.insee = v.code_insee
  LEFT JOIN ref.passage_cog p ON p.code_ancien = v.code_insee
  WHERE c.insee IS NULL AND p.code_ancien IS NULL;

  -- Code INSEE ancien : récupérable grâce à la table de passage
  INSERT INTO qualite.anomalies (table_source, id_objet, controle, detail)
  SELECT 'source.ventes', v.id_vente, 'code_insee_ancien',
         v.code_insee || ' -> ' || p.code_nouveau
  FROM source.ventes v
  JOIN ref.passage_cog p ON p.code_ancien = v.code_insee;

  -- On compte ce qu'on a trouvé et on le renvoie
  SELECT count(*) INTO n
  FROM qualite.anomalies
  WHERE table_source = 'source.ventes';

  RETURN n;
END;
$$;

-- 3. Contrôle des géométries des zones de projet
DELETE FROM qualite.anomalies WHERE table_source = 'source.zones_projet';
INSERT INTO qualite.anomalies (table_source, id_objet, controle, detail)
SELECT 'source.zones_projet', id_zone, 'geometrie_invalide', ST_IsValidReason(geom)
FROM source.zones_projet
WHERE NOT ST_IsValid(geom);

-- 4. Lancer le contrôle des ventes (attendu : 38)
SELECT qualite.controler_ventes();

-- 5. Synthèse : nombre d'anomalies par table et par type de contrôle
SELECT table_source, controle, count(*) AS nb
FROM qualite.anomalies
GROUP BY table_source, controle
ORDER BY table_source, controle;