# Index des interfaces par type

Chaque fichier est un `.rbxm` contenant un **ScreenGui** (ou Folder/BillboardGui) prêt à glisser dans `StarterGui`.
Les menus extraits d'un gros ScreenGui gardent le **nom d'origine du ScreenGui** (ex. `Main`, `MainUI`) pour rester compatibles avec les scripts du jeu (`systems/FromGames/<Jeu>_Systems.rbxm`). Les fichiers `*_Full` sont le ScreenGui original entier.

**Qualité** : note 1-5 heuristique (nombre d'éléments + densité de style : images, UIStroke, UIGradient, UICorner), ajustée à la main. **Scripts** : la plupart des UI dépendent de RemoteEvents/modules du jeu d'origine → à rebrancher (voir le Systems du jeu).

Types ajoutés : `Index_Collection` (index/collection), `Profile_Stats` (profil/stats/rangs), `Teleport_Zones` (téléport/achat de zones), `Components_Kits` (packs de briques UI). `Leaderboard` : aucun leaderboard trouvé dans les sources.

## Résumé

| Type | Fichiers |
|---|---|
| [HUD_Currency](#hud_currency) | 26 |
| [Shop_Store](#shop_store) | 19 |
| [Robux_Gamepass](#robux_gamepass) | 18 |
| [Pets_Inventory](#pets_inventory) | 14 |
| [Eggs_Hatch](#eggs_hatch) | 13 |
| [Trade](#trade) | 8 |
| [Rebirth](#rebirth) | 6 |
| [Upgrades](#upgrades) | 8 |
| [DailyRewards_Gifts](#dailyrewards_gifts) | 13 |
| [SpinWheel](#spinwheel) | 2 |
| [Quests_Season](#quests_season) | 9 |
| [Codes](#codes) | 6 |
| [Settings](#settings) | 10 |
| [Notifications_Popups](#notifications_popups) | 18 |
| [Loading_Intro](#loading_intro) | 6 |
| [Leaderboard](#leaderboard) | 0 |
| [Admin_Debug](#admin_debug) | 2 |
| [Index_Collection](#index_collection) | 6 |
| [Profile_Stats](#profile_stats) | 5 |
| [Teleport_Zones](#teleport_zones) | 7 |
| [Components_Kits](#components_kits) | 5 |
| [Misc](#misc) | 30 |
| **Total** | **231** |

## HUD_Currency

| Fichier | Jeu d'origine | Ce que c'est | Qualité | Scripts |
|---|---|---|---|---|
| `MiningMasters_SideButtons.rbxm` | MiningMasters | Grille de 14 boutons de menu (Pets, Quests, Shop, VIP, Codes…) + boosts actifs. | ★★★★★ (5) | oui (2) |
| `MiningMasters_UI_Full.rbxm` | MiningMasters | UI complète du simulateur (boutons, pets, quêtes, trade, rebirth, gamepass…). | ★★★★★ (5) | oui (11) |
| `PunchSim_Main.rbxm` | PunchSim | HUD principal : stats, barre de progression de puissance, offres à droite, menu gauche, boosts. | ★★★★★ (5) | oui (20) |
| `RebirthChampionsX_HUD.rbxm` | RebirthChampionsX | HUD : menu gauche + compteurs, auto clicker/rebirth, timers de boosts. | ★★★★★ (5) | oui (1) |
| `RebirthChampionsX_MainUI_Full.rbxm` | RebirthChampionsX | UI complète style Rebirth Champions (très riche, 3600 éléments). | ★★★★★ (5) | oui (11) |
| `ShootABrainrot_Main_Full.rbxm` | ShootABrainrot | UI complète style 'brainrot' 2025 (HUD, shop, guns, index, sell) sans scripts. | ★★★★★ (5) | non |
| `TrainingSim_HUD.rbxm` | TrainingSim | HUD : compteurs (wins, muscle…), boutons droite, auto train/rebirth Robux. | ★★★★★ (5) | oui (16) |
| `TrainingSim_MainUI_Full.rbxm` | TrainingSim | UI complète simulateur d'entraînement (shop, pets, rebirth, gifts, upgrades…). | ★★★★★ (5) | oui (55) |
| `1HealthEverySecond_Main_Full.rbxm` | 1HealthEverySecond | HUD complet d'un obby/simulateur '+1 par seconde' : barre du haut, boutons gauche/droite, shop, gears, rebirth (tout-en-un). | ★★★★☆ (4) | oui (24) |
| `1JumpEverySecond_Main_Full.rbxm` | 1JumpEverySecond | HUD complet '+1 Jump par seconde' (variante du précédent) avec tutoriel, récompenses de temps de jeu, progression. | ★★★★☆ (4) | oui (14) |
| `BakerySim_Main_Full.rbxm` | BakerySim | HUD principal (XP, inventaire bas, boosts, events, codes, indicateur hors-écran). | ★★★★☆ (4) | oui (20) |
| `MiningMasters_Currency.rbxm` | MiningMasters | HUD monnaies (+x/sec) + boutons gauche (Shop, Stats, Settings, Rebirth, Weapons). | ★★★★☆ (4) | non |
| `PetPharmica_LeftHUD.rbxm` | PetPharmica | HUD gauche : monnaies + colonnes de boutons + events. | ★★★★☆ (4) | oui (36) |
| `PetPharmica_Main_Full.rbxm` | PetPharmica | UI complète (shop, teleport, inventaire, trade, upgrades, codes…). | ★★★★☆ (4) | oui (123) |
| `ShootABrainrot_HUD.rbxm` | ShootABrainrot | HUD cash + boutons gauche (Shop/Guns/Index) et droite (Sell/Auto/Shoot). | ★★★★☆ (4) | non |
| `CashgrabBridge_CurrencyCounter.rbxm` | CashgrabBridge | Compteur de monnaie + 'Buttons left'. | ★★★☆☆ (3) | oui (2) |
| `GlassBridge_CashHUD.rbxm` | GlassBridge | Compteur de cash + texte d'erreur + sons UI. | ★★★☆☆ (3) | oui (1) |
| `HatchingSim_EventBoosts.rbxm` | HatchingSim | Étiquettes d'events actifs (hatch speed, luck, shiny). | ★★★☆☆ (3) | non |
| `RobotSim_main_Full.rbxm` | RobotSim | UI complète Robot Simulator (sans scripts, pilotée par RobotSim_UIModules). | ★★★☆☆ (3) | non |
| `TappingLords_HUD.rbxm` | TappingLords | HUD clicker (compteurs, boutons Rebirth/Shop/Pets/Codes, auto clicker/rebirth). | ★★★☆☆ (3) | oui (76) |
| `TweetingSim_Core_Full.rbxm` | TweetingSim | UI complète (sans scripts) : panneaux, store, robux shop, pets, codes, daily, settings. | ★★★☆☆ (3) | non |
| `1JumpEverySecond_ProgressBar.rbxm` | 1JumpEverySecond | Barre de progression de course/obby ('You are here'). | ★★☆☆☆ (2) | oui (1) |
| `CashgrabBridge_ProgressBar.rbxm` | CashgrabBridge | Barre de progression simple. | ★★☆☆☆ (2) | oui (1) |
| `HatchingSim_HUD.rbxm` | HatchingSim | HUD clicker : pièces, event, bouton click et auto-click. | ★★☆☆☆ (2) | oui (8) |
| `TappingLords_PotionTimers.rbxm` | TappingLords | Timers de potions actives (click/gem/xp). | ★★☆☆☆ (2) | oui (10) |
| `TweetingSim_HUD.rbxm` | TweetingSim | HUD gauche/haut/droite (monnaies, niveau, sell). | ★★☆☆☆ (2) | non |

## Shop_Store

| Fichier | Jeu d'origine | Ce que c'est | Qualité | Scripts |
|---|---|---|---|---|
| `1HealthEverySecond_Shop.rbxm` | 1HealthEverySecond | Shop à onglets (Passes / Exclusive / Health / Wins) avec liste défilante d'offres Robux. | ★★★★★ (5) | non |
| `PunchSim_Store.rbxm` | PunchSim | Très grand store à sections (gamepasses, potions, gems, strength, spins, codes). | ★★★★★ (5) | oui (12) |
| `RebirthChampionsX_EventShop.rbxm` | RebirthChampionsX | Shop d'event (améliorations à niveaux). | ★★★★★ (5) | non |
| `ShootABrainrot_ExclusiveShop.rbxm` | ShootABrainrot | Shop exclusif (cash bundles, gamepasses). | ★★★★★ (5) | non |
| `TrainingSim_Shop.rbxm` | TrainingSim | Shop à onglets (Passes, Wins, Pets, Boost, Codes). | ★★★★★ (5) | oui (25) |
| `CashgrabBridge_PetShop.rbxm` | CashgrabBridge | Shop de pets paginé (< >) avec prix. | ★★★★☆ (4) | oui (8) |
| `PetPharmica_Shop.rbxm` | PetPharmica | Grand shop à sections (GamePasses, Gold, Boosts, Limited). | ★★★★☆ (4) | oui (9) |
| `RebirthChampionsX_Shop.rbxm` | RebirthChampionsX | Shop exclusif (codes, pets, packs, passes, boosts). | ★★★★☆ (4) | non |
| `ShootABrainrot_GunShop.rbxm` | ShootABrainrot | Gun shop (fire rate, damage). | ★★★★☆ (4) | non |
| `BakerySim_PetShop.rbxm` | BakerySim | Shop de pets avec stats, Set Active et caisses de pets (Robux). | ★★★☆☆ (3) | oui (1) |
| `HatchingSim_GamepassShop.rbxm` | HatchingSim | Shop game passes + starter pack. | ★★★☆☆ (3) | oui (13) |
| `PetPharmica_PetShop.rbxm` | PetPharmica | Shop de pets (coins/gems, stock 0/2). | ★★★☆☆ (3) | oui (17) |
| `RobotSim_ShopBoosts.rbxm` | RobotSim | Shop gemmes Robux + boosts temporaires. | ★★★☆☆ (3) | non |
| `RobotSim_WeaponSkillShop.rbxm` | RobotSim | Shop d'armes et de compétences. | ★★★☆☆ (3) | non |
| `TappingLords_PetShops.rbxm` | TappingLords | Shops de pets (normal + star). | ★★★☆☆ (3) | oui (47) |
| `TappingLords_Shop.rbxm` | TappingLords | Shop game passes + Star shop (Robux). | ★★★☆☆ (3) | oui (90) |
| `1HealthEverySecond_GearsShop.rbxm` | 1HealthEverySecond | Liste d'objets/outils (gears) à acheter, grille défilante. | ★★☆☆☆ (2) | non |
| `BakerySim_ItemShop.rbxm` | BakerySim | Shop d'objets en monnaie du jeu (onglets Carts/Ovens, stats, acheter/vendre). | ★★☆☆☆ (2) | oui (1) |
| `TweetingSim_ItemStore.rbxm` | TweetingSim | Store d'objets (coût coins/gems, equip). | ★★☆☆☆ (2) | non |

## Robux_Gamepass

| Fichier | Jeu d'origine | Ce que c'est | Qualité | Scripts |
|---|---|---|---|---|
| `MiningMasters_GamepassShop.rbxm` | MiningMasters | Shop Robux (pets Robux, x10 boosts, bundles) + panneau Premium. | ★★★★★ (5) | oui (1) |
| `PunchSim_RainbowEggs.rbxm` | PunchSim | Offre Robux 'Rainbow Eggs'. | ★★★★★ (5) | oui (2) |
| `BakerySim_BoostsEvents.rbxm` | BakerySim | Barres de boosts et d'events payants (x2, Drop Nuke, UFO…). | ★★★★☆ (4) | oui (2) |
| `BakerySim_CurrencyStore.rbxm` | BakerySim | Boutique Robux de gemmes et pièces (3 packs chacun, 'Best Deal!'). | ★★★★☆ (4) | oui (3) |
| `CashgrabBridge_TrollProducts.rbxm` | CashgrabBridge | Boutons produits 'troll' (Nuke, Skip to end, Reveal glass) + écran nuke. | ★★★★☆ (4) | oui (9) |
| `FirstDonations_GameShop.rbxm` | FirstDonations | Grille 'GAME SHOP' de dons Robux (10 à 15k) avec scripts d'achat. | ★★★★☆ (4) | oui (27) |
| `GlassBridge_TrollButtons_Full.rbxm` | GlassBridge | HUD de produits troll (reveal, skip, kill all, nuke), gears, invite, roue. | ★★★★☆ (4) | oui (34) |
| `PunchSim_DarkMatterPack.rbxm` | PunchSim | Offre pack Robux 'Dark Matter' (SAVE 98%, contenu détaillé). | ★★★★☆ (4) | oui (5) |
| `RebirthChampionsX_GiftingSpecial.rbxm` | RebirthChampionsX | Offrir un produit à un joueur + boosts spéciaux Robux. | ★★★★☆ (4) | non |
| `1HealthEverySecond_DevProductButtons.rbxm` | 1HealthEverySecond | Colonne de boutons produits développeur (+1 Win, +100 Health, +10K…) prêts à brancher sur MarketplaceService. | ★★★☆☆ (3) | oui (8) |
| `BillionaireTycoon_ShopGui.rbxm` | BillionaireTycoon | Shop tycoon dev products / game passes (cash, vitesse, tapis volant) avec slides. | ★★★☆☆ (3) | oui (3) |
| `CashgrabBridge_Donation.rbxm` | CashgrabBridge | Bouton Donate + liste de dons Robux (5 à 100). | ★★★☆☆ (3) | oui (8) |
| `CashgrabBridge_GearPasses.rbxm` | CashgrabBridge | 12 boutons icônes de game passes d'objets (coil, jetpack, carpet…). | ★★★☆☆ (3) | oui (12) |
| `CashgrabBridge_KillAll.rbxm` | CashgrabBridge | Bouton produit 'KILL ALL'. | ★★★☆☆ (3) | oui (2) |
| `TweetingSim_RobuxShop.rbxm` | TweetingSim | Shop Robux à onglets (coins, gems, passes, boosts). | ★★★☆☆ (3) | non |
| `1HealthEverySecond_LimitedOffers.rbxm` | 1HealthEverySecond | Pop-ups d'offres limitées dans le temps (Dominus) avec compte à rebours, prix barré et bouton Buy. | ★★☆☆☆ (2) | oui (8) |
| `HatchingSim_RobuxBoosts.rbxm` | HatchingSim | Boosts Robux temporaires (2x luck, 2x hatch speed, +1h/+3h). | ★★☆☆☆ (2) | oui (9) |
| `TappingLords_AutoHatchPass.rbxm` | TappingLords | Popup d'achat Auto Hatch. | ★☆☆☆☆ (1) | oui (3) |

## Pets_Inventory

| Fichier | Jeu d'origine | Ce que c'est | Qualité | Scripts |
|---|---|---|---|---|
| `RebirthChampionsX_Pets.rbxm` | RebirthChampionsX | Inventaire pets avancé (teams, renommer, craft all, shrink, multi delete). | ★★★★★ (5) | oui (4) |
| `TrainingSim_Pets.rbxm` | TrainingSim | Inventaire pets (rareté, renommer, craft, equip best, delete). | ★★★★★ (5) | oui (1) |
| `CashgrabBridge_PetInventory.rbxm` | CashgrabBridge | Inventaire de pets paginé (< >) avec bouton Inventory. | ★★★★☆ (4) | oui (8) |
| `MiningMasters_PetInventory.rbxm` | MiningMasters | Inventaire pets (equip best, multi delete, unequip all) + info pet. | ★★★★☆ (4) | oui (1) |
| `PunchSim_Pets.rbxm` | PunchSim | Inventaire pets (equip best, delete, craft, stockage). | ★★★★☆ (4) | non |
| `HatchingSim_PetsInventory.rbxm` | HatchingSim | Inventaire de pets complet (stats, equip, multi-delete, tri, niveaux). | ★★★☆☆ (3) | oui (4) |
| `HatchingSim_PetsInventory_Patriot.rbxm` | HatchingSim | Variante thématique de l'inventaire de pets. | ★★★☆☆ (3) | oui (3) |
| `PetPharmica_PetInventory.rbxm` | PetPharmica | Inventaire pets + craft + suppression légendaires/non-légendaires. | ★★★☆☆ (3) | oui (27) |
| `PetPharmica_UITemplates.rbxm` | PetPharmica | Templates (carte pet, trade, viewport d'éclosion). | ★★★☆☆ (3) | oui (7) |
| `RobotSim_Pets.rbxm` | RobotSim | Inventaire pets (XP, sélection multiple). | ★★★☆☆ (3) | non |
| `TappingLords_PetInventory.rbxm` | TappingLords | Inventaire pets (rareté, type, mass delete). | ★★★☆☆ (3) | oui (30) |
| `PetPharmica_PetCardTemplate.rbxm` | PetPharmica | Template de carte pet (viewport, rareté, verrou). | ★★☆☆☆ (2) | oui (2) |
| `TappingLords_UITemplates.rbxm` | TappingLords | Templates de carte pet + viewport d'éclosion. | ★★☆☆☆ (2) | oui (2) |
| `TweetingSim_PetManager.rbxm` | TweetingSim | Gestion des pets (equip, release, multi release). | ★★☆☆☆ (2) | non |

## Eggs_Hatch

| Fichier | Jeu d'origine | Ce que c'est | Qualité | Scripts |
|---|---|---|---|---|
| `RebirthChampionsX_EggView.rbxm` | RebirthChampionsX | Aperçu d'œuf (chances, luck) + stop auto hatch + machine à pets. | ★★★★★ (5) | non |
| `GlassBridge_RewardShowcase.rbxm` | GlassBridge | Animation de révélation de récompenses (cartes rareté) + CLAIM. | ★★★★☆ (4) | oui (10) |
| `HatchingSim_AutoDelete.rbxm` | HatchingSim | Configuration d'auto-delete des pets à l'éclosion. | ★★★☆☆ (3) | oui (1) |
| `MiningMasters_HatchFrame.rbxm` | MiningMasters | Animation d'éclosion triple (3 pets, rareté). | ★★★☆☆ (3) | oui (3) |
| `PetPharmica_AutoDelete.rbxm` | PetPharmica | Réglages d'auto-delete par rareté. | ★★★☆☆ (3) | oui (7) |
| `PetPharmica_EggPreview.rbxm` | PetPharmica | Aperçu d'œuf (pets, coût, boutons E/R/T x1/x3/Auto) + notif texte. | ★★★☆☆ (3) | oui (10) |
| `TappingLords_EggPreview.rbxm` | TappingLords | Aperçu d'œuf (coût, x1/x3/auto) + auto-delete par rareté. | ★★★☆☆ (3) | oui (24) |
| `TrainingSim_EggView.rbxm` | TrainingSim | Aperçu d'œuf (auto delete au clic, open 1/3/auto). | ★★★☆☆ (3) | oui (3) |
| `TweetingSim_IncubatorBillboards.rbxm` | TweetingSim | BillboardGui d'œufs (Hatch 1/3, prix). | ★★★☆☆ (3) | non |
| `RobotSim_EggOpen.rbxm` | RobotSim | Ouverture d'œuf (3 pets) + billboards d'œuf. | ★★☆☆☆ (2) | non |
| `TappingLords_Lootboxes.rbxm` | TappingLords | Inventaire de lootboxes à ouvrir. | ★★☆☆☆ (2) | oui (8) |
| `TappingLords_LootboxOpen.rbxm` | TappingLords | Animation d'ouverture de lootbox (flash, récompense). | ★☆☆☆☆ (1) | oui (3) |
| `TweetingSim_EggOpener.rbxm` | TweetingSim | Ouverture d'œuf (rareté). | ★☆☆☆☆ (1) | non |

## Trade

| Fichier | Jeu d'origine | Ce que c'est | Qualité | Scripts |
|---|---|---|---|---|
| `PunchSim_Trade.rbxm` | PunchSim | Fenêtre de trade (You / Other, Ready, Processing). | ★★★★★ (5) | non |
| `RebirthChampionsX_Trade.rbxm` | RebirthChampionsX | Trade complet (liste, requête, fenêtre, info). | ★★★★★ (5) | oui (4) |
| `MiningMasters_Trade.rbxm` | MiningMasters | Trade complet (requête, offres, inventaire, accept/decline). | ★★★★☆ (4) | non |
| `PetPharmica_Trade.rbxm` | PetPharmica | Trade (liste joueurs, demande entrante, offres + confirm). | ★★★★☆ (4) | oui (17) |
| `PunchSim_TradeList.rbxm` | PunchSim | Liste de joueurs pour trader. | ★★★★☆ (4) | non |
| `HatchingSim_Trade.rbxm` | HatchingSim | Système de trade complet (liste joueurs, requête, offres, ready, avertissement). | ★★★☆☆ (3) | oui (3) |
| `PetPharmica_TradeFrame.rbxm` | PetPharmica | Fenêtre de trade avec timer, ready/cancel, refus. | ★★★☆☆ (3) | oui (10) |
| `TappingLords_Trade.rbxm` | TappingLords | Fenêtre de trade avec pets et niveaux. | ★★★☆☆ (3) | oui (22) |

## Rebirth

| Fichier | Jeu d'origine | Ce que c'est | Qualité | Scripts |
|---|---|---|---|---|
| `PunchSim_Rebirth.rbxm` | PunchSim | Rebirth avec avant/après (force, gemmes, boost) + skip Robux. | ★★★★★ (5) | oui (2) |
| `RebirthChampionsX_Rebirth.rbxm` | RebirthChampionsX | Rebirth multiple + auto-rebirth. | ★★★★☆ (4) | non |
| `TrainingSim_Rebirth.rbxm` | TrainingSim | Rebirth + auto rebirth. | ★★★★☆ (4) | non |
| `MiningMasters_Rebirth.rbxm` | MiningMasters | Panneau Rebirth avec avant/après. | ★★★☆☆ (3) | non |
| `TappingLords_Rebirth.rbxm` | TappingLords | Grille de rebirths multiples (1, 5, 10…). | ★★★☆☆ (3) | oui (62) |
| `1HealthEverySecond_Rebirth.rbxm` | 1HealthEverySecond | Petit panneau Rebirth simple (wins requis + bouton). | ★★☆☆☆ (2) | oui (1) |

## Upgrades

| Fichier | Jeu d'origine | Ce que c'est | Qualité | Scripts |
|---|---|---|---|---|
| `PunchSim_Upgrades.rbxm` | PunchSim | Améliorations (multiplicateur force, pet equip, gems) payables en monnaie ou Robux. | ★★★★★ (5) | non |
| `RebirthChampionsX_UpgradesPotions.rbxm` | RebirthChampionsX | Améliorations à niveaux (0/16) + potions. | ★★★★★ (5) | non |
| `TrainingSim_Upgrades.rbxm` | TrainingSim | Améliorations à niveaux + rangs (titre/description/prix). | ★★★★★ (5) | non |
| `PetPharmica_GoldenMachine.rbxm` | PetPharmica | Machine à pets dorés (confirmation, chance %, coût). | ★★★★☆ (4) | oui (8) |
| `MiningMasters_Upgrades.rbxm` | MiningMasters | Fenêtre d'améliorations (squelette). | ★★★☆☆ (3) | non |
| `PetPharmica_Upgrades.rbxm` | PetPharmica | Liste d'améliorations (stockage…). | ★★★☆☆ (3) | oui (2) |
| `TappingLords_Upgrades.rbxm` | TappingLords | Améliorations gems + star upgrades [x/10]. | ★★★☆☆ (3) | oui (36) |
| `TappingLords_Potions.rbxm` | TappingLords | Achat de potions (stars). | ★★☆☆☆ (2) | oui (18) |

## DailyRewards_Gifts

| Fichier | Jeu d'origine | Ce que c'est | Qualité | Scripts |
|---|---|---|---|---|
| `MiningMasters_DailyRewards.rbxm` | MiningMasters | Calendrier de récompenses 7 jours + cadeaux. | ★★★★★ (5) | non |
| `PunchSim_Daily.rbxm` | PunchSim | Connexion quotidienne 7 jours avec gros lot jour 7. | ★★★★★ (5) | oui (4) |
| `PunchSim_Free.rbxm` | PunchSim | Cadeaux gratuits de temps de jeu (perdus si on quitte). | ★★★★★ (5) | non |
| `TrainingSim_Gifts.rbxm` | TrainingSim | Cadeaux gratuits (grille 0/10). | ★★★★★ (5) | oui (10) |
| `1JumpEverySecond_PlaytimeRewards.rbxm` | 1JumpEverySecond | Grille de cadeaux de temps de jeu (60:00, 'Leaving resets progress'). | ★★★★☆ (4) | non |
| `PunchSim_PetPack.rbxm` | PunchSim | Pack de pets gratuit après 20 min de jeu. | ★★★★☆ (4) | oui (1) |
| `CashgrabBridge_FreeTimer.rbxm` | CashgrabBridge | Récompense gratuite à minuteur ('FREE IN 00:00'). | ★★★☆☆ (3) | oui (8) |
| `HatchingSim_ChestReward.rbxm` | HatchingSim | Popup de coffre réclamé (+X monnaie, OK). | ★★★☆☆ (3) | oui (1) |
| `BakerySim_DailyLogin.rbxm` | BakerySim | Récompense quotidienne avec bouton SPIN. | ★★☆☆☆ (2) | oui (1) |
| `HatchingSim_DailyReward.rbxm` | HatchingSim | Panneau récompense quotidienne (claim / reviens dans X heures). | ★★☆☆☆ (2) | non |
| `HatchingSim_TimeRewards.rbxm` | HatchingSim | Récompenses de temps de jeu (Play 1 minute…). | ★★☆☆☆ (2) | oui (3) |
| `TappingLords_DailyGroup.rbxm` | TappingLords | Récompense quotidienne + récompense de groupe. | ★★☆☆☆ (2) | oui (8) |
| `TweetingSim_DailyRewards.rbxm` | TweetingSim | Récompenses quotidiennes. | ★★☆☆☆ (2) | non |

## SpinWheel

| Fichier | Jeu d'origine | Ce que c'est | Qualité | Scripts |
|---|---|---|---|---|
| `PunchSim_Wheel.rbxm` | PunchSim | Roue de spin + achat de spins (1/10/100). | ★★★★☆ (4) | oui (1) |
| `GlassBridge_Spinner.rbxm` | GlassBridge | Roue de la fortune (6 lots de cash) avec bouton Spin. | ★★★☆☆ (3) | oui (3) |

## Quests_Season

| Fichier | Jeu d'origine | Ce que c'est | Qualité | Scripts |
|---|---|---|---|---|
| `PunchSim_FreeHugeEvent.rbxm` | PunchSim | Event 'Free Huge' : quêtes (kills / temps) ou achat Robux. | ★★★★★ (5) | oui (1) |
| `PunchSim_Quests.rbxm` | PunchSim | Quêtes daily / weekly avec reset. | ★★★★★ (5) | non |
| `PunchSim_Season.rbxm` | PunchSim | Season pass free/premium avec paliers. | ★★★★★ (5) | oui (1) |
| `RebirthChampionsX_SeasonPass.rbxm` | RebirthChampionsX | Season pass + Easter pass + chasse aux œufs. | ★★★★★ (5) | non |
| `TrainingSim_PlaytimeAchievements.rbxm` | TrainingSim | Récompenses de temps de jeu/succès (titres). | ★★★★★ (5) | non |
| `MiningMasters_Quests.rbxm` | MiningMasters | Quêtes avec reset, récompenses et barre de progression. | ★★★★☆ (4) | oui (1) |
| `PunchSim_HackerEvent.rbxm` | PunchSim | Event 'Hacker' : quêtes ou achat Robux. | ★★★★☆ (4) | oui (1) |
| `HatchingSim_HatchPass.rbxm` | HatchingSim | Battle pass 'Hatch Pass' avec paliers et tokens. | ★★★☆☆ (3) | oui (16) |
| `TappingLords_Achievements.rbxm` | TappingLords | Succès par catégorie (rebirths, clicks, gems, eggs). | ★★★☆☆ (3) | oui (117) |

## Codes

| Fichier | Jeu d'origine | Ce que c'est | Qualité | Scripts |
|---|---|---|---|---|
| `BakerySim_Codes.rbxm` | BakerySim | Fenêtre de codes promo (champ + Apply). | ★★★☆☆ (3) | oui (2) |
| `MiningMasters_Codes.rbxm` | MiningMasters | Fenêtre de codes (Redeem). | ★★★☆☆ (3) | oui (1) |
| `PetPharmica_Codes.rbxm` | PetPharmica | Fenêtre 'Redeem Codes!'. | ★★★☆☆ (3) | oui (5) |
| `RobotSim_Codes.rbxm` | RobotSim | Fenêtre codes. | ★★☆☆☆ (2) | non |
| `TappingLords_Codes.rbxm` | TappingLords | Fenêtre codes (Redeem). | ★★☆☆☆ (2) | oui (12) |
| `TweetingSim_Codes.rbxm` | TweetingSim | Codes + popup de récompense. | ★★☆☆☆ (2) | non |

## Settings

| Fichier | Jeu d'origine | Ce que c'est | Qualité | Scripts |
|---|---|---|---|---|
| `PunchSim_Settings.rbxm` | PunchSim | Settings + Stats + Titres + Auras à onglets. | ★★★★★ (5) | non |
| `FirstDonations_Settings.rbxm` | FirstDonations | Réglages (musique, jour/nuit) avec Apply. | ★★★★☆ (4) | oui (3) |
| `RebirthChampionsX_Settings.rbxm` | RebirthChampionsX | Réglages à toggles (auras, boosts, musique, pets, popups). | ★★★★☆ (4) | non |
| `TrainingSim_Settings.rbxm` | TrainingSim | Réglages Visuals/General à toggles. | ★★★★☆ (4) | non |
| `HatchingSim_Settings.rbxm` | HatchingSim | Liste de réglages à toggles (debug, pets, musique, particules). | ★★★☆☆ (3) | oui (3) |
| `PetPharmica_Settings.rbxm` | PetPharmica | Réglages (optimisation, pet strength…). | ★★★☆☆ (3) | oui (5) |
| `RobotSim_Settings.rbxm` | RobotSim | Réglages (vitesse, popups, pets, son). | ★★★☆☆ (3) | non |
| `1JumpEverySecond_Settings.rbxm` | 1JumpEverySecond | Mini panneau de réglages (musique on/off). | ★★☆☆☆ (2) | non |
| `TappingLords_Settings.rbxm` | TappingLords | Réglages (musique, sons, thème < >). | ★★☆☆☆ (2) | oui (29) |
| `TweetingSim_Settings.rbxm` | TweetingSim | Réglages à toggles (hide UI, pets, popups, son, musique). | ★★☆☆☆ (2) | non |

## Notifications_Popups

| Fichier | Jeu d'origine | Ce que c'est | Qualité | Scripts |
|---|---|---|---|---|
| `PunchSim_Confirm.rbxm` | PunchSim | Boîte de confirmation Oui/Non. | ★★★★☆ (4) | non |
| `PunchSim_SpecialEvent.rbxm` | PunchSim | Bannière 'Special Event'. | ★★★★☆ (4) | non |
| `RebirthChampionsX_Popups.rbxm` | RebirthChampionsX | Messages d'erreur/gain empilés + popup merci. | ★★★★☆ (4) | non |
| `FirstDonations_WelcomeAlert.rbxm` | FirstDonations | Alerte de bienvenue animée (ES). | ★★★☆☆ (3) | oui (1) |
| `GlassBridge_WinScreen.rbxm` | GlassBridge | Écran 'YOU WON!' avec Claim. | ★★★☆☆ (3) | oui (2) |
| `TappingLords_ErrorMessages.rbxm` | TappingLords | Messages 'pas assez de place / trop de pets'. | ★★★☆☆ (3) | non |
| `TrainingSim_Error.rbxm` | TrainingSim | Message d'erreur. | ★★★☆☆ (3) | non |
| `TweetingSim_Popups.rbxm` | TweetingSim | Sac plein (offre), notifications, tooltip, message global, confirm. | ★★★☆☆ (3) | non |
| `BillionaireTycoon_Welcome.rbxm` | BillionaireTycoon | Popup de bienvenue avec avantages et bouton OK. | ★★☆☆☆ (2) | oui (1) |
| `HatchingSim_Warnings.rbxm` | HatchingSim | Notifications 'pas assez de place / d'argent'. | ★★☆☆☆ (2) | non |
| `PunchSim_Notifications.rbxm` | PunchSim | Conteneur de notifications en bas d'écran. | ★★☆☆☆ (2) | non |
| `PunchSim_Reward.rbxm` | PunchSim | Écran 'You received' cliquable. | ★★☆☆☆ (2) | non |
| `ShootABrainrot_Notify.rbxm` | ShootABrainrot | Template de notification. | ★★☆☆☆ (2) | non |
| `TappingLords_GainEffect.rbxm` | TappingLords | Effet '+999K' de gain flottant. | ★★☆☆☆ (2) | oui (1) |
| `BakerySim_BasicPopup.rbxm` | BakerySim | Scripts de popup/notification texte simples (cart full, clients arrivés). | ★☆☆☆☆ (1) | oui (2) |
| `BakerySim_LevelUp.rbxm` | BakerySim | Bannière 'You've reached LEVEL X'. | ★☆☆☆☆ (1) | non |
| `FirstDonations_ClaimPopup.rbxm` | FirstDonations | Petit popup 'Successfully claimed' avec sons. | ★☆☆☆☆ (1) | oui (1) |
| `FirstDonations_HoverTooltip.rbxm` | FirstDonations | Infobulle au survol (nom, type, prix). | ★☆☆☆☆ (1) | oui (1) |

## Loading_Intro

| Fichier | Jeu d'origine | Ce que c'est | Qualité | Scripts |
|---|---|---|---|---|
| `HatchingSim_Loading.rbxm` | HatchingSim | Écran de chargement avec pourcentage et séquence de fin. | ★★★☆☆ (3) | oui (5) |
| `Lib_SimpleLoadUIV2.rbxm` | Lib | Loading screen simple avec Skip (LocalScript qui crée la GUI). | ★★★☆☆ (3) | oui (3) |
| `MiningMasters_LoadingScreen.rbxm` | MiningMasters | Écran de chargement scripté. | ★★★☆☆ (3) | oui (3) |
| `RebirthChampionsX_Loading.rbxm` | RebirthChampionsX | Chargement (pourcentage) + transition. | ★★★☆☆ (3) | oui (2) |
| `TappingLords_Intro.rbxm` | TappingLords | Intro/écran titre animé avec bouton PLAY. | ★★★☆☆ (3) | oui (2) |
| `BakerySim_Load.rbxm` | BakerySim | Écran titre avec bouton Play et caméra de départ. | ★★☆☆☆ (2) | oui (2) |

## Leaderboard

_Aucun fichier._

## Admin_Debug

| Fichier | Jeu d'origine | Ce que c'est | Qualité | Scripts |
|---|---|---|---|---|
| `BakerySim_AdminPanel.rbxm` | BakerySim | Panneau admin (wipe data, shutdown, give coins…) — à protéger côté serveur. | ★★★☆☆ (3) | oui (2) |
| `HatchingSim_DebugMode.rbxm` | HatchingSim | Overlay debug (playtime, position, FPS/ping). | ★☆☆☆☆ (1) | oui (3) |

## Index_Collection

| Fichier | Jeu d'origine | Ce que c'est | Qualité | Scripts |
|---|---|---|---|---|
| `RebirthChampionsX_Index.rbxm` | RebirthChampionsX | Index de pets avec récompenses de collection. | ★★★★★ (5) | non |
| `ShootABrainrot_MobIndex.rbxm` | ShootABrainrot | Index de mobs avec %. | ★★★★☆ (4) | non |
| `BakerySim_RecipeBook.rbxm` | BakerySim | Livre de recettes à onglets (catégories, compteur 'Baked'). | ★★★☆☆ (3) | oui (1) |
| `TappingLords_Index.rbxm` | TappingLords | Index de pets. | ★★★☆☆ (3) | oui (19) |
| `HatchingSim_PetIndex.rbxm` | HatchingSim | Index des pets par œuf avec chances. | ★★☆☆☆ (2) | oui (4) |
| `RobotSim_Index.rbxm` | RobotSim | Index de pets. | ★★☆☆☆ (2) | non |

## Profile_Stats

| Fichier | Jeu d'origine | Ce que c'est | Qualité | Scripts |
|---|---|---|---|---|
| `PunchSim_Ranks.rbxm` | PunchSim | Rangs de progression (actuel / suivant, claim). | ★★★★★ (5) | non |
| `TrainingSim_Stats.rbxm` | TrainingSim | Statistiques joueur. | ★★★★☆ (4) | non |
| `RebirthChampionsX_Profile.rbxm` | RebirthChampionsX | Profil joueur (temps de jeu, robux dépensés, œufs, rebirths). | ★★★☆☆ (3) | non |
| `HatchingSim_Stats.rbxm` | HatchingSim | Fenêtre de statistiques (coins, œufs, secrets, stats d'event). | ★★☆☆☆ (2) | oui (12) |
| `TappingLords_Profile.rbxm` | TappingLords | Profil (rang, stats). | ★★☆☆☆ (2) | oui (19) |

## Teleport_Zones

| Fichier | Jeu d'origine | Ce que c'est | Qualité | Scripts |
|---|---|---|---|---|
| `PetPharmica_Teleport.rbxm` | PetPharmica | Liste de mondes à téléporter (Plains, Atlantis, Volcano…). | ★★★★★ (5) | oui (19) |
| `MiningMasters_TeleportZones.rbxm` | MiningMasters | Téléport + popup d'achat de zone. | ★★★★☆ (4) | non |
| `TrainingSim_Teleport.rbxm` | TrainingSim | Téléport entre gyms (acheter / téléporter). | ★★★★☆ (4) | non |
| `TappingLords_PortalBuy.rbxm` | TappingLords | Popups d'achat de zones (5 portails). | ★★★☆☆ (3) | oui (15) |
| `TweetingSim_TeleporterBillboards.rbxm` | TweetingSim | BillboardGui d'achat de téléporteurs. | ★★★☆☆ (3) | non |
| `PetPharmica_TravelTransition.rbxm` | PetPharmica | Transition 'Traveling to <monde>'. | ★★☆☆☆ (2) | oui (1) |
| `PetPharmica_AreaDoor.rbxm` | PetPharmica | Popup d'achat de zone (Unlock/Decline) + bouton E. | ★☆☆☆☆ (1) | oui (7) |

## Components_Kits

| Fichier | Jeu d'origine | Ce que c'est | Qualité | Scripts |
|---|---|---|---|---|
| `CrypticPack_Buttons.rbxm` | CrypticPack | Pack de boutons (simulator, shortcut, realistic) — briques de base. | ★★★★☆ (4) | oui (1) |
| `Lib_UIMegaPack.rbxm` | Lib | Méga-pack de composants (boutons icônes, boutons texte, panneaux couleur) — déjà découpé dans ui_split/UIMegaPack. | ★★★★☆ (4) | non |
| `CrypticPack_Frames.rbxm` | CrypticPack | Cadres/fenêtres de base (UIS1/UIS2). | ★★★☆☆ (3) | oui (1) |
| `CrypticPack_Images.rbxm` | CrypticPack | Planche d'images/icônes. | ★★★☆☆ (3) | oui (1) |
| `CrypticPack_Other.rbxm` | CrypticPack | Éléments génériques (scrolling, textbox, viewport, stackers). | ★☆☆☆☆ (1) | non |

## Misc

| Fichier | Jeu d'origine | Ce que c'est | Qualité | Scripts |
|---|---|---|---|---|
| `FirstDonations_EditGui_Full.rbxm` | FirstDonations | Menu complet de jeu de donation (stand, danses, cadeaux, shop, settings), textes ES. | ★★★★★ (5) | oui (54) |
| `PunchSim_Auras.rbxm` | PunchSim | Inventaire d'auras (Fire, Electro, Divine…) avec Equip. | ★★★★★ (5) | non |
| `PunchSim_Clans.rbxm` | PunchSim | Système de clans (liste, créer, rejoindre, quêtes de clan). | ★★★★★ (5) | non |
| `PunchSim_Tutorial.rbxm` | PunchSim | Tutoriel en pages (NEXT >>). | ★★★★★ (5) | non |
| `GlassBridge_InviteRewards.rbxm` | GlassBridge | Récompenses d'invitation (3/5/13 amis) + popup invite. | ★★★★☆ (4) | oui (6) |
| `MiningMasters_FeedbackUpdatesTuto.rbxm` | MiningMasters | Feedback, report bugs, update log, tutoriel. | ★★★★☆ (4) | oui (1) |
| `PetPharmica_UpdateLog.rbxm` | PetPharmica | Journal des mises à jour. | ★★★★☆ (4) | oui (3) |
| `PunchSim_DiscordVerification.rbxm` | PunchSim | Récompense vérification Discord. | ★★★★☆ (4) | oui (1) |
| `PunchSim_InviteRewards.rbxm` | PunchSim | Récompenses d'invitation d'amis (pages). | ★★★★☆ (4) | non |
| `ShootABrainrot_SellMobs.rbxm` | ShootABrainrot | Fenêtre de vente (Sell all). | ★★★★☆ (4) | non |
| `BakerySim_BuildEditor.rbxm` | BakerySim | Interface de mode construction (placement fours/sols, couleurs). | ★★★☆☆ (3) | oui (5) |
| `CashgrabBridge_Spectate.rbxm` | CashgrabBridge | Système Spectate (bouton + < nom >). | ★★★☆☆ (3) | oui (2) |
| `FirstDonations_Piano.rbxm` | FirstDonations | Piano jouable au clavier (touches + partitions). | ★★★☆☆ (3) | oui (1) |
| `GlassBridge_RaceReward.rbxm` | GlassBridge | Bannière de course 'Beat for gift / Mega reward'. | ★★★☆☆ (3) | oui (3) |
| `GlassBridge_TrollMenu.rbxm` | GlassBridge | Menu troll (choisir joueur, Kill/Fling/Jumpscare). | ★★★☆☆ (3) | oui (5) |
| `HatchingSim_MainUI_Full.rbxm` | HatchingSim | Toute l'UI du jeu d'éclosion (pets, trade, shop, pass, index, settings…). | ★★★☆☆ (3) | oui (71) |
| `RebirthChampionsX_Auras.rbxm` | RebirthChampionsX | Auras à débloquer/équiper. | ★★★☆☆ (3) | non |
| `RebirthChampionsX_UpdateLog.rbxm` | RebirthChampionsX | Update log. | ★★★☆☆ (3) | non |
| `RobotSim_CreditsUpdateLog.rbxm` | RobotSim | Crédits + update log. | ★★★☆☆ (3) | non |
| `RobotSim_UIModules.rbxm` | RobotSim | Modules UI (UIMain warn/question, settings, weapon shop, egg, pet) — logique de l'UI 'main'. | ★★★☆☆ (3) | oui (56) |
| `TappingLords_FrameUI_Full.rbxm` | TappingLords | Tous les menus du jeu (shop, settings, codes, profil, succès, daily, titres, lootbox, index). | ★★★☆☆ (3) | oui (400) |
| `TappingLords_Titles.rbxm` | TappingLords | Titres à débloquer/sélectionner. | ★★★☆☆ (3) | oui (48) |
| `CashgrabBridge_InviteFriend.rbxm` | CashgrabBridge | Bouton d'invitation d'amis avec badge. | ★★☆☆☆ (2) | oui (3) |
| `FirstDonations_Dances.rbxm` | FirstDonations | Menu de danses/émotes gratuites (liste générée par script). | ★★☆☆☆ (2) | oui (1) |
| `FirstDonations_MusicPlayer.rbxm` | FirstDonations | Lecteur de musique / radio (thème clair + sombre, chansons recommandées), textes ES. | ★★☆☆☆ (2) | oui (10) |
| `PetPharmica_SuggestionWall.rbxm` | PetPharmica | SurfaceGui mur de suggestions (Submit). | ★★☆☆☆ (2) | oui (3) |
| `CashgrabBridge_Feedback.rbxm` | CashgrabBridge | Fenêtre de feedback (TextBox + Submit). | ★☆☆☆☆ (1) | oui (3) |
| `GlassBridge_Jumpscare.rbxm` | GlassBridge | Écran de jumpscare plein écran. | ★☆☆☆☆ (1) | oui (1) |
| `HatchingSim_UpdateLog.rbxm` | HatchingSim | Journal des mises à jour. | ★☆☆☆☆ (1) | oui (1) |
| `PetPharmica_FX.rbxm` | PetPharmica | Effet de transition cercle + texte. | ★☆☆☆☆ (1) | oui (1) |

## Sécurité

- Tous les fichiers ont été scannés (`analyze.py`) : aucun `require(id)`, `getfenv`, `loadstring`, `InsertService`, ni obfuscation.
- Un webhook Discord du jeu d'origine (non utilisé) a été retiré de `Eggs_Hatch/TappingLords_EggPreview.rbxm` (BuyScript).
- Restent des `game:GetService("HttpService")` inoffensifs (GenerateGUID / variables inutilisées) dans quelques scripts Tapping Lords, Mining Masters, Robot Sim et Cashgrab Feedback.
- `Admin_Debug/BakerySim_AdminPanel` et les menus « troll » (Kill all, Nuke…) ne doivent être actifs qu'avec une vérification **côté serveur**.

## Ajouts du 17/10/2026 (fichiers isolés, hors jeux)

| Fichier | Ce que c'est | Scripts |
|---|---|---|
| `HUD_Currency/Lib_HUD_ButtonsMoney.rbxm` | HUD « HUD » : boutons Rebirth / Settings / Store / Buy / Home / Sell + compteur d'argent (dégradés, ombres). | non |
| `HUD_Currency/Lib_Hud_LeftRightTop.rbxm` | HUD complet gauche/droite/haut : Achievements, Codes, DailyRewards, Pets, Rebirth, SeasonPass, Trade, Shop, Stats, Teleport, Auto, Rewards. | non |
| `Index_Collection/Lib_IndexButton.rbxm` | Bouton « Index » seul (image + texte). | non |
| `SpinWheel/Lib_SpinWheel_Full.rbxm` | Roue complète « Spin Wheel » : spins Robux, cotes, récompenses progressives, pity bar, blocage par région. | non |
| `Admin_Debug/Lib_F2AdminButton.rbxm` | Bouton admin F2 (Conch) — ⚠️ ID admin d'un inconnu à remplacer. | oui (1) |
| `Components_Kits/Lib_UIKit_vortex_tree.rbxm` | UI kit de vortex_tree. | oui |
| `Loading_Intro/Lib_Loading_Brainrot.rbxm` | Loading « brainrot » (0/2500, tips, Skip). | oui (1) |
| `Loading_Intro/Lib_Loading_Pazze.rbxm` | Loading animé avec tips, son et blur — ⚠️ retirer le commentaire insultant. | oui (1) |

Aussi : `ui/Icons/SimulatorIcons.rbxm` (planche d'icônes simulateur), `ui/Icons/Icons_gtasixseven.rbxl` (icônes + Kohl's Admin + F3X), `ui/Icons/k4lsh/` (6 PNG), `ui/Figma/` (Codes v1/v2, Rewards), et tout `ui/SpookyGame/` (voir `packs/LISEZMOI_PACKS.md`).