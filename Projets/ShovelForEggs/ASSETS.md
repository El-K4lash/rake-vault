# SHOVEL FOR EGGS — ASSETS

> Chaque modèle utilisé dans le jeu : origine (base Rake / vault / généré), note Obsidian dans le vault, emplacement dans Studio.

## Vault (modèles procéduraux du vault 3D, exportés en .rbxmx → ServerStorage.Vault.<catégorie>)
| Modèle | Note vault | Studio | Usage |
|---|---|---|---|
| Biome Ice (16) : arbre, petit arbre, buisson, fleurs, rochers, gros rocher, cristaux, sol, étang, œuf, coffre, clôture, portail, tas, bonhomme de neige, igloo | Notes/Biomes/Ice/*.md | ServerStorage.Vault.biomes.biomes_ice_* | décor des zones, clôtures des zones, sapin de Noël du lobby, chalet (PenBuilder) |
| Biome Grotte de cristal (16) | Notes/Biomes/Grotte de cristal | Vault.biomes.biomes_crystal_* | décor Ice Cave, Geode (ItemModels) |
| Biome Îles célestes (16) | Notes/Biomes/Îles célestes | Vault.biomes.biomes_sky_* | décor Aurora Peak |
| Sucre d'orge (Candy Land) | Notes/Biomes/Candy Land | Vault.biomes.biomes_candy_sp_cane | décor Village / lobby |
| Pelles bois / fer / or | Notes/Outils/Pelle *.md | ReplicatedStorage.Assets.Shovels.Shovel1..12 (recolorées, tools/build_shovels.lua) | outil du joueur |
| Lobby : stands Shop / Index / Sell, lampadaires, incubateur, machine rebirth, panneau info | Notes/Lobby/*.md | Workspace.Map.Hub | lobby (copié depuis la place Tyly) |
| Général : maisons, caisses, feu de camp, lampadaire doré, coffre rouge, stand gemmes, coffres | Notes/Général/*.md | Hub (FreeChest, FusionMachine), Zones.Village.Decor, Plots (PenBuilder) | décor |

## Vault (fichiers .rbxm de la bibliothèque)
| Modèle | Note vault | Studio | Usage |
|---|---|---|---|
| 87 brainrots de Rake for Brainrots (7 mutations : Normal, Oro, Diamante, Lava, Galaxia, Arcoiris, Hacker) | Notes/Brainrots/*.md · Projets/RakeForBrainrots_projet/RakeForBrainrots_v10.rbxl | ReplicatedStorage.Assets.Pets.<Mutation>.<Nom> | pets (Config/Pets) |
| RobuxShop (Steal An Egg Better Version) | Notes/Interfaces/Robux & gamepass | ServerStorage.SAE_RobuxShop → StarterGui.GUI.Frames.Store | boutique Robux |
| Kit K4LSH (images) | Notes/Interfaces/… k4lsh | StarterGui.* | toutes les GUI |

## Base Rake v10 (copié-collé depuis la place Tyly)
| Modèle | Studio | Usage |
|---|---|---|
| Lobby complet (Map.Hub) rethémé hiver | Workspace.Map.Hub | lobby |
| Arbres / buissons voxel enneigés de la maquette (SCATTER, 3 134 pièces) | Workspace.Map.Island.Scatter | décor du camp de base |
| GUI (GUI, Hotbar, AdminPanel, Tutorial, WheelWin, PlotTags, boards, LbBoard_*) | StarterGui | interface |

## Générés (fait main en studs, tools/)
| Modèle | Studio | Usage |
|---|---|---|
| Tas de neige, boule, stalactite, moufle, pomme de pin, pièce gelée, poisson gelé, cristaux (Ice Shard, Pine Crystal, Frost Gem, Frozen Pearl, Crystal Shard, Glacier Gem, Ancient Ice, Star Fragment, Aurora Shard, Moonstone), porte-bonheurs (flocon, chocolat chaud, grosse moufle, sucre d'orge) | ReplicatedStorage.Assets.ItemModels.<Id> | objets à déterrer (tools/build_snow_items.lua) |
| Montagne : terrasses, rampes, blocs de roche enneigés, pic | Workspace.Map.Terraces / Mountains | map |
| Clôture + portail + panneaux + chalet (PenBuilder) | Workspace.Map.Plots.PlotN.Pen | base des joueurs |
| HUD.Storm (compte à rebours) | StarterGui.GUI.HUD.Storm | tempêtes |
| Luges Sled1..5 + Slot | ReplicatedStorage.Assets.Sleds (tools/build_sleds.lua) | luge traînée (SledService) + vignettes du shop |
| Chalets en rondins, télésiège, pont de glace, grotte de glace, aurore | Workspace.Map.Extras (tools/build_winter_extras.lua) | structures de la montagne |

| 7 œufs à studs (Snow, Pine, Frozen, Crystal, Glacier, Aurora, Golden) | ReplicatedStorage.Assets.Eggs.<Model> (tools/build_eggs.lua) | œufs (outil, chalet, shop, hotbar) — remplacent les œufs lisses des biomes |
| Effets de creusage (trou en voxels, cubes, motte, aura) | StarterPlayerScripts.Client.DigFx (code) | coup de pelle |
| Œuf North Pole, objets Ornament / Present / StarTopper / FrozenChest | Assets.Eggs.NorthPole / Assets.ItemModels | zone 7 |
| Décor du Pôle Nord (atelier, sapin géant, rennes, traîneau, pôle, cannes, cadeaux, lampadaires) | Map.Zones.NorthPole.Decor + Map.Extras.NorthPole | zone 7 |
| Kit de déco studs (49 modèles : sapins, buissons, rochers, cristaux, fleurs, bonhommes de neige, igloo…) | ServerStorage.DecorKit_Studs | déco des biomes |
| Interfaces Advent / Quests / Pass / Starter / Offline / EggSkip, HUD.Right, HUD.Combo | StarterGui.GUI | fonctions d'hiver |

Icônes reprises du vault : pack SimulatorIcons (Assets/ui/Icons), Training Sim Gifts (cadeau 13300725267), Punch Sim Season (tickets 14290584744 / 14290583117), Bakery Sim (coffres, pièces).

## Ajoutés au vault (23/10)
| Élément | Fichier | Note |
|---|---|---|
| Luges (Shovel for Eggs) | Assets/models/ShovelForEggs/ShovelForEggs_Sleds.rbxm | Notes/Bibliothèque 3D/Hiver - Shovel for Eggs (Bibliothèque 3D)/Luges (Shovel for Eggs).md |
| Objets de neige (22) | …/ShovelForEggs_SnowItems.rbxm | …/Objets de neige (Shovel for Eggs).md |
| Pelles d'hiver (12) | …/ShovelForEggs_WinterShovels.rbxm | …/Pelles d'hiver (Shovel for Eggs).md |
| Chalet en rondins | …/ShovelForEggs_Chalet.rbxm | …/Chalet en rondins.md |
| Kit télésiège | …/ShovelForEggs_SkiLiftKit.rbxm | …/Kit télésiège.md |
| Œufs à studs (7) | …/ShovelForEggs_StudEggs.rbxm | …/Œufs à studs (Shovel for Eggs).md |
| Œuf North Pole | …/ShovelForEggs_Egg_NorthPole.rbxm | …/Œuf North Pole (Shovel for Eggs).md |
| Objets du Pôle Nord (4) | …/ShovelForEggs_NorthPole_Items.rbxm | …/Objets du Pôle Nord (Shovel for Eggs).md |
| Décor du Pôle Nord | …/ShovelForEggs_NorthPole_Decor.rbxm | …/Décor du Pôle Nord (Shovel for Eggs).md |
| Interfaces d'hiver | …/ShovelForEggs_GUI_WinterFeatures.rbxm | …/Interfaces d'hiver (Shovel for Eggs).md |
| Brainrots Festive (retirés du jeu ensuite) | …/ShovelForEggs_Pets_Festive.rbxm | …/Brainrots Festive (Shovel for Eggs).md |
