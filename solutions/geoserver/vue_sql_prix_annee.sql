-- Étape 7.4 : requête de la vue SQL paramétrée à coller dans GeoServer
-- (Couches > Ajouter > vt:observatoire > Configurer une nouvelle vue SQL)
-- Paramètre : annee, valeur par défaut 2025, expression de validation ^\d{4}$
SELECT insee, nom, annee, nb_ventes, prix_m2_median, geom
FROM diffusion.indic_prix_commune
WHERE annee = %annee%
