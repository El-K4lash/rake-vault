# Modèles 3D classés par type

2306 objets extraits de `newlib/models` (FromGames + Machines + VFX), un objet par fichier `.rbxm`.

Règles appliquées : un seul objet racine (Model, ou Tool/Accessory laissé tel quel), PrimaryPart défini (celui d’origine sinon la plus grosse pièce), WorldPivot en bas au centre de la bounding box, pièces ancrées sauf Tools, pets, véhicules, personnages (Humanoid) et objets à contraintes physiques (ancrage d’origine conservé). Scripts dangereux retirés (require(ID), getfenv/setfenv, loadstring, webhooks, URLs suspectes). Doublons exacts et variantes de couleur des pets (Golden/Toxic/Galaxy/Shiny…) retirés : seule la version Normal est gardée, les variantes restent dans le fichier source de `newlib`.

## Résumé

| Type | Objets |
|---|---|
| [Pets](#pets) | 913 |
| [Eggs_Incubators](#eggs_incubators) | 172 |
| [Tools_Weapons](#tools_weapons) | 180 |
| [Gear_Gadgets](#gear_gadgets) | 80 |
| [Accessories_Hats](#accessories_hats) | 31 |
| [Machines_Upgraders](#machines_upgraders) | 91 |
| [Shops_Stands](#shops_stands) | 59 |
| [Conveyors_Tycoon](#conveyors_tycoon) | 3 |
| [Plots_Bases](#plots_bases) | 11 |
| [Portals_Teleports](#portals_teleports) | 55 |
| [Leaderboards_Boards](#leaderboards_boards) | 72 |
| [Collectibles_Chests](#collectibles_chests) | 36 |
| [Decor_Props](#decor_props) | 268 |
| [Buildings](#buildings) | 65 |
| [Maps_Islands_Worlds](#maps_islands_worlds) | 75 |
| [Vehicles](#vehicles) | 10 |
| [NPC_Characters](#npc_characters) | 67 |
| [VFX_Effects](#vfx_effects) | 76 |
| [Misc](#misc) | 42 |

## Pets

Dossier `ByType/Pets/` — 913 objets.

| Fichier | Jeu | Pièces | Scripts | Description |
|---|---|---|---|---|
| 1HealthEverySecond_Cat.rbxm | 1HealthEverySecond | 3 | non | Pet, ancrage d’origine conservé, 2x2x2 studs (de 1HealthEverySecond/Assets.rbxm) |
| 1HealthEverySecond_ChristmasDominus.rbxm | 1HealthEverySecond | 1 | non | Pet, ancrage d’origine conservé, 4x4x2 studs (de 1HealthEverySecond/Assets.rbxm) |
| 1HealthEverySecond_Crabby.rbxm | 1HealthEverySecond | 3 | non | Pet, ancrage d’origine conservé, 3x2x2 studs (de 1HealthEverySecond/Assets.rbxm) |
| 1HealthEverySecond_CupcakeBunny.rbxm | 1HealthEverySecond | 1 | non | Pet, ancrage d’origine conservé, 2x3x2 studs (de 1HealthEverySecond/Assets.rbxm) |
| 1HealthEverySecond_DeadlyDarkDominus.rbxm | 1HealthEverySecond | 1 | non | Pet, ancrage d’origine conservé, 3x2x2 studs (de 1HealthEverySecond/Assets.rbxm) |
| 1HealthEverySecond_Donut.rbxm | 1HealthEverySecond | 1 | non | Pet, ancrage d’origine conservé, 2x2x2 studs (de 1HealthEverySecond/Assets.rbxm) |
| 1HealthEverySecond_IceCreamGnome.rbxm | 1HealthEverySecond | 2 | non | Pet, 3 particules/effets, ancrage d’origine conservé, 2x3x3 studs (de 1HealthEverySecond/Assets.rbxm) |
| 1HealthEverySecond_JellyBeanBear.rbxm | 1HealthEverySecond | 1 | non | Pet, ancrage d’origine conservé, 2x2x2 studs (de 1HealthEverySecond/Assets.rbxm) |
| 1HealthEverySecond_Pumpkin.rbxm | 1HealthEverySecond | 2 | non | Pet, ancrage d’origine conservé, 3x3x3 studs (de 1HealthEverySecond/Assets.rbxm) |
| 1HealthEverySecond_Snake.rbxm | 1HealthEverySecond | 2 | non | Pet, ancrage d’origine conservé, 2x3x3 studs (de 1HealthEverySecond/Assets.rbxm) |
| 1HealthEverySecond_Spidy.rbxm | 1HealthEverySecond | 4 | non | Pet, ancrage d’origine conservé, 3x2x2 studs (de 1HealthEverySecond/Assets.rbxm) |
| 1JumpEverySecond_CactusBunny.rbxm | 1JumpEverySecond | 1 | non | Pet, ancrage d’origine conservé, 2x3x3 studs (de 1JumpEverySecond/Assets.rbxm) |
| 1JumpEverySecond_ChristmasDominus.rbxm | 1JumpEverySecond | 1 | non | Pet, ancrage d’origine conservé, 2x4x4 studs (de 1JumpEverySecond/Assets.rbxm) |
| 1JumpEverySecond_CrystalGolem.rbxm | 1JumpEverySecond | 2 | non | Pet, 1 particules/effets, ancrage d’origine conservé, 2x2x2 studs (de 1JumpEverySecond/Assets.rbxm) |
| 1JumpEverySecond_CupcakeBunny.rbxm | 1JumpEverySecond | 1 | non | Pet, ancrage d’origine conservé, 2x3x2 studs (de 1JumpEverySecond/Assets.rbxm) |
| 1JumpEverySecond_DeadlyDarkDominus.rbxm | 1JumpEverySecond | 1 | non | Pet, ancrage d’origine conservé, 3x2x2 studs (de 1JumpEverySecond/Assets.rbxm) |
| 1JumpEverySecond_DizzyFlower.rbxm | 1JumpEverySecond | 1 | non | Pet, ancrage d’origine conservé, 3x2x2 studs (de 1JumpEverySecond/Assets.rbxm) |
| 1JumpEverySecond_FrostDragon.rbxm | 1JumpEverySecond | 1 | non | Pet, ancrage d’origine conservé, 4x3x3 studs (de 1JumpEverySecond/Assets.rbxm) |
| 1JumpEverySecond_GlowySkull.rbxm | 1JumpEverySecond | 2 | non | Pet, 1 particules/effets, ancrage d’origine conservé, 3x3x2 studs (de 1JumpEverySecond/Assets.rbxm) |
| 1JumpEverySecond_GnomeBear.rbxm | 1JumpEverySecond | 1 | non | Pet, ancrage d’origine conservé, 2x3x2 studs (de 1JumpEverySecond/Assets.rbxm) |
| 1JumpEverySecond_Husky.rbxm | 1JumpEverySecond | 1 | non | Pet, ancrage d’origine conservé, 2x2x2 studs (de 1JumpEverySecond/Assets.rbxm) |
| 1JumpEverySecond_IceCreamGnome.rbxm | 1JumpEverySecond | 2 | non | Pet, 3 particules/effets, ancrage d’origine conservé, 2x3x3 studs (de 1JumpEverySecond/Assets.rbxm) |
| 1JumpEverySecond_ImperialPenguin.rbxm | 1JumpEverySecond | 1 | non | Pet, ancrage d’origine conservé, 3x2x2 studs (de 1JumpEverySecond/Assets.rbxm) |
| 1JumpEverySecond_JellyBeanBear.rbxm | 1JumpEverySecond | 1 | non | Pet, ancrage d’origine conservé, 2x2x2 studs (de 1JumpEverySecond/Assets.rbxm) |
| 1JumpEverySecond_Marshmallow.rbxm | 1JumpEverySecond | 1 | non | Pet, ancrage d’origine conservé, 2x2x2 studs (de 1JumpEverySecond/Assets.rbxm) |
| 1JumpEverySecond_MinerDog.rbxm | 1JumpEverySecond | 1 | non | Pet, ancrage d’origine conservé, 2x2x2 studs (de 1JumpEverySecond/Assets.rbxm) |
| 1JumpEverySecond_Mushroom.rbxm | 1JumpEverySecond | 1 | non | Pet, ancrage d’origine conservé, 2x3x2 studs (de 1JumpEverySecond/Assets.rbxm) |
| 1JumpEverySecond_Narwhal.rbxm | 1JumpEverySecond | 1 | non | Pet, ancrage d’origine conservé, 3x2x2 studs (de 1JumpEverySecond/Assets.rbxm) |
| 1JumpEverySecond_Pinnata.rbxm | 1JumpEverySecond | 1 | non | Pet, ancrage d’origine conservé, 3x2x2 studs (de 1JumpEverySecond/Assets.rbxm) |
| 1JumpEverySecond_SheriffBunny.rbxm | 1JumpEverySecond | 1 | non | Pet, ancrage d’origine conservé, 2x3x2 studs (de 1JumpEverySecond/Assets.rbxm) |
| 1JumpEverySecond_SombreroCat.rbxm | 1JumpEverySecond | 1 | non | Pet, ancrage d’origine conservé, 3x3x2 studs (de 1JumpEverySecond/Assets.rbxm) |
| 1JumpEverySecond_Walrus.rbxm | 1JumpEverySecond | 1 | non | Pet, ancrage d’origine conservé, 3x1x2 studs (de 1JumpEverySecond/Assets.rbxm) |
| BakerySim_AlienRobot.rbxm | BakerySim | 2 | non | Pet, Humanoid, ancrage d’origine conservé, 2x3x2 studs (de Bakery-Simulator/Pets.rbxm) |
| BakerySim_Batty.rbxm | BakerySim | 2 | non | Pet, Humanoid, ancrage d’origine conservé, 2x3x5 studs (de Bakery-Simulator/Pets.rbxm) |
| BakerySim_BlackSheep.rbxm | BakerySim | 2 | non | Pet, Humanoid, ancrage d’origine conservé, 3x3x3 studs (de Bakery-Simulator/Pets.rbxm) |
| BakerySim_Boar.rbxm | BakerySim | 2 | non | Pet, Humanoid, ancrage d’origine conservé, 4x3x3 studs (de Bakery-Simulator/Pets.rbxm) |
| BakerySim_BrownHorse.rbxm | BakerySim | 2 | non | Pet, Humanoid, ancrage d’origine conservé, 5x4x2 studs (de Bakery-Simulator/Pets.rbxm) |
| BakerySim_BrownRabbit.rbxm | BakerySim | 2 | non | Pet, Humanoid, ancrage d’origine conservé, 3x4x2 studs (de Bakery-Simulator/Pets.rbxm) |
| BakerySim_Bull.rbxm | BakerySim | 2 | non | Pet, Humanoid, ancrage d’origine conservé, 4x3x2 studs (de Bakery-Simulator/Pets.rbxm) |
| BakerySim_Cat.rbxm | BakerySim | 4 | non | Pet, Humanoid, ancrage d’origine conservé, 2x3x3 studs (de Bakery-Simulator/Pets.rbxm) |
| BakerySim_Chick.rbxm | BakerySim | 2 | non | Pet, Humanoid, ancrage d’origine conservé, 2x2x2 studs (de Bakery-Simulator/Pets.rbxm) |
| BakerySim_Chicken.rbxm | BakerySim | 2 | non | Pet, Humanoid, ancrage d’origine conservé, 2x2x2 studs (de Bakery-Simulator/Pets.rbxm) |
| BakerySim_Cow.rbxm | BakerySim | 2 | non | Pet, Humanoid, ancrage d’origine conservé, 4x3x3 studs (de Bakery-Simulator/Pets.rbxm) |
| BakerySim_Duck.rbxm | BakerySim | 2 | non | Pet, Humanoid, ancrage d’origine conservé, 2x2x1 studs (de Bakery-Simulator/Pets.rbxm) |
| BakerySim_Goat.rbxm | BakerySim | 2 | non | Pet, Humanoid, ancrage d’origine conservé, 5x4x2 studs (de Bakery-Simulator/Pets.rbxm) |
| BakerySim_Monkey.rbxm | BakerySim | 2 | non | Pet, Humanoid, ancrage d’origine conservé, 2x2x2 studs (de Bakery-Simulator/Pets.rbxm) |
| BakerySim_Owl.rbxm | BakerySim | 2 | non | Pet, Humanoid, ancrage d’origine conservé, 2x2x2 studs (de Bakery-Simulator/Pets.rbxm) |
| BakerySim_Panther.rbxm | BakerySim | 2 | non | Pet, Humanoid, ancrage d’origine conservé, 3x3x2 studs (de Bakery-Simulator/Pets.rbxm) |
| BakerySim_Pig.rbxm | BakerySim | 2 | non | Pet, Humanoid, ancrage d’origine conservé, 4x3x3 studs (de Bakery-Simulator/Pets.rbxm) |
| BakerySim_Pup.rbxm | BakerySim | 2 | non | Pet, Humanoid, ancrage d’origine conservé, 3x3x3 studs (de Bakery-Simulator/Pets.rbxm) |
| BakerySim_Turtle.rbxm | BakerySim | 2 | non | Pet, Humanoid, ancrage d’origine conservé, 4x2x4 studs (de Bakery-Simulator/Pets.rbxm) |
| CashgrabBridge_ArcticBear.rbxm | CashgrabBridge | 3 | oui (1) | Pet, ancrage d’origine conservé, 3x3x3 studs (de CashgrabBridgeEU/Pets.rbxm) |
| CashgrabBridge_Bat.rbxm | CashgrabBridge | 7 | oui (1) | Pet, ancrage d’origine conservé, 2x3x6 studs (de CashgrabBridgeEU/Pets.rbxm) |
| CashgrabBridge_Blue.rbxm | CashgrabBridge | 5 | oui (1) | Pet, ancrage d’origine conservé, 6x8x7 studs (de CashgrabBridgeEU/Pets.rbxm) |
| CashgrabBridge_Brown.rbxm | CashgrabBridge | 2 | oui (1) | Pet, ancrage d’origine conservé, 5x11x13 studs (de CashgrabBridgeEU/Pets.rbxm) |
| CashgrabBridge_CrabbyCrab.rbxm | CashgrabBridge | 3 | oui (1) | Pet, ancrage d’origine conservé, 4x2x6 studs (de CashgrabBridgeEU/Pets.rbxm) |
| CashgrabBridge_CuddlyOctopus.rbxm | CashgrabBridge | 3 | oui (1) | Pet, ancrage d’origine conservé, 5x3x4 studs (de CashgrabBridgeEU/Pets.rbxm) |
| CashgrabBridge_Elephant.rbxm | CashgrabBridge | 6 | oui (1) | Pet, ancrage d’origine conservé, 5x2x5 studs (de CashgrabBridgeEU/Pets.rbxm) |
| CashgrabBridge_Kitty.rbxm | CashgrabBridge | 5 | oui (1) | Pet, ancrage d’origine conservé, 4x2x2 studs (de CashgrabBridgeEU/Pets.rbxm) |
| CashgrabBridge_Lion.rbxm | CashgrabBridge | 8 | oui (1) | Pet, ancrage d’origine conservé, 4x2x2 studs (de CashgrabBridgeEU/Pets.rbxm) |
| CashgrabBridge_Orange.rbxm | CashgrabBridge | 2 | oui (1) | Pet, ancrage d’origine conservé, 12x10x14 studs (de CashgrabBridgeEU/Pets.rbxm) |
| CashgrabBridge_Owl.rbxm | CashgrabBridge | 14 | oui (1) | Pet, ancrage d’origine conservé, 3x2x2 studs (de CashgrabBridgeEU/Pets.rbxm) |
| CashgrabBridge_Panda.rbxm | CashgrabBridge | 6 | oui (1) | Pet, ancrage d’origine conservé, 2x2x2 studs (de CashgrabBridgeEU/Pets.rbxm) |
| CashgrabBridge_Peacock.rbxm | CashgrabBridge | 9 | oui (1) | Pet, ancrage d’origine conservé, 2x3x5 studs (de CashgrabBridgeEU/Pets.rbxm) |
| CashgrabBridge_Penguin.rbxm | CashgrabBridge | 3 | oui (1) | Pet, ancrage d’origine conservé, 3x3x3 studs (de CashgrabBridgeEU/Pets.rbxm) |
| CashgrabBridge_Pink.rbxm | CashgrabBridge | 2 | oui (1) | Pet, ancrage d’origine conservé, 6x8x5 studs (de CashgrabBridgeEU/Pets.rbxm) |
| CashgrabBridge_Reindeer.rbxm | CashgrabBridge | 3 | oui (1) | Pet, ancrage d’origine conservé, 3x4x7 studs (de CashgrabBridgeEU/Pets.rbxm) |
| CashgrabBridge_SeaTurtle.rbxm | CashgrabBridge | 3 | oui (1) | Pet, ancrage d’origine conservé, 4x1x5 studs (de CashgrabBridgeEU/Pets.rbxm) |
| CashgrabBridge_Sheep.rbxm | CashgrabBridge | 4 | oui (1) | Pet, ancrage d’origine conservé, 2x2x3 studs (de CashgrabBridgeEU/Pets.rbxm) |
| CashgrabBridge_Sloth.rbxm | CashgrabBridge | 4 | oui (1) | Pet, ancrage d’origine conservé, 2x2x2 studs (de CashgrabBridgeEU/Pets.rbxm) |
| CashgrabBridge_Unicorn.rbxm | CashgrabBridge | 7 | oui (1) | Pet, ancrage d’origine conservé, 5x3x2 studs (de CashgrabBridgeEU/Pets.rbxm) |
| CashgrabBridge_Walrus.rbxm | CashgrabBridge | 3 | oui (1) | Pet, ancrage d’origine conservé, 4x2x2 studs (de CashgrabBridgeEU/Pets.rbxm) |
| CashgrabBridge_White.rbxm | CashgrabBridge | 5 | oui (1) | Pet, ancrage d’origine conservé, 6x9x7 studs (de CashgrabBridgeEU/Pets.rbxm) |
| CashgrabBridge_Yellow.rbxm | CashgrabBridge | 6 | oui (1) | Pet, ancrage d’origine conservé, 4x9x5 studs (de CashgrabBridgeEU/Pets.rbxm) |
| GlassBridge_DragonPlushie.rbxm | GlassBridge | 14 | non | Pet, 29x31x31 studs (de GlassBridge/Workspace/Dragon Plushie.rbxm) |
| GlassBridge_MythicKoi.rbxm | GlassBridge | 11 | non | Pet, 34x31x30 studs (de GlassBridge/Workspace/Mythic Koi.rbxm) |
| GlassBridge_MythicLuminance.rbxm | GlassBridge | 7 | non | Pet, 3 particules/effets, 39x24x36 studs (de GlassBridge/Workspace/Mythic Luminance.rbxm) |
| HatchingSim_Bear.rbxm | HatchingSim | 4 | non | Pet, ancrage d’origine conservé, 2x3x2 studs (de HatchingSimulator/GameClient.rbxm) |
| HatchingSim_Bunny.rbxm | HatchingSim | 4 | non | Pet, ancrage d’origine conservé, 3x4x2 studs (de HatchingSimulator/GameClient.rbxm) |
| HatchingSim_CrimsonOverlord.rbxm | HatchingSim | 7 | non | Pet, 1 particules/effets, ancrage d’origine conservé, 4x5x9 studs (de HatchingSimulator/GameClient.rbxm) |
| HatchingSim_CrimsonSerpent.rbxm | HatchingSim | 12 | non | Pet, 4 particules/effets, ancrage d’origine conservé, 3x5x7 studs (de HatchingSimulator/GameClient.rbxm) |
| HatchingSim_DarkDragon.rbxm | HatchingSim | 16 | non | Pet, ancrage d’origine conservé, 3x3x7 studs (de HatchingSimulator/GameClient.rbxm) |
| HatchingSim_Dino.rbxm | HatchingSim | 13 | non | Pet, ancrage d’origine conservé, 3x3x2 studs (de HatchingSimulator/GameClient.rbxm) |
| HatchingSim_Doggy.rbxm | HatchingSim | 7 | non | Pet, ancrage d’origine conservé, 3x3x3 studs (de HatchingSimulator/GameClient.rbxm) |
| HatchingSim_ElectricHydra.rbxm | HatchingSim | 9 | non | Pet, 2 particules/effets, ancrage d’origine conservé, 7x5x3 studs (de HatchingSimulator/GameClient.rbxm) |
| HatchingSim_EmeraldGolem.rbxm | HatchingSim | 4 | non | Pet, ancrage d’origine conservé, 2x4x5 studs (de HatchingSimulator/GameClient.rbxm) |
| HatchingSim_FallenAngel.rbxm | HatchingSim | 5 | non | Pet, ancrage d’origine conservé, 5x5x10 studs (de HatchingSimulator/GameClient.rbxm) |
| HatchingSim_FallenBunny.rbxm | HatchingSim | 4 | non | Pet, ancrage d’origine conservé, 3x4x2 studs (de HatchingSimulator/GameClient.rbxm) |
| HatchingSim_FallenDino.rbxm | HatchingSim | 13 | non | Pet, ancrage d’origine conservé, 3x3x2 studs (de HatchingSimulator/GameClient.rbxm) |
| HatchingSim_FallenDragon.rbxm | HatchingSim | 12 | non | Pet, ancrage d’origine conservé, 3x3x7 studs (de HatchingSimulator/GameClient.rbxm) |
| HatchingSim_FallenGolem.rbxm | HatchingSim | 4 | non | Pet, ancrage d’origine conservé, 3x4x5 studs (de HatchingSimulator/GameClient.rbxm) |
| HatchingSim_FallenOwl.rbxm | HatchingSim | 6 | non | Pet, ancrage d’origine conservé, 2x3x3 studs (de HatchingSimulator/GameClient.rbxm) |
| HatchingSim_FallenSpike.rbxm | HatchingSim | 4 | non | Pet, ancrage d’origine conservé, 2x5x2 studs (de HatchingSimulator/GameClient.rbxm) |
| HatchingSim_FallenStack.rbxm | HatchingSim | 4 | non | Pet, ancrage d’origine conservé, 3x5x3 studs (de HatchingSimulator/GameClient.rbxm) |
| HatchingSim_FlameBear.rbxm | HatchingSim | 4 | non | Pet, ancrage d’origine conservé, 2x3x2 studs (de HatchingSimulator/GameClient.rbxm) |
| HatchingSim_FlameCube.rbxm | HatchingSim | 6 | non | Pet, 1 particules/effets, ancrage d’origine conservé, 2x3x2 studs (de HatchingSimulator/GameClient.rbxm) |
| HatchingSim_FlameDoggy.rbxm | HatchingSim | 7 | non | Pet, ancrage d’origine conservé, 3x3x3 studs (de HatchingSimulator/GameClient.rbxm) |
| HatchingSim_FlameDragon.rbxm | HatchingSim | 13 | non | Pet, 1 particules/effets, ancrage d’origine conservé, 3x3x7 studs (de HatchingSimulator/GameClient.rbxm) |
| HatchingSim_FlameKitty.rbxm | HatchingSim | 4 | non | Pet, ancrage d’origine conservé, 4x3x2 studs (de HatchingSimulator/GameClient.rbxm) |
| HatchingSim_FlameMarshmallow.rbxm | HatchingSim | 5 | non | Pet, ancrage d’origine conservé, 3x3x5 studs (de HatchingSimulator/GameClient.rbxm) |
| HatchingSim_FrostBoi.rbxm | HatchingSim | 3 | non | Pet, ancrage d’origine conservé, 3x3x2 studs (de HatchingSimulator/GameClient.rbxm) |
| HatchingSim_FrostDoggy.rbxm | HatchingSim | 7 | non | Pet, ancrage d’origine conservé, 3x3x3 studs (de HatchingSimulator/GameClient.rbxm) |
| HatchingSim_FrostGolem.rbxm | HatchingSim | 4 | non | Pet, ancrage d’origine conservé, 2x4x5 studs (de HatchingSimulator/GameClient.rbxm) |
| HatchingSim_FrostKitty.rbxm | HatchingSim | 4 | non | Pet, ancrage d’origine conservé, 4x3x2 studs (de HatchingSimulator/GameClient.rbxm) |
| HatchingSim_FrostUnicorn.rbxm | HatchingSim | 4 | non | Pet, ancrage d’origine conservé, 3x4x3 studs (de HatchingSimulator/GameClient.rbxm) |
| HatchingSim_GalacticDino.rbxm | HatchingSim | 13 | non | Pet, ancrage d’origine conservé, 3x3x2 studs (de HatchingSimulator/GameClient.rbxm) |
| HatchingSim_GalacticDragon.rbxm | HatchingSim | 12 | non | Pet, ancrage d’origine conservé, 3x3x7 studs (de HatchingSimulator/GameClient.rbxm) |
| HatchingSim_GalacticElemental.rbxm | HatchingSim | 3 | non | Pet, 4 particules/effets, ancrage d’origine conservé, 3x3x3 studs (de HatchingSimulator/GameClient.rbxm) |
| HatchingSim_GalacticGolem.rbxm | HatchingSim | 4 | non | Pet, ancrage d’origine conservé, 2x4x5 studs (de HatchingSimulator/GameClient.rbxm) |
| HatchingSim_GalacticSerpent.rbxm | HatchingSim | 12 | non | Pet, 4 particules/effets, ancrage d’origine conservé, 3x5x7 studs (de HatchingSimulator/GameClient.rbxm) |
| HatchingSim_GalacticSpikey.rbxm | HatchingSim | 4 | non | Pet, ancrage d’origine conservé, 2x5x2 studs (de HatchingSimulator/GameClient.rbxm) |
| HatchingSim_GalacticUnicorn.rbxm | HatchingSim | 4 | non | Pet, ancrage d’origine conservé, 3x4x3 studs (de HatchingSimulator/GameClient.rbxm) |
| HatchingSim_Golem.rbxm | HatchingSim | 4 | non | Pet, ancrage d’origine conservé, 3x4x5 studs (de HatchingSimulator/GameClient.rbxm) |
| HatchingSim_IceSpikey.rbxm | HatchingSim | 4 | non | Pet, ancrage d’origine conservé, 2x5x2 studs (de HatchingSimulator/GameClient.rbxm) |
| HatchingSim_Kitty.rbxm | HatchingSim | 4 | non | Pet, ancrage d’origine conservé, 4x3x2 studs (de HatchingSimulator/GameClient.rbxm) |
| HatchingSim_Owl.rbxm | HatchingSim | 6 | non | Pet, ancrage d’origine conservé, 2x3x3 studs (de HatchingSimulator/GameClient.rbxm) |
| HatchingSim_Panda.rbxm | HatchingSim | 4 | non | Pet, ancrage d’origine conservé, 2x3x2 studs (de HatchingSimulator/GameClient.rbxm) |
| HatchingSim_PastelShock.rbxm | HatchingSim | 7 | non | Pet, ancrage d’origine conservé, 3x3x3 studs (de HatchingSimulator/GameClient.rbxm) |
| HatchingSim_ReleaseBoi.rbxm | HatchingSim | 3 | non | Pet, ancrage d’origine conservé, 3x3x3 studs (de HatchingSimulator/GameClient.rbxm) |
| HatchingSim_ReleaseCone.rbxm | HatchingSim | 4 | non | Pet, ancrage d’origine conservé, 3x5x3 studs (de HatchingSimulator/GameClient.rbxm) |
| HatchingSim_ReleaseDino.rbxm | HatchingSim | 4 | non | Pet, ancrage d’origine conservé, 3x3x3 studs (de HatchingSimulator/GameClient.rbxm) |
| HatchingSim_ReleaseGolem.rbxm | HatchingSim | 4 | non | Pet, ancrage d’origine conservé, 3x4x5 studs (de HatchingSimulator/GameClient.rbxm) |
| HatchingSim_ReleaseSphere.rbxm | HatchingSim | 4 | non | Pet, ancrage d’origine conservé, 3x4x3 studs (de HatchingSimulator/GameClient.rbxm) |
| HatchingSim_ReleaseStack.rbxm | HatchingSim | 4 | non | Pet, ancrage d’origine conservé, 3x5x3 studs (de HatchingSimulator/GameClient.rbxm) |
| HatchingSim_RockBoi.rbxm | HatchingSim | 3 | non | Pet, ancrage d’origine conservé, 3x3x2 studs (de HatchingSimulator/GameClient.rbxm) |
| HatchingSim_SnowOwl.rbxm | HatchingSim | 6 | non | Pet, ancrage d’origine conservé, 2x3x3 studs (de HatchingSimulator/GameClient.rbxm) |
| HatchingSim_Spikey.rbxm | HatchingSim | 4 | non | Pet, ancrage d’origine conservé, 2x5x2 studs (de HatchingSimulator/GameClient.rbxm) |
| HatchingSim_TheOverlord.rbxm | HatchingSim | 7 | non | Pet, 1 particules/effets, ancrage d’origine conservé, 4x5x9 studs (de HatchingSimulator/GameClient.rbxm) |
| HatchingSim_Trophy.rbxm | HatchingSim | 33 | non | Pet, ancrage d’origine conservé, 6x10x10 studs (de HatchingSimulator/GameClient.rbxm) |
| HatchingSim_VoidBoi.rbxm | HatchingSim | 3 | non | Pet, ancrage d’origine conservé, 3x3x3 studs (de HatchingSimulator/GameClient.rbxm) |
| HatchingSim_VoidBunny.rbxm | HatchingSim | 4 | non | Pet, ancrage d’origine conservé, 3x4x2 studs (de HatchingSimulator/GameClient.rbxm) |
| HatchingSim_VoidKitty.rbxm | HatchingSim | 4 | non | Pet, ancrage d’origine conservé, 4x3x2 studs (de HatchingSimulator/GameClient.rbxm) |
| HatchingSim_VoidMarshmallow.rbxm | HatchingSim | 5 | non | Pet, ancrage d’origine conservé, 3x3x5 studs (de HatchingSimulator/GameClient.rbxm) |
| HatchingSim_VoidOwl.rbxm | HatchingSim | 6 | non | Pet, ancrage d’origine conservé, 2x3x3 studs (de HatchingSimulator/GameClient.rbxm) |
| HatchingSim_VoidPhoniex.rbxm | HatchingSim | 3 | non | Pet, ancrage d’origine conservé, 3x3x4 studs (de HatchingSimulator/GameClient.rbxm) |
| HatchingSim_VoidSphere.rbxm | HatchingSim | 4 | non | Pet, ancrage d’origine conservé, 3x4x3 studs (de HatchingSimulator/GameClient.rbxm) |
| HatchingSim_VoidStack.rbxm | HatchingSim | 4 | non | Pet, ancrage d’origine conservé, 3x5x3 studs (de HatchingSimulator/GameClient.rbxm) |
| MagnetSim2_BlueHornedDragon.rbxm | MagnetSim2 | 9 | non | Pet, Humanoid, 2 particules/effets, ancrage d’origine conservé, 2x2x4 studs (de UNCOPYLOCKED-Magnet-Simulator-2/Models.rbxm) |
| MagnetSim2_Elephant.rbxm | MagnetSim2 | 4 | non | Pet, Humanoid, ancrage d’origine conservé, 5x3x5 studs (de UNCOPYLOCKED-Magnet-Simulator-2/Models.rbxm) |
| MagnetSim2_Fox.rbxm | MagnetSim2 | 21 | non | Pet, Humanoid, ancrage d’origine conservé, 3x3x3 studs (de UNCOPYLOCKED-Magnet-Simulator-2/Models.rbxm) |
| MagnetSim2_GreenDragon.rbxm | MagnetSim2 | 6 | non | Pet, Humanoid, 1 particules/effets, ancrage d’origine conservé, 2x2x4 studs (de UNCOPYLOCKED-Magnet-Simulator-2/Models.rbxm) |
| MagnetSim2_HappyFudgicle.rbxm | MagnetSim2 | 12 | non | Pet, Humanoid, ancrage d’origine conservé, 2x4x2 studs (de UNCOPYLOCKED-Magnet-Simulator-2/Models.rbxm) |
| MagnetSim2_HardHatParrot.rbxm | MagnetSim2 | 8 | non | Pet, Humanoid, ancrage d’origine conservé, 2x2x2 studs (de UNCOPYLOCKED-Magnet-Simulator-2/Models.rbxm) |
| MagnetSim2_IceFiend.rbxm | MagnetSim2 | 21 | non | Pet, Humanoid, ancrage d’origine conservé, 2x3x3 studs (de UNCOPYLOCKED-Magnet-Simulator-2/Models.rbxm) |
| MagnetSim2_MagmaFiend.rbxm | MagnetSim2 | 21 | non | Pet, Humanoid, ancrage d’origine conservé, 2x3x3 studs (de UNCOPYLOCKED-Magnet-Simulator-2/Models.rbxm) |
| MagnetSim2_OrangeCat.rbxm | MagnetSim2 | 5 | non | Pet, Humanoid, ancrage d’origine conservé, 2x2x2 studs (de UNCOPYLOCKED-Magnet-Simulator-2/Models.rbxm) |
| MagnetSim2_SadFudgicle.rbxm | MagnetSim2 | 15 | non | Pet, Humanoid, ancrage d’origine conservé, 2x4x2 studs (de UNCOPYLOCKED-Magnet-Simulator-2/Models.rbxm) |
| MagnetSim2_Stud.rbxm | MagnetSim2 | 3 | non | Pet, Humanoid, ancrage d’origine conservé, 2x2x2 studs (de UNCOPYLOCKED-Magnet-Simulator-2/Models.rbxm) |
| MiningMasters_ArticCat.rbxm | MiningMasters | 10 | non | Pet, ancrage d’origine conservé, 3x3x2 studs (de Mining-Masters/Pets.rbxm) |
| MiningMasters_ArticFox.rbxm | MiningMasters | 10 | non | Pet, ancrage d’origine conservé, 2x3x4 studs (de Mining-Masters/Pets.rbxm) |
| MiningMasters_Bat.rbxm | MiningMasters | 10 | non | Pet, ancrage d’origine conservé, 4x3x2 studs (de Mining-Masters/Pets.rbxm) |
| MiningMasters_Bear.rbxm | MiningMasters | 10 | non | Pet, ancrage d’origine conservé, 3x3x3 studs (de Mining-Masters/Pets.rbxm) |
| MiningMasters_BlueDog.rbxm | MiningMasters | 10 | non | Pet, ancrage d’origine conservé, 5x4x6 studs (de Mining-Masters/Pets.rbxm) |
| MiningMasters_BlueFish.rbxm | MiningMasters | 2 | non | Pet, ancrage d’origine conservé, 3x2x2 studs (de Mining-Masters/Pets.rbxm) |
| MiningMasters_Bunny.rbxm | MiningMasters | 9 | non | Pet, ancrage d’origine conservé, 3x5x5 studs (de Mining-Masters/Pets.rbxm) |
| MiningMasters_Bunny_2.rbxm | MiningMasters | 10 | non | Pet, 3x4x3 studs (de Mining-Masters/Workspace/Bunny.rbxm) |
| MiningMasters_Camel.rbxm | MiningMasters | 8 | non | Pet, ancrage d’origine conservé, 2x3x2 studs (de Mining-Masters/Pets.rbxm) |
| MiningMasters_Cat.rbxm | MiningMasters | 9 | non | Pet, ancrage d’origine conservé, 3x4x4 studs (de Mining-Masters/Pets.rbxm) |
| MiningMasters_Cat_2.rbxm | MiningMasters | 10 | non | Pet, 3x4x4 studs (de Mining-Masters/Workspace/Cat.rbxm) |
| MiningMasters_Cheetah.rbxm | MiningMasters | 4 | non | Pet, ancrage d’origine conservé, 4x3x2 studs (de Mining-Masters/Pets.rbxm) |
| MiningMasters_CookieCat.rbxm | MiningMasters | 5 | non | Pet, ancrage d’origine conservé, 3x3x2 studs (de Mining-Masters/Pets.rbxm) |
| MiningMasters_Crocodile.rbxm | MiningMasters | 4 | non | Pet, ancrage d’origine conservé, 2x2x2 studs (de Mining-Masters/Pets.rbxm) |
| MiningMasters_Dog.rbxm | MiningMasters | 9 | non | Pet, ancrage d’origine conservé, 3x4x5 studs (de Mining-Masters/Pets.rbxm) |
| MiningMasters_Dog_2.rbxm | MiningMasters | 10 | non | Pet, 4x4x4 studs (de Mining-Masters/Workspace/Dog.rbxm) |
| MiningMasters_Dragon.rbxm | MiningMasters | 12 | non | Pet, ancrage d’origine conservé, 7x4x4 studs (de Mining-Masters/Pets.rbxm) |
| MiningMasters_FennecFox.rbxm | MiningMasters | 10 | non | Pet, ancrage d’origine conservé, 2x4x4 studs (de Mining-Masters/Pets.rbxm) |
| MiningMasters_FireCat.rbxm | MiningMasters | 10 | non | Pet, ancrage d’origine conservé, 2x3x4 studs (de Mining-Masters/Pets.rbxm) |
| MiningMasters_FireDog.rbxm | MiningMasters | 10 | non | Pet, ancrage d’origine conservé, 4x2x4 studs (de Mining-Masters/Pets.rbxm) |
| MiningMasters_FirePegasus.rbxm | MiningMasters | 12 | non | Pet, ancrage d’origine conservé, 8x4x3 studs (de Mining-Masters/Pets.rbxm) |
| MiningMasters_FireSlime.rbxm | MiningMasters | 1 | non | Pet, ancrage d’origine conservé, 2x2x2 studs (de Mining-Masters/Pets.rbxm) |
| MiningMasters_Fish.rbxm | MiningMasters | 5 | non | Pet, ancrage d’origine conservé, 3x3x2 studs (de Mining-Masters/Pets.rbxm) |
| MiningMasters_Fox.rbxm | MiningMasters | 10 | non | Pet, ancrage d’origine conservé, 2x4x4 studs (de Mining-Masters/Pets.rbxm) |
| MiningMasters_GingerbreadDog.rbxm | MiningMasters | 11 | non | Pet, ancrage d’origine conservé, 4x3x3 studs (de Mining-Masters/Pets.rbxm) |
| MiningMasters_GoldenArticCat.rbxm | MiningMasters | 10 | non | Pet, ancrage d’origine conservé, 2x3x3 studs (de Mining-Masters/Pets.rbxm) |
| MiningMasters_GoldenArticFox.rbxm | MiningMasters | 10 | non | Pet, ancrage d’origine conservé, 2x3x4 studs (de Mining-Masters/Pets.rbxm) |
| MiningMasters_GoldenBat.rbxm | MiningMasters | 10 | non | Pet, ancrage d’origine conservé, 4x3x2 studs (de Mining-Masters/Pets.rbxm) |
| MiningMasters_GoldenBear.rbxm | MiningMasters | 10 | non | Pet, ancrage d’origine conservé, 3x3x3 studs (de Mining-Masters/Pets.rbxm) |
| MiningMasters_GoldenBlueFish.rbxm | MiningMasters | 2 | non | Pet, ancrage d’origine conservé, 3x2x2 studs (de Mining-Masters/Pets.rbxm) |
| MiningMasters_GoldenBunny.rbxm | MiningMasters | 9 | non | Pet, ancrage d’origine conservé, 5x5x3 studs (de Mining-Masters/Pets.rbxm) |
| MiningMasters_GoldenCamel.rbxm | MiningMasters | 8 | non | Pet, ancrage d’origine conservé, 2x3x2 studs (de Mining-Masters/Pets.rbxm) |
| MiningMasters_GoldenCat.rbxm | MiningMasters | 9 | non | Pet, ancrage d’origine conservé, 4x4x3 studs (de Mining-Masters/Pets.rbxm) |
| MiningMasters_GoldenCheetah.rbxm | MiningMasters | 5 | non | Pet, ancrage d’origine conservé, 4x3x2 studs (de Mining-Masters/Pets.rbxm) |
| MiningMasters_GoldenCookieCat.rbxm | MiningMasters | 5 | non | Pet, ancrage d’origine conservé, 3x3x2 studs (de Mining-Masters/Pets.rbxm) |
| MiningMasters_GoldenDog.rbxm | MiningMasters | 9 | non | Pet, ancrage d’origine conservé, 5x4x3 studs (de Mining-Masters/Pets.rbxm) |
| MiningMasters_GoldenDragon.rbxm | MiningMasters | 12 | non | Pet, ancrage d’origine conservé, 4x4x7 studs (de Mining-Masters/Pets.rbxm) |
| MiningMasters_GoldenFennecFox.rbxm | MiningMasters | 10 | non | Pet, ancrage d’origine conservé, 2x4x4 studs (de Mining-Masters/Pets.rbxm) |
| MiningMasters_GoldenFireCat.rbxm | MiningMasters | 10 | non | Pet, ancrage d’origine conservé, 2x3x4 studs (de Mining-Masters/Pets.rbxm) |
| MiningMasters_GoldenFireDog.rbxm | MiningMasters | 10 | non | Pet, ancrage d’origine conservé, 4x2x4 studs (de Mining-Masters/Pets.rbxm) |
| MiningMasters_GoldenFirePegasus.rbxm | MiningMasters | 12 | non | Pet, ancrage d’origine conservé, 8x4x3 studs (de Mining-Masters/Pets.rbxm) |
| MiningMasters_GoldenFireSlime.rbxm | MiningMasters | 1 | non | Pet, ancrage d’origine conservé, 2x2x2 studs (de Mining-Masters/Pets.rbxm) |
| MiningMasters_GoldenFish.rbxm | MiningMasters | 5 | non | Pet, ancrage d’origine conservé, 3x3x2 studs (de Mining-Masters/Pets.rbxm) |
| MiningMasters_GoldenFox.rbxm | MiningMasters | 10 | non | Pet, ancrage d’origine conservé, 4x4x2 studs (de Mining-Masters/Pets.rbxm) |
| MiningMasters_GoldenGingerbreadDog.rbxm | MiningMasters | 11 | non | Pet, ancrage d’origine conservé, 4x3x3 studs (de Mining-Masters/Pets.rbxm) |
| MiningMasters_GoldenGreenGecko.rbxm | MiningMasters | 4 | non | Pet, ancrage d’origine conservé, 2x2x3 studs (de Mining-Masters/Pets.rbxm) |
| MiningMasters_GoldenGriffin.rbxm | MiningMasters | 9 | non | Pet, ancrage d’origine conservé, 7x4x5 studs (de Mining-Masters/Pets.rbxm) |
| MiningMasters_GoldenHugeCrab.rbxm | MiningMasters | 5 | non | Pet, ancrage d’origine conservé, 9x7x7 studs (de Mining-Masters/Pets.rbxm) |
| MiningMasters_GoldenHugeDonut.rbxm | MiningMasters | 3 | non | Pet, ancrage d’origine conservé, 6x6x6 studs (de Mining-Masters/Pets.rbxm) |
| MiningMasters_GoldenHugeFirePegasus.rbxm | MiningMasters | 12 | non | Pet, ancrage d’origine conservé, 21x11x8 studs (de Mining-Masters/Pets.rbxm) |
| MiningMasters_GoldenHugeGriffin.rbxm | MiningMasters | 9 | non | Pet, ancrage d’origine conservé, 18x11x12 studs (de Mining-Masters/Pets.rbxm) |
| MiningMasters_GoldenHugeKillerDog.rbxm | MiningMasters | 2 | non | Pet, ancrage d’origine conservé, 12x7x10 studs (de Mining-Masters/Pets.rbxm) |
| MiningMasters_GoldenHugeLion.rbxm | MiningMasters | 9 | non | Pet, ancrage d’origine conservé, 6x9x10 studs (de Mining-Masters/Pets.rbxm) |
| MiningMasters_GoldenHugeMegaRobot.rbxm | MiningMasters | 15 | non | Pet, ancrage d’origine conservé, 13x8x17 studs (de Mining-Masters/Pets.rbxm) |
| MiningMasters_GoldenHugeMonkey.rbxm | MiningMasters | 4 | non | Pet, ancrage d’origine conservé, 6x6x9 studs (de Mining-Masters/Pets.rbxm) |
| MiningMasters_GoldenHugeReindeer.rbxm | MiningMasters | 5 | non | Pet, ancrage d’origine conservé, 8x12x8 studs (de Mining-Masters/Pets.rbxm) |
| MiningMasters_GoldenLollipop.rbxm | MiningMasters | 3 | non | Pet, ancrage d’origine conservé, 2x3x2 studs (de Mining-Masters/Pets.rbxm) |
| MiningMasters_GoldenMarshMallow.rbxm | MiningMasters | 2 | non | Pet, ancrage d’origine conservé, 2x2x2 studs (de Mining-Masters/Pets.rbxm) |
| MiningMasters_GoldenMegaRobot.rbxm | MiningMasters | 15 | non | Pet, ancrage d’origine conservé, 5x4x7 studs (de Mining-Masters/Pets.rbxm) |
| MiningMasters_GoldenOctopus.rbxm | MiningMasters | 2 | non | Pet, ancrage d’origine conservé, 2x2x2 studs (de Mining-Masters/Pets.rbxm) |
| MiningMasters_GoldenPanther.rbxm | MiningMasters | 10 | non | Pet, ancrage d’origine conservé, 2x3x4 studs (de Mining-Masters/Pets.rbxm) |
| MiningMasters_GoldenPenguin.rbxm | MiningMasters | 4 | non | Pet, ancrage d’origine conservé, 4x2x2 studs (de Mining-Masters/Pets.rbxm) |
| MiningMasters_GoldenPurpleGecko.rbxm | MiningMasters | 4 | non | Pet, ancrage d’origine conservé, 2x2x3 studs (de Mining-Masters/Pets.rbxm) |
| MiningMasters_GoldenSandCat.rbxm | MiningMasters | 10 | non | Pet, ancrage d’origine conservé, 2x3x4 studs (de Mining-Masters/Pets.rbxm) |
| MiningMasters_GoldenScienceBunny.rbxm | MiningMasters | 13 | non | Pet, ancrage d’origine conservé, 3x4x2 studs (de Mining-Masters/Pets.rbxm) |
| MiningMasters_GoldenScienceCat.rbxm | MiningMasters | 13 | non | Pet, ancrage d’origine conservé, 4x3x2 studs (de Mining-Masters/Pets.rbxm) |
| MiningMasters_GoldenScienceDog.rbxm | MiningMasters | 13 | non | Pet, ancrage d’origine conservé, 4x3x4 studs (de Mining-Masters/Pets.rbxm) |
| MiningMasters_GoldenSeahorse.rbxm | MiningMasters | 3 | non | Pet, ancrage d’origine conservé, 2x2x2 studs (de Mining-Masters/Pets.rbxm) |
| MiningMasters_GoldenShark.rbxm | MiningMasters | 3 | non | Pet, ancrage d’origine conservé, 3x2x4 studs (de Mining-Masters/Pets.rbxm) |
| MiningMasters_GoldenSnake.rbxm | MiningMasters | 3 | non | Pet, ancrage d’origine conservé, 2x2x4 studs (de Mining-Masters/Pets.rbxm) |
| MiningMasters_GoldenSnowMan.rbxm | MiningMasters | 7 | non | Pet, ancrage d’origine conservé, 4x4x3 studs (de Mining-Masters/Pets.rbxm) |
| MiningMasters_GoldenStarFish.rbxm | MiningMasters | 8 | non | Pet, ancrage d’origine conservé, 2x2x1 studs (de Mining-Masters/Pets.rbxm) |
| MiningMasters_Gorilla.rbxm | MiningMasters | 2 | non | Pet, ancrage d’origine conservé, 2x2x2 studs (de Mining-Masters/Pets.rbxm) |
| MiningMasters_GreenGecko.rbxm | MiningMasters | 4 | non | Pet, ancrage d’origine conservé, 2x2x3 studs (de Mining-Masters/Pets.rbxm) |
| MiningMasters_Griffin.rbxm | MiningMasters | 9 | non | Pet, ancrage d’origine conservé, 7x4x5 studs (de Mining-Masters/Pets.rbxm) |
| MiningMasters_GroupPets.rbxm | MiningMasters | 17 | non | Pet, prompt/clic, SurfaceGui/Billboard, ancrage d’origine conservé, 12x12x13 studs (de Mining-Masters/Workspace/GroupPets.rbxm) |
| MiningMasters_HugeCat.rbxm | MiningMasters | 10 | non | Pet, ancrage d’origine conservé, 5x7x8 studs (de Mining-Masters/Pets.rbxm) |
| MiningMasters_HugeCrab.rbxm | MiningMasters | 5 | non | Pet, ancrage d’origine conservé, 9x7x7 studs (de Mining-Masters/Pets.rbxm) |
| MiningMasters_HugeDog.rbxm | MiningMasters | 10 | non | Pet, ancrage d’origine conservé, 7x5x8 studs (de Mining-Masters/Pets.rbxm) |
| MiningMasters_HugeDonut.rbxm | MiningMasters | 3 | non | Pet, ancrage d’origine conservé, 6x6x6 studs (de Mining-Masters/Pets.rbxm) |
| MiningMasters_HugeDragon.rbxm | MiningMasters | 12 | non | Pet, ancrage d’origine conservé, 13x9x9 studs (de Mining-Masters/Pets.rbxm) |
| MiningMasters_HugeFirePegasus.rbxm | MiningMasters | 12 | non | Pet, ancrage d’origine conservé, 21x11x8 studs (de Mining-Masters/Pets.rbxm) |
| MiningMasters_HugeGriffin.rbxm | MiningMasters | 9 | non | Pet, ancrage d’origine conservé, 18x11x12 studs (de Mining-Masters/Pets.rbxm) |
| MiningMasters_HugeKillerDog.rbxm | MiningMasters | 2 | non | Pet, ancrage d’origine conservé, 12x7x10 studs (de Mining-Masters/Pets.rbxm) |
| MiningMasters_HugeLion.rbxm | MiningMasters | 9 | non | Pet, ancrage d’origine conservé, 6x9x10 studs (de Mining-Masters/Pets.rbxm) |
| MiningMasters_HugeMegaRobot.rbxm | MiningMasters | 15 | non | Pet, ancrage d’origine conservé, 17x8x13 studs (de Mining-Masters/Pets.rbxm) |
| MiningMasters_HugeMonkey.rbxm | MiningMasters | 4 | non | Pet, ancrage d’origine conservé, 6x6x9 studs (de Mining-Masters/Pets.rbxm) |
| MiningMasters_HugeReindeer.rbxm | MiningMasters | 5 | non | Pet, ancrage d’origine conservé, 8x12x8 studs (de Mining-Masters/Pets.rbxm) |
| MiningMasters_HugeRobuxDoggy.rbxm | MiningMasters | 4 | non | Pet, ancrage d’origine conservé, 9x8x9 studs (de Mining-Masters/Pets.rbxm) |
| MiningMasters_Lollipop.rbxm | MiningMasters | 3 | non | Pet, ancrage d’origine conservé, 2x3x2 studs (de Mining-Masters/Pets.rbxm) |
| MiningMasters_MarshMallow.rbxm | MiningMasters | 2 | non | Pet, ancrage d’origine conservé, 2x2x2 studs (de Mining-Masters/Pets.rbxm) |
| MiningMasters_MegaRobot.rbxm | MiningMasters | 15 | non | Pet, ancrage d’origine conservé, 7x4x5 studs (de Mining-Masters/Pets.rbxm) |
| MiningMasters_Octopus.rbxm | MiningMasters | 2 | non | Pet, ancrage d’origine conservé, 2x2x2 studs (de Mining-Masters/Pets.rbxm) |
| MiningMasters_Panther.rbxm | MiningMasters | 10 | non | Pet, ancrage d’origine conservé, 2x3x4 studs (de Mining-Masters/Pets.rbxm) |
| MiningMasters_Parrot.rbxm | MiningMasters | 3 | non | Pet, ancrage d’origine conservé, 2x2x5 studs (de Mining-Masters/Pets.rbxm) |
| MiningMasters_Penguin.rbxm | MiningMasters | 4 | non | Pet, ancrage d’origine conservé, 4x2x2 studs (de Mining-Masters/Pets.rbxm) |
| MiningMasters_PurpleFish.rbxm | MiningMasters | 2 | non | Pet, ancrage d’origine conservé, 3x2x2 studs (de Mining-Masters/Pets.rbxm) |
| MiningMasters_PurpleGecko.rbxm | MiningMasters | 4 | non | Pet, ancrage d’origine conservé, 2x2x3 studs (de Mining-Masters/Pets.rbxm) |
| MiningMasters_RedFish.rbxm | MiningMasters | 2 | non | Pet, ancrage d’origine conservé, 3x2x2 studs (de Mining-Masters/Pets.rbxm) |
| MiningMasters_RobuxDoggy.rbxm | MiningMasters | 4 | non | Pet, ancrage d’origine conservé, 11x9x10 studs (de Mining-Masters/Pets.rbxm) |
| MiningMasters_RobuxKitty.rbxm | MiningMasters | 5 | non | Pet, ancrage d’origine conservé, 10x9x8 studs (de Mining-Masters/Pets.rbxm) |
| MiningMasters_SandCat.rbxm | MiningMasters | 10 | non | Pet, ancrage d’origine conservé, 2x3x4 studs (de Mining-Masters/Pets.rbxm) |
| MiningMasters_ScienceBunny.rbxm | MiningMasters | 13 | non | Pet, ancrage d’origine conservé, 2x4x3 studs (de Mining-Masters/Pets.rbxm) |
| MiningMasters_ScienceCat.rbxm | MiningMasters | 13 | non | Pet, ancrage d’origine conservé, 2x3x4 studs (de Mining-Masters/Pets.rbxm) |
| MiningMasters_ScienceDog.rbxm | MiningMasters | 13 | non | Pet, ancrage d’origine conservé, 4x3x4 studs (de Mining-Masters/Pets.rbxm) |
| MiningMasters_Seahorse.rbxm | MiningMasters | 3 | non | Pet, ancrage d’origine conservé, 2x2x2 studs (de Mining-Masters/Pets.rbxm) |
| MiningMasters_Shark.rbxm | MiningMasters | 3 | non | Pet, ancrage d’origine conservé, 3x2x4 studs (de Mining-Masters/Pets.rbxm) |
| MiningMasters_Snake.rbxm | MiningMasters | 3 | non | Pet, ancrage d’origine conservé, 2x2x4 studs (de Mining-Masters/Pets.rbxm) |
| MiningMasters_SnowMan.rbxm | MiningMasters | 7 | non | Pet, ancrage d’origine conservé, 4x4x3 studs (de Mining-Masters/Pets.rbxm) |
| MiningMasters_StarFish.rbxm | MiningMasters | 8 | non | Pet, ancrage d’origine conservé, 2x2x1 studs (de Mining-Masters/Pets.rbxm) |
| MiningMasters_Turtle.rbxm | MiningMasters | 3 | non | Pet, ancrage d’origine conservé, 2x3x3 studs (de Mining-Masters/Pets.rbxm) |
| PetPharmica_1kAxolotl.rbxm | PetPharmica | 14 | non | Pet, variantes source: golden, ancrage d’origine conservé, 2x2x2 studs (de Pet_Pharmica_1_1/Pets.rbxm) |
| PetPharmica_1kBunny.rbxm | PetPharmica | 8 | non | Pet, variantes source: golden, ancrage d’origine conservé, 2x3x2 studs (de Pet_Pharmica_1_1/Pets.rbxm) |
| PetPharmica_1kButterfly.rbxm | PetPharmica | 7 | non | Pet, variantes source: golden, ancrage d’origine conservé, 2x2x2 studs (de Pet_Pharmica_1_1/Pets.rbxm) |
| PetPharmica_1kDeer.rbxm | PetPharmica | 8 | non | Pet, variantes source: golden, ancrage d’origine conservé, 1x2x1 studs (de Pet_Pharmica_1_1/Pets.rbxm) |
| PetPharmica_1kDog.rbxm | PetPharmica | 5 | non | Pet, variantes source: golden, ancrage d’origine conservé, 3x3x2 studs (de Pet_Pharmica_1_1/Pets.rbxm) |
| PetPharmica_1kGuest.rbxm | PetPharmica | 6 | non | Pet, variantes source: golden, ancrage d’origine conservé, 2x3x2 studs (de Pet_Pharmica_1_1/Pets.rbxm) |
| PetPharmica_1kHugeCat.rbxm | PetPharmica | 7 | non | Pet, variantes source: golden, ancrage d’origine conservé, 5x5x4 studs (de Pet_Pharmica_1_1/Pets.rbxm) |
| PetPharmica_1kHugeDog.rbxm | PetPharmica | 5 | non | Pet, variantes source: golden, ancrage d’origine conservé, 9x9x6 studs (de Pet_Pharmica_1_1/Pets.rbxm) |
| PetPharmica_1kLord.rbxm | PetPharmica | 36 | non | Pet, variantes source: golden, 21 particules/effets, ancrage d’origine conservé, 3x3x3 studs (de Pet_Pharmica_1_1/Pets.rbxm) |
| PetPharmica_1kPearl.rbxm | PetPharmica | 2 | non | Pet, variantes source: golden, ancrage d’origine conservé, 3x3x3 studs (de Pet_Pharmica_1_1/Pets.rbxm) |
| PetPharmica_1kTurtle.rbxm | PetPharmica | 6 | non | Pet, variantes source: golden, ancrage d’origine conservé, 2x3x2 studs (de Pet_Pharmica_1_1/Pets.rbxm) |
| PetPharmica_Arcc.rbxm | PetPharmica | 31 | non | Pet, ancrage d’origine conservé, 10x7x9 studs (de Pet_Pharmica_1_1/Pets.rbxm) |
| PetPharmica_Axolotl.rbxm | PetPharmica | 13 | non | Pet, variantes source: golden, ancrage d’origine conservé, 2x2x2 studs (de Pet_Pharmica_1_1/Pets.rbxm) |
| PetPharmica_Bear.rbxm | PetPharmica | 8 | non | Pet, variantes source: golden/toxic, ancrage d’origine conservé, 2x2x2 studs (de Pet_Pharmica_1_1/Pets.rbxm) |
| PetPharmica_BlueFroggy.rbxm | PetPharmica | 12 | non | Pet, variantes source: golden/toxic, ancrage d’origine conservé, 3x4x3 studs (de Pet_Pharmica_1_1/Pets.rbxm) |
| PetPharmica_Bull.rbxm | PetPharmica | 8 | non | Pet, variantes source: golden/toxic, ancrage d’origine conservé, 2x2x2 studs (de Pet_Pharmica_1_1/Pets.rbxm) |
| PetPharmica_Bunny.rbxm | PetPharmica | 7 | non | Pet, variantes source: golden/toxic, ancrage d’origine conservé, 2x2x2 studs (de Pet_Pharmica_1_1/Pets.rbxm) |
| PetPharmica_Butterfly.rbxm | PetPharmica | 6 | non | Pet, variantes source: golden, ancrage d’origine conservé, 2x1x2 studs (de Pet_Pharmica_1_1/Pets.rbxm) |
| PetPharmica_CactusDog.rbxm | PetPharmica | 4 | non | Pet, variantes source: golden/toxic, ancrage d’origine conservé, 3x2x2 studs (de Pet_Pharmica_1_1/Pets.rbxm) |
| PetPharmica_Cat.rbxm | PetPharmica | 6 | non | Pet, variantes source: golden/toxic, ancrage d’origine conservé, 2x2x2 studs (de Pet_Pharmica_1_1/Pets.rbxm) |
| PetPharmica_CoconutLord.rbxm | PetPharmica | 15 | non | Pet, variantes source: golden, ancrage d’origine conservé, 2x2x4 studs (de Pet_Pharmica_1_1/Pets.rbxm) |
| PetPharmica_Deer.rbxm | PetPharmica | 7 | non | Pet, variantes source: golden/toxic, ancrage d’origine conservé, 1x2x1 studs (de Pet_Pharmica_1_1/Pets.rbxm) |
| PetPharmica_DominusAngelic.rbxm | PetPharmica | 6 | non | Pet, variantes source: golden, ancrage d’origine conservé, 2x2x3 studs (de Pet_Pharmica_1_1/Pets.rbxm) |
| PetPharmica_DominusClump.rbxm | PetPharmica | 24 | non | Pet, variantes source: golden, ancrage d’origine conservé, 2x2x3 studs (de Pet_Pharmica_1_1/Pets.rbxm) |
| PetPharmica_DominusCrystal.rbxm | PetPharmica | 6 | non | Pet, variantes source: golden, ancrage d’origine conservé, 2x2x3 studs (de Pet_Pharmica_1_1/Pets.rbxm) |
| PetPharmica_DominusEvil.rbxm | PetPharmica | 6 | non | Pet, variantes source: golden, ancrage d’origine conservé, 3x2x3 studs (de Pet_Pharmica_1_1/Pets.rbxm) |
| PetPharmica_DominusSky.rbxm | PetPharmica | 6 | non | Pet, variantes source: golden, ancrage d’origine conservé, 2x2x3 studs (de Pet_Pharmica_1_1/Pets.rbxm) |
| PetPharmica_Dragon.rbxm | PetPharmica | 51 | non | Pet, variantes source: golden/toxic, ancrage d’origine conservé, 4x3x5 studs (de Pet_Pharmica_1_1/Pets.rbxm) |
| PetPharmica_Fishe.rbxm | PetPharmica | 4 | non | Pet, variantes source: golden, ancrage d’origine conservé, 2x1x2 studs (de Pet_Pharmica_1_1/Pets.rbxm) |
| PetPharmica_ForestQuin.rbxm | PetPharmica | 15 | non | Pet, variantes source: golden/toxic, ancrage d’origine conservé, 2x2x3 studs (de Pet_Pharmica_1_1/Pets.rbxm) |
| PetPharmica_Fox.rbxm | PetPharmica | 7 | non | Pet, variantes source: golden/toxic, ancrage d’origine conservé, 2x2x2 studs (de Pet_Pharmica_1_1/Pets.rbxm) |
| PetPharmica_Froggy.rbxm | PetPharmica | 12 | non | Pet, variantes source: golden, ancrage d’origine conservé, 2x2x2 studs (de Pet_Pharmica_1_1/Pets.rbxm) |
| PetPharmica_FroggyTwins.rbxm | PetPharmica | 25 | non | Pet, variantes source: golden, ancrage d’origine conservé, 2x1x1 studs (de Pet_Pharmica_1_1/Pets.rbxm) |
| PetPharmica_FrostHearth.rbxm | PetPharmica | 4 | non | Pet, variantes source: golden/toxic, 1 particules/effets, ancrage d’origine conservé, 9x8x8 studs (de Pet_Pharmica_1_1/Pets.rbxm) |
| PetPharmica_Golden.rbxm | PetPharmica | 7 | non | Pet, 2x3x2 studs (de Pet_Pharmica_1_1/Workspace/Golden.rbxm) |
| PetPharmica_Guest.rbxm | PetPharmica | 5 | non | Pet, variantes source: golden, ancrage d’origine conservé, 2x2x2 studs (de Pet_Pharmica_1_1/Pets.rbxm) |
| PetPharmica_Head.rbxm | PetPharmica | 1 | non | Pet, ancrage d’origine conservé, 4x3x4 studs (de Pet_Pharmica_1_1/Pets.rbxm) |
| PetPharmica_HellFox.rbxm | PetPharmica | 9 | non | Pet, variantes source: golden/toxic, ancrage d’origine conservé, 3x3x3 studs (de Pet_Pharmica_1_1/Pets.rbxm) |
| PetPharmica_HellStar.rbxm | PetPharmica | 5 | non | Pet, ancrage d’origine conservé, 3x5x5 studs (de Pet_Pharmica_1_1/Pets.rbxm) |
| PetPharmica_HugeAlbino.rbxm | PetPharmica | 4 | non | Pet, variantes source: golden, ancrage d’origine conservé, 5x4x3 studs (de Pet_Pharmica_1_1/Pets.rbxm) |
| PetPharmica_HugeCactus.rbxm | PetPharmica | 4 | non | Pet, variantes source: golden, ancrage d’origine conservé, 4x3x3 studs (de Pet_Pharmica_1_1/Pets.rbxm) |
| PetPharmica_HugeCat.rbxm | PetPharmica | 2 | non | Pet, variantes source: golden/toxic, 1 particules/effets, SurfaceGui/Billboard, ancrage d’origine conservé, 6x7x6 studs (de Pet_Pharmica_1_1/Pets.rbxm) |
| PetPharmica_HugeDog.rbxm | PetPharmica | 4 | non | Pet, variantes source: golden, ancrage d’origine conservé, 5x4x3 studs (de Pet_Pharmica_1_1/Pets.rbxm) |
| PetPharmica_HugeDominus.rbxm | PetPharmica | 6 | non | Pet, variantes source: golden, ancrage d’origine conservé, 6x4x8 studs (de Pet_Pharmica_1_1/Pets.rbxm) |
| PetPharmica_HugeDragon.rbxm | PetPharmica | 51 | non | Pet, variantes source: golden, ancrage d’origine conservé, 6x5x7 studs (de Pet_Pharmica_1_1/Pets.rbxm) |
| PetPharmica_HugeGuest.rbxm | PetPharmica | 5 | non | Pet, variantes source: golden, ancrage d’origine conservé, 5x4x5 studs (de Pet_Pharmica_1_1/Pets.rbxm) |
| PetPharmica_HugeIcecube.rbxm | PetPharmica | 2 | non | Pet, variantes source: golden, ancrage d’origine conservé, 4x3x4 studs (de Pet_Pharmica_1_1/Pets.rbxm) |
| PetPharmica_HugeMagmaTV.rbxm | PetPharmica | 5 | non | Pet, variantes source: golden/toxic, ancrage d’origine conservé, 7x11x7 studs (de Pet_Pharmica_1_1/Pets.rbxm) |
| PetPharmica_IceCat.rbxm | PetPharmica | 7 | non | Pet, variantes source: golden/toxic, ancrage d’origine conservé, 2x2x2 studs (de Pet_Pharmica_1_1/Pets.rbxm) |
| PetPharmica_IceCube.rbxm | PetPharmica | 2 | non | Pet, variantes source: golden/toxic, ancrage d’origine conservé, 2x1x2 studs (de Pet_Pharmica_1_1/Pets.rbxm) |
| PetPharmica_IceDeer.rbxm | PetPharmica | 7 | non | Pet, variantes source: golden/toxic, ancrage d’origine conservé, 1x2x1 studs (de Pet_Pharmica_1_1/Pets.rbxm) |
| PetPharmica_IceDog.rbxm | PetPharmica | 4 | non | Pet, variantes source: golden/toxic, ancrage d’origine conservé, 2x2x2 studs (de Pet_Pharmica_1_1/Pets.rbxm) |
| PetPharmica_IceLord.rbxm | PetPharmica | 31 | non | Pet, variantes source: golden, 21 particules/effets, ancrage d’origine conservé, 4x4x5 studs (de Pet_Pharmica_1_1/Pets.rbxm) |
| PetPharmica_Jaguar.rbxm | PetPharmica | 5 | non | Pet, variantes source: golden/toxic, ancrage d’origine conservé, 2x2x2 studs (de Pet_Pharmica_1_1/Pets.rbxm) |
| PetPharmica_Kraken.rbxm | PetPharmica | 3 | non | Pet, variantes source: golden/toxic, ancrage d’origine conservé, 4x4x4 studs (de Pet_Pharmica_1_1/Pets.rbxm) |
| PetPharmica_KrakenCouplet.rbxm | PetPharmica | 10 | non | Pet, 4 particules/effets, 16x14x9 studs (de Pet_Pharmica_1_1/Workspace/Kraken Couplet.rbxm) |
| PetPharmica_Lizard.rbxm | PetPharmica | 51 | non | Pet, variantes source: golden/toxic, ancrage d’origine conservé, 2x2x2 studs (de Pet_Pharmica_1_1/Pets.rbxm) |
| PetPharmica_MagmaBunny.rbxm | PetPharmica | 8 | non | Pet, variantes source: golden/toxic, ancrage d’origine conservé, 2x2x2 studs (de Pet_Pharmica_1_1/Pets.rbxm) |
| PetPharmica_MagmaCat.rbxm | PetPharmica | 8 | non | Pet, variantes source: golden/toxic, ancrage d’origine conservé, 2x2x2 studs (de Pet_Pharmica_1_1/Pets.rbxm) |
| PetPharmica_MagmaDog.rbxm | PetPharmica | 5 | non | Pet, variantes source: golden/toxic, ancrage d’origine conservé, 3x2x2 studs (de Pet_Pharmica_1_1/Pets.rbxm) |
| PetPharmica_MagmaDragon.rbxm | PetPharmica | 8 | non | Pet, variantes source: golden/toxic, ancrage d’origine conservé, 2x2x3 studs (de Pet_Pharmica_1_1/Pets.rbxm) |
| PetPharmica_MagmaImmortal.rbxm | PetPharmica | 9 | non | Pet, variantes source: golden/toxic, ancrage d’origine conservé, 2x3x2 studs (de Pet_Pharmica_1_1/Pets.rbxm) |
| PetPharmica_MagmaRock.rbxm | PetPharmica | 3 | non | Pet, variantes source: golden/toxic, ancrage d’origine conservé, 2x1x2 studs (de Pet_Pharmica_1_1/Pets.rbxm) |
| PetPharmica_MassivePearl.rbxm | PetPharmica | 1 | non | Pet, variantes source: golden/toxic, ancrage d’origine conservé, 3x3x3 studs (de Pet_Pharmica_1_1/Pets.rbxm) |
| PetPharmica_Normal.rbxm | PetPharmica | 7 | non | Pet, 2x3x2 studs (de Pet_Pharmica_1_1/Workspace/Normal.rbxm) |
| PetPharmica_NyanCat.rbxm | PetPharmica | 25 | non | Pet, 1 particules/effets, 5x4x4 studs (de Pet_Pharmica_1_1/Workspace/Nyan Cat.rbxm) |
| PetPharmica_OceanGem.rbxm | PetPharmica | 2 | non | Pet, variantes source: golden, ancrage d’origine conservé, 6x5x2 studs (de Pet_Pharmica_1_1/Pets.rbxm) |
| PetPharmica_OceanLord.rbxm | PetPharmica | 9 | non | Pet, variantes source: golden/toxic, 4 particules/effets, ancrage d’origine conservé, 13x7x15 studs (de Pet_Pharmica_1_1/Pets.rbxm) |
| PetPharmica_Panther.rbxm | PetPharmica | 5 | non | Pet, variantes source: golden/toxic, ancrage d’origine conservé, 2x2x2 studs (de Pet_Pharmica_1_1/Pets.rbxm) |
| PetPharmica_Parrot.rbxm | PetPharmica | 12 | non | Pet, variantes source: golden, ancrage d’origine conservé, 2x2x2 studs (de Pet_Pharmica_1_1/Pets.rbxm) |
| PetPharmica_PinkBunny.rbxm | PetPharmica | 7 | non | Pet, variantes source: golden, ancrage d’origine conservé, 5x6x4 studs (de Pet_Pharmica_1_1/Pets.rbxm) |
| PetPharmica_Pirate.rbxm | PetPharmica | 4 | non | Pet, variantes source: golden, ancrage d’origine conservé, 3x2x2 studs (de Pet_Pharmica_1_1/Pets.rbxm) |
| PetPharmica_PirateDeer.rbxm | PetPharmica | 10 | non | Pet, variantes source: golden/toxic, ancrage d’origine conservé, 2x3x3 studs (de Pet_Pharmica_1_1/Pets.rbxm) |
| PetPharmica_PirateDog.rbxm | PetPharmica | 4 | non | Pet, variantes source: golden, ancrage d’origine conservé, 3x2x3 studs (de Pet_Pharmica_1_1/Pets.rbxm) |
| PetPharmica_PirateMonkey.rbxm | PetPharmica | 11 | non | Pet, variantes source: golden/toxic, ancrage d’origine conservé, 2x2x2 studs (de Pet_Pharmica_1_1/Pets.rbxm) |
| PetPharmica_Poseidon.rbxm | PetPharmica | 10 | non | Pet, variantes source: golden, ancrage d’origine conservé, 2x3x2 studs (de Pet_Pharmica_1_1/Pets.rbxm) |
| PetPharmica_Prisom.rbxm | PetPharmica | 25 | non | Pet, variantes source: golden/toxic, ancrage d’origine conservé, 13x11x13 studs (de Pet_Pharmica_1_1/Pets.rbxm) |
| PetPharmica_PurpleFroggy.rbxm | PetPharmica | 12 | non | Pet, variantes source: golden/toxic, ancrage d’origine conservé, 3x4x3 studs (de Pet_Pharmica_1_1/Pets.rbxm) |
| PetPharmica_quicksilver8o6.rbxm | PetPharmica | 8 | non | Pet, Humanoid, ancrage d’origine conservé, 3x6x4 studs (de Pet_Pharmica_1_1/Workspace/quicksilver8o6.rbxm) |
| PetPharmica_RedFroggy.rbxm | PetPharmica | 12 | non | Pet, variantes source: golden/toxic, ancrage d’origine conservé, 3x4x3 studs (de Pet_Pharmica_1_1/Pets.rbxm) |
| PetPharmica_RobuxBeast.rbxm | PetPharmica | 33 | non | Pet, 3 particules/effets, ancrage d’origine conservé, 13x8x14 studs (de Pet_Pharmica_1_1/Pets.rbxm) |
| PetPharmica_SandCat.rbxm | PetPharmica | 5 | non | Pet, variantes source: golden/toxic, ancrage d’origine conservé, 3x2x2 studs (de Pet_Pharmica_1_1/Pets.rbxm) |
| PetPharmica_SandImmortal.rbxm | PetPharmica | 6 | non | Pet, variantes source: golden/toxic, ancrage d’origine conservé, 2x3x2 studs (de Pet_Pharmica_1_1/Pets.rbxm) |
| PetPharmica_Shark.rbxm | PetPharmica | 4 | non | Pet, variantes source: golden/toxic, ancrage d’origine conservé, 3x2x3 studs (de Pet_Pharmica_1_1/Pets.rbxm) |
| PetPharmica_Sinister.rbxm | PetPharmica | 28 | non | Pet, variantes source: golden/toxic, ancrage d’origine conservé, 9x5x7 studs (de Pet_Pharmica_1_1/Pets.rbxm) |
| PetPharmica_Snake.rbxm | PetPharmica | 2 | non | Pet, variantes source: golden/toxic, ancrage d’origine conservé, 2x1x2 studs (de Pet_Pharmica_1_1/Pets.rbxm) |
| PetPharmica_SnowKing.rbxm | PetPharmica | 15 | non | Pet, variantes source: golden/toxic, ancrage d’origine conservé, 8x7x5 studs (de Pet_Pharmica_1_1/Pets.rbxm) |
| PetPharmica_SnowMaster.rbxm | PetPharmica | 30 | non | Pet, variantes source: golden/toxic, ancrage d’origine conservé, 10x7x12 studs (de Pet_Pharmica_1_1/Pets.rbxm) |
| PetPharmica_Spider.rbxm | PetPharmica | 10 | non | Pet, variantes source: golden/toxic, ancrage d’origine conservé, 3x2x4 studs (de Pet_Pharmica_1_1/Pets.rbxm) |
| PetPharmica_Stack.rbxm | PetPharmica | 17 | non | Pet, variantes source: golden, ancrage d’origine conservé, 3x3x3 studs (de Pet_Pharmica_1_1/Pets.rbxm) |
| PetPharmica_SurferCat.rbxm | PetPharmica | 9 | non | Pet, variantes source: golden/toxic, ancrage d’origine conservé, 4x2x2 studs (de Pet_Pharmica_1_1/Pets.rbxm) |
| PetPharmica_SurferDog.rbxm | PetPharmica | 6 | non | Pet, variantes source: golden/toxic, ancrage d’origine conservé, 5x2x2 studs (de Pet_Pharmica_1_1/Pets.rbxm) |
| PetPharmica_SwimmingFox.rbxm | PetPharmica | 11 | non | Pet, variantes source: golden/toxic, ancrage d’origine conservé, 3x2x3 studs (de Pet_Pharmica_1_1/Pets.rbxm) |
| PetPharmica_TitanicDog.rbxm | PetPharmica | 4 | non | Pet, variantes source: golden, ancrage d’origine conservé, 22x17x13 studs (de Pet_Pharmica_1_1/Pets.rbxm) |
| PetPharmica_Toxic.rbxm | PetPharmica | 28 | non | Pet, 22x12x16 studs (de Pet_Pharmica_1_1/Workspace/Toxic.rbxm) |
| PetPharmica_Turtle.rbxm | PetPharmica | 5 | non | Pet, variantes source: golden, ancrage d’origine conservé, 2x2x2 studs (de Pet_Pharmica_1_1/Pets.rbxm) |
| PetPharmica_WanderingShip.rbxm | PetPharmica | 7 | non | Pet, variantes source: golden/toxic, ancrage d’origine conservé, 3x2x2 studs (de Pet_Pharmica_1_1/Pets.rbxm) |
| PunchSim_250kDragon.rbxm | PunchSim | 2 | non | Pet, ancrage d’origine conservé, 17x12x7 studs (de Punch Simulator/Assets.rbxm) |
| PunchSim_2MSerpent.rbxm | PunchSim | 2 | non | Pet, ancrage d’origine conservé, 13x13x12 studs (de Punch Simulator/Assets.rbxm) |
| PunchSim_Bat.rbxm | PunchSim | 2 | non | Pet, ancrage d’origine conservé, 2x2x2 studs (de Punch Simulator/Assets.rbxm) |
| PunchSim_Bee.rbxm | PunchSim | 2 | non | Pet, ancrage d’origine conservé, 3x3x3 studs (de Punch Simulator/Assets.rbxm) |
| PunchSim_CactusBoi.rbxm | PunchSim | 2 | non | Pet, ancrage d’origine conservé, 3x4x3 studs (de Punch Simulator/Assets.rbxm) |
| PunchSim_Cat.rbxm | PunchSim | 1 | non | Pet, ancrage d’origine conservé, 3x2x1 studs (de Punch Simulator/Assets.rbxm) |
| PunchSim_CommunityBeast.rbxm | PunchSim | 3 | non | Pet, 4 particules/effets, ancrage d’origine conservé, 6x6x7 studs (de Punch Simulator/Assets.rbxm) |
| PunchSim_CosmicCyborg.rbxm | PunchSim | 2 | non | Pet, 5 particules/effets, ancrage d’origine conservé, 4x5x3 studs (de Punch Simulator/Assets.rbxm) |
| PunchSim_Cow.rbxm | PunchSim | 1 | non | Pet, ancrage d’origine conservé, 1x2x3 studs (de Punch Simulator/Assets.rbxm) |
| PunchSim_DarkSpirit.rbxm | PunchSim | 3 | non | Pet, ancrage d’origine conservé, 21x12x9 studs (de Punch Simulator/Assets.rbxm) |
| PunchSim_DesertDragon.rbxm | PunchSim | 2 | non | Pet, ancrage d’origine conservé, 3x4x3 studs (de Punch Simulator/Assets.rbxm) |
| PunchSim_DesertFox.rbxm | PunchSim | 2 | non | Pet, ancrage d’origine conservé, 3x3x3 studs (de Punch Simulator/Assets.rbxm) |
| PunchSim_DeveloperMonkey.rbxm | PunchSim | 2 | non | Pet, ancrage d’origine conservé, 73x73x84 studs (de Punch Simulator/Assets.rbxm) |
| PunchSim_Dog.rbxm | PunchSim | 1 | non | Pet, ancrage d’origine conservé, 2x2x2 studs (de Punch Simulator/Assets.rbxm) |
| PunchSim_ElectroSpirit.rbxm | PunchSim | 2 | non | Pet, ancrage d’origine conservé, 12x12x11 studs (de Punch Simulator/Assets.rbxm) |
| PunchSim_Elephant.rbxm | PunchSim | 2 | non | Pet, ancrage d’origine conservé, 3x3x4 studs (de Punch Simulator/Assets.rbxm) |
| PunchSim_EmeraldMonkey.rbxm | PunchSim | 2 | non | Pet, ancrage d’origine conservé, 39x39x45 studs (de Punch Simulator/Assets.rbxm) |
| PunchSim_EvilSpirit.rbxm | PunchSim | 2 | non | Pet, ancrage d’origine conservé, 8x8x7 studs (de Punch Simulator/Assets.rbxm) |
| PunchSim_ForestWyvern.rbxm | PunchSim | 2 | non | Pet, ancrage d’origine conservé, 6x12x8 studs (de Punch Simulator/Assets.rbxm) |
| PunchSim_GalacticAlien.rbxm | PunchSim | 2 | non | Pet, 1 particules/effets, ancrage d’origine conservé, 4x2x6 studs (de Punch Simulator/Assets.rbxm) |
| PunchSim_GalaxyBeast.rbxm | PunchSim | 3 | non | Pet, 4 particules/effets, ancrage d’origine conservé, 7x6x6 studs (de Punch Simulator/Assets.rbxm) |
| PunchSim_GalaxyCat.rbxm | PunchSim | 2 | non | Pet, 4 particules/effets, ancrage d’origine conservé, 6x2x3 studs (de Punch Simulator/Assets.rbxm) |
| PunchSim_GalaxyDragon.rbxm | PunchSim | 2 | non | Pet, 4 particules/effets, ancrage d’origine conservé, 6x3x3 studs (de Punch Simulator/Assets.rbxm) |
| PunchSim_Gift.rbxm | PunchSim | 2 | non | Pet, ancrage d’origine conservé, 1x1x1 studs (de Punch Simulator/Assets.rbxm) |
| PunchSim_Grass.rbxm | PunchSim | 1 | non | Pet, ancrage d’origine conservé, 3x2x3 studs (de Punch Simulator/Assets.rbxm) |
| PunchSim_HellWisp.rbxm | PunchSim | 3 | non | Pet, ancrage d’origine conservé, 19x13x5 studs (de Punch Simulator/Assets.rbxm) |
| PunchSim_HolyDominus.rbxm | PunchSim | 2 | non | Pet, ancrage d’origine conservé, 42x33x22 studs (de Punch Simulator/Assets.rbxm) |
| PunchSim_HugeCthulhu.rbxm | PunchSim | 2 | non | Pet, ancrage d’origine conservé, 8x16x14 studs (de Punch Simulator/Assets.rbxm) |
| PunchSim_IceScorpion.rbxm | PunchSim | 2 | non | Pet, ancrage d’origine conservé, 4x4x4 studs (de Punch Simulator/Assets.rbxm) |
| PunchSim_JungleBunny.rbxm | PunchSim | 2 | non | Pet, ancrage d’origine conservé, 3x4x3 studs (de Punch Simulator/Assets.rbxm) |
| PunchSim_LavaAngel.rbxm | PunchSim | 2 | non | Pet, ancrage d’origine conservé, 15x14x15 studs (de Punch Simulator/Assets.rbxm) |
| PunchSim_LavaDragon.rbxm | PunchSim | 2 | non | Pet, ancrage d’origine conservé, 8x14x10 studs (de Punch Simulator/Assets.rbxm) |
| PunchSim_Lion.rbxm | PunchSim | 2 | non | Pet, ancrage d’origine conservé, 4x5x6 studs (de Punch Simulator/Assets.rbxm) |
| PunchSim_MagmaBeast.rbxm | PunchSim | 2 | non | Pet, ancrage d’origine conservé, 16x8x6 studs (de Punch Simulator/Assets.rbxm) |
| PunchSim_MagmaCrystalite.rbxm | PunchSim | 2 | non | Pet, ancrage d’origine conservé, 9x9x9 studs (de Punch Simulator/Assets.rbxm) |
| PunchSim_MagmaCube.rbxm | PunchSim | 2 | non | Pet, ancrage d’origine conservé, 6x6x6 studs (de Punch Simulator/Assets.rbxm) |
| PunchSim_MagmaDemon.rbxm | PunchSim | 2 | non | Pet, ancrage d’origine conservé, 2x2x2 studs (de Punch Simulator/Assets.rbxm) |
| PunchSim_MagmaHellfire.rbxm | PunchSim | 2 | non | Pet, 6 particules/effets, ancrage d’origine conservé, 6x5x5 studs (de Punch Simulator/Assets.rbxm) |
| PunchSim_MegaKraken.rbxm | PunchSim | 2 | non | Pet, ancrage d’origine conservé, 11x12x13 studs (de Punch Simulator/Assets.rbxm) |
| PunchSim_MidnightSpirit.rbxm | PunchSim | 2 | non | Pet, ancrage d’origine conservé, 11x11x10 studs (de Punch Simulator/Assets.rbxm) |
| PunchSim_MoltenAlien.rbxm | PunchSim | 2 | non | Pet, 1 particules/effets, ancrage d’origine conservé, 19x14x27 studs (de Punch Simulator/Assets.rbxm) |
| PunchSim_MoltenScorpion.rbxm | PunchSim | 2 | non | Pet, ancrage d’origine conservé, 3x4x3 studs (de Punch Simulator/Assets.rbxm) |
| PunchSim_MoltenWisp.rbxm | PunchSim | 2 | non | Pet, ancrage d’origine conservé, 13x10x6 studs (de Punch Simulator/Assets.rbxm) |
| PunchSim_MoltenWyvern.rbxm | PunchSim | 2 | non | Pet, ancrage d’origine conservé, 4x7x5 studs (de Punch Simulator/Assets.rbxm) |
| PunchSim_Monkey.rbxm | PunchSim | 2 | non | Pet, ancrage d’origine conservé, 3x4x4 studs (de Punch Simulator/Assets.rbxm) |
| PunchSim_Mouse.rbxm | PunchSim | 1 | non | Pet, ancrage d’origine conservé, 2x3x2 studs (de Punch Simulator/Assets.rbxm) |
| PunchSim_Parrot.rbxm | PunchSim | 2 | non | Pet, ancrage d’origine conservé, 4x4x3 studs (de Punch Simulator/Assets.rbxm) |
| PunchSim_PinkAngel.rbxm | PunchSim | 2 | non | Pet, ancrage d’origine conservé, 8x8x8 studs (de Punch Simulator/Assets.rbxm) |
| PunchSim_RagedBeast.rbxm | PunchSim | 2 | non | Pet, ancrage d’origine conservé, 24x14x11 studs (de Punch Simulator/Assets.rbxm) |
| PunchSim_S1ClanTrophy.rbxm | PunchSim | 2 | non | Pet, ancrage d’origine conservé, 8x18x9 studs (de Punch Simulator/Assets.rbxm) |
| PunchSim_SLIMEBOY.rbxm | PunchSim | 2 | non | Pet, ancrage d’origine conservé, 12x14x6 studs (de Punch Simulator/Assets.rbxm) |
| PunchSim_SnowyWyvern.rbxm | PunchSim | 2 | non | Pet, ancrage d’origine conservé, 10x18x12 studs (de Punch Simulator/Assets.rbxm) |
| PunchSim_StormDragon.rbxm | PunchSim | 2 | non | Pet, ancrage d’origine conservé, 14x31x20 studs (de Punch Simulator/Assets.rbxm) |
| PunchSim_ToxicAlien.rbxm | PunchSim | 2 | non | Pet, 1 particules/effets, ancrage d’origine conservé, 15x12x22 studs (de Punch Simulator/Assets.rbxm) |
| PunchSim_ToxicCactusBoi.rbxm | PunchSim | 2 | non | Pet, ancrage d’origine conservé, 4x6x3 studs (de Punch Simulator/Assets.rbxm) |
| PunchSim_ToxicDragon.rbxm | PunchSim | 2 | non | Pet, ancrage d’origine conservé, 13x6x7 studs (de Punch Simulator/Assets.rbxm) |
| PunchSim_ToxicHydra.rbxm | PunchSim | 2 | non | Pet, ancrage d’origine conservé, 7x9x7 studs (de Punch Simulator/Assets.rbxm) |
| PunchSim_ToxicPhoenix.rbxm | PunchSim | 2 | non | Pet, ancrage d’origine conservé, 4x5x3 studs (de Punch Simulator/Assets.rbxm) |
| PunchSim_VoidDominus.rbxm | PunchSim | 2 | non | Pet, ancrage d’origine conservé, 8x7x9 studs (de Punch Simulator/Assets.rbxm) |
| PunchSim_VoidDragon.rbxm | PunchSim | 2 | non | Pet, ancrage d’origine conservé, 5x5x5 studs (de Punch Simulator/Assets.rbxm) |
| PunchSim_WispDragon.rbxm | PunchSim | 3 | non | Pet, ancrage d’origine conservé, 19x13x5 studs (de Punch Simulator/Assets.rbxm) |
| RebirthChampionsX_10MBeast.rbxm | RebirthChampionsX | 8 | non | Pet, variantes source: galaxy/golden/toxic, 6 particules/effets, SurfaceGui/Billboard, ancrage d’origine conservé, 32x16x15 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_10MBlob.rbxm | RebirthChampionsX | 27 | non | Pet, variantes source: galaxy/golden/toxic, SurfaceGui/Billboard, ancrage d’origine conservé, 2x2x2 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_10MCat.rbxm | RebirthChampionsX | 9 | non | Pet, variantes source: galaxy/golden/toxic, SurfaceGui/Billboard, ancrage d’origine conservé, 2x3x2 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_10MCrown.rbxm | RebirthChampionsX | 7 | non | Pet, variantes source: galaxy/golden/toxic, SurfaceGui/Billboard, ancrage d’origine conservé, 3x2x3 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_10MHexagon.rbxm | RebirthChampionsX | 11 | non | Pet, variantes source: galaxy/golden/toxic, 2 particules/effets, SurfaceGui/Billboard, ancrage d’origine conservé, 7x6x3 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_10MImmortal.rbxm | RebirthChampionsX | 14 | non | Pet, variantes source: galaxy/golden/toxic, 2 particules/effets, SurfaceGui/Billboard, ancrage d’origine conservé, 16x6x8 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_10MTrophy.rbxm | RebirthChampionsX | 29 | non | Pet, variantes source: galaxy/golden/toxic, SurfaceGui/Billboard, ancrage d’origine conservé, 12x16x9 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_10MUnicorn.rbxm | RebirthChampionsX | 7 | non | Pet, variantes source: galaxy/golden/toxic, SurfaceGui/Billboard, ancrage d’origine conservé, 2x3x2 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_5MBlob.rbxm | RebirthChampionsX | 20 | non | Pet, variantes source: galaxy/golden/toxic, SurfaceGui/Billboard, ancrage d’origine conservé, 2x2x2 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_5MCat.rbxm | RebirthChampionsX | 9 | non | Pet, variantes source: galaxy/golden/toxic, SurfaceGui/Billboard, ancrage d’origine conservé, 2x3x2 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_5MCrown.rbxm | RebirthChampionsX | 6 | non | Pet, variantes source: galaxy/golden/toxic, SurfaceGui/Billboard, ancrage d’origine conservé, 3x2x3 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_5MDragon.rbxm | RebirthChampionsX | 10 | non | Pet, variantes source: galaxy/golden/toxic, 4 particules/effets, SurfaceGui/Billboard, ancrage d’origine conservé, 10x5x4 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_5MImmortal.rbxm | RebirthChampionsX | 16 | non | Pet, variantes source: galaxy/golden/toxic, 5 particules/effets, SurfaceGui/Billboard, ancrage d’origine conservé, 29x19x10 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_5MOverlord.rbxm | RebirthChampionsX | 10 | non | Pet, variantes source: galaxy/golden/toxic, 3 particules/effets, SurfaceGui/Billboard, ancrage d’origine conservé, 19x6x6 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_5MTrophy.rbxm | RebirthChampionsX | 26 | non | Pet, variantes source: galaxy/golden/toxic, SurfaceGui/Billboard, ancrage d’origine conservé, 12x17x8 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_5MUnicorn.rbxm | RebirthChampionsX | 7 | non | Pet, variantes source: galaxy/golden/toxic, SurfaceGui/Billboard, ancrage d’origine conservé, 2x3x2 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_Alien.rbxm | RebirthChampionsX | 6 | non | Pet, variantes source: galaxy/golden/toxic, SurfaceGui/Billboard, ancrage d’origine conservé, 3x3x2 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_AngelDragon.rbxm | RebirthChampionsX | 10 | non | Pet, variantes source: galaxy/golden/toxic, 1 particules/effets, SurfaceGui/Billboard, ancrage d’origine conservé, 11x5x7 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_AngelOverlord.rbxm | RebirthChampionsX | 15 | non | Pet, variantes source: galaxy/golden/toxic, 1 particules/effets, SurfaceGui/Billboard, ancrage d’origine conservé, 14x10x7 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_AngelSerpent.rbxm | RebirthChampionsX | 14 | non | Pet, variantes source: galaxy/golden/toxic, 1 particules/effets, SurfaceGui/Billboard, ancrage d’origine conservé, 6x4x3 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_Anglerfish.rbxm | RebirthChampionsX | 6 | non | Pet, variantes source: galaxy/golden/toxic, SurfaceGui/Billboard, ancrage d’origine conservé, 4x4x4 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_Baguette.rbxm | RebirthChampionsX | 9 | non | Pet, variantes source: galaxy/golden/toxic, SurfaceGui/Billboard, ancrage d’origine conservé, 1x2x11 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_Bat.rbxm | RebirthChampionsX | 20 | non | Pet, variantes source: galaxy/golden/toxic, SurfaceGui/Billboard, ancrage d’origine conservé, 9x3x3 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_BoneOverlord.rbxm | RebirthChampionsX | 5 | non | Pet, variantes source: galaxy/golden/toxic, 2 particules/effets, SurfaceGui/Billboard, ancrage d’origine conservé, 11x6x7 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_Bread.rbxm | RebirthChampionsX | 5 | non | Pet, variantes source: galaxy/golden/toxic, 1 particules/effets, SurfaceGui/Billboard, ancrage d’origine conservé, 2x3x2 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_Bunny.rbxm | RebirthChampionsX | 4 | non | Pet, variantes source: galaxy/golden/toxic, SurfaceGui/Billboard, ancrage d’origine conservé, 2x3x2 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_Cactus.rbxm | RebirthChampionsX | 7 | non | Pet, variantes source: galaxy/golden/toxic, SurfaceGui/Billboard, ancrage d’origine conservé, 3x4x3 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_Camel.rbxm | RebirthChampionsX | 4 | non | Pet, variantes source: galaxy/golden/toxic, SurfaceGui/Billboard, ancrage d’origine conservé, 2x2x2 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_Carrot.rbxm | RebirthChampionsX | 4 | non | Pet, variantes source: galaxy/golden/toxic, SurfaceGui/Billboard, ancrage d’origine conservé, 4x9x3 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_Cat.rbxm | RebirthChampionsX | 6 | non | Pet, variantes source: galaxy/golden/toxic, SurfaceGui/Billboard, ancrage d’origine conservé, 2x3x3 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_CaveBunny.rbxm | RebirthChampionsX | 14 | non | Pet, variantes source: galaxy/golden/toxic, SurfaceGui/Billboard, ancrage d’origine conservé, 3x4x2 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_CaveCat.rbxm | RebirthChampionsX | 16 | non | Pet, variantes source: galaxy/golden/toxic, SurfaceGui/Billboard, ancrage d’origine conservé, 3x3x3 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_CaveDog.rbxm | RebirthChampionsX | 13 | non | Pet, variantes source: galaxy/golden/toxic, SurfaceGui/Billboard, ancrage d’origine conservé, 3x4x2 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_CaveSerpent.rbxm | RebirthChampionsX | 20 | non | Pet, variantes source: galaxy/golden/toxic, 1 particules/effets, SurfaceGui/Billboard, ancrage d’origine conservé, 6x4x3 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_ChickenDuo.rbxm | RebirthChampionsX | 8 | non | Pet, variantes source: galaxy/golden/toxic, SurfaceGui/Billboard, ancrage d’origine conservé, 4x2x3 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_ChocolateBunny.rbxm | RebirthChampionsX | 5 | non | Pet, variantes source: galaxy/golden/toxic, SurfaceGui/Billboard, ancrage d’origine conservé, 2x3x2 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_ChocolateCat.rbxm | RebirthChampionsX | 7 | non | Pet, variantes source: galaxy/golden/toxic, SurfaceGui/Billboard, ancrage d’origine conservé, 2x3x3 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_ChocolateDog.rbxm | RebirthChampionsX | 4 | non | Pet, variantes source: galaxy/golden/toxic, SurfaceGui/Billboard, ancrage d’origine conservé, 2x2x2 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_ChocolateDragon.rbxm | RebirthChampionsX | 8 | non | Pet, variantes source: galaxy/golden/toxic, SurfaceGui/Billboard, ancrage d’origine conservé, 10x4x3 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_ChocolateEgg.rbxm | RebirthChampionsX | 3 | non | Pet, variantes source: galaxy/golden/toxic, SurfaceGui/Billboard, ancrage d’origine conservé, 2x2x2 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_CloudyBunny.rbxm | RebirthChampionsX | 5 | non | Pet, variantes source: galaxy/golden/toxic, SurfaceGui/Billboard, ancrage d’origine conservé, 4x4x4 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_CloudyCat.rbxm | RebirthChampionsX | 7 | non | Pet, variantes source: galaxy/golden/toxic, SurfaceGui/Billboard, ancrage d’origine conservé, 4x4x4 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_CloudyDog.rbxm | RebirthChampionsX | 4 | non | Pet, variantes source: galaxy/golden/toxic, SurfaceGui/Billboard, ancrage d’origine conservé, 4x3x4 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_CrystalBall.rbxm | RebirthChampionsX | 10 | non | Pet, variantes source: galaxy/golden/toxic, 1 particules/effets, SurfaceGui/Billboard, ancrage d’origine conservé, 8x5x8 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_CrystalGem.rbxm | RebirthChampionsX | 15 | non | Pet, variantes source: galaxy/golden/toxic, 4 particules/effets, SurfaceGui/Billboard, ancrage d’origine conservé, 53x21x38 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_CrystalMaster.rbxm | RebirthChampionsX | 17 | non | Pet, variantes source: galaxy/golden/toxic, 7 particules/effets, SurfaceGui/Billboard, ancrage d’origine conservé, 32x19x13 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_CrystalOverlord.rbxm | RebirthChampionsX | 17 | non | Pet, variantes source: galaxy/golden/toxic, 4 particules/effets, SurfaceGui/Billboard, ancrage d’origine conservé, 21x8x8 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_CyberCat.rbxm | RebirthChampionsX | 8 | non | Pet, variantes source: galaxy/golden/toxic, SurfaceGui/Billboard, ancrage d’origine conservé, 2x4x2 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_CyberDog.rbxm | RebirthChampionsX | 10 | non | Pet, variantes source: galaxy/golden/toxic, SurfaceGui/Billboard, ancrage d’origine conservé, 2x4x3 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_CyberDragon.rbxm | RebirthChampionsX | 7 | non | Pet, variantes source: galaxy/golden/toxic, 4 particules/effets, SurfaceGui/Billboard, ancrage d’origine conservé, 11x10x5 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_CyberHydra.rbxm | RebirthChampionsX | 21 | non | Pet, variantes source: galaxy/golden/toxic, 1 particules/effets, SurfaceGui/Billboard, ancrage d’origine conservé, 5x4x3 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_CyberImmortal.rbxm | RebirthChampionsX | 7 | non | Pet, variantes source: galaxy/golden/toxic, 3 particules/effets, SurfaceGui/Billboard, ancrage d’origine conservé, 20x13x10 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_CyberMonster.rbxm | RebirthChampionsX | 11 | non | Pet, variantes source: galaxy/golden/toxic, 1 particules/effets, SurfaceGui/Billboard, ancrage d’origine conservé, 8x4x4 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_DesertMonster.rbxm | RebirthChampionsX | 8 | non | Pet, variantes source: galaxy/golden/toxic, 1 particules/effets, SurfaceGui/Billboard, ancrage d’origine conservé, 11x6x4 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_DivineHarp.rbxm | RebirthChampionsX | 22 | non | Pet, variantes source: galaxy/golden/toxic, 5 particules/effets, SurfaceGui/Billboard, ancrage d’origine conservé, 17x25x12 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_Dog.rbxm | RebirthChampionsX | 3 | non | Pet, variantes source: galaxy/golden/toxic, SurfaceGui/Billboard, ancrage d’origine conservé, 2x2x2 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_EasterBasket.rbxm | RebirthChampionsX | 34 | non | Pet, variantes source: galaxy/golden/toxic, SurfaceGui/Billboard, ancrage d’origine conservé, 11x10x12 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_EasterBunny.rbxm | RebirthChampionsX | 7 | non | Pet, variantes source: galaxy/golden/toxic, SurfaceGui/Billboard, ancrage d’origine conservé, 2x3x2 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_EasterCat.rbxm | RebirthChampionsX | 8 | non | Pet, variantes source: galaxy/golden/toxic, SurfaceGui/Billboard, ancrage d’origine conservé, 2x3x3 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_EasterCreature.rbxm | RebirthChampionsX | 10 | non | Pet, variantes source: galaxy/golden/toxic, 6 particules/effets, SurfaceGui/Billboard, ancrage d’origine conservé, 29x15x28 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_EasterDog.rbxm | RebirthChampionsX | 5 | non | Pet, variantes source: galaxy/golden/toxic, SurfaceGui/Billboard, ancrage d’origine conservé, 2x3x2 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_EasterDragon.rbxm | RebirthChampionsX | 9 | non | Pet, variantes source: galaxy/golden/toxic, 3 particules/effets, SurfaceGui/Billboard, ancrage d’origine conservé, 16x8x6 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_EasterHexagon.rbxm | RebirthChampionsX | 3 | non | Pet, variantes source: galaxy/golden/toxic, 2 particules/effets, SurfaceGui/Billboard, ancrage d’origine conservé, 4x5x4 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_EasterHydra.rbxm | RebirthChampionsX | 17 | non | Pet, variantes source: galaxy/golden/toxic, SurfaceGui/Billboard, ancrage d’origine conservé, 5x4x3 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_EasterImmortal.rbxm | RebirthChampionsX | 19 | non | Pet, variantes source: galaxy/golden/toxic, 7 particules/effets, SurfaceGui/Billboard, ancrage d’origine conservé, 23x14x11 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_EasterKing.rbxm | RebirthChampionsX | 20 | non | Pet, variantes source: galaxy/golden/toxic, 3 particules/effets, SurfaceGui/Billboard, ancrage d’origine conservé, 21x16x10 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_EasterSplit.rbxm | RebirthChampionsX | 47 | non | Pet, variantes source: galaxy/golden/toxic, 2 particules/effets, SurfaceGui/Billboard, ancrage d’origine conservé, 20x8x14 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_EasterStar.rbxm | RebirthChampionsX | 4 | non | Pet, variantes source: galaxy/golden/toxic, SurfaceGui/Billboard, ancrage d’origine conservé, 8x8x2 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_EasterTutel.rbxm | RebirthChampionsX | 20 | non | Pet, variantes source: galaxy/golden/toxic, SurfaceGui/Billboard, ancrage d’origine conservé, 24x23x30 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_Egg.rbxm | RebirthChampionsX | 5 | non | Pet, variantes source: galaxy/golden/toxic, SurfaceGui/Billboard, ancrage d’origine conservé, 3x4x3 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_EggCube.rbxm | RebirthChampionsX | 4 | non | Pet, variantes source: galaxy/golden/toxic, SurfaceGui/Billboard, ancrage d’origine conservé, 7x7x2 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_EggDragon.rbxm | RebirthChampionsX | 6 | non | Pet, variantes source: galaxy/golden/toxic, 5 particules/effets, SurfaceGui/Billboard, ancrage d’origine conservé, 18x6x7 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_EggKing.rbxm | RebirthChampionsX | 13 | non | Pet, variantes source: galaxy/golden/toxic, 2 particules/effets, SurfaceGui/Billboard, ancrage d’origine conservé, 18x15x9 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_EggOverlord.rbxm | RebirthChampionsX | 15 | non | Pet, variantes source: galaxy/golden/toxic, 10 particules/effets, SurfaceGui/Billboard, ancrage d’origine conservé, 36x20x25 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_EggShard.rbxm | RebirthChampionsX | 6 | non | Pet, variantes source: galaxy/golden/toxic, SurfaceGui/Billboard, ancrage d’origine conservé, 10x10x3 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_EggWarrior.rbxm | RebirthChampionsX | 15 | non | Pet, variantes source: galaxy/golden/toxic, 2 particules/effets, SurfaceGui/Billboard, ancrage d’origine conservé, 8x4x4 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_EternalEgg.rbxm | RebirthChampionsX | 41 | non | Pet, variantes source: galaxy/golden/toxic, 7 particules/effets, SurfaceGui/Billboard, ancrage d’origine conservé, 40x14x13 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_EvilEgg.rbxm | RebirthChampionsX | 5 | non | Pet, variantes source: galaxy/golden/toxic, SurfaceGui/Billboard, ancrage d’origine conservé, 3x3x2 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_FireShard.rbxm | RebirthChampionsX | 6 | non | Pet, variantes source: galaxy/golden/toxic, 1 particules/effets, SurfaceGui/Billboard, ancrage d’origine conservé, 11x12x7 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_FireStar.rbxm | RebirthChampionsX | 5 | non | Pet, variantes source: galaxy/golden/toxic, SurfaceGui/Billboard, ancrage d’origine conservé, 15x11x7 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_FlowerGuardian.rbxm | RebirthChampionsX | 27 | non | Pet, variantes source: galaxy/golden/toxic, 6 particules/effets, SurfaceGui/Billboard, ancrage d’origine conservé, 31x15x9 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_FlowerSpirit.rbxm | RebirthChampionsX | 11 | non | Pet, variantes source: galaxy/golden/toxic, 1 particules/effets, SurfaceGui/Billboard, ancrage d’origine conservé, 19x7x6 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_Fmakju.rbxm | RebirthChampionsX | 7 | non | Pet, variantes source: galaxy/golden/toxic, SurfaceGui/Billboard, ancrage d’origine conservé, 3x3x3 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_ForestDragon.rbxm | RebirthChampionsX | 5 | non | Pet, variantes source: galaxy/golden/toxic, 1 particules/effets, SurfaceGui/Billboard, ancrage d’origine conservé, 4x3x3 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_ForestImmortal.rbxm | RebirthChampionsX | 10 | non | Pet, variantes source: galaxy/golden/toxic, 2 particules/effets, SurfaceGui/Billboard, ancrage d’origine conservé, 10x6x4 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_Fox.rbxm | RebirthChampionsX | 5 | non | Pet, variantes source: galaxy/golden/toxic, SurfaceGui/Billboard, ancrage d’origine conservé, 2x2x2 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_GalaxyHexagon.rbxm | RebirthChampionsX | 5 | non | Pet, variantes source: galaxy/golden/toxic, 4 particules/effets, SurfaceGui/Billboard, ancrage d’origine conservé, 21x16x12 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_Ghost.rbxm | RebirthChampionsX | 5 | non | Pet, variantes source: galaxy/golden/toxic, SurfaceGui/Billboard, ancrage d’origine conservé, 2x3x2 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_GhostDragon.rbxm | RebirthChampionsX | 12 | non | Pet, variantes source: galaxy/golden/toxic, 1 particules/effets, SurfaceGui/Billboard, ancrage d’origine conservé, 10x6x3 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_Hacker.rbxm | RebirthChampionsX | 26 | non | Pet, variantes source: galaxy/golden/toxic, 2 particules/effets, SurfaceGui/Billboard, ancrage d’origine conservé, 5x3x5 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_HackerDragon.rbxm | RebirthChampionsX | 5 | non | Pet, variantes source: galaxy/golden/toxic, 3 particules/effets, SurfaceGui/Billboard, ancrage d’origine conservé, 14x5x3 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_HeavenSoul.rbxm | RebirthChampionsX | 19 | non | Pet, variantes source: galaxy/golden/toxic, 2 particules/effets, SurfaceGui/Billboard, ancrage d’origine conservé, 21x11x8 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_Holix.rbxm | RebirthChampionsX | 5 | non | Pet, variantes source: galaxy/golden/toxic, SurfaceGui/Billboard, ancrage d’origine conservé, 2x3x2 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_HugeRobot.rbxm | RebirthChampionsX | 10 | non | Pet, variantes source: galaxy/golden/toxic, 2 particules/effets, SurfaceGui/Billboard, ancrage d’origine conservé, 11x17x9 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_IceDog.rbxm | RebirthChampionsX | 9 | non | Pet, variantes source: galaxy/golden/toxic, SurfaceGui/Billboard, ancrage d’origine conservé, 3x4x2 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_IceDragon.rbxm | RebirthChampionsX | 13 | non | Pet, variantes source: galaxy/golden/toxic, 2 particules/effets, SurfaceGui/Billboard, ancrage d’origine conservé, 11x6x5 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_IceGolem.rbxm | RebirthChampionsX | 5 | non | Pet, variantes source: galaxy/golden/toxic, SurfaceGui/Billboard, ancrage d’origine conservé, 3x3x3 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_ImmortalCarrot.rbxm | RebirthChampionsX | 16 | non | Pet, variantes source: galaxy/golden/toxic, 1 particules/effets, SurfaceGui/Billboard, ancrage d’origine conservé, 7x8x4 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_ImmortalShard.rbxm | RebirthChampionsX | 8 | non | Pet, variantes source: galaxy/golden/toxic, 2 particules/effets, SurfaceGui/Billboard, ancrage d’origine conservé, 14x12x7 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_Jellyfish.rbxm | RebirthChampionsX | 5 | non | Pet, variantes source: galaxy/golden/toxic, 2 particules/effets, SurfaceGui/Billboard, ancrage d’origine conservé, 3x6x3 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_KingBunny.rbxm | RebirthChampionsX | 29 | non | Pet, variantes source: galaxy/golden/toxic, 6 particules/effets, SurfaceGui/Billboard, ancrage d’origine conservé, 38x25x19 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_KingCrab.rbxm | RebirthChampionsX | 7 | non | Pet, variantes source: galaxy/golden/toxic, 3 particules/effets, SurfaceGui/Billboard, ancrage d’origine conservé, 9x6x6 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_KingDragon.rbxm | RebirthChampionsX | 6 | non | Pet, variantes source: galaxy/golden/toxic, 1 particules/effets, SurfaceGui/Billboard, ancrage d’origine conservé, 12x5x5 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_KingHexagon.rbxm | RebirthChampionsX | 3 | non | Pet, variantes source: galaxy/golden/toxic, 1 particules/effets, SurfaceGui/Billboard, ancrage d’origine conservé, 3x3x3 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_KingStar.rbxm | RebirthChampionsX | 5 | non | Pet, variantes source: golden/toxic, 3 particules/effets, SurfaceGui/Billboard, ancrage d’origine conservé, 14x10x3 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_LavaDog.rbxm | RebirthChampionsX | 5 | non | Pet, variantes source: galaxy/golden/toxic, SurfaceGui/Billboard, ancrage d’origine conservé, 3x2x2 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_LavaFox.rbxm | RebirthChampionsX | 6 | non | Pet, variantes source: galaxy/golden/toxic, SurfaceGui/Billboard, ancrage d’origine conservé, 2x3x2 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_LavaGolem.rbxm | RebirthChampionsX | 5 | non | Pet, variantes source: galaxy/golden/toxic, 1 particules/effets, SurfaceGui/Billboard, ancrage d’origine conservé, 3x3x3 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_LavaImmortal.rbxm | RebirthChampionsX | 12 | non | Pet, variantes source: galaxy/golden/toxic, 4 particules/effets, SurfaceGui/Billboard, ancrage d’origine conservé, 16x14x10 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_LavaOverlord.rbxm | RebirthChampionsX | 9 | non | Pet, variantes source: galaxy/golden/toxic, 4 particules/effets, SurfaceGui/Billboard, ancrage d’origine conservé, 13x6x7 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_LavaSerpent.rbxm | RebirthChampionsX | 13 | non | Pet, variantes source: galaxy/golden/toxic, 2 particules/effets, SurfaceGui/Billboard, ancrage d’origine conservé, 5x4x2 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_Lion.rbxm | RebirthChampionsX | 3 | non | Pet, variantes source: galaxy/golden/toxic, SurfaceGui/Billboard, ancrage d’origine conservé, 2x2x2 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_MagicBunny.rbxm | RebirthChampionsX | 5 | non | Pet, variantes source: galaxy/golden/toxic, SurfaceGui/Billboard, ancrage d’origine conservé, 2x3x2 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_MagicCat.rbxm | RebirthChampionsX | 8 | non | Pet, variantes source: galaxy/golden/toxic, SurfaceGui/Billboard, ancrage d’origine conservé, 2x2x2 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_MagicCreature.rbxm | RebirthChampionsX | 13 | non | Pet, variantes source: galaxy/golden/toxic, 2 particules/effets, SurfaceGui/Billboard, ancrage d’origine conservé, 32x21x7 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_MagicDragon.rbxm | RebirthChampionsX | 6 | non | Pet, variantes source: galaxy/golden/toxic, SurfaceGui/Billboard, ancrage d’origine conservé, 9x5x3 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_MagicImmortal.rbxm | RebirthChampionsX | 8 | non | Pet, variantes source: galaxy/golden/toxic, 1 particules/effets, SurfaceGui/Billboard, ancrage d’origine conservé, 13x7x4 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_MagicShard.rbxm | RebirthChampionsX | 12 | non | Pet, variantes source: galaxy/golden/toxic, 3 particules/effets, SurfaceGui/Billboard, ancrage d’origine conservé, 17x15x6 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_MagicUnicorn.rbxm | RebirthChampionsX | 6 | non | Pet, variantes source: galaxy/golden/toxic, SurfaceGui/Billboard, ancrage d’origine conservé, 2x3x3 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_MagmaDragon.rbxm | RebirthChampionsX | 9 | non | Pet, variantes source: galaxy/golden/toxic, 3 particules/effets, SurfaceGui/Billboard, ancrage d’origine conservé, 19x7x6 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_MagmaMonster.rbxm | RebirthChampionsX | 7 | non | Pet, variantes source: galaxy/golden/toxic, SurfaceGui/Billboard, ancrage d’origine conservé, 5x4x4 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_MagmaStar.rbxm | RebirthChampionsX | 3 | non | Pet, variantes source: galaxy/golden/toxic, 1 particules/effets, SurfaceGui/Billboard, ancrage d’origine conservé, 7x6x4 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_MagmaTrio.rbxm | RebirthChampionsX | 9 | non | Pet, variantes source: galaxy/golden/toxic, 3 particules/effets, SurfaceGui/Billboard, ancrage d’origine conservé, 6x4x5 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_MoonKnight.rbxm | RebirthChampionsX | 26 | non | Pet, variantes source: galaxy/golden/toxic, 6 particules/effets, SurfaceGui/Billboard, ancrage d’origine conservé, 25x15x11 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_Mushroom.rbxm | RebirthChampionsX | 4 | non | Pet, variantes source: galaxy/golden/toxic, SurfaceGui/Billboard, ancrage d’origine conservé, 2x2x2 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_MythicBat.rbxm | RebirthChampionsX | 14 | non | Pet, variantes source: galaxy/golden/toxic, SurfaceGui/Billboard, ancrage d’origine conservé, 9x3x3 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_MythicFox.rbxm | RebirthChampionsX | 5 | non | Pet, variantes source: galaxy/golden/toxic, SurfaceGui/Billboard, ancrage d’origine conservé, 2x3x2 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_MythicGolem.rbxm | RebirthChampionsX | 5 | non | Pet, variantes source: galaxy/golden/toxic, SurfaceGui/Billboard, ancrage d’origine conservé, 3x2x2 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_MythicHydra.rbxm | RebirthChampionsX | 11 | non | Pet, variantes source: galaxy/golden/toxic, SurfaceGui/Billboard, ancrage d’origine conservé, 5x4x3 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_NuclearBunny.rbxm | RebirthChampionsX | 6 | non | Pet, variantes source: galaxy/golden/toxic, SurfaceGui/Billboard, ancrage d’origine conservé, 2x3x2 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_NuclearCat.rbxm | RebirthChampionsX | 8 | non | Pet, variantes source: galaxy/golden/toxic, SurfaceGui/Billboard, ancrage d’origine conservé, 2x3x3 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_NuclearDog.rbxm | RebirthChampionsX | 5 | non | Pet, variantes source: galaxy/golden/toxic, SurfaceGui/Billboard, ancrage d’origine conservé, 2x2x2 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_NuclearDragon.rbxm | RebirthChampionsX | 6 | non | Pet, variantes source: galaxy/golden/toxic, 3 particules/effets, SurfaceGui/Billboard, ancrage d’origine conservé, 18x8x6 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_NuclearGuardian.rbxm | RebirthChampionsX | 7 | non | Pet, variantes source: galaxy/golden/toxic, 3 particules/effets, SurfaceGui/Billboard, ancrage d’origine conservé, 5x4x6 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_NuclearHydra.rbxm | RebirthChampionsX | 16 | non | Pet, variantes source: galaxy/golden/toxic, SurfaceGui/Billboard, ancrage d’origine conservé, 5x4x3 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_NuclearLord.rbxm | RebirthChampionsX | 8 | non | Pet, variantes source: galaxy/golden/toxic, 10 particules/effets, SurfaceGui/Billboard, ancrage d’origine conservé, 39x23x14 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_NuclearOverlord.rbxm | RebirthChampionsX | 13 | non | Pet, variantes source: galaxy/golden/toxic, 4 particules/effets, SurfaceGui/Billboard, ancrage d’origine conservé, 26x14x7 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_Pearl.rbxm | RebirthChampionsX | 4 | non | Pet, variantes source: galaxy/golden/toxic, SurfaceGui/Billboard, ancrage d’origine conservé, 3x2x2 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_Pedro.rbxm | RebirthChampionsX | 7 | non | Pet, variantes source: galaxy/golden/toxic, SurfaceGui/Billboard, ancrage d’origine conservé, 4x4x4 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_Phoenix.rbxm | RebirthChampionsX | 9 | non | Pet, variantes source: galaxy/golden/toxic, 6 particules/effets, SurfaceGui/Billboard, ancrage d’origine conservé, 23x19x11 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_PlanetKing.rbxm | RebirthChampionsX | 7 | non | Pet, variantes source: galaxy/golden/toxic, 4 particules/effets, SurfaceGui/Billboard, ancrage d’origine conservé, 19x9x13 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_Puzonik.rbxm | RebirthChampionsX | 5 | non | Pet, variantes source: galaxy/golden/toxic, SurfaceGui/Billboard, ancrage d’origine conservé, 2x3x2 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_Reaper.rbxm | RebirthChampionsX | 8 | non | Pet, variantes source: galaxy/golden/toxic, 1 particules/effets, SurfaceGui/Billboard, ancrage d’origine conservé, 4x5x3 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_ReaperImmortal.rbxm | RebirthChampionsX | 9 | non | Pet, variantes source: galaxy/golden/toxic, 5 particules/effets, SurfaceGui/Billboard, ancrage d’origine conservé, 21x16x9 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_Roblerom.rbxm | RebirthChampionsX | 8 | non | Pet, variantes source: galaxy/golden/toxic, SurfaceGui/Billboard, ancrage d’origine conservé, 3x4x3 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_Rocket.rbxm | RebirthChampionsX | 9 | non | Pet, variantes source: galaxy/golden/toxic, SurfaceGui/Billboard, ancrage d’origine conservé, 3x4x3 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_Roksek.rbxm | RebirthChampionsX | 8 | non | Pet, variantes source: galaxy/golden/toxic, SurfaceGui/Billboard, ancrage d’origine conservé, 3x4x3 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_SandBucket.rbxm | RebirthChampionsX | 4 | non | Pet, variantes source: galaxy/golden/toxic, SurfaceGui/Billboard, ancrage d’origine conservé, 2x3x2 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_SandOverlord.rbxm | RebirthChampionsX | 6 | non | Pet, variantes source: galaxy/golden/toxic, 2 particules/effets, SurfaceGui/Billboard, ancrage d’origine conservé, 17x10x8 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_SandSerpent.rbxm | RebirthChampionsX | 10 | non | Pet, variantes source: galaxy/golden/toxic, 1 particules/effets, SurfaceGui/Billboard, ancrage d’origine conservé, 6x4x3 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_Scorpio.rbxm | RebirthChampionsX | 5 | non | Pet, variantes source: galaxy/golden/toxic, SurfaceGui/Billboard, ancrage d’origine conservé, 4x4x5 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_SeaDog.rbxm | RebirthChampionsX | 12 | non | Pet, variantes source: galaxy/golden/toxic, SurfaceGui/Billboard, ancrage d’origine conservé, 2x3x2 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_SeaMonster.rbxm | RebirthChampionsX | 9 | non | Pet, variantes source: galaxy/golden/toxic, 5 particules/effets, SurfaceGui/Billboard, ancrage d’origine conservé, 14x6x6 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_ShadowDragon.rbxm | RebirthChampionsX | 17 | non | Pet, variantes source: galaxy/golden/toxic, SurfaceGui/Billboard, ancrage d’origine conservé, 9x8x3 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_Shark.rbxm | RebirthChampionsX | 3 | non | Pet, variantes source: galaxy/golden/toxic, SurfaceGui/Billboard, ancrage d’origine conservé, 4x2x2 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_Snowball.rbxm | RebirthChampionsX | 1 | non | Pet, variantes source: galaxy/golden/toxic, SurfaceGui/Billboard, ancrage d’origine conservé, 2x2x2 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_SnowBear.rbxm | RebirthChampionsX | 3 | non | Pet, variantes source: galaxy/golden/toxic, SurfaceGui/Billboard, ancrage d’origine conservé, 2x3x2 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_Snowman.rbxm | RebirthChampionsX | 11 | non | Pet, variantes source: galaxy/golden/toxic, SurfaceGui/Billboard, ancrage d’origine conservé, 2x4x2 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_SnowOverlord.rbxm | RebirthChampionsX | 10 | non | Pet, variantes source: galaxy/golden/toxic, 3 particules/effets, SurfaceGui/Billboard, ancrage d’origine conservé, 16x12x9 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_SpaceBunny.rbxm | RebirthChampionsX | 7 | non | Pet, variantes source: galaxy/golden/toxic, SurfaceGui/Billboard, ancrage d’origine conservé, 2x3x3 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_SpaceDog.rbxm | RebirthChampionsX | 6 | non | Pet, variantes source: galaxy/golden/toxic, SurfaceGui/Billboard, ancrage d’origine conservé, 3x2x2 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_Spider.rbxm | RebirthChampionsX | 5 | non | Pet, variantes source: galaxy/golden/toxic, SurfaceGui/Billboard, ancrage d’origine conservé, 4x2x3 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_SplitBunny.rbxm | RebirthChampionsX | 11 | non | Pet, variantes source: galaxy/golden/toxic, SurfaceGui/Billboard, ancrage d’origine conservé, 2x4x3 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_SpringBunny.rbxm | RebirthChampionsX | 11 | non | Pet, variantes source: galaxy/golden/toxic, 2 particules/effets, SurfaceGui/Billboard, ancrage d’origine conservé, 3x6x3 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_SpringDragon.rbxm | RebirthChampionsX | 24 | non | Pet, variantes source: galaxy/golden/toxic, SurfaceGui/Billboard, ancrage d’origine conservé, 12x4x4 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_SpringImmortal.rbxm | RebirthChampionsX | 12 | non | Pet, variantes source: galaxy/golden/toxic, 1 particules/effets, SurfaceGui/Billboard, ancrage d’origine conservé, 15x14x8 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_SpringSoul.rbxm | RebirthChampionsX | 14 | non | Pet, variantes source: galaxy/golden/toxic, 4 particules/effets, SurfaceGui/Billboard, ancrage d’origine conservé, 14x10x16 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_Starfish.rbxm | RebirthChampionsX | 5 | non | Pet, variantes source: galaxy/golden/toxic, 1 particules/effets, SurfaceGui/Billboard, ancrage d’origine conservé, 5x5x1 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_StarOverlord.rbxm | RebirthChampionsX | 8 | non | Pet, variantes source: galaxy/golden/toxic, 1 particules/effets, SurfaceGui/Billboard, ancrage d’origine conservé, 13x7x4 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_Tedy.rbxm | RebirthChampionsX | 9 | non | Pet, variantes source: galaxy/golden/toxic, SurfaceGui/Billboard, ancrage d’origine conservé, 4x4x3 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_Turtle.rbxm | RebirthChampionsX | 5 | non | Pet, variantes source: galaxy/golden/toxic, SurfaceGui/Billboard, ancrage d’origine conservé, 2x2x3 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_Tutel.rbxm | RebirthChampionsX | 5 | non | Pet, variantes source: galaxy/golden/toxic, SurfaceGui/Billboard, ancrage d’origine conservé, 8x10x13 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_UFO.rbxm | RebirthChampionsX | 8 | non | Pet, variantes source: galaxy/golden/toxic, SurfaceGui/Billboard, ancrage d’origine conservé, 6x3x6 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_VoidBunny.rbxm | RebirthChampionsX | 6 | non | Pet, variantes source: galaxy/golden/toxic, SurfaceGui/Billboard, ancrage d’origine conservé, 2x3x2 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_VoidCat.rbxm | RebirthChampionsX | 9 | non | Pet, variantes source: galaxy/golden/toxic, SurfaceGui/Billboard, ancrage d’origine conservé, 2x3x3 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_VoidDog.rbxm | RebirthChampionsX | 7 | non | Pet, variantes source: galaxy/golden/toxic, SurfaceGui/Billboard, ancrage d’origine conservé, 2x2x2 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_VoidGod.rbxm | RebirthChampionsX | 21 | non | Pet, variantes source: galaxy/golden/toxic, 8 particules/effets, SurfaceGui/Billboard, ancrage d’origine conservé, 44x24x17 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_VoidHydra.rbxm | RebirthChampionsX | 13 | non | Pet, variantes source: galaxy/golden/toxic, 1 particules/effets, SurfaceGui/Billboard, ancrage d’origine conservé, 5x4x3 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_VoidKing.rbxm | RebirthChampionsX | 18 | non | Pet, variantes source: galaxy/golden/toxic, 6 particules/effets, SurfaceGui/Billboard, ancrage d’origine conservé, 19x19x10 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_VoidOverlord.rbxm | RebirthChampionsX | 11 | non | Pet, variantes source: galaxy/golden/toxic, 2 particules/effets, SurfaceGui/Billboard, ancrage d’origine conservé, 14x9x5 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_VoidPlanet.rbxm | RebirthChampionsX | 4 | non | Pet, variantes source: galaxy/golden/toxic, 2 particules/effets, SurfaceGui/Billboard, ancrage d’origine conservé, 6x4x6 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_WaterBall.rbxm | RebirthChampionsX | 4 | non | Pet, variantes source: galaxy/golden/toxic, 2 particules/effets, SurfaceGui/Billboard, ancrage d’origine conservé, 3x4x3 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_WaterDragon.rbxm | RebirthChampionsX | 9 | non | Pet, variantes source: galaxy/golden/toxic, SurfaceGui/Billboard, ancrage d’origine conservé, 9x5x3 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_WaterMonster.rbxm | RebirthChampionsX | 5 | non | Pet, variantes source: galaxy/golden/toxic, SurfaceGui/Billboard, ancrage d’origine conservé, 14x6x4 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_WaterShard.rbxm | RebirthChampionsX | 7 | non | Pet, variantes source: galaxy/golden/toxic, SurfaceGui/Billboard, ancrage d’origine conservé, 6x9x4 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_WitchPot.rbxm | RebirthChampionsX | 3 | non | Pet, variantes source: galaxy/golden/toxic, SurfaceGui/Billboard, ancrage d’origine conservé, 3x2x3 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_Wolf.rbxm | RebirthChampionsX | 5 | non | Pet, variantes source: galaxy/golden/toxic, SurfaceGui/Billboard, ancrage d’origine conservé, 2x2x2 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_Zombie.rbxm | RebirthChampionsX | 5 | non | Pet, variantes source: galaxy/golden/toxic, SurfaceGui/Billboard, ancrage d’origine conservé, 3x3x2 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_ZombieTutel.rbxm | RebirthChampionsX | 7 | non | Pet, variantes source: galaxy/golden/toxic, SurfaceGui/Billboard, ancrage d’origine conservé, 16x17x19 studs (de Rebirth Champions X/Assets.rbxm) |
| RobotSim_AdvancedRobot.rbxm | RobotSim | 7 | non | Pet, ancrage d’origine conservé, 2x3x2 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_Alien.rbxm | RobotSim | 6 | non | Pet, 8 particules/effets, ancrage d’origine conservé, 2x4x4 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_AlienFish.rbxm | RobotSim | 5 | non | Pet, 8 particules/effets, ancrage d’origine conservé, 2x3x2 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_AlienLion.rbxm | RobotSim | 9 | non | Pet, 8 particules/effets, ancrage d’origine conservé, 4x3x2 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_AlienSatellite.rbxm | RobotSim | 24 | non | Pet, 22 particules/effets, ancrage d’origine conservé, 4x5x2 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_ArcticFox.rbxm | RobotSim | 5 | non | Pet, ancrage d’origine conservé, 3x3x3 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_Asteroid.rbxm | RobotSim | 2 | non | Pet, 4 particules/effets, ancrage d’origine conservé, 2x2x2 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_Astronaut.rbxm | RobotSim | 11 | non | Pet, 4 particules/effets, ancrage d’origine conservé, 3x3x3 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_Austin.rbxm | RobotSim | 7 | non | Pet, ancrage d’origine conservé, 3x4x2 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_BaconHair.rbxm | RobotSim | 4 | non | Pet, ancrage d’origine conservé, 4x3x4 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_BrickBear.rbxm | RobotSim | 12 | non | Pet, ancrage d’origine conservé, 2x3x3 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_BrickBunny.rbxm | RobotSim | 12 | non | Pet, ancrage d’origine conservé, 2x5x2 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_BrickCat.rbxm | RobotSim | 12 | non | Pet, ancrage d’origine conservé, 2x4x3 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_BrickDeer.rbxm | RobotSim | 14 | non | Pet, ancrage d’origine conservé, 2x5x4 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_BrickDog.rbxm | RobotSim | 9 | non | Pet, ancrage d’origine conservé, 2x3x3 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_BrickDragon.rbxm | RobotSim | 11 | non | Pet, ancrage d’origine conservé, 3x3x4 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_BrickPig.rbxm | RobotSim | 12 | non | Pet, ancrage d’origine conservé, 2x3x2 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_BrickRobot.rbxm | RobotSim | 11 | non | Pet, ancrage d’origine conservé, 2x4x3 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_BrickWolf.rbxm | RobotSim | 12 | non | Pet, ancrage d’origine conservé, 2x3x2 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_CamGuy.rbxm | RobotSim | 10 | non | Pet, ancrage d’origine conservé, 3x4x5 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_Champ-OLD.rbxm | RobotSim | 5 | non | Pet, ancrage d’origine conservé, 3x4x2 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_Champ.rbxm | RobotSim | 5 | non | Pet, ancrage d’origine conservé, 3x4x2 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_Chicken.rbxm | RobotSim | 6 | non | Pet, ancrage d’origine conservé, 2x4x2 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_Chomp.rbxm | RobotSim | 10 | non | Pet, 3 particules/effets, ancrage d’origine conservé, 3x4x3 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_CityCat.rbxm | RobotSim | 7 | non | Pet, 3 particules/effets, ancrage d’origine conservé, 2x4x3 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_CodexGeas.rbxm | RobotSim | 10 | non | Pet, ancrage d’origine conservé, 3x4x3 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_Cow.rbxm | RobotSim | 5 | non | Pet, ancrage d’origine conservé, 2x4x2 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_Crab.rbxm | RobotSim | 20 | non | Pet, ancrage d’origine conservé, 3x3x5 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_CrewRox.rbxm | RobotSim | 9 | non | Pet, ancrage d’origine conservé, 3x4x7 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_Crystal.rbxm | RobotSim | 3 | non | Pet, ancrage d’origine conservé, 2x3x2 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_CrystalizedBear.rbxm | RobotSim | 7 | non | Pet, ancrage d’origine conservé, 2x3x2 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_CrystalizedBunny.rbxm | RobotSim | 7 | non | Pet, ancrage d’origine conservé, 2x4x2 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_CrystalizedCat.rbxm | RobotSim | 7 | non | Pet, ancrage d’origine conservé, 2x4x2 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_CrystalizedDog.rbxm | RobotSim | 4 | non | Pet, ancrage d’origine conservé, 2x3x3 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_CrystalizedDragon.rbxm | RobotSim | 6 | non | Pet, ancrage d’origine conservé, 3x3x4 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_CrystalizedGolem.rbxm | RobotSim | 3 | non | Pet, ancrage d’origine conservé, 2x3x2 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_CrystalizedRobot.rbxm | RobotSim | 6 | non | Pet, ancrage d’origine conservé, 2x3x3 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_CrystalizedWolf.rbxm | RobotSim | 7 | non | Pet, ancrage d’origine conservé, 2x3x2 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_CyborgDog.rbxm | RobotSim | 4 | non | Pet, ancrage d’origine conservé, 2x2x3 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_Deeter.rbxm | RobotSim | 10 | non | Pet, ancrage d’origine conservé, 3x4x3 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_Dino.rbxm | RobotSim | 6 | non | Pet, ancrage d’origine conservé, 2x4x2 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_Duck.rbxm | RobotSim | 5 | non | Pet, ancrage d’origine conservé, 2x3x2 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_Egg.rbxm | RobotSim | 1 | non | Pet, ancrage d’origine conservé, 3x5x4 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_EvilCyborg.rbxm | RobotSim | 3 | non | Pet, ancrage d’origine conservé, 2x2x2 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_EvilDeer.rbxm | RobotSim | 9 | non | Pet, ancrage d’origine conservé, 2x4x4 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_EvilHumanCyborg.rbxm | RobotSim | 9 | non | Pet, ancrage d’origine conservé, 2x2x2 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_FancyRobot.rbxm | RobotSim | 7 | non | Pet, ancrage d’origine conservé, 2x5x3 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_FireIce.rbxm | RobotSim | 13 | non | Pet, ancrage d’origine conservé, 3x3x8 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_FlyingPig.rbxm | RobotSim | 23 | non | Pet, ancrage d’origine conservé, 3x4x5 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_Fox.rbxm | RobotSim | 7 | non | Pet, ancrage d’origine conservé, 2x3x2 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_Fraser.rbxm | RobotSim | 8 | non | Pet, ancrage d’origine conservé, 2x4x2 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_FrostCat.rbxm | RobotSim | 7 | non | Pet, ancrage d’origine conservé, 2x4x3 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_FrostDog.rbxm | RobotSim | 4 | non | Pet, ancrage d’origine conservé, 2x3x4 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_FrozenRobot.rbxm | RobotSim | 5 | non | Pet, ancrage d’origine conservé, 2x4x3 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_GamesReborn.rbxm | RobotSim | 8 | non | Pet, ancrage d’origine conservé, 3x4x3 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_Gingerbread.rbxm | RobotSim | 16 | non | Pet, 3 particules/effets, ancrage d’origine conservé, 2x3x2 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_Golem.rbxm | RobotSim | 3 | non | Pet, ancrage d’origine conservé, 2x2x2 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_GuineaPig.rbxm | RobotSim | 2 | non | Pet, ancrage d’origine conservé, 3x3x3 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_GusTV.rbxm | RobotSim | 7 | non | Pet, 3 particules/effets, ancrage d’origine conservé, 2x3x3 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_HumanCyborg.rbxm | RobotSim | 9 | non | Pet, ancrage d’origine conservé, 2x2x2 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_Iceyfire.rbxm | RobotSim | 13 | non | Pet, ancrage d’origine conservé, 4x4x11 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_Jojo.rbxm | RobotSim | 7 | non | Pet, ancrage d’origine conservé, 2x3x2 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_LightCyborg.rbxm | RobotSim | 3 | non | Pet, ancrage d’origine conservé, 2x2x2 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_Lizard.rbxm | RobotSim | 2 | non | Pet, ancrage d’origine conservé, 2x3x2 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_Madxbutterflies.rbxm | RobotSim | 3 | non | Pet, ancrage d’origine conservé, 4x5x4 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_MagmaBear.rbxm | RobotSim | 6 | non | Pet, ancrage d’origine conservé, 2x3x3 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_MagmaCat.rbxm | RobotSim | 6 | non | Pet, ancrage d’origine conservé, 2x4x3 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_MagmaDog.rbxm | RobotSim | 3 | non | Pet, ancrage d’origine conservé, 2x3x4 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_MagmaDragon.rbxm | RobotSim | 4 | non | Pet, ancrage d’origine conservé, 3x3x4 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_MagmaMouse.rbxm | RobotSim | 6 | non | Pet, ancrage d’origine conservé, 2x4x3 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_MagmaRobot.rbxm | RobotSim | 5 | non | Pet, ancrage d’origine conservé, 2x4x3 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_Marcos.rbxm | RobotSim | 8 | non | Pet, ancrage d’origine conservé, 3x3x3 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_MegaAlien.rbxm | RobotSim | 6 | non | Pet, 8 particules/effets, ancrage d’origine conservé, 3x5x5 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_MegaBaconHair.rbxm | RobotSim | 4 | non | Pet, ancrage d’origine conservé, 5x4x5 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_MegaGuineaPig.rbxm | RobotSim | 2 | non | Pet, ancrage d’origine conservé, 4x4x4 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_MegaPhixxle.rbxm | RobotSim | 3 | non | Pet, ancrage d’origine conservé, 3x3x3 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_MegaRobot.rbxm | RobotSim | 5 | non | Pet, ancrage d’origine conservé, 3x6x4 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_MiniBaconHair.rbxm | RobotSim | 4 | non | Pet, ancrage d’origine conservé, 3x3x3 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_MiniBlast.rbxm | RobotSim | 7 | non | Pet, ancrage d’origine conservé, 4x5x5 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_MiniBucket.rbxm | RobotSim | 6 | non | Pet, ancrage d’origine conservé, 3x3x3 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_MiniRock.rbxm | RobotSim | 1 | non | Pet, ancrage d’origine conservé, 2x3x3 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_mmistaken.rbxm | RobotSim | 5 | non | Pet, ancrage d’origine conservé, 3x5x3 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_Monopoli.rbxm | RobotSim | 8 | non | Pet, ancrage d’origine conservé, 4x3x3 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_Muneeb.rbxm | RobotSim | 8 | non | Pet, ancrage d’origine conservé, 3x4x3 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_Narwhal.rbxm | RobotSim | 4 | non | Pet, ancrage d’origine conservé, 4x4x5 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_Oneo.rbxm | RobotSim | 5 | non | Pet, ancrage d’origine conservé, 2x4x2 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_Opa.rbxm | RobotSim | 7 | non | Pet, ancrage d’origine conservé, 2x2x2 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_Overlord.rbxm | RobotSim | 4 | non | Pet, ancrage d’origine conservé, 3x3x4 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_Penguin.rbxm | RobotSim | 3 | non | Pet, ancrage d’origine conservé, 2x3x2 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_Phixxle.rbxm | RobotSim | 3 | non | Pet, ancrage d’origine conservé, 2x2x2 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_Pig.rbxm | RobotSim | 7 | non | Pet, ancrage d’origine conservé, 2x3x2 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_PolarBear.rbxm | RobotSim | 7 | non | Pet, ancrage d’origine conservé, 2x4x3 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_Rabbit.rbxm | RobotSim | 7 | non | Pet, ancrage d’origine conservé, 2x5x2 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_Robot.rbxm | RobotSim | 5 | non | Pet, ancrage d’origine conservé, 2x4x3 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_RobotAstronaut.rbxm | RobotSim | 13 | non | Pet, 4 particules/effets, ancrage d’origine conservé, 3x4x4 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_RobotBear.rbxm | RobotSim | 7 | non | Pet, ancrage d’origine conservé, 2x3x3 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_RobotBunny.rbxm | RobotSim | 8 | non | Pet, ancrage d’origine conservé, 2x4x2 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_RobotDeer.rbxm | RobotSim | 9 | non | Pet, ancrage d’origine conservé, 2x4x4 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_RobotDino.rbxm | RobotSim | 6 | non | Pet, ancrage d’origine conservé, 2x4x2 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_RobotDragon.rbxm | RobotSim | 6 | non | Pet, ancrage d’origine conservé, 3x3x4 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_RoboticAlien.rbxm | RobotSim | 6 | non | Pet, 8 particules/effets, ancrage d’origine conservé, 2x4x4 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_RoboticBird.rbxm | RobotSim | 12 | non | Pet, ancrage d’origine conservé, 3x2x2 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_RoboticBucket.rbxm | RobotSim | 6 | non | Pet, ancrage d’origine conservé, 3x4x4 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_RoboticDog.rbxm | RobotSim | 10 | non | Pet, ancrage d’origine conservé, 2x2x2 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_RoboticPolarBear.rbxm | RobotSim | 7 | non | Pet, ancrage d’origine conservé, 2x4x3 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_RobotStack.rbxm | RobotSim | 8 | non | Pet, ancrage d’origine conservé, 2x6x3 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_Rock.rbxm | RobotSim | 1 | non | Pet, ancrage d’origine conservé, 3x4x4 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_Sabrina.rbxm | RobotSim | 8 | non | Pet, ancrage d’origine conservé, 3x4x3 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_Sheep.rbxm | RobotSim | 3 | non | Pet, ancrage d’origine conservé, 2x3x2 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_Simas.rbxm | RobotSim | 9 | non | Pet, ancrage d’origine conservé, 2x3x2 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_Snug.rbxm | RobotSim | 7 | non | Pet, ancrage d’origine conservé, 3x3x2 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_SparkleBear.rbxm | RobotSim | 7 | non | Pet, 2 particules/effets, ancrage d’origine conservé, 2x3x3 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_SparkleBunny.rbxm | RobotSim | 7 | non | Pet, 2 particules/effets, ancrage d’origine conservé, 2x5x2 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_SparkleCat.rbxm | RobotSim | 7 | non | Pet, 2 particules/effets, ancrage d’origine conservé, 2x4x3 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_SparkleDeer.rbxm | RobotSim | 9 | non | Pet, 2 particules/effets, ancrage d’origine conservé, 2x5x4 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_SparkleDog.rbxm | RobotSim | 4 | non | Pet, 2 particules/effets, ancrage d’origine conservé, 2x3x3 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_SparkleDragon.rbxm | RobotSim | 5 | non | Pet, 2 particules/effets, ancrage d’origine conservé, 3x3x4 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_SparkleFox.rbxm | RobotSim | 5 | non | Pet, 2 particules/effets, ancrage d’origine conservé, 3x3x2 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_SparkleMouse.rbxm | RobotSim | 7 | non | Pet, 2 particules/effets, ancrage d’origine conservé, 2x4x3 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_SparkleRobot.rbxm | RobotSim | 5 | non | Pet, 2 particules/effets, ancrage d’origine conservé, 2x4x3 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_SpikyBear.rbxm | RobotSim | 12 | non | Pet, ancrage d’origine conservé, 2x3x4 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_SpikyDino.rbxm | RobotSim | 8 | non | Pet, ancrage d’origine conservé, 2x3x4 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_SpikyDragon.rbxm | RobotSim | 8 | non | Pet, ancrage d’origine conservé, 2x3x4 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_SpikyFox.rbxm | RobotSim | 10 | non | Pet, ancrage d’origine conservé, 3x3x4 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_SpikyMouse.rbxm | RobotSim | 12 | non | Pet, ancrage d’origine conservé, 2x3x4 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_SpikyRobot.rbxm | RobotSim | 8 | non | Pet, ancrage d’origine conservé, 2x3x4 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_StarBlasto.rbxm | RobotSim | 7 | non | Pet, ancrage d’origine conservé, 3x3x3 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_SuperMiniBlast.rbxm | RobotSim | 7 | non | Pet, ancrage d’origine conservé, 4x4x4 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_Telanthric.rbxm | RobotSim | 9 | non | Pet, ancrage d’origine conservé, 4x5x5 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_Tempest.rbxm | RobotSim | 7 | non | Pet, ancrage d’origine conservé, 4x5x4 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_ThreeHeadedAlien.rbxm | RobotSim | 10 | non | Pet, 8 particules/effets, ancrage d’origine conservé, 2x5x7 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_Thunder.rbxm | RobotSim | 15 | non | Pet, 4 particules/effets, ancrage d’origine conservé, 6x5x14 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_ThunderYT.rbxm | RobotSim | 15 | non | Pet, 4 particules/effets, ancrage d’origine conservé, 4x3x9 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_Ve_xr.rbxm | RobotSim | 9 | non | Pet, ancrage d’origine conservé, 3x5x3 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_VipCat.rbxm | RobotSim | 10 | non | Pet, 4 particules/effets, ancrage d’origine conservé, 4x5x4 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_VipDog.rbxm | RobotSim | 6 | non | Pet, 4 particules/effets, ancrage d’origine conservé, 4x5x4 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_VipDragon.rbxm | RobotSim | 8 | non | Pet, 4 particules/effets, ancrage d’origine conservé, 5x5x4 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_VipRobot.rbxm | RobotSim | 6 | non | Pet, 4 particules/effets, ancrage d’origine conservé, 4x5x4 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_Walrus.rbxm | RobotSim | 4 | non | Pet, ancrage d’origine conservé, 2x3x3 studs (de Robot Simulator/Pets.rbxm) |
| RobotSim_Wolf.rbxm | RobotSim | 7 | non | Pet, ancrage d’origine conservé, 2x3x2 studs (de Robot Simulator/Pets.rbxm) |
| TappingLords_100K.rbxm | TappingLords | 3 | oui (1) | Pet, variantes source: golden/shiny, SurfaceGui/Billboard, ancrage d’origine conservé, 2x3x6 studs (de Tapping-Lords-Simulator/Pets.rbxm) |
| TappingLords_100KBeast.rbxm | TappingLords | 7 | oui (1) | Pet, variantes source: golden/shiny, SurfaceGui/Billboard, ancrage d’origine conservé, 4x4x6 studs (de Tapping-Lords-Simulator/Pets.rbxm) |
| TappingLords_100KRing.rbxm | TappingLords | 7 | oui (1) | Pet, variantes source: golden/shiny, SurfaceGui/Billboard, ancrage d’origine conservé, 6x4x7 studs (de Tapping-Lords-Simulator/Pets.rbxm) |
| TappingLords_100KShard.rbxm | TappingLords | 2 | oui (1) | Pet, variantes source: golden/shiny, SurfaceGui/Billboard, ancrage d’origine conservé, 10x11x5 studs (de Tapping-Lords-Simulator/Pets.rbxm) |
| TappingLords_AlienCat.rbxm | TappingLords | 17 | oui (1) | Pet, variantes source: golden/shiny, SurfaceGui/Billboard, ancrage d’origine conservé, 3x4x4 studs (de Tapping-Lords-Simulator/Pets.rbxm) |
| TappingLords_AlienCreature.rbxm | TappingLords | 20 | oui (1) | Pet, variantes source: golden/shiny, SurfaceGui/Billboard, ancrage d’origine conservé, 5x10x11 studs (de Tapping-Lords-Simulator/Pets.rbxm) |
| TappingLords_AngelicButton.rbxm | TappingLords | 7 | oui (1) | Pet, variantes source: golden/shiny, SurfaceGui/Billboard, ancrage d’origine conservé, 4x4x12 studs (de Tapping-Lords-Simulator/Pets.rbxm) |
| TappingLords_Anglerfish.rbxm | TappingLords | 6 | oui (1) | Pet, variantes source: golden/shiny, 5 particules/effets, SurfaceGui/Billboard, ancrage d’origine conservé, 4x4x3 studs (de Tapping-Lords-Simulator/Pets.rbxm) |
| TappingLords_Asteroid.rbxm | TappingLords | 6 | oui (1) | Pet, variantes source: golden/shiny, SurfaceGui/Billboard, ancrage d’origine conservé, 4x3x3 studs (de Tapping-Lords-Simulator/Pets.rbxm) |
| TappingLords_AutoEggPet.rbxm | TappingLords | 1 | oui (1) | Pet, variantes source: golden/shiny, SurfaceGui/Billboard, ancrage d’origine conservé, 4x4x4 studs (de Tapping-Lords-Simulator/Pets.rbxm) |
| TappingLords_BaconHair.rbxm | TappingLords | 1 | oui (1) | Pet, variantes source: golden/shiny, SurfaceGui/Billboard, ancrage d’origine conservé, 2x1x2 studs (de Tapping-Lords-Simulator/Pets.rbxm) |
| TappingLords_Bear.rbxm | TappingLords | 5 | oui (1) | Pet, variantes source: golden/shiny, SurfaceGui/Billboard, ancrage d’origine conservé, 2x2x2 studs (de Tapping-Lords-Simulator/Pets.rbxm) |
| TappingLords_BlueDominus.rbxm | TappingLords | 2 | oui (1) | Pet, variantes source: golden/shiny, SurfaceGui/Billboard, ancrage d’origine conservé, 2x2x2 studs (de Tapping-Lords-Simulator/Pets.rbxm) |
| TappingLords_BrokenYoutube.rbxm | TappingLords | 16 | oui (1) | Pet, variantes source: golden/shiny, SurfaceGui/Billboard, ancrage d’origine conservé, 7x10x11 studs (de Tapping-Lords-Simulator/Pets.rbxm) |
| TappingLords_Bunny.rbxm | TappingLords | 4 | oui (1) | Pet, variantes source: golden/shiny, SurfaceGui/Billboard, ancrage d’origine conservé, 2x3x2 studs (de Tapping-Lords-Simulator/Pets.rbxm) |
| TappingLords_Candy.rbxm | TappingLords | 4 | oui (1) | Pet, variantes source: golden/shiny, SurfaceGui/Billboard, ancrage d’origine conservé, 5x3x3 studs (de Tapping-Lords-Simulator/Pets.rbxm) |
| TappingLords_CandyBat.rbxm | TappingLords | 5 | oui (1) | Pet, variantes source: golden/shiny, SurfaceGui/Billboard, ancrage d’origine conservé, 3x2x5 studs (de Tapping-Lords-Simulator/Pets.rbxm) |
| TappingLords_Coconut.rbxm | TappingLords | 1 | oui (1) | Pet, variantes source: golden/shiny, SurfaceGui/Billboard, ancrage d’origine conservé, 2x2x2 studs (de Tapping-Lords-Simulator/Pets.rbxm) |
| TappingLords_Crab.rbxm | TappingLords | 9 | oui (1) | Pet, variantes source: golden/shiny, SurfaceGui/Billboard, ancrage d’origine conservé, 4x2x4 studs (de Tapping-Lords-Simulator/Pets.rbxm) |
| TappingLords_Crown.rbxm | TappingLords | 2 | oui (1) | Pet, variantes source: golden/shiny, SurfaceGui/Billboard, ancrage d’origine conservé, 3x1x3 studs (de Tapping-Lords-Simulator/Pets.rbxm) |
| TappingLords_Deer.rbxm | TappingLords | 5 | oui (1) | Pet, variantes source: golden/shiny, SurfaceGui/Billboard, ancrage d’origine conservé, 2x3x2 studs (de Tapping-Lords-Simulator/Pets.rbxm) |
| TappingLords_Dragon.rbxm | TappingLords | 5 | oui (1) | Pet, variantes source: golden/shiny, SurfaceGui/Billboard, ancrage d’origine conservé, 2x2x4 studs (de Tapping-Lords-Simulator/Pets.rbxm) |
| TappingLords_Elephant.rbxm | TappingLords | 8 | oui (1) | Pet, variantes source: golden/shiny, SurfaceGui/Billboard, ancrage d’origine conservé, 4x2x4 studs (de Tapping-Lords-Simulator/Pets.rbxm) |
| TappingLords_ForestBat.rbxm | TappingLords | 4 | oui (1) | Pet, variantes source: golden/shiny, SurfaceGui/Billboard, ancrage d’origine conservé, 2x2x5 studs (de Tapping-Lords-Simulator/Pets.rbxm) |
| TappingLords_ForestGolem.rbxm | TappingLords | 4 | oui (1) | Pet, variantes source: golden/shiny, SurfaceGui/Billboard, ancrage d’origine conservé, 3x3x2 studs (de Tapping-Lords-Simulator/Pets.rbxm) |
| TappingLords_ForestOrg.rbxm | TappingLords | 6 | oui (1) | Pet, variantes source: golden/shiny, SurfaceGui/Billboard, ancrage d’origine conservé, 8x7x8 studs (de Tapping-Lords-Simulator/Pets.rbxm) |
| TappingLords_Fox.rbxm | TappingLords | 5 | oui (1) | Pet, variantes source: golden/shiny, SurfaceGui/Billboard, ancrage d’origine conservé, 2x2x2 studs (de Tapping-Lords-Simulator/Pets.rbxm) |
| TappingLords_GamePowerOrb.rbxm | TappingLords | 5 | oui (1) | Pet, variantes source: golden/shiny, SurfaceGui/Billboard, ancrage d’origine conservé, 5x6x7 studs (de Tapping-Lords-Simulator/Pets.rbxm) |
| TappingLords_GreenDominus.rbxm | TappingLords | 6 | non | Pet, variantes source: golden/shiny, ancrage d’origine conservé, 3x3x3 studs (de Tapping-Lords-Simulator/Pets.rbxm) |
| TappingLords_GummyBear.rbxm | TappingLords | 3 | oui (1) | Pet, variantes source: golden/shiny, SurfaceGui/Billboard, ancrage d’origine conservé, 4x6x3 studs (de Tapping-Lords-Simulator/Pets.rbxm) |
| TappingLords_HauntedForestGolem.rbxm | TappingLords | 15 | oui (1) | Pet, variantes source: golden/shiny, SurfaceGui/Billboard, ancrage d’origine conservé, 5x4x5 studs (de Tapping-Lords-Simulator/Pets.rbxm) |
| TappingLords_Hydra.rbxm | TappingLords | 9 | oui (1) | Pet, variantes source: golden/shiny, 4 particules/effets, SurfaceGui/Billboard, ancrage d’origine conservé, 6x10x14 studs (de Tapping-Lords-Simulator/Pets.rbxm) |
| TappingLords_IcecreamCone.rbxm | TappingLords | 6 | oui (1) | Pet, variantes source: golden/shiny, SurfaceGui/Billboard, ancrage d’origine conservé, 3x7x2 studs (de Tapping-Lords-Simulator/Pets.rbxm) |
| TappingLords_InfernalDragon.rbxm | TappingLords | 13 | oui (1) | Pet, variantes source: golden/shiny, SurfaceGui/Billboard, ancrage d’origine conservé, 4x5x12 studs (de Tapping-Lords-Simulator/Pets.rbxm) |
| TappingLords_Jellyfish.rbxm | TappingLords | 4 | oui (1) | Pet, variantes source: golden/shiny, 5 particules/effets, SurfaceGui/Billboard, ancrage d’origine conservé, 3x6x3 studs (de Tapping-Lords-Simulator/Pets.rbxm) |
| TappingLords_JungleElephant.rbxm | TappingLords | 14 | oui (1) | Pet, variantes source: golden/shiny, 3 particules/effets, SurfaceGui/Billboard, ancrage d’origine conservé, 11x9x11 studs (de Tapping-Lords-Simulator/Pets.rbxm) |
| TappingLords_LavaBear.rbxm | TappingLords | 6 | oui (1) | Pet, variantes source: golden/shiny, 3 particules/effets, SurfaceGui/Billboard, ancrage d’origine conservé, 4x4x4 studs (de Tapping-Lords-Simulator/Pets.rbxm) |
| TappingLords_LavaBeast.rbxm | TappingLords | 21 | oui (1) | Pet, variantes source: golden/shiny, SurfaceGui/Billboard, ancrage d’origine conservé, 2x3x4 studs (de Tapping-Lords-Simulator/Pets.rbxm) |
| TappingLords_LavaDeer.rbxm | TappingLords | 6 | oui (1) | Pet, variantes source: golden/shiny, 3 particules/effets, SurfaceGui/Billboard, ancrage d’origine conservé, 5x6x4 studs (de Tapping-Lords-Simulator/Pets.rbxm) |
| TappingLords_LavaFox.rbxm | TappingLords | 6 | oui (1) | Pet, variantes source: golden/shiny, 3 particules/effets, SurfaceGui/Billboard, ancrage d’origine conservé, 4x5x3 studs (de Tapping-Lords-Simulator/Pets.rbxm) |
| TappingLords_LavaWolf.rbxm | TappingLords | 5 | oui (1) | Pet, variantes source: golden/shiny, 3 particules/effets, SurfaceGui/Billboard, ancrage d’origine conservé, 5x5x4 studs (de Tapping-Lords-Simulator/Pets.rbxm) |
| TappingLords_LimeDominus.rbxm | TappingLords | 2 | oui (1) | Pet, variantes source: golden/shiny, SurfaceGui/Billboard, ancrage d’origine conservé, 3x3x3 studs (de Tapping-Lords-Simulator/Pets.rbxm) |
| TappingLords_LimeGreenDominus.rbxm | TappingLords | 6 | oui (1) | Pet, variantes source: golden/shiny, SurfaceGui/Billboard, ancrage d’origine conservé, 3x3x3 studs (de Tapping-Lords-Simulator/Pets.rbxm) |
| TappingLords_Lollipop.rbxm | TappingLords | 4 | oui (1) | Pet, variantes source: golden/shiny, SurfaceGui/Billboard, ancrage d’origine conservé, 3x5x3 studs (de Tapping-Lords-Simulator/Pets.rbxm) |
| TappingLords_Megalodon.rbxm | TappingLords | 4 | oui (1) | Pet, variantes source: golden/shiny, 5 particules/effets, SurfaceGui/Billboard, ancrage d’origine conservé, 10x9x12 studs (de Tapping-Lords-Simulator/Pets.rbxm) |
| TappingLords_MiniBest.rbxm | TappingLords | 4 | oui (1) | Pet, variantes source: golden/shiny, SurfaceGui/Billboard, ancrage d’origine conservé, 2x2x2 studs (de Tapping-Lords-Simulator/Pets.rbxm) |
| TappingLords_MiniBossMan.rbxm | TappingLords | 3 | oui (1) | Pet, variantes source: golden/shiny, SurfaceGui/Billboard, ancrage d’origine conservé, 1x3x2 studs (de Tapping-Lords-Simulator/Pets.rbxm) |
| TappingLords_Minibskillz.rbxm | TappingLords | 3 | oui (1) | Pet, variantes source: golden/shiny, SurfaceGui/Billboard, ancrage d’origine conservé, 2x2x2 studs (de Tapping-Lords-Simulator/Pets.rbxm) |
| TappingLords_MiniCaviar.rbxm | TappingLords | 4 | oui (1) | Pet, variantes source: golden/shiny, SurfaceGui/Billboard, ancrage d’origine conservé, 4x7x5 studs (de Tapping-Lords-Simulator/Pets.rbxm) |
| TappingLords_MiniCode.rbxm | TappingLords | 4 | oui (1) | Pet, variantes source: golden/shiny, SurfaceGui/Billboard, ancrage d’origine conservé, 5x7x5 studs (de Tapping-Lords-Simulator/Pets.rbxm) |
| TappingLords_MiniDorner.rbxm | TappingLords | 4 | oui (1) | Pet, variantes source: golden/shiny, SurfaceGui/Billboard, ancrage d’origine conservé, 2x4x2 studs (de Tapping-Lords-Simulator/Pets.rbxm) |
| TappingLords_MiniLovre.rbxm | TappingLords | 4 | oui (1) | Pet, variantes source: golden/shiny, SurfaceGui/Billboard, ancrage d’origine conservé, 4x8x5 studs (de Tapping-Lords-Simulator/Pets.rbxm) |
| TappingLords_MiniRoblerom.rbxm | TappingLords | 2 | oui (1) | Pet, variantes source: golden/shiny, SurfaceGui/Billboard, ancrage d’origine conservé, 1x2x2 studs (de Tapping-Lords-Simulator/Pets.rbxm) |
| TappingLords_MiniSensei.rbxm | TappingLords | 5 | oui (1) | Pet, variantes source: golden/shiny, SurfaceGui/Billboard, ancrage d’origine conservé, 4x7x5 studs (de Tapping-Lords-Simulator/Pets.rbxm) |
| TappingLords_MiniSk0t.rbxm | TappingLords | 6 | oui (1) | Pet, variantes source: golden/shiny, SurfaceGui/Billboard, ancrage d’origine conservé, 4x7x5 studs (de Tapping-Lords-Simulator/Pets.rbxm) |
| TappingLords_Mouse.rbxm | TappingLords | 5 | oui (1) | Pet, variantes source: golden/shiny, SurfaceGui/Billboard, ancrage d’origine conservé, 3x3x3 studs (de Tapping-Lords-Simulator/Pets.rbxm) |
| TappingLords_Octopus.rbxm | TappingLords | 3 | oui (1) | Pet, variantes source: golden/shiny, 1 particules/effets, SurfaceGui/Billboard, ancrage d’origine conservé, 4x2x4 studs (de Tapping-Lords-Simulator/Pets.rbxm) |
| TappingLords_OrangeDominus.rbxm | TappingLords | 2 | oui (1) | Pet, variantes source: golden/shiny, SurfaceGui/Billboard, ancrage d’origine conservé, 2x2x2 studs (de Tapping-Lords-Simulator/Pets.rbxm) |
| TappingLords_Parrot.rbxm | TappingLords | 6 | oui (1) | Pet, variantes source: golden/shiny, SurfaceGui/Billboard, ancrage d’origine conservé, 3x3x4 studs (de Tapping-Lords-Simulator/Pets.rbxm) |
| TappingLords_Penguin.rbxm | TappingLords | 6 | oui (1) | Pet, variantes source: golden/shiny, SurfaceGui/Billboard, ancrage d’origine conservé, 2x3x2 studs (de Tapping-Lords-Simulator/Pets.rbxm) |
| TappingLords_Pig.rbxm | TappingLords | 6 | oui (1) | Pet, variantes source: golden/shiny, SurfaceGui/Billboard, ancrage d’origine conservé, 3x3x2 studs (de Tapping-Lords-Simulator/Pets.rbxm) |
| TappingLords_PlushBaconHair.rbxm | TappingLords | 7 | non | Pet, Humanoid, ancrage d’origine conservé, 2x3x2 studs (de Tapping-Lords-Simulator/Workspace/Plush Bacon Hair.rbxm) |
| TappingLords_Popsicle.rbxm | TappingLords | 4 | oui (1) | Pet, variantes source: golden/shiny, SurfaceGui/Billboard, ancrage d’origine conservé, 2x5x1 studs (de Tapping-Lords-Simulator/Pets.rbxm) |
| TappingLords_RedDominus.rbxm | TappingLords | 2 | oui (1) | Pet, variantes source: golden/shiny, SurfaceGui/Billboard, ancrage d’origine conservé, 3x3x3 studs (de Tapping-Lords-Simulator/Pets.rbxm) |
| TappingLords_RedDragon.rbxm | TappingLords | 10 | oui (1) | Pet, variantes source: golden/shiny, SurfaceGui/Billboard, ancrage d’origine conservé, 3x3x5 studs (de Tapping-Lords-Simulator/Pets.rbxm) |
| TappingLords_RobloxPlayButton.rbxm | TappingLords | 2 | oui (1) | Pet, variantes source: golden/shiny, SurfaceGui/Billboard, ancrage d’origine conservé, 3x3x9 studs (de Tapping-Lords-Simulator/Pets.rbxm) |
| TappingLords_RobuxBeast.rbxm | TappingLords | 21 | oui (1) | Pet, variantes source: golden/shiny, 1 particules/effets, SurfaceGui/Billboard, ancrage d’origine conservé, 10x6x15 studs (de Tapping-Lords-Simulator/Pets.rbxm) |
| TappingLords_Russo.rbxm | TappingLords | 4 | oui (1) | Pet, variantes source: golden/shiny, SurfaceGui/Billboard, ancrage d’origine conservé, 7x5x5 studs (de Tapping-Lords-Simulator/Pets.rbxm) |
| TappingLords_Saturn.rbxm | TappingLords | 5 | oui (1) | Pet, variantes source: golden/shiny, SurfaceGui/Billboard, ancrage d’origine conservé, 6x7x7 studs (de Tapping-Lords-Simulator/Pets.rbxm) |
| TappingLords_SecretPetTM.rbxm | TappingLords | 1 | oui (1) | Pet, variantes source: golden/shiny, SurfaceGui/Billboard, ancrage d’origine conservé, 3x3x3 studs (de Tapping-Lords-Simulator/Pets.rbxm) |
| TappingLords_SenseiHead.rbxm | TappingLords | 3 | oui (1) | Pet, variantes source: golden/shiny, SurfaceGui/Billboard, ancrage d’origine conservé, 2x2x3 studs (de Tapping-Lords-Simulator/Pets.rbxm) |
| TappingLords_Sharkpedo.rbxm | TappingLords | 8 | oui (1) | Pet, variantes source: golden/shiny, 3 particules/effets, SurfaceGui/Billboard, ancrage d’origine conservé, 4x4x4 studs (de Tapping-Lords-Simulator/Pets.rbxm) |
| TappingLords_SpaceDoggy.rbxm | TappingLords | 9 | oui (1) | Pet, variantes source: golden/shiny, SurfaceGui/Billboard, ancrage d’origine conservé, 3x3x3 studs (de Tapping-Lords-Simulator/Pets.rbxm) |
| TappingLords_Spaceship.rbxm | TappingLords | 5 | oui (1) | Pet, variantes source: golden/shiny, SurfaceGui/Billboard, ancrage d’origine conservé, 5x10x7 studs (de Tapping-Lords-Simulator/Pets.rbxm) |
| TappingLords_Swine.rbxm | TappingLords | 8 | oui (1) | Pet, variantes source: golden/shiny, SurfaceGui/Billboard, ancrage d’origine conservé, 4x3x2 studs (de Tapping-Lords-Simulator/Pets.rbxm) |
| TappingLords_ToadBoiGaming.rbxm | TappingLords | 7 | oui (1) | Pet, variantes source: golden/shiny, SurfaceGui/Billboard, ancrage d’origine conservé, 7x5x6 studs (de Tapping-Lords-Simulator/Pets.rbxm) |
| TappingLords_Tofuu.rbxm | TappingLords | 4 | oui (1) | Pet, variantes source: golden/shiny, SurfaceGui/Billboard, ancrage d’origine conservé, 6x4x5 studs (de Tapping-Lords-Simulator/Pets.rbxm) |
| TappingLords_Trophy.rbxm | TappingLords | 2 | oui (1) | Pet, variantes source: golden/shiny, SurfaceGui/Billboard, ancrage d’origine conservé, 4x5x6 studs (de Tapping-Lords-Simulator/Pets.rbxm) |
| TappingLords_TwoHeadedSnake.rbxm | TappingLords | 4 | oui (1) | Pet, variantes source: golden/shiny, SurfaceGui/Billboard, ancrage d’origine conservé, 5x1x3 studs (de Tapping-Lords-Simulator/Pets.rbxm) |
| TappingLords_WaterDragon.rbxm | TappingLords | 53 | oui (1) | Pet, variantes source: golden/shiny, 2 particules/effets, SurfaceGui/Billboard, ancrage d’origine conservé, 12x11x27 studs (de Tapping-Lords-Simulator/Pets.rbxm) |
| TappingLords_WaterShard.rbxm | TappingLords | 7 | oui (1) | Pet, variantes source: golden/shiny, SurfaceGui/Billboard, ancrage d’origine conservé, 7x8x15 studs (de Tapping-Lords-Simulator/Pets.rbxm) |
| TappingLords_YellowDominus.rbxm | TappingLords | 6 | non | Pet, variantes source: golden/shiny, ancrage d’origine conservé, 3x3x3 studs (de Tapping-Lords-Simulator/Pets.rbxm) |
| TappingLords_YoutubePlayButton.rbxm | TappingLords | 9 | oui (1) | Pet, variantes source: golden/shiny, SurfaceGui/Billboard, ancrage d’origine conservé, 4x5x9 studs (de Tapping-Lords-Simulator/Pets.rbxm) |
| TappingLords_YoutubeStar.rbxm | TappingLords | 2 | oui (1) | Pet, variantes source: golden/shiny, SurfaceGui/Billboard, ancrage d’origine conservé, 1x3x3 studs (de Tapping-Lords-Simulator/Pets.rbxm) |
| TappingLords_YoutubeTrio.rbxm | TappingLords | 16 | oui (1) | Pet, variantes source: golden/shiny, SurfaceGui/Billboard, ancrage d’origine conservé, 11x11x7 studs (de Tapping-Lords-Simulator/Pets.rbxm) |
| TrainingSim_Anglerfish.rbxm | TrainingSim | 6 | non | Pet, variantes source: shiny, ancrage d’origine conservé, 5x4x4 studs (de TrainingSimulatorEU/Pets.rbxm) |
| TrainingSim_Ant.rbxm | TrainingSim | 2 | non | Pet, variantes source: shiny, ancrage d’origine conservé, 4x3x3 studs (de TrainingSimulatorEU/Pets.rbxm) |
| TrainingSim_Bear.rbxm | TrainingSim | 2 | non | Pet, variantes source: shiny, ancrage d’origine conservé, 2x3x3 studs (de TrainingSimulatorEU/Pets.rbxm) |
| TrainingSim_Bunny.rbxm | TrainingSim | 2 | non | Pet, variantes source: shiny, ancrage d’origine conservé, 3x4x3 studs (de TrainingSimulatorEU/Pets.rbxm) |
| TrainingSim_BusinessCat.rbxm | TrainingSim | 13 | non | Pet, variantes source: shiny, ancrage d’origine conservé, 5x6x7 studs (de TrainingSimulatorEU/Pets.rbxm) |
| TrainingSim_CandyBunny.rbxm | TrainingSim | 9 | non | Pet, variantes source: shiny, ancrage d’origine conservé, 3x4x3 studs (de TrainingSimulatorEU/Pets.rbxm) |
| TrainingSim_CandyCat.rbxm | TrainingSim | 9 | non | Pet, variantes source: shiny, ancrage d’origine conservé, 3x3x3 studs (de TrainingSimulatorEU/Pets.rbxm) |
| TrainingSim_CandyCreation.rbxm | TrainingSim | 18 | non | Pet, variantes source: shiny, ancrage d’origine conservé, 24x15x11 studs (de TrainingSimulatorEU/Pets.rbxm) |
| TrainingSim_CandyDragon.rbxm | TrainingSim | 16 | non | Pet, variantes source: shiny, ancrage d’origine conservé, 7x4x5 studs (de TrainingSimulatorEU/Pets.rbxm) |
| TrainingSim_CandyHybrid.rbxm | TrainingSim | 10 | non | Pet, variantes source: shiny, ancrage d’origine conservé, 13x7x7 studs (de TrainingSimulatorEU/Pets.rbxm) |
| TrainingSim_CandyPegasus.rbxm | TrainingSim | 8 | non | Pet, variantes source: shiny, ancrage d’origine conservé, 8x6x6 studs (de TrainingSimulatorEU/Pets.rbxm) |
| TrainingSim_Capybara.rbxm | TrainingSim | 8 | non | Pet, variantes source: shiny, ancrage d’origine conservé, 2x3x4 studs (de TrainingSimulatorEU/Pets.rbxm) |
| TrainingSim_Cat.rbxm | TrainingSim | 2 | non | Pet, variantes source: shiny, ancrage d’origine conservé, 2x3x3 studs (de TrainingSimulatorEU/Pets.rbxm) |
| TrainingSim_CyberCat.rbxm | TrainingSim | 6 | non | Pet, variantes source: shiny, ancrage d’origine conservé, 3x4x4 studs (de TrainingSimulatorEU/Pets.rbxm) |
| TrainingSim_CyberHexagon.rbxm | TrainingSim | 2 | non | Pet, variantes source: shiny, ancrage d’origine conservé, 4x4x4 studs (de TrainingSimulatorEU/Pets.rbxm) |
| TrainingSim_CyberSerpent.rbxm | TrainingSim | 9 | non | Pet, variantes source: shiny, ancrage d’origine conservé, 9x5x5 studs (de TrainingSimulatorEU/Pets.rbxm) |
| TrainingSim_CyberSnake.rbxm | TrainingSim | 6 | non | Pet, variantes source: shiny, ancrage d’origine conservé, 4x3x7 studs (de TrainingSimulatorEU/Pets.rbxm) |
| TrainingSim_DarkDragon.rbxm | TrainingSim | 7 | non | Pet, variantes source: shiny, ancrage d’origine conservé, 7x4x3 studs (de TrainingSimulatorEU/Pets.rbxm) |
| TrainingSim_Dog.rbxm | TrainingSim | 5 | non | Pet, variantes source: shiny, ancrage d’origine conservé, 3x4x4 studs (de TrainingSimulatorEU/Pets.rbxm) |
| TrainingSim_Dragon.rbxm | TrainingSim | 8 | non | Pet, variantes source: shiny, ancrage d’origine conservé, 10x5x7 studs (de TrainingSimulatorEU/Pets.rbxm) |
| TrainingSim_Duckling.rbxm | TrainingSim | 2 | non | Pet, variantes source: shiny, ancrage d’origine conservé, 3x3x3 studs (de TrainingSimulatorEU/Pets.rbxm) |
| TrainingSim_Eagle.rbxm | TrainingSim | 2 | non | Pet, variantes source: shiny, ancrage d’origine conservé, 5x3x3 studs (de TrainingSimulatorEU/Pets.rbxm) |
| TrainingSim_EarthDragon.rbxm | TrainingSim | 7 | non | Pet, variantes source: shiny, ancrage d’origine conservé, 7x4x3 studs (de TrainingSimulatorEU/Pets.rbxm) |
| TrainingSim_Emu.rbxm | TrainingSim | 2 | non | Pet, variantes source: shiny, ancrage d’origine conservé, 3x3x2 studs (de TrainingSimulatorEU/Pets.rbxm) |
| TrainingSim_FireDragon.rbxm | TrainingSim | 6 | non | Pet, variantes source: shiny, ancrage d’origine conservé, 7x4x3 studs (de TrainingSimulatorEU/Pets.rbxm) |
| TrainingSim_Flamingo.rbxm | TrainingSim | 2 | non | Pet, variantes source: shiny, ancrage d’origine conservé, 3x3x3 studs (de TrainingSimulatorEU/Pets.rbxm) |
| TrainingSim_Fox.rbxm | TrainingSim | 2 | non | Pet, variantes source: shiny, ancrage d’origine conservé, 3x3x3 studs (de TrainingSimulatorEU/Pets.rbxm) |
| TrainingSim_GalaxyDominus.rbxm | TrainingSim | 2 | non | Pet, variantes source: shiny, ancrage d’origine conservé, 6x3x3 studs (de TrainingSimulatorEU/Pets.rbxm) |
| TrainingSim_Goat.rbxm | TrainingSim | 2 | non | Pet, variantes source: shiny, ancrage d’origine conservé, 4x4x3 studs (de TrainingSimulatorEU/Pets.rbxm) |
| TrainingSim_Goldfish.rbxm | TrainingSim | 2 | non | Pet, variantes source: shiny, ancrage d’origine conservé, 3x3x3 studs (de TrainingSimulatorEU/Pets.rbxm) |
| TrainingSim_Hacker.rbxm | TrainingSim | 10 | non | Pet, variantes source: shiny, ancrage d’origine conservé, 7x4x6 studs (de TrainingSimulatorEU/Pets.rbxm) |
| TrainingSim_Hampster.rbxm | TrainingSim | 2 | non | Pet, variantes source: shiny, ancrage d’origine conservé, 3x3x3 studs (de TrainingSimulatorEU/Pets.rbxm) |
| TrainingSim_HugeCapybara.rbxm | TrainingSim | 10 | non | Pet, variantes source: shiny, ancrage d’origine conservé, 17x11x7 studs (de TrainingSimulatorEU/Pets.rbxm) |
| TrainingSim_HugeRobot.rbxm | TrainingSim | 6 | non | Pet, variantes source: shiny, ancrage d’origine conservé, 5x5x5 studs (de TrainingSimulatorEU/Pets.rbxm) |
| TrainingSim_InfernalDragon.rbxm | TrainingSim | 7 | non | Pet, variantes source: shiny, ancrage d’origine conservé, 13x7x6 studs (de TrainingSimulatorEU/Pets.rbxm) |
| TrainingSim_Jellyfish.rbxm | TrainingSim | 5 | non | Pet, variantes source: shiny, ancrage d’origine conservé, 3x5x4 studs (de TrainingSimulatorEU/Pets.rbxm) |
| TrainingSim_Koala.rbxm | TrainingSim | 2 | non | Pet, variantes source: shiny, ancrage d’origine conservé, 4x3x3 studs (de TrainingSimulatorEU/Pets.rbxm) |
| TrainingSim_Lion.rbxm | TrainingSim | 2 | non | Pet, variantes source: shiny, ancrage d’origine conservé, 4x3x3 studs (de TrainingSimulatorEU/Pets.rbxm) |
| TrainingSim_MagmaBunny.rbxm | TrainingSim | 5 | non | Pet, variantes source: shiny, ancrage d’origine conservé, 3x4x3 studs (de TrainingSimulatorEU/Pets.rbxm) |
| TrainingSim_MagmaCat.rbxm | TrainingSim | 6 | non | Pet, variantes source: shiny, ancrage d’origine conservé, 3x3x4 studs (de TrainingSimulatorEU/Pets.rbxm) |
| TrainingSim_MagmaDragon.rbxm | TrainingSim | 8 | non | Pet, variantes source: shiny, ancrage d’origine conservé, 7x4x5 studs (de TrainingSimulatorEU/Pets.rbxm) |
| TrainingSim_MagmaPhoenix.rbxm | TrainingSim | 16 | non | Pet, variantes source: shiny, ancrage d’origine conservé, 19x15x10 studs (de TrainingSimulatorEU/Pets.rbxm) |
| TrainingSim_MagmaSlime.rbxm | TrainingSim | 5 | non | Pet, variantes source: shiny, ancrage d’origine conservé, 3x3x3 studs (de TrainingSimulatorEU/Pets.rbxm) |
| TrainingSim_Moose.rbxm | TrainingSim | 2 | non | Pet, variantes source: shiny, ancrage d’origine conservé, 4x3x3 studs (de TrainingSimulatorEU/Pets.rbxm) |
| TrainingSim_Mouse.rbxm | TrainingSim | 2 | non | Pet, variantes source: shiny, ancrage d’origine conservé, 3x3x3 studs (de TrainingSimulatorEU/Pets.rbxm) |
| TrainingSim_OceanBlob.rbxm | TrainingSim | 3 | non | Pet, variantes source: shiny, ancrage d’origine conservé, 4x5x4 studs (de TrainingSimulatorEU/Pets.rbxm) |
| TrainingSim_OceanKing.rbxm | TrainingSim | 8 | non | Pet, variantes source: shiny, ancrage d’origine conservé, 15x10x12 studs (de TrainingSimulatorEU/Pets.rbxm) |
| TrainingSim_OceanMonster.rbxm | TrainingSim | 7 | non | Pet, variantes source: shiny, ancrage d’origine conservé, 14x5x6 studs (de TrainingSimulatorEU/Pets.rbxm) |
| TrainingSim_Pigeon.rbxm | TrainingSim | 2 | non | Pet, variantes source: shiny, ancrage d’origine conservé, 3x3x3 studs (de TrainingSimulatorEU/Pets.rbxm) |
| TrainingSim_Pony.rbxm | TrainingSim | 2 | non | Pet, variantes source: shiny, ancrage d’origine conservé, 3x3x3 studs (de TrainingSimulatorEU/Pets.rbxm) |
| TrainingSim_Pug.rbxm | TrainingSim | 2 | non | Pet, variantes source: shiny, ancrage d’origine conservé, 3x3x3 studs (de TrainingSimulatorEU/Pets.rbxm) |
| TrainingSim_Racoon.rbxm | TrainingSim | 2 | non | Pet, variantes source: shiny, ancrage d’origine conservé, 3x3x4 studs (de TrainingSimulatorEU/Pets.rbxm) |
| TrainingSim_Rattlesnake.rbxm | TrainingSim | 2 | non | Pet, variantes source: shiny, ancrage d’origine conservé, 3x3x3 studs (de TrainingSimulatorEU/Pets.rbxm) |
| TrainingSim_Scorpian.rbxm | TrainingSim | 2 | non | Pet, variantes source: shiny, ancrage d’origine conservé, 4x4x4 studs (de TrainingSimulatorEU/Pets.rbxm) |
| TrainingSim_Shark.rbxm | TrainingSim | 5 | non | Pet, variantes source: shiny, ancrage d’origine conservé, 5x4x4 studs (de TrainingSimulatorEU/Pets.rbxm) |
| TrainingSim_SobEgg.rbxm | TrainingSim | 5 | non | Pet, variantes source: shiny, ancrage d’origine conservé, 3x4x3 studs (de TrainingSimulatorEU/Pets.rbxm) |
| TrainingSim_StarterPet.rbxm | TrainingSim | 2 | non | Pet, variantes source: shiny, ancrage d’origine conservé, 7x4x3 studs (de TrainingSimulatorEU/Pets.rbxm) |
| TrainingSim_TheOverlord.rbxm | TrainingSim | 8 | non | Pet, variantes source: shiny, ancrage d’origine conservé, 19x10x10 studs (de TrainingSimulatorEU/Pets.rbxm) |
| TrainingSim_Vulture.rbxm | TrainingSim | 2 | non | Pet, variantes source: shiny, ancrage d’origine conservé, 5x3x3 studs (de TrainingSimulatorEU/Pets.rbxm) |
| TrainingSim_WaterDragon.rbxm | TrainingSim | 7 | non | Pet, variantes source: shiny, ancrage d’origine conservé, 7x4x3 studs (de TrainingSimulatorEU/Pets.rbxm) |
| TweetingSim_Atom.rbxm | TweetingSim | 5 | non | Pet, 2 particules/effets, ancrage d’origine conservé, 3x4x2 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Objects.rbxm) |
| TweetingSim_BabyDoge.rbxm | TweetingSim | 13 | non | Pet, ancrage d’origine conservé, 2x1x1 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Objects.rbxm) |
| TweetingSim_BlueBird.rbxm | TweetingSim | 5 | non | Pet, ancrage d’origine conservé, 2x2x3 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Objects.rbxm) |
| TweetingSim_Cyclone.rbxm | TweetingSim | 6 | non | Pet, ancrage d’origine conservé, 4x4x3 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Objects.rbxm) |
| TweetingSim_GoldenBird.rbxm | TweetingSim | 4 | non | Pet, ancrage d’origine conservé, 3x3x5 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Objects.rbxm) |
| TweetingSim_Illuminati.rbxm | TweetingSim | 5 | non | Pet, ancrage d’origine conservé, 4x3x3 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Objects.rbxm) |
| TweetingSim_Infernus.rbxm | TweetingSim | 15 | non | Pet, 1 particules/effets, ancrage d’origine conservé, 2x3x4 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Objects.rbxm) |
| TweetingSim_Kitten.rbxm | TweetingSim | 13 | non | Pet, ancrage d’origine conservé, 2x2x2 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Objects.rbxm) |
| TweetingSim_Noire.rbxm | TweetingSim | 6 | non | Pet, 1 particules/effets, ancrage d’origine conservé, 2x4x4 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Objects.rbxm) |
| TweetingSim_One.rbxm | TweetingSim | 4 | non | Pet, 1 particules/effets, ancrage d’origine conservé, 4x4x3 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Objects.rbxm) |
| TweetingSim_OrangeBird.rbxm | TweetingSim | 5 | non | Pet, ancrage d’origine conservé, 2x2x4 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Objects.rbxm) |
| TweetingSim_Owl.rbxm | TweetingSim | 7 | non | Pet, ancrage d’origine conservé, 2x3x4 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Objects.rbxm) |
| TweetingSim_Penguin.rbxm | TweetingSim | 8 | non | Pet, ancrage d’origine conservé, 2x3x3 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Objects.rbxm) |
| TweetingSim_Peridot.rbxm | TweetingSim | 5 | non | Pet, 2 particules/effets, ancrage d’origine conservé, 3x4x2 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Objects.rbxm) |
| TweetingSim_PupperBunny.rbxm | TweetingSim | 4 | non | Pet, ancrage d’origine conservé, 3x4x3 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Objects.rbxm) |
| TweetingSim_Saurus.rbxm | TweetingSim | 3 | non | Pet, 1 particules/effets, ancrage d’origine conservé, 4x4x4 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Objects.rbxm) |
| TweetingSim_SausageTwins.rbxm | TweetingSim | 5 | non | Pet, 2 particules/effets, ancrage d’origine conservé, 2x2x4 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Objects.rbxm) |
| TweetingSim_Singularity.rbxm | TweetingSim | 5 | non | Pet, ancrage d’origine conservé, 4x4x3 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Objects.rbxm) |
| TweetingSim_Squiddy.rbxm | TweetingSim | 15 | non | Pet, ancrage d’origine conservé, 3x3x3 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Objects.rbxm) |
| TweetingSim_Tundra.rbxm | TweetingSim | 6 | non | Pet, 1 particules/effets, ancrage d’origine conservé, 3x3x3 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Objects.rbxm) |
| TweetingSim_Tweetula.rbxm | TweetingSim | 6 | non | Pet, ancrage d’origine conservé, 2x2x2 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Objects.rbxm) |
| TweetingSim_Verified.rbxm | TweetingSim | 8 | non | Pet, 1 particules/effets, ancrage d’origine conservé, 3x2x3 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Objects.rbxm) |

## Eggs_Incubators

Dossier `ByType/Eggs_Incubators/` — 172 objets.

| Fichier | Jeu | Pièces | Scripts | Description |
|---|---|---|---|---|
| 1JumpEverySecond_Eggs.rbxm | 1JumpEverySecond | 23 | non | Œuf / incubateur, 4 particules/effets, SurfaceGui/Billboard, 37x21x85 studs (de 1JumpEverySecond/Workspace/__MAP.rbxm) |
| 1JumpEverySecond_Eggs_2.rbxm | 1JumpEverySecond | 9 | non | Œuf / incubateur, SurfaceGui/Billboard, 24x16x10 studs (de 1JumpEverySecond/Workspace/__MAP.rbxm) |
| BakerySim_PetCrateRegular.rbxm | BakerySim | 14 | non | Œuf / incubateur, ancrage d’origine conservé, 3x3x3 studs (de Bakery-Simulator/Assets.rbxm) |
| BakerySim_RegularCrateOpen.rbxm | BakerySim | 28 | non | Œuf / incubateur, 5 particules/effets, 103x34x103 studs (de Bakery-Simulator/Assets.rbxm) |
| HatchingSim_CommonEgg.rbxm | HatchingSim | 3 | non | Œuf / incubateur, 4x4x4 studs (de HatchingSimulator/GameClient.rbxm) |
| HatchingSim_CommonEgg_2.rbxm | HatchingSim | 15 | non | Œuf / incubateur, SurfaceGui/Billboard, 13x18x13 studs (de HatchingSimulator/Workspace/Eggs.rbxm) |
| HatchingSim_ElectricEgg.rbxm | HatchingSim | 4 | non | Œuf / incubateur, 5x5x5 studs (de HatchingSimulator/GameClient.rbxm) |
| HatchingSim_ElectricEgg_2.rbxm | HatchingSim | 16 | non | Œuf / incubateur, SurfaceGui/Billboard, 9x12x9 studs (de HatchingSimulator/Workspace/Eggs.rbxm) |
| HatchingSim_FallenEgg.rbxm | HatchingSim | 6 | non | Œuf / incubateur, 4x6x4 studs (de HatchingSimulator/GameClient.rbxm) |
| HatchingSim_FallenEgg_2.rbxm | HatchingSim | 18 | non | Œuf / incubateur, SurfaceGui/Billboard, 13x16x13 studs (de HatchingSimulator/Workspace/Eggs.rbxm) |
| HatchingSim_FlameEgg.rbxm | HatchingSim | 4 | non | Œuf / incubateur, 4x5x4 studs (de HatchingSimulator/GameClient.rbxm) |
| HatchingSim_FlameEgg_2.rbxm | HatchingSim | 16 | non | Œuf / incubateur, SurfaceGui/Billboard, 10x17x10 studs (de HatchingSimulator/Workspace/Eggs.rbxm) |
| HatchingSim_GalacticEgg.rbxm | HatchingSim | 10 | non | Œuf / incubateur, 7x6x7 studs (de HatchingSimulator/GameClient.rbxm) |
| HatchingSim_GalacticEgg_2.rbxm | HatchingSim | 22 | non | Œuf / incubateur, SurfaceGui/Billboard, 10x17x10 studs (de HatchingSimulator/Workspace/Eggs.rbxm) |
| HatchingSim_IceyEgg.rbxm | HatchingSim | 3 | non | Œuf / incubateur, 3x5x3 studs (de HatchingSimulator/GameClient.rbxm) |
| HatchingSim_IceyEgg_2.rbxm | HatchingSim | 15 | non | Œuf / incubateur, SurfaceGui/Billboard, 12x16x12 studs (de HatchingSimulator/Workspace/Eggs.rbxm) |
| HatchingSim_ReleaseEgg.rbxm | HatchingSim | 12 | non | Œuf / incubateur, 3x5x3 studs (de HatchingSimulator/GameClient.rbxm) |
| HatchingSim_ReleaseEgg_2.rbxm | HatchingSim | 23 | non | Œuf / incubateur, SurfaceGui/Billboard, 13x17x13 studs (de HatchingSimulator/Workspace/Eggs.rbxm) |
| HatchingSim_RockyEgg.rbxm | HatchingSim | 5 | non | Œuf / incubateur, 4x4x4 studs (de HatchingSimulator/GameClient.rbxm) |
| HatchingSim_RockyEgg_2.rbxm | HatchingSim | 17 | non | Œuf / incubateur, SurfaceGui/Billboard, 12x17x12 studs (de HatchingSimulator/Workspace/Eggs.rbxm) |
| HatchingSim_VoidEgg.rbxm | HatchingSim | 11 | non | Œuf / incubateur, 5x5x5 studs (de HatchingSimulator/GameClient.rbxm) |
| HatchingSim_VoidEgg_2.rbxm | HatchingSim | 23 | non | Œuf / incubateur, SurfaceGui/Billboard, 7x12x7 studs (de HatchingSimulator/Workspace/Eggs.rbxm) |
| MagnetSim2_Tier1.rbxm | MagnetSim2 | 7 | non | Œuf / incubateur, SurfaceGui/Billboard, 10x11x11 studs (de UNCOPYLOCKED-Magnet-Simulator-2/Workspace/Eggs.rbxm) |
| MagnetSim2_Tier2.rbxm | MagnetSim2 | 10 | non | Œuf / incubateur, SurfaceGui/Billboard, 11x11x12 studs (de UNCOPYLOCKED-Magnet-Simulator-2/Workspace/Eggs.rbxm) |
| MagnetSim2_Tier3.rbxm | MagnetSim2 | 10 | non | Œuf / incubateur, SurfaceGui/Billboard, 12x11x11 studs (de UNCOPYLOCKED-Magnet-Simulator-2/Workspace/Eggs.rbxm) |
| MagnetSim2_Tier4.rbxm | MagnetSim2 | 22 | non | Œuf / incubateur, SurfaceGui/Billboard, 11x11x8 studs (de UNCOPYLOCKED-Magnet-Simulator-2/Workspace/Eggs.rbxm) |
| MiningMasters_BasicEgg.rbxm | MiningMasters | 8 | non | Œuf / incubateur, SurfaceGui/Billboard, 10x11x10 studs (de Mining-Masters/Workspace/Eggs.rbxm) |
| MiningMasters_BeachEgg.rbxm | MiningMasters | 9 | non | Œuf / incubateur, SurfaceGui/Billboard, 7x6x8 studs (de Mining-Masters/Workspace/Eggs.rbxm) |
| MiningMasters_CandyEgg.rbxm | MiningMasters | 8 | non | Œuf / incubateur, SurfaceGui/Billboard, 7x10x8 studs (de Mining-Masters/Workspace/Eggs.rbxm) |
| MiningMasters_CaveEgg.rbxm | MiningMasters | 8 | non | Œuf / incubateur, SurfaceGui/Billboard, 7x10x8 studs (de Mining-Masters/Workspace/Eggs.rbxm) |
| MiningMasters_GoldenBasicEgg.rbxm | MiningMasters | 8 | non | Œuf / incubateur, SurfaceGui/Billboard, 10x11x11 studs (de Mining-Masters/Workspace/Eggs.rbxm) |
| MiningMasters_GoldenBeachEgg.rbxm | MiningMasters | 9 | non | Œuf / incubateur, SurfaceGui/Billboard, 7x6x8 studs (de Mining-Masters/Workspace/Eggs.rbxm) |
| MiningMasters_GoldenCandyEgg.rbxm | MiningMasters | 8 | non | Œuf / incubateur, SurfaceGui/Billboard, 7x10x8 studs (de Mining-Masters/Workspace/Eggs.rbxm) |
| MiningMasters_GoldenCaveEgg.rbxm | MiningMasters | 8 | non | Œuf / incubateur, SurfaceGui/Billboard, 7x10x8 studs (de Mining-Masters/Workspace/Eggs.rbxm) |
| MiningMasters_GoldenDesertEgg.rbxm | MiningMasters | 8 | non | Œuf / incubateur, SurfaceGui/Billboard, 10x9x11 studs (de Mining-Masters/Workspace/Eggs.rbxm) |
| MiningMasters_GoldenJungleEgg.rbxm | MiningMasters | 8 | non | Œuf / incubateur, SurfaceGui/Billboard, 7x10x8 studs (de Mining-Masters/Workspace/Eggs.rbxm) |
| MiningMasters_GoldenScienceEgg.rbxm | MiningMasters | 8 | non | Œuf / incubateur, SurfaceGui/Billboard, 7x11x8 studs (de Mining-Masters/Workspace/Eggs.rbxm) |
| MiningMasters_GoldenSnowEgg.rbxm | MiningMasters | 8 | non | Œuf / incubateur, SurfaceGui/Billboard, 7x8x8 studs (de Mining-Masters/Workspace/Eggs.rbxm) |
| MiningMasters_GoldenUnderwaterEgg.rbxm | MiningMasters | 8 | non | Œuf / incubateur, SurfaceGui/Billboard, 7x10x8 studs (de Mining-Masters/Workspace/Eggs.rbxm) |
| MiningMasters_GoldenVolcanoEgg.rbxm | MiningMasters | 8 | non | Œuf / incubateur, SurfaceGui/Billboard, 7x10x8 studs (de Mining-Masters/Workspace/Eggs.rbxm) |
| MiningMasters_JungleEgg.rbxm | MiningMasters | 8 | non | Œuf / incubateur, SurfaceGui/Billboard, 7x10x8 studs (de Mining-Masters/Workspace/Eggs.rbxm) |
| MiningMasters_ScienceEgg.rbxm | MiningMasters | 8 | non | Œuf / incubateur, SurfaceGui/Billboard, 7x11x8 studs (de Mining-Masters/Workspace/Eggs.rbxm) |
| MiningMasters_SnowEgg.rbxm | MiningMasters | 8 | non | Œuf / incubateur, SurfaceGui/Billboard, 7x8x8 studs (de Mining-Masters/Workspace/Eggs.rbxm) |
| MiningMasters_UnderwaterEgg.rbxm | MiningMasters | 8 | non | Œuf / incubateur, SurfaceGui/Billboard, 7x11x8 studs (de Mining-Masters/Workspace/Eggs.rbxm) |
| MiningMasters_VolcanoEgg.rbxm | MiningMasters | 8 | non | Œuf / incubateur, SurfaceGui/Billboard, 7x10x8 studs (de Mining-Masters/Workspace/Eggs.rbxm) |
| PetPharmica_Atlantis.rbxm | PetPharmica | 10 | non | Œuf / incubateur, SurfaceGui/Billboard, 9x12x14 studs (de Pet_Pharmica_1_1/Workspace/Eggs.rbxm) |
| PetPharmica_BasicGold.rbxm | PetPharmica | 10 | non | Œuf / incubateur, SurfaceGui/Billboard, 14x13x9 studs (de Pet_Pharmica_1_1/Workspace/Eggs.rbxm) |
| PetPharmica_Cave.rbxm | PetPharmica | 10 | non | Œuf / incubateur, SurfaceGui/Billboard, 7x11x12 studs (de Pet_Pharmica_1_1/Workspace/Eggs.rbxm) |
| PetPharmica_Coconut.rbxm | PetPharmica | 10 | non | Œuf / incubateur, SurfaceGui/Billboard, 7x12x12 studs (de Pet_Pharmica_1_1/Workspace/Eggs.rbxm) |
| PetPharmica_Desert.rbxm | PetPharmica | 10 | non | Œuf / incubateur, SurfaceGui/Billboard, 7x12x12 studs (de Pet_Pharmica_1_1/Workspace/Eggs.rbxm) |
| PetPharmica_Dominus.rbxm | PetPharmica | 10 | non | Œuf / incubateur, 1 particules/effets, SurfaceGui/Billboard, 9x12x14 studs (de Pet_Pharmica_1_1/Workspace/Eggs.rbxm) |
| PetPharmica_Forest.rbxm | PetPharmica | 10 | non | Œuf / incubateur, SurfaceGui/Billboard, 9x12x13 studs (de Pet_Pharmica_1_1/Workspace/Eggs.rbxm) |
| PetPharmica_Ice.rbxm | PetPharmica | 10 | non | Œuf / incubateur, SurfaceGui/Billboard, 7x13x12 studs (de Pet_Pharmica_1_1/Workspace/Eggs.rbxm) |
| PetPharmica_Limited.rbxm | PetPharmica | 10 | non | Œuf / incubateur, SurfaceGui/Billboard, 8x14x13 studs (de Pet_Pharmica_1_1/Workspace/Eggs.rbxm) |
| PetPharmica_Limited2.rbxm | PetPharmica | 10 | non | Œuf / incubateur, SurfaceGui/Billboard, 9x14x14 studs (de Pet_Pharmica_1_1/Workspace/Eggs.rbxm) |
| PetPharmica_Magma.rbxm | PetPharmica | 10 | non | Œuf / incubateur, SurfaceGui/Billboard, 13x11x13 studs (de Pet_Pharmica_1_1/Workspace/Eggs.rbxm) |
| PetPharmica_Pirate.rbxm | PetPharmica | 10 | non | Œuf / incubateur, SurfaceGui/Billboard, 13x11x8 studs (de Pet_Pharmica_1_1/Workspace/Eggs.rbxm) |
| PetPharmica_SurfBoard.rbxm | PetPharmica | 10 | non | Œuf / incubateur, SurfaceGui/Billboard, 13x11x8 studs (de Pet_Pharmica_1_1/Workspace/Eggs.rbxm) |
| PunchSim_Egg.rbxm | PunchSim | 2 | non | Œuf / incubateur, 10x8x10 studs (de Punch Simulator/Workspace/__MAP.rbxm) |
| PunchSim_Egg_2.rbxm | PunchSim | 4 | non | Œuf / incubateur, 9x7x9 studs (de Punch Simulator/Workspace/__MAP.rbxm) |
| RebirthChampionsX_10M.rbxm | RebirthChampionsX | 8 | non | Œuf / incubateur, 1x1x1 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_5M.rbxm | RebirthChampionsX | 6 | non | Œuf / incubateur, 2 particules/effets, 1x1x1 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_Alien.rbxm | RebirthChampionsX | 4 | non | Œuf / incubateur, 5x8x5 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_Atlantis.rbxm | RebirthChampionsX | 4 | non | Œuf / incubateur, 4x6x4 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_Atlantis_2.rbxm | RebirthChampionsX | 8 | non | Œuf / incubateur, SurfaceGui/Billboard, 1x2x2 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_Atlantis_3.rbxm | RebirthChampionsX | 13 | non | Œuf / incubateur, SurfaceGui/Billboard, 10x12x9 studs (de Rebirth Champions X/Workspace/Scripts.rbxm) |
| RebirthChampionsX_Basic.rbxm | RebirthChampionsX | 1 | non | Œuf / incubateur, SurfaceGui/Billboard, 1x1x1 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_Basic_2.rbxm | RebirthChampionsX | 6 | non | Œuf / incubateur, SurfaceGui/Billboard, 12x12x12 studs (de Rebirth Champions X/Workspace/Scripts.rbxm) |
| RebirthChampionsX_Basket.rbxm | RebirthChampionsX | 6 | non | Œuf / incubateur, 5x3x5 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_Beach.rbxm | RebirthChampionsX | 6 | non | Œuf / incubateur, SurfaceGui/Billboard, 2x2x2 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_Beach_2.rbxm | RebirthChampionsX | 11 | non | Œuf / incubateur, SurfaceGui/Billboard, 11x12x11 studs (de Rebirth Champions X/Workspace/Scripts.rbxm) |
| RebirthChampionsX_Cave.rbxm | RebirthChampionsX | 22 | non | Œuf / incubateur, 7x6x6 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_Cave_2.rbxm | RebirthChampionsX | 20 | non | Œuf / incubateur, 1x1x1 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_Cave_3.rbxm | RebirthChampionsX | 25 | non | Œuf / incubateur, 9x12x9 studs (de Rebirth Champions X/Workspace/Scripts.rbxm) |
| RebirthChampionsX_Chocolate.rbxm | RebirthChampionsX | 7 | non | Œuf / incubateur, 1x2x1 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_Chocolate_2.rbxm | RebirthChampionsX | 12 | non | Œuf / incubateur, 13x12x13 studs (de Rebirth Champions X/Workspace/Scripts.rbxm) |
| RebirthChampionsX_Crazy.rbxm | RebirthChampionsX | 2 | non | Œuf / incubateur, SurfaceGui/Billboard, 1x1x1 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_Crazy_2.rbxm | RebirthChampionsX | 7 | non | Œuf / incubateur, SurfaceGui/Billboard, 10x12x10 studs (de Rebirth Champions X/Workspace/Scripts.rbxm) |
| RebirthChampionsX_Cyber.rbxm | RebirthChampionsX | 8 | non | Œuf / incubateur, 1x1x1 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_Cyber_2.rbxm | RebirthChampionsX | 13 | non | Œuf / incubateur, 9x12x9 studs (de Rebirth Champions X/Workspace/Scripts.rbxm) |
| RebirthChampionsX_Desert.rbxm | RebirthChampionsX | 13 | non | Œuf / incubateur, SurfaceGui/Billboard, 2x1x1 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_Desert_2.rbxm | RebirthChampionsX | 10 | non | Œuf / incubateur, SurfaceGui/Billboard, 12x15x12 studs (de Rebirth Champions X/Workspace/Scripts.rbxm) |
| RebirthChampionsX_Easter.rbxm | RebirthChampionsX | 5 | non | Œuf / incubateur, 1x2x1 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_Easter_2.rbxm | RebirthChampionsX | 10 | non | Œuf / incubateur, 18x16x18 studs (de Rebirth Champions X/Workspace/Scripts.rbxm) |
| RebirthChampionsX_EasterPart2.rbxm | RebirthChampionsX | 8 | non | Œuf / incubateur, 2x2x1 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_EasterPart2_2.rbxm | RebirthChampionsX | 13 | non | Œuf / incubateur, 16x16x16 studs (de Rebirth Champions X/Workspace/Scripts.rbxm) |
| RebirthChampionsX_EasterRobux.rbxm | RebirthChampionsX | 1 | non | Œuf / incubateur, 1x2x1 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_EasterRobux_2.rbxm | RebirthChampionsX | 6 | non | Œuf / incubateur, 13x12x13 studs (de Rebirth Champions X/Workspace/Scripts.rbxm) |
| RebirthChampionsX_EggHunt.rbxm | RebirthChampionsX | 420 | non | Œuf / incubateur, 86 particules/effets, 881x112x947 studs (de Rebirth Champions X/Workspace/Maps.rbxm) |
| RebirthChampionsX_EggHuntDiamond.rbxm | RebirthChampionsX | 4 | non | Œuf / incubateur, variantes source: diamond/toxic, 4x6x4 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_Eggs.rbxm | RebirthChampionsX | 2 | non | Œuf / incubateur, variantes source: mythic/void, 3x3x3 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_Fire.rbxm | RebirthChampionsX | 2 | non | Œuf / incubateur, 4x5x4 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_Forest.rbxm | RebirthChampionsX | 4 | non | Œuf / incubateur, 4x6x4 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_Forest_2.rbxm | RebirthChampionsX | 12 | non | Œuf / incubateur, SurfaceGui/Billboard, 1x1x1 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_Forest_3.rbxm | RebirthChampionsX | 17 | non | Œuf / incubateur, SurfaceGui/Billboard, 9x12x9 studs (de Rebirth Champions X/Workspace/Scripts.rbxm) |
| RebirthChampionsX_Hacker.rbxm | RebirthChampionsX | 6 | non | Œuf / incubateur, 4x6x4 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_Heaven.rbxm | RebirthChampionsX | 4 | non | Œuf / incubateur, 1x2x1 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_Heaven_2.rbxm | RebirthChampionsX | 9 | non | Œuf / incubateur, 9x12x9 studs (de Rebirth Champions X/Workspace/Scripts.rbxm) |
| RebirthChampionsX_King.rbxm | RebirthChampionsX | 3 | non | Œuf / incubateur, SurfaceGui/Billboard, 1x1x2 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_King_2.rbxm | RebirthChampionsX | 8 | non | Œuf / incubateur, SurfaceGui/Billboard, 15x15x15 studs (de Rebirth Champions X/Workspace/Scripts.rbxm) |
| RebirthChampionsX_Lava.rbxm | RebirthChampionsX | 3 | non | Œuf / incubateur, SurfaceGui/Billboard, 1x1x1 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_Lava_2.rbxm | RebirthChampionsX | 8 | non | Œuf / incubateur, SurfaceGui/Billboard, 11x14x11 studs (de Rebirth Champions X/Workspace/Scripts.rbxm) |
| RebirthChampionsX_Magic.rbxm | RebirthChampionsX | 3 | non | Œuf / incubateur, 1x1x1 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_Magic_2.rbxm | RebirthChampionsX | 8 | non | Œuf / incubateur, 9x12x9 studs (de Rebirth Champions X/Workspace/Scripts.rbxm) |
| RebirthChampionsX_Magma.rbxm | RebirthChampionsX | 2 | non | Œuf / incubateur, SurfaceGui/Billboard, 1x1x1 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_Magma_2.rbxm | RebirthChampionsX | 8 | non | Œuf / incubateur, SurfaceGui/Billboard, 16x20x19 studs (de Rebirth Champions X/Workspace/Scripts.rbxm) |
| RebirthChampionsX_Money.rbxm | RebirthChampionsX | 5 | non | Œuf / incubateur, 4x6x4 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_Moon.rbxm | RebirthChampionsX | 9 | non | Œuf / incubateur, 1x2x1 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_Moon_2.rbxm | RebirthChampionsX | 13 | non | Œuf / incubateur, SurfaceGui/Billboard, 9x12x9 studs (de Rebirth Champions X/Workspace/Scripts.rbxm) |
| RebirthChampionsX_Nuclear.rbxm | RebirthChampionsX | 4 | non | Œuf / incubateur, 2 particules/effets, 1x1x1 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_Nuclear_2.rbxm | RebirthChampionsX | 9 | non | Œuf / incubateur, 2 particules/effets, 9x12x9 studs (de Rebirth Champions X/Workspace/Scripts.rbxm) |
| RebirthChampionsX_Snowman.rbxm | RebirthChampionsX | 7 | non | Œuf / incubateur, SurfaceGui/Billboard, 4x7x5 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_Spooky.rbxm | RebirthChampionsX | 5 | non | Œuf / incubateur, 1x2x1 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_Spooky_2.rbxm | RebirthChampionsX | 9 | non | Œuf / incubateur, 9x12x9 studs (de Rebirth Champions X/Workspace/Scripts.rbxm) |
| RebirthChampionsX_ToxicToxic.rbxm | RebirthChampionsX | 4 | non | Œuf / incubateur, prompt/clic, 5x6x5 studs (de Rebirth Champions X/Workspace/Scripts.rbxm) |
| RebirthChampionsX_Volcano.rbxm | RebirthChampionsX | 4 | non | Œuf / incubateur, 1 particules/effets, SurfaceGui/Billboard, 1x1x2 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_Volcano_2.rbxm | RebirthChampionsX | 9 | non | Œuf / incubateur, 1 particules/effets, SurfaceGui/Billboard, 13x14x11 studs (de Rebirth Champions X/Workspace/Scripts.rbxm) |
| RebirthChampionsX_Water.rbxm | RebirthChampionsX | 8 | non | Œuf / incubateur, SurfaceGui/Billboard, 1x2x1 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_Water_2.rbxm | RebirthChampionsX | 13 | non | Œuf / incubateur, SurfaceGui/Billboard, 13x12x13 studs (de Rebirth Champions X/Workspace/Scripts.rbxm) |
| RebirthChampionsX_Winter.rbxm | RebirthChampionsX | 7 | non | Œuf / incubateur, SurfaceGui/Billboard, 1x2x1 studs (de Rebirth Champions X/Assets.rbxm) |
| RebirthChampionsX_Winter_2.rbxm | RebirthChampionsX | 12 | non | Œuf / incubateur, SurfaceGui/Billboard, 11x13x11 studs (de Rebirth Champions X/Workspace/Scripts.rbxm) |
| RobotSim_BasicEgg.rbxm | RobotSim | 1 | non | Œuf / incubateur, 2x2x2 studs (de Robot Simulator/Extra.rbxm) |
| RobotSim_BasicEgg_2.rbxm | RobotSim | 21 | non | Œuf / incubateur, SurfaceGui/Billboard, 15x11x9 studs (de Robot Simulator/Workspace/Eggs.rbxm) |
| RobotSim_BrickEgg.rbxm | RobotSim | 5 | non | Œuf / incubateur, 4x3x4 studs (de Robot Simulator/Extra.rbxm) |
| RobotSim_BrickEgg_2.rbxm | RobotSim | 27 | non | Œuf / incubateur, SurfaceGui/Billboard, 22x11x20 studs (de Robot Simulator/Workspace/Eggs.rbxm) |
| RobotSim_CrystalEgg.rbxm | RobotSim | 2 | non | Œuf / incubateur, 4x4x4 studs (de Robot Simulator/Extra.rbxm) |
| RobotSim_CrystalEgg_2.rbxm | RobotSim | 24 | non | Œuf / incubateur, SurfaceGui/Billboard, 15x11x19 studs (de Robot Simulator/Workspace/Eggs.rbxm) |
| RobotSim_DefaultEgg.rbxm | RobotSim | 1 | non | Œuf / incubateur, 2x2x2 studs (de Robot Simulator/Extra.rbxm) |
| RobotSim_DevEgg.rbxm | RobotSim | 1 | non | Œuf / incubateur, 1 particules/effets, 4x3x4 studs (de Robot Simulator/Extra.rbxm) |
| RobotSim_DevEgg_2.rbxm | RobotSim | 21 | non | Œuf / incubateur, 1 particules/effets, SurfaceGui/Billboard, 15x11x9 studs (de Robot Simulator/Workspace/Eggs.rbxm) |
| RobotSim_EggPlatform.rbxm | RobotSim | 10 | non | Œuf / incubateur, 47x3x51 studs (de Robot Simulator/Workspace/Map.rbxm) |
| RobotSim_FrostEgg.rbxm | RobotSim | 1 | non | Œuf / incubateur, 1 particules/effets, 4x3x4 studs (de Robot Simulator/Extra.rbxm) |
| RobotSim_FrostEgg_2.rbxm | RobotSim | 27 | non | Œuf / incubateur, 1 particules/effets, SurfaceGui/Billboard, 25x11x26 studs (de Robot Simulator/Workspace/Eggs.rbxm) |
| RobotSim_GalaxyEgg.rbxm | RobotSim | 1 | non | Œuf / incubateur, 1 particules/effets, 3x3x3 studs (de Robot Simulator/Extra.rbxm) |
| RobotSim_GalaxyEgg_2.rbxm | RobotSim | 21 | non | Œuf / incubateur, 1 particules/effets, SurfaceGui/Billboard, 15x11x18 studs (de Robot Simulator/Workspace/Eggs.rbxm) |
| RobotSim_GoldenEgg.rbxm | RobotSim | 2 | non | Œuf / incubateur, 6x4x6 studs (de Robot Simulator/Extra.rbxm) |
| RobotSim_GoldenEgg_2.rbxm | RobotSim | 23 | non | Œuf / incubateur, SurfaceGui/Billboard, 20x11x10 studs (de Robot Simulator/Workspace/Eggs.rbxm) |
| RobotSim_GrassEgg.rbxm | RobotSim | 5 | non | Œuf / incubateur, 4x3x4 studs (de Robot Simulator/Extra.rbxm) |
| RobotSim_GrassEgg_2.rbxm | RobotSim | 31 | non | Œuf / incubateur, SurfaceGui/Billboard, 25x10x26 studs (de Robot Simulator/Workspace/Eggs.rbxm) |
| RobotSim_MagmaEgg.rbxm | RobotSim | 2 | non | Œuf / incubateur, 3x3x3 studs (de Robot Simulator/Extra.rbxm) |
| RobotSim_MagmaEgg_2.rbxm | RobotSim | 23 | non | Œuf / incubateur, SurfaceGui/Billboard, 13x11x17 studs (de Robot Simulator/Workspace/Eggs.rbxm) |
| RobotSim_PremiumEgg.rbxm | RobotSim | 1 | non | Œuf / incubateur, 1 particules/effets, 4x3x4 studs (de Robot Simulator/Extra.rbxm) |
| RobotSim_PremiumEgg_2.rbxm | RobotSim | 22 | non | Œuf / incubateur, 1 particules/effets, SurfaceGui/Billboard, 25x10x21 studs (de Robot Simulator/Workspace/Eggs.rbxm) |
| RobotSim_RoboticEgg.rbxm | RobotSim | 21 | non | Œuf / incubateur, SurfaceGui/Billboard, 15x11x10 studs (de Robot Simulator/Workspace/Eggs.rbxm) |
| RobotSim_SparkleEgg.rbxm | RobotSim | 1 | non | Œuf / incubateur, 1 particules/effets, 3x3x3 studs (de Robot Simulator/Extra.rbxm) |
| RobotSim_SparkleEgg_2.rbxm | RobotSim | 21 | non | Œuf / incubateur, 1 particules/effets, SurfaceGui/Billboard, 15x11x9 studs (de Robot Simulator/Workspace/Eggs.rbxm) |
| RobotSim_SpikeEgg.rbxm | RobotSim | 1 | non | Œuf / incubateur, 3x3x3 studs (de Robot Simulator/Extra.rbxm) |
| RobotSim_SpikeEgg_2.rbxm | RobotSim | 21 | non | Œuf / incubateur, SurfaceGui/Billboard, 15x11x9 studs (de Robot Simulator/Workspace/Eggs.rbxm) |
| RobotSim_TesterEgg.rbxm | RobotSim | 19 | oui (1) | Œuf / incubateur, SurfaceGui/Billboard, 18x14x66 studs (de Robot Simulator/Tester Egg.rbxm) |
| RobotSim_VipEgg.rbxm | RobotSim | 1 | non | Œuf / incubateur, 1 particules/effets, 3x3x3 studs (de Robot Simulator/Extra.rbxm) |
| RobotSim_VipEgg_2.rbxm | RobotSim | 23 | non | Œuf / incubateur, 1 particules/effets, SurfaceGui/Billboard, 27x10x24 studs (de Robot Simulator/Workspace/Eggs.rbxm) |
| TappingLords_Basic.rbxm | TappingLords | 11 | oui (1) | Œuf / incubateur, SurfaceGui/Billboard, 14x8x9 studs (de Tapping-Lords-Simulator/Workspace/Eggs.rbxm) |
| TappingLords_Candy.rbxm | TappingLords | 11 | oui (1) | Œuf / incubateur, SurfaceGui/Billboard, 14x8x10 studs (de Tapping-Lords-Simulator/Workspace/Eggs.rbxm) |
| TappingLords_Forest.rbxm | TappingLords | 9 | oui (1) | Œuf / incubateur, SurfaceGui/Billboard, 15x7x12 studs (de Tapping-Lords-Simulator/Workspace/Eggs.rbxm) |
| TappingLords_Lava.rbxm | TappingLords | 9 | oui (1) | Œuf / incubateur, 1 particules/effets, SurfaceGui/Billboard, 15x7x15 studs (de Tapping-Lords-Simulator/Workspace/Eggs.rbxm) |
| TappingLords_Rare.rbxm | TappingLords | 11 | oui (1) | Œuf / incubateur, SurfaceGui/Billboard, 14x8x10 studs (de Tapping-Lords-Simulator/Workspace/Eggs.rbxm) |
| TappingLords_Space.rbxm | TappingLords | 9 | oui (1) | Œuf / incubateur, SurfaceGui/Billboard, 14x7x9 studs (de Tapping-Lords-Simulator/Workspace/Eggs.rbxm) |
| TappingLords_Water.rbxm | TappingLords | 9 | oui (1) | Œuf / incubateur, SurfaceGui/Billboard, 13x7x8 studs (de Tapping-Lords-Simulator/Workspace/Eggs.rbxm) |
| TrainingSim_Dominus.rbxm | TrainingSim | 6 | oui (1) | Œuf / incubateur, 4 particules/effets, SurfaceGui/Billboard, 8x7x8 studs (de TrainingSimulatorEU/Workspace/Eggs.rbxm) |
| TrainingSim_Spawn1.rbxm | TrainingSim | 4 | non | Œuf / incubateur, SurfaceGui/Billboard, 8x7x7 studs (de TrainingSimulatorEU/Workspace/Eggs.rbxm) |
| TrainingSim_Spawn2.rbxm | TrainingSim | 3 | non | Œuf / incubateur, SurfaceGui/Billboard, 6x7x6 studs (de TrainingSimulatorEU/Workspace/Eggs.rbxm) |
| TrainingSim_Spawn3.rbxm | TrainingSim | 5 | non | Œuf / incubateur, SurfaceGui/Billboard, 8x7x8 studs (de TrainingSimulatorEU/Workspace/Eggs.rbxm) |
| TrainingSim_Spawn4.rbxm | TrainingSim | 4 | non | Œuf / incubateur, SurfaceGui/Billboard, 6x5x6 studs (de TrainingSimulatorEU/Workspace/Eggs.rbxm) |
| TweetingSim_Ancient.rbxm | TweetingSim | 6 | non | Œuf / incubateur, 5x4x5 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Objects.rbxm) |
| TweetingSim_Common.rbxm | TweetingSim | 1 | non | Œuf / incubateur, 2x3x2 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Objects.rbxm) |
| TweetingSim_EggIncubators_200.rbxm | TweetingSim | 9 | non | Œuf / incubateur, 12x11x15 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Core.rbxm) |
| TweetingSim_EggIncubators_202.rbxm | TweetingSim | 62 | non | Œuf / incubateur, SurfaceGui/Billboard, 18x14x12 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Core.rbxm) |
| TweetingSim_EggIncubators_203.rbxm | TweetingSim | 14 | non | Œuf / incubateur, SurfaceGui/Billboard, 21x12x19 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Core.rbxm) |
| TweetingSim_EggIncubators_204.rbxm | TweetingSim | 20 | non | Œuf / incubateur, SurfaceGui/Billboard, 22x15x24 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Core.rbxm) |
| TweetingSim_Mystical.rbxm | TweetingSim | 10 | non | Œuf / incubateur, 2x2x2 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Objects.rbxm) |
| TweetingSim_Rare.rbxm | TweetingSim | 26 | non | Œuf / incubateur, 4x4x4 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Objects.rbxm) |
| TweetingSim_Uncommon.rbxm | TweetingSim | 12 | non | Œuf / incubateur, 3x3x3 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Objects.rbxm) |

## Tools_Weapons

Dossier `ByType/Tools_Weapons/` — 180 objets.

| Fichier | Jeu | Pièces | Scripts | Description |
|---|---|---|---|---|
| 1JumpEverySecond_Sword.rbxm | 1JumpEverySecond | 1 | oui (2) | Arme / outil, Tool prêt à donner, 3x4x3 studs (de 1JumpEverySecond/ItemsGiver.rbxm) |
| BillionaireTycoon_AK-47.rbxm | BillionaireTycoon | 19 | oui (3) | Arme / outil, SurfaceGui/Billboard, Tool prêt à donner, 0x2x5 studs (de Billionaire_Tycoon/AK-47.rbxm) |
| BillionaireTycoon_Bullpup.rbxm | BillionaireTycoon | 22 | oui (3) | Arme / outil, 2 particules/effets, Tool prêt à donner, 3x1x0 studs (de Billionaire_Tycoon/Bullpup.rbxm) |
| BillionaireTycoon_HyperlaserGun.rbxm | BillionaireTycoon | 8 | oui (10) | Arme / outil, 2 particules/effets, Tool prêt à donner, 1x2x3 studs (de Billionaire_Tycoon/Hyperlaser Gun.rbxm) |
| BillionaireTycoon_M4A1.rbxm | BillionaireTycoon | 52 | oui (4) | Arme / outil, SurfaceGui/Billboard, Tool prêt à donner, 2x3x5 studs (de Billionaire_Tycoon/M4A1.rbxm) |
| BillionaireTycoon_MP5.rbxm | BillionaireTycoon | 18 | oui (3) | Arme / outil, SurfaceGui/Billboard, Tool prêt à donner, 0x2x3 studs (de Billionaire_Tycoon/MP5.rbxm) |
| BillionaireTycoon_N7Hurricane.rbxm | BillionaireTycoon | 19 | oui (3) | Arme / outil, 2 particules/effets, Tool prêt à donner, 3x1x1 studs (de Billionaire_Tycoon/N7 Hurricane.rbxm) |
| BillionaireTycoon_R870.rbxm | BillionaireTycoon | 8 | oui (3) | Arme / outil, SurfaceGui/Billboard, Tool prêt à donner, 1x1x6 studs (de Billionaire_Tycoon/R870.rbxm) |
| BillionaireTycoon_USPMatch.rbxm | BillionaireTycoon | 22 | oui (3) | Arme / outil, SurfaceGui/Billboard, Tool prêt à donner, 0x1x3 studs (de Billionaire_Tycoon/USP Match.rbxm) |
| FirstDonations_GUNSSMG.rbxm | FirstDonations | 17 | oui (16) | Arme / outil, 25 particules/effets, SurfaceGui/Billboard, Tool prêt à donner, 4x2x2 studs (de First_Donations/GUNS SMG.rbxm) |
| FirstDonations_HitMarks.rbxm | FirstDonations | 5 | non | Arme / outil, SurfaceGui/Billboard, 3x2x0 studs (de First_Donations/WeaponsSystem.rbxm) |
| FirstDonations_melody.rbxm | FirstDonations | 18 | oui (2) | Arme / outil, Tool prêt à donner, 2x2x2 studs (de First_Donations/melody.rbxm) |
| FirstDonations_PistolCasing.rbxm | FirstDonations | 1 | non | Arme / outil, 0x0x0 studs (de First_Donations/WeaponsSystem.rbxm) |
| FirstDonations_RifleCasing.rbxm | FirstDonations | 1 | non | Arme / outil, 0x0x0 studs (de First_Donations/WeaponsSystem.rbxm) |
| FirstDonations_RobuxHammerGiant.rbxm | FirstDonations | 26 | oui (15) | Arme / outil, Humanoid, 63 particules/effets, SurfaceGui/Billboard, ancrage d’origine conservé, 695x492x938 studs (de First_Donations/RobuxHammerGiant.rbxm) |
| FirstDonations_Shots.rbxm | FirstDonations | 7 | non | Arme / outil, 24 particules/effets, 2x2x2 studs (de First_Donations/WeaponsSystem.rbxm) |
| FirstDonations_Sign.rbxm | FirstDonations | 6 | oui (1) | Arme / outil, SurfaceGui/Billboard, Tool prêt à donner, 5x8x1 studs (de First_Donations/Sign.rbxm) |
| FirstDonations_SmiteHammer.rbxm | FirstDonations | 2 | oui (1) | Arme / outil, 20 particules/effets, Tool prêt à donner, 3x11x6 studs (de First_Donations/Tools.rbxm) |
| FirstDonations_SuperSing.rbxm | FirstDonations | 7 | oui (1) | Arme / outil, SurfaceGui/Billboard, Tool prêt à donner, 9x130x82 studs (de First_Donations/Tools.rbxm) |
| GlassBridge_MachineGun.rbxm | GlassBridge | 5 | oui (6) | Arme / outil, 2 particules/effets, SurfaceGui/Billboard, Tool prêt à donner, 1x1x4 studs (de GlassBridge/GamepassComponents.rbxm) |
| GlassBridge_Radio.rbxm | GlassBridge | 1 | oui (3) | Arme / outil, Tool prêt à donner, 3x2x1 studs (de GlassBridge/GamepassComponents.rbxm) |
| GlassBridge_Sword.rbxm | GlassBridge | 1 | oui (2) | Arme / outil, Tool prêt à donner, 3x4x3 studs (de GlassBridge/GamepassComponents.rbxm) |
| GlassBridge_WaterSword.rbxm | GlassBridge | 1 | oui (5) | Arme / outil, 4 particules/effets, Tool prêt à donner, 1x1x1 studs (de GlassBridge/GamepassComponents.rbxm) |
| MiningMasters_IronPickaxe.rbxm | MiningMasters | 3 | oui (3) | Arme / outil, 1 particules/effets, Tool prêt à donner, 2x3x0 studs (de Mining-Masters/PickaxeStorage.rbxm) |
| MiningMasters_Pickaxe.rbxm | MiningMasters | 3 | non | Arme / outil, Tool prêt à donner, 0x2x3 studs (de Mining-Masters/Pickaxe.rbxm) |
| RobotSim_Axe.rbxm | RobotSim | 4 | non | Arme / outil, 1 particules/effets, Tool prêt à donner, 0x5x3 studs (de Robot Simulator/Assets.rbxm) |
| RobotSim_BlackAxe.rbxm | RobotSim | 4 | non | Arme / outil, 1 particules/effets, Tool prêt à donner, 0x5x3 studs (de Robot Simulator/Assets.rbxm) |
| RobotSim_BlackCogSword.rbxm | RobotSim | 2 | non | Arme / outil, 1 particules/effets, Tool prêt à donner, 0x3x3 studs (de Robot Simulator/Assets.rbxm) |
| RobotSim_BlackDagger.rbxm | RobotSim | 3 | non | Arme / outil, 1 particules/effets, Tool prêt à donner, 0x5x1 studs (de Robot Simulator/Assets.rbxm) |
| RobotSim_BlackHammer.rbxm | RobotSim | 4 | non | Arme / outil, 1 particules/effets, Tool prêt à donner, 1x5x2 studs (de Robot Simulator/Assets.rbxm) |
| RobotSim_BlackSlasher.rbxm | RobotSim | 3 | non | Arme / outil, 1 particules/effets, Tool prêt à donner, 0x5x1 studs (de Robot Simulator/Assets.rbxm) |
| RobotSim_BlackSlicer.rbxm | RobotSim | 3 | non | Arme / outil, 1 particules/effets, Tool prêt à donner, 0x6x1 studs (de Robot Simulator/Assets.rbxm) |
| RobotSim_BlueAxe.rbxm | RobotSim | 4 | non | Arme / outil, 1 particules/effets, Tool prêt à donner, 0x5x3 studs (de Robot Simulator/Assets.rbxm) |
| RobotSim_BlueCogSword.rbxm | RobotSim | 2 | non | Arme / outil, 1 particules/effets, Tool prêt à donner, 0x3x3 studs (de Robot Simulator/Assets.rbxm) |
| RobotSim_BlueDagger.rbxm | RobotSim | 3 | non | Arme / outil, 1 particules/effets, Tool prêt à donner, 0x5x1 studs (de Robot Simulator/Assets.rbxm) |
| RobotSim_BlueHammer.rbxm | RobotSim | 4 | non | Arme / outil, 1 particules/effets, Tool prêt à donner, 1x5x2 studs (de Robot Simulator/Assets.rbxm) |
| RobotSim_BlueSlasher.rbxm | RobotSim | 3 | non | Arme / outil, 1 particules/effets, Tool prêt à donner, 0x5x1 studs (de Robot Simulator/Assets.rbxm) |
| RobotSim_BlueSlicer.rbxm | RobotSim | 3 | non | Arme / outil, 1 particules/effets, Tool prêt à donner, 0x6x1 studs (de Robot Simulator/Assets.rbxm) |
| RobotSim_BrownAxe.rbxm | RobotSim | 4 | non | Arme / outil, 1 particules/effets, Tool prêt à donner, 0x5x3 studs (de Robot Simulator/Assets.rbxm) |
| RobotSim_BrownCogBlade.rbxm | RobotSim | 5 | non | Arme / outil, 1 particules/effets, Tool prêt à donner, 0x6x1 studs (de Robot Simulator/Assets.rbxm) |
| RobotSim_BrownCogSword.rbxm | RobotSim | 2 | non | Arme / outil, 1 particules/effets, Tool prêt à donner, 0x3x3 studs (de Robot Simulator/Assets.rbxm) |
| RobotSim_BrownDagger.rbxm | RobotSim | 3 | non | Arme / outil, 1 particules/effets, Tool prêt à donner, 0x5x1 studs (de Robot Simulator/Assets.rbxm) |
| RobotSim_BrownHammer.rbxm | RobotSim | 4 | non | Arme / outil, 1 particules/effets, Tool prêt à donner, 1x5x2 studs (de Robot Simulator/Assets.rbxm) |
| RobotSim_BrownScythe.rbxm | RobotSim | 2 | non | Arme / outil, 1 particules/effets, Tool prêt à donner, 0x6x4 studs (de Robot Simulator/Assets.rbxm) |
| RobotSim_BrownSlasher.rbxm | RobotSim | 3 | non | Arme / outil, 1 particules/effets, Tool prêt à donner, 0x5x1 studs (de Robot Simulator/Assets.rbxm) |
| RobotSim_BrownSlicer.rbxm | RobotSim | 3 | non | Arme / outil, 1 particules/effets, Tool prêt à donner, 0x6x1 studs (de Robot Simulator/Assets.rbxm) |
| RobotSim_CogBlade.rbxm | RobotSim | 5 | non | Arme / outil, 1 particules/effets, Tool prêt à donner, 0x6x1 studs (de Robot Simulator/Assets.rbxm) |
| RobotSim_CogBlade_2.rbxm | RobotSim | 9 | non | Arme / outil, 2x50x8 studs (de Robot Simulator/Cog Blade.rbxm) |
| RobotSim_CogSword.rbxm | RobotSim | 2 | non | Arme / outil, 1 particules/effets, Tool prêt à donner, 0x3x3 studs (de Robot Simulator/Assets.rbxm) |
| RobotSim_CyanAxe.rbxm | RobotSim | 4 | non | Arme / outil, 1 particules/effets, Tool prêt à donner, 0x5x3 studs (de Robot Simulator/Assets.rbxm) |
| RobotSim_CyanCogBlade.rbxm | RobotSim | 5 | non | Arme / outil, 1 particules/effets, Tool prêt à donner, 0x6x1 studs (de Robot Simulator/Assets.rbxm) |
| RobotSim_CyanCogSword.rbxm | RobotSim | 2 | non | Arme / outil, 1 particules/effets, Tool prêt à donner, 0x3x3 studs (de Robot Simulator/Assets.rbxm) |
| RobotSim_CyanDagger.rbxm | RobotSim | 3 | non | Arme / outil, 1 particules/effets, Tool prêt à donner, 0x5x1 studs (de Robot Simulator/Assets.rbxm) |
| RobotSim_CyanHammer.rbxm | RobotSim | 4 | non | Arme / outil, 1 particules/effets, Tool prêt à donner, 1x5x2 studs (de Robot Simulator/Assets.rbxm) |
| RobotSim_CyanScythe.rbxm | RobotSim | 2 | non | Arme / outil, 1 particules/effets, Tool prêt à donner, 0x6x4 studs (de Robot Simulator/Assets.rbxm) |
| RobotSim_CyanSlasher.rbxm | RobotSim | 3 | non | Arme / outil, 1 particules/effets, Tool prêt à donner, 0x5x1 studs (de Robot Simulator/Assets.rbxm) |
| RobotSim_CyanSlicer.rbxm | RobotSim | 3 | non | Arme / outil, 1 particules/effets, Tool prêt à donner, 0x6x1 studs (de Robot Simulator/Assets.rbxm) |
| RobotSim_Dagger.rbxm | RobotSim | 3 | non | Arme / outil, 1 particules/effets, Tool prêt à donner, 0x5x1 studs (de Robot Simulator/Assets.rbxm) |
| RobotSim_DarkCogBlade.rbxm | RobotSim | 5 | non | Arme / outil, 1 particules/effets, Tool prêt à donner, 0x6x1 studs (de Robot Simulator/Assets.rbxm) |
| RobotSim_DarkScythe.rbxm | RobotSim | 2 | non | Arme / outil, 1 particules/effets, Tool prêt à donner, 0x6x4 studs (de Robot Simulator/Assets.rbxm) |
| RobotSim_EvilAxe.rbxm | RobotSim | 4 | non | Arme / outil, 2 particules/effets, Tool prêt à donner, 0x5x3 studs (de Robot Simulator/Assets.rbxm) |
| RobotSim_EvilDagger.rbxm | RobotSim | 3 | non | Arme / outil, 2 particules/effets, Tool prêt à donner, 0x5x1 studs (de Robot Simulator/Assets.rbxm) |
| RobotSim_EvilHammer.rbxm | RobotSim | 4 | non | Arme / outil, 2 particules/effets, Tool prêt à donner, 1x5x2 studs (de Robot Simulator/Assets.rbxm) |
| RobotSim_EvilSlasher.rbxm | RobotSim | 3 | non | Arme / outil, 2 particules/effets, Tool prêt à donner, 0x5x1 studs (de Robot Simulator/Assets.rbxm) |
| RobotSim_EvilSlicer.rbxm | RobotSim | 3 | non | Arme / outil, 2 particules/effets, Tool prêt à donner, 0x6x1 studs (de Robot Simulator/Assets.rbxm) |
| RobotSim_GreenAxe.rbxm | RobotSim | 4 | non | Arme / outil, 1 particules/effets, Tool prêt à donner, 0x5x3 studs (de Robot Simulator/Assets.rbxm) |
| RobotSim_GreenCogBlade.rbxm | RobotSim | 5 | non | Arme / outil, 1 particules/effets, Tool prêt à donner, 0x6x1 studs (de Robot Simulator/Assets.rbxm) |
| RobotSim_GreenCogSword.rbxm | RobotSim | 2 | non | Arme / outil, 1 particules/effets, Tool prêt à donner, 0x3x3 studs (de Robot Simulator/Assets.rbxm) |
| RobotSim_GreenDagger.rbxm | RobotSim | 3 | non | Arme / outil, 1 particules/effets, Tool prêt à donner, 0x5x1 studs (de Robot Simulator/Assets.rbxm) |
| RobotSim_GreenHammer.rbxm | RobotSim | 4 | non | Arme / outil, 1 particules/effets, Tool prêt à donner, 1x5x2 studs (de Robot Simulator/Assets.rbxm) |
| RobotSim_GreenScythe.rbxm | RobotSim | 2 | non | Arme / outil, 1 particules/effets, Tool prêt à donner, 0x6x4 studs (de Robot Simulator/Assets.rbxm) |
| RobotSim_GreenSlasher.rbxm | RobotSim | 3 | non | Arme / outil, 1 particules/effets, Tool prêt à donner, 0x5x1 studs (de Robot Simulator/Assets.rbxm) |
| RobotSim_GreenSlicer.rbxm | RobotSim | 3 | non | Arme / outil, 1 particules/effets, Tool prêt à donner, 0x6x1 studs (de Robot Simulator/Assets.rbxm) |
| RobotSim_Hammer.rbxm | RobotSim | 4 | non | Arme / outil, 1 particules/effets, Tool prêt à donner, 1x5x2 studs (de Robot Simulator/Assets.rbxm) |
| RobotSim_LightAxe.rbxm | RobotSim | 4 | non | Arme / outil, 1 particules/effets, Tool prêt à donner, 0x5x3 studs (de Robot Simulator/Assets.rbxm) |
| RobotSim_LightCogBlade.rbxm | RobotSim | 5 | non | Arme / outil, 1 particules/effets, Tool prêt à donner, 0x6x1 studs (de Robot Simulator/Assets.rbxm) |
| RobotSim_LightCogSword.rbxm | RobotSim | 2 | non | Arme / outil, 1 particules/effets, Tool prêt à donner, 0x3x3 studs (de Robot Simulator/Assets.rbxm) |
| RobotSim_LightDagger.rbxm | RobotSim | 3 | non | Arme / outil, 1 particules/effets, Tool prêt à donner, 0x5x1 studs (de Robot Simulator/Assets.rbxm) |
| RobotSim_LightHammer.rbxm | RobotSim | 4 | non | Arme / outil, 1 particules/effets, Tool prêt à donner, 1x5x2 studs (de Robot Simulator/Assets.rbxm) |
| RobotSim_LightSlasher.rbxm | RobotSim | 3 | non | Arme / outil, 1 particules/effets, Tool prêt à donner, 0x5x1 studs (de Robot Simulator/Assets.rbxm) |
| RobotSim_LightSlicer.rbxm | RobotSim | 3 | non | Arme / outil, 1 particules/effets, Tool prêt à donner, 0x6x1 studs (de Robot Simulator/Assets.rbxm) |
| RobotSim_LimeGreenAxe.rbxm | RobotSim | 4 | non | Arme / outil, 1 particules/effets, Tool prêt à donner, 0x5x3 studs (de Robot Simulator/Assets.rbxm) |
| RobotSim_LimeGreenCogBlade.rbxm | RobotSim | 5 | non | Arme / outil, 1 particules/effets, Tool prêt à donner, 0x6x1 studs (de Robot Simulator/Assets.rbxm) |
| RobotSim_LimeGreenDagger.rbxm | RobotSim | 3 | non | Arme / outil, 1 particules/effets, Tool prêt à donner, 0x5x1 studs (de Robot Simulator/Assets.rbxm) |
| RobotSim_LimeGreenHammer.rbxm | RobotSim | 4 | non | Arme / outil, 1 particules/effets, Tool prêt à donner, 1x5x2 studs (de Robot Simulator/Assets.rbxm) |
| RobotSim_LimeGreenSlasher.rbxm | RobotSim | 3 | non | Arme / outil, 1 particules/effets, Tool prêt à donner, 0x5x1 studs (de Robot Simulator/Assets.rbxm) |
| RobotSim_LimeGreenSlicer.rbxm | RobotSim | 3 | non | Arme / outil, 1 particules/effets, Tool prêt à donner, 0x6x1 studs (de Robot Simulator/Assets.rbxm) |
| RobotSim_MagentaAxe.rbxm | RobotSim | 4 | non | Arme / outil, 1 particules/effets, Tool prêt à donner, 0x5x3 studs (de Robot Simulator/Assets.rbxm) |
| RobotSim_MagentaCogBlade.rbxm | RobotSim | 5 | non | Arme / outil, 1 particules/effets, Tool prêt à donner, 0x6x1 studs (de Robot Simulator/Assets.rbxm) |
| RobotSim_MagentaCogSword.rbxm | RobotSim | 2 | non | Arme / outil, 1 particules/effets, Tool prêt à donner, 0x3x3 studs (de Robot Simulator/Assets.rbxm) |
| RobotSim_MagentaDagger.rbxm | RobotSim | 3 | non | Arme / outil, 1 particules/effets, Tool prêt à donner, 0x5x1 studs (de Robot Simulator/Assets.rbxm) |
| RobotSim_MagentaHammer.rbxm | RobotSim | 4 | non | Arme / outil, 1 particules/effets, Tool prêt à donner, 1x5x2 studs (de Robot Simulator/Assets.rbxm) |
| RobotSim_MagentaScythe.rbxm | RobotSim | 2 | non | Arme / outil, 1 particules/effets, Tool prêt à donner, 0x6x4 studs (de Robot Simulator/Assets.rbxm) |
| RobotSim_MagentaSlasher.rbxm | RobotSim | 3 | non | Arme / outil, 1 particules/effets, Tool prêt à donner, 0x5x1 studs (de Robot Simulator/Assets.rbxm) |
| RobotSim_MagentaSlicer.rbxm | RobotSim | 3 | non | Arme / outil, 1 particules/effets, Tool prêt à donner, 0x6x1 studs (de Robot Simulator/Assets.rbxm) |
| RobotSim_OrangeAxe.rbxm | RobotSim | 4 | non | Arme / outil, 1 particules/effets, Tool prêt à donner, 0x5x3 studs (de Robot Simulator/Assets.rbxm) |
| RobotSim_OrangeCogBlade.rbxm | RobotSim | 5 | non | Arme / outil, 1 particules/effets, Tool prêt à donner, 0x6x1 studs (de Robot Simulator/Assets.rbxm) |
| RobotSim_OrangeCogBlade_2.rbxm | RobotSim | 9 | non | Arme / outil, 2x50x8 studs (de Robot Simulator/Orange Cog Blade.rbxm) |
| RobotSim_OrangeCogSword.rbxm | RobotSim | 2 | non | Arme / outil, 1 particules/effets, Tool prêt à donner, 0x3x3 studs (de Robot Simulator/Assets.rbxm) |
| RobotSim_OrangeDagger.rbxm | RobotSim | 3 | non | Arme / outil, 1 particules/effets, Tool prêt à donner, 0x5x1 studs (de Robot Simulator/Assets.rbxm) |
| RobotSim_OrangeHammer.rbxm | RobotSim | 4 | non | Arme / outil, 1 particules/effets, Tool prêt à donner, 1x5x2 studs (de Robot Simulator/Assets.rbxm) |
| RobotSim_OrangeScythe.rbxm | RobotSim | 2 | non | Arme / outil, 1 particules/effets, Tool prêt à donner, 0x6x4 studs (de Robot Simulator/Assets.rbxm) |
| RobotSim_OrangeSlasher.rbxm | RobotSim | 3 | non | Arme / outil, 1 particules/effets, Tool prêt à donner, 0x5x1 studs (de Robot Simulator/Assets.rbxm) |
| RobotSim_OrangeSlicer.rbxm | RobotSim | 3 | non | Arme / outil, 1 particules/effets, Tool prêt à donner, 0x6x1 studs (de Robot Simulator/Assets.rbxm) |
| RobotSim_PinkAxe.rbxm | RobotSim | 4 | non | Arme / outil, 1 particules/effets, Tool prêt à donner, 0x5x3 studs (de Robot Simulator/Assets.rbxm) |
| RobotSim_PinkCogBlade.rbxm | RobotSim | 5 | non | Arme / outil, 1 particules/effets, Tool prêt à donner, 0x6x1 studs (de Robot Simulator/Assets.rbxm) |
| RobotSim_PinkCogSword.rbxm | RobotSim | 2 | non | Arme / outil, 1 particules/effets, Tool prêt à donner, 0x3x3 studs (de Robot Simulator/Assets.rbxm) |
| RobotSim_PinkDagger.rbxm | RobotSim | 3 | non | Arme / outil, 1 particules/effets, Tool prêt à donner, 0x5x1 studs (de Robot Simulator/Assets.rbxm) |
| RobotSim_PinkHammer.rbxm | RobotSim | 4 | non | Arme / outil, 1 particules/effets, Tool prêt à donner, 1x5x2 studs (de Robot Simulator/Assets.rbxm) |
| RobotSim_PinkScythe.rbxm | RobotSim | 2 | non | Arme / outil, 1 particules/effets, Tool prêt à donner, 0x6x4 studs (de Robot Simulator/Assets.rbxm) |
| RobotSim_PinkSlasher.rbxm | RobotSim | 3 | non | Arme / outil, 1 particules/effets, Tool prêt à donner, 0x5x1 studs (de Robot Simulator/Assets.rbxm) |
| RobotSim_PinkSlicer.rbxm | RobotSim | 3 | non | Arme / outil, 1 particules/effets, Tool prêt à donner, 0x6x1 studs (de Robot Simulator/Assets.rbxm) |
| RobotSim_PlasmaBlueCogBlade.rbxm | RobotSim | 5 | non | Arme / outil, 2 particules/effets, Tool prêt à donner, 0x6x1 studs (de Robot Simulator/Assets.rbxm) |
| RobotSim_PlasmaBlueScythe.rbxm | RobotSim | 2 | non | Arme / outil, 2 particules/effets, Tool prêt à donner, 0x6x4 studs (de Robot Simulator/Assets.rbxm) |
| RobotSim_PlasmaGreenCogSword.rbxm | RobotSim | 2 | non | Arme / outil, 2 particules/effets, Tool prêt à donner, 0x3x3 studs (de Robot Simulator/Assets.rbxm) |
| RobotSim_PlasmaGreenScythe.rbxm | RobotSim | 2 | non | Arme / outil, 2 particules/effets, Tool prêt à donner, 0x6x4 studs (de Robot Simulator/Assets.rbxm) |
| RobotSim_PurpleAxe.rbxm | RobotSim | 4 | non | Arme / outil, 1 particules/effets, Tool prêt à donner, 0x5x3 studs (de Robot Simulator/Assets.rbxm) |
| RobotSim_PurpleCogBlade.rbxm | RobotSim | 5 | non | Arme / outil, 1 particules/effets, Tool prêt à donner, 0x6x1 studs (de Robot Simulator/Assets.rbxm) |
| RobotSim_PurpleCogSword.rbxm | RobotSim | 2 | non | Arme / outil, 1 particules/effets, Tool prêt à donner, 0x3x3 studs (de Robot Simulator/Assets.rbxm) |
| RobotSim_PurpleDagger.rbxm | RobotSim | 3 | non | Arme / outil, 1 particules/effets, Tool prêt à donner, 0x5x1 studs (de Robot Simulator/Assets.rbxm) |
| RobotSim_PurpleHammer.rbxm | RobotSim | 4 | non | Arme / outil, 1 particules/effets, Tool prêt à donner, 1x5x2 studs (de Robot Simulator/Assets.rbxm) |
| RobotSim_PurpleScythe.rbxm | RobotSim | 2 | non | Arme / outil, 1 particules/effets, Tool prêt à donner, 0x6x4 studs (de Robot Simulator/Assets.rbxm) |
| RobotSim_PurpleSlasher.rbxm | RobotSim | 3 | non | Arme / outil, 1 particules/effets, Tool prêt à donner, 0x5x1 studs (de Robot Simulator/Assets.rbxm) |
| RobotSim_PurpleSlicer.rbxm | RobotSim | 3 | non | Arme / outil, 1 particules/effets, Tool prêt à donner, 0x6x1 studs (de Robot Simulator/Assets.rbxm) |
| RobotSim_RedCogBlade.rbxm | RobotSim | 5 | non | Arme / outil, 1 particules/effets, Tool prêt à donner, 0x6x1 studs (de Robot Simulator/Assets.rbxm) |
| RobotSim_RedCogSword.rbxm | RobotSim | 2 | non | Arme / outil, 1 particules/effets, Tool prêt à donner, 0x3x3 studs (de Robot Simulator/Assets.rbxm) |
| RobotSim_RedScythe.rbxm | RobotSim | 2 | non | Arme / outil, 1 particules/effets, Tool prêt à donner, 0x6x4 studs (de Robot Simulator/Assets.rbxm) |
| RobotSim_Scythe.rbxm | RobotSim | 2 | non | Arme / outil, 1 particules/effets, Tool prêt à donner, 0x6x4 studs (de Robot Simulator/Assets.rbxm) |
| RobotSim_Slasher.rbxm | RobotSim | 3 | non | Arme / outil, 1 particules/effets, Tool prêt à donner, 0x5x1 studs (de Robot Simulator/Assets.rbxm) |
| RobotSim_Slicer.rbxm | RobotSim | 3 | non | Arme / outil, 1 particules/effets, Tool prêt à donner, 0x6x1 studs (de Robot Simulator/Assets.rbxm) |
| RobotSim_TanAxe.rbxm | RobotSim | 4 | non | Arme / outil, 1 particules/effets, Tool prêt à donner, 0x5x3 studs (de Robot Simulator/Assets.rbxm) |
| RobotSim_TanCogBlade.rbxm | RobotSim | 5 | non | Arme / outil, 1 particules/effets, Tool prêt à donner, 0x6x1 studs (de Robot Simulator/Assets.rbxm) |
| RobotSim_TanCogSword.rbxm | RobotSim | 2 | non | Arme / outil, 1 particules/effets, Tool prêt à donner, 0x3x3 studs (de Robot Simulator/Assets.rbxm) |
| RobotSim_TanDagger.rbxm | RobotSim | 3 | non | Arme / outil, 1 particules/effets, Tool prêt à donner, 0x5x1 studs (de Robot Simulator/Assets.rbxm) |
| RobotSim_TanHammer.rbxm | RobotSim | 4 | non | Arme / outil, 1 particules/effets, Tool prêt à donner, 1x5x2 studs (de Robot Simulator/Assets.rbxm) |
| RobotSim_TanScythe.rbxm | RobotSim | 2 | non | Arme / outil, 1 particules/effets, Tool prêt à donner, 0x6x4 studs (de Robot Simulator/Assets.rbxm) |
| RobotSim_TanSlasher.rbxm | RobotSim | 3 | non | Arme / outil, 1 particules/effets, Tool prêt à donner, 0x5x1 studs (de Robot Simulator/Assets.rbxm) |
| RobotSim_TanSlicer.rbxm | RobotSim | 3 | non | Arme / outil, 1 particules/effets, Tool prêt à donner, 0x6x1 studs (de Robot Simulator/Assets.rbxm) |
| RobotSim_Test.rbxm | RobotSim | 9 | oui (1) | Arme / outil, Tool prêt à donner, 0x8x1 studs (de Robot Simulator/OLD_THINGS.rbxm) |
| RobotSim_WhiteScythe.rbxm | RobotSim | 2 | non | Arme / outil, 1 particules/effets, Tool prêt à donner, 0x6x4 studs (de Robot Simulator/Assets.rbxm) |
| RobotSim_YellowAxe.rbxm | RobotSim | 4 | non | Arme / outil, 1 particules/effets, Tool prêt à donner, 0x5x3 studs (de Robot Simulator/Assets.rbxm) |
| RobotSim_YellowCogBlade.rbxm | RobotSim | 5 | non | Arme / outil, 1 particules/effets, Tool prêt à donner, 0x6x1 studs (de Robot Simulator/Assets.rbxm) |
| RobotSim_YellowCogSword.rbxm | RobotSim | 2 | non | Arme / outil, 1 particules/effets, Tool prêt à donner, 0x3x3 studs (de Robot Simulator/Assets.rbxm) |
| RobotSim_YellowDagger.rbxm | RobotSim | 3 | non | Arme / outil, 1 particules/effets, Tool prêt à donner, 0x5x1 studs (de Robot Simulator/Assets.rbxm) |
| RobotSim_YellowHammer.rbxm | RobotSim | 4 | non | Arme / outil, 1 particules/effets, Tool prêt à donner, 1x5x2 studs (de Robot Simulator/Assets.rbxm) |
| RobotSim_YellowScythe.rbxm | RobotSim | 2 | non | Arme / outil, 1 particules/effets, Tool prêt à donner, 0x6x4 studs (de Robot Simulator/Assets.rbxm) |
| RobotSim_YellowSlasher.rbxm | RobotSim | 3 | non | Arme / outil, 1 particules/effets, Tool prêt à donner, 0x5x1 studs (de Robot Simulator/Assets.rbxm) |
| RobotSim_YellowSlicer.rbxm | RobotSim | 3 | non | Arme / outil, 1 particules/effets, Tool prêt à donner, 0x6x1 studs (de Robot Simulator/Assets.rbxm) |
| ShootABrainrot_BasicRifle.rbxm | ShootABrainrot | 4 | non | Arme / outil, Tool prêt à donner, 1x1x5 studs (de ShootABrainrotEU/Assets.rbxm) |
| ShootABrainrot_DarkForceRival.rbxm | ShootABrainrot | 5 | non | Arme / outil, Tool prêt à donner, 1x2x5 studs (de ShootABrainrotEU/Assets.rbxm) |
| ShootABrainrot_DeadlyRifle.rbxm | ShootABrainrot | 3 | non | Arme / outil, Tool prêt à donner, 0x1x4 studs (de ShootABrainrotEU/Assets.rbxm) |
| ShootABrainrot_Deagle.rbxm | ShootABrainrot | 3 | non | Arme / outil, Tool prêt à donner, 1x1x3 studs (de ShootABrainrotEU/Assets.rbxm) |
| ShootABrainrot_GoldenRifle.rbxm | ShootABrainrot | 3 | non | Arme / outil, Tool prêt à donner, 0x1x4 studs (de ShootABrainrotEU/Assets.rbxm) |
| ShootABrainrot_GunsShop.rbxm | ShootABrainrot | 26 | non | Arme / outil, 14x11x9 studs (de ShootABrainrotEU/Workspace/Main.rbxm) |
| ShootABrainrot_RPG.rbxm | ShootABrainrot | 3 | non | Arme / outil, Tool prêt à donner, 1x1x4 studs (de ShootABrainrotEU/Assets.rbxm) |
| ShootABrainrot_StarterRifle.rbxm | ShootABrainrot | 4 | non | Arme / outil, Tool prêt à donner, 0x2x5 studs (de ShootABrainrotEU/Assets.rbxm) |
| TweetingSim_BloxBook.rbxm | TweetingSim | 6 | non | Arme / outil, Tool prêt à donner, 3x2x3 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Objects.rbxm) |
| TweetingSim_BloxBookAir.rbxm | TweetingSim | 6 | non | Arme / outil, Tool prêt à donner, 3x2x3 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Objects.rbxm) |
| TweetingSim_BloxBookAirE.rbxm | TweetingSim | 6 | non | Arme / outil, Tool prêt à donner, 3x2x3 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Objects.rbxm) |
| TweetingSim_BloxBookPro.rbxm | TweetingSim | 6 | non | Arme / outil, Tool prêt à donner, 3x2x3 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Objects.rbxm) |
| TweetingSim_EtherBook.rbxm | TweetingSim | 6 | non | Arme / outil, 1 particules/effets, Tool prêt à donner, 3x2x3 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Objects.rbxm) |
| TweetingSim_Insta.rbxm | TweetingSim | 2 | non | Arme / outil, Tool prêt à donner, 0x3x2 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Objects.rbxm) |
| TweetingSim_rAsyncEther.rbxm | TweetingSim | 3 | non | Arme / outil, 1 particules/effets, Tool prêt à donner, 0x3x3 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Objects.rbxm) |
| TweetingSim_rFloansVoid.rbxm | TweetingSim | 1 | non | Arme / outil, 1 particules/effets, Tool prêt à donner, 1x2x1 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Objects.rbxm) |
| TweetingSim_Rokia.rbxm | TweetingSim | 1 | non | Arme / outil, Tool prêt à donner, 0x2x1 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Objects.rbxm) |
| TweetingSim_RooglePixel.rbxm | TweetingSim | 2 | non | Arme / outil, Tool prêt à donner, 0x2x1 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Objects.rbxm) |
| TweetingSim_RooglePixelBlue.rbxm | TweetingSim | 2 | non | Arme / outil, Tool prêt à donner, 0x2x1 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Objects.rbxm) |
| TweetingSim_RooglePixelOrange.rbxm | TweetingSim | 2 | non | Arme / outil, Tool prêt à donner, 0x2x1 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Objects.rbxm) |
| TweetingSim_RooglePixelRed.rbxm | TweetingSim | 2 | non | Arme / outil, Tool prêt à donner, 0x2x1 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Objects.rbxm) |
| TweetingSim_RooglePixelS.rbxm | TweetingSim | 2 | non | Arme / outil, Tool prêt à donner, 0x2x1 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Objects.rbxm) |
| TweetingSim_Rosung.rbxm | TweetingSim | 3 | non | Arme / outil, Tool prêt à donner, 1x2x1 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Objects.rbxm) |
| TweetingSim_Rosung20.rbxm | TweetingSim | 4 | non | Arme / outil, Tool prêt à donner, 1x2x1 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Objects.rbxm) |
| TweetingSim_Rosung30.rbxm | TweetingSim | 3 | non | Arme / outil, Tool prêt à donner, 1x2x1 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Objects.rbxm) |
| TweetingSim_RosungSlim.rbxm | TweetingSim | 3 | non | Arme / outil, Tool prêt à donner, 1x2x1 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Objects.rbxm) |
| TweetingSim_RosungSlim20.rbxm | TweetingSim | 3 | non | Arme / outil, Tool prêt à donner, 1x2x1 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Objects.rbxm) |
| TweetingSim_RotorolaBrick.rbxm | TweetingSim | 1 | non | Arme / outil, Tool prêt à donner, 1x3x1 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Objects.rbxm) |
| TweetingSim_RotorolaBrickSlim.rbxm | TweetingSim | 1 | non | Arme / outil, Tool prêt à donner, 1x2x1 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Objects.rbxm) |
| TweetingSim_RuaweiGlass.rbxm | TweetingSim | 3 | non | Arme / outil, Tool prêt à donner, 0x2x1 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Objects.rbxm) |
| TweetingSim_RuaweiSlate.rbxm | TweetingSim | 3 | non | Arme / outil, Tool prêt à donner, 0x2x1 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Objects.rbxm) |
| TweetingSim_VoidBook.rbxm | TweetingSim | 6 | non | Arme / outil, 1 particules/effets, Tool prêt à donner, 3x2x3 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Objects.rbxm) |

## Gear_Gadgets

Dossier `ByType/Gear_Gadgets/` — 80 objets.

| Fichier | Jeu | Pièces | Scripts | Description |
|---|---|---|---|---|
| 1HealthEverySecond_BloxyCola.rbxm | 1HealthEverySecond | 1 | oui (1) | Gadget / équipement, Tool prêt à donner, 1x1x1 studs (de 1HealthEverySecond/Assets.rbxm) |
| 1HealthEverySecond_Pizza.rbxm | 1HealthEverySecond | 1 | oui (1) | Gadget / équipement, Tool prêt à donner, 1x1x1 studs (de 1HealthEverySecond/Assets.rbxm) |
| 1HealthEverySecond_TeddyBear.rbxm | 1HealthEverySecond | 1 | oui (1) | Gadget / équipement, Tool prêt à donner, 1x3x2 studs (de 1HealthEverySecond/Assets.rbxm) |
| 1JumpEverySecond_BloxyCola.rbxm | 1JumpEverySecond | 1 | oui (1) | Gadget / équipement, Tool prêt à donner, 1x1x1 studs (de 1JumpEverySecond/Assets.rbxm) |
| 1JumpEverySecond_Boombox.rbxm | 1JumpEverySecond | 1 | oui (4) | Gadget / équipement, Tool prêt à donner, 3x2x1 studs (de 1JumpEverySecond/GamepassesTools.rbxm) |
| 1JumpEverySecond_GrappleHook.rbxm | 1JumpEverySecond | 1 | oui (4) | Gadget / équipement, Tool prêt à donner, 1x1x2 studs (de 1JumpEverySecond/GamepassesTools.rbxm) |
| 1JumpEverySecond_GrappleHook_2.rbxm | 1JumpEverySecond | 8 | oui (1) | Gadget / équipement, 5 particules/effets, SurfaceGui/Billboard, 6x6x7 studs (de 1JumpEverySecond/Workspace/GrappleHook.rbxm) |
| 1JumpEverySecond_GravityCoil.rbxm | 1JumpEverySecond | 1 | oui (1) | Gadget / équipement, Tool prêt à donner, 1x1x2 studs (de 1JumpEverySecond/GamepassesTools.rbxm) |
| 1JumpEverySecond_Hoverboard.rbxm | 1JumpEverySecond | 1 | oui (2) | Gadget / équipement, Tool prêt à donner, 1x1x1 studs (de 1JumpEverySecond/GamepassesTools.rbxm) |
| 1JumpEverySecond_HoverboardModel.rbxm | 1JumpEverySecond | 7 | non | Gadget / équipement, 2 particules/effets, 1x1x6 studs (de 1JumpEverySecond/Workspace/HoverboardModel.rbxm) |
| 1JumpEverySecond_Jetpack.rbxm | 1JumpEverySecond | 1 | oui (3) | Gadget / équipement, 2 particules/effets, Tool prêt à donner, 5x5x5 studs (de 1JumpEverySecond/GamepassesTools.rbxm) |
| 1JumpEverySecond_Pizza.rbxm | 1JumpEverySecond | 1 | oui (1) | Gadget / équipement, Tool prêt à donner, 1x1x1 studs (de 1JumpEverySecond/Assets.rbxm) |
| 1JumpEverySecond_RainbowMagicCarpet.rbxm | 1JumpEverySecond | 1 | oui (4) | Gadget / équipement, Tool prêt à donner, 7x3x6 studs (de 1JumpEverySecond/GamepassesTools.rbxm) |
| 1JumpEverySecond_SpeedCoil.rbxm | 1JumpEverySecond | 1 | oui (1) | Gadget / équipement, Tool prêt à donner, 1x2x1 studs (de 1JumpEverySecond/GamepassesTools.rbxm) |
| 1JumpEverySecond_TeddyBear.rbxm | 1JumpEverySecond | 1 | oui (1) | Gadget / équipement, Tool prêt à donner, 1x3x2 studs (de 1JumpEverySecond/Assets.rbxm) |
| BillionaireTycoon_HandlessSegway.rbxm | BillionaireTycoon | 14 | oui (7) | Gadget / équipement, Tool prêt à donner, 3x1x1 studs (de Billionaire_Tycoon/HandlessSegway.rbxm) |
| CashgrabBridge_Coil.rbxm | CashgrabBridge | 1 | oui (1) | Gadget / équipement, Tool prêt à donner, 2x1x1 studs (de CashgrabBridgeEU/Storage.rbxm) |
| CashgrabBridge_FlyingCarpet.rbxm | CashgrabBridge | 1 | oui (4) | Gadget / équipement, Tool prêt à donner, 6x3x7 studs (de CashgrabBridgeEU/Storage.rbxm) |
| CashgrabBridge_GrappleHook.rbxm | CashgrabBridge | 1 | oui (4) | Gadget / équipement, Tool prêt à donner, 1x2x2 studs (de CashgrabBridgeEU/Storage.rbxm) |
| CashgrabBridge_GravityCoil.rbxm | CashgrabBridge | 1 | oui (1) | Gadget / équipement, Tool prêt à donner, 2x1x2 studs (de CashgrabBridgeEU/Storage.rbxm) |
| CashgrabBridge_GravityCoilGiver.rbxm | CashgrabBridge | 7 | oui (2) | Gadget / équipement, ancrage d’origine conservé, 6x7x5 studs (de CashgrabBridgeEU/Workspace/Magic Carpet Speed Coil and Gravity Coil Givers.rbxm) |
| CashgrabBridge_Jetpack.rbxm | CashgrabBridge | 28 | oui (3) | Gadget / équipement, 6 particules/effets, Tool prêt à donner, 2x4x2 studs (de CashgrabBridgeEU/Storage.rbxm) |
| CashgrabBridge_RainbowMagicCarpetgiver.rbxm | CashgrabBridge | 7 | oui (4) | Gadget / équipement, ancrage d’origine conservé, 5x7x6 studs (de CashgrabBridgeEU/Workspace/Magic Carpet Speed Coil and Gravity Coil Givers.rbxm) |
| CashgrabBridge_SpeedCoilGiver.rbxm | CashgrabBridge | 7 | oui (1) | Gadget / équipement, ancrage d’origine conservé, 6x7x5 studs (de CashgrabBridgeEU/Workspace/Magic Carpet Speed Coil and Gravity Coil Givers.rbxm) |
| GlassBridge_BloxyCola.rbxm | GlassBridge | 1 | oui (1) | Gadget / équipement, Tool prêt à donner, 1x1x1 studs (de GlassBridge/LuckyblockGear.rbxm) |
| GlassBridge_Cheezburger.rbxm | GlassBridge | 1 | oui (1) | Gadget / équipement, Tool prêt à donner, 1x1x1 studs (de GlassBridge/LuckyblockGear.rbxm) |
| GlassBridge_GravityCoil.rbxm | GlassBridge | 1 | oui (1) | Gadget / équipement, Tool prêt à donner, 1x1x2 studs (de GlassBridge/GamepassComponents.rbxm) |
| GlassBridge_Lantern.rbxm | GlassBridge | 14 | non | Gadget / équipement, 1 particules/effets, Tool prêt à donner, 1x3x1 studs (de GlassBridge/LuckyblockGear.rbxm) |
| GlassBridge_MagicCarpet.rbxm | GlassBridge | 1 | oui (4) | Gadget / équipement, Tool prêt à donner, 6x3x7 studs (de GlassBridge/GamepassComponents.rbxm) |
| GlassBridge_RainbowPopIt.rbxm | GlassBridge | 9 | oui (2) | Gadget / équipement, Tool prêt à donner, 1x1x1 studs (de GlassBridge/LuckyblockGear.rbxm) |
| GlassBridge_SpeedCoil.rbxm | GlassBridge | 1 | oui (4) | Gadget / équipement, Tool prêt à donner, 1x1x2 studs (de GlassBridge/GamepassComponents.rbxm) |
| MagnetSim2_BigBackpack.rbxm | MagnetSim2 | 4 | non | Gadget / équipement, 2x3x2 studs (de UNCOPYLOCKED-Magnet-Simulator-2/Models.rbxm) |
| MagnetSim2_BlackGreenBigBackpack.rbxm | MagnetSim2 | 4 | non | Gadget / équipement, 2x3x2 studs (de UNCOPYLOCKED-Magnet-Simulator-2/Models.rbxm) |
| MagnetSim2_BlackMagnet.rbxm | MagnetSim2 | 1 | non | Gadget / équipement, 0x2x2 studs (de UNCOPYLOCKED-Magnet-Simulator-2/Models.rbxm) |
| MagnetSim2_CyanBigBackpack.rbxm | MagnetSim2 | 4 | non | Gadget / équipement, 2x3x2 studs (de UNCOPYLOCKED-Magnet-Simulator-2/Models.rbxm) |
| MagnetSim2_Favorite.rbxm | MagnetSim2 | 4 | non | Gadget / équipement, 4x5x1 studs (de UNCOPYLOCKED-Magnet-Simulator-2/Magnets.rbxm) |
| MagnetSim2_GodlyMagnet.rbxm | MagnetSim2 | 2 | non | Gadget / équipement, 6x0x6 studs (de UNCOPYLOCKED-Magnet-Simulator-2/Models.rbxm) |
| MagnetSim2_GradientBackpack.rbxm | MagnetSim2 | 6 | non | Gadget / équipement, 1 particules/effets, 2x3x1 studs (de UNCOPYLOCKED-Magnet-Simulator-2/Models.rbxm) |
| MagnetSim2_GreenBackpack.rbxm | MagnetSim2 | 6 | non | Gadget / équipement, 2x3x1 studs (de UNCOPYLOCKED-Magnet-Simulator-2/Models.rbxm) |
| MagnetSim2_GreyBackpack.rbxm | MagnetSim2 | 6 | non | Gadget / équipement, 2x3x1 studs (de UNCOPYLOCKED-Magnet-Simulator-2/Models.rbxm) |
| MagnetSim2_InfiniteBackpack.rbxm | MagnetSim2 | 6 | non | Gadget / équipement, 2x3x1 studs (de UNCOPYLOCKED-Magnet-Simulator-2/Models.rbxm) |
| MagnetSim2_Ionized.rbxm | MagnetSim2 | 1 | non | Gadget / équipement, 0x2x2 studs (de UNCOPYLOCKED-Magnet-Simulator-2/Models.rbxm) |
| MagnetSim2_LimeMagnet.rbxm | MagnetSim2 | 1 | non | Gadget / équipement, 0x2x2 studs (de UNCOPYLOCKED-Magnet-Simulator-2/Models.rbxm) |
| MagnetSim2_Metal.rbxm | MagnetSim2 | 3 | non | Gadget / équipement, 4x4x1 studs (de UNCOPYLOCKED-Magnet-Simulator-2/Magnets.rbxm) |
| MagnetSim2_PinkBackpack.rbxm | MagnetSim2 | 6 | non | Gadget / équipement, 2x3x1 studs (de UNCOPYLOCKED-Magnet-Simulator-2/Models.rbxm) |
| MagnetSim2_Ruby.rbxm | MagnetSim2 | 4 | non | Gadget / équipement, 4x5x1 studs (de UNCOPYLOCKED-Magnet-Simulator-2/Magnets.rbxm) |
| MagnetSim2_RubySapphire.rbxm | MagnetSim2 | 6 | non | Gadget / équipement, 4x5x1 studs (de UNCOPYLOCKED-Magnet-Simulator-2/Magnets.rbxm) |
| MagnetSim2_Sapphire.rbxm | MagnetSim2 | 4 | non | Gadget / équipement, 4x5x1 studs (de UNCOPYLOCKED-Magnet-Simulator-2/Magnets.rbxm) |
| MagnetSim2_SnowlyBackpack.rbxm | MagnetSim2 | 6 | non | Gadget / équipement, 2x3x1 studs (de UNCOPYLOCKED-Magnet-Simulator-2/Models.rbxm) |
| MagnetSim2_SpiritBlueMagnet.rbxm | MagnetSim2 | 5 | non | Gadget / équipement, 0x2x5 studs (de UNCOPYLOCKED-Magnet-Simulator-2/Models.rbxm) |
| MagnetSim2_SpiritToothpasteMagnet.rbxm | MagnetSim2 | 5 | non | Gadget / équipement, 0x2x5 studs (de UNCOPYLOCKED-Magnet-Simulator-2/Models.rbxm) |
| MagnetSim2_Starter.rbxm | MagnetSim2 | 1 | non | Gadget / équipement, 0x2x2 studs (de UNCOPYLOCKED-Magnet-Simulator-2/Models.rbxm) |
| MagnetSim2_Starter_2.rbxm | MagnetSim2 | 6 | non | Gadget / équipement, 2x3x1 studs (de UNCOPYLOCKED-Magnet-Simulator-2/Models.rbxm) |
| MagnetSim2_ToothpasteMagnet.rbxm | MagnetSim2 | 1 | non | Gadget / équipement, 0x2x2 studs (de UNCOPYLOCKED-Magnet-Simulator-2/Models.rbxm) |
| MagnetSim2_UltraGreenMagnet.rbxm | MagnetSim2 | 5 | non | Gadget / équipement, 0x2x6 studs (de UNCOPYLOCKED-Magnet-Simulator-2/Models.rbxm) |
| MagnetSim2_UltraYellowMagnet.rbxm | MagnetSim2 | 5 | non | Gadget / équipement, 0x2x6 studs (de UNCOPYLOCKED-Magnet-Simulator-2/Models.rbxm) |
| MagnetSim2_Wooden.rbxm | MagnetSim2 | 3 | non | Gadget / équipement, 4x4x1 studs (de UNCOPYLOCKED-Magnet-Simulator-2/Magnets.rbxm) |
| MagnetSim2_YellowMagnet.rbxm | MagnetSim2 | 1 | non | Gadget / équipement, 0x2x2 studs (de UNCOPYLOCKED-Magnet-Simulator-2/Models.rbxm) |
| MagnetSim2_YinYang.rbxm | MagnetSim2 | 6 | non | Gadget / équipement, 4x5x1 studs (de UNCOPYLOCKED-Magnet-Simulator-2/Magnets.rbxm) |
| MagnetSim2_YinYangBigBackpack.rbxm | MagnetSim2 | 9 | non | Gadget / équipement, 2x3x2 studs (de UNCOPYLOCKED-Magnet-Simulator-2/Models.rbxm) |
| TweetingSim_BackpackShop.rbxm | TweetingSim | 88 | non | Gadget / équipement, 2 particules/effets, 92x22x60 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Core.rbxm) |
| TweetingSim_BackpackSign.rbxm | TweetingSim | 5 | non | Gadget / équipement, 9x8x14 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Core.rbxm) |
| TweetingSim_Basic.rbxm | TweetingSim | 5 | non | Gadget / équipement, SurfaceGui/Billboard, 3x3x2 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Objects.rbxm) |
| TweetingSim_Bush.rbxm | TweetingSim | 6 | non | Gadget / équipement, SurfaceGui/Billboard, 2x2x2 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Objects.rbxm) |
| TweetingSim_Cloud.rbxm | TweetingSim | 4 | non | Gadget / équipement, SurfaceGui/Billboard, 2x3x3 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Objects.rbxm) |
| TweetingSim_EtherTank.rbxm | TweetingSim | 3 | non | Gadget / équipement, SurfaceGui/Billboard, 3x2x2 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Objects.rbxm) |
| TweetingSim_Expanded.rbxm | TweetingSim | 4 | non | Gadget / équipement, SurfaceGui/Billboard, 2x3x2 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Objects.rbxm) |
| TweetingSim_FireTriangle.rbxm | TweetingSim | 5 | non | Gadget / équipement, SurfaceGui/Billboard, 2x2x3 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Objects.rbxm) |
| TweetingSim_Gem.rbxm | TweetingSim | 4 | non | Gadget / équipement, SurfaceGui/Billboard, 2x3x2 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Objects.rbxm) |
| TweetingSim_Infinity.rbxm | TweetingSim | 4 | non | Gadget / équipement, SurfaceGui/Billboard, 2x4x4 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Objects.rbxm) |
| TweetingSim_Large.rbxm | TweetingSim | 4 | non | Gadget / équipement, SurfaceGui/Billboard, 2x2x2 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Objects.rbxm) |
| TweetingSim_LavaTank.rbxm | TweetingSim | 7 | non | Gadget / équipement, SurfaceGui/Billboard, 3x2x2 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Objects.rbxm) |
| TweetingSim_rAsyncEtherTank.rbxm | TweetingSim | 5 | non | Gadget / équipement, 1 particules/effets, SurfaceGui/Billboard, 2x3x3 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Objects.rbxm) |
| TweetingSim_rFloansVoidCrystal.rbxm | TweetingSim | 3 | non | Gadget / équipement, 1 particules/effets, SurfaceGui/Billboard, 3x3x2 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Objects.rbxm) |
| TweetingSim_Round.rbxm | TweetingSim | 5 | non | Gadget / équipement, SurfaceGui/Billboard, 2x2x2 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Objects.rbxm) |
| TweetingSim_rPhone.rbxm | TweetingSim | 3 | non | Gadget / équipement, Tool prêt à donner, 0x2x1 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Objects.rbxm) |
| TweetingSim_rPhoneS.rbxm | TweetingSim | 3 | non | Gadget / équipement, Tool prêt à donner, 0x2x1 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Objects.rbxm) |
| TweetingSim_rPhoneX.rbxm | TweetingSim | 3 | non | Gadget / équipement, Tool prêt à donner, 0x2x1 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Objects.rbxm) |
| TweetingSim_SnowTank.rbxm | TweetingSim | 7 | non | Gadget / équipement, SurfaceGui/Billboard, 3x2x2 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Objects.rbxm) |
| TweetingSim_TurtleShell.rbxm | TweetingSim | 5 | non | Gadget / équipement, SurfaceGui/Billboard, 2x3x3 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Objects.rbxm) |

## Accessories_Hats

Dossier `ByType/Accessories_Hats/` — 31 objets.

| Fichier | Jeu | Pièces | Scripts | Description |
|---|---|---|---|---|
| CashgrabBridge_clear1.rbxm | CashgrabBridge | 2 | oui (2) | Accessoire / chapeau, 8 particules/effets, SurfaceGui/Billboard, 4x0x4 studs (de CashgrabBridgeEU/Workspace/Hats1.rbxm) |
| CashgrabBridge_Hat12.rbxm | CashgrabBridge | 7 | oui (1) | Accessoire / chapeau, 6x4x4 studs (de CashgrabBridgeEU/Workspace/Hats1.rbxm) |
| CashgrabBridge_Hat13.rbxm | CashgrabBridge | 7 | oui (1) | Accessoire / chapeau, 6x5x4 studs (de CashgrabBridgeEU/Workspace/Hats1.rbxm) |
| CashgrabBridge_Hat14.rbxm | CashgrabBridge | 7 | oui (1) | Accessoire / chapeau, 6x4x4 studs (de CashgrabBridgeEU/Workspace/Hats1.rbxm) |
| CashgrabBridge_Hat15.rbxm | CashgrabBridge | 7 | oui (1) | Accessoire / chapeau, 6x4x4 studs (de CashgrabBridgeEU/Workspace/Hats1.rbxm) |
| CashgrabBridge_Hat21.rbxm | CashgrabBridge | 7 | oui (1) | Accessoire / chapeau, 6x4x4 studs (de CashgrabBridgeEU/Workspace/Dominus Hats.rbxm) |
| CashgrabBridge_Hat22.rbxm | CashgrabBridge | 7 | oui (1) | Accessoire / chapeau, 6x4x4 studs (de CashgrabBridgeEU/Workspace/Dominus Hats.rbxm) |
| CashgrabBridge_Hat23.rbxm | CashgrabBridge | 7 | oui (1) | Accessoire / chapeau, 6x4x4 studs (de CashgrabBridgeEU/Workspace/Dominus Hats.rbxm) |
| CashgrabBridge_Hat25.rbxm | CashgrabBridge | 7 | oui (1) | Accessoire / chapeau, 6x4x4 studs (de CashgrabBridgeEU/Workspace/Dominus Hats.rbxm) |
| CashgrabBridge_HatPath2.rbxm | CashgrabBridge | 4 | oui (2) | Accessoire / chapeau, 8 particules/effets, SurfaceGui/Billboard, 8x0x31 studs (de CashgrabBridgeEU/Workspace/Dominus Hats.rbxm) |
| GlassBridge_Hats.rbxm | GlassBridge | 16 | oui (15) | Accessoire / chapeau, 38x5x4 studs (de GlassBridge/Workspace/Hats.rbxm) |
| MagnetSim2_Bandana.rbxm | MagnetSim2 | 1 | non | Accessoire / chapeau, ancrage d’origine conservé, 2x1x1 studs (de UNCOPYLOCKED-Magnet-Simulator-2/Models.rbxm) |
| MagnetSim2_Bucket.rbxm | MagnetSim2 | 1 | non | Accessoire / chapeau, ancrage d’origine conservé, 2x2x2 studs (de UNCOPYLOCKED-Magnet-Simulator-2/Models.rbxm) |
| MagnetSim2_Clockworks.rbxm | MagnetSim2 | 1 | non | Accessoire / chapeau, ancrage d’origine conservé, 1x2x2 studs (de UNCOPYLOCKED-Magnet-Simulator-2/Models.rbxm) |
| MagnetSim2_Domino.rbxm | MagnetSim2 | 1 | non | Accessoire / chapeau, ancrage d’origine conservé, 2x1x1 studs (de UNCOPYLOCKED-Magnet-Simulator-2/Models.rbxm) |
| MagnetSim2_Dominus.rbxm | MagnetSim2 | 1 | non | Accessoire / chapeau, ancrage d’origine conservé, 2x2x2 studs (de UNCOPYLOCKED-Magnet-Simulator-2/Models.rbxm) |
| MagnetSim2_Fedora.rbxm | MagnetSim2 | 1 | non | Accessoire / chapeau, ancrage d’origine conservé, 1x1x1 studs (de UNCOPYLOCKED-Magnet-Simulator-2/Models.rbxm) |
| MagnetSim2_PirateHat.rbxm | MagnetSim2 | 1 | non | Accessoire / chapeau, ancrage d’origine conservé, 2x0x1 studs (de UNCOPYLOCKED-Magnet-Simulator-2/Models.rbxm) |
| MagnetSim2_RubberDuckie.rbxm | MagnetSim2 | 1 | non | Accessoire / chapeau, ancrage d’origine conservé, 1x2x1 studs (de UNCOPYLOCKED-Magnet-Simulator-2/Models.rbxm) |
| MagnetSim2_Tentacles.rbxm | MagnetSim2 | 1 | non | Accessoire / chapeau, ancrage d’origine conservé, 2x4x2 studs (de UNCOPYLOCKED-Magnet-Simulator-2/Models.rbxm) |
| MagnetSim2_TopHat.rbxm | MagnetSim2 | 1 | non | Accessoire / chapeau, ancrage d’origine conservé, 2x1x2 studs (de UNCOPYLOCKED-Magnet-Simulator-2/Models.rbxm) |
| MagnetSim2_TrafficCone.rbxm | MagnetSim2 | 1 | non | Accessoire / chapeau, ancrage d’origine conservé, 2x2x2 studs (de UNCOPYLOCKED-Magnet-Simulator-2/Models.rbxm) |
| MagnetSim2_Valkyrie.rbxm | MagnetSim2 | 1 | non | Accessoire / chapeau, ancrage d’origine conservé, 2x2x1 studs (de UNCOPYLOCKED-Magnet-Simulator-2/Models.rbxm) |
| PunchSim_DiamondSword.rbxm | PunchSim | 2 | non | Accessoire / chapeau, ancrage d’origine conservé, 4x4x2 studs (de Punch Simulator/Swords.rbxm) |
| PunchSim_DoubleLightsaber.rbxm | PunchSim | 20 | non | Accessoire / chapeau, 16 particules/effets, ancrage d’origine conservé, 1x3x2 studs (de Punch Simulator/Swords.rbxm) |
| PunchSim_DragonSword.rbxm | PunchSim | 2 | non | Accessoire / chapeau, ancrage d’origine conservé, 0x5x5 studs (de Punch Simulator/Swords.rbxm) |
| PunchSim_GreenLightsaber.rbxm | PunchSim | 19 | non | Accessoire / chapeau, 8 particules/effets, ancrage d’origine conservé, 1x2x2 studs (de Punch Simulator/Swords.rbxm) |
| PunchSim_PinkLightsaber.rbxm | PunchSim | 17 | non | Accessoire / chapeau, 8 particules/effets, ancrage d’origine conservé, 1x2x2 studs (de Punch Simulator/Swords.rbxm) |
| PunchSim_PrismaticStar.rbxm | PunchSim | 1 | oui (4) | Accessoire / chapeau, 18 particules/effets, ancrage d’origine conservé, 1x4x4 studs (de Punch Simulator/Swords.rbxm) |
| RobotSim_AdminGlider.rbxm | RobotSim | 4 | non | Accessoire / chapeau, 1 particules/effets, ancrage d’origine conservé, 6x4x4 studs (de Robot Simulator/ParachuteModels.rbxm) |
| RobotSim_DebugGlider.rbxm | RobotSim | 37 | non | Accessoire / chapeau, ancrage d’origine conservé, 20x12x10 studs (de Robot Simulator/OLD_THINGS.rbxm) |

## Machines_Upgraders

Dossier `ByType/Machines_Upgraders/` — 91 objets.

| Fichier | Jeu | Pièces | Scripts | Description |
|---|---|---|---|---|
| BakerySim_Alien.rbxm | BakerySim | 32 | non | Machine / upgrader, 1 particules/effets, SurfaceGui/Billboard, 5x6x7 studs (de Bakery-Simulator/Ovens.rbxm) |
| BakerySim_Aqua.rbxm | BakerySim | 24 | non | Machine / upgrader, SurfaceGui/Billboard, 6x4x4 studs (de Bakery-Simulator/Ovens.rbxm) |
| BakerySim_Banana.rbxm | BakerySim | 26 | non | Machine / upgrader, SurfaceGui/Billboard, 6x5x4 studs (de Bakery-Simulator/Ovens.rbxm) |
| BakerySim_BasicFirewood.rbxm | BakerySim | 43 | non | Machine / upgrader, 2 particules/effets, SurfaceGui/Billboard, 5x8x4 studs (de Bakery-Simulator/Ovens.rbxm) |
| BakerySim_BasicPropane.rbxm | BakerySim | 27 | non | Machine / upgrader, 2 particules/effets, SurfaceGui/Billboard, 6x5x4 studs (de Bakery-Simulator/Ovens.rbxm) |
| BakerySim_BiggerOven.rbxm | BakerySim | 25 | non | Machine / upgrader, SurfaceGui/Billboard, 13x9x8 studs (de Bakery-Simulator/Bigger Oven.rbxm) |
| BakerySim_bloooven.rbxm | BakerySim | 21 | non | Machine / upgrader, 2 particules/effets, SurfaceGui/Billboard, 6x4x4 studs (de Bakery-Simulator/bloo oven.rbxm) |
| BakerySim_BlueCube.rbxm | BakerySim | 23 | non | Machine / upgrader, SurfaceGui/Billboard, 6x5x4 studs (de Bakery-Simulator/Ovens.rbxm) |
| BakerySim_BlueStriped.rbxm | BakerySim | 6 | non | Machine / upgrader, 4x4x3 studs (de Bakery-Simulator/Carts.rbxm) |
| BakerySim_Brick.rbxm | BakerySim | 27 | non | Machine / upgrader, 3 particules/effets, SurfaceGui/Billboard, 6x6x4 studs (de Bakery-Simulator/Ovens.rbxm) |
| BakerySim_CauldronEvent.rbxm | BakerySim | 80 | oui (4) | Machine / upgrader, Humanoid, 1 particules/effets, SurfaceGui/Billboard, ancrage d’origine conservé, 21x12x26 studs (de Bakery-Simulator/CauldronEvent.rbxm) |
| BakerySim_Celestial.rbxm | BakerySim | 24 | non | Machine / upgrader, 2 particules/effets, SurfaceGui/Billboard, 5x8x7 studs (de Bakery-Simulator/Ovens.rbxm) |
| BakerySim_Cheese.rbxm | BakerySim | 27 | non | Machine / upgrader, 2 particules/effets, SurfaceGui/Billboard, 6x5x4 studs (de Bakery-Simulator/Ovens.rbxm) |
| BakerySim_ChromeFireplace.rbxm | BakerySim | 41 | non | Machine / upgrader, 2 particules/effets, SurfaceGui/Billboard, 5x8x4 studs (de Bakery-Simulator/Ovens.rbxm) |
| BakerySim_Cobblestone.rbxm | BakerySim | 27 | non | Machine / upgrader, 3 particules/effets, SurfaceGui/Billboard, 6x6x4 studs (de Bakery-Simulator/Ovens.rbxm) |
| BakerySim_Cursed.rbxm | BakerySim | 7 | non | Machine / upgrader, 1 particules/effets, 4x4x3 studs (de Bakery-Simulator/Carts.rbxm) |
| BakerySim_DefaultOven.rbxm | BakerySim | 24 | non | Machine / upgrader, SurfaceGui/Billboard, 6x4x4 studs (de Bakery-Simulator/Default Oven.rbxm) |
| BakerySim_Electric.rbxm | BakerySim | 29 | non | Machine / upgrader, 1 particules/effets, SurfaceGui/Billboard, 7x5x4 studs (de Bakery-Simulator/Ovens.rbxm) |
| BakerySim_Electrified.rbxm | BakerySim | 7 | non | Machine / upgrader, 1 particules/effets, 4x4x3 studs (de Bakery-Simulator/Carts.rbxm) |
| BakerySim_Explosive.rbxm | BakerySim | 27 | non | Machine / upgrader, 3 particules/effets, SurfaceGui/Billboard, 6x6x4 studs (de Bakery-Simulator/Ovens.rbxm) |
| BakerySim_Frosty.rbxm | BakerySim | 7 | non | Machine / upgrader, 1 particules/effets, 4x4x3 studs (de Bakery-Simulator/Carts.rbxm) |
| BakerySim_Gaming.rbxm | BakerySim | 26 | non | Machine / upgrader, SurfaceGui/Billboard, 6x4x4 studs (de Bakery-Simulator/Ovens.rbxm) |
| BakerySim_Glistening.rbxm | BakerySim | 7 | non | Machine / upgrader, 1 particules/effets, 4x4x3 studs (de Bakery-Simulator/Carts.rbxm) |
| BakerySim_Glitch.rbxm | BakerySim | 7 | non | Machine / upgrader, 1 particules/effets, 4x4x3 studs (de Bakery-Simulator/Carts.rbxm) |
| BakerySim_GreenStriped.rbxm | BakerySim | 6 | non | Machine / upgrader, 4x4x3 studs (de Bakery-Simulator/Carts.rbxm) |
| BakerySim_Hacker.rbxm | BakerySim | 29 | non | Machine / upgrader, 4 particules/effets, SurfaceGui/Billboard, 7x5x4 studs (de Bakery-Simulator/Ovens.rbxm) |
| BakerySim_Heart.rbxm | BakerySim | 27 | non | Machine / upgrader, 1 particules/effets, SurfaceGui/Billboard, 5x5x4 studs (de Bakery-Simulator/Ovens.rbxm) |
| BakerySim_Honey.rbxm | BakerySim | 26 | non | Machine / upgrader, SurfaceGui/Billboard, 6x6x4 studs (de Bakery-Simulator/Ovens.rbxm) |
| BakerySim_Ice.rbxm | BakerySim | 24 | non | Machine / upgrader, 2 particules/effets, SurfaceGui/Billboard, 6x4x4 studs (de Bakery-Simulator/Ovens.rbxm) |
| BakerySim_Lego.rbxm | BakerySim | 27 | non | Machine / upgrader, SurfaceGui/Billboard, 6x5x4 studs (de Bakery-Simulator/Ovens.rbxm) |
| BakerySim_Lemon.rbxm | BakerySim | 24 | non | Machine / upgrader, SurfaceGui/Billboard, 6x4x4 studs (de Bakery-Simulator/Ovens.rbxm) |
| BakerySim_Lines.rbxm | BakerySim | 27 | non | Machine / upgrader, 3 particules/effets, SurfaceGui/Billboard, 6x6x4 studs (de Bakery-Simulator/Ovens.rbxm) |
| BakerySim_Mars.rbxm | BakerySim | 29 | non | Machine / upgrader, 2 particules/effets, SurfaceGui/Billboard, 5x6x4 studs (de Bakery-Simulator/Ovens.rbxm) |
| BakerySim_Matrix.rbxm | BakerySim | 6 | non | Machine / upgrader, 4x4x3 studs (de Bakery-Simulator/Carts.rbxm) |
| BakerySim_Melon.rbxm | BakerySim | 27 | non | Machine / upgrader, SurfaceGui/Billboard, 6x5x4 studs (de Bakery-Simulator/Ovens.rbxm) |
| BakerySim_Military.rbxm | BakerySim | 27 | non | Machine / upgrader, 2 particules/effets, SurfaceGui/Billboard, 6x5x4 studs (de Bakery-Simulator/Ovens.rbxm) |
| BakerySim_Molten.rbxm | BakerySim | 7 | non | Machine / upgrader, 1 particules/effets, 4x4x3 studs (de Bakery-Simulator/Carts.rbxm) |
| BakerySim_OrangeCamo.rbxm | BakerySim | 24 | non | Machine / upgrader, SurfaceGui/Billboard, 6x4x4 studs (de Bakery-Simulator/Ovens.rbxm) |
| BakerySim_OvensGold.rbxm | BakerySim | 26 | non | Machine / upgrader, SurfaceGui/Billboard, 5x5x4 studs (de Bakery-Simulator/Ovens.rbxm) |
| BakerySim_Overgrown.rbxm | BakerySim | 28 | non | Machine / upgrader, SurfaceGui/Billboard, 6x6x4 studs (de Bakery-Simulator/Ovens.rbxm) |
| BakerySim_Pink.rbxm | BakerySim | 6 | non | Machine / upgrader, 4x4x3 studs (de Bakery-Simulator/Carts.rbxm) |
| BakerySim_PinkPropane.rbxm | BakerySim | 27 | non | Machine / upgrader, 2 particules/effets, SurfaceGui/Billboard, 6x5x4 studs (de Bakery-Simulator/Ovens.rbxm) |
| BakerySim_Plate.rbxm | BakerySim | 24 | non | Machine / upgrader, SurfaceGui/Billboard, 6x4x4 studs (de Bakery-Simulator/Ovens.rbxm) |
| BakerySim_Pumpkin.rbxm | BakerySim | 25 | non | Machine / upgrader, SurfaceGui/Billboard, 4x6x6 studs (de Bakery-Simulator/Ovens.rbxm) |
| BakerySim_PurpleCamo.rbxm | BakerySim | 23 | non | Machine / upgrader, SurfaceGui/Billboard, 6x5x4 studs (de Bakery-Simulator/Ovens.rbxm) |
| BakerySim_RedCube.rbxm | BakerySim | 24 | non | Machine / upgrader, SurfaceGui/Billboard, 6x4x4 studs (de Bakery-Simulator/Ovens.rbxm) |
| BakerySim_RedStriped.rbxm | BakerySim | 6 | non | Machine / upgrader, 4x4x3 studs (de Bakery-Simulator/Carts.rbxm) |
| BakerySim_Retro.rbxm | BakerySim | 24 | non | Machine / upgrader, SurfaceGui/Billboard, 5x4x4 studs (de Bakery-Simulator/Ovens.rbxm) |
| BakerySim_Shelves_Model.rbxm | BakerySim | 18 | non | Machine / upgrader, 16x4x4 studs (de Bakery-Simulator/Shelves.rbxm) |
| BakerySim_Shelves_Model_2.rbxm | BakerySim | 19 | non | Machine / upgrader, 16x4x4 studs (de Bakery-Simulator/Shelves.rbxm) |
| BakerySim_Shelves_Model_3.rbxm | BakerySim | 22 | non | Machine / upgrader, 16x4x4 studs (de Bakery-Simulator/Shelves.rbxm) |
| BakerySim_Shelves_Model_4.rbxm | BakerySim | 16 | non | Machine / upgrader, 2 particules/effets, 15x4x3 studs (de Bakery-Simulator/Shelves.rbxm) |
| BakerySim_Shelves_Model_5.rbxm | BakerySim | 5 | non | Machine / upgrader, 15x3x5 studs (de Bakery-Simulator/Shelves.rbxm) |
| BakerySim_Shelves_Model_6.rbxm | BakerySim | 11 | non | Machine / upgrader, 16x4x4 studs (de Bakery-Simulator/Shelves.rbxm) |
| BakerySim_Shelves_Model_7.rbxm | BakerySim | 20 | non | Machine / upgrader, 13x5x4 studs (de Bakery-Simulator/Shelves.rbxm) |
| BakerySim_SilentStudios.rbxm | BakerySim | 20 | non | Machine / upgrader, 1 particules/effets, SurfaceGui/Billboard, 6x5x4 studs (de Bakery-Simulator/Ovens.rbxm) |
| BakerySim_Spooky.rbxm | BakerySim | 29 | non | Machine / upgrader, 1 particules/effets, SurfaceGui/Billboard, 7x5x4 studs (de Bakery-Simulator/Ovens.rbxm) |
| BakerySim_Sprinkle.rbxm | BakerySim | 29 | non | Machine / upgrader, 1 particules/effets, SurfaceGui/Billboard, 7x5x4 studs (de Bakery-Simulator/Ovens.rbxm) |
| BakerySim_Starter.rbxm | BakerySim | 24 | non | Machine / upgrader, SurfaceGui/Billboard, 4x4x6 studs (de Bakery-Simulator/Ovens.rbxm) |
| BakerySim_Steel.rbxm | BakerySim | 6 | non | Machine / upgrader, 4x4x3 studs (de Bakery-Simulator/Carts.rbxm) |
| BakerySim_Stone.rbxm | BakerySim | 21 | non | Machine / upgrader, SurfaceGui/Billboard, 6x4x4 studs (de Bakery-Simulator/Ovens.rbxm) |
| BakerySim_Sunshine.rbxm | BakerySim | 7 | non | Machine / upgrader, 2 particules/effets, 4x4x3 studs (de Bakery-Simulator/Carts.rbxm) |
| BakerySim_Tree.rbxm | BakerySim | 24 | non | Machine / upgrader, SurfaceGui/Billboard, 5x4x4 studs (de Bakery-Simulator/Ovens.rbxm) |
| BakerySim_XLBasic.rbxm | BakerySim | 25 | non | Machine / upgrader, SurfaceGui/Billboard, 13x9x8 studs (de Bakery-Simulator/Ovens.rbxm) |
| BakerySim_XLBasicFirewood.rbxm | BakerySim | 44 | non | Machine / upgrader, 2 particules/effets, SurfaceGui/Billboard, 13x16x10 studs (de Bakery-Simulator/Ovens.rbxm) |
| BakerySim_XLBasicPropane.rbxm | BakerySim | 28 | non | Machine / upgrader, 2 particules/effets, SurfaceGui/Billboard, 12x10x8 studs (de Bakery-Simulator/Ovens.rbxm) |
| BakerySim_XLCheese.rbxm | BakerySim | 28 | non | Machine / upgrader, 2 particules/effets, SurfaceGui/Billboard, 12x10x8 studs (de Bakery-Simulator/Ovens.rbxm) |
| BakerySim_XLCobblestone.rbxm | BakerySim | 28 | non | Machine / upgrader, 3 particules/effets, SurfaceGui/Billboard, 11x12x8 studs (de Bakery-Simulator/Ovens.rbxm) |
| BakerySim_XLCube.rbxm | BakerySim | 25 | non | Machine / upgrader, SurfaceGui/Billboard, 13x9x8 studs (de Bakery-Simulator/Ovens.rbxm) |
| BakerySim_XLExplosive.rbxm | BakerySim | 28 | non | Machine / upgrader, 3 particules/effets, SurfaceGui/Billboard, 11x12x8 studs (de Bakery-Simulator/Ovens.rbxm) |
| BakerySim_XLGold.rbxm | BakerySim | 27 | non | Machine / upgrader, SurfaceGui/Billboard, 11x10x8 studs (de Bakery-Simulator/Ovens.rbxm) |
| BakerySim_XLHacker.rbxm | BakerySim | 30 | non | Machine / upgrader, 4 particules/effets, SurfaceGui/Billboard, 13x10x8 studs (de Bakery-Simulator/Ovens.rbxm) |
| BakerySim_XLHeart.rbxm | BakerySim | 28 | non | Machine / upgrader, 1 particules/effets, SurfaceGui/Billboard, 11x9x8 studs (de Bakery-Simulator/Ovens.rbxm) |
| BakerySim_XLIce.rbxm | BakerySim | 25 | non | Machine / upgrader, 3 particules/effets, SurfaceGui/Billboard, 13x9x8 studs (de Bakery-Simulator/Ovens.rbxm) |
| BakerySim_XLMelon.rbxm | BakerySim | 28 | non | Machine / upgrader, SurfaceGui/Billboard, 13x10x8 studs (de Bakery-Simulator/Ovens.rbxm) |
| BakerySim_XLMetallic.rbxm | BakerySim | 30 | non | Machine / upgrader, 1 particules/effets, SurfaceGui/Billboard, 14x10x8 studs (de Bakery-Simulator/Ovens.rbxm) |
| BakerySim_XLMilitary.rbxm | BakerySim | 28 | non | Machine / upgrader, 2 particules/effets, SurfaceGui/Billboard, 12x11x8 studs (de Bakery-Simulator/Ovens.rbxm) |
| BakerySim_XLOld.rbxm | BakerySim | 24 | non | Machine / upgrader, SurfaceGui/Billboard, 12x10x8 studs (de Bakery-Simulator/Ovens.rbxm) |
| BakerySim_XLOrangeCamo.rbxm | BakerySim | 25 | non | Machine / upgrader, SurfaceGui/Billboard, 12x8x8 studs (de Bakery-Simulator/Ovens.rbxm) |
| BakerySim_XLPinkPropane.rbxm | BakerySim | 28 | non | Machine / upgrader, 2 particules/effets, SurfaceGui/Billboard, 12x11x8 studs (de Bakery-Simulator/Ovens.rbxm) |
| BakerySim_XLPlate.rbxm | BakerySim | 25 | non | Machine / upgrader, SurfaceGui/Billboard, 13x9x8 studs (de Bakery-Simulator/Ovens.rbxm) |
| BakerySim_XLRetro.rbxm | BakerySim | 25 | non | Machine / upgrader, SurfaceGui/Billboard, 11x9x8 studs (de Bakery-Simulator/Ovens.rbxm) |
| BakerySim_XLSpooky.rbxm | BakerySim | 30 | non | Machine / upgrader, 1 particules/effets, SurfaceGui/Billboard, 13x10x8 studs (de Bakery-Simulator/Ovens.rbxm) |
| BakerySim_XLSprinkle.rbxm | BakerySim | 30 | non | Machine / upgrader, 1 particules/effets, SurfaceGui/Billboard, 13x10x8 studs (de Bakery-Simulator/Ovens.rbxm) |
| BakerySim_YellowStriped.rbxm | BakerySim | 6 | non | Machine / upgrader, 4x4x3 studs (de Bakery-Simulator/Carts.rbxm) |
| BakerySim_ZebraFirewood.rbxm | BakerySim | 41 | non | Machine / upgrader, 2 particules/effets, SurfaceGui/Billboard, 5x8x4 studs (de Bakery-Simulator/Ovens.rbxm) |
| Lib_UpgradeMachine.rbxm | Lib | 31 | non | Machine / upgrader, 8 particules/effets, SurfaceGui/Billboard, 40x27x37 studs (de Machines/UpgradeMachine.rbxm) |
| PunchSim_Crafting.rbxm | PunchSim | 11 | non | Machine / upgrader, SurfaceGui/Billboard, 33x21x38 studs (de Punch Simulator/Crafting.rbxm) |
| PunchSim_Rebirth.rbxm | PunchSim | 3 | non | Machine / upgrader, 21 particules/effets, 1x5x5 studs (de Punch Simulator/Assets.rbxm) |
| PunchSim_Upgrademachine.rbxm | PunchSim | 10 | non | Machine / upgrader, 28x13x23 studs (de Punch Simulator/Upgrade machine.rbxm) |
| RebirthChampionsX_PetMachine.rbxm | RebirthChampionsX | 38 | non | Machine / upgrader, 17 particules/effets, SurfaceGui/Billboard, ancrage d’origine conservé, 21x17x21 studs (de Rebirth Champions X/Workspace/Scripts.rbxm) |

## Shops_Stands

Dossier `ByType/Shops_Stands/` — 59 objets.

| Fichier | Jeu | Pièces | Scripts | Description |
|---|---|---|---|---|
| 1JumpEverySecond_MorphGivers.rbxm | 1JumpEverySecond | 37 | oui (5) | Stand / boutique, Humanoid, prompt/clic, ancrage d’origine conservé, 6x7x24 studs (de 1JumpEverySecond/Workspace/MorphGivers.rbxm) |
| 1JumpEverySecond_PackageGivers_Model.rbxm | 1JumpEverySecond | 10 | oui (1) | Stand / boutique, 6x8x6 studs (de 1JumpEverySecond/Workspace/Package Givers.rbxm) |
| 1JumpEverySecond_SuperbizCatalogModel.rbxm | 1JumpEverySecond | 10 | oui (2) | Stand / boutique, prompt/clic, SurfaceGui/Billboard, 9x8x9 studs (de 1JumpEverySecond/Workspace/SuperbizCatalogModel.rbxm) |
| BakerySim_LimitedTimeSale.rbxm | BakerySim | 21 | non | Stand / boutique, SurfaceGui/Billboard, 5x17x13 studs (de Bakery-Simulator/Workspace/LimitedTimeSale.rbxm) |
| BakerySim_ShopBackground.rbxm | BakerySim | 74 | non | Stand / boutique, 27x18x852 studs (de Bakery-Simulator/ShopBackground.rbxm) |
| BillionaireTycoon_VIPGiver1.rbxm | BillionaireTycoon | 58 | oui (1) | Stand / boutique, 4 particules/effets, 10x13x4 studs (de Billionaire_Tycoon/Workspace/VIPGiver1.rbxm) |
| BillionaireTycoon_VIPGiver2.rbxm | BillionaireTycoon | 14 | oui (1) | Stand / boutique, 5x6x4 studs (de Billionaire_Tycoon/Workspace/VIPGiver2.rbxm) |
| CashgrabBridge_LightningParticleGiver.rbxm | CashgrabBridge | 7 | oui (1) | Stand / boutique, 1 particules/effets, 9x9x9 studs (de CashgrabBridgeEU/Workspace/LightningParticleGiver.rbxm) |
| CashgrabBridge_PetShop.rbxm | CashgrabBridge | 26 | oui (1) | Stand / boutique, Humanoid, SurfaceGui/Billboard, ancrage d’origine conservé, 16x6x16 studs (de CashgrabBridgeEU/Workspace/PetShop.rbxm) |
| CashgrabBridge_RewardChest.rbxm | CashgrabBridge | 11 | oui (1) | Stand / boutique, SurfaceGui/Billboard, 42x24x35 studs (de CashgrabBridgeEU/Workspace/RewardChest.rbxm) |
| CashgrabBridge_ToyShop.rbxm | CashgrabBridge | 80 | oui (2) | Stand / boutique, Humanoid, prompt/clic, SurfaceGui/Billboard, ancrage d’origine conservé, 11x6x11 studs (de CashgrabBridgeEU/Workspace/Shop2.rbxm) |
| FirstDonations_Map.rbxm | FirstDonations | 105 | non | Stand / boutique, 14 particules/effets, 389x183x640 studs (de First_Donations/Workspace/OfflineDonation.rbxm) |
| FirstDonations_MonedaRobux.rbxm | FirstDonations | 1 | non | Stand / boutique, 18x19x2 studs (de First_Donations/Workspace/Party.rbxm) |
| FirstDonations_OfflineDono.rbxm | FirstDonations | 35 | oui (5) | Stand / boutique, 3 particules/effets, prompt/clic, SurfaceGui/Billboard, 7x17x12 studs (de First_Donations/Workspace/OfflineDonation.rbxm) |
| FirstDonations_Sale.rbxm | FirstDonations | 13 | oui (3) | Stand / boutique, Humanoid, prompt/clic, ancrage d’origine conservé, 4x6x5 studs (de First_Donations/Workspace/TIENDA.rbxm) |
| FirstDonations_Stands_12.rbxm | FirstDonations | 20 | oui (6) | Stand / boutique, 12 particules/effets, prompt/clic, SurfaceGui/Billboard, 8x14x8 studs (de First_Donations/Workspace/Stands.rbxm) |
| FirstDonations_StandShop.rbxm | FirstDonations | 417 | non | Stand / boutique, SurfaceGui/Billboard, 232x57x232 studs (de First_Donations/Workspace/Shop.rbxm) |
| GlassBridge_GamepassStands.rbxm | GlassBridge | 70 | oui (29) | Stand / boutique, 1 particules/effets, prompt/clic, SurfaceGui/Billboard, 300x7x84 studs (de GlassBridge/Workspace/GamepassStands.rbxm) |
| GlassBridge_Morph.rbxm | GlassBridge | 18 | oui (3) | Stand / boutique, Humanoid, ancrage d’origine conservé, 7x5x4 studs (de GlassBridge/Workspace/Morphs.rbxm) |
| GlassBridge_Morph_2.rbxm | GlassBridge | 10 | oui (3) | Stand / boutique, Humanoid, ancrage d’origine conservé, 8x6x4 studs (de GlassBridge/Workspace/Morphs.rbxm) |
| GlassBridge_Morph_3.rbxm | GlassBridge | 19 | oui (3) | Stand / boutique, Humanoid, ancrage d’origine conservé, 8x6x4 studs (de GlassBridge/Workspace/Morphs.rbxm) |
| GlassBridge_Morph_4.rbxm | GlassBridge | 9 | oui (3) | Stand / boutique, Humanoid, ancrage d’origine conservé, 9x7x4 studs (de GlassBridge/Workspace/Morphs.rbxm) |
| GlassBridge_Morph_5.rbxm | GlassBridge | 23 | oui (3) | Stand / boutique, Humanoid, ancrage d’origine conservé, 7x5x4 studs (de GlassBridge/Workspace/Morphs.rbxm) |
| GlassBridge_Morph_6.rbxm | GlassBridge | 11 | oui (3) | Stand / boutique, Humanoid, ancrage d’origine conservé, 8x5x4 studs (de GlassBridge/Workspace/Morphs.rbxm) |
| HatchingSim_FrostShop.rbxm | HatchingSim | 31 | non | Stand / boutique, SurfaceGui/Billboard, 43x38x69 studs (de HatchingSimulator/Workspace/World.rbxm) |
| HatchingSim_GummyShop.rbxm | HatchingSim | 31 | non | Stand / boutique, SurfaceGui/Billboard, 31x38x67 studs (de HatchingSimulator/Workspace/World.rbxm) |
| HatchingSim_MarsShop.rbxm | HatchingSim | 31 | non | Stand / boutique, SurfaceGui/Billboard, 40x38x71 studs (de HatchingSimulator/Workspace/World.rbxm) |
| HatchingSim_Shop.rbxm | HatchingSim | 31 | non | Stand / boutique, SurfaceGui/Billboard, 27x33x59 studs (de HatchingSimulator/Workspace/World.rbxm) |
| HatchingSim_SpaceShop.rbxm | HatchingSim | 31 | non | Stand / boutique, SurfaceGui/Billboard, 43x38x69 studs (de HatchingSimulator/Workspace/World.rbxm) |
| MiningMasters_AlreadyPro.rbxm | MiningMasters | 10 | non | Stand / boutique, Humanoid, ancrage d’origine conservé, 4x6x3 studs (de Mining-Masters/Workspace/AlreadyPro.rbxm) |
| MiningMasters_RobuxStand.rbxm | MiningMasters | 8 | oui (1) | Stand / boutique, SurfaceGui/Billboard, 12x11x13 studs (de Mining-Masters/Workspace/RobuxStand.rbxm) |
| MiningMasters_VIPZone.rbxm | MiningMasters | 13 | non | Stand / boutique, 99x90x117 studs (de Mining-Masters/Workspace/World1.rbxm) |
| PetPharmica_PetShopPart.rbxm | PetPharmica | 57 | non | Stand / boutique, 3 particules/effets, SurfaceGui/Billboard, 37x27x31 studs (de Pet_Pharmica_1_1/Workspace/TouchParts.rbxm) |
| PetPharmica_Shop.rbxm | PetPharmica | 266 | non | Stand / boutique, 202x45x199 studs (de Pet_Pharmica_1_1/Workspace/Areas.rbxm) |
| PunchSim_Upgrades.rbxm | PunchSim | 11 | non | Stand / boutique, SurfaceGui/Billboard, 46x21x47 studs (de Punch Simulator/Workspace/__MAP.rbxm) |
| RebirthChampionsX_DailySpin.rbxm | RebirthChampionsX | 7 | non | Stand / boutique, prompt/clic, SurfaceGui/Billboard, 5x16x12 studs (de Rebirth Champions X/Workspace/Scripts.rbxm) |
| RebirthChampionsX_EasterShop.rbxm | RebirthChampionsX | 3 | non | Stand / boutique, SurfaceGui/Billboard, 18x1x18 studs (de Rebirth Champions X/Workspace/Scripts.rbxm) |
| RebirthChampionsX_Potions.rbxm | RebirthChampionsX | 3 | non | Stand / boutique, SurfaceGui/Billboard, 21x1x21 studs (de Rebirth Champions X/Workspace/Scripts.rbxm) |
| RebirthChampionsX_Shop.rbxm | RebirthChampionsX | 3 | non | Stand / boutique, SurfaceGui/Billboard, 23x1x23 studs (de Rebirth Champions X/Workspace/Scripts.rbxm) |
| RebirthChampionsX_Upgrades.rbxm | RebirthChampionsX | 3 | non | Stand / boutique, SurfaceGui/Billboard, 24x1x24 studs (de Rebirth Champions X/Workspace/Scripts.rbxm) |
| RobotSim_2xCoins.rbxm | RobotSim | 18 | non | Stand / boutique, 2 particules/effets, SurfaceGui/Billboard, 2x11x13 studs (de Robot Simulator/GamepassSIgnsClone.rbxm) |
| RobotSim_PremiumIsland.rbxm | RobotSim | 173 | non | Stand / boutique, 359x408x360 studs (de Robot Simulator/Workspace/Premium Island.rbxm) |
| RobotSim_Sell-Premium.rbxm | RobotSim | 3 | non | Stand / boutique, SurfaceGui/Billboard, 35x2x30 studs (de Robot Simulator/Workspace/Sells.rbxm) |
| RobotSim_Sell-Spawn.rbxm | RobotSim | 30 | non | Stand / boutique, SurfaceGui/Billboard, 35x8x35 studs (de Robot Simulator/Workspace/Sells.rbxm) |
| RobotSim_Shop.rbxm | RobotSim | 234 | non | Stand / boutique, 32x34x39 studs (de Robot Simulator/Workspace/Map.rbxm) |
| RobotSim_VIPIsland.rbxm | RobotSim | 175 | non | Stand / boutique, 384x408x351 studs (de Robot Simulator/Workspace/VIP Island.rbxm) |
| ShootABrainrot_SellShop.rbxm | ShootABrainrot | 25 | non | Stand / boutique, 14x10x9 studs (de ShootABrainrotEU/Workspace/Main.rbxm) |
| TappingLords_DailyReward.rbxm | TappingLords | 12 | non | Stand / boutique, SurfaceGui/Billboard, 22x3x23 studs (de Tapping-Lords-Simulator/Workspace/DailyReward.rbxm) |
| TappingLords_PetShop.rbxm | TappingLords | 12 | non | Stand / boutique, SurfaceGui/Billboard, 24x11x24 studs (de Tapping-Lords-Simulator/Workspace/PetShop.rbxm) |
| TappingLords_Potions.rbxm | TappingLords | 12 | non | Stand / boutique, SurfaceGui/Billboard, 36x7x36 studs (de Tapping-Lords-Simulator/Workspace/Potions.rbxm) |
| TappingLords_ShopA.rbxm | TappingLords | 12 | non | Stand / boutique, SurfaceGui/Billboard, 23x11x24 studs (de Tapping-Lords-Simulator/Workspace/ShopA.rbxm) |
| TappingLords_StarUpgrades.rbxm | TappingLords | 12 | non | Stand / boutique, SurfaceGui/Billboard, 20x11x22 studs (de Tapping-Lords-Simulator/Workspace/StarUpgrades.rbxm) |
| TweetingSim_BeamShop.rbxm | TweetingSim | 6 | non | Stand / boutique, 79x89x23 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Core.rbxm) |
| TweetingSim_CostumeShop.rbxm | TweetingSim | 17 | non | Stand / boutique, 33x76x67 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Core.rbxm) |
| TweetingSim_Desks.rbxm | TweetingSim | 12 | non | Stand / boutique, 19x2x40 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Core.rbxm) |
| TweetingSim_LaptopShop.rbxm | TweetingSim | 61 | non | Stand / boutique, 2 particules/effets, 51x17x37 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Core.rbxm) |
| TweetingSim_PhoneShop.rbxm | TweetingSim | 116 | non | Stand / boutique, 6 particules/effets, 65x68x66 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Core.rbxm) |
| TweetingSim_StorageShop.rbxm | TweetingSim | 72 | non | Stand / boutique, 81x32x195 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Core.rbxm) |
| TweetingSim_StorageShop_2.rbxm | TweetingSim | 59 | non | Stand / boutique, 59x282x301 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Core.rbxm) |

## Conveyors_Tycoon

Dossier `ByType/Conveyors_Tycoon/` — 3 objets.

| Fichier | Jeu | Pièces | Scripts | Description |
|---|---|---|---|---|
| BakerySim_ConveyorBelt.rbxm | BakerySim | 30 | oui (1) | Élément tycoon, 102x2x23 studs (de Bakery-Simulator/Workspace/ConveyorBelt.rbxm) |
| BillionaireTycoon_ZednovsTycoonKit.rbxm | BillionaireTycoon | 16604 | oui (562) | Élément tycoon, Humanoid, 76 particules/effets, prompt/clic, SurfaceGui/Billboard, ancrage d’origine conservé, 12 script(s) dangereux retiré(s), 446x38x373 studs (de Billionaire_Tycoon/Workspace/Zednovs Tycoon Kit.rbxm) |
| RobotSim_CityTycoonIsland.rbxm | RobotSim | 233 | non | Élément tycoon, 576x268x548 studs (de Robot Simulator/Workspace/CityTycoonIsland.rbxm) |

## Plots_Bases

Dossier `ByType/Plots_Bases/` — 11 objets.

| Fichier | Jeu | Pièces | Scripts | Description |
|---|---|---|---|---|
| BakerySim_Plot1.rbxm | BakerySim | 61 | non | Plot / base / pad, SurfaceGui/Billboard, 48x24x29 studs (de Bakery-Simulator/Workspace/Plots.rbxm) |
| BakerySim_Plot2.rbxm | BakerySim | 61 | non | Plot / base / pad, SurfaceGui/Billboard, 48x24x29 studs (de Bakery-Simulator/Workspace/Plots.rbxm) |
| GlassBridge_HelicopterPad.rbxm | GlassBridge | 94 | non | Plot / base / pad, 32x3x32 studs (de GlassBridge/Workspace/Helicopter Pad.rbxm) |
| RebirthChampionsX_SpawnLocations.rbxm | RebirthChampionsX | 8 | non | Plot / base / pad, 87x0x87 studs (de Rebirth Champions X/Workspace/Scripts.rbxm) |
| RobotSim_GemBoost1.rbxm | RobotSim | 50 | non | Plot / base / pad, Humanoid, 2 particules/effets, SurfaceGui/Billboard, ancrage d’origine conservé, 28x54x35 studs (de Robot Simulator/Workspace/GemBoostPads.rbxm) |
| RobotSim_JumpingPads.rbxm | RobotSim | 25 | non | Plot / base / pad, 28x11x30 studs (de Robot Simulator/Workspace/Map.rbxm) |
| RobotSim_Large.rbxm | RobotSim | 2 | non | Plot / base / pad, 16x0x16 studs (de Robot Simulator/Workspace/JumpPads.rbxm) |
| RobotSim_Large_2.rbxm | RobotSim | 6 | non | Plot / base / pad, 4 particules/effets, 18x3x18 studs (de Robot Simulator/Workspace/JumpPads.rbxm) |
| RobotSim_Pad.rbxm | RobotSim | 2 | non | Plot / base / pad, 28x0x28 studs (de Robot Simulator/Workspace/KingOfTheRobots.rbxm) |
| RobotSim_Small.rbxm | RobotSim | 2 | non | Plot / base / pad, 11x0x12 studs (de Robot Simulator/Workspace/JumpPads.rbxm) |
| ShootABrainrot_Plot6.rbxm | ShootABrainrot | 34 | non | Plot / base / pad, SurfaceGui/Billboard, 55x62x52 studs (de ShootABrainrotEU/Workspace/Main.rbxm) |

## Portals_Teleports

Dossier `ByType/Portals_Teleports/` — 55 objets.

| Fichier | Jeu | Pièces | Scripts | Description |
|---|---|---|---|---|
| FirstDonations_PortalParty.rbxm | FirstDonations | 4 | oui (2) | Portail / téléporteur, prompt/clic, 33x25x33 studs (de First_Donations/Workspace/Party.rbxm) |
| FirstDonations_TeleportParty.rbxm | FirstDonations | 30 | oui (1) | Portail / téléporteur, 287x335x287 studs (de First_Donations/Workspace/Party.rbxm) |
| GlassBridge_BackPortal.rbxm | GlassBridge | 16 | oui (1) | Portail / téléporteur, SurfaceGui/Billboard, 11x11x3 studs (de GlassBridge/Workspace/BackPortal.rbxm) |
| GlassBridge_Portal.rbxm | GlassBridge | 16 | oui (1) | Portail / téléporteur, SurfaceGui/Billboard, 14x14x4 studs (de GlassBridge/Workspace/Portal.rbxm) |
| MagnetSim2_Grass1.rbxm | MagnetSim2 | 2 | non | Portail / téléporteur, 2x15x10 studs (de UNCOPYLOCKED-Magnet-Simulator-2/Workspace/Portals.rbxm) |
| MagnetSim2_Ice1.rbxm | MagnetSim2 | 2 | non | Portail / téléporteur, 2x15x10 studs (de UNCOPYLOCKED-Magnet-Simulator-2/Workspace/Portals.rbxm) |
| MagnetSim2_Sand1.rbxm | MagnetSim2 | 2 | non | Portail / téléporteur, 2x15x10 studs (de UNCOPYLOCKED-Magnet-Simulator-2/Workspace/Portals.rbxm) |
| MiningMasters_TeleportParts.rbxm | MiningMasters | 10 | non | Portail / téléporteur, 598x7x2387 studs (de Mining-Masters/Workspace/TeleportParts.rbxm) |
| PetPharmica_1kPortal.rbxm | PetPharmica | 2 | non | Portail / téléporteur, 27x21x27 studs (de Pet_Pharmica_1_1/Workspace/Areas.rbxm) |
| PunchSim_MainPortalTemplate.rbxm | PunchSim | 45 | oui (3) | Portail / téléporteur, 5 particules/effets, 16x22x11 studs (de Punch Simulator/Workspace/Main Portal Template.rbxm) |
| PunchSim_Nuclear.rbxm | PunchSim | 5 | non | Portail / téléporteur, SurfaceGui/Billboard, 26x22x32 studs (de Punch Simulator/Workspace/__MAP.rbxm) |
| PunchSim_Spawn.rbxm | PunchSim | 4 | non | Portail / téléporteur, SurfaceGui/Billboard, 63x41x62 studs (de Punch Simulator/Workspace/__MAP.rbxm) |
| PunchSim_Spawn_2.rbxm | PunchSim | 12 | non | Portail / téléporteur, SurfaceGui/Billboard, 55x35x53 studs (de Punch Simulator/Workspace/__MAP.rbxm) |
| RebirthChampionsX_Beach.rbxm | RebirthChampionsX | 4 | non | Portail / téléporteur, SurfaceGui/Billboard, 8x14x11 studs (de Rebirth Champions X/Workspace/Scripts.rbxm) |
| RebirthChampionsX_BlackExitFade.rbxm | RebirthChampionsX | 16 | non | Portail / téléporteur, 182x24x94 studs (de Rebirth Champions X/Workspace/Maps.rbxm) |
| RebirthChampionsX_Cave.rbxm | RebirthChampionsX | 4 | non | Portail / téléporteur, SurfaceGui/Billboard, 12x14x6 studs (de Rebirth Champions X/Workspace/Scripts.rbxm) |
| RebirthChampionsX_Cube.rbxm | RebirthChampionsX | 4 | non | Portail / téléporteur, 9x13x10 studs (de Rebirth Champions X/Workspace/Scripts.rbxm) |
| RebirthChampionsX_Cyber.rbxm | RebirthChampionsX | 4 | non | Portail / téléporteur, SurfaceGui/Billboard, 9x14x10 studs (de Rebirth Champions X/Workspace/Scripts.rbxm) |
| RebirthChampionsX_Desert.rbxm | RebirthChampionsX | 4 | non | Portail / téléporteur, SurfaceGui/Billboard, 12x14x6 studs (de Rebirth Champions X/Workspace/Scripts.rbxm) |
| RebirthChampionsX_Easter.rbxm | RebirthChampionsX | 3 | non | Portail / téléporteur, SurfaceGui/Billboard, 14x17x4 studs (de Rebirth Champions X/Workspace/Scripts.rbxm) |
| RebirthChampionsX_Easterportal.rbxm | RebirthChampionsX | 14 | non | Portail / téléporteur, 33x27x50 studs (de Rebirth Champions X/Workspace/Maps.rbxm) |
| RebirthChampionsX_Magic.rbxm | RebirthChampionsX | 4 | non | Portail / téléporteur, SurfaceGui/Billboard, 6x14x12 studs (de Rebirth Champions X/Workspace/Scripts.rbxm) |
| RebirthChampionsX_Moon.rbxm | RebirthChampionsX | 4 | non | Portail / téléporteur, SurfaceGui/Billboard, 10x14x9 studs (de Rebirth Champions X/Workspace/Scripts.rbxm) |
| RebirthChampionsX_PortalsVoid.rbxm | RebirthChampionsX | 4 | non | Portail / téléporteur, SurfaceGui/Billboard, 9x14x11 studs (de Rebirth Champions X/Workspace/Scripts.rbxm) |
| RebirthChampionsX_Spawn.rbxm | RebirthChampionsX | 3 | non | Portail / téléporteur, SurfaceGui/Billboard, 2x14x11 studs (de Rebirth Champions X/Workspace/Scripts.rbxm) |
| RebirthChampionsX_Spawn_2.rbxm | RebirthChampionsX | 2 | non | Portail / téléporteur, 4x14x17 studs (de Rebirth Champions X/Workspace/Scripts.rbxm) |
| RebirthChampionsX_Spooky.rbxm | RebirthChampionsX | 4 | non | Portail / téléporteur, SurfaceGui/Billboard, 11x14x8 studs (de Rebirth Champions X/Workspace/Scripts.rbxm) |
| RebirthChampionsX_TeleportTo.rbxm | RebirthChampionsX | 17 | non | Portail / téléporteur, 1563x103x1481 studs (de Rebirth Champions X/Workspace/Scripts.rbxm) |
| RebirthChampionsX_Volcano.rbxm | RebirthChampionsX | 1 | non | Portail / téléporteur, SurfaceGui/Billboard, 63x41x8 studs (de Rebirth Champions X/Workspace/Scripts.rbxm) |
| RebirthChampionsX_Winter.rbxm | RebirthChampionsX | 4 | non | Portail / téléporteur, SurfaceGui/Billboard, 11x14x2 studs (de Rebirth Champions X/Workspace/Scripts.rbxm) |
| RobotSim_ComingsoonPortal.rbxm | RobotSim | 28 | non | Portail / téléporteur, SurfaceGui/Billboard, 12x14x10 studs (de Robot Simulator/Workspace/Portals.rbxm) |
| RobotSim_GrasslandPortal.rbxm | RobotSim | 28 | non | Portail / téléporteur, SurfaceGui/Billboard, 12x14x9 studs (de Robot Simulator/Grassland Portal.rbxm) |
| RobotSim_MagmalandPortal.rbxm | RobotSim | 28 | non | Portail / téléporteur, SurfaceGui/Billboard, 12x14x9 studs (de Robot Simulator/Magmaland Portal.rbxm) |
| RobotSim_PremiumSpawn.rbxm | RobotSim | 28 | non | Portail / téléporteur, SurfaceGui/Billboard, 13x17x14 studs (de Robot Simulator/Workspace/Portals.rbxm) |
| RobotSim_Spawn.rbxm | RobotSim | 28 | non | Portail / téléporteur, SurfaceGui/Billboard, 10x14x12 studs (de Robot Simulator/Workspace/Portals.rbxm) |
| RobotSim_TeleSpots.rbxm | RobotSim | 6 | non | Portail / téléporteur, 2255x3151x2222 studs (de Robot Simulator/Workspace/Portals.rbxm) |
| RobotSim_VIPSpawn.rbxm | RobotSim | 28 | non | Portail / téléporteur, SurfaceGui/Billboard, 15x17x16 studs (de Robot Simulator/Workspace/Portals.rbxm) |
| RobotSim_WinterWonderlandPortal.rbxm | RobotSim | 28 | non | Portail / téléporteur, SurfaceGui/Billboard, 12x14x9 studs (de Robot Simulator/Winter Wonderland Portal.rbxm) |
| RobotSim_Zone5.rbxm | RobotSim | 28 | non | Portail / téléporteur, SurfaceGui/Billboard, 12x14x10 studs (de Robot Simulator/Workspace/Portals.rbxm) |
| RobotSim_Zone6.rbxm | RobotSim | 28 | non | Portail / téléporteur, SurfaceGui/Billboard, 12x14x10 studs (de Robot Simulator/Workspace/Portals.rbxm) |
| TappingLords_CandyWorldPortal.rbxm | TappingLords | 5 | non | Portail / téléporteur, SurfaceGui/Billboard, 22x17x15 studs (de Tapping-Lords-Simulator/Workspace/Portals.rbxm) |
| TappingLords_Event1WorldPortal.rbxm | TappingLords | 5 | non | Portail / téléporteur, SurfaceGui/Billboard, 23x17x23 studs (de Tapping-Lords-Simulator/Workspace/Portals.rbxm) |
| TappingLords_LavaWorldPortal.rbxm | TappingLords | 6 | non | Portail / téléporteur, SurfaceGui/Billboard, 22x17x23 studs (de Tapping-Lords-Simulator/Workspace/Portals.rbxm) |
| TappingLords_MythicalForestPortal.rbxm | TappingLords | 5 | non | Portail / téléporteur, SurfaceGui/Billboard, 20x17x24 studs (de Tapping-Lords-Simulator/Workspace/Portals.rbxm) |
| TappingLords_PortalSpawn1.rbxm | TappingLords | 16 | non | Portail / téléporteur, 14x13x7 studs (de Tapping-Lords-Simulator/Workspace/Portals.rbxm) |
| TappingLords_PortalSpawn2.rbxm | TappingLords | 16 | non | Portail / téléporteur, 2x13x15 studs (de Tapping-Lords-Simulator/Workspace/Portals.rbxm) |
| TappingLords_PortalSpawn3.rbxm | TappingLords | 16 | non | Portail / téléporteur, 13x13x10 studs (de Tapping-Lords-Simulator/Workspace/Portals.rbxm) |
| TappingLords_PortalSpawn4.rbxm | TappingLords | 16 | non | Portail / téléporteur, 2x13x15 studs (de Tapping-Lords-Simulator/Workspace/Portals.rbxm) |
| TappingLords_PortalSpawn5.rbxm | TappingLords | 16 | non | Portail / téléporteur, 2x13x15 studs (de Tapping-Lords-Simulator/Workspace/Portals.rbxm) |
| TappingLords_PortalSpawnX.rbxm | TappingLords | 16 | non | Portail / téléporteur, 4x13x15 studs (de Tapping-Lords-Simulator/Workspace/Portals.rbxm) |
| TappingLords_SpaceWorldPortal.rbxm | TappingLords | 5 | non | Portail / téléporteur, SurfaceGui/Billboard, 19x17x23 studs (de Tapping-Lords-Simulator/Workspace/Portals.rbxm) |
| TappingLords_WaterWorldPortal.rbxm | TappingLords | 5 | non | Portail / téléporteur, SurfaceGui/Billboard, 21x17x13 studs (de Tapping-Lords-Simulator/Workspace/Portals.rbxm) |
| TweetingSim_TeleportersForSale_400.rbxm | TweetingSim | 6 | non | Portail / téléporteur, 1 particules/effets, 5x18x12 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Core.rbxm) |
| TweetingSim_TeleportersForSale_402.rbxm | TweetingSim | 8 | non | Portail / téléporteur, 1 particules/effets, 8x18x12 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Core.rbxm) |
| TweetingSim_TeleportersForSale_406.rbxm | TweetingSim | 9 | non | Portail / téléporteur, 1 particules/effets, 13x22x15 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Core.rbxm) |

## Leaderboards_Boards

Dossier `ByType/Leaderboards_Boards/` — 72 objets.

| Fichier | Jeu | Pièces | Scripts | Description |
|---|---|---|---|---|
| 1JumpEverySecond_PremiumBenefitBoard.rbxm | 1JumpEverySecond | 21 | oui (1) | Panneau / leaderboard, 2 particules/effets, SurfaceGui/Billboard, 13x16x4 studs (de 1JumpEverySecond/Workspace/PremiumBenefitBoard.rbxm) |
| CashgrabBridge_Design.rbxm | CashgrabBridge | 6 | non | Panneau / leaderboard, 10x82x79 studs (de CashgrabBridgeEU/Workspace/Design.rbxm) |
| FirstDonations_Boards.rbxm | FirstDonations | 19 | oui (6) | Panneau / leaderboard, Humanoid, SurfaceGui/Billboard, ancrage d’origine conservé, 2 script(s) dangereux retiré(s), 15x13x19 studs (de First_Donations/Workspace/Boards.rbxm) |
| FirstDonations_TopDonadores2.rbxm | FirstDonations | 11 | non | Panneau / leaderboard, 23x16x28 studs (de First_Donations/Workspace/IslaCentralVerde.rbxm) |
| GlassBridge_Nr1Player.rbxm | GlassBridge | 16 | oui (1) | Panneau / leaderboard, Humanoid, ancrage d’origine conservé, 6x8x5 studs (de GlassBridge/Workspace/Nr1Player.rbxm) |
| HatchingSim_TopClicks.rbxm | HatchingSim | 30 | non | Panneau / leaderboard, Humanoid, SurfaceGui/Billboard, ancrage d’origine conservé, 1 script(s) dangereux retiré(s), 27x15x14 studs (de HatchingSimulator/Workspace/Top Clicks.rbxm) |
| HatchingSim_TopCoins.rbxm | HatchingSim | 29 | oui (1) | Panneau / leaderboard, Humanoid, SurfaceGui/Billboard, ancrage d’origine conservé, 14x12x22 studs (de HatchingSimulator/Workspace/Top Coins.rbxm) |
| MiningMasters_Rebirth.rbxm | MiningMasters | 11 | oui (1) | Panneau / leaderboard, SurfaceGui/Billboard, 11x12x5 studs (de Mining-Masters/Workspace/Leaderboards.rbxm) |
| MiningMasters_signs.rbxm | MiningMasters | 27 | non | Panneau / leaderboard, SurfaceGui/Billboard, 757x44x2593 studs (de Mining-Masters/Workspace/signs.rbxm) |
| MiningMasters_Strength.rbxm | MiningMasters | 11 | oui (1) | Panneau / leaderboard, SurfaceGui/Billboard, 11x12x5 studs (de Mining-Masters/Workspace/Leaderboards.rbxm) |
| MiningMasters_Wins.rbxm | MiningMasters | 11 | oui (1) | Panneau / leaderboard, SurfaceGui/Billboard, 13x15x2 studs (de Mining-Masters/Workspace/Leaderboards.rbxm) |
| PetPharmica_Plaques.rbxm | PetPharmica | 8 | non | Panneau / leaderboard, 16x12x2 studs (de Pet_Pharmica_1_1/Workspace/Plaques.rbxm) |
| PetPharmica_Sign.rbxm | PetPharmica | 2 | non | Panneau / leaderboard, SurfaceGui/Billboard, 4x4x4 studs (de Pet_Pharmica_1_1/Workspace/Areas.rbxm) |
| PunchSim_Gems.rbxm | PunchSim | 4 | non | Panneau / leaderboard, SurfaceGui/Billboard, 14x16x8 studs (de Punch Simulator/Workspace/__MAP.rbxm) |
| PunchSim_Ranks.rbxm | PunchSim | 7 | non | Panneau / leaderboard, SurfaceGui/Billboard, 9x13x11 studs (de Punch Simulator/Ranks.rbxm) |
| PunchSim_Ranks_2.rbxm | PunchSim | 2 | non | Panneau / leaderboard, SurfaceGui/Billboard, 27x30x26 studs (de Punch Simulator/Workspace/__MAP.rbxm) |
| PunchSim_Strength.rbxm | PunchSim | 5 | non | Panneau / leaderboard, SurfaceGui/Billboard, 10x16x13 studs (de Punch Simulator/Workspace/__MAP.rbxm) |
| PunchSim_Time.rbxm | PunchSim | 4 | non | Panneau / leaderboard, SurfaceGui/Billboard, 13x17x11 studs (de Punch Simulator/Workspace/__MAP.rbxm) |
| RebirthChampionsX_EggsOpened.rbxm | RebirthChampionsX | 6 | non | Panneau / leaderboard, SurfaceGui/Billboard, 13x17x9 studs (de Rebirth Champions X/Workspace/Scripts.rbxm) |
| RebirthChampionsX_Index.rbxm | RebirthChampionsX | 3 | non | Panneau / leaderboard, SurfaceGui/Billboard, 12x1x11 studs (de Rebirth Champions X/Workspace/Scripts.rbxm) |
| RebirthChampionsX_Rebirths.rbxm | RebirthChampionsX | 6 | non | Panneau / leaderboard, SurfaceGui/Billboard, 8x17x14 studs (de Rebirth Champions X/Workspace/Scripts.rbxm) |
| RebirthChampionsX_RobuxSpent.rbxm | RebirthChampionsX | 6 | non | Panneau / leaderboard, SurfaceGui/Billboard, 14x17x3 studs (de Rebirth Champions X/Workspace/Scripts.rbxm) |
| RebirthChampionsX_SecretsHatched.rbxm | RebirthChampionsX | 6 | non | Panneau / leaderboard, SurfaceGui/Billboard, 14x17x5 studs (de Rebirth Champions X/Workspace/Scripts.rbxm) |
| RebirthChampionsX_Sign1.rbxm | RebirthChampionsX | 3 | non | Panneau / leaderboard, 6x12x2 studs (de Rebirth Champions X/Workspace/Maps.rbxm) |
| RebirthChampionsX_TimePlayed.rbxm | RebirthChampionsX | 6 | non | Panneau / leaderboard, SurfaceGui/Billboard, 11x17x12 studs (de Rebirth Champions X/Workspace/Scripts.rbxm) |
| RebirthChampionsX_TopRebirths_1.rbxm | RebirthChampionsX | 31 | oui (1) | Panneau / leaderboard, Humanoid, 1 particules/effets, SurfaceGui/Billboard, ancrage d’origine conservé, 8x15x13 studs (de Rebirth Champions X/Workspace/Scripts.rbxm) |
| RebirthChampionsX_TopRebirths_2.rbxm | RebirthChampionsX | 27 | oui (1) | Panneau / leaderboard, Humanoid, 1 particules/effets, SurfaceGui/Billboard, ancrage d’origine conservé, 6x11x6 studs (de Rebirth Champions X/Workspace/Scripts.rbxm) |
| RebirthChampionsX_TopRebirths_3.rbxm | RebirthChampionsX | 29 | oui (1) | Panneau / leaderboard, Humanoid, SurfaceGui/Billboard, ancrage d’origine conservé, 6x12x7 studs (de Rebirth Champions X/Workspace/Scripts.rbxm) |
| RebirthChampionsX_TotalClicks.rbxm | RebirthChampionsX | 6 | non | Panneau / leaderboard, SurfaceGui/Billboard, 3x17x14 studs (de Rebirth Champions X/Workspace/Scripts.rbxm) |
| RebirthChampionsX_TotalGems.rbxm | RebirthChampionsX | 6 | non | Panneau / leaderboard, SurfaceGui/Billboard, 14x17x7 studs (de Rebirth Champions X/Workspace/Scripts.rbxm) |
| RobotSim_Billboard.rbxm | RobotSim | 29 | non | Panneau / leaderboard, 18x32x40 studs (de Robot Simulator/Workspace/Map.rbxm) |
| RobotSim_BillboardSquare.rbxm | RobotSim | 27 | non | Panneau / leaderboard, 24x32x23 studs (de Robot Simulator/Workspace/Map.rbxm) |
| RobotSim_Boss.rbxm | RobotSim | 20 | non | Panneau / leaderboard, 2 particules/effets, SurfaceGui/Billboard, 4x12x11 studs (de Robot Simulator/Workspace/Leaderboards.rbxm) |
| RobotSim_CaptureSign.rbxm | RobotSim | 14 | non | Panneau / leaderboard, 2 particules/effets, SurfaceGui/Billboard, 4x6x11 studs (de Robot Simulator/OLD_THINGS.rbxm) |
| RobotSim_Champ.rbxm | RobotSim | 20 | non | Panneau / leaderboard, Humanoid, SurfaceGui/Billboard, ancrage d’origine conservé, 4x4x4 studs (de Robot Simulator/Workspace/Champ.rbxm) |
| RobotSim_CodeGoalsBoard.rbxm | RobotSim | 29 | non | Panneau / leaderboard, SurfaceGui/Billboard, 4x13x12 studs (de Robot Simulator/Workspace/Map.rbxm) |
| RobotSim_Cog.rbxm | RobotSim | 21 | non | Panneau / leaderboard, 2 particules/effets, SurfaceGui/Billboard, 9x12x8 studs (de Robot Simulator/Workspace/Leaderboards.rbxm) |
| RobotSim_Coin.rbxm | RobotSim | 22 | non | Panneau / leaderboard, 2 particules/effets, SurfaceGui/Billboard, 8x12x8 studs (de Robot Simulator/Workspace/Leaderboards.rbxm) |
| RobotSim_CoinsBoard.rbxm | RobotSim | 25 | non | Panneau / leaderboard, SurfaceGui/Billboard, 12x17x12 studs (de Robot Simulator/Workspace/CoinsBoard.rbxm) |
| RobotSim_CreditsBoard.rbxm | RobotSim | 20 | non | Panneau / leaderboard, SurfaceGui/Billboard, 8x13x11 studs (de Robot Simulator/CreditsBoard.rbxm) |
| RobotSim_CreditsBoard_2.rbxm | RobotSim | 28 | non | Panneau / leaderboard, SurfaceGui/Billboard, 9x13x10 studs (de Robot Simulator/Workspace/Map.rbxm) |
| RobotSim_DungeonSign.rbxm | RobotSim | 20 | non | Panneau / leaderboard, 2 particules/effets, 10x6x8 studs (de Robot Simulator/DungeonSign.rbxm) |
| RobotSim_EggHatched.rbxm | RobotSim | 22 | non | Panneau / leaderboard, 2 particules/effets, SurfaceGui/Billboard, 11x12x1 studs (de Robot Simulator/Workspace/Leaderboards.rbxm) |
| RobotSim_FlagsCaptured.rbxm | RobotSim | 24 | non | Panneau / leaderboard, 2 particules/effets, SurfaceGui/Billboard, 8x12x9 studs (de Robot Simulator/Workspace/Leaderboards.rbxm) |
| RobotSim_GamepassBoard.rbxm | RobotSim | 28 | non | Panneau / leaderboard, SurfaceGui/Billboard, 16x19x17 studs (de Robot Simulator/Workspace/GamepassBoard.rbxm) |
| RobotSim_GamepassSign.rbxm | RobotSim | 15 | non | Panneau / leaderboard, 2 particules/effets, SurfaceGui/Billboard, 11x8x11 studs (de Robot Simulator/GamepassSign.rbxm) |
| RobotSim_Gem.rbxm | RobotSim | 21 | non | Panneau / leaderboard, 2 particules/effets, SurfaceGui/Billboard, 8x12x8 studs (de Robot Simulator/Workspace/Leaderboards.rbxm) |
| RobotSim_GemsBoard.rbxm | RobotSim | 24 | non | Panneau / leaderboard, SurfaceGui/Billboard, 13x17x12 studs (de Robot Simulator/Workspace/GemsBoard.rbxm) |
| RobotSim_Hill.rbxm | RobotSim | 20 | non | Panneau / leaderboard, 2 particules/effets, SurfaceGui/Billboard, 11x12x1 studs (de Robot Simulator/Workspace/Leaderboards.rbxm) |
| RobotSim_Kill.rbxm | RobotSim | 22 | non | Panneau / leaderboard, 2 particules/effets, SurfaceGui/Billboard, 9x12x8 studs (de Robot Simulator/Workspace/Leaderboards.rbxm) |
| RobotSim_LeaderboardUpdate_Model.rbxm | RobotSim | 10 | non | Panneau / leaderboard, 2 particules/effets, 8x6x6 studs (de Robot Simulator/Workspace/Leaderboards.rbxm) |
| RobotSim_RobuxSpent.rbxm | RobotSim | 21 | non | Panneau / leaderboard, 2 particules/effets, SurfaceGui/Billboard, 9x12x8 studs (de Robot Simulator/RobuxSpent.rbxm) |
| RobotSim_ShirtSign.rbxm | RobotSim | 11 | non | Panneau / leaderboard, 2 particules/effets, SurfaceGui/Billboard, 8x6x4 studs (de Robot Simulator/ShirtDisplays.rbxm) |
| RobotSim_Time.rbxm | RobotSim | 21 | non | Panneau / leaderboard, 2 particules/effets, SurfaceGui/Billboard, 10x12x7 studs (de Robot Simulator/Workspace/Leaderboards.rbxm) |
| RobotSim_TycoonSign.rbxm | RobotSim | 22 | non | Panneau / leaderboard, 2 particules/effets, 48x25x48 studs (de Robot Simulator/Workspace/LowModeParts.rbxm) |
| ShootABrainrot_Billboard.rbxm | ShootABrainrot | 5 | non | Panneau / leaderboard, SurfaceGui/Billboard, 44x18x3 studs (de ShootABrainrotEU/Workspace/Main.rbxm) |
| TappingLords_1Clicks.rbxm | TappingLords | 16 | oui (3) | Panneau / leaderboard, Humanoid, SurfaceGui/Billboard, ancrage d’origine conservé, 4x5x3 studs (de Tapping-Lords-Simulator/Workspace/1 Clicks.rbxm) |
| TappingLords_Index.rbxm | TappingLords | 12 | non | Panneau / leaderboard, SurfaceGui/Billboard, 17x2x13 studs (de Tapping-Lords-Simulator/Workspace/Index.rbxm) |
| TappingLords_Leaderboards.rbxm | TappingLords | 35 | oui (5) | Panneau / leaderboard, SurfaceGui/Billboard, 17x12x49 studs (de Tapping-Lords-Simulator/Workspace/Leaderboards.rbxm) |
| TappingLords_Rankboard.rbxm | TappingLords | 7 | oui (16) | Panneau / leaderboard, SurfaceGui/Billboard, 14x16x4 studs (de Tapping-Lords-Simulator/Workspace/Rankboard.rbxm) |
| TappingLords_Titles.rbxm | TappingLords | 12 | oui (1) | Panneau / leaderboard, SurfaceGui/Billboard, 18x11x20 studs (de Tapping-Lords-Simulator/Workspace/Titles.rbxm) |
| TrainingSim_RobuxSpent.rbxm | TrainingSim | 6 | non | Panneau / leaderboard, 1 particules/effets, SurfaceGui/Billboard, 3x13x10 studs (de TrainingSimulatorEU/Workspace/Leaderboard.rbxm) |
| TrainingSim_RobuxSpent_2.rbxm | TrainingSim | 14 | non | Panneau / leaderboard, 6x5x6 studs (de TrainingSimulatorEU/Workspace/Podium.rbxm) |
| TrainingSim_TimePlayed.rbxm | TrainingSim | 14 | non | Panneau / leaderboard, 8x5x8 studs (de TrainingSimulatorEU/Workspace/Podium.rbxm) |
| TrainingSim_TotalMuscle.rbxm | TrainingSim | 1 | non | Panneau / leaderboard, SurfaceGui/Billboard, 7x13x4 studs (de TrainingSimulatorEU/Workspace/Leaderboard.rbxm) |
| TrainingSim_TotalRebirths.rbxm | TrainingSim | 14 | non | Panneau / leaderboard, 8x5x8 studs (de TrainingSimulatorEU/Workspace/Podium.rbxm) |
| TweetingSim_DevProductSign.rbxm | TweetingSim | 8 | non | Panneau / leaderboard, 6x12x12 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Core.rbxm) |
| TweetingSim_LaptopSign.rbxm | TweetingSim | 6 | non | Panneau / leaderboard, 12x12x17 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Core.rbxm) |
| TweetingSim_PhoneSign.rbxm | TweetingSim | 3 | non | Panneau / leaderboard, 29x13x26 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Core.rbxm) |
| TweetingSim_SpecialSign.rbxm | TweetingSim | 5 | non | Panneau / leaderboard, 15x11x20 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Core.rbxm) |
| TweetingSim_TotalTweets.rbxm | TweetingSim | 6 | non | Panneau / leaderboard, SurfaceGui/Billboard, 5x11x11 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Core.rbxm) |
| TweetingSim_VerifiedSign.rbxm | TweetingSim | 5 | non | Panneau / leaderboard, 21x11x11 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Core.rbxm) |

## Collectibles_Chests

Dossier `ByType/Collectibles_Chests/` — 36 objets.

| Fichier | Jeu | Pièces | Scripts | Description |
|---|---|---|---|---|
| GlassBridge_Money.rbxm | GlassBridge | 16 | non | Collectible / coffre, 11x6x11 studs (de GlassBridge/Workspace/Money.rbxm) |
| Lib_coin.rbxm | Lib | 1 | non | Collectible / coffre, 3x3x0 studs (de VFX/PluginAssets_VFX.rbxm) |
| MagnetSim2_Chests.rbxm | MagnetSim2 | 5 | non | Collectible / coffre, 13x6271x19 studs (de UNCOPYLOCKED-Magnet-Simulator-2/Workspace/Skys.rbxm) |
| MagnetSim2_Red.rbxm | MagnetSim2 | 1 | non | Collectible / coffre, 2x2x1 studs (de UNCOPYLOCKED-Magnet-Simulator-2/Models.rbxm) |
| MagnetSim2_StoneCurrency.rbxm | MagnetSim2 | 9 | non | Collectible / coffre, SurfaceGui/Billboard, 21x22x4 studs (de UNCOPYLOCKED-Magnet-Simulator-2/Workspace/StoneCurrency.rbxm) |
| MagnetSim2_Yellow.rbxm | MagnetSim2 | 1 | non | Collectible / coffre, 2x2x2 studs (de UNCOPYLOCKED-Magnet-Simulator-2/Models.rbxm) |
| MiningMasters_ChestByDevvNexus.rbxm | MiningMasters | 8 | non | Collectible / coffre, 14x12x19 studs (de Mining-Masters/Workspace/ChestByDevvNexus.rbxm) |
| MiningMasters_Ore4.rbxm | MiningMasters | 1 | non | Collectible / coffre, SurfaceGui/Billboard, 6x5x5 studs (de Mining-Masters/Workspace/Ores.rbxm) |
| MiningMasters_Ore40.rbxm | MiningMasters | 1 | non | Collectible / coffre, SurfaceGui/Billboard, 5x5x6 studs (de Mining-Masters/Workspace/Ores.rbxm) |
| MiningMasters_VIP1.rbxm | MiningMasters | 2 | non | Collectible / coffre, SurfaceGui/Billboard, 6x7x5 studs (de Mining-Masters/Workspace/Ores.rbxm) |
| MiningMasters_Wins.rbxm | MiningMasters | 10 | oui (15) | Collectible / coffre, 20 particules/effets, SurfaceGui/Billboard, 642x81x2467 studs (de Mining-Masters/Workspace/Wins.rbxm) |
| PetPharmica_Coins.rbxm | PetPharmica | 132 | oui (134) | Collectible / coffre, 260 particules/effets, prompt/clic, SurfaceGui/Billboard, 1404x36x194 studs (de Pet_Pharmica_1_1/Workspace/Coins.rbxm) |
| PetPharmica_Gems.rbxm | PetPharmica | 15 | non | Collectible / coffre, SurfaceGui/Billboard, 2x20x24 studs (de Pet_Pharmica_1_1/Workspace/Gems.rbxm) |
| PetPharmica_MontedeCoins.rbxm | PetPharmica | 15 | non | Collectible / coffre, 6x2x8 studs (de Pet_Pharmica_1_1/Workspace/Ancient Coins.rbxm) |
| PetPharmica_TreasureChest.rbxm | PetPharmica | 9 | non | Collectible / coffre, SurfaceGui/Billboard, 41x13x43 studs (de Pet_Pharmica_1_1/Workspace/TreasureChest.rbxm) |
| PunchSim_CaveChest.rbxm | PunchSim | 11 | non | Collectible / coffre, 1 particules/effets, SurfaceGui/Billboard, 19x10x19 studs (de Punch Simulator/Cave Chest.rbxm) |
| RebirthChampionsX_Beach.rbxm | RebirthChampionsX | 19 | non | Collectible / coffre, SurfaceGui/Billboard, 26x13x26 studs (de Rebirth Champions X/Workspace/Scripts.rbxm) |
| RebirthChampionsX_Cyber.rbxm | RebirthChampionsX | 19 | non | Collectible / coffre, SurfaceGui/Billboard, 22x11x22 studs (de Rebirth Champions X/Workspace/Scripts.rbxm) |
| RebirthChampionsX_Easter.rbxm | RebirthChampionsX | 19 | non | Collectible / coffre, SurfaceGui/Billboard, 24x13x19 studs (de Rebirth Champions X/Workspace/Scripts.rbxm) |
| RebirthChampionsX_Nuclear.rbxm | RebirthChampionsX | 19 | non | Collectible / coffre, SurfaceGui/Billboard, 22x11x22 studs (de Rebirth Champions X/Workspace/Scripts.rbxm) |
| RebirthChampionsX_Spawn.rbxm | RebirthChampionsX | 19 | non | Collectible / coffre, SurfaceGui/Billboard, 28x18x34 studs (de Rebirth Champions X/Workspace/Scripts.rbxm) |
| RebirthChampionsX_Winter.rbxm | RebirthChampionsX | 19 | non | Collectible / coffre, SurfaceGui/Billboard, 31x16x31 studs (de Rebirth Champions X/Workspace/Scripts.rbxm) |
| RobotSim_BothLoop1.rbxm | RobotSim | 4 | non | Collectible / coffre, SurfaceGui/Billboard, 43x43x11 studs (de Robot Simulator/CopyHoops.rbxm) |
| RobotSim_CoinChest.rbxm | RobotSim | 33 | non | Collectible / coffre, SurfaceGui/Billboard, 40x15x38 studs (de Robot Simulator/Workspace/CollectableChests.rbxm) |
| RobotSim_CoinLoop1.rbxm | RobotSim | 4 | non | Collectible / coffre, SurfaceGui/Billboard, 43x43x11 studs (de Robot Simulator/CopyHoops.rbxm) |
| RobotSim_DailyReward.rbxm | RobotSim | 14 | non | Collectible / coffre, SurfaceGui/Billboard, 35x17x36 studs (de Robot Simulator/Workspace/CollectableChests.rbxm) |
| RobotSim_GalaxyGemChest.rbxm | RobotSim | 33 | non | Collectible / coffre, SurfaceGui/Billboard, 41x15x38 studs (de Robot Simulator/Workspace/CollectableChests.rbxm) |
| RobotSim_GemChest.rbxm | RobotSim | 33 | non | Collectible / coffre, SurfaceGui/Billboard, 39x14x41 studs (de Robot Simulator/Workspace/CollectableChests.rbxm) |
| RobotSim_GemLoop1.rbxm | RobotSim | 4 | non | Collectible / coffre, SurfaceGui/Billboard, 43x43x11 studs (de Robot Simulator/CopyHoops.rbxm) |
| RobotSim_HiddenChest.rbxm | RobotSim | 40 | non | Collectible / coffre, SurfaceGui/Billboard, 16x11x16 studs (de Robot Simulator/Workspace/CollectableChests.rbxm) |
| RobotSim_Locations.rbxm | RobotSim | 157 | non | Collectible / coffre, 2414x3158x2381 studs (de Robot Simulator/Workspace/Coins.rbxm) |
| RobotSim_PetXPChest.rbxm | RobotSim | 32 | non | Collectible / coffre, SurfaceGui/Billboard, ancrage d’origine conservé, 41x14x40 studs (de Robot Simulator/Workspace/CollectableChests.rbxm) |
| RobotSim_PremiumGemChest.rbxm | RobotSim | 69 | non | Collectible / coffre, SurfaceGui/Billboard, 41x14x40 studs (de Robot Simulator/Workspace/CollectableChests.rbxm) |
| RobotSim_Spawned.rbxm | RobotSim | 11 | non | Collectible / coffre, 2222x3157x2053 studs (de Robot Simulator/Workspace/Coins.rbxm) |
| RobotSim_VIPGemChest.rbxm | RobotSim | 69 | non | Collectible / coffre, SurfaceGui/Billboard, 40x14x40 studs (de Robot Simulator/Workspace/CollectableChests.rbxm) |
| TweetingSim_Sellpoints.rbxm | TweetingSim | 21 | non | Collectible / coffre, 7 particules/effets, 1905x90x2411 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Core.rbxm) |

## Decor_Props

Dossier `ByType/Decor_Props/` — 268 objets.

| Fichier | Jeu | Pièces | Scripts | Description |
|---|---|---|---|---|
| 1HealthEverySecond_Cactus.rbxm | 1HealthEverySecond | 1 | non | Décor, 14x15x9 studs (de 1HealthEverySecond/Workspace/Added Stuff.rbxm) |
| 1HealthEverySecond_DeadTree.rbxm | 1HealthEverySecond | 1 | non | Décor, 21x31x20 studs (de 1HealthEverySecond/Workspace/Added Stuff.rbxm) |
| 1HealthEverySecond_Rocks.rbxm | 1HealthEverySecond | 3 | non | Décor, 34x13x30 studs (de 1HealthEverySecond/Workspace/Added Stuff.rbxm) |
| 1HealthEverySecond_Tree.rbxm | 1HealthEverySecond | 4 | non | Décor, 32x47x32 studs (de 1HealthEverySecond/Workspace/Added Stuff.rbxm) |
| 1HealthEverySecond_World1.rbxm | 1HealthEverySecond | 46 | non | Décor, SurfaceGui/Billboard, 277x1x135 studs (de 1HealthEverySecond/Workspace/World1.rbxm) |
| 1HealthEverySecond_World2.rbxm | 1HealthEverySecond | 15 | non | Décor, SurfaceGui/Billboard, 262x1x141 studs (de 1HealthEverySecond/Workspace/World2.rbxm) |
| 1JumpEverySecond_Blocks.rbxm | 1JumpEverySecond | 31 | non | Décor, 87x4134x130 studs (de 1JumpEverySecond/Workspace/__MAP.rbxm) |
| 1JumpEverySecond_Blocks_2.rbxm | 1JumpEverySecond | 27 | non | Décor, 87x1722x130 studs (de 1JumpEverySecond/Workspace/__MAP.rbxm) |
| 1JumpEverySecond_Blocks_3.rbxm | 1JumpEverySecond | 34 | non | Décor, 87x7105x145 studs (de 1JumpEverySecond/Workspace/__MAP.rbxm) |
| 1JumpEverySecond_Blocks_4.rbxm | 1JumpEverySecond | 36 | non | Décor, 97x9582x170 studs (de 1JumpEverySecond/Workspace/__MAP.rbxm) |
| 1JumpEverySecond_Blocks_5.rbxm | 1JumpEverySecond | 39 | non | Décor, 97x13733x170 studs (de 1JumpEverySecond/Workspace/__MAP.rbxm) |
| 1JumpEverySecond_Blocks_6.rbxm | 1JumpEverySecond | 41 | non | Décor, 97x17769x180 studs (de 1JumpEverySecond/Workspace/__MAP.rbxm) |
| 1JumpEverySecond_Blocks_7.rbxm | 1JumpEverySecond | 43 | non | Décor, 97x21132x186 studs (de 1JumpEverySecond/Workspace/__MAP.rbxm) |
| 1JumpEverySecond_Blocks_8.rbxm | 1JumpEverySecond | 45 | non | Décor, 97x24295x186 studs (de 1JumpEverySecond/Workspace/__MAP.rbxm) |
| 1JumpEverySecond_Blocks_9.rbxm | 1JumpEverySecond | 46 | non | Décor, 97x25608x186 studs (de 1JumpEverySecond/Workspace/__MAP.rbxm) |
| 1JumpEverySecond_RainbowTower.rbxm | 1JumpEverySecond | 9 | non | Décor, 1433x0x15 studs (de 1JumpEverySecond/Workspace/__MAP.rbxm) |
| 1JumpEverySecond_Spawns.rbxm | 1JumpEverySecond | 9 | non | Décor, 1433x1x103 studs (de 1JumpEverySecond/Workspace/__MAP.rbxm) |
| 1JumpEverySecond_Win.rbxm | 1JumpEverySecond | 2 | non | Décor, SurfaceGui/Billboard, 18x4x18 studs (de 1JumpEverySecond/Workspace/__MAP.rbxm) |
| BakerySim_Cakes.rbxm | BakerySim | 10 | non | Décor, 4x2x29 studs (de Bakery-Simulator/RecipeProducts.rbxm) |
| BakerySim_Cookies.rbxm | BakerySim | 9 | non | Décor, 6x0x10 studs (de Bakery-Simulator/RecipeProducts.rbxm) |
| BakerySim_Cupcakes.rbxm | BakerySim | 15 | non | Décor, 2x2x13 studs (de Bakery-Simulator/RecipeProducts.rbxm) |
| BakerySim_DisplayModelBread.rbxm | BakerySim | 1 | non | Décor, 2x1x3 studs (de Bakery-Simulator/Assets.rbxm) |
| BakerySim_Donuts.rbxm | BakerySim | 10 | non | Décor, 4x1x14 studs (de Bakery-Simulator/RecipeProducts.rbxm) |
| BakerySim_Exotic.rbxm | BakerySim | 17 | non | Décor, 7x1x13 studs (de Bakery-Simulator/RecipeProducts.rbxm) |
| BakerySim_FancyCakes.rbxm | BakerySim | 24 | non | Décor, 8x2x19 studs (de Bakery-Simulator/RecipeProducts.rbxm) |
| BakerySim_Ingredients.rbxm | BakerySim | 32 | non | Décor, 17x3x13 studs (de Bakery-Simulator/Assets.rbxm) |
| BakerySim_IngredientsOLD.rbxm | BakerySim | 7 | non | Décor, 15x3x52 studs (de Bakery-Simulator/Assets.rbxm) |
| BakerySim_Nuke.rbxm | BakerySim | 2 | non | Décor, 1 particules/effets, 31x29x32 studs (de Bakery-Simulator/Assets.rbxm) |
| BakerySim_PetMenuBackground.rbxm | BakerySim | 70 | non | Décor, 28x18x46 studs (de Bakery-Simulator/Assets.rbxm) |
| BakerySim_Pies.rbxm | BakerySim | 12 | non | Décor, 3x1x22 studs (de Bakery-Simulator/RecipeProducts.rbxm) |
| BakerySim_Sweetbread.rbxm | BakerySim | 1 | non | Décor, 1 particules/effets, 3x2x3 studs (de Bakery-Simulator/RecipeProducts.rbxm) |
| BakerySim_Tray.rbxm | BakerySim | 1 | non | Décor, 4x0x6 studs (de Bakery-Simulator/Assets.rbxm) |
| BillionaireTycoon_BeachSet.rbxm | BillionaireTycoon | 6 | oui (2) | Décor, 10x7x6 studs (de Billionaire_Tycoon/Workspace/Beach Seats.rbxm) |
| BillionaireTycoon_Tree.rbxm | BillionaireTycoon | 2 | non | Décor, 30x36x30 studs (de Billionaire_Tycoon/Workspace/Trees.rbxm) |
| CashgrabBridge_HolographicClock.rbxm | CashgrabBridge | 55 | oui (8) | Décor, SurfaceGui/Billboard, 3x12x14 studs (de CashgrabBridgeEU/Workspace/HolographicClock.rbxm) |
| CashgrabBridge_Playground.rbxm | CashgrabBridge | 649 | oui (9) | Décor, Humanoid, ancrage d’origine conservé, 90x24x76 studs (de CashgrabBridgeEU/Workspace/Playground.rbxm) |
| CashgrabBridge_Shattered.rbxm | CashgrabBridge | 20 | non | Décor, 3x7x0 studs (de CashgrabBridgeEU/Storage.rbxm) |
| CashgrabBridge_Wheel.rbxm | CashgrabBridge | 7 | non | Décor, prompt/clic, SurfaceGui/Billboard, 18x20x6 studs (de CashgrabBridgeEU/Workspace/Wheel.rbxm) |
| FirstDonations_Arbol.rbxm | FirstDonations | 8 | non | Décor, 67x79x68 studs (de First_Donations/Workspace/IslaCentralVerde.rbxm) |
| FirstDonations_CartelMini.rbxm | FirstDonations | 29 | oui (1) | Décor, Humanoid, SurfaceGui/Billboard, ancrage d’origine conservé, 19x12x6 studs (de First_Donations/Workspace/IslaCentralVerde.rbxm) |
| FirstDonations_CartelMini_2.rbxm | FirstDonations | 28 | oui (1) | Décor, Humanoid, SurfaceGui/Billboard, ancrage d’origine conservé, 6x17x19 studs (de First_Donations/Workspace/IslaCentralVerde.rbxm) |
| FirstDonations_Entradapiedras.rbxm | FirstDonations | 2 | non | Décor, 133x12x46 studs (de First_Donations/Workspace/Party.rbxm) |
| FirstDonations_Fuente.rbxm | FirstDonations | 16 | non | Décor, 50x27x50 studs (de First_Donations/Workspace/IslaCentralVerde.rbxm) |
| FirstDonations_Futbol_Model.rbxm | FirstDonations | 236 | oui (1) | Décor, Humanoid, 8 particules/effets, SurfaceGui/Billboard, ancrage d’origine conservé, 301x97x318 studs (de First_Donations/Workspace/Futbol.rbxm) |
| FirstDonations_grapejuicebottleremastered.rbxm | FirstDonations | 3 | non | Décor, 1x2x1 studs (de First_Donations/Workspace/Party.rbxm) |
| FirstDonations_grapejuicebottleremastered_2.rbxm | FirstDonations | 6 | non | Décor, 8x5x2 studs (de First_Donations/Workspace/Party.rbxm) |
| FirstDonations_HongoNaranja.rbxm | FirstDonations | 3 | non | Décor, 39x11x39 studs (de First_Donations/Workspace/IslaCentralVerde.rbxm) |
| FirstDonations_HongoRosa.rbxm | FirstDonations | 3 | non | Décor, 49x15x49 studs (de First_Donations/Workspace/IslaCentralVerde.rbxm) |
| FirstDonations_HongoRosa_2.rbxm | FirstDonations | 4 | non | Décor, 49x15x49 studs (de First_Donations/Workspace/IslaCentralVerde.rbxm) |
| FirstDonations_HongoVerde.rbxm | FirstDonations | 3 | non | Décor, 68x20x68 studs (de First_Donations/Workspace/IslaCentralVerde.rbxm) |
| FirstDonations_IceSpike.rbxm | FirstDonations | 31 | non | Décor, 6x15x6 studs (de First_Donations/spikes.rbxm) |
| FirstDonations_Keyboard.rbxm | FirstDonations | 86 | oui (2) | Décor, SurfaceGui/Billboard, 6x4x8 studs (de First_Donations/Workspace/Keyboard.rbxm) |
| FirstDonations_Linea.rbxm | FirstDonations | 2 | non | Décor, 37x0x55 studs (de First_Donations/Workspace/IslaCentralVerde.rbxm) |
| FirstDonations_LineaVerde.rbxm | FirstDonations | 2 | non | Décor, 64x1x22 studs (de First_Donations/Workspace/IslaCentralVerde.rbxm) |
| FirstDonations_Luz.rbxm | FirstDonations | 3 | non | Décor, 8x6x8 studs (de First_Donations/Workspace/IslaCentralVerde.rbxm) |
| FirstDonations_LuzIslaVerde.rbxm | FirstDonations | 11 | non | Décor, ancrage d’origine conservé, 10x32x10 studs (de First_Donations/Workspace/IslaCentralVerde.rbxm) |
| FirstDonations_Model_Model.rbxm | FirstDonations | 6 | non | Décor, 26x10x10 studs (de First_Donations/Workspace/Party.rbxm) |
| FirstDonations_Model_Model_2.rbxm | FirstDonations | 47 | non | Décor, 50x25x32 studs (de First_Donations/Workspace/Party.rbxm) |
| FirstDonations_Model_Model_3.rbxm | FirstDonations | 11 | non | Décor, 56x3x12 studs (de First_Donations/Workspace/Party.rbxm) |
| FirstDonations_ModeloExhibicion.rbxm | FirstDonations | 8 | non | Décor, 3 particules/effets, SurfaceGui/Billboard, 16x6x16 studs (de First_Donations/Workspace/IslaCentralVerde.rbxm) |
| FirstDonations_Notocar.rbxm | FirstDonations | 2 | non | Décor, 759x168x759 studs (de First_Donations/Workspace/IslaCentralVerde.rbxm) |
| FirstDonations_Nubes.rbxm | FirstDonations | 7 | oui (7) | Décor, 237x37x192 studs (de First_Donations/Workspace/Nuke1.rbxm) |
| FirstDonations_Nuke.rbxm | FirstDonations | 28 | oui (8) | Décor, 29 particules/effets, SurfaceGui/Billboard, ancrage d’origine conservé, 2048x529x2048 studs (de First_Donations/Nuke.rbxm) |
| FirstDonations_Nuke2.rbxm | FirstDonations | 13 | oui (7) | Décor, SurfaceGui/Billboard, 294x104x366 studs (de First_Donations/Workspace/Nuke2.rbxm) |
| FirstDonations_NukePlatform.rbxm | FirstDonations | 22 | oui (1) | Décor, 8 particules/effets, SurfaceGui/Billboard, 95x20x95 studs (de First_Donations/Workspace/NukePlatform.rbxm) |
| FirstDonations_Piano.rbxm | FirstDonations | 88 | oui (2) | Décor, 7x7x8 studs (de First_Donations/Workspace/Piano.rbxm) |
| FirstDonations_PiedraRoja.rbxm | FirstDonations | 3 | non | Décor, 6x0x4 studs (de First_Donations/Workspace/IslaCentralVerde.rbxm) |
| FirstDonations_PiedraRoja_2.rbxm | FirstDonations | 2 | non | Décor, 56x0x206 studs (de First_Donations/Workspace/IslaCentralVerde.rbxm) |
| FirstDonations_PiedrasNormalesCentro.rbxm | FirstDonations | 60 | non | Décor, 202x1x189 studs (de First_Donations/Workspace/IslaCentralVerde.rbxm) |
| FirstDonations_PiedrasNormalesFuera.rbxm | FirstDonations | 3 | non | Décor, 8x0x7 studs (de First_Donations/Workspace/IslaCentralVerde.rbxm) |
| FirstDonations_PisoBordeGris.rbxm | FirstDonations | 7 | non | Décor, 275x0x272 studs (de First_Donations/Workspace/IslaCentralVerde.rbxm) |
| FirstDonations_PisoIsla.rbxm | FirstDonations | 2 | non | Décor, 854x21x853 studs (de First_Donations/Workspace/IslaCentralVerde.rbxm) |
| FirstDonations_PisoLineasUniones.rbxm | FirstDonations | 2 | non | Décor, 854x146x854 studs (de First_Donations/Workspace/IslaCentralVerde.rbxm) |
| FirstDonations_Publicidad.rbxm | FirstDonations | 30 | non | Décor, 8 particules/effets, SurfaceGui/Billboard, 94x61x110 studs (de First_Donations/Workspace/IslaCentralVerde.rbxm) |
| FirstDonations_Rocas.rbxm | FirstDonations | 3 | non | Décor, 19x4x23 studs (de First_Donations/Workspace/IslaCentralVerde.rbxm) |
| FirstDonations_Silla.rbxm | FirstDonations | 32 | non | Décor, 9x6x15 studs (de First_Donations/Workspace/IslaCentralVerde.rbxm) |
| FirstDonations_Subidas.rbxm | FirstDonations | 3 | non | Décor, 169x1x185 studs (de First_Donations/Workspace/IslaCentralVerde.rbxm) |
| FirstDonations_TopDonacionesGame.rbxm | FirstDonations | 6 | non | Décor, 13x23x17 studs (de First_Donations/Workspace/IslaCentralVerde.rbxm) |
| FirstDonations_TopRecibidos.rbxm | FirstDonations | 6 | non | Décor, 17x23x13 studs (de First_Donations/Workspace/IslaCentralVerde.rbxm) |
| FirstDonations_TopTiempo.rbxm | FirstDonations | 6 | non | Décor, 17x16x13 studs (de First_Donations/Workspace/IslaCentralVerde.rbxm) |
| GlassBridge_Paint.rbxm | GlassBridge | 15 | oui (7) | Décor, 1x10x29 studs (de GlassBridge/Workspace/Paint.rbxm) |
| GlassBridge_PalmTree.rbxm | GlassBridge | 9 | non | Décor, 16x18x16 studs (de GlassBridge/Workspace/Palm Tree.rbxm) |
| GlassBridge_SwingSet.rbxm | GlassBridge | 21 | non | Décor, ancrage d’origine conservé, 5x15x17 studs (de GlassBridge/Workspace/SwingSet.rbxm) |
| GlassBridge_Trampoline.rbxm | GlassBridge | 93 | oui (1) | Décor, 19x14x20 studs (de GlassBridge/Workspace/Trampoline.rbxm) |
| HatchingSim_Clouds.rbxm | HatchingSim | 8 | non | Décor, 742x70x654 studs (de HatchingSimulator/Workspace/World.rbxm) |
| HatchingSim_CloudSteps.rbxm | HatchingSim | 21 | non | Décor, 42x105x36 studs (de HatchingSimulator/Workspace/World.rbxm) |
| HatchingSim_EnchantingStation.rbxm | HatchingSim | 8 | oui (1) | Décor, 16x25x16 studs (de HatchingSimulator/Workspace/World.rbxm) |
| HatchingSim_Grass.rbxm | HatchingSim | 3 | non | Décor, 5x3x5 studs (de HatchingSimulator/Workspace/World.rbxm) |
| HatchingSim_Hill.rbxm | HatchingSim | 2 | non | Décor, 22x6x20 studs (de HatchingSimulator/Workspace/World.rbxm) |
| HatchingSim_HugeHill.rbxm | HatchingSim | 6 | non | Décor, 38x24x42 studs (de HatchingSimulator/Workspace/World.rbxm) |
| HatchingSim_MarsMountains.rbxm | HatchingSim | 71 | non | Décor, 528x71x503 studs (de HatchingSimulator/Workspace/World.rbxm) |
| HatchingSim_MarsRocket.rbxm | HatchingSim | 10 | non | Décor, SurfaceGui/Billboard, 50x29x50 studs (de HatchingSimulator/Workspace/World.rbxm) |
| HatchingSim_MoonHill.rbxm | HatchingSim | 2 | non | Décor, 22x6x20 studs (de HatchingSimulator/Workspace/World.rbxm) |
| HatchingSim_MoonTree.rbxm | HatchingSim | 3 | non | Décor, 27x31x15 studs (de HatchingSimulator/Workspace/World.rbxm) |
| HatchingSim_Mountain.rbxm | HatchingSim | 6 | non | Décor, 74x47x68 studs (de HatchingSimulator/Workspace/World.rbxm) |
| HatchingSim_Mountains.rbxm | HatchingSim | 6 | non | Décor, 57x49x63 studs (de HatchingSimulator/Workspace/World.rbxm) |
| HatchingSim_OverworldRocket.rbxm | HatchingSim | 10 | non | Décor, SurfaceGui/Billboard, 50x29x50 studs (de HatchingSimulator/Workspace/World.rbxm) |
| HatchingSim_Rocks.rbxm | HatchingSim | 11 | non | Décor, 577x7x283 studs (de HatchingSimulator/Workspace/World.rbxm) |
| HatchingSim_Rocks_2.rbxm | HatchingSim | 7 | non | Décor, 361x54x226 studs (de HatchingSimulator/Workspace/World.rbxm) |
| HatchingSim_Spikes.rbxm | HatchingSim | 6 | non | Décor, 294x43x250 studs (de HatchingSimulator/Workspace/World.rbxm) |
| HatchingSim_StoneMountains.rbxm | HatchingSim | 71 | non | Décor, 949x128x904 studs (de HatchingSimulator/Workspace/World.rbxm) |
| HatchingSim_Top.rbxm | HatchingSim | 71 | non | Décor, 759x63x723 studs (de HatchingSimulator/Workspace/World.rbxm) |
| HatchingSim_Tree.rbxm | HatchingSim | 3 | non | Décor, 22x31x30 studs (de HatchingSimulator/Workspace/World.rbxm) |
| HatchingSim_Unnamed.rbxm | HatchingSim | 8 | non | Décor, SurfaceGui/Billboard, 20x18x20 studs (de HatchingSimulator/Workspace/World.rbxm) |
| Lib_BlueMush.rbxm | Lib | 2 | non | Décor, 3x3x3 studs (de VFX/PluginAssets_VFX.rbxm) |
| Lib_fountain.rbxm | Lib | 1 | non | Décor, 9x10x9 studs (de VFX/PluginAssets_VFX.rbxm) |
| Lib_Grass.rbxm | Lib | 1 | non | Décor, 4x4x4 studs (de VFX/PluginAssets_VFX.rbxm) |
| Lib_GroundGrassPart.rbxm | Lib | 1 | non | Décor, 4x2x0 studs (de VFX/PluginAssets_VFX.rbxm) |
| Lib_LightPost.rbxm | Lib | 4 | non | Décor, 2x9x5 studs (de VFX/PluginAssets_VFX.rbxm) |
| Lib_OrangeMush.rbxm | Lib | 2 | non | Décor, 3x3x3 studs (de VFX/PluginAssets_VFX.rbxm) |
| Lib_RedMush.rbxm | Lib | 2 | non | Décor, 3x3x3 studs (de VFX/PluginAssets_VFX.rbxm) |
| Lib_Rock.rbxm | Lib | 1 | non | Décor, 66x72x77 studs (de VFX/PluginAssets_VFX.rbxm) |
| MagnetSim2_Cloud.rbxm | MagnetSim2 | 1 | non | Décor, 34x6x23 studs (de UNCOPYLOCKED-Magnet-Simulator-2/Workspace/Skys.rbxm) |
| MagnetSim2_Grass.rbxm | MagnetSim2 | 363 | non | Décor, SurfaceGui/Billboard, 742x368x738 studs (de UNCOPYLOCKED-Magnet-Simulator-2/Workspace/Locations.rbxm) |
| MagnetSim2_Grass_2.rbxm | MagnetSim2 | 13 | non | Décor, 418x1x322 studs (de UNCOPYLOCKED-Magnet-Simulator-2/Workspace/Spawners.rbxm) |
| MagnetSim2_Ice.rbxm | MagnetSim2 | 26 | non | Décor, 341x1x341 studs (de UNCOPYLOCKED-Magnet-Simulator-2/Workspace/Spawners.rbxm) |
| MagnetSim2_Island.rbxm | MagnetSim2 | 6 | non | Décor, 144x78x173 studs (de UNCOPYLOCKED-Magnet-Simulator-2/Workspace/Skys.rbxm) |
| MagnetSim2_Sand.rbxm | MagnetSim2 | 14 | non | Décor, 473x1x450 studs (de UNCOPYLOCKED-Magnet-Simulator-2/Workspace/Spawners.rbxm) |
| MagnetSim2_Skys.rbxm | MagnetSim2 | 56 | non | Décor, 241x1467x283 studs (de UNCOPYLOCKED-Magnet-Simulator-2/Workspace/Skys.rbxm) |
| MagnetSim2_Skys_Model.rbxm | MagnetSim2 | 56 | non | Décor, 283x1467x241 studs (de UNCOPYLOCKED-Magnet-Simulator-2/Workspace/Skys.rbxm) |
| MagnetSim2_Skys_Model_2.rbxm | MagnetSim2 | 13 | non | Décor, 173x78x220 studs (de UNCOPYLOCKED-Magnet-Simulator-2/Workspace/Skys.rbxm) |
| MagnetSim2_Trampoline.rbxm | MagnetSim2 | 44 | non | Décor, 219x830x173 studs (de UNCOPYLOCKED-Magnet-Simulator-2/Workspace/Skys.rbxm) |
| MiningMasters_Areas.rbxm | MiningMasters | 10 | non | Décor, 795x139x2670 studs (de Mining-Masters/Workspace/Areas.rbxm) |
| MiningMasters_DeadTree.rbxm | MiningMasters | 1 | non | Décor, 10x24x6 studs (de Mining-Masters/Brushtool2_Plugin_Storage.rbxm) |
| MiningMasters_RandomModels_Model.rbxm | MiningMasters | 8 | non | Décor, 4x27x33 studs (de Mining-Masters/Workspace/RandomModels.rbxm) |
| MiningMasters_RandomModels_Model_2.rbxm | MiningMasters | 4 | non | Décor, 3x18x3 studs (de Mining-Masters/Workspace/RandomModels.rbxm) |
| MiningMasters_RandomModels_Model_3.rbxm | MiningMasters | 7 | non | Décor, 3x28x33 studs (de Mining-Masters/Workspace/RandomModels.rbxm) |
| MiningMasters_RandomModels_Model_4.rbxm | MiningMasters | 3 | non | Décor, 23x36x24 studs (de Mining-Masters/Workspace/RandomModels.rbxm) |
| MiningMasters_RandomModels_Model_5.rbxm | MiningMasters | 5 | non | Décor, 26x52x25 studs (de Mining-Masters/Workspace/RandomModels.rbxm) |
| MiningMasters_RandomModels_Model_6.rbxm | MiningMasters | 32 | non | Décor, 22x26x29 studs (de Mining-Masters/Workspace/RandomModels.rbxm) |
| MiningMasters_randomparts.rbxm | MiningMasters | 73 | non | Décor, SurfaceGui/Billboard, 849x184x2434 studs (de Mining-Masters/Workspace/randomparts.rbxm) |
| MiningMasters_SpawnWIP.rbxm | MiningMasters | 14 | non | Décor, 712x40x322 studs (de Mining-Masters/Workspace/World1.rbxm) |
| MiningMasters_spike.rbxm | MiningMasters | 1 | non | Décor, 5x9x4 studs (de Mining-Masters/Workspace/RandomModels.rbxm) |
| MiningMasters_TexturePack.rbxm | MiningMasters | 185 | non | Décor, 161x51x99 studs (de Mining-Masters/TexturePack.rbxm) |
| MiningMasters_Unused.rbxm | MiningMasters | 48 | non | Décor, SurfaceGui/Billboard, 651x741x2120 studs (de Mining-Masters/Unused.rbxm) |
| PetPharmica_1Spawn_Model.rbxm | PetPharmica | 48 | non | Décor, 3 particules/effets, 97x371x105 studs (de Pet_Pharmica_1_1/Workspace/Areas.rbxm) |
| PetPharmica_1Spawn_Model_2.rbxm | PetPharmica | 20 | non | Décor, 3 particules/effets, 160x149x135 studs (de Pet_Pharmica_1_1/Workspace/Areas.rbxm) |
| PetPharmica_1Spawn_Model_3.rbxm | PetPharmica | 21 | oui (21) | Décor, SurfaceGui/Billboard, 20x25x7 studs (de Pet_Pharmica_1_1/Workspace/Areas.rbxm) |
| PetPharmica_Background_Model.rbxm | PetPharmica | 61 | non | Décor, 51x71x21 studs (de Pet_Pharmica_1_1/Workspace/Areas.rbxm) |
| PetPharmica_Background_Model_2.rbxm | PetPharmica | 53 | non | Décor, 51x59x20 studs (de Pet_Pharmica_1_1/Workspace/Areas.rbxm) |
| PetPharmica_Background_Model_3.rbxm | PetPharmica | 80 | non | Décor, 45x71x23 studs (de Pet_Pharmica_1_1/Workspace/Areas.rbxm) |
| PetPharmica_Background_Model_4.rbxm | PetPharmica | 62 | non | Décor, 51x82x18 studs (de Pet_Pharmica_1_1/Workspace/Areas.rbxm) |
| PetPharmica_Bush.rbxm | PetPharmica | 2 | non | Décor, 20x17x20 studs (de Pet_Pharmica_1_1/Workspace/Areas.rbxm) |
| PetPharmica_CrystalCluster.rbxm | PetPharmica | 3 | non | Décor, 19x23x20 studs (de Pet_Pharmica_1_1/Workspace/Areas.rbxm) |
| PetPharmica_FantasyPine.rbxm | PetPharmica | 6 | non | Décor, 32x55x32 studs (de Pet_Pharmica_1_1/Workspace/Areas.rbxm) |
| PetPharmica_Flowers_Model.rbxm | PetPharmica | 3 | non | Décor, 1x2x1 studs (de Pet_Pharmica_1_1/Workspace/Flowers.rbxm) |
| PetPharmica_HillWithQuicksilver.rbxm | PetPharmica | 19 | non | Décor, 48x43x48 studs (de Pet_Pharmica_1_1/Workspace/Hill With Quicksilver.rbxm) |
| PetPharmica_LayeredIslandPlatform.rbxm | PetPharmica | 2 | non | Décor, 137x11x137 studs (de Pet_Pharmica_1_1/Workspace/Areas.rbxm) |
| PetPharmica_MakeRainbow.rbxm | PetPharmica | 49 | oui (15) | Décor, 8 particules/effets, SurfaceGui/Billboard, 65x65x32 studs (de Pet_Pharmica_1_1/Workspace/Areas.rbxm) |
| PetPharmica_Promo.rbxm | PetPharmica | 7 | non | Décor, SurfaceGui/Billboard, 21x15x5 studs (de Pet_Pharmica_1_1/Workspace/Areas.rbxm) |
| PetPharmica_Rock.rbxm | PetPharmica | 2 | non | Décor, 35x31x35 studs (de Pet_Pharmica_1_1/Workspace/Areas.rbxm) |
| PetPharmica_Tree.rbxm | PetPharmica | 7 | non | Décor, 97x99x98 studs (de Pet_Pharmica_1_1/Workspace/Areas.rbxm) |
| PunchSim_Arrow.rbxm | PunchSim | 1 | non | Décor, 5x1x4 studs (de Punch Simulator/Assets.rbxm) |
| PunchSim_Beach.rbxm | PunchSim | 13 | non | Décor, 540x226x1131 studs (de Punch Simulator/Workspace/Beach.rbxm) |
| PunchSim_Crown.rbxm | PunchSim | 5 | non | Décor, SurfaceGui/Billboard, 17x8x16 studs (de Punch Simulator/Workspace/__MAP.rbxm) |
| PunchSim_DiscordVerification.rbxm | PunchSim | 7 | non | Décor, 4 particules/effets, SurfaceGui/Billboard, 34x17x34 studs (de Punch Simulator/Workspace/__MAP.rbxm) |
| PunchSim_Electro_Spirit.rbxm | PunchSim | 6 | non | Décor, 1 particules/effets, SurfaceGui/Billboard, 27x19x26 studs (de Punch Simulator/Workspace/__MAP.rbxm) |
| PunchSim_Quests.rbxm | PunchSim | 43 | non | Décor, SurfaceGui/Billboard, 36x17x36 studs (de Punch Simulator/Workspace/__MAP.rbxm) |
| PunchSim_TexturePack.rbxm | PunchSim | 417 | non | Décor, 180x1x189 studs (de Punch Simulator/Texture Pack.rbxm) |
| PunchSim_TrainingAreas_1.rbxm | PunchSim | 90 | non | Décor, Humanoid, SurfaceGui/Billboard, ancrage d’origine conservé, 33x26x39 studs (de Punch Simulator/Workspace/__MAP.rbxm) |
| PunchSim_TrainingAreas_2.rbxm | PunchSim | 35 | non | Décor, 4 particules/effets, SurfaceGui/Billboard, 128x51x114 studs (de Punch Simulator/Workspace/__MAP.rbxm) |
| PunchSim_TrainingAreas_3.rbxm | PunchSim | 8 | non | Décor, SurfaceGui/Billboard, 50x30x46 studs (de Punch Simulator/Workspace/__MAP.rbxm) |
| PunchSim_TrainingAreas_4.rbxm | PunchSim | 32 | non | Décor, 1 particules/effets, SurfaceGui/Billboard, 105x41x66 studs (de Punch Simulator/Workspace/__MAP.rbxm) |
| PunchSim_TrainingAreas_5.rbxm | PunchSim | 3 | non | Décor, SurfaceGui/Billboard, 138x132x138 studs (de Punch Simulator/Workspace/__MAP.rbxm) |
| PunchSim_TrainingAreas_6.rbxm | PunchSim | 34 | non | Décor, 6 particules/effets, SurfaceGui/Billboard, 140x161x119 studs (de Punch Simulator/Workspace/__MAP.rbxm) |
| PunchSim_TrainingAreas_7.rbxm | PunchSim | 5 | non | Décor, SurfaceGui/Billboard, 128x189x132 studs (de Punch Simulator/Workspace/__MAP.rbxm) |
| PunchSim_Volcano.rbxm | PunchSim | 38 | non | Décor, 7 particules/effets, 382x214x456 studs (de Punch Simulator/Workspace/Volcano.rbxm) |
| RebirthChampionsX_12Void.rbxm | RebirthChampionsX | 41 | non | Décor, 190x77x170 studs (de Rebirth Champions X/Workspace/Maps.rbxm) |
| RebirthChampionsX_5Winter.rbxm | RebirthChampionsX | 11 | non | Décor, variantes source: , 19x28x18 studs (de Rebirth Champions X/Workspace/Maps.rbxm) |
| RebirthChampionsX_9Magic.rbxm | RebirthChampionsX | 27 | non | Décor, 208x124x196 studs (de Rebirth Champions X/Workspace/Maps.rbxm) |
| RebirthChampionsX_Barrel1.rbxm | RebirthChampionsX | 5 | non | Décor, 6x5x6 studs (de Rebirth Champions X/Workspace/Maps.rbxm) |
| RebirthChampionsX_BasicTree01.rbxm | RebirthChampionsX | 3 | non | Décor, 41x52x27 studs (de Rebirth Champions X/Workspace/Maps.rbxm) |
| RebirthChampionsX_Bush2.rbxm | RebirthChampionsX | 4 | non | Décor, 11x5x8 studs (de Rebirth Champions X/Workspace/Maps.rbxm) |
| RebirthChampionsX_Cube.rbxm | RebirthChampionsX | 6 | non | Décor, 47x46x46 studs (de Rebirth Champions X/Workspace/Maps.rbxm) |
| RebirthChampionsX_Decor.rbxm | RebirthChampionsX | 465 | non | Décor, 104 particules/effets, 251x43x123 studs (de Rebirth Champions X/Workspace/Maps.rbxm) |
| RebirthChampionsX_Dirt.rbxm | RebirthChampionsX | 35 | non | Décor, 200x38x121 studs (de Rebirth Champions X/Workspace/Maps.rbxm) |
| RebirthChampionsX_Easter_Model.rbxm | RebirthChampionsX | 26 | non | Décor, 152x6x91 studs (de Rebirth Champions X/Workspace/Maps.rbxm) |
| RebirthChampionsX_Easter_Model_2.rbxm | RebirthChampionsX | 27 | non | Décor, 151x6x71 studs (de Rebirth Champions X/Workspace/Maps.rbxm) |
| RebirthChampionsX_Easter_Model_3.rbxm | RebirthChampionsX | 23 | non | Décor, 898x164x874 studs (de Rebirth Champions X/Workspace/Maps.rbxm) |
| RebirthChampionsX_EasterPass.rbxm | RebirthChampionsX | 3 | non | Décor, SurfaceGui/Billboard, 17x1x17 studs (de Rebirth Champions X/Workspace/Scripts.rbxm) |
| RebirthChampionsX_FiberRope.rbxm | RebirthChampionsX | 11 | non | Décor, 1x4x6 studs (de Rebirth Champions X/Workspace/Maps.rbxm) |
| RebirthChampionsX_Flower01.rbxm | RebirthChampionsX | 2 | non | Décor, 7x0x7 studs (de Rebirth Champions X/Workspace/Maps.rbxm) |
| RebirthChampionsX_Flower01_2.rbxm | RebirthChampionsX | 4 | non | Décor, 15x14x15 studs (de Rebirth Champions X/Workspace/Maps.rbxm) |
| RebirthChampionsX_Flower02.rbxm | RebirthChampionsX | 2 | non | Décor, 5x0x5 studs (de Rebirth Champions X/Workspace/Maps.rbxm) |
| RebirthChampionsX_Flower03.rbxm | RebirthChampionsX | 2 | non | Décor, 10x1x10 studs (de Rebirth Champions X/Workspace/Maps.rbxm) |
| RebirthChampionsX_Grass.rbxm | RebirthChampionsX | 49 | non | Décor, 201x37x114 studs (de Rebirth Champions X/Workspace/Maps.rbxm) |
| RebirthChampionsX_Mushroom.rbxm | RebirthChampionsX | 2 | non | Décor, 2x3x2 studs (de Rebirth Champions X/Workspace/Maps.rbxm) |
| RebirthChampionsX_Mushroom01.rbxm | RebirthChampionsX | 2 | non | Décor, 2x4x2 studs (de Rebirth Champions X/Workspace/Maps.rbxm) |
| RebirthChampionsX_Mushroom02.rbxm | RebirthChampionsX | 4 | non | Décor, 4x4x2 studs (de Rebirth Champions X/Workspace/Maps.rbxm) |
| RebirthChampionsX_Mushroom04.rbxm | RebirthChampionsX | 4 | non | Décor, 3x2x2 studs (de Rebirth Champions X/Workspace/Maps.rbxm) |
| RebirthChampionsX_Mushroom06.rbxm | RebirthChampionsX | 4 | non | Décor, 2x3x2 studs (de Rebirth Champions X/Workspace/Maps.rbxm) |
| RebirthChampionsX_Mushroom07.rbxm | RebirthChampionsX | 4 | non | Décor, 6x6x6 studs (de Rebirth Champions X/Workspace/Maps.rbxm) |
| RebirthChampionsX_PineTree02.rbxm | RebirthChampionsX | 3 | non | Décor, 16x46x17 studs (de Rebirth Champions X/Workspace/Maps.rbxm) |
| RebirthChampionsX_Rocks.rbxm | RebirthChampionsX | 361 | non | Décor, 266x64x172 studs (de Rebirth Champions X/Workspace/Maps.rbxm) |
| RebirthChampionsX_Shinies.rbxm | RebirthChampionsX | 50 | non | Décor, 197x20x147 studs (de Rebirth Champions X/Workspace/Maps.rbxm) |
| RebirthChampionsX_Stump.rbxm | RebirthChampionsX | 2 | non | Décor, 5x2x5 studs (de Rebirth Champions X/Workspace/Maps.rbxm) |
| RebirthChampionsX_Suffixes.rbxm | RebirthChampionsX | 5 | non | Décor, SurfaceGui/Billboard, 12x10x9 studs (de Rebirth Champions X/Workspace/Maps.rbxm) |
| RebirthChampionsX_ThreeDTextObject.rbxm | RebirthChampionsX | 6 | non | Décor, 4x2x1 studs (de Rebirth Champions X/Workspace/Maps.rbxm) |
| RebirthChampionsX_ThreeDTextObject_2.rbxm | RebirthChampionsX | 7 | non | Décor, 3x1x3 studs (de Rebirth Champions X/Workspace/Maps.rbxm) |
| RebirthChampionsX_Trunk01.rbxm | RebirthChampionsX | 2 | non | Décor, 9x5x7 studs (de Rebirth Champions X/Workspace/Maps.rbxm) |
| RebirthChampionsX_Well.rbxm | RebirthChampionsX | 37 | non | Décor, 8x11x9 studs (de Rebirth Champions X/Workspace/Maps.rbxm) |
| RebirthChampionsX_woda.rbxm | RebirthChampionsX | 3 | non | Décor, 235x1x245 studs (de Rebirth Champions X/Workspace/Maps.rbxm) |
| RobotSim_Box.rbxm | RobotSim | 17 | non | Décor, 6x8x6 studs (de Robot Simulator/Box.rbxm) |
| RobotSim_Cam_Statue.rbxm | RobotSim | 8 | non | Décor, Humanoid, ancrage d’origine conservé, 6x22x17 studs (de Robot Simulator/Workspace/Map.rbxm) |
| RobotSim_CogPlat.rbxm | RobotSim | 2 | non | Décor, 14x1x14 studs (de Robot Simulator/Workspace/Map.rbxm) |
| RobotSim_ConstructionArea.rbxm | RobotSim | 36 | non | Décor, 79x6x88 studs (de Robot Simulator/Workspace/Map.rbxm) |
| RobotSim_ConstructionSite2.rbxm | RobotSim | 25 | non | Décor, 81x11x71 studs (de Robot Simulator/Workspace/Map.rbxm) |
| RobotSim_Flag.rbxm | RobotSim | 11 | non | Décor, SurfaceGui/Billboard, 19x37x19 studs (de Robot Simulator/Workspace/Flags.rbxm) |
| RobotSim_GalaticPineTree.rbxm | RobotSim | 2 | non | Décor, 16x34x16 studs (de Robot Simulator/Workspace/Map.rbxm) |
| RobotSim_Hexagon.rbxm | RobotSim | 6 | non | Décor, 24x2x27 studs (de Robot Simulator/OLD_THINGS.rbxm) |
| RobotSim_IslandWater.rbxm | RobotSim | 4 | non | Décor, 195x5x206 studs (de Robot Simulator/Workspace/Map.rbxm) |
| RobotSim_KingHill.rbxm | RobotSim | 26 | non | Décor, 106x91x124 studs (de Robot Simulator/Workspace/Map.rbxm) |
| RobotSim_Kingofthehillareatext.rbxm | RobotSim | 2 | non | Décor, 28x0x28 studs (de Robot Simulator/Workspace/KingOfTheRobots.rbxm) |
| RobotSim_KIngPersonText.rbxm | RobotSim | 1 | non | Décor, SurfaceGui/Billboard, 2x2x2 studs (de Robot Simulator/Workspace/KingOfTheRobots.rbxm) |
| RobotSim_LampPost.rbxm | RobotSim | 4 | non | Décor, 3x13x7 studs (de Robot Simulator/Workspace/Map.rbxm) |
| RobotSim_MiniHill.rbxm | RobotSim | 26 | non | Décor, 87x26x143 studs (de Robot Simulator/Workspace/Map.rbxm) |
| RobotSim_Mountain.rbxm | RobotSim | 8 | non | Décor, 69x75x67 studs (de Robot Simulator/Workspace/Map.rbxm) |
| RobotSim_Mountain_Model.rbxm | RobotSim | 176 | non | Décor, 38x21x37 studs (de Robot Simulator/Workspace/Map.rbxm) |
| RobotSim_Mountainplace.rbxm | RobotSim | 81 | non | Décor, 157x97x158 studs (de Robot Simulator/Workspace/Map.rbxm) |
| RobotSim_MovingPlatformModel.rbxm | RobotSim | 4 | oui (1) | Décor, ancrage d’origine conservé, 38x1x31 studs (de Robot Simulator/Bridge_Icey.rbxm) |
| RobotSim_Platforms.rbxm | RobotSim | 2 | non | Décor, 33x1x38 studs (de Robot Simulator/OLD_THINGS.rbxm) |
| RobotSim_Rocks.rbxm | RobotSim | 69 | non | Décor, 901x216x974 studs (de Robot Simulator/Workspace/Map.rbxm) |
| RobotSim_SellSpawns.rbxm | RobotSim | 8 | non | Décor, 2117x3152x2313 studs (de Robot Simulator/Workspace/Map.rbxm) |
| RobotSim_SpawnItems.rbxm | RobotSim | 21 | non | Décor, 5x5x37 studs (de Robot Simulator/SpawnItems.rbxm) |
| RobotSim_TesterBox.rbxm | RobotSim | 18 | non | Décor, 8x11x10 studs (de Robot Simulator/TesterBox.rbxm) |
| RobotSim_Tree.rbxm | RobotSim | 2 | non | Décor, 16x34x16 studs (de Robot Simulator/Workspace/Map.rbxm) |
| RobotSim_Tree2.rbxm | RobotSim | 2 | non | Décor, 20x39x18 studs (de Robot Simulator/Workspace/Map.rbxm) |
| RobotSim_TropicalIsland.rbxm | RobotSim | 2 | non | Décor, 57x20x95 studs (de Robot Simulator/Workspace/Map.rbxm) |
| RobotSim_WaterParts.rbxm | RobotSim | 12 | non | Décor, 6139x81x8173 studs (de Robot Simulator/Workspace/Map.rbxm) |
| ShootABrainrot_Hills.rbxm | ShootABrainrot | 40 | non | Décor, 289x66x459 studs (de ShootABrainrotEU/Workspace/Main.rbxm) |
| ShootABrainrot_Log.rbxm | ShootABrainrot | 2 | non | Décor, 8x2x6 studs (de ShootABrainrotEU/Workspace/Main.rbxm) |
| ShootABrainrot_Rock.rbxm | ShootABrainrot | 9 | non | Décor, 11x3x11 studs (de ShootABrainrotEU/Workspace/Main.rbxm) |
| ShootABrainrot_Trees_Model.rbxm | ShootABrainrot | 26 | non | Décor, 33x21x33 studs (de ShootABrainrotEU/Workspace/Main.rbxm) |
| TappingLords_GrassHill.rbxm | TappingLords | 2 | non | Décor, 42x27x44 studs (de Tapping-Lords-Simulator/Workspace/Meshes.rbxm) |
| TappingLords_Log.rbxm | TappingLords | 2 | non | Décor, SurfaceGui/Billboard, 5x4x17 studs (de Tapping-Lords-Simulator/Workspace/Logs.rbxm) |
| TappingLords_Mound.rbxm | TappingLords | 2 | non | Décor, 19x4x18 studs (de Tapping-Lords-Simulator/Workspace/Mound.rbxm) |
| TappingLords_Mountain.rbxm | TappingLords | 2 | non | Décor, 71x68x71 studs (de Tapping-Lords-Simulator/Workspace/Mountain.rbxm) |
| TappingLords_Rocks.rbxm | TappingLords | 19 | non | Décor, 496x139x429 studs (de Tapping-Lords-Simulator/Workspace/Rocks.rbxm) |
| TappingLords_Tree.rbxm | TappingLords | 5 | non | Décor, 35x43x16 studs (de Tapping-Lords-Simulator/Workspace/Trees.rbxm) |
| TappingLords_Tree_2.rbxm | TappingLords | 2 | non | Décor, 20x35x20 studs (de Tapping-Lords-Simulator/Workspace/Trees.rbxm) |
| TappingLords_WaterAssets.rbxm | TappingLords | 17 | non | Décor, 114x84x121 studs (de Tapping-Lords-Simulator/Workspace/WaterAssets.rbxm) |
| TrainingSim_Table.rbxm | TrainingSim | 6 | non | Décor, 6x3x8 studs (de TrainingSimulatorEU/Workspace/Table.rbxm) |
| TweetingSim_AreaB.rbxm | TweetingSim | 7 | non | Décor, 182x12x138 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Core.rbxm) |
| TweetingSim_AreaC.rbxm | TweetingSim | 6 | non | Décor, 188x8x156 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Core.rbxm) |
| TweetingSim_AreaD.rbxm | TweetingSim | 5 | non | Décor, 178x3x181 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Core.rbxm) |
| TweetingSim_AreaE.rbxm | TweetingSim | 6 | non | Décor, 204x8x191 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Core.rbxm) |
| TweetingSim_AreaF.rbxm | TweetingSim | 7 | non | Décor, 340x10x338 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Core.rbxm) |
| TweetingSim_AreaG.rbxm | TweetingSim | 6 | non | Décor, 158x3x204 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Core.rbxm) |
| TweetingSim_AreaH.rbxm | TweetingSim | 7 | non | Décor, 169x5x155 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Core.rbxm) |
| TweetingSim_Bubbles.rbxm | TweetingSim | 84 | non | Décor, 198x0x157 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Core.rbxm) |
| TweetingSim_Clouds.rbxm | TweetingSim | 58 | non | Décor, 315x2175x365 studs (de Tweeting-Simulator-UncopyLocked/Workspace/MinigameMap.rbxm) |
| TweetingSim_Crane.rbxm | TweetingSim | 5 | non | Décor, 75x40x65 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Core.rbxm) |
| TweetingSim_DesertIsland.rbxm | TweetingSim | 41 | non | Décor, 723x383x762 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Core.rbxm) |
| TweetingSim_GarbageTree.rbxm | TweetingSim | 2 | non | Décor, 75x92x91 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Core.rbxm) |
| TweetingSim_Grass.rbxm | TweetingSim | 47 | non | Décor, 649x95x1503 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Core.rbxm) |
| TweetingSim_Hills.rbxm | TweetingSim | 24 | non | Décor, 546x240x532 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Core.rbxm) |
| TweetingSim_Hills_2.rbxm | TweetingSim | 4 | non | Décor, 85x6x97 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Core.rbxm) |
| TweetingSim_Mountain.rbxm | TweetingSim | 2 | non | Décor, 56x67x65 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Core.rbxm) |
| TweetingSim_Mountain_2.rbxm | TweetingSim | 26 | non | Décor, 666x234x566 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Core.rbxm) |
| TweetingSim_Phone.rbxm | TweetingSim | 2 | non | Décor, 5x9x5 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Core.rbxm) |
| TweetingSim_Regions.rbxm | TweetingSim | 8 | oui (1) | Décor, 2195x103x3009 studs (de Tweeting-Simulator-UncopyLocked/Regions.rbxm) |
| TweetingSim_Saurus.rbxm | TweetingSim | 2 | non | Décor, 1 particules/effets, 41x39x40 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Core.rbxm) |
| TweetingSim_SavanaTree.rbxm | TweetingSim | 2 | non | Décor, 113x125x108 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Core.rbxm) |
| TweetingSim_Spawn.rbxm | TweetingSim | 8 | non | Décor, 53x1x63 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Core.rbxm) |
| TweetingSim_SunTree.rbxm | TweetingSim | 2 | non | Décor, 130x130x107 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Core.rbxm) |
| TweetingSim_TreeOfLife.rbxm | TweetingSim | 21 | non | Décor, 144x182x167 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Core.rbxm) |
| TweetingSim_Unique.rbxm | TweetingSim | 10 | non | Décor, 17x16x17 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Core.rbxm) |
| TweetingSim_WaterfallGrass.rbxm | TweetingSim | 59 | non | Décor, 344x29x326 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Core.rbxm) |

## Buildings

Dossier `ByType/Buildings/` — 65 objets.

| Fichier | Jeu | Pièces | Scripts | Description |
|---|---|---|---|---|
| 1HealthEverySecond_Barriers.rbxm | 1HealthEverySecond | 10 | non | Construction, 1338x39x108 studs (de 1HealthEverySecond/Workspace/Barriers.rbxm) |
| 1JumpEverySecond_Barrier.rbxm | 1JumpEverySecond | 11 | non | Construction, 265x20540x14 studs (de 1JumpEverySecond/Workspace/__MAP.rbxm) |
| 1JumpEverySecond_IlluminaTower.rbxm | 1JumpEverySecond | 16 | non | Construction, SurfaceGui/Billboard, 14x30780x265 studs (de 1JumpEverySecond/Workspace/__MAP.rbxm) |
| 1JumpEverySecond_Lift.rbxm | 1JumpEverySecond | 6 | non | Construction, 28x13x16 studs (de 1JumpEverySecond/Workspace/Lift.rbxm) |
| BakerySim_PathNodes.rbxm | BakerySim | 42 | non | Construction, 180x2x60 studs (de Bakery-Simulator/Workspace/PathNodes.rbxm) |
| BillionaireTycoon_Building1.rbxm | BillionaireTycoon | 9 | non | Construction, 71x23x90 studs (de Billionaire_Tycoon/Workspace/Building 1.rbxm) |
| BillionaireTycoon_House1a.rbxm | BillionaireTycoon | 186 | non | Construction, 40x28x33 studs (de Billionaire_Tycoon/Workspace/House1a.rbxm) |
| BillionaireTycoon_House1b.rbxm | BillionaireTycoon | 208 | non | Construction, 40x29x33 studs (de Billionaire_Tycoon/Workspace/House1b.rbxm) |
| BillionaireTycoon_House1c.rbxm | BillionaireTycoon | 191 | non | Construction, 40x28x33 studs (de Billionaire_Tycoon/Workspace/House 1c.rbxm) |
| BillionaireTycoon_House2a.rbxm | BillionaireTycoon | 186 | non | Construction, 40x28x33 studs (de Billionaire_Tycoon/Workspace/House2a.rbxm) |
| BillionaireTycoon_House2b.rbxm | BillionaireTycoon | 208 | non | Construction, 40x29x33 studs (de Billionaire_Tycoon/Workspace/House2b.rbxm) |
| BillionaireTycoon_House2c.rbxm | BillionaireTycoon | 191 | non | Construction, 40x28x33 studs (de Billionaire_Tycoon/Workspace/House2c.rbxm) |
| BillionaireTycoon_House3a.rbxm | BillionaireTycoon | 186 | non | Construction, 40x28x33 studs (de Billionaire_Tycoon/Workspace/House 3a.rbxm) |
| BillionaireTycoon_House3b.rbxm | BillionaireTycoon | 208 | non | Construction, 40x29x33 studs (de Billionaire_Tycoon/Workspace/House3b.rbxm) |
| BillionaireTycoon_House3c.rbxm | BillionaireTycoon | 191 | non | Construction, 40x28x33 studs (de Billionaire_Tycoon/Workspace/House3c.rbxm) |
| BillionaireTycoon_Road.rbxm | BillionaireTycoon | 69 | non | Construction, 512x3x635 studs (de Billionaire_Tycoon/Workspace/Road.rbxm) |
| CashgrabBridge_Fence.rbxm | CashgrabBridge | 11 | non | Construction, 1x4x16 studs (de CashgrabBridgeEU/Workspace/Fence.rbxm) |
| CashgrabBridge_Stage_2.rbxm | CashgrabBridge | 4 | non | Construction, 9x9x19 studs (de CashgrabBridgeEU/Workspace/Stage.rbxm) |
| GlassBridge_Bridge.rbxm | GlassBridge | 97 | non | Construction, 13x8x43 studs (de GlassBridge/Workspace/Bridge.rbxm) |
| HatchingSim_Fence.rbxm | HatchingSim | 3 | non | Construction, 2x7x10 studs (de HatchingSimulator/Workspace/World.rbxm) |
| HatchingSim_FrostBarriers_Model.rbxm | HatchingSim | 71 | non | Construction, 553x75x527 studs (de HatchingSimulator/Workspace/World.rbxm) |
| HatchingSim_GumdropWalls.rbxm | HatchingSim | 71 | non | Construction, 528x71x503 studs (de HatchingSimulator/Workspace/World.rbxm) |
| HatchingSim_MoonWalls.rbxm | HatchingSim | 71 | non | Construction, 528x71x503 studs (de HatchingSimulator/Workspace/World.rbxm) |
| HatchingSim_SecuredFence.rbxm | HatchingSim | 13 | non | Construction, 7x6x10 studs (de HatchingSimulator/Workspace/World.rbxm) |
| MiningMasters_CanopyTent.rbxm | MiningMasters | 9 | non | Construction, 16x15x16 studs (de Mining-Masters/Brushtool2_Plugin_Storage.rbxm) |
| MiningMasters_Doors.rbxm | MiningMasters | 9 | non | Construction, SurfaceGui/Billboard, 744x41x2265 studs (de Mining-Masters/Workspace/Doors.rbxm) |
| MiningMasters_Fences_Model.rbxm | MiningMasters | 5 | non | Construction, 1x7x15 studs (de Mining-Masters/Workspace/Fences.rbxm) |
| MiningMasters_Walls.rbxm | MiningMasters | 98 | non | Construction, 98 particules/effets, SurfaceGui/Billboard, 657x116x2479 studs (de Mining-Masters/Workspace/Walls.rbxm) |
| PetPharmica_Door.rbxm | PetPharmica | 9 | non | Construction, 22x57x213 studs (de Pet_Pharmica_1_1/Workspace/Areas.rbxm) |
| PetPharmica_Doors.rbxm | PetPharmica | 32 | non | Construction, 8 particules/effets, SurfaceGui/Billboard, 1228x129x3400 studs (de Pet_Pharmica_1_1/Workspace/Doors.rbxm) |
| PetPharmica_DoorsKeys.rbxm | PetPharmica | 8 | non | Construction, 1216x72x3237 studs (de Pet_Pharmica_1_1/Workspace/DoorsKeys.rbxm) |
| PetPharmica_JungleHouse.rbxm | PetPharmica | 25 | non | Construction, 38x34x38 studs (de Pet_Pharmica_1_1/Workspace/Jungle House.rbxm) |
| PetPharmica_OutDoor.rbxm | PetPharmica | 12 | non | Construction, 26x36x11 studs (de Pet_Pharmica_1_1/Workspace/OutDoor.rbxm) |
| PunchSim_FencePost.rbxm | PunchSim | 6 | non | Construction, 6x3x1 studs (de Punch Simulator/Fence Post.rbxm) |
| PunchSim_Pipe2.rbxm | PunchSim | 6 | non | Construction, 50x16x40 studs (de Punch Simulator/Workspace/Pipe2.rbxm) |
| PunchSim_Sandcastle.rbxm | PunchSim | 1 | non | Construction, 1 particules/effets, 46x38x48 studs (de Punch Simulator/Workspace/Sandcastle Poi.rbxm) |
| PunchSim_Stairs.rbxm | PunchSim | 45 | non | Construction, 296x194x213 studs (de Punch Simulator/Workspace/Stairs.rbxm) |
| RebirthChampionsX_Bridge.rbxm | RebirthChampionsX | 5 | non | Construction, 32x11x15 studs (de Rebirth Champions X/Workspace/Maps.rbxm) |
| RebirthChampionsX_Fence1.rbxm | RebirthChampionsX | 6 | non | Construction, 5x5x8 studs (de Rebirth Champions X/Workspace/Maps.rbxm) |
| RebirthChampionsX_Walls.rbxm | RebirthChampionsX | 8 | non | Construction, 263x240x246 studs (de Rebirth Champions X/Workspace/Maps.rbxm) |
| RebirthChampionsX_Walls_2.rbxm | RebirthChampionsX | 9 | non | Construction, 404x152x379 studs (de Rebirth Champions X/Workspace/Maps.rbxm) |
| RobotSim_Bridge.rbxm | RobotSim | 39 | non | Construction, 74x14x53 studs (de Robot Simulator/Workspace/Map.rbxm) |
| RobotSim_BridgeReelLEFT.rbxm | RobotSim | 2 | non | Construction, 54x52x43 studs (de Robot Simulator/Bridge_Icey.rbxm) |
| RobotSim_BridgeSideLEFT.rbxm | RobotSim | 24 | non | Construction, 37x0x32 studs (de Robot Simulator/Bridge_Icey.rbxm) |
| RobotSim_BridgeSideRIGHT.rbxm | RobotSim | 24 | non | Construction, 40x0x30 studs (de Robot Simulator/Bridge_Icey.rbxm) |
| RobotSim_BridgeStairSide1.rbxm | RobotSim | 10 | non | Construction, 15x6x14 studs (de Robot Simulator/Bridge_Icey.rbxm) |
| RobotSim_BridgeStairSide1_2.rbxm | RobotSim | 11 | non | Construction, 15x6x14 studs (de Robot Simulator/Bridge_Icey.rbxm) |
| RobotSim_BridgeStairSide2.rbxm | RobotSim | 11 | non | Construction, 15x6x14 studs (de Robot Simulator/Bridge_Icey.rbxm) |
| RobotSim_Center.rbxm | RobotSim | 29 | non | Construction, 201x10x175 studs (de Robot Simulator/Workspace/Map.rbxm) |
| RobotSim_FuturisticBuild.rbxm | RobotSim | 98 | non | Construction, 66x103x67 studs (de Robot Simulator/Workspace/Map.rbxm) |
| RobotSim_GearBridgeHOLDERS.rbxm | RobotSim | 12 | non | Construction, 46x7x41 studs (de Robot Simulator/Bridge_Icey.rbxm) |
| RobotSim_Paths_Model.rbxm | RobotSim | 42 | non | Construction, 377x8x336 studs (de Robot Simulator/Workspace/Map.rbxm) |
| RobotSim_Paths_Model_2.rbxm | RobotSim | 52 | non | Construction, 363x8x480 studs (de Robot Simulator/Workspace/Map.rbxm) |
| RobotSim_Pillars.rbxm | RobotSim | 4 | non | Construction, 10x41x12 studs (de Robot Simulator/Workspace/Map.rbxm) |
| ShootABrainrot_Barriers.rbxm | ShootABrainrot | 35 | non | Construction, 457x137x459 studs (de ShootABrainrotEU/Workspace/Main.rbxm) |
| ShootABrainrot_Bridge3.rbxm | ShootABrainrot | 94 | non | Construction, 160x28x33 studs (de ShootABrainrotEU/Workspace/Main.rbxm) |
| TappingLords_Path.rbxm | TappingLords | 28 | non | Construction, 747x75x1557 studs (de Tapping-Lords-Simulator/Workspace/Path.rbxm) |
| TweetingSim_Borders.rbxm | TweetingSim | 24 | non | Construction, 304x65x354 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Core.rbxm) |
| TweetingSim_Buildings_Model.rbxm | TweetingSim | 26 | non | Construction, 50x73x63 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Core.rbxm) |
| TweetingSim_DirtPaths.rbxm | TweetingSim | 12 | non | Construction, 197x2x254 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Core.rbxm) |
| TweetingSim_Floors.rbxm | TweetingSim | 15 | non | Construction, 229x26x204 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Core.rbxm) |
| TweetingSim_MapBorders.rbxm | TweetingSim | 66 | non | Construction, 2215x182x2783 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Core.rbxm) |
| TweetingSim_SunBuilding.rbxm | TweetingSim | 17 | non | Construction, 63x53x110 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Core.rbxm) |
| TweetingSim_SunBuilding_2.rbxm | TweetingSim | 24 | non | Construction, 206x117x218 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Core.rbxm) |
| TweetingSim_VerifiedBuilding.rbxm | TweetingSim | 46 | non | Construction, 72x40x59 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Core.rbxm) |

## Maps_Islands_Worlds

Dossier `ByType/Maps_Islands_Worlds/` — 75 objets.

| Fichier | Jeu | Pièces | Scripts | Description |
|---|---|---|---|---|
| 1HealthEverySecond___MAP.rbxm | 1HealthEverySecond | 1650 | oui (71) | Map / zone, 269 particules/effets, prompt/clic, SurfaceGui/Billboard, 1666x2470x3533 studs (de 1HealthEverySecond/Workspace/__MAP.rbxm) |
| 1HealthEverySecond_Gears.rbxm | 1HealthEverySecond | 162 | non | Map / zone, SurfaceGui/Billboard, 12x13x19 studs (de 1HealthEverySecond/Workspace/__MAP.rbxm) |
| 1HealthEverySecond_Zones.rbxm | 1HealthEverySecond | 777 | oui (14) | Map / zone, 16 particules/effets, SurfaceGui/Billboard, 1577x2470x3533 studs (de 1HealthEverySecond/Workspace/__MAP.rbxm) |
| 1JumpEverySecond_Barriers.rbxm | 1JumpEverySecond | 110 | non | Map / zone, 1179x20540x288 studs (de 1JumpEverySecond/Workspace/__MAP.rbxm) |
| 1JumpEverySecond_Borders.rbxm | 1JumpEverySecond | 128 | non | Map / zone, SurfaceGui/Billboard, 1252x30780x265 studs (de 1JumpEverySecond/Workspace/__MAP.rbxm) |
| 1JumpEverySecond_Towers.rbxm | 1JumpEverySecond | 401 | non | Map / zone, 4 particules/effets, SurfaceGui/Billboard, 1515x25611x305 studs (de 1JumpEverySecond/Workspace/__MAP.rbxm) |
| BakerySim_Map.rbxm | BakerySim | 1456 | oui (7) | Map / zone, Humanoid, 12 particules/effets, SurfaceGui/Billboard, ancrage d’origine conservé, 477x100x345 studs (de Bakery-Simulator/Workspace/Map.rbxm) |
| FirstDonations_IslaCentral.rbxm | FirstDonations | 1274 | oui (4) | Map / zone, Humanoid, 18 particules/effets, SurfaceGui/Billboard, ancrage d’origine conservé, 854x288x854 studs (de First_Donations/Workspace/IslaCentralVerde.rbxm) |
| HatchingSim_Candy.rbxm | HatchingSim | 122 | oui (1) | Map / zone, Humanoid, SurfaceGui/Billboard, ancrage d’origine conservé, 573x71x533 studs (de HatchingSimulator/Workspace/World.rbxm) |
| HatchingSim_Frosty.rbxm | HatchingSim | 199 | non | Map / zone, Humanoid, SurfaceGui/Billboard, ancrage d’origine conservé, 575x75x533 studs (de HatchingSimulator/Workspace/World.rbxm) |
| HatchingSim_Mars.rbxm | HatchingSim | 162 | oui (1) | Map / zone, Humanoid, SurfaceGui/Billboard, ancrage d’origine conservé, 573x71x533 studs (de HatchingSimulator/Workspace/World.rbxm) |
| HatchingSim_Moon.rbxm | HatchingSim | 225 | oui (2) | Map / zone, Humanoid, SurfaceGui/Billboard, ancrage d’origine conservé, 573x71x533 studs (de HatchingSimulator/Workspace/World.rbxm) |
| HatchingSim_Overworld.rbxm | HatchingSim | 765 | oui (4) | Map / zone, Humanoid, 1 particules/effets, SurfaceGui/Billboard, ancrage d’origine conservé, 1266x158x904 studs (de HatchingSimulator/Workspace/World.rbxm) |
| MagnetSim2_Ice.rbxm | MagnetSim2 | 330 | non | Map / zone, 1 particules/effets, SurfaceGui/Billboard, 1040x480x1021 studs (de UNCOPYLOCKED-Magnet-Simulator-2/Workspace/Locations.rbxm) |
| MagnetSim2_Main.rbxm | MagnetSim2 | 2116 | non | Map / zone, SurfaceGui/Billboard, 1020x1392x698 studs (de UNCOPYLOCKED-Magnet-Simulator-2/Workspace/Locations.rbxm) |
| MagnetSim2_Sand.rbxm | MagnetSim2 | 402 | non | Map / zone, SurfaceGui/Billboard, 692x329x894 studs (de UNCOPYLOCKED-Magnet-Simulator-2/Workspace/Locations.rbxm) |
| MiningMasters_assets.rbxm | MiningMasters | 946 | non | Map / zone, SurfaceGui/Billboard, 920x713x2961 studs (de Mining-Masters/Workspace/assets.rbxm) |
| MiningMasters_CaveZone.rbxm | MiningMasters | 169 | non | Map / zone, 813x97x2376 studs (de Mining-Masters/Workspace/World1.rbxm) |
| MiningMasters_DesertZone.rbxm | MiningMasters | 120 | non | Map / zone, 356x93x249 studs (de Mining-Masters/Workspace/World1.rbxm) |
| MiningMasters_HalloweenEvent.rbxm | MiningMasters | 498 | oui (1) | Map / zone, Humanoid, 45 particules/effets, SurfaceGui/Billboard, ancrage d’origine conservé, 1082x860x1996 studs (de Mining-Masters/Halloween Event.rbxm) |
| MiningMasters_PirateCoveZone.rbxm | MiningMasters | 88 | non | Map / zone, 344x108x243 studs (de Mining-Masters/Workspace/World1.rbxm) |
| MiningMasters_WinterZone.rbxm | MiningMasters | 72 | non | Map / zone, 300x102x244 studs (de Mining-Masters/Workspace/World1.rbxm) |
| PetPharmica_1Spawn_Model.rbxm | PetPharmica | 70 | oui (1) | Map / zone, SurfaceGui/Billboard, 4x23x14 studs (de Pet_Pharmica_1_1/Workspace/Areas.rbxm) |
| PetPharmica_2Desert.rbxm | PetPharmica | 205 | oui (1) | Map / zone, Humanoid, ancrage d’origine conservé, 306x293x426 studs (de Pet_Pharmica_1_1/Workspace/Areas.rbxm) |
| PetPharmica_2Mashed.rbxm | PetPharmica | 181 | non | Map / zone, 256x142x410 studs (de Pet_Pharmica_1_1/Workspace/Areas.rbxm) |
| PetPharmica_3Fall.rbxm | PetPharmica | 189 | non | Map / zone, Humanoid, ancrage d’origine conservé, 293x107x370 studs (de Pet_Pharmica_1_1/Workspace/Areas.rbxm) |
| PetPharmica_4Winter.rbxm | PetPharmica | 220 | non | Map / zone, 5 particules/effets, 289x108x339 studs (de Pet_Pharmica_1_1/Workspace/Areas.rbxm) |
| PetPharmica_5Forest.rbxm | PetPharmica | 552 | non | Map / zone, 297x87x343 studs (de Pet_Pharmica_1_1/Workspace/Areas.rbxm) |
| PetPharmica_6Atlantis.rbxm | PetPharmica | 267 | non | Map / zone, 1 particules/effets, 831x146x3428 studs (de Pet_Pharmica_1_1/Workspace/Areas.rbxm) |
| PetPharmica_GypsyArea.rbxm | PetPharmica | 71 | non | Map / zone, 49x11x32 studs (de Pet_Pharmica_1_1/Workspace/GypsyArea.rbxm) |
| PetPharmica_Limited.rbxm | PetPharmica | 1039 | oui (1) | Map / zone, 3 particules/effets, prompt/clic, SurfaceGui/Billboard, 1206x355x3412 studs (de Pet_Pharmica_1_1/Workspace/Areas.rbxm) |
| PetPharmica_Overworld.rbxm | PetPharmica | 2639 | oui (41) | Map / zone, Humanoid, 29 particules/effets, prompt/clic, SurfaceGui/Billboard, ancrage d’origine conservé, 1785x532x4629 studs (de Pet_Pharmica_1_1/Workspace/Areas.rbxm) |
| PetPharmica_OverworldSecret.rbxm | PetPharmica | 126 | oui (2) | Map / zone, 3 particules/effets, SurfaceGui/Billboard, 130x54x86 studs (de Pet_Pharmica_1_1/Workspace/Areas.rbxm) |
| PunchSim_TrainingAreas.rbxm | PunchSim | 237 | non | Map / zone, Humanoid, 11 particules/effets, SurfaceGui/Billboard, ancrage d’origine conservé, 1416x3951x12012 studs (de Punch Simulator/Workspace/__MAP.rbxm) |
| RebirthChampionsX_0Spawn.rbxm | RebirthChampionsX | 1572 | non | Map / zone, 1 particules/effets, 833x334x912 studs (de Rebirth Champions X/Workspace/Maps.rbxm) |
| RebirthChampionsX_10Heaven.rbxm | RebirthChampionsX | 112 | non | Map / zone, 215x174x186 studs (de Rebirth Champions X/Workspace/Maps.rbxm) |
| RebirthChampionsX_11Nuclear.rbxm | RebirthChampionsX | 112 | non | Map / zone, 221x146x197 studs (de Rebirth Champions X/Workspace/Maps.rbxm) |
| RebirthChampionsX_13Spooky.rbxm | RebirthChampionsX | 187 | non | Map / zone, 269x178x220 studs (de Rebirth Champions X/Workspace/Maps.rbxm) |
| RebirthChampionsX_14Crystal.rbxm | RebirthChampionsX | 1002 | non | Map / zone, 108 particules/effets, 275x64x172 studs (de Rebirth Champions X/Workspace/Maps.rbxm) |
| RebirthChampionsX_1Forest.rbxm | RebirthChampionsX | 500 | non | Map / zone, Humanoid, 1 particules/effets, ancrage d’origine conservé, 268x240x263 studs (de Rebirth Champions X/Workspace/Maps.rbxm) |
| RebirthChampionsX_2Beach.rbxm | RebirthChampionsX | 177 | non | Map / zone, 369x240x381 studs (de Rebirth Champions X/Workspace/Maps.rbxm) |
| RebirthChampionsX_3Atlantis.rbxm | RebirthChampionsX | 197 | non | Map / zone, 397x245x370 studs (de Rebirth Champions X/Workspace/Maps.rbxm) |
| RebirthChampionsX_4Desert.rbxm | RebirthChampionsX | 114 | non | Map / zone, prompt/clic, 358x241x333 studs (de Rebirth Champions X/Workspace/Maps.rbxm) |
| RebirthChampionsX_5Winter.rbxm | RebirthChampionsX | 229 | non | Map / zone, SurfaceGui/Billboard, 432x240x365 studs (de Rebirth Champions X/Workspace/Maps.rbxm) |
| RebirthChampionsX_6Volcano.rbxm | RebirthChampionsX | 397 | non | Map / zone, 392x240x392 studs (de Rebirth Champions X/Workspace/Maps.rbxm) |
| RebirthChampionsX_7Moon.rbxm | RebirthChampionsX | 133 | non | Map / zone, 517x143x447 studs (de Rebirth Champions X/Workspace/Maps.rbxm) |
| RebirthChampionsX_8Cyber.rbxm | RebirthChampionsX | 253 | non | Map / zone, 846x149x630 studs (de Rebirth Champions X/Workspace/Maps.rbxm) |
| RebirthChampionsX_8Cyber_Model.rbxm | RebirthChampionsX | 60 | non | Map / zone, 14x13x14 studs (de Rebirth Champions X/Workspace/Maps.rbxm) |
| RebirthChampionsX_Easter.rbxm | RebirthChampionsX | 1413 | non | Map / zone, 1 particules/effets, 898x336x874 studs (de Rebirth Champions X/Workspace/Maps.rbxm) |
| RobotSim_Boxes.rbxm | RobotSim | 85 | non | Map / zone, 11x9x13 studs (de Robot Simulator/Workspace/Map.rbxm) |
| RobotSim_Decoration.rbxm | RobotSim | 2562 | oui (2) | Map / zone, Humanoid, SurfaceGui/Billboard, ancrage d’origine conservé, 873x3250x690 studs (de Robot Simulator/Workspace/Map.rbxm) |
| RobotSim_Dungeonarea.rbxm | RobotSim | 1417 | non | Map / zone, 37x22x65 studs (de Robot Simulator/Dungeon area.rbxm) |
| RobotSim_Island1.rbxm | RobotSim | 291 | non | Map / zone, 233x41x224 studs (de Robot Simulator/Workspace/Island 1.rbxm) |
| RobotSim_Island2.rbxm | RobotSim | 288 | non | Map / zone, 233x41x224 studs (de Robot Simulator/Workspace/Island 2.rbxm) |
| RobotSim_Island3.rbxm | RobotSim | 124 | non | Map / zone, 4 particules/effets, SurfaceGui/Billboard, 233x38x224 studs (de Robot Simulator/Island 3.rbxm) |
| RobotSim_Island3_2.rbxm | RobotSim | 314 | non | Map / zone, 206x41x197 studs (de Robot Simulator/Workspace/Island 3.rbxm) |
| RobotSim_Island4.rbxm | RobotSim | 292 | non | Map / zone, 233x39x224 studs (de Robot Simulator/Workspace/Island 4.rbxm) |
| RobotSim_Island5.rbxm | RobotSim | 829 | non | Map / zone, 10 particules/effets, SurfaceGui/Billboard, 362x1031x530 studs (de Robot Simulator/Island5.rbxm) |
| RobotSim_IslandJumps.rbxm | RobotSim | 278 | non | Map / zone, 730x3044x577 studs (de Robot Simulator/Workspace/Map.rbxm) |
| RobotSim_Paths.rbxm | RobotSim | 133 | non | Map / zone, 566x10x625 studs (de Robot Simulator/Workspace/Map.rbxm) |
| ShootABrainrot_Map.rbxm | ShootABrainrot | 3860 | non | Map / zone, 22 particules/effets, 1000x137x1000 studs (de ShootABrainrotEU/Workspace/Main.rbxm) |
| ShootABrainrot_Others.rbxm | ShootABrainrot | 669 | non | Map / zone, 1000x34x1000 studs (de ShootABrainrotEU/Workspace/Main.rbxm) |
| ShootABrainrot_Plots.rbxm | ShootABrainrot | 204 | oui (1) | Map / zone, SurfaceGui/Billboard, 323x62x232 studs (de ShootABrainrotEU/Workspace/Main.rbxm) |
| TappingLords_ForestIsland.rbxm | TappingLords | 100 | non | Map / zone, 4 particules/effets, 427x99x427 studs (de Tapping-Lords-Simulator/Workspace/ForestIsland.rbxm) |
| TappingLords_LavaWorld.rbxm | TappingLords | 146 | non | Map / zone, 380x160x392 studs (de Tapping-Lords-Simulator/Workspace/Lava World.rbxm) |
| TappingLords_ToxicWorld.rbxm | TappingLords | 135 | non | Map / zone, 8 particules/effets, 413x138x429 studs (de Tapping-Lords-Simulator/Toxic World.rbxm) |
| TweetingSim_10kTweetsArea.rbxm | TweetingSim | 110 | non | Map / zone, 704x274x892 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Core.rbxm) |
| TweetingSim_AquaLand.rbxm | TweetingSim | 111 | non | Map / zone, 4 particules/effets, 943x482x1074 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Core.rbxm) |
| TweetingSim_CandyLand.rbxm | TweetingSim | 125 | non | Map / zone, 221x12x316 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Core.rbxm) |
| TweetingSim_CandyLand_2.rbxm | TweetingSim | 134 | non | Map / zone, 6 particules/effets, 1180x639x1240 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Core.rbxm) |
| TweetingSim_EggIncubators.rbxm | TweetingSim | 125 | non | Map / zone, SurfaceGui/Billboard, 34x15x74 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Core.rbxm) |
| TweetingSim_GarbageLand.rbxm | TweetingSim | 78 | non | Map / zone, 626x281x610 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Core.rbxm) |
| TweetingSim_Map.rbxm | TweetingSim | 2809 | non | Map / zone, 35 particules/effets, 2773x742x3275 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Core.rbxm) |
| TweetingSim_SunLand.rbxm | TweetingSim | 154 | non | Map / zone, 547x305x591 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Core.rbxm) |
| TweetingSim_TeleportersForSale.rbxm | TweetingSim | 88 | non | Map / zone, 12 particules/effets, 1997x82x2329 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Core.rbxm) |

## Vehicles

Dossier `ByType/Vehicles/` — 10 objets.

| Fichier | Jeu | Pièces | Scripts | Description |
|---|---|---|---|---|
| BakerySim_UFO.rbxm | BakerySim | 10 | oui (4) | Véhicule, 2 particules/effets, SurfaceGui/Billboard, 52x148x293 studs (de Bakery-Simulator/AlienInvasion.rbxm) |
| BakerySim_Vehicles.rbxm | BakerySim | 5 | non | Véhicule, 149x55x300 studs (de Bakery-Simulator/Assets.rbxm) |
| FirstDonations_DuneBuggybeige.rbxm | FirstDonations | 51 | oui (14) | Véhicule, 2 particules/effets, prompt/clic, SurfaceGui/Billboard, ancrage d’origine conservé, 17x7x9 studs (de First_Donations/Dune Buggy beige.rbxm) |
| GlassBridge_Helicopter.rbxm | GlassBridge | 12 | oui (3) | Véhicule, ancrage d’origine conservé, 6x9x29 studs (de GlassBridge/Helicopter.rbxm) |
| RebirthChampionsX_Ufo.rbxm | RebirthChampionsX | 8 | non | Véhicule, 36x17x36 studs (de Rebirth Champions X/Workspace/Maps.rbxm) |
| RobotSim_Boat.rbxm | RobotSim | 2 | non | Véhicule, 10x4x30 studs (de Robot Simulator/Workspace/Map.rbxm) |
| RobotSim_Rocket.rbxm | RobotSim | 867 | oui (1) | Véhicule, 15 particules/effets, prompt/clic, SurfaceGui/Billboard, ancrage d’origine conservé, 47x104x35 studs (de Robot Simulator/Workspace/Rocket.rbxm) |
| RobotSim_SailBoat.rbxm | RobotSim | 38 | non | Véhicule, Humanoid, ancrage d’origine conservé, 25x20x44 studs (de Robot Simulator/Sail Boat.rbxm) |
| TweetingSim_Rocket.rbxm | TweetingSim | 12 | non | Véhicule, 4 particules/effets, 25x20x32 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Core.rbxm) |
| TweetingSim_Submarine.rbxm | TweetingSim | 12 | non | Véhicule, 30x11x23 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Core.rbxm) |

## NPC_Characters

Dossier `ByType/NPC_Characters/` — 67 objets.

| Fichier | Jeu | Pièces | Scripts | Description |
|---|---|---|---|---|
| BakerySim_Dummy.rbxm | BakerySim | 16 | non | Personnage / NPC, Humanoid, ancrage d’origine conservé, 4x5x1 studs (de Bakery-Simulator/Assets.rbxm) |
| BakerySim_Dummy_2.rbxm | BakerySim | 18 | non | Personnage / NPC, Humanoid, ancrage d’origine conservé, 2x6x4 studs (de Bakery-Simulator/CustomerTypes.rbxm) |
| BakerySim_Dummy_3.rbxm | BakerySim | 17 | non | Personnage / NPC, Humanoid, ancrage d’origine conservé, 2x5x4 studs (de Bakery-Simulator/CustomerTypes.rbxm) |
| BakerySim_NpcBase.rbxm | BakerySim | 17 | non | Personnage / NPC, Humanoid, ancrage d’origine conservé, 4x5x2 studs (de Bakery-Simulator/CustomerTypes.rbxm) |
| BillionaireTycoon_GetDressedfortheBeach.rbxm | BillionaireTycoon | 7 | non | Personnage / NPC, Humanoid, ancrage d’origine conservé, 5x6x2 studs (de Billionaire_Tycoon/Workspace/Get Dressed for the Beach.rbxm) |
| BillionaireTycoon_Unnamed.rbxm | BillionaireTycoon | 8 | oui (3) | Personnage / NPC, Humanoid, ancrage d’origine conservé, 6x5x8 studs (de Billionaire_Tycoon/Workspace/ .rbxm) |
| CashgrabBridge_Devil.rbxm | CashgrabBridge | 17 | oui (2) | Personnage / NPC, Humanoid, ancrage d’origine conservé, 9x6x5 studs (de CashgrabBridgeEU/Workspace/Devil.rbxm) |
| CashgrabBridge_FireMan.rbxm | CashgrabBridge | 10 | oui (1) | Personnage / NPC, Humanoid, ancrage d’origine conservé, 109x182x124 studs (de CashgrabBridgeEU/Workspace/Fire Man.rbxm) |
| CashgrabBridge_Giorno.rbxm | CashgrabBridge | 17 | oui (2) | Personnage / NPC, Humanoid, ancrage d’origine conservé, 8x6x8 studs (de CashgrabBridgeEU/Workspace/Giorno.rbxm) |
| CashgrabBridge_God.rbxm | CashgrabBridge | 18 | oui (2) | Personnage / NPC, Humanoid, ancrage d’origine conservé, 9x7x9 studs (de CashgrabBridgeEU/Workspace/God.rbxm) |
| CashgrabBridge_Gojo.rbxm | CashgrabBridge | 17 | oui (2) | Personnage / NPC, Humanoid, ancrage d’origine conservé, 8x6x8 studs (de CashgrabBridgeEU/Workspace/Gojo.rbxm) |
| CashgrabBridge_GoldenMan.rbxm | CashgrabBridge | 11 | oui (1) | Personnage / NPC, Humanoid, ancrage d’origine conservé, 200x193x200 studs (de CashgrabBridgeEU/Workspace/Golden Man.rbxm) |
| CashgrabBridge_Ichigo.rbxm | CashgrabBridge | 16 | oui (2) | Personnage / NPC, Humanoid, ancrage d’origine conservé, 8x6x8 studs (de CashgrabBridgeEU/Workspace/Ichigo.rbxm) |
| CashgrabBridge_MrRich.rbxm | CashgrabBridge | 12 | oui (1) | Personnage / NPC, Humanoid, ancrage d’origine conservé, 104x178x104 studs (de CashgrabBridgeEU/Workspace/Mr Rich.rbxm) |
| CashgrabBridge_Owner.rbxm | CashgrabBridge | 26 | oui (1) | Personnage / NPC, Humanoid, SurfaceGui/Billboard, ancrage d’origine conservé, 3x6x3 studs (de CashgrabBridgeEU/Workspace/Owner.rbxm) |
| CashgrabBridge_Rich.rbxm | CashgrabBridge | 19 | oui (2) | Personnage / NPC, Humanoid, ancrage d’origine conservé, 9x6x5 studs (de CashgrabBridgeEU/Workspace/Rich.rbxm) |
| CashgrabBridge_Unnamed.rbxm | CashgrabBridge | 19 | oui (1) | Personnage / NPC, Humanoid, SurfaceGui/Billboard, ancrage d’origine conservé, 3x5x3 studs (de CashgrabBridgeEU/Workspace/ .rbxm) |
| FirstDonations_Picnic.rbxm | FirstDonations | 45 | oui (2) | Personnage / NPC, Humanoid, 1 particules/effets, ancrage d’origine conservé, 19x6x20 studs (de First_Donations/Workspace/IslaCentralVerde.rbxm) |
| GlassBridge_Unnamed.rbxm | GlassBridge | 19 | oui (1) | Personnage / NPC, Humanoid, ancrage d’origine conservé, 6x15x9 studs (de GlassBridge/Workspace/ .rbxm) |
| HatchingSim_NPC.rbxm | HatchingSim | 18 | oui (1) | Personnage / NPC, Humanoid, ancrage d’origine conservé, 2x4x4 studs (de HatchingSimulator/Workspace/World.rbxm) |
| HatchingSim_NPCS.rbxm | HatchingSim | 17 | oui (1) | Personnage / NPC, Humanoid, ancrage d’origine conservé, 2x6x3 studs (de HatchingSimulator/Workspace/Space.rbxm) |
| HatchingSim_Npcs_2.rbxm | HatchingSim | 20 | oui (1) | Personnage / NPC, Humanoid, ancrage d’origine conservé, 2x6x3 studs (de HatchingSimulator/Workspace/World.rbxm) |
| HatchingSim_Npcs_3.rbxm | HatchingSim | 17 | oui (1) | Personnage / NPC, Humanoid, SurfaceGui/Billboard, ancrage d’origine conservé, 4x6x3 studs (de HatchingSimulator/Workspace/World.rbxm) |
| HatchingSim_Npcs_4.rbxm | HatchingSim | 19 | oui (1) | Personnage / NPC, Humanoid, SurfaceGui/Billboard, ancrage d’origine conservé, 4x7x4 studs (de HatchingSimulator/Workspace/World.rbxm) |
| HatchingSim_NPCS_5.rbxm | HatchingSim | 24 | non | Personnage / NPC, Humanoid, ancrage d’origine conservé, 2x6x3 studs (de HatchingSimulator/Workspace/World.rbxm) |
| MagnetSim2_Interaction.rbxm | MagnetSim2 | 38 | oui (3) | Personnage / NPC, Humanoid, SurfaceGui/Billboard, ancrage d’origine conservé, 60x7x36 studs (de UNCOPYLOCKED-Magnet-Simulator-2/Workspace/Interaction.rbxm) |
| MiningMasters_AnimationDummy.rbxm | MiningMasters | 16 | oui (1) | Personnage / NPC, Humanoid, ancrage d’origine conservé, 4x5x1 studs (de Mining-Masters/AnimationDummy.rbxm) |
| PetPharmica_Dummy.rbxm | PetPharmica | 7 | non | Personnage / NPC, Humanoid, ancrage d’origine conservé, 1x5x4 studs (de Pet_Pharmica_1_1/Workspace/Dummy.rbxm) |
| PetPharmica_NPC.rbxm | PetPharmica | 17 | oui (2) | Personnage / NPC, Humanoid, ancrage d’origine conservé, 2x6x4 studs (de Pet_Pharmica_1_1/Workspace/NPC.rbxm) |
| PetPharmica_Pharmox.rbxm | PetPharmica | 8 | non | Personnage / NPC, Humanoid, ancrage d’origine conservé, 4x5x5 studs (de Pet_Pharmica_1_1/Workspace/Areas.rbxm) |
| PunchSim_Dummy.rbxm | PunchSim | 7 | non | Personnage / NPC, Humanoid, 10 particules/effets, ancrage d’origine conservé, 4x5x1 studs (de Punch Simulator/Workspace/gift for brennan.rbxm) |
| RebirthChampionsX_Dummy.rbxm | RebirthChampionsX | 16 | non | Personnage / NPC, Humanoid, ancrage d’origine conservé, 2x8x6 studs (de Rebirth Champions X/Workspace/Maps.rbxm) |
| RobotSim_BonusIdleForRobot.rbxm | RobotSim | 7 | non | Personnage / NPC, Humanoid, ancrage d’origine conservé, 1x5x4 studs (de Robot Simulator/Bosses.rbxm) |
| RobotSim_Boss.rbxm | RobotSim | 63 | non | Personnage / NPC, 16x62x49 studs (de Robot Simulator/Boss.rbxm) |
| RobotSim_BossArena.rbxm | RobotSim | 68 | non | Personnage / NPC, SurfaceGui/Billboard, 113x47x131 studs (de Robot Simulator/Workspace/BossArena.rbxm) |
| RobotSim_Builder.rbxm | RobotSim | 17 | non | Personnage / NPC, Humanoid, ancrage d’origine conservé, 3x6x4 studs (de Robot Simulator/Builder.rbxm) |
| RobotSim_BuildersSimpleBed.rbxm | RobotSim | 20 | non | Personnage / NPC, Humanoid, ancrage d’origine conservé, 15x2x14 studs (de Robot Simulator/Builders Simple Bed.rbxm) |
| RobotSim_Cam.rbxm | RobotSim | 13 | non | Personnage / NPC, Humanoid, SurfaceGui/Billboard, ancrage d’origine conservé, 3x4x2 studs (de Robot Simulator/Workspace/Map.rbxm) |
| RobotSim_Gunner.rbxm | RobotSim | 10 | oui (20) | Personnage / NPC, Humanoid, 1 particules/effets, ancrage d’origine conservé, 5x6x8 studs (de Robot Simulator/Workspace/Gunner.rbxm) |
| RobotSim_MechGolem.rbxm | RobotSim | 16 | non | Personnage / NPC, Humanoid, ancrage d’origine conservé, 12x31x25 studs (de Robot Simulator/Bosses.rbxm) |
| RobotSim_Minion.rbxm | RobotSim | 6 | oui (4) | Personnage / NPC, Humanoid, ancrage d’origine conservé, 4x5x4 studs (de Robot Simulator/Workspace/Minion.rbxm) |
| RobotSim_Mmistaken.rbxm | RobotSim | 19 | non | Personnage / NPC, Humanoid, SurfaceGui/Billboard, ancrage d’origine conservé, 3x5x3 studs (de Robot Simulator/Workspace/Map.rbxm) |
| RobotSim_PurpleTitan.rbxm | RobotSim | 17 | non | Personnage / NPC, Humanoid, ancrage d’origine conservé, 12x34x25 studs (de Robot Simulator/Bosses.rbxm) |
| RobotSim_Robot.rbxm | RobotSim | 7 | oui (1) | Personnage / NPC, Humanoid, ancrage d’origine conservé, 6x28x23 studs (de Robot Simulator/OLD_THINGS.rbxm) |
| RobotSim_RobotbyOnscurezynkez.rbxm | RobotSim | 124 | non | Personnage / NPC, 28x50x41 studs (de Robot Simulator/Robot by Onscurezynkez.rbxm) |
| RobotSim_RobotSellNPC.rbxm | RobotSim | 7 | oui (1) | Personnage / NPC, Humanoid, SurfaceGui/Billboard, ancrage d’origine conservé, 4x6x5 studs (de Robot Simulator/Workspace/Map.rbxm) |
| RobotSim_Stomp.rbxm | RobotSim | 7 | non | Personnage / NPC, Humanoid, ancrage d’origine conservé, 7x30x24 studs (de Robot Simulator/Bosses.rbxm) |
| RobotSim_SuperRobot.rbxm | RobotSim | 16 | non | Personnage / NPC, Humanoid, ancrage d’origine conservé, 13x30x25 studs (de Robot Simulator/Bosses.rbxm) |
| RobotSim_SWAT.rbxm | RobotSim | 31 | oui (3) | Personnage / NPC, Humanoid, 3 particules/effets, SurfaceGui/Billboard, ancrage d’origine conservé, 5x6x5 studs (de Robot Simulator/Workspace/SWAT.rbxm) |
| RobotSim_Temp.rbxm | RobotSim | 20 | non | Personnage / NPC, Humanoid, SurfaceGui/Billboard, ancrage d’origine conservé, 3x5x3 studs (de Robot Simulator/Workspace/Map.rbxm) |
| RobotSim_Unnamed.rbxm | RobotSim | 17 | non | Personnage / NPC, Humanoid, ancrage d’origine conservé, 8x30x22 studs (de Robot Simulator/Unnamed.rbxm) |
| RobotSim_Ved.rbxm | RobotSim | 18 | non | Personnage / NPC, Humanoid, ancrage d’origine conservé, 2x6x3 studs (de Robot Simulator/OLD_THINGS.rbxm) |
| RobotSim_WhiteShirt.rbxm | RobotSim | 10 | non | Personnage / NPC, Humanoid, SurfaceGui/Billboard, ancrage d’origine conservé, 6x5x2 studs (de Robot Simulator/ShirtDisplays.rbxm) |
| ShootABrainrot_BasicDude.rbxm | ShootABrainrot | 7 | oui (1) | Personnage / NPC, Humanoid, ancrage d’origine conservé, 6x8x2 studs (de ShootABrainrotEU/Storage.rbxm) |
| ShootABrainrot_Noob.rbxm | ShootABrainrot | 7 | oui (1) | Personnage / NPC, Humanoid, ancrage d’origine conservé, 6x8x2 studs (de ShootABrainrotEU/Storage.rbxm) |
| ShootABrainrot_Npc.rbxm | ShootABrainrot | 7 | oui (2) | Personnage / NPC, Humanoid, prompt/clic, ancrage d’origine conservé, 4x5x1 studs (de ShootABrainrotEU/Workspace/Main.rbxm) |
| ShootABrainrot_Npc_2.rbxm | ShootABrainrot | 8 | oui (2) | Personnage / NPC, Humanoid, prompt/clic, ancrage d’origine conservé, 4x6x2 studs (de ShootABrainrotEU/Workspace/Main.rbxm) |
| ShootABrainrot_TungTungSahur.rbxm | ShootABrainrot | 18 | oui (1) | Personnage / NPC, Humanoid, ancrage d’origine conservé, 6x12x7 studs (de ShootABrainrotEU/Assets.rbxm) |
| ShootABrainrot_UDinDinDun.rbxm | ShootABrainrot | 34 | oui (1) | Personnage / NPC, Humanoid, 5 particules/effets, ancrage d’origine conservé, 7x14x14 studs (de ShootABrainrotEU/Assets.rbxm) |
| TappingLords_Dummy.rbxm | TappingLords | 16 | non | Personnage / NPC, Humanoid, ancrage d’origine conservé, 1x5x4 studs (de Tapping-Lords-Simulator/Workspace/Dummy.rbxm) |
| TrainingSim_CameraMan.rbxm | TrainingSim | 16 | non | Personnage / NPC, Humanoid, ancrage d’origine conservé, 2x9x4 studs (de TrainingSimulatorEU/Workspace/CameraMan.rbxm) |
| TrainingSim_Unnamed.rbxm | TrainingSim | 17 | oui (1) | Personnage / NPC, Humanoid, ancrage d’origine conservé, 2x5x4 studs (de TrainingSimulatorEU/Workspace/  .rbxm) |
| TrainingSim_Unnamed_2.rbxm | TrainingSim | 8 | non | Personnage / NPC, Humanoid, ancrage d’origine conservé, 3x7x4 studs (de TrainingSimulatorEU/Workspace/Unnamed.rbxm) |
| TweetingSim_CannonGuy.rbxm | TweetingSim | 23 | oui (4) | Personnage / NPC, Humanoid, ancrage d’origine conservé, 19x10x17 studs (de Tweeting-Simulator-UncopyLocked/UpdateBuilds.rbxm) |
| TweetingSim_Fisherman_NPC.rbxm | TweetingSim | 17 | oui (4) | Personnage / NPC, Humanoid, ancrage d’origine conservé, 5x8x4 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Core.rbxm) |
| TweetingSim_Fisherman_NPC2.rbxm | TweetingSim | 17 | oui (4) | Personnage / NPC, Humanoid, ancrage d’origine conservé, 4x6x4 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Core.rbxm) |
| TweetingSim_GodNPC.rbxm | TweetingSim | 16 | oui (4) | Personnage / NPC, Humanoid, ancrage d’origine conservé, 20x35x8 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Core.rbxm) |

## VFX_Effects

Dossier `ByType/VFX_Effects/` — 76 objets.

| Fichier | Jeu | Pièces | Scripts | Description |
|---|---|---|---|---|
| BakerySim_GourmetEffects.rbxm | BakerySim | 1 | non | Effet visuel, 2 particules/effets, 2x2x2 studs (de Bakery-Simulator/Assets.rbxm) |
| BakerySim_LevelUpParticle.rbxm | BakerySim | 1 | non | Effet visuel, 4 particules/effets, 1x1x1 studs (de Bakery-Simulator/Assets.rbxm) |
| BakerySim_SnoozeEffect.rbxm | BakerySim | 1 | non | Effet visuel, 1 particules/effets, 3x3x3 studs (de Bakery-Simulator/Assets.rbxm) |
| BakerySim_SprintEffects.rbxm | BakerySim | 1 | non | Effet visuel, 1 particules/effets, 4x1x2 studs (de Bakery-Simulator/Assets.rbxm) |
| BakerySim_Star.rbxm | BakerySim | 1 | oui (1) | Effet visuel, 2 particules/effets, prompt/clic, 4x5x1 studs (de Bakery-Simulator/Assets.rbxm) |
| CashgrabBridge_LightningParticle.rbxm | CashgrabBridge | 7 | oui (1) | Effet visuel, 1 particules/effets, 9x9x9 studs (de CashgrabBridgeEU/Workspace/LightningParticle.rbxm) |
| FirstDonations_CurrencyCoin.rbxm | FirstDonations | 1 | non | Effet visuel, 4 particules/effets, ancrage d’origine conservé, 0x2x2 studs (de First_Donations/Templates.rbxm) |
| FirstDonations_Explosion.rbxm | FirstDonations | 5 | non | Effet visuel, 14x14x14 studs (de First_Donations/Templates.rbxm) |
| FirstDonations_GiftbuxCoin.rbxm | FirstDonations | 1 | non | Effet visuel, 3 particules/effets, SurfaceGui/Billboard, ancrage d’origine conservé, 0x2x2 studs (de First_Donations/Templates.rbxm) |
| FirstDonations_Hole.rbxm | FirstDonations | 6 | oui (4) | Effet visuel, 6 particules/effets, SurfaceGui/Billboard, 90x94x79 studs (de First_Donations/Hole.rbxm) |
| FirstDonations_RocketL.rbxm | FirstDonations | 5 | oui (2) | Effet visuel, 10 particules/effets, SurfaceGui/Billboard, 225x284x142 studs (de First_Donations/RocketL.rbxm) |
| FirstDonations_Smite.rbxm | FirstDonations | 49 | oui (15) | Effet visuel, Humanoid, 57 particules/effets, SurfaceGui/Billboard, ancrage d’origine conservé, 2162x1588x2284 studs (de First_Donations/Smite.rbxm) |
| FirstDonations_Spotlight.rbxm | FirstDonations | 8 | non | Effet visuel, 1 particules/effets, 7x7x6 studs (de First_Donations/Workspace/Spotlight.rbxm) |
| FirstDonations_TablaPrincipalLive.rbxm | FirstDonations | 6 | non | Effet visuel, 6 particules/effets, 25x36x27 studs (de First_Donations/Workspace/IslaCentralVerde.rbxm) |
| GlassBridge_BreakEffect.rbxm | GlassBridge | 29 | oui (1) | Effet visuel, 17x1x17 studs (de GlassBridge/BreakEffect.rbxm) |
| Lib_NewPluginAssets_Model.rbxm | Lib | 3 | non | Effet visuel, 19x26x19 studs (de VFX/PluginAssets_VFX.rbxm) |
| Lib_NewPluginAssets_Model_2.rbxm | Lib | 7 | non | Effet visuel, 10x33x10 studs (de VFX/PluginAssets_VFX.rbxm) |
| Lib_NewPluginAssets_Model_3.rbxm | Lib | 4 | non | Effet visuel, 10x15x7 studs (de VFX/PluginAssets_VFX.rbxm) |
| Lib_NewPluginAssets_Model_4.rbxm | Lib | 6 | non | Effet visuel, 11x14x7 studs (de VFX/PluginAssets_VFX.rbxm) |
| Lib_Waterfall.rbxm | Lib | 2 | non | Effet visuel, 15 particules/effets, 24x35x27 studs (de VFX/PluginAssets_VFX.rbxm) |
| PetPharmica_Return2.rbxm | PetPharmica | 4 | oui (1) | Effet visuel, 2 particules/effets, prompt/clic, SurfaceGui/Billboard, 30x21x30 studs (de Pet_Pharmica_1_1/Workspace/Areas.rbxm) |
| PetPharmica_Waterfall.rbxm | PetPharmica | 2 | non | Effet visuel, 3 particules/effets, 27x365x29 studs (de Pet_Pharmica_1_1/Workspace/Areas.rbxm) |
| PunchSim_Auras.rbxm | PunchSim | 2 | non | Effet visuel, SurfaceGui/Billboard, 33x30x32 studs (de Punch Simulator/Workspace/__MAP.rbxm) |
| PunchSim_DarkMatterPower.rbxm | PunchSim | 1 | non | Effet visuel, 13 particules/effets, 41x41x41 studs (de Punch Simulator/Assets.rbxm) |
| PunchSim_ElectroPower.rbxm | PunchSim | 1 | non | Effet visuel, 13 particules/effets, 41x41x41 studs (de Punch Simulator/Assets.rbxm) |
| PunchSim_Fireball1.rbxm | PunchSim | 3 | non | Effet visuel, 4 particules/effets, 12x12x12 studs (de Punch Simulator/Assets.rbxm) |
| PunchSim_Fireball10.rbxm | PunchSim | 3 | non | Effet visuel, 6 particules/effets, 18x18x18 studs (de Punch Simulator/Assets.rbxm) |
| PunchSim_Fireball11.rbxm | PunchSim | 3 | non | Effet visuel, 6 particules/effets, 19x19x19 studs (de Punch Simulator/Assets.rbxm) |
| PunchSim_Fireball12.rbxm | PunchSim | 3 | non | Effet visuel, 13 particules/effets, 17x17x17 studs (de Punch Simulator/Assets.rbxm) |
| PunchSim_Fireball13.rbxm | PunchSim | 3 | non | Effet visuel, 13 particules/effets, 17x17x17 studs (de Punch Simulator/Assets.rbxm) |
| PunchSim_Fireball14.rbxm | PunchSim | 3 | non | Effet visuel, 13 particules/effets, 17x17x17 studs (de Punch Simulator/Assets.rbxm) |
| PunchSim_Fireball15.rbxm | PunchSim | 3 | non | Effet visuel, 13 particules/effets, 17x17x17 studs (de Punch Simulator/Assets.rbxm) |
| PunchSim_Fireball16.rbxm | PunchSim | 3 | non | Effet visuel, 1 particules/effets, 19x19x19 studs (de Punch Simulator/Assets.rbxm) |
| PunchSim_Fireball17.rbxm | PunchSim | 3 | non | Effet visuel, 3 particules/effets, 19x19x19 studs (de Punch Simulator/Assets.rbxm) |
| PunchSim_Fireball18.rbxm | PunchSim | 3 | non | Effet visuel, 1 particules/effets, 19x19x19 studs (de Punch Simulator/Assets.rbxm) |
| PunchSim_Fireball19.rbxm | PunchSim | 3 | non | Effet visuel, 4 particules/effets, 25x25x25 studs (de Punch Simulator/Assets.rbxm) |
| PunchSim_Fireball2.rbxm | PunchSim | 3 | non | Effet visuel, 4 particules/effets, 12x12x12 studs (de Punch Simulator/Assets.rbxm) |
| PunchSim_Fireball20.rbxm | PunchSim | 3 | non | Effet visuel, 5 particules/effets, 16x16x16 studs (de Punch Simulator/Assets.rbxm) |
| PunchSim_Fireball21.rbxm | PunchSim | 3 | non | Effet visuel, 5 particules/effets, 16x16x16 studs (de Punch Simulator/Assets.rbxm) |
| PunchSim_Fireball22.rbxm | PunchSim | 3 | non | Effet visuel, 5 particules/effets, 24x24x24 studs (de Punch Simulator/Assets.rbxm) |
| PunchSim_Fireball23.rbxm | PunchSim | 3 | non | Effet visuel, 9 particules/effets, 22x22x22 studs (de Punch Simulator/Assets.rbxm) |
| PunchSim_Fireball24.rbxm | PunchSim | 3 | non | Effet visuel, 9 particules/effets, 22x22x22 studs (de Punch Simulator/Assets.rbxm) |
| PunchSim_Fireball25.rbxm | PunchSim | 3 | non | Effet visuel, 13 particules/effets, 31x31x31 studs (de Punch Simulator/Assets.rbxm) |
| PunchSim_Fireball26.rbxm | PunchSim | 3 | non | Effet visuel, 3 particules/effets, 20x20x20 studs (de Punch Simulator/Assets.rbxm) |
| PunchSim_Fireball27.rbxm | PunchSim | 3 | non | Effet visuel, 6 particules/effets, 27x27x27 studs (de Punch Simulator/Assets.rbxm) |
| PunchSim_Fireball28.rbxm | PunchSim | 3 | non | Effet visuel, 8 particules/effets, 36x36x36 studs (de Punch Simulator/Assets.rbxm) |
| PunchSim_Fireball29.rbxm | PunchSim | 3 | non | Effet visuel, 8 particules/effets, 45x45x45 studs (de Punch Simulator/Assets.rbxm) |
| PunchSim_Fireball3.rbxm | PunchSim | 3 | non | Effet visuel, 4 particules/effets, 12x12x12 studs (de Punch Simulator/Assets.rbxm) |
| PunchSim_Fireball30.rbxm | PunchSim | 3 | non | Effet visuel, 8 particules/effets, 45x45x45 studs (de Punch Simulator/Assets.rbxm) |
| PunchSim_Fireball31.rbxm | PunchSim | 3 | non | Effet visuel, 8 particules/effets, 45x45x45 studs (de Punch Simulator/Assets.rbxm) |
| PunchSim_Fireball32.rbxm | PunchSim | 3 | non | Effet visuel, 9 particules/effets, 38x38x38 studs (de Punch Simulator/Assets.rbxm) |
| PunchSim_Fireball33.rbxm | PunchSim | 1 | non | Effet visuel, 27 particules/effets, 32x32x32 studs (de Punch Simulator/Assets.rbxm) |
| PunchSim_Fireball34.rbxm | PunchSim | 1 | non | Effet visuel, 27 particules/effets, 32x32x32 studs (de Punch Simulator/Assets.rbxm) |
| PunchSim_Fireball35.rbxm | PunchSim | 1 | non | Effet visuel, 26 particules/effets, 32x32x32 studs (de Punch Simulator/Assets.rbxm) |
| PunchSim_Fireball36.rbxm | PunchSim | 1 | non | Effet visuel, 26 particules/effets, 32x32x32 studs (de Punch Simulator/Assets.rbxm) |
| PunchSim_Fireball37.rbxm | PunchSim | 1 | non | Effet visuel, 26 particules/effets, 32x32x32 studs (de Punch Simulator/Assets.rbxm) |
| PunchSim_Fireball38.rbxm | PunchSim | 1 | non | Effet visuel, 26 particules/effets, 32x32x32 studs (de Punch Simulator/Assets.rbxm) |
| PunchSim_Fireball39.rbxm | PunchSim | 1 | non | Effet visuel, 7 particules/effets, 36x36x36 studs (de Punch Simulator/Assets.rbxm) |
| PunchSim_Fireball4.rbxm | PunchSim | 3 | non | Effet visuel, 4 particules/effets, 12x12x12 studs (de Punch Simulator/Assets.rbxm) |
| PunchSim_Fireball40.rbxm | PunchSim | 1 | non | Effet visuel, 7 particules/effets, 36x36x36 studs (de Punch Simulator/Assets.rbxm) |
| PunchSim_Fireball41.rbxm | PunchSim | 1 | non | Effet visuel, 16 particules/effets, 28x28x28 studs (de Punch Simulator/Assets.rbxm) |
| PunchSim_Fireball43.rbxm | PunchSim | 1 | non | Effet visuel, 16 particules/effets, 28x28x28 studs (de Punch Simulator/Assets.rbxm) |
| PunchSim_Fireball44.rbxm | PunchSim | 1 | non | Effet visuel, 16 particules/effets, 28x28x28 studs (de Punch Simulator/Assets.rbxm) |
| PunchSim_Fireball45.rbxm | PunchSim | 1 | non | Effet visuel, 16 particules/effets, 28x28x28 studs (de Punch Simulator/Assets.rbxm) |
| PunchSim_Fireball5.rbxm | PunchSim | 3 | non | Effet visuel, 4 particules/effets, 16x16x16 studs (de Punch Simulator/Assets.rbxm) |
| PunchSim_Fireball6.rbxm | PunchSim | 3 | non | Effet visuel, 4 particules/effets, 18x18x18 studs (de Punch Simulator/Assets.rbxm) |
| PunchSim_Fireball7.rbxm | PunchSim | 3 | non | Effet visuel, 6 particules/effets, 14x14x14 studs (de Punch Simulator/Assets.rbxm) |
| PunchSim_Fireball8.rbxm | PunchSim | 3 | non | Effet visuel, 6 particules/effets, 14x14x14 studs (de Punch Simulator/Assets.rbxm) |
| PunchSim_Fireball9.rbxm | PunchSim | 3 | non | Effet visuel, 6 particules/effets, 14x14x14 studs (de Punch Simulator/Assets.rbxm) |
| PunchSim_LevelUp.rbxm | PunchSim | 1 | non | Effet visuel, 5 particules/effets, 1x1x1 studs (de Punch Simulator/Assets.rbxm) |
| PunchSim_Punch.rbxm | PunchSim | 1 | non | Effet visuel, 5 particules/effets, 2x2x2 studs (de Punch Simulator/Assets.rbxm) |
| PunchSim_SuperPower.rbxm | PunchSim | 1 | non | Effet visuel, 13 particules/effets, 41x41x41 studs (de Punch Simulator/Assets.rbxm) |
| RobotSim_Island1Fire.rbxm | RobotSim | 4 | non | Effet visuel, 4 particules/effets, 153x10x171 studs (de Robot Simulator/Workspace/LowModeParts.rbxm) |
| RobotSim_Island4Fire.rbxm | RobotSim | 5 | non | Effet visuel, 4 particules/effets, 206x11x197 studs (de Robot Simulator/Workspace/LowModeParts.rbxm) |
| RobotSim_PetGlow.rbxm | RobotSim | 1 | non | Effet visuel, 4 particules/effets, ancrage d’origine conservé, 1x1x1 studs (de Robot Simulator/Assets.rbxm) |
| ShootABrainrot_WaterFall.rbxm | ShootABrainrot | 2 | non | Effet visuel, 11 particules/effets, 76x27x15 studs (de ShootABrainrotEU/Workspace/Main.rbxm) |

## Misc

Dossier `ByType/Misc/` — 42 objets.

| Fichier | Jeu | Pièces | Scripts | Description |
|---|---|---|---|---|
| 1HealthEverySecond_AddedStuff_Model.rbxm | 1HealthEverySecond | 15 | non | Divers, 8x24x10 studs (de 1HealthEverySecond/Workspace/Added Stuff.rbxm) |
| 1JumpEverySecond_Gears.rbxm | 1JumpEverySecond | 162 | non | Divers, SurfaceGui/Billboard, 18x12x11 studs (de 1JumpEverySecond/Workspace/Gears.rbxm) |
| 1JumpEverySecond_ImageAdUnit2.rbxm | 1JumpEverySecond | 10 | oui (1) | Divers, 17x11x6 studs (de 1JumpEverySecond/Workspace/Image Ad Unit 2.rbxm) |
| BakerySim_BasicCart.rbxm | BakerySim | 13 | non | Divers, 3x4x5 studs (de Bakery-Simulator/BasicCart.rbxm) |
| BakerySim_PetGatherPoints.rbxm | BakerySim | 10 | non | Divers, 104x1x30 studs (de Bakery-Simulator/Workspace/PetGatherPoints.rbxm) |
| CashgrabBridge_Green.rbxm | CashgrabBridge | 69 | oui (1) | Divers, 122x638x165 studs (de CashgrabBridgeEU/PetSystem.rbxm) |
| CashgrabBridge_Red.rbxm | CashgrabBridge | 12 | oui (1) | Divers, 48x638x54 studs (de CashgrabBridgeEU/PetSystem.rbxm) |
| CashgrabBridge_Violet.rbxm | CashgrabBridge | 11 | oui (1) | Divers, 8x14x15 studs (de CashgrabBridgeEU/PetSystem.rbxm) |
| FirstDonations_Panel.rbxm | FirstDonations | 63 | oui (1) | Divers, 7 particules/effets, prompt/clic, SurfaceGui/Billboard, 3x6x12 studs (de First_Donations/Workspace/Panel.rbxm) |
| HatchingSim_Frawst4.rbxm | HatchingSim | 15 | oui (1) | Divers, 4x37x27 studs (de HatchingSimulator/Workspace/Frawst4.rbxm) |
| HatchingSim_Frawst5.rbxm | HatchingSim | 15 | oui (1) | Divers, 8x13x10 studs (de HatchingSimulator/Workspace/Frawst5.rbxm) |
| MagnetSim2_Essentials.rbxm | MagnetSim2 | 9 | non | Divers, 520x20x803 studs (de UNCOPYLOCKED-Magnet-Simulator-2/Workspace/Essentials.rbxm) |
| MiningMasters_Cube.rbxm | MiningMasters | 1 | non | Divers, 3x4x3 studs (de Mining-Masters/Brushtool2_Plugin_Storage.rbxm) |
| MiningMasters_GFXRoomTemp.rbxm | MiningMasters | 5 | non | Divers, 63x44x77 studs (de Mining-Masters/GFXRoomTemp.rbxm) |
| MiningMasters_MineParts.rbxm | MiningMasters | 10 | non | Divers, 596x13x2426 studs (de Mining-Masters/Workspace/MineParts.rbxm) |
| MiningMasters_TUTORIALCAMERAS.rbxm | MiningMasters | 6 | oui (1) | Divers, 53x66x147 studs (de Mining-Masters/Workspace/TUTORIALCAMERAS.rbxm) |
| PetPharmica_Basic.rbxm | PetPharmica | 10 | oui (1) | Divers, SurfaceGui/Billboard, 7x11x12 studs (de Pet_Pharmica_1_1/Workspace/Basic.rbxm) |
| PetPharmica_BlackbeardStuff.rbxm | PetPharmica | 24 | non | Divers, 24x6x24 studs (de Pet_Pharmica_1_1/Workspace/BlackbeardStuff.rbxm) |
| PetPharmica_Return.rbxm | PetPharmica | 7 | oui (1) | Divers, prompt/clic, SurfaceGui/Billboard, 27x42x44 studs (de Pet_Pharmica_1_1/Workspace/Return.rbxm) |
| PetPharmica_Streat.rbxm | PetPharmica | 8 | non | Divers, 358x33x238 studs (de Pet_Pharmica_1_1/Workspace/Streat.rbxm) |
| PunchSim_ImageAdUnit2.rbxm | PunchSim | 14 | oui (1) | Divers, 22x14x1 studs (de Punch Simulator/Workspace/Image Ad Unit 2.rbxm) |
| PunchSim_Protection.rbxm | PunchSim | 1 | non | Divers, 10x10x10 studs (de Punch Simulator/Assets.rbxm) |
| PunchSim_RadioactiveMiningSite.rbxm | PunchSim | 18 | non | Divers, 48x34x46 studs (de Punch Simulator/Workspace/Radioactive Mining Site.rbxm) |
| PunchSim_Strength.rbxm | PunchSim | 1 | non | Divers, SurfaceGui/Billboard, 1x1x1 studs (de Punch Simulator/Assets.rbxm) |
| RobotSim_Island1Sign.rbxm | RobotSim | 21 | non | Divers, 2 particules/effets, 10x6x7 studs (de Robot Simulator/Workspace/LowModeParts.rbxm) |
| RobotSim_Island2Sign.rbxm | RobotSim | 21 | non | Divers, 2 particules/effets, 10x6x7 studs (de Robot Simulator/Workspace/LowModeParts.rbxm) |
| RobotSim_Island3Sign.rbxm | RobotSim | 21 | non | Divers, 2 particules/effets, 8x6x10 studs (de Robot Simulator/Workspace/LowModeParts.rbxm) |
| RobotSim_Island4Sign.rbxm | RobotSim | 23 | non | Divers, 2 particules/effets, 6x6x11 studs (de Robot Simulator/Workspace/LowModeParts.rbxm) |
| RobotSim_JumpColorReference.rbxm | RobotSim | 9 | non | Divers, 44x1x4 studs (de Robot Simulator/OLD_THINGS.rbxm) |
| RobotSim_MiddleCircle.rbxm | RobotSim | 1 | non | Divers, 1 particules/effets, 188x0x188 studs (de Robot Simulator/Workspace/LowModeParts.rbxm) |
| RobotSim_Snow.rbxm | RobotSim | 1 | non | Divers, 1 particules/effets, 239x1x229 studs (de Robot Simulator/Workspace/LowModeParts.rbxm) |
| TappingLords_10KEgg.rbxm | TappingLords | 9 | oui (1) | Divers, SurfaceGui/Billboard, 15x7x12 studs (de Tapping-Lords-Simulator/10KEgg.rbxm) |
| TappingLords_EventThingy.rbxm | TappingLords | 78 | non | Divers, 379x109x396 studs (de Tapping-Lords-Simulator/Workspace/EventThingy.rbxm) |
| TappingLords_Meshes_Model.rbxm | TappingLords | 7 | non | Divers, 124x69x76 studs (de Tapping-Lords-Simulator/Workspace/Meshes.rbxm) |
| TrainingSim_Assets.rbxm | TrainingSim | 29 | non | Divers, 17 particules/effets, SurfaceGui/Billboard, ancrage d’origine conservé, 1757x54x945 studs (de TrainingSimulatorEU/Assets.rbxm) |
| TweetingSim_Boundries.rbxm | TweetingSim | 7 | non | Divers, 2330x173x2861 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Boundries.rbxm) |
| TweetingSim_GemSpawnRegions.rbxm | TweetingSim | 43 | non | Divers, 2070x79x2686 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Core.rbxm) |
| TweetingSim_SpringMinigame.rbxm | TweetingSim | 6 | non | Divers, 22x4x22 studs (de Tweeting-Simulator-UncopyLocked/UpdateBuilds.rbxm) |
| TweetingSim_Superhero.rbxm | TweetingSim | 10 | non | Divers, 14x13x8 studs (de Tweeting-Simulator-UncopyLocked/UpdateBuilds.rbxm) |
| TweetingSim_WorldSpawnPoints.rbxm | TweetingSim | 7 | non | Divers, 1979x65x2339 studs (de Tweeting-Simulator-UncopyLocked/Workspace/Core.rbxm) |
| TweetingSim_Youtube.rbxm | TweetingSim | 3 | non | Divers, 4x3x4 studs (de Tweeting-Simulator-UncopyLocked/UpdateBuilds.rbxm) |
| TweetingSim_Youtuber.rbxm | TweetingSim | 10 | non | Divers, 14x13x9 studs (de Tweeting-Simulator-UncopyLocked/UpdateBuilds.rbxm) |
