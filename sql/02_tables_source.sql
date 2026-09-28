-- Table des ventes (données brutes)
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

-- Table des logements sociaux (données brutes)
DROP TABLE IF EXISTS source.logements_sociaux;
CREATE TABLE source.logements_sociaux (
  annee                     smallint,
  code_insee                text,
  nb_residences_principales integer,
  nb_logements_sociaux      integer
);

-- Table de passage COG (référentiel)
DROP TABLE IF EXISTS ref.passage_cog;
CREATE TABLE ref.passage_cog (
  code_ancien  char(5) PRIMARY KEY,
  nom_ancien   text,
  code_nouveau char(5) NOT NULL,
  date_effet   date
);