-- Étape 3 : tables d'accueil des CSV (les GeoJSON sont chargés par ogr2ogr)
DROP TABLE IF EXISTS source.ventes;
CREATE TABLE source.ventes (
  id_vente    text,
  date_vente  date,
  code_insee  text,
  type_local  text,
  surface_m2  numeric,
  prix_eur    numeric,
  longitude   numeric,
  latitude    numeric
);

DROP TABLE IF EXISTS source.logements_sociaux;
CREATE TABLE source.logements_sociaux (
  annee                     smallint,
  code_insee                text,
  nb_residences_principales integer,
  nb_logements_sociaux      integer
);

DROP TABLE IF EXISTS ref.passage_cog;
CREATE TABLE ref.passage_cog (
  code_ancien  char(5) PRIMARY KEY,
  nom_ancien   text,
  code_nouveau char(5) NOT NULL,
  date_effet   date
);
