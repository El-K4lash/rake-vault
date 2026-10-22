# RAKE FOR BRAINROTS — PLAN

> Notes de projet. À relire au début de chaque conversation. Copie dans Studio : ServerStorage/PLAN.

## Le jeu (v1, 17/10/2026)
- Boucle : ratisser (outil Rake, clic ou maintien) → objets dans le sac → pad SELL (vert) → argent → shop (râteau / sac / slots)
  → brainrot trouvé par chance → posé dans la base (8 bases, modèle Plot_Template de la lib) → $/s → pad COLLECT → rebirth → zone suivante.
- 5 zones (Beach 0 rebirth, Swamp 1, Volcano 3, Ice 6, Void 10), carré 84×84 avec pond au centre (2× plus lent, 2× plus de chance).
- 40 brainrots = pack Brainrots_Animated de la lib (Normal, Gold, Diamond, Lava, Rainbow = mutations x1/x3/x6/x10/x15).
- GUI = kit SpookyGame (ton pote dev) réutilisé en VRAIES instances (HUD gauche, Labels, Shop, Index, Base, Rebirth, Leaderboard, Popup).
- Runes (objets spéciaux) = bonus permanents : Luck, Speed (cooldown râteau), Bag (+capacité), Income.
- Codes : RAKE, BRAINROT, LUCKY, RELEASE (ServerStorage/Codes).

## Fichiers
- deliver/RakeForBrainrots.rbxmx : tout le jeu (scripts + assets + GUI + map) dans un dossier RakeForBrainrots_Install.
- deliver/COMMANDE_INSTALL.lua : à coller dans la barre de commande après avoir glissé le .rbxmx.
- src/ : code Luau. gui.py / world.py / assets.py / build.py : fabrication du .rbxmx (python3 build.py).

## Arborescence dans Studio
ReplicatedStorage: Shared/Config (Zones, Items, Brainrots, Mutations, Upgrades, Rebirth), Shared/Util/Format, Assets (Brainrots, Rakes, RakeModels, Bags, Sounds, GuiTemplates), Remotes (créé au démarrage)
ServerScriptService: Main, Services (Data, World, Plot, Index, Harvest, Economy, Rebirth, Codes, Leaderboard), Lib (Net, Stats)
ServerStorage: Codes, PLAN
StarterGui: GUI (HUD, Frames, Templates)
StarterPlayer/StarterPlayerScripts: Client (Main + contrôleurs)
Workspace: Map (Island, Hub, Plots/Plot1..8, Zones/<Zone>)

## Fait (v1.1)
- PNJ du hub (modèle SellNPC de la lib, ×3) : SELL (vend le sac), SHOP (ouvre le shop), INDEX (ouvre l'index). Touche E, nom au-dessus de la tête.
- Retour "Nothing here..." quand un coup de râteau ne touche rien.
- Brainrots : textures + particules des mutations restaurées ; idle procédural (flottement) si l'animation du pack est refusée par Roblox.
- Sons de l'interface restaurés. Export .rbxmx corrigé (MeshId / Texture / SoundId / AnimationId écrits en Content).
- Testé en Play : récolte, vente (pad + PNJ), shop, slots, collect, index, codes, rebirth, zone 2.

## À faire ensuite
1. Animations des brainrots : elles appartiennent au créateur du pack → les ré-uploader avec TON compte (Animation Editor / import) et remplacer les AnimationId, sinon l'idle procédural reste utilisé.
2. Équilibrage (prix, chances) : tout est dans Shared/Config.
3. Robux : gamepasses (x2 money, auto-sell, +slots) — ids à créer, ProcessReceipt pas encore écrit.
4. Fusion (3 identiques → rareté au-dessus), événements (pluie de brainrots), quêtes.
5. Icône + thumbnail (les visuels de la page de présentation).
6. Publier → activer l'accès API → tester la sauvegarde → test à 2 joueurs.
