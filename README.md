# Rake Vault

Le « deuxième cerveau » de mes jeux Roblox : tous les modèles, GUI, maquettes Figma, icônes, scripts et systèmes réutilisables, rangés dans un univers 3D navigable.

## Contenu

- `index.html` : le vault 3D (graphe façon Obsidian, visionneuse 3D, lecteur de GUI interactif, exports)
- `lib/` : données du vault (atlas de miniatures, bundles de modèles, GUI, animations, Figma)
- `Assets/` : les fichiers Roblox (.rbxm) des packs ajoutés : `99 Eggs/` (100 œufs), `Nature 480/` (480 assets nature par catégorie) et `_Originaux/` (fichiers d'origine)
- `Notes/` : la version Obsidian, 1 note par élément avec miniature (à ouvrir comme coffre dans Obsidian)
- `three.min.js`, `atlas*.jpg` : rendu 3D et miniatures

## Ouvrir le vault 3D

Le vault charge ses fichiers avec `fetch`, il faut donc un petit serveur local :

```bash
python -m http.server 8000
```

Puis ouvrir http://localhost:8000 dans le navigateur.

## Ouvrir les notes dans Obsidian

Obsidian → « Ouvrir un dossier comme coffre » → choisir le dossier `Notes`.
