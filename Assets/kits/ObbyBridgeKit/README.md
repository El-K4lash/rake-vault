# ObbyBridgeKit – Obby / Glass Bridge

Kit Roblox prêt à l'emploi : pont de verre (une vitre solide, une qui casse), checkpoints, kill bricks, plateforme de victoire avec Wins sauvegardés, timer de manche, écran de victoire et Developer Product « Skip stage ».
Inspiré de GlassBridge / CashgrabBridgeEU, code réécrit de zéro (aucun script d'origine).

## Installation
Insère `ObbyBridgeKit.rbxm` dans Studio, puis déplace chaque dossier dans son service :

| Dans le Model | Va dans |
|---|---|
| `Workspace/KIT_Obby` | Workspace (contient `ObbyMap`) |
| `ReplicatedStorage/KIT_Obby` | ReplicatedStorage (`ObbyConfig`) |
| `ServerScriptService/KIT_Obby` | ServerScriptService (`ObbyServer`, `ObbyService`, `GlassBridge`, `WinsStore`, `README`) |
| `StarterGui/KIT_Obby_HUD` + `KIT_Obby_WinGui` | StarterGui |

Ne renomme pas les dossiers `KIT_Obby` (les scripts les cherchent par nom). Supprime ensuite le Model vide.

## Configuration (`ReplicatedStorage.KIT_Obby.ObbyConfig`)
- `GlassRows` : nombre de rangées. L'espacement s'adapte entre les repères `GlassStart` et `GlassEnd`.
- `GlassSize`, `GlassSideOffset`, `GlassColor`, `GlassTransparency`, `GlassBreakSound`.
- `RoundDuration` : durée d'une manche (s). À chaque nouvelle manche, nouveau motif de verre.
- `ResetPlayersOnNewRound` : renvoie tout le monde au départ à chaque manche.
- `WinsPerVictory`, `WinCooldown`.
- `SkipStageProductId` : ID du Developer Product (0 = bouton caché).
- `OwnProcessReceipt` : `true` = le kit définit `MarketplaceService.ProcessReceipt`. Si ton jeu en a déjà un (un seul autorisé par jeu), mets `false` et appelle `ObbyService.HandleReceipt(receiptInfo)` depuis ton handler (il renvoie `nil` si l'achat ne concerne pas le kit).
- `DataStoreName`, `AutoSaveInterval`.

Pour tester la sauvegarde dans Studio : Game Settings > Security > *Enable Studio Access to API Services*.

## Modifier le parcours (`Workspace.KIT_Obby.ObbyMap`)
- `Start` : départ (étape 0, respawn).
- `Checkpoints/` : Parts avec l'attribut `Stage` = 1, 2, 3… dans l'ordre. Le plus grand = étape requise pour gagner.
- `KillBricks/` : toute Part ici tue au contact.
- `GlassBridge/GlassStart` et `GlassEnd` : repères invisibles du pont (les vitres sont générées au lancement dans `GlassBridge/Generated`).
- `Obstacles/` : plateformes de saut.
- `WinPad` : plateforme de victoire (+Wins puis retour au départ).

## Sécurité
- Le motif du verre n'existe que dans une table serveur : rien de répliqué (attribut, propriété) ne révèle la bonne vitre.
- Le client n'envoie aucun remote : il reçoit seulement `ObbyNotify` (checkpoint, victoire, nouvelle manche).
- Checkpoints validés dans l'ordre (impossible d'en sauter), victoire seulement si le dernier checkpoint est atteint, cooldown anti double-gain.
- Wins gardés dans une table serveur ; les leaderstats ne servent qu'à l'affichage.
- DataStore : `UpdateAsync` + retry exponentiel, autosave, `BindToClose`. Un joueur dont le chargement a échoué n'est pas sauvegardé (pas d'écrasement).
- ProcessReceipt : idempotent par `PurchaseId`, `NotProcessedYet` si le joueur n'est plus là.
