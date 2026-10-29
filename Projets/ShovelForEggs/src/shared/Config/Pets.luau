--!strict
-- Shared/Config/Pets
-- Les brainrots du jeu (les mêmes que Rake for Brainrots) : ce sont les "pets" qui éclosent des œufs.
-- Modèles : pack Brainrots_Animated du vault, dans ReplicatedStorage/Assets/Pets/<Variante>/<Nom>
-- (variantes = mutations : Normal, Oro, Diamante, Lava, Galaxia, Arcoiris, Hacker). Income = $ par seconde (base).
-- Rarities : Common, Rare, Epic, Legendary, Mythic, Secret. Zone = zone de la montagne où l'œuf les donne le plus.

export type Pet = { Id: string, Name: string, Rarity: string, Income: number, Zone: string }

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
local function b(name: string, rarity: string, income: number, zone: string): Pet
	return { Id = name, Name = name, Rarity = rarity, Income = income, Zone = zone }
end

local List: { Pet } = {
	-- Common (Village)
	b("Pipi Kiwi", "Common", 1, "Village"),
	b("Pipi Potato", "Common", 1.2, "Village"),
	b("Fluri Flura", "Common", 1.4, "Village"),
	b("Talpa Di Fero", "Common", 1.5, "Village"),
	b("Svinina Bombardino", "Common", 1.7, "Village"),
	b("Tim Cheese", "Common", 1.9, "Village"),
	b("Boneca Ambalabu", "Common", 2.1, "Village"),
	b("Cacto Hipopotamo", "Common", 2.2, "Village"),
	b("Trippi Troppi", "Common", 2.4, "Village"),
	b("Avocadini Guffo", "Common", 2.6, "Village"),
	b("Bananita Dolphinita", "Common", 2.8, "Village"),
	b("Lirili Larila", "Common", 2.9, "Village"),
	b("Tralalita Tralala", "Common", 3.1, "Village"),
	b("Agarrini La Pallini", "Common", 3.3, "Village"),
	b("Bambini Crostini", "Common", 3.5, "Village"),
	b("Swag Soda", "Common", 3.6, "Village"),
	b("Smurfo Gatto", "Common", 3.8, "Village"),
	b("Chillin Chili", "Common", 4, "Village"),
	-- Rare (Forest)
	b("Tralalero Tralala", "Rare", 6, "Forest"),
	b("Brr Brr Patapim", "Rare", 6.6, "Forest"),
	b("Bobrito Bandito", "Rare", 7.1, "Forest"),
	b("Cappuccino Assassino", "Rare", 7.7, "Forest"),
	b("Ballerina Cappuccina", "Rare", 8.2, "Forest"),
	b("Ballerino Lololo", "Rare", 8.8, "Forest"),
	b("Banana Dancana", "Rare", 9.4, "Forest"),
	b("Bananini Kittini", "Rare", 9.9, "Forest"),
	b("Brri Brri Bicus Dicus", "Rare", 10, "Forest"),
	b("Burbaloni Luliloli", "Rare", 11, "Forest"),
	b("Cachorrito Melonito", "Rare", 12, "Forest"),
	b("Gangster Footera", "Rare", 12, "Forest"),
	b("Madudung", "Rare", 13, "Forest"),
	b("Meowl", "Rare", 13, "Forest"),
	b("Noo My Examen", "Rare", 14, "Forest"),
	b("Yess My Examen", "Rare", 14, "Forest"),
	b("Pot Hotspot", "Rare", 15, "Forest"),
	-- Epic (FrozenLake)
	b("Frigo Camelo", "Epic", 25, "FrozenLake"),
	b("Chimpanzini Bananini", "Epic", 27, "FrozenLake"),
	b("Blueberrinni Octopusini", "Epic", 30, "FrozenLake"),
	b("Bombardiro Crocodilo", "Epic", 32, "FrozenLake"),
	b("Bombombini Gusini", "Epic", 34, "FrozenLake"),
	b("Tung Sahur", "Epic", 37, "FrozenLake"),
	b("Ta Ta Ta Ta Sahur", "Epic", 39, "FrozenLake"),
	b("Job Job Job Sahur", "Epic", 41, "FrozenLake"),
	b("Glorbo Fruttodrillo", "Epic", 44, "FrozenLake"),
	b("Rhino Toasterino", "Epic", 46, "FrozenLake"),
	b("Orangutini Ananassini", "Epic", 48, "FrozenLake"),
	b("Pandaccini Bananini", "Epic", 51, "FrozenLake"),
	b("Quesadilla Crocodila", "Epic", 53, "FrozenLake"),
	b("Zibra Zubra Zibralini", "Epic", 55, "FrozenLake"),
	b("Lionel Cactuseli", "Epic", 58, "FrozenLake"),
	b("Espresso Signora", "Epic", 60, "FrozenLake"),
	-- Legendary (IceCave)
	b("Chef Crabracadabra", "Legendary", 120, "IceCave"),
	b("Girafa Celeste", "Legendary", 135, "IceCave"),
	b("Gorillo Watermelondrillo", "Legendary", 151, "IceCave"),
	b("Odin Din Din Dun", "Legendary", 166, "IceCave"),
	b("Cocofanto Elefanto", "Legendary", 182, "IceCave"),
	b("Trulimero Trulicina", "Legendary", 197, "IceCave"),
	b("Tigroligre Frutonni", "Legendary", 212, "IceCave"),
	b("Strawberrelli Flamingelli", "Legendary", 228, "IceCave"),
	b("Orcalero Orcala", "Legendary", 243, "IceCave"),
	b("Cavallo Virtuoso", "Legendary", 258, "IceCave"),
	b("Nyannini Cattalini", "Legendary", 274, "IceCave"),
	b("Tric Trac Barabum", "Legendary", 289, "IceCave"),
	b("Trippi Troppi Troppa Trippa", "Legendary", 305, "IceCave"),
	b("Karkerkar Kurkur", "Legendary", 320, "IceCave"),
	-- Mythic (Glacier)
	b("Matteo", "Mythic", 700, "Glacier"),
	b("Dragon Cannelloni", "Mythic", 800, "Glacier"),
	b("Torrtuginni Dragonfrutini", "Mythic", 900, "Glacier"),
	b("Garamararam", "Mythic", 1000, "Glacier"),
	b("Pakrahmatmamat", "Mythic", 1100, "Glacier"),
	b("Pakrahmatmatina", "Mythic", 1200, "Glacier"),
	b("Tirilikalika Tirilikalako", "Mythic", 1300, "Glacier"),
	b("Ganganzelli Trulala", "Mythic", 1400, "Glacier"),
	b("Chicleteira Bicicleteira", "Mythic", 1500, "Glacier"),
	b("Chicleteirina Bicicleteirina", "Mythic", 1600, "Glacier"),
	b("Lerulerulerule", "Mythic", 1700, "Glacier"),
	b("W Or L", "Mythic", 1800, "Glacier"),
	-- Secret (Aurora)
	b("Tralaledon", "Secret", 4000, "Aurora"),
	b("Esok Sekolah", "Secret", 5222, "Aurora"),
	b("La Grande Combinasion", "Secret", 6444, "Aurora"),
	b("Los Tralaleritos", "Secret", 7667, "Aurora"),
	b("Illuminato Triangolo", "Secret", 8889, "Aurora"),
	b("Triplito Tralaleritos", "Secret", 10111, "Aurora"),
	b("1x1x1x1", "Secret", 11333, "Aurora"),
	b("Strawberry Elephant", "Secret", 12556, "Aurora"),
	b("Six Seven", "Secret", 13778, "Aurora"),
	b("La Vacca Saturno Saturnita", "Secret", 15000, "Aurora"),
}

local ById: { [string]: Pet } = {}
local ByRarity: { [string]: { Pet } } = {}
for _, p in ipairs(List) do
	ById[p.Id] = p
	ByRarity[p.Rarity] = ByRarity[p.Rarity] or {}
	table.insert(ByRarity[p.Rarity], p)
end

return { List = List, ById = ById, ByRarity = ByRarity, Rarities = Rarities, RarityById = RarityById }
