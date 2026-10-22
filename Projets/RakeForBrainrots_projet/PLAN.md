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

## v2 — refonte "Steal an Egg" (17/10/2026)
- Bases -> ENCLOS (PenBuilder) : clôture style SAE, sol terre à damier, panneau "<Pseudo>'s Pen" sur l'arche, pad Collect.
  Taille selon les slots (Upgrades.Pen.Size), couleur de clôture achetable (8 styles, Shop > PEN FENCES).
- Ratisser donne des ŒUFS (outil par type). Clic dans son enclos = pose ; éclosion (15 s -> 240 s) = brainrot + mutation (7 mutations).
- Brainrots = pack Brainrots_Animated (87 × 7 variantes, noms normalisés sans préfixe). Marche procédurale côté client (PenController).
- Map : même disposition, tout restylé avec les modèles/couleurs SAE (stands Shop/Index/Sell, RiftMachine = Rebirth, leaderboards SAE,
  coffre "FREE EGG" au centre = 1 œuf gratuit / 10 min, décor SAE dans le hub et les 5 biomes).
- GUI K4LSH (gui_k4.lua) : HUD (grille gauche, argent, sac, boutons BASE/SELL/ZONES = téléportations), Shop, Codes, Index (7 onglets),
  Base, Rebirth, Leaderboard, Popup d'éclosion, notifications en bas.
- Correctif : l'enclos était reconstruit à chaque rafraîchissement (comparaison float32) -> clignotement. Rendu maintenant incrémental.

## À faire ensuite
- Republier les animations du pack sur ton compte (sinon elles sont refusées) puis remettre PackAnimId -> AnimationId.
- Silhouettes noires des brainrots non découverts dans l'Index.
- Équilibrage (prix des clôtures / slots / chances des œufs) après vrais tests.
- Nettoyer ServerStorage (SAE_Map, SAE_Ref, GUI_Old, K4Kit) quand plus rien n'y est pris -> place plus légère.

## v3 — reconstruction complète (21/10/2026, place 94965884783307 « Expérience sans titre »)
- Compte c_k4lash bloqué : jeu reconstruit de zéro dans une nouvelle place (ancien travail du vault rangé dans ServerStorage.VaultBackup).
- Ordre de reconstruction : deliver/RakeForBrainrots.rbxmx (base) -> brainrots 7 variantes (packs _Complet) -> œufs (_Eggs_Complet)
  -> modèles Steal an Egg dans ServerStorage.SAE -> push.py --all -> tools/build_map.lua -> gui_k4.lua -> tools/build_hotbar.lua -> tools/build_store.lua.
- Bug trouvé : les UIStroke à dégradé des cartes du shop Robux empêchent l'affichage de toutes les cartes sauf une -> remplacés par un UIStroke simple.
- La police FredokaOne ne s'affiche pas dans les BillboardGui -> GothamSSm Heavy.
- Les sons / animations des packs appartiennent à d'autres créateurs : supprimés / désactivés (sinon erreurs « not authorized »).

## v8 (21/10) — refonte visuelle via le Rake Vault
- Vault : les modèles procéduraux (Enclos, Général, Lobby, Outils, Biomes) sont exportés via l'exporteur du vault
  (Chromium headless) -> ServerStorage.Vault.<catégorie>.<id> (31k parts, côté serveur seulement).
- Enclos : PenBuilder porte la clôture + le portail "Player's Pen" du vault (lanternes, chaînes, panneau) + déco (foin, abreuvoir, gamelle, nid).
- Râteaux : 12 niveaux (Upgrades.Rakes) = râteaux du vault (tools/build_rakes.lua), tête tournée (dents vers le sol).
  RakeController : râteau tenu en biais tête au sol, coup = lever / planter / gratter vers soi (poussière + traces).
- Objets à ratisser : ReplicatedStorage.Assets.ItemModels (tools/build_items.lua) ; WorldService = hitbox invisible + modèle soudé.
- Biomes : tools/build_biomes.lua (clôture + arche du biome, composition aérée, allée en dalles). Île des zones prolongée à z=770.
- Leaderstats : Money / Rebirths / Brainrots (DataService.RefreshStats).
- Stand Sell retourné, machine Rebirth posée au sol (build_map à jour).

## v10 — Lobby refait avec le vault (catégorie Lobby)
- tools/build_lobby.lua (à lancer après build_map) : jardinière centrale, stands SHOP/INDEX/SELL/CODES/VIP (+ vendeurs PNJ, textes sur les panneaux),
  coffre FREE EGG (timer perso via Client/LobbyController), machine Rebirth, classements TOP EARNERS / TOP REBIRTHS (r=64), lampadaires aux 9 entrées, panneau HOW TO PLAY.
- Nouvelles dalles : CodesPad (Action=Codes), StorePad (Action=Store). Spawn déplacé en (0, 0.6, 21).
- Ancien lobby sauvegardé dans ServerStorage.OldLobbyBackup.
- v10b (retours Hugo) : CODES/VIP retirés, PNJ retirés, auvents en demi-cercles (GeometryService:SubtractAsync sur les modèles du Vault),
  ancienne machine Rebirth + anciens classements remis (OldLobbyBackup suit les déplacements faits à la main), chemins des enclos sous la bordure (r 51.23).
  Centre = statue dorée (general_statue) sur socle rond ; coffre FREE EGG = general_chest_gold sur socle.
  Nouveaux systèmes (LobbyService + Config/Lobby) : Roue (1 tour gratuit/h, 6 gains), Incubateur (super éclosion x3 mutation, payant),
  Fusion (3 identiques -> mutation suivante, menu Frames.Fusion via tools/build_fusion.lua, Client/FusionController).
  build_lobby.lua : reconstruction partielle avec _G.LOBBY_ONLY = { section = true }.
