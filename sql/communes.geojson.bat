@echo off
REM Étape 3a : chargement des GeoJSON dans PostGIS avec ogr2ogr
REM À lancer dans l'OSGeo4W Shell, depuis le dossier kit-val-test,
REM après avoir défini le mot de passe : set PGPASSWORD=...

ogr2ogr -f PostgreSQL "PG:host=localhost port=5432 dbname=observatoire user=postgres" data\communes.geojson -nln ref.communes -t_srs EPSG:2154 -nlt PROMOTE_TO_MULTI -lco GEOMETRY_NAME=geom -lco FID=gid -overwrite

ogr2ogr -f PostgreSQL "PG:host=localhost port=5432 dbname=observatoire user=postgres" data\zones_projet.geojson -nln source.zones_projet -t_srs EPSG:2154 -nlt PROMOTE_TO_MULTI -lco GEOMETRY_NAME=geom -lco FID=gid -overwrite

echo Chargement GeoJSON termine