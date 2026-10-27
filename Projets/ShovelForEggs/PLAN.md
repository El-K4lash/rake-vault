# SHOVEL FOR EGGS — PLAN

> Notes de projet. À relire au début de chaque conversation. Dossier : `Rake Vault\Projets\ShovelForEggs`.
> Objectif : sortie avant début décembre 2026 (période de Noël).

## Le jeu
Simulator d'hiver. On déneige des zones à la pelle sur une montagne ; la neige remplit la luge (= le sac),
sous la neige on trouve des œufs, des cristaux de glace (argent) et des porte-bonheurs (bonus permanents). Luge pleine → SELL.
Les œufs éclosent dans son chalet en pets qui rapportent $/s. Shop : pelles (vitesse / zone d'effet) + luges (capacité).
Rebirth : débloque les zones plus hautes. Tempêtes : la neige retombe (toutes les zones se remplissent) ;
tempête dorée (rare, annoncée) = œufs dorés + luck x3 pendant 2 min.

Zones (terrasses de la montagne, de bas en haut, Y = 0 / 12 / 26 / 42 / 60 / 82) :
1 Snowy Village (0 rebirth) · 2 Pine Forest (1) · 3 Frozen Lake (2) · 4 Ice Cave (3) · 5 Glacier Summit (5) · 6 Aurora Peak (8).

## Jeu de base : Rake for Brainrots v10 (22/10/2026)
Place en ligne « Lieu de Tyly0_0 : 10222026_2 » (placeId 129524191759129) = copie de la v10 fournie par Hugo
(`RakeForBrainrots_projet/RakeForBrainrots_v10.rbxl`, original dans le vault, ne plus toucher).
**Place de travail Shovel : « Expérience sans titre » (placeId 101874796739418)** — à enregistrer en
`Projets/ShovelForEggs/ShovelForEggs.rbxl` (Fichier → Enregistrer dans un fichier sous).
Pourquoi Rake : même boucle (zones → sac → sell → base → rebirth), œufs + éclosion + enclos + shop + DataStore
(verrou de session, retry, autosave, BindToClose) + GUI K4 en vraies instances + tutoriel + roue + fusion + admin + classements.
Code serveur-autoritaire (Lib/Net : une RemoteEvent "Request" + seau de jetons par action, arguments vérifiés).

## Audit de la base (code v10, 8 900 lignes, --!strict)
### Gardé tel quel (renommé)
Lib/Net, DataService (nouvelle clé `ShovelForEggs_Players_v1`), WorldService (objets perso + RefillAll = tempêtes), HarvestService,
EggService, PlotService, EconomyService, RebirthService, UpgradeService, IndexService, CodesService, StoreService, LeaderboardService,
TutorialService, SettingsService, AdminService, DebugService, LobbyService ; tous les contrôleurs client ; GUI K4 (vraies instances).
### Modifié
- Renommage global : Rake→Shovel, Brainrot→Pet, Bag→Sled, Rune→Charm, pen→chalet (code, instances, textes, remotes, clé DataStore).
- Config/Zones (6 zones montagne, Y croissant), Items (neige / cristaux / porte-bonheurs), Eggs (7 œufs dont Golden), Pets = **les 87 brainrots de Rake** (copiés depuis rake_v10,
  raretés Common→Village … Secret→Aurora), Mutations = celles de Rake (Normal, Gold x2, Diamond x3, Lava x5, Galaxy x7, Rainbow x10, Hacker x15),
  Upgrades (12 pelles, 5 luges, 8 clôtures), Store (Lucky Egg, VIP Sled, packs d'œufs, Golden Egg limité).
- HarvestService : tempête dorée → l'œuf trouvé est un GoldenEgg. EconomyService : téléports Aurora (gardés, inutiles sur la montagne).
- PenBuilder : style chalet (poteaux bois, chapeaux neige, sol neige tassée, petit chalet + feu de camp + caisses + sapin + bonhomme).
- State (client) : redemande "Resync" si la première synchro est ratée (données chargées trop vite en Studio).
- Tutoriel : textes Shovel, zone Village. Main.client : MusicController retiré (pistes de la lib pas autorisées).
### Supprimé
NextWorld (config + menu + contrôleur), MapFxController, Brainrots config, RakeController, assets Rake (Brainrots, Rakes, Bags), SAE, GUI_Old, VaultBackup, OldLobbyBackup.
### Ajouté
- StormService (serveur) : tempête toutes les 8 min (45 s), annonce 20 s avant, 1/6 dorée (2 min, EventLuck x3, œufs dorés) ;
  attributs workspace StormKind / StormEnd / NextStorm ; Debug `storm`.
- Client : StormController (HUD.Storm compte à rebours + bannières), SnowFxController (neige qui tombe, blizzard / paillettes dorées).
- Map montagne (tools/build_winter_map.lua) : camp de base, 8 chalets, 6 terrasses avec rampes, clôtures Ice du vault, décor par zone, murs, lumière.
- Lobby = copié-collé depuis la place Tyly (v10 rethémée : sapin de Noël, stands enneigés, roue, classements, Gift Box, incubateur, fusion).
- Arbres voxel enneigés de la maquette (SCATTER) copiés-collés autour du camp de base.
- Assets : Pets (87 brainrots × 7 mutations, depuis rake_v10.rbxl), Eggs (7, vault biomes_*_egg), Shovels (12, pelles du vault recolorées), ItemModels (22, tools/build_snow_items.lua).
- Exports du vault 3D (Chromium headless, tools dans /home/claude/vault3d) : biomes Ice + Grotte de cristal + Îles célestes + 4 œufs
  → `Rake Vault/_claude_tmp/Vault_biomes_winter.rbxmx`, `Vault_biomes_sky.rbxmx`, `Vault_biomes_eggs.rbxmx`.

- SledService (serveur) : la luge du niveau acheté est traînée derrière le joueur (soudée, au ras du sol, vue par tous),
  le tas de neige « Load » grossit avec le remplissage (10 paliers). Testé en Play le 23/10 : bas de la luge à 0,05 stud du sol.
- Extras map (tools/build_winter_extras.lua) : 8 chalets en rondins (camp + Village), télésiège (pylônes, câbles, sièges, 2 gares)
  le long des terrasses, pont de glace (rambardes + arches) Frozen Lake → Ice Cave, grotte de glace (piliers, toit, stalactites,
  lumières cristal), aurore (Beams + étoiles) au-dessus d'Aurora Peak.
- Creusage (Client/DigFx + ShovelController) : vraie animation de pelle (lever → planter → basculer → jeter la motte
  dans la luge). Au sol : trou en voxels à studs (fond en marches Inlet, 2 anneaux de blocs qui jaillissent), cubes projetés
  qui rebondissent, poudre de neige, onde de choc + aura à la couleur de la pelle (halo dès la Golden, colonne de lumière dès
  la Crystal), petit tremblement caméra. Objet trouvé = anneau (+ rayon pour cristaux / charmes) ; œuf trouvé = colonne de
  lumière + double anneau. Le trou se rebouche après 2,4 s. Purement visuel (local), le serveur décide toujours.
- Œufs refaits (tools/build_eggs.lua) : 7 œufs à studs liés aux zones (bonnet de Noël, mini sapin, glace fissurée, cristaux,
  stalactites, aurore, couronne dorée). Chalet : œufs mis à l'échelle sur la hauteur ; hotbar : l'œuf est montré debout.
- Debug : `shovel` et `sled` (niveau) ajoutés à SFE_Debug.
- Codes : SNOW (500 $), SHOVEL (2 500 $), LUCKY (Luck x2 15 min), XMAS (10 000 $).
- Vault (ajouts, 23/10) : `Assets/models/ShovelForEggs/` (5 .rbxm : luges, objets de neige, pelles d'hiver, chalet, kit télésiège)
  + notes `Notes/Bibliothèque 3D/Hiver - Shovel for Eggs (Bibliothèque 3D)/` + miniatures `Notes/_img/SFE_*.webp`.
  Puis les œufs à studs (`ShovelForEggs_StudEggs.rbxm`, 6e élément de la sous-catégorie).

## Finition (23/10, nuit)
- Audit sécurité (agent) corrigé : game pass vérifié par UserOwnsGamePassAsync, ProcessReceipt n'accorde que si la sauvegarde réussit,
  PlaceEgg refuse les NaN, boucles serveur (revenus, éclosions, tempêtes, apparition) protégées par pcall, l'œuf n'est retiré
  qu'une fois le pet créé, SaveNow ignore un profil en cours de libération, LOCK_STALE 90 s, inventaire max 500 brainrots,
  classements renommés SFE_Lb_*.
- Équilibrage : Rebirth.Cost = 10 000 × 6^n (simulation : 1er rebirth ~10 min, Glacier ~1 h, Aurora ~4 h).
- Sons (Assets.Sounds, Creator Store gratuits / Pro Sound Effects / APM) : Click, Hover, Error, Success, Normal, LevelUp, Win,
  Fireworks, Wave, Money, Dig, SnowLand, Hatch, Blizzard, Whoosh, Thunder, Gust, GoldenJingle. Musique : 4 titres de Noël APM
  (Assets.Music), MusicController réactivé (bouton Music du HUD).
- Météo (tools/build_weather.lua) : Atmosphere plus dense, nuages, flou de profondeur, rayons ; Map.Horizon = champ de neige +
  30 montagnes lointaines → on ne voit plus le bord de la map. Lumière baissée (Brightness 1.6, exposition −0.35) : biomes moins éblouissants.
- Tempêtes (Client/StormFxController, remplace SnowFxController) : ciel qui se couvre 20 s avant, blizzard (traînées, paquets,
  brume au sol, rafales), voile blanc, givre sur les bords de l'écran (StarterGui.StormFx, vraies instances : tools/build_storm_fx_gui.lua),
  éclairs + tonnerre, caméra qui tremble ; tempête dorée : lumière chaude, flocons/paillettes dorés, colonnes de lumière, jingle.
- Recalage au sol (agent) : 297 objets déplacés (igloo, décor des 6 zones, lobby, sapins des montagnes, arbres Scatter),
  journal d'annulation ServerStorage._GroundFixLog ; panneau HowToPlay remonté (il était sous la map) ; moulin flottant sans tour
  déplacé dans ServerStorage._Removed.
- Testé en Play : récolte dans les 6 zones, verrou de rebirth, vente, codes, tutoriel, tempête de neige + dorée, console propre.
- Murs invisibles refaits (tools/build_walls.lua, 95 murs) : l'ancienne version comptait 2 fois la hauteur des terrasses
  (murs des zones hautes en l'air, on passait dessous) et le bord nord du camp coupait le Village. Testé : entrée par le portail,
  portail verrouillé bloquant, bords de terrasse et côtés des rampes bloqués. Anciens murs gardés dans ServerStorage._Removed.Walls_old.
- Lobby : 16 décors (sapins, bonshommes, sucres d'orge) qui étaient dans les stands / zones d'interaction déplacés à côté.
- Panel admin > Events : cadre STORM EVENTS (SNOW STORM, GOLDEN STORM, END STORM + statut), commandes serveur Admin Storm / EndStorm,
  StormService.Stop(). GUI en vraies instances (tools/build_admin_storm_gui.lua).
- Traîneaux v2 (tools/build_sleds.lua) : 5 modèles détaillés et de plus en plus grands ; SledService : traîneau visible seulement
  dans les zones, chargement morceau par morceau aux couleurs des objets ramassés ; Client/SledAnimController : suit le sol et
  les pentes, traîne en virage, se balance, corde à la main gauche, gerbes de neige + traces, morceaux qui tombent dedans,
  pouf à l'apparition / étincelles quand on achète un meilleur traîneau.
- Page du jeu : PAGE_JEU.md + Page/icon_512.png, thumb_1.png, thumb_2.png.

## Mise à jour d'hiver (23/10, après-midi) — « fait tout sauf le 4, pas de VIP »
- Calendrier de l'Avent (1→24 déc., cases ratées rattrapables), 3 quêtes du jour + bonus, Winter Pass 30 paliers (gratuit + Premium = game pass WinterPass),
  Starter Pack (après 5 min), gains hors ligne x2 (R$19), éclore maintenant (argent ou R$15, invite sur l'œuf), pass Triple Hatch (+3 œufs).
  Config : `Shared/Config/Events.lua` ; serveur : `RewardsService` ; client : `RewardsController` ; interfaces : `tools/build_features_gui.lua`
  + `build_features_icons.lua` (vraies icônes du vault) + `build_features_restyle.lua` (cartes texturées K4).
- Combo de creusage (x10/x25/x50 = chance d'œuf x1.3/1.6/2), coffre gelé rare (1/140), premier œuf garanti après 3 tas, bonus +5 % d'argent par index complété (+2 Golden Eggs).
- Zone 7 « North Pole » (12 rebirths, œuf NorthPole, objets Present/Ornament/StarTopper) : `tools/build_northpole.lua` (terrasse, rampe, arche, atelier, sapin géant, rennes, traîneau…),
  clôture arrière d'Aurora ouverte, pic reculé, murs refaits (`build_walls`).
- Classements de la semaine (tas creusés, Secret trouvés), week-end de lancement (tempêtes dorées toutes les 5 min, code LAUNCH).
- Bouton AUTO toujours visible (verrouillé = prix, clic = achat), rappel « fusion possible » (bulle + faisceau vers la machine), tutoriel raccourci (5 étapes), moins de particules sur mobile.
- Déco des biomes refaite en blocs à studs (279 modèles, kit `ServerStorage.DecorKit_Studs`, anciens modèles dans `ServerStorage.OldDecor_Backup`).
- Retiré à la demande de Hugo : mutation Festive (bonnets de Noël sur les brainrots) → les récompenses donnent des Rainbow / Hacker.
- Pas fait (volontairement) : social (échanges, likes, annonces), VIP.

## Outils (ServerStorage.Tools, à lancer en Edit via require(module:Clone()))
build_winter_map (sections island/plots/zones/mountains/walls/lighting via _G.SFE_MAP_ONLY), build_winter_hub, build_winter_retheme
(pour la map maquette : palette / zones / aurora / hub / lighting), build_shovels, build_snow_items, build_storm_hud, build_store, gui_k4, build_* (Rake).
ServerStorage.SFE_Push : applique un `content/sfe/<fichier>.rbxmx` (StringValues chemin|Classe) — outil de dev, à supprimer avant publication.
Injection de fichiers : `game:GetObjects("rbxasset://sfe/...")` (dossier `AppData\Local\Roblox\Versions\version-7aaa6838d36c4448\content\sfe`,
toujours un nouveau nom de fichier : GetObjects met en cache).

## Testé en Play (22-23/10)
Données chargées, pelle donnée, creuser (Harvested), vendre, œuf → pose dans le chalet → éclosion → pet posé, tempête dorée (HUD + boost x3),
Store K4, hotbar, panneaux UPGRADES / STATS, achat pelle / luge / slot / clôture, luge traînée derrière le joueur.
Console : aucune erreur. DataStore actif (API access OK : données persistantes).

## À faire ensuite
1. Hugo : enregistrer la place en `ShovelForEggs.rbxl` + publier ; avant publication retirer ServerStorage.SFE_Push, SFE_Export, Tools, SAE_RobuxShop.
2. Tutoriel : le compte de test a Tutorial=99 → `Debug:Invoke("tutorial", 0)` pour le revoir ; vérifier les 5 étapes en jeu.
3. Son de pelle / neige (ids audio à choisir).
4. Store : ids GamePass / Developer Products à créer (Config/Store), ProcessReceipt déjà en place.
5. Créer les game passes / produits (liste dans PAGE_JEU.md, 11 nouveaux) et mettre les Id dans Config/Store.lua.
8. Objets enterrés (idée de Hugo) : à discuter avant de coder.
6. Polish montagne : variété des blocs de roche, plus de décor par zone.
7. Réglages du jeu : 8 joueurs max par serveur (8 chalets), genre Simulation, description et images de PAGE_JEU.md.

## Décisions
- Pets = les mêmes brainrots que Rake for Brainrots (demande de Hugo, 22/10), mutations de Rake.
- GUI K4 gardées (copiées depuis la place Tyly), textes adaptés ; pas de panneaux inventés.
- Nouvelle clé DataStore `ShovelForEggs_Players_v1`.

## Correctifs du 23/10 (soir, retours de test en jeu)
- HUD.Combo : le fond bleu passait devant les textes (ZIndex) → Bg Z1, textes Z3, barre Z4.
- Igloo des enclos : flottait de ~3 studs (sa sphère du dessous comptait comme le bas) → PenBuilder, 4e valeur « part enterrée » (0,47), hauteur 7,5.
- Starter Pack : bouton « Starter » visible dès l'arrivée tant qu'il n'est pas acheté ; pastille « ! » + ouverture auto après 5 min. Id du produit encore à 0 → « Coming soon! ».
- Barrières des 7 zones (16 Studs_Fence chacune) : flottaient de ~2,5 studs → posées sur le sol.
- Dalles des portails : 0,4 stud au-dessus de la terrasse + débord au-dessus du haut de la rampe (on rentrait dedans) → posées sur la terrasse, la 1re raccourcie pour commencer au bout de la rampe.
- Murs invisibles `<Zone>_StripL/R` : ferment la bande entre le bout de la rampe (ou le camp pour le Village) et la barrière, on ne passe plus derrière les barrières.
- Bouton Collect caché quand la pelle est en main (le bouton AUTO était à la même place).
- Musique : le jingle de la tempête dorée se mélangeait à la playlist → la musique se coupe pendant le jingle (attribut SoundService « MusicDuckUntil »).
- Bouton EQUIP BEST (Base + Index) : texte qui touchait le bord → bouton plus large, marge à droite.
- Skip d'œuf (argent) : prix = max(base de l'œuf × (1 + rebirths)^1,6 ; revenu de la base × durée d'éclosion × 1,5) × part du temps restant, min 50 $. Bases : Snow 150, Pine 900, Frozen 5K, Crystal 30K, Glacier 180K, Aurora 1M, North Pole 6M, Golden 25K. Le prix affiché baisse avec le temps. Robux inchangé (15 R$).
- Œufs rééquilibrés : chaque œuf donne surtout les pets de sa zone, plus jamais ceux des zones d'en dessous (Pine = Rare 74 / Epic 22 / Leg 4 ; Frozen = Epic 74 / Leg 22 / Myth 4 ; Crystal = Leg 74 / Myth 22 / Secret 4 ; Glacier = Myth 86 / Secret 14 ; North Pole = Myth 30 / Secret 70).
- Igloo : la porte regarde le centre de l'enclos (PenBuilder, 5e valeur).
- Clôture de l'enclos selon les rebirths (Upgrades.FenceFor) : 0 Wood, 1 Snowy, 2 Candy, 3 Frost, 5 Pine, 8 Golden, 10 Crystal, 12 Aurora ; celle du shop gagne si elle est meilleure.
- Lobby : 4 bonshommes de neige sortis du chemin / de la place / d'un lampadaire.
- Musique : 4 musiques de Noël à clochettes remplacées par 5 lo-fi d'hiver DistroKid (snowflakes, frosted windows, frost hour, snowman, remember mittens next time) ; anciennes dans ServerStorage.OldMusic_Christmas.
- 25/10 : comptes à rebours côté client calés sur l'horloge du SERVEUR (workspace:GetServerTimeNow) au lieu de os.time() (horloge du PC) : tempête (affichait 66 min sur un PC décalé d'1 h au passage à l'heure d'hiver), reset du shop, jour de l'Avent, fin du Winter Pass, reset des quêtes. Dates d'Events en DateTime.fromUniversalTime (UTC sans ambiguïté).
- 25/10 : [GIFT] Skip Timer (Developer Product « GiftSkip », 15 R$, Robux uniquement) : près de l'œuf d'un AUTRE joueur, invite « Gift hatch 🎁 <pseudo> » → fenêtre GUI.Frames.GiftSkip (vraie instance, clone d'EggSkip) → achat → l'œuf éclot pour son propriétaire. Cible envoyée avant l'achat (GiftSkipTarget, vérifiée serveur). Notifs : propriétaire, acheteur, et tout le serveur. Si l'œuf a éclos → celui qui finit le plus tard ; joueur parti / plus d'œuf / inventaire plein → l'acheteur reçoit un Golden Egg. Id à créer dans Creator Hub.

## 25/10 — Icônes dev products + bandeau Store
- 10 icônes de dev products refaites avec Figma (œufs Snow/Pine/Frozen/Crystal/Glacier/Aurora x3, Golden x1/x5/x15/x40) et envoyées sur Roblox.
- Store : bandeau offre limitée renommé "VOID EGG" → "GOLDEN EGG" (+ builder build_store corrigé), contour et halo dorés. Vignettes = vrais pets avec les vraies chances de l’œuf doré.

## 26/10 — GROSSE UPDATE : amélioration des brainrots
- Chaque brainrot a un niveau (Lv 1 → 15). +25 % de revenu par niveau (Lv 15 = x4.5).
- Prix = revenu de base du pet × mutation × bonus de rebirth × 60 s, puis ×1.45 par niveau. Les niveaux restent après un rebirth.
- Où : bouton UPGRADE sur chaque carte du menu Base, ou touche F près d'un de ses pets dans l'enclos → fenêtre Upgrade (Lv actuel > suivant, revenu avant/après, UPGRADE +1 ou MAX = autant que l'argent permet).
- Serveur : PlotService "UpgradePet" (tout vérifié serveur), billboard « [Lv X] » mis à jour sans faire sauter le pet.
- Nouvelle quête du jour « Upgrade your brainrots X times » + XP du Winter Pass.
- Fichiers : Shared/Config/Levels (réglages), Client/UpgradeController, GUI.Frames.Upgrade, BaseTemplate (Level + Upgrade).

## 26/10 — Panel admin + divers
- GIVE : 3 catégories PETS / PRODUCTS / GAMEPASSES. Products : chaque clic redonne. Gamepasses : coché = donné, décoché = retiré même s'il a payé (data.PassRevoked bloque la re-vérification Roblox).
- Grille GIVE EGGS réparée (8 œufs sur 3 lignes, noms courts).
- Cercles Shop et Index du hub : entrer = le menu s'ouvre, sortir = il se ferme (plus besoin de E).
- Slots au même endroit : « Hatch slots » (ex-Egg Slots, œufs qui éclosent en même temps) déplacé du panneau UPGRADES de l'enclos vers le Shop, sous Chalet slot.
- Gift hatch : le clic souris sur l'œuf d'un autre joueur marche aussi (avant : seulement E).
- Test Studio sans toucher à la sauvegarde : mettre l'attribut ServerStorage.StudioNoSave = true (Studio uniquement), remettre à false après.
- 2 œufs peuvent toujours éclore, même avec le chalet plein de brainrots (PlotService.FreeEggs = 2 : les 2 premiers œufs ne prennent pas de chalet slot). À l'éclosion, le nouveau pet remplace le plus faible s'il rapporte plus, sinon il est rangé.
- Vente d'un pet amélioré : + la moitié de l'argent investi dans ses niveaux (entry.Spent). Le bouton affiche « SURE? LV X ».
- Fusion : 3 pets identiques → le meilleur niveau est gardé ; pets différents → Lv 1 et la moitié de l'argent investi est rendue (pas de transfert de niveau d'un Common vers un Legendary).
- Prix des niveaux baissés : Lv1→2 = 20 s du revenu du pet (avant 60 s), ×1.4 par niveau (avant ×1.45). Ex. Pipi Kiwi Lv 1→15 = 5.5K au total.
- Clic souris sur un de ses brainrots dans l'enclos = fenêtre Upgrade (boîte invisible « UpgradeHit » + ClickDetector, rien chez les autres joueurs).
- Fenêtre Upgrade refaite : case du pet avec LV, nom + rareté, barre LEVEL x / 15, revenu actuel → suivant. Bouton UPGRADE des cartes Base centré, avec le prix (grisé si pas assez d'argent).
- Admin GIVE PET : champ « Lv » à côté de Count (1 à 15, vide = Lv 1).

## 26/10 — Passage dans le groupe Stud'io
- Le jeu est maintenant dans le groupe **Stud'io** (groupe 955449225) : experience 10773155178, place 72776938111193. L'ancien jeu (experience 10772429390, à fxgntdgthfxth) n'est plus utilisé.
- 6 gamepasses + 19 dev products recréés dans le nouveau jeu (mêmes noms, descriptions, prix, icônes ; tarification gérée coupée). Nouveaux IDs dans Config/Store (tableau dans PAGE_JEU.md).
- Panel admin : en plus de mon UserId, le propriétaire du groupe et ses admins (rang ≥ 254) sont propriétaires du panel.
- Icône « level up » (flèche verte + étoile, Figma) sur la fenêtre Upgrade, envoyée au nom du groupe (decal 79990146455730 → image 103979965937146). Fichier : Miniatures/Icone_LevelUp.png.
- Coffre FREE EGG du lobby : réservé aux membres du groupe qui ont mis le jeu en favori. Sinon la fenêtre GroupChest s'ouvre : 1. JOIN (rejoindre le groupe sans quitter le jeu, revérifié côté serveur), 2. FAVORITE (étoile Roblox), puis OPEN CHEST.

## UI 9-slice (contours fins) — 2026-10-26
- Les 38 images cadres/boutons du kit étaient étirées (Stretch) => côtés noirs énormes sur les boutons larges.
- Copies 700px ré-uploadées dans le groupe Stud'io (taille connue) + ScaleType Slice.
- Module `ReplicatedStorage.Shared.Util.Slice9` : table ancien id -> nouvel id, taille, bords. `Thin = 0.85` (épaisseur des contours).
- `Client.SliceController` (chargé après UI) : recalcule SliceScale selon la taille réelle (PC/mobile) + GUI clonées + changements d'image.
- Attribut `NoSlice = true` sur une image pour l'exclure.
- 688 éléments convertis (StarterGui + Workspace).
- Bouton PREMIUM (Winter Pass) refait : plus de "✓" texte. Enfant `Owned` (icône coche + PREMIUM + ACTIVE), bouton doré quand acheté. Coche = vault `Assets/ui/Icons/Checkmark/Checkmark 2nd Outline 256px.png` (Free Icon Pack 2.0) → image groupe 119460915184899.
- Paliers réclamés : icône `Claimed` (même coche) + texte CLAIMED au lieu de "✓".
- État non acheté refait pareil : enfant `Locked` (ticket doré + PREMIUM + robux blanc 399), bouton vert. Robux blanc contouré = vault `Assets/ui/Icons/Robux/` → image groupe 125284136845502. Anciens `Text`/`PriceRow` cachés.

## Session du 26/10 (soir)
- Barre « Next storm » / MoneyBar (image 103553873357333) : 9-slice aussi (copie groupe 97830305955669).
- Filtres Base (ALL / PLACED / STORED) : icônes même taille visuelle, centrées.
- Store refait : cartes du kit (couleurs par pass : Hatch bleu, Money vert, Luck orange, VIP or, Triple rose, Winter Pass violet), icône dans une case, titre/texte alignés à gauche ; cartes Money vertes ; cartes Eggs à la couleur de chaque œuf ; icône Robux blanche partout.
- Œufs 2D (style vault Free Icon Pack, recoloré + motif par zone) : `Assets/ui/Icons/Egg/ShovelForEggs/` (+ gen_eggs.py). Ids image : Snow 101801156195317, Pine 137241775257980, Frozen 103858761831995, Crystal 78930058580337, Glacier 99723055528491, Aurora 138871801294716, NorthPole 120972647115170, Golden 128385392356810. Les ViewportFrame 3D du Store sont supprimées.
- Icône Pet Fusion (portail violet + patte dorée) : `Assets/ui/Icons/Fusion/Icone_PetFusion.png` → image 85687425256546 ; ancienne machine 3D gardée dans ServerStorage._OldGui.
- Tempête dorée : luck x3 + 40 % d'avoir l'œuf de la zone du dessus ; œufs dorés seulement au Pôle Nord (StormService.EggFor).
- Admin > Server : RESTART SERVER et RESTART ALL (soft restart : serveur réservé d'attente puis nouveau serveur public ; MessagingService pour tous les serveurs ; propriétaires seulement).
- Coffre du groupe : favori validé même si Roblox renvoie « Failed » (seul « Non » refuse) + secours au bout de 12 s.
- Boutons : le survol grossit depuis le centre et de 6 px max ; un mot seul ne se coupe plus pendant l'animation (UITextSizeConstraint temporaire).
- Page du jeu : icône + 6 bannières (page détails) + 6 miniatures page d'accueil (API thumbnail-personalization, il faut interroger /uploads/status pour finaliser).

## Session du 27/10 (patch mobile)
- Fenêtre Upgrade : bouton UPGRADE remis à sa place (UI.Button ne change plus AnchorPoint ; Claim du coffre centré dans Studio).
- Quêtes : badge DoneBadge (bouton vert + coche du vault + DONE) au lieu de « ✓ DONE » ; bonus « Daily bonus claimed! » + badge ; titres moins larges (0.52) pour ne plus toucher la récompense.
- Mobile : cartes Upgrades du Shop à proportion fixe (UIAspectRatioConstraint 4) ; grilles Index / Base / Fusion / Fences / Admin : cellules à proportion fixe (CellRatio sous UIGridLayout) ; lignes du leaderboard (RowRatio 6.9) ; paliers du Pass à 0.88 ; bouton REBIRTH en majuscules.
- HUD : boutons Codes et Ranks (Leaderboard) cachés ; section CODES (saisie + REDEEM) ajoutée en bas du Store Robux (ShopController.hookCodes).
- Icônes des 19 dev products refaites (Free Icon Pack du vault + œufs 2D, fond kit à studs, Montserrat Black) : `Produits/` + make_icons.py ; envoyées sur Creator Hub (en modération). Cartes Money du Store : StoreCash_1..5 (sans fond).
- Section CODES du Store refaite comme les cartes de pass : carte violette du kit, clé dorée du vault (`Assets/ui/Icons/Codes/`, image 75852084553605), titre REDEEM A CODE, barre de saisie sombre, bouton REDEEM.
- HUD gauche (Shop, Index, Base, Rebirth) en une colonne comme à droite (Left : taille 0.055 x 0.42, ancre 0,0.5, cellules 1 x 0.235) ; bouton Admin remonté au-dessus.
- Mobile sans casser PC : cartes Shop / cellules des grilles / lignes leaderboard en hauteur 10000 px + UIAspectRatioConstraint (FitWithinMaxSize) → la taille suit la largeur sur PC comme sur tel.
- Index refait : fond de carte du kit teinté par rareté (Bg 71327065275858 en 9-slice), rayons (123171646849062) derrière les pets découverts, cartes non découvertes sombres teintées, onglet actif blanc + contour « Sel », étiquette de rareté plus large (0.9 x 0.13) pour que MYTHIC/LEGENDARY ne se coupent plus.
- Codes : le message de validation affiche les gains (ex. « Code redeemed! You got $25K + 3x Golden Egg », « x2 Luck 15 min »).