- v10c : roue faite main (tools/build_wheel.lua, styles Royal/Carnival/Lab via _G.WHEEL_STYLE), pointeur-cliquet animé (LobbyController),
  fusion libre (3 brainrots au choix), coffre doré + œuf, fontaine au centre, décor de l'île (tools/build_scenery.lua : 40 montagnes stud,
  ferme, lac + camp, nuages), HUD argent rééquilibré, menu Shop moins haut (0.64).

## v10d — Map = copie exacte de la maquette Claude Design + objets personnels
- Map (hors lobby / enclos / téléporteur du Void) reconstruite pièce par pièce depuis la maquette HTML :
  tools/maquette/instr.py (instrumente la page) -> dump.py (Chromium headless, dump de la scène three.js)
  -> convert.py (primitives -> pièces Roblox : blocs à studs, octogones = 4 blocs, pyramides = 4 CornerWedge,
  troncs coniques = faces WedgePart, cônes = MeshPart, sphères = SpecialMesh) -> pack.py (MaqData.rbxmx)
  -> tools/build_maquette.lua (Prepare / Chunk(i) / Finish). Résultat : workspace.Map.Maquette (~58k pièces).
- Zones déplacées aux positions de la maquette : centres z = 230, 360, 490, 620, 750 ; pond rond (PondSize 23.2).
- Coffres des biomes = modèles du Vault (biomes_<id>_chest). Téléporteur du Void = Zones.Void.Portal (vault vortex).
- Client/MapFxController : fumée des volcans, bulles et anneaux du Void, moulin, nuages, ponds qui pulsent, écume.
- Objets à ratisser PERSONNELS : WorldService garde les objets par joueur (Near / Take), Client/ItemsController
  les dessine en local (workspace.MyItems). Les autres joueurs ne les voient pas et ne peuvent pas les ramasser.
- Téléport "Zones" : à l'entrée de la zone (plus au-dessus du pond).
- Obsolètes : build_island.lua, build_scenery.lua, build_biomes.lua (remplacés par la maquette).
- Murs invisibles (tools/build_walls.lua -> Map.Walls) : autour de chaque zone (ouvertures = arche + sortie arrière),
  au-dessus des arches, et autour de l'île. Sortie arrière bloquée par Zones.<Id>.GateBack (même rebirth que la zone),
  ouverte localement par WorldController.
- Rebirth / agrandissement d'enclos : les textes des panneaux (UPGRADES / MY STATS) sont coupés pendant que le panneau
  remonte (PenFxController) et BoardController ne reste plus accroché à l'ancien enclos ("OldPen").
- UI.ShowModel(vp, model, spin, fill) : caméra côté -Z (face avant des brainrots) ; `fill` = cadrage auto centré
  (boutique : brainrots du pack, hotbar : outils). Cases de la hotbar : View 0.94 x 0.8.

## v10e — Tutoriel des nouveaux joueurs
- GUI : tools/build_tutorial.lua -> StarterGui.Tutorial (Welcome, Card, Pointer + Ring, Done + Confetti, Templates.Marker).
- Client/TutorialController : 7 étapes (Equip, Zone/Beach, Rake x5, Sell, Upgrade/Shop, Base/pen, Rebirth) ;
  carte à droite, flèche + anneau sur le bouton à toucher, chemin de losanges lumineux au sol + panneau 3D sur l'objectif.
- TutorialService : data.Tutorial (étapes validées, 99 = fini/passé), pas de saut d'étape, récompense $500 une fois.
  Les anciens joueurs (rebirth ou > 60 objets ratissés) ne le voient pas.
- Musique de fond : tools/build_music.lua (Assets.Music = 4 pistes de la lib, bouton HUD.Left.Music ♫),
  Client/MusicController (playlist mélangée, fondus, on/off) + SettingsService (data.Settings.Music sauvegardé).
- Tutoriel v2 : cases K4 (comme le HUD) dans l'accueil, pointeur = épingle K4, panneau 3D sans fond (caché de près).
- Bouton SELL : téléporte devant le stand de vente (sur le pad), plus dedans.
- Roue : gain gardé dans data.WheelPending et donné à la fin du tour (SpinTime) ; fenêtre StarterGui.WheelWin
  (tools/build_wheelwin.lua) : rayons, icône du gain, montant, confettis, JACKPOT spécial, CLAIM.
- Lampadaires adoucis (PointLight 0.35 / 9 ; néons des têtes plus doux).
- Classements du lobby refaits au style du jeu (tools/build_leaderboards.lua) : socle + piliers bleu marine à studs,
  bagues dorées, couronne en blocs, en-tête K4, lignes or/argent/bronze/bleu avec tête du joueur (Avatar).
- Bases : Client/PlotTagController + StarterGui.PlotTags (tools/build_plottags.lua) : tête + pseudo au-dessus de chaque
  base, "YOUR BASE" vert sur la sienne ; panneaux UPGRADES / STATS des autres bases couverts (tête + "<NOM>'S PEN").
- HUD : bouton Admin en haut à gauche au-dessus de Shop ; boosts en bas à droite, plus petits.
- Classements du lobby : top 100 défilable. Listes = StarterGui.LbBoard_Money / LbBoard_Rebirths (SurfaceGui, 100 lignes),
  posées sur les écrans par Client/LbBoardController ; LeaderboardService lit 100 entrées (pseudos mis en cache).
