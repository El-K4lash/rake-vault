# SimulatorKit

Kit « simulator » prêt à l'emploi : entraînement → Force, SellPad → Cash, œuf → pets aléatoires qui suivent le joueur et multiplient les gains, inventaire (équiper/retirer), Rebirth, sauvegarde DataStore.

## Installation

Insère `SimulatorKit.rbxm` dans Studio, puis déplace chaque dossier dans son service (garde les noms) :

| Dans le Model | À mettre dans |
|---|---|
| `Workspace/KIT_Simulator` | Workspace (SellPad + EggStand, déplaçables) |
| `ServerScriptService/KIT_Simulator` | ServerScriptService |
| `ReplicatedStorage/KIT_Simulator` | ReplicatedStorage |
| `StarterGui/KIT_SimulatorHUD` | StarterGui |
| `StarterPlayerScripts/KIT_Simulator` | StarterPlayer > StarterPlayerScripts |

Un script `README` désactivé (en français) est inclus dans le kit avec les mêmes infos.

## Commandes joueur

- **ENTRAÎNER** (bouton bas d'écran ou touche **E**) : + Force
- Marcher sur la dalle **VENDRE** : Force → Cash
- Près de l'œuf, maintenir **F** : ouvre un œuf (50 Cash par défaut)
- Bouton **Pets** (gauche) : inventaire, Équiper / Retirer (3 max)
- Bouton **Rebirth** (gauche) : remet Cash/Force à 0, +50 % de multiplicateur permanent

## Configuration

Tout est dans `ReplicatedStorage.KIT_Simulator.Config` : gains, cooldowns, prix de l'œuf, poids des raretés (Common/Rare/Epic/Legendary), liste des pets et leurs bonus, limites d'inventaire, coût et bonus du rebirth, nom du DataStore. Aucun ID de gamepass/produit à remplir.

Pour ajouter un pet : un Model (avec PrimaryPart) dans `Assets/Pets` + une ligne dans `Config.Pets` avec le même nom.

## Architecture

- `SimulatorServer` (ModuleScript serveur) : toute la logique (Train, Sell, Hatch, Equip, Unequip, Rebirth). Les RemoteEvents ne font que demander ; types vérifiés, cooldown anti-spam par joueur et par action, prix/raretés lus uniquement dans la Config côté serveur. La vente passe par le `Touched` serveur du SellPad, l'œuf par le `ProximityPrompt` serveur.
- `PlayerData` (ModuleScript serveur) : `UpdateAsync` uniquement, `pcall` + retry avec backoff, verrou de session (JobId), autosave 60 s, sauvegarde au départ, `BindToClose`. Les données chargées sont nettoyées (types, pets inconnus). En jeu publié, un échec de chargement kick le joueur (jamais d'écrasement de sauvegarde). En Studio sans accès API, le jeu tourne sans sauvegarde (avertissement console).
- `HUDController` (LocalScript) : affichage des stats, inventaire (ViewportFrames), popup d'éclosion, notifications.
- `PetFollow` (LocalScript) : le serveur crée les modèles de pets dans `Workspace.KIT_Simulator.ActivePets`, chaque client les anime localement en arc derrière leur propriétaire (fluide, aucun trafic réseau).
- Multiplicateur = (1 + rebirths × 0,5) × (1 + somme des bonus des pets équipés).

## Origine des assets

- Pets (Bear, Bunny, Fox, Parrot, Dragon, Red Dragon, Crown) et œuf : Tapping Lords Simulator, nettoyés (aucun script, pièces ancrées, sans collision).
- Icônes Pets / Rebirth / Retour et bouton Rebirth : UIMegaPack.
- Code : entièrement neuf (aucun script des jeux d'origine).
