# Kit d'entraînement – Observatoire du Val Test

Jeu de données **fictif** pour s'entraîner à la chaîne PostGIS → GeoServer → Git.
Le territoire (6 communes, EPCI « CC du Val Test ») est inventé et placé arbitrairement en Lambert 93.

## Contenu

| Fichier | Contenu |
| --- | --- |
| `data/communes.geojson` | 6 communes, polygones, EPSG:2154, COG 2026 |
| `data/zones_projet.geojson` | 5 zones de projet, EPSG:2154 (dont 1 géométrie invalide) |
| `data/ventes.csv` | 341 ventes 2022-2025, coordonnées en WGS84 (erreurs volontaires) |
| `data/logements_sociaux.csv` | Logements sociaux par commune et par année |
| `data/passage_cog.csv` | Fusion de Saint-Ancien (35907) dans Val-Postgis (35905) au 01/01/2025 |
| `cahier_recette.csv` | Cahier de recette à remplir |
| `sql/` | **Tes** scripts |
| `solutions/` | Corrigés : SQL, styles SLD, script Python API REST |
| `docker-compose.yml` | Option Docker, **non utilisée** : à ignorer |

Séparateur des CSV : point-virgule. Encodage : UTF-8.

## Environnement utilisé (sans Docker)

| Outil | Usage |
| --- | --- |
| PostgreSQL + PostGIS | Base `observatoire`, utilisateur `postgres` |
| pgAdmin (Query Tool) | Écrire et exécuter le SQL |
| SQL Shell (psql) | Charger les CSV avec `\copy` |
| QGIS + OSGeo4W Shell | Visualiser ; `ogr2ogr` pour les GeoJSON |
| GeoServer (Windows) | http://localhost:8080/geoserver |
| Git + GitHub | Une branche et une Pull Request par étape |

## Ordre des scripts

1. `01_schemas_roles.sql` et `02_tables_source.sql` : pgAdmin (Query Tool, F5)
2. `03a_chargement_geojson.bat` : OSGeo4W Shell, après `set PGPASSWORD=...`
3. `03b_chargement_csv.sql` : psql, avec `\i 'chemin/du/fichier.sql'`
4. `04` à `06` : pgAdmin
5. `publier_geoserver.py` : PowerShell, avec `$env:GS_USER` et `$env:GS_PASSWORD`

Aucun mot de passe ne doit être écrit dans un fichier du dépôt.

Fais les exercices du tuto avant d'ouvrir `solutions/`.
