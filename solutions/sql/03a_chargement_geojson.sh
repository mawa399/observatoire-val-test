#!/usr/bin/env bash
# Étape 3a : GeoJSON -> PostGIS avec ogr2ogr
# Depuis Docker : docker compose run --rm gdal bash solutions/sql/03a_chargement_geojson.sh
set -e
PG="PG:host=${PGHOST:-localhost} port=5432 dbname=observatoire user=admin password=admin"

ogr2ogr -f PostgreSQL "$PG" data/communes.geojson -nln ref.communes \
  -t_srs EPSG:2154 -nlt PROMOTE_TO_MULTI -lco GEOMETRY_NAME=geom -lco FID=gid -overwrite

ogr2ogr -f PostgreSQL "$PG" data/zones_projet.geojson -nln source.zones_projet \
  -t_srs EPSG:2154 -nlt PROMOTE_TO_MULTI -lco GEOMETRY_NAME=geom -lco FID=gid -overwrite

echo "Chargement GeoJSON terminé"
