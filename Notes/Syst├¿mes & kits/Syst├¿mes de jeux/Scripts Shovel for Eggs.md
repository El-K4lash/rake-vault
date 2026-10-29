---
title: "Scripts Shovel for Eggs"
id: "SFE_Scripts"
catégorie: "Systèmes & kits"
sous-catégorie: "Systèmes de jeux"
version: "29/10/2026"
source: "Assets/systems/ShovelForEggs/ShovelForEggs_Scripts.rbxm"
tags: [categorie/systemes-kits, type/lib-sys, jeu/shovel-for-eggs]
---

# Scripts Shovel for Eggs

Tout le code du jeu au 29/10/2026 : **73 scripts, ~13159 lignes**. Serveur autoritaire (services), client en contrôleurs, config partagée. Base réutilisable pour les prochains jeux du groupe (copier, renommer, nouvelle clé DataStore).

- **Pack Studio** : `Assets/systems/ShovelForEggs/ShovelForEggs_Scripts.rbxm` (dossiers ServerScriptService / StarterPlayerScripts / Shared à remettre à leur place)
- **Sources lisibles** : `Projets/ShovelForEggs/src/` (server / client / shared)
- **Place complète** : `Projets/ShovelForEggs/ShovelForEggs_29oct.rbxl`
- **Sécurité** : scan fait le 29/10/2026 — aucun require(ID), webhook, loadstring ni HttpService externe.

## Fichiers

- `client/Client/AdminController.luau`
- `client/Client/BaseController.luau`
- `client/Client/BoardController.luau`
- `client/Client/BoostController.luau`
- `client/Client/DigFx.luau`
- `client/Client/FusionController.luau`
- `client/Client/GroupChestController.luau`
- `client/Client/HUDController.luau`
- `client/Client/HotbarController.luau`
- `client/Client/IndexController.luau`
- `client/Client/ItemsController.luau`
- `client/Client/LbBoardController.luau`
- `client/Client/LeaderboardController.luau`
- `client/Client/LobbyController.luau`
- `client/Client/Main.client.luau`
- `client/Client/MusicController.luau`
- `client/Client/NotifyController.luau`
- `client/Client/PenController.luau`
- `client/Client/PenFxController.luau`
- `client/Client/PerfController.luau`
- `client/Client/PlotTagController.luau`
- `client/Client/RebirthController.luau`
- `client/Client/RewardsController.luau`
- `client/Client/ShopController.luau`
- `client/Client/ShovelController.luau`
- `client/Client/SledAnimController.luau`
- `client/Client/SliceController.luau`
- `client/Client/State.luau`
- `client/Client/StoreController.luau`
- `client/Client/StormController.luau`
- `client/Client/StormFxController.luau`
- `client/Client/TutorialController.luau`
- `client/Client/UI.luau`
- `client/Client/UpgradeController.luau`
- `client/Client/WorldController.luau`
- `server/Lib/Net.luau`
- `server/Lib/Stats.luau`
- `server/Main.server.luau`
- `server/Services/AdminService.luau`
- `server/Services/CodesService.luau`
- `server/Services/DataService.luau`
- `server/Services/DebugService.luau`
- `server/Services/EconomyService.luau`
- `server/Services/EggService.luau`
- `server/Services/HarvestService.luau`
- `server/Services/IndexService.luau`
- `server/Services/LeaderboardService.luau`
- `server/Services/LobbyService.luau`
- `server/Services/PlotService.luau`
- `server/Services/RebirthService.luau`
- `server/Services/RewardsService.luau`
- `server/Services/SettingsService.luau`
- `server/Services/SledService.luau`
- `server/Services/StoreService.luau`
- `server/Services/StormService.luau`
- `server/Services/TutorialService.luau`
- `server/Services/UpgradeService.luau`
- `server/Services/WorldService.luau`
- `shared/Config/Admins.luau`
- `shared/Config/Eggs.luau`
- `shared/Config/Events.luau`
- `shared/Config/Items.luau`
- `shared/Config/Levels.luau`
- `shared/Config/Lobby.luau`
- `shared/Config/Mutations.luau`
- `shared/Config/Pets.luau`
- `shared/Config/Rebirth.luau`
- `shared/Config/Store.luau`
- `shared/Config/Upgrades.luau`
- `shared/Config/Zones.luau`
- `shared/PenBuilder.luau`
- `shared/Util/Format.luau`
- `shared/Util/Slice9.luau`
