--!strict
-- Shared/Config/NextWorld
-- Le prochain monde (au-delà du Void) : affiché par le portail de la zone Void, pas encore jouable.
-- Les conditions sont montrées au joueur pour qu'il se prépare ; Available passe à true le jour de la mise à jour.
return {
	Available = false,
	Rebirths = 5, -- 1 rebirth = 1 zone de plus : le Void (zone 5) s'ouvre au rebirth 4, le monde suivant au 5
	Money = 1_000_000_000,
	Brainrots = 60, -- brainrots différents découverts (Index)
}
