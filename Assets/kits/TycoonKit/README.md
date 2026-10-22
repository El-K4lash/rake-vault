# TycoonKit

Kit tycoon complet et propre (code neuf, serveur-autoritaire) : plots + porte Claim, droppers, convoyeur, upgraders, collecteur + banque, pad Collect, boutons d'achat séquentiels, sauvegarde DataStore.

## Installation
Insère `TycoonKit.rbxm`, puis déplace chaque dossier `KIT_Tycoon` dans le service du même nom :

| Dossier du kit | Service | Contenu |
|---|---|---|
| Workspace/KIT_Tycoon | Workspace | `PlotSpots` (1 Part = 1 plot, 2 fournis à X=600 et X=710) |
| ServerScriptService/KIT_Tycoon | ServerScriptService | `TycoonServer` (Script), `PlayerData` (Module DataStore) |
| ReplicatedStorage/KIT_Tycoon | ReplicatedStorage | `TycoonConfig` (tous les réglages), `Notify` (RemoteEvent serveur→client) |
| ServerStorage/KIT_Tycoon | ServerStorage | `PlotTemplate` (cloné sur chaque Spot) |
| StarterGui/KIT_Tycoon | StarterGui | `TycoonHUD` (messages à l'écran) |

Un Script désactivé `README` à la racine du Model reprend ces explications.

## Fonctionnement
1. Toucher la porte bleue → le plot appartient au joueur.
2. Bouton « Dropper #1 » gratuit → objets sur le convoyeur → upgraders (x2, x1.5) → collecteur → **banque** du plot.
3. Pad doré **COLLECT** → la banque passe dans le Cash (leaderstats).
4. Chaque achat débloque le suivant (`Requires` dans la Config) : Dropper1 → Dropper2 → Upgrader1 → Dropper3 → Mur → Super Dropper / Lampadaires → Upgrader2 → Murs latéraux / Jardin → Machine géante.
5. Départ : banque ajoutée au cash, sauvegarde, plot libéré. Retour : le joueur reprend un plot et tout est reconstruit.

## Configurer
Tout est dans `ReplicatedStorage.KIT_Tycoon.TycoonConfig` : prix, prérequis, valeur/intervalle des droppers, multiplicateurs, vitesse du convoyeur, limites anti-lag, distance d'interaction, nom du DataStore, autosave.

Ajouter un élément : Model dans `PlotTemplate.Items` (nom = Id ; Part `Drop` pour un dropper, Part `Laser` pour un upgrader) + bouton du même nom dans `PlotTemplate.Buttons` + ligne dans `Config.Items`.

Aucun ID de gamepass/produit à configurer.

## Sauvegarde
DataStore `KIT_Tycoon_v1`, clé `Player_<UserId>` : `{version, cash, purchased = {ids}}`. UpdateAsync + pcall + retry/backoff, verrou de session (anti-dupe), autosave 60 s, sauvegarde au départ et `BindToClose`. Si le chargement échoue en ligne → kick (pas d'écrasement). Dans Studio sans « Studio Access to API Services » → partie sans sauvegarde.

## Sécurité
Le serveur n'écoute aucun RemoteEvent : claim, achats et collect sont des contacts vérifiés côté serveur (joueur vivant, propriétaire du plot, distance réelle, cooldown, prix et prérequis lus côté serveur, cash vérifié avant débit). Objets du convoyeur possédés par le serveur (`SetNetworkOwner(nil)`), nombre limité par plot, durée de vie limitée.

## Modèles réutilisés
Lampadaires, arbres, banc : Zednov's Tycoon Kit (Billionaire Tycoon) — scripts retirés. Texture du tapis : convoyeur Bakery Simulator. Décor « Machine géante » : UpgradeMachine (réduite à 40 %).
