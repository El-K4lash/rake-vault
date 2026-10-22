--!strict
-- Shared/Config/Brainrots
-- Les 87 brainrots du jeu. Les modèles viennent du pack Brainrots_Animated de la lib
-- (ReplicatedStorage/Assets/Brainrots/<Variante>/<Nom>). Income = $ par seconde (base).
-- Rarities : Common, Rare, Epic, Legendary, Mythic, Secret.

export type Brainrot = { Id: string, Name: string, Rarity: string, Income: number, Zone: string }

local Rarities = {
	{ Id = "Common",    Name = "Common",    Color = Color3.fromRGB(176, 182, 196), Income = 1,    SellMult = 20 },
	{ Id = "Rare",      Name = "Rare",      Color = Color3.fromRGB(79, 216, 255),  Income = 5,    SellMult = 25 },
	{ Id = "Epic",      Name = "Epic",      Color = Color3.fromRGB(178, 107, 255), Income = 25,   SellMult = 30 },
	{ Id = "Legendary", Name = "Legendary", Color = Color3.fromRGB(255, 204, 51),  Income = 150,  SellMult = 40 },
	{ Id = "Mythic",    Name = "Mythic",    Color = Color3.fromRGB(255, 95, 168),  Income = 1000, SellMult = 50 },
	{ Id = "Secret",    Name = "Secret",    Color = Color3.fromRGB(40, 40, 50),    Income = 8000, SellMult = 80 },
}
local RarityById: { [string]: any } = {}
for i, r in ipairs(Rarities) do (r :: any).Order = i; RarityById[r.Id] = r end

-- Nom = nom exact du modèle dans le pack
local function b(name: string, rarity: string, income: number, zone: string): Brainrot
	return { Id = name, Name = name, Rarity = rarity, Income = income, Zone = zone }
end

