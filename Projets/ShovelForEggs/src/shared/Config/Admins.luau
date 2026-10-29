--!strict
-- Shared/Config/Admins
-- PROPRIÉTAIRE(S) du panel admin : accès complet ET seuls à pouvoir nommer / retirer des admins (onglet ADMINS).
-- Les admins nommés depuis le panel sont gardés en DataStore : ils ont le panel, mais ne peuvent ni nommer
-- d'autres admins, ni agir (kick / ban / reset...) sur un propriétaire.
-- (En Studio, tout le monde est propriétaire pour pouvoir tester.)
return {
	OwnerIds = { 11848575080 } :: { number },
	-- le jeu appartient au groupe : son propriétaire (rang 255) et ses admins (rang >= OwnerRank) sont aussi propriétaires du panel
	GroupId = 955449225,
	OwnerRank = 254,
	OpenKey = Enum.KeyCode.F2, -- touche pour ouvrir le panel
}
