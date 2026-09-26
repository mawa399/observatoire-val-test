-- Étape 2 : extension, schémas et rôles
CREATE EXTENSION IF NOT EXISTS postgis;

CREATE SCHEMA IF NOT EXISTS ref;        -- référentiels (communes, table de passage)
CREATE SCHEMA IF NOT EXISTS source;     -- données brutes, jamais modifiées
CREATE SCHEMA IF NOT EXISTS travail;    -- données nettoyées
CREATE SCHEMA IF NOT EXISTS diffusion;  -- ce qui est publié dans GeoServer
CREATE SCHEMA IF NOT EXISTS qualite;    -- anomalies

-- Rôle lecture seule utilisé par GeoServer
DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'geoserver_ro') THEN
    CREATE ROLE geoserver_ro LOGIN PASSWORD 'geoserver_ro';
  END IF;
END $$;
GRANT CONNECT ON DATABASE observatoire TO geoserver_ro;
GRANT USAGE ON SCHEMA diffusion TO geoserver_ro;
GRANT SELECT ON ALL TABLES IN SCHEMA diffusion TO geoserver_ro;
ALTER DEFAULT PRIVILEGES IN SCHEMA diffusion GRANT SELECT ON TABLES TO geoserver_ro;
