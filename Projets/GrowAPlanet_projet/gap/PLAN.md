# GROW A PLANET — PLAN

> Notes de projet. À relire au début de chaque conversation.
> Une copie sera mise dans Studio : `ServerStorage/PLAN` (ModuleScript, commentaire seulement).

## État actuel (12/10/2026)
- Studio connecté via MCP (Vinegar, Linux). Tout le code est INSTALLÉ dans `game.rbxl` et TESTÉ en Play :
  spawn galaxie → achat → enclos → éclosion (+ mutation) → équipement auto → orbite → argent/s. OK.
- 12/10 : Hugo a testé → « vraiment pas mal ». Demande : TOUS les modèles refaits en style BLOCS avec studs,
  beaucoup plus détaillés (pas de 3D lisse). GUI : garder, petites améliorations possibles.
  → FAIT : `Models.lua` v2 (planètes = sphères de briques à studs, 30 styles : roche, désert, terre, jungle,
    gaz à bandes, glace, lave, cristal, vide, ruche, bonbon, étoile, œil, œuf, glitch ; anneaux en briques,
    lunes, visage mignon en blocs ; galaxies = cœur en briques néon + bras en cubes + étoiles + anneau doré)
    et `MapBuilder.lua` v2 (hub en dalles damier + piédestal à marches + planète géante, stands façon marché
    avec auvent rayé, chemin en dalles + lampadaires, bases avec murs en briques décalées, arche, pont,
    spawners à studs, incubateur à arceaux, soleil en blocs, plantes, cristaux, astéroïdes en blocs, satellites).
  → ~4 500 parts pour la map, ≤ 58 parts par planète, ≤ 69 par galaxie.
- Sauvegarde : DataStore indisponible tant que le jeu n'est pas publié + « Studio Access to API Services » activé.

- 12/10 (suite) : corrections faites et vérifiées dans Studio :
  - sols qui se chevauchaient (hub, chemin, ponts, socles, couches des planètes) → plus aucun chevauchement visible
    (vérificateur automatique de dessus coplanaires) ;
  - boutons cachés sous leur fond (Upgrades Buy, Hatch/Skip, Shop Buy… 55 boutons) → ZIndex 4 dans barButton ;
  - icônes Galaxies / Planets dessinées (Figma + rendu SVG), uploadées sur le compte c_K4lash :
    images 102775835546583 / 110187389445730 (Config/UIAssets). Les cases 3D ne s'affichaient pas sous Linux.
  - Studio a planté une fois sans sauvegarde → TOUJOURS Ctrl+S après une série de changements.

## À faire ensuite
1. Hugo regarde les nouveaux modèles en Play et dit ce qu'il veut changer.
2. Petites améliorations GUI (validées « pas mal » telles quelles).
3. Publier le jeu (Fichier > Publier sur Roblox) → activer l'accès API → tester la sauvegarde.
4. Uploader les autres icônes de deliver/ si on veut les utiliser (les 2 du HUD droit sont faites).
5. Test 2 joueurs (bases, prompts réservés au propriétaire, orbites). Players max = 8 (réglage du jeu publié).
6. Phase 8 : perf (beaucoup de modèles qui tournent côté client), équilibrage, audit.

## Kit GUI K4LSH (ce qu'il contient)
- Tout est en IMAGES (PNG déjà mis en ligne sur Roblox) : fonds de panneaux, barres de titre,
  boutons, icônes. Le texte est par-dessus (police Gotham SSm, ExtraBold 800, UIStroke noir).
- Boutons : une ImageButton transparente par-dessus l'image + un LocalScript
  (survol = grossit à 1.05, clic = 0.97, son de survol 408524543, son de clic 6042053626).
- Images utilisées :
  - Case de bouton HUD : 127062449162498 (VIP doré : 73646313229415)
  - Icônes HUD : Index 134306875683469, Shop 110119422421461, Rebirth 102040339566414,
    Quest 102082573689395, Rewards 112101874744840, VIP 94666332436790
  - Boutons du bas : Base 118147684330981, Sell 139238474736040, Shop 105496683105089
  - Panneau : fond 75109179445868, barre de titre 112249404449276, croix 77317040960880,
    carte 110428657945327, bouton argent 72484859487238, bouton Robux 130202638558172,
    icône Robux 97272186997275, flèche 120180286105410
