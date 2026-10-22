--!strict
-- Shared/Config/Admins
-- PROPRIÉTAIRE(S) du panel admin : accès complet ET seuls à pouvoir nommer / retirer des admins (onglet ADMINS).
-- Les admins nommés depuis le panel sont gardés en DataStore : ils ont le panel, mais ne peuvent ni nommer
-- d'autres admins, ni agir (kick / ban / reset...) sur un propriétaire.
-- (En Studio, tout le monde est propriétaire pour pouvoir tester.)
return {
	OwnerIds = { 11848575080 } :: { number },
	OpenKey = Enum.KeyCode.F2, -- touche pour ouvrir le panel
}