local List: { Brainrot } = {
	-- Common (Beach)
	b("Pipi Kiwi", "Common", 1, "Beach"),
	b("Pipi Potato", "Common", 1.2, "Beach"),
	b("Fluri Flura", "Common", 1.4, "Beach"),
	b("Talpa Di Fero", "Common", 1.5, "Beach"),
	b("Svinina Bombardino", "Common", 1.7, "Beach"),
	b("Tim Cheese", "Common", 1.9, "Beach"),
	b("Boneca Ambalabu", "Common", 2.1, "Beach"),
	b("Cacto Hipopotamo", "Common", 2.2, "Beach"),
	b("Trippi Troppi", "Common", 2.4, "Beach"),
	b("Avocadini Guffo", "Common", 2.6, "Beach"),
	b("Bananita Dolphinita", "Common", 2.8, "Beach"),
	b("Lirili Larila", "Common", 2.9, "Beach"),
	b("Tralalita Tralala", "Common", 3.1, "Beach"),
	b("Agarrini La Pallini", "Common", 3.3, "Beach"),
	b("Bambini Crostini", "Common", 3.5, "Beach"),
	b("Swag Soda", "Common", 3.6, "Beach"),
	b("Smurfo Gatto", "Common", 3.8, "Beach"),
	b("Chillin Chili", "Common", 4, "Beach"),
	-- Rare (Swamp)
	b("Tralalero Tralala", "Rare", 6, "Swamp"),
	b("Brr Brr Patapim", "Rare", 6.6, "Swamp"),
	b("Bobrito Bandito", "Rare", 7.1, "Swamp"),
	b("Cappuccino Assassino", "Rare", 7.7, "Swamp"),
	b("Ballerina Cappuccina", "Rare", 8.2, "Swamp"),
	b("Ballerino Lololo", "Rare", 8.8, "Swamp"),
	b("Banana Dancana", "Rare", 9.4, "Swamp"),
	b("Bananini Kittini", "Rare", 9.9, "Swamp"),
	b("Brri Brri Bicus Dicus", "Rare", 10, "Swamp"),
	b("Burbaloni Luliloli", "Rare", 11, "Swamp"),
	b("Cachorrito Melonito", "Rare", 12, "Swamp"),
	b("Gangster Footera", "Rare", 12, "Swamp"),
	b("Madudung", "Rare", 13, "Swamp"),
	b("Meowl", "Rare", 13, "Swamp"),
	b("Noo My Examen", "Rare", 14, "Swamp"),
	b("Yess My Examen", "Rare", 14, "Swamp"),
	b("Pot Hotspot", "Rare", 15, "Swamp"),
	-- Epic (Volcano)
	b("Frigo Camelo", "Epic", 25, "Volcano"),
	b("Chimpanzini Bananini", "Epic", 27, "Volcano"),
	b("Blueberrinni Octopusini", "Epic", 30, "Volcano"),
	b("Bombardiro Crocodilo", "Epic", 32, "Volcano"),
	b("Bombombini Gusini", "Epic", 34, "Volcano"),
	b("Tung Sahur", "Epic", 37, "Volcano"),
	b("Ta Ta Ta Ta Sahur", "Epic", 39, "Volcano"),
	b("Job Job Job Sahur", "Epic", 41, "Volcano"),
	b("Glorbo Fruttodrillo", "Epic", 44, "Volcano"),
	b("Rhino Toasterino", "Epic", 46, "Volcano"),
	b("Orangutini Ananassini", "Epic", 48, "Volcano"),
	b("Pandaccini Bananini", "Epic", 51, "Volcano"),
	b("Quesadilla Crocodila", "Epic", 53, "Volcano"),
	b("Zibra Zubra Zibralini", "Epic", 55, "Volcano"),
	b("Lionel Cactuseli", "Epic", 58, "Volcano"),
	b("Espresso Signora", "Epic", 60, "Volcano"),
	-- Legendary (Ice)
	b("Chef Crabracadabra", "Legendary", 120, "Ice"),
	b("Girafa Celeste", "Legendary", 135, "Ice"),
	b("Gorillo Watermelondrillo", "Legendary", 151, "Ice"),
	b("Odin Din Din Dun", "Legendary", 166, "Ice"),
	b("Cocofanto Elefanto", "Legendary", 182, "Ice"),
	b("Trulimero Trulicina", "Legendary", 197, "Ice"),
	b("Tigroligre Frutonni", "Legendary", 212, "Ice"),
	b("Strawberrelli Flamingelli", "Legendary", 228, "Ice"),
	b("Orcalero Orcala", "Legendary", 243, "Ice"),
	b("Cavallo Virtuoso", "Legendary", 258, "Ice"),
	b("Nyannini Cattalini", "Legendary", 274, "Ice"),
	b("Tric Trac Barabum", "Legendary", 289, "Ice"),
	b("Trippi Troppi Troppa Trippa", "Legendary", 305, "Ice"),
	b("Karkerkar Kurkur", "Legendary", 320, "Ice"),
	-- Mythic (Void)
	b("Matteo", "Mythic", 700, "Void"),
	b("Dragon Cannelloni", "Mythic", 800, "Void"),
	b("Torrtuginni Dragonfrutini", "Mythic", 900, "Void"),
	b("Garamararam", "Mythic", 1000, "Void"),
	b("Pakrahmatmamat", "Mythic", 1100, "Void"),
	b("Pakrahmatmatina", "Mythic", 1200, "Void"),
	b("Tirilikalika Tirilikalako", "Mythic", 1300, "Void"),
	b("Ganganzelli Trulala", "Mythic", 1400, "Void"),
	b("Chicleteira Bicicleteira", "Mythic", 1500, "Void"),
	b("Chicleteirina Bicicleteirina", "Mythic", 1600, "Void"),
	b("Lerulerulerule", "Mythic", 1700, "Void"),
	b("W Or L", "Mythic", 1800, "Void"),
	-- Secret (Void)
	b("Tralaledon", "Secret", 4000, "Void"),
	b("Esok Sekolah", "Secret", 5222, "Void"),
	b("La Grande Combinasion", "Secret", 6444, "Void"),
	b("Los Tralaleritos", "Secret", 7667, "Void"),
	b("Illuminato Triangolo", "Secret", 8889, "Void"),
	b("Triplito Tralaleritos", "Secret", 10111, "Void"),
	b("1x1x1x1", "Secret", 11333, "Void"),
	b("Strawberry Elephant", "Secret", 12556, "Void"),
	b("Six Seven", "Secret", 13778, "Void"),
	b("La Vacca Saturno Saturnita", "Secret", 15000, "Void"),
}

local ById: { [string]: Brainrot } = {}
local ByRarity: { [string]: { Brainrot } } = {}
for _, br in ipairs(List) do
	ById[br.Id] = br
	ByRarity[br.Rarity] = ByRarity[br.Rarity] or {}
	table.insert(ByRarity[br.Rarity], br)
end

return { List = List, ById = ById, ByRarity = ByRarity, Rarities = Rarities, RarityById = RarityById }