- Défauts à corriger en le réutilisant :
  - Les zones cliquables ont une taille fixe en pixels (67×68, 198×56) → ne suivent pas l'écran,
    surtout sur téléphone. On les met à 100 % de leur case.
  - Positions bizarres dans la barre du bas (valeurs à -11, 10…) → on reconstruit proprement.
  - Un script copié dans chaque bouton → remplacé par UN seul script client qui gère tous les boutons.

## Arborescence prévue
```
ReplicatedStorage
  Shared
    Config/ Rarities, Galaxies, Planets, Mutations, Upgrades, Rebirth, Gamepasses, Products, Codes, DailyRewards
    Util/ Format (1.2K, 3.4M…), Signal
  Remotes (créés par le serveur au démarrage, un dossier)
  Assets/ Galaxies, Planets, Effects (modèles 3D)
ServerScriptService
  Main (démarre les services dans l'ordre)
  Services/ DataService, PlotService, SpawnerService, IncubatorService, IncomeService,
            UpgradeService, RebirthService, IndexService, DailyService, CodesService, ShopService
  Lib/ RateLimit, Guard (vérif des arguments)
ServerStorage
  PLAN (notes), Templates/ Plot (modèle d'une base)
StarterGui
  HUD (gauche, bas, haut, droite) + un ScreenGui par écran (Galaxy, Planets, Shop, Rebirth, Index, Upgrades, Daily, Codes, Settings, HatchPopup)
StarterPlayerScripts
  Client/ Main + contrôleurs : HUDController, ButtonFX, GalaxyController, PlanetsController, ShopController,
          RebirthController, IndexController, UpgradesController, DailyController, CodesController,
          SettingsController, OrbitController (orbites côté client), PlotVisuals (timers au-dessus des galaxies)
Workspace
  Map/ Hub (Shop, Sell, Upgrade), Path, Plots/Plot1..8, Decor
```

## Décisions techniques
- Le serveur décide de tout ; le client affiche et demande. Chaque Remote : vérif joueur + arguments + limite de fréquence.
- Sauvegarde : DataStore avec retry, verrou de session, autosave toutes les 60 s, BindToClose, champ `Version`.
- Timers d'éclosion = heure de fin en `os.time()` sauvegardée → continue hors ligne.
- Argent hors ligne : gain/s × temps d'absence (plafonné, valeur dans la Config).
- Achats Robux : ProcessReceipt idempotent (liste des reçus déjà traités dans les données du joueur).
- Serveur à 8 joueurs max (8 bases).
- IDs Robux à 0 dans la Config tant qu'ils ne sont pas créés.

## Phases
- [x] 0 Analyse + plan
- [x] 1 Config d'équilibrage
- [x] 2 Map (v2 en briques) + assignation des bases
- [x] 3 Boucle principale (testée) — sauvegarde à tester après publication
- [ ] 4 GUI finale (Figma → validation → Studio)
- [ ] 5 Upgrades, Rebirth, Index, mutations, daily, codes
- [ ] 6 Modèles 3D + effets
- [ ] 7 Shop Robux
- [ ] 8 Finition, tests 2 joueurs, audit

## Décisions prises
- Kit K4LSH utilisé tel quel (images du kit), entête bleu, cartes grises teintées à la couleur de rareté.
- Noms en anglais en jeu, serveurs 8 joueurs, rebirth garde planètes/upgrades/enclos.
- Planètes avec un petit visage mignon (comme l'icône) = identité du jeu.
- Style 3D = BLOCS avec studs partout (demande de Hugo 12/10). Blender indisponible → tout en Parts (Models.lua). Un modèle mis dans
  ReplicatedStorage.Assets.Planets/<Id> remplace automatiquement la version Parts.
- Codes promo côté serveur (ServerStorage) pour qu'ils ne soient pas lisibles par les joueurs.

## Idées business (après le premier test)
- Récompenses de temps de jeu (5/15/30/60 min) → plus de temps de session.
- Bonus amis (+10 % par ami dans le serveur, max 3) → partage du jeu.
- Classements globaux (argent, rebirths) sur le hub.
- Événement week-end « x2 Luck » + galaxie limitée → retour des joueurs.
- Groupe Roblox : +10 % d'argent pour les membres.
