-- 1. Activation de PostGIS
create extension if not exists PostGIS;

-- 2. Création des 5 schémas ref, source, travail, diffusion, qualite
create schema if not exists ref;
create schema if not exists source;
create schema if not exists travail;
create schema if not exists diffusion;
create schema if not exists qualite;

-- 3.  Création du rôle geoserver_ro en lecture seule pour Geoserver
create role geoserver_ro with login password 'geoserver_ro';


-- 4. les droits : base, schema, puis tables
grant connect on database observatoire to geoserver_ro;
grant usage on schema diffusion to geoserver_ro;
grant select on all tables in schema diffusion to geoserver_ro;
alter default privileges in schema diffusion grant select on tables to geoserver_ro;

