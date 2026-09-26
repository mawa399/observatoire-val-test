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
| `docker-compose.yml` | PostGIS 16 + GeoServer 2.28.2 (+ GDAL) |
| `cahier_recette.csv` | Cahier de recette à remplir |
| `solutions/` | Corrigés : SQL, styles SLD, script Python API REST |

Séparateur des CSV : point-virgule. Encodage : UTF-8.

## Démarrage rapide

```bash
docker compose up -d
# PostGIS : localhost:5432, base observatoire, admin/admin
# GeoServer : http://localhost:8080/geoserver, admin/geoserver
```

Fais les exercices du tuto avant d'ouvrir `solutions/`.
