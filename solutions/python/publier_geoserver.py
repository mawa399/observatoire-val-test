"""
Étape 8 : publier automatiquement les couches du Val Test via l'API REST de GeoServer.

Usage :
    pip install requests
    python solutions/python/publier_geoserver.py

Le script est rejouable : ce qui existe déjà est ignoré.
"""
import os
from pathlib import Path

import requests

GS = os.getenv("GS_URL", "http://localhost:8080/geoserver")
AUTH = (os.getenv("GS_USER", "admin"), os.getenv("GS_PASSWORD", "geoserver"))
WS = "vt"
STORE = "observatoire"
STYLES_DIR = Path(__file__).resolve().parent.parent / "geoserver"

# couche (nom de la table/vue dans le schéma diffusion) -> (titre, style)
COUCHES = {
    "indic_prix_commune": ("Prix médian au m² par commune", "prix_m2_classes"),
    "indic_logement_social": ("Taux de logements sociaux", "taux_logement_social"),
    "ventes": ("Ventes immobilières", "ventes_type_local"),
    "zones_projet": ("Zones de projet", "zones_projet"),
}

JSON = {"Content-Type": "application/json"}
s = requests.Session()
s.auth = AUTH


def existe(url: str) -> bool:
    return s.get(url, headers={"Accept": "application/json"}).status_code == 200


def creer_workspace():
    if existe(f"{GS}/rest/workspaces/{WS}"):
        print(f"Workspace {WS} : déjà présent")
        return
    s.post(f"{GS}/rest/workspaces", json={"workspace": {"name": WS}}, headers=JSON).raise_for_status()
    print(f"Workspace {WS} : créé")


def creer_store():
    if existe(f"{GS}/rest/workspaces/{WS}/datastores/{STORE}"):
        print(f"Store {STORE} : déjà présent")
        return
    params = {
        "host": "postgis",            # nom du service Docker, pas localhost
        "port": "5432",
        "database": "observatoire",
        "schema": "diffusion",
        "user": "geoserver_ro",
        "passwd": "geoserver_ro",
        "dbtype": "postgis",
        "Expose primary keys": "true",
    }
    corps = {"dataStore": {
        "name": STORE,
        "connectionParameters": {"entry": [{"@key": k, "$": v} for k, v in params.items()]},
    }}
    s.post(f"{GS}/rest/workspaces/{WS}/datastores", json=corps, headers=JSON).raise_for_status()
    print(f"Store {STORE} : créé")


def creer_style(nom: str):
    if existe(f"{GS}/rest/workspaces/{WS}/styles/{nom}"):
        print(f"Style {nom} : déjà présent")
        return
    sld = (STYLES_DIR / f"{nom}.sld").read_bytes()
    s.post(f"{GS}/rest/workspaces/{WS}/styles", params={"name": nom}, data=sld,
           headers={"Content-Type": "application/vnd.ogc.sld+xml"}).raise_for_status()
    print(f"Style {nom} : créé")


def publier_couche(nom: str, titre: str, style: str):
    url_ft = f"{GS}/rest/workspaces/{WS}/datastores/{STORE}/featuretypes"
    if not existe(f"{url_ft}/{nom}"):
        corps = {"featureType": {"name": nom, "nativeName": nom, "title": titre, "srs": "EPSG:2154"}}
        s.post(url_ft, json=corps, headers=JSON).raise_for_status()
        print(f"Couche {WS}:{nom} : publiée")
    else:
        print(f"Couche {WS}:{nom} : déjà publiée")
    corps = {"layer": {"defaultStyle": {"name": style, "workspace": WS}}}
    s.put(f"{GS}/rest/layers/{WS}:{nom}", json=corps, headers=JSON).raise_for_status()
    print(f"   style par défaut : {style}")


def purger_cache(nom: str):
    xml = f"<truncateLayer><layerName>{WS}:{nom}</layerName></truncateLayer>"
    r = s.post(f"{GS}/gwc/rest/masstruncate", data=xml, headers={"Content-Type": "text/xml"})
    print(f"   cache purgé ({r.status_code})")


if __name__ == "__main__":
    creer_workspace()
    creer_store()
    for nom, (titre, style) in COUCHES.items():
        creer_style(style)
        publier_couche(nom, titre, style)
        purger_cache(nom)
    print(f"\nTerminé. Aperçu : {GS}/web/wicket/bookmarkable/org.geoserver.web.demo.MapPreviewPage")
