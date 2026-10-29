--!strict
-- Shared/Util/Slice9 : 9-slice des cadres/boutons du kit UI.
-- Les bords noirs gardent la même épaisseur quelle que soit la forme de la case
-- (avant : image étirée = côtés noirs énormes sur les boutons larges).
-- Données : ancien id -> { nouvel id (copie 700px du groupe), largeur, hauteur, bords mesurés L,R,T,B }
local M = {}

M.Thin = 0.85 -- < 1 = contours un peu plus fins que l'image d'origine

local RAW: { [string]: { number } } = {
	["72484859487238"] = { 112571562887469, 700, 240, 17, 17, 17, 17 },
	["71327065275858"] = { 85340622947101, 700, 693, 37, 37, 37, 38 },
	["110981870724664"] = { 119750519928800, 700, 240, 17, 17, 17, 17 },
	["118459934312421"] = { 72710988625605, 700, 85, -1, -1, -1, -1 },
	["130202638558172"] = { 137082657641266, 700, 240, 17, 17, 17, 17 },
	["75109179445868"] = { 87181326471198, 700, 255, 5, 5, 5, 5 },
	["112249404449276"] = { 73427215587438, 700, 125, 5, 5, 5, 5 },
	["73242668214006"] = { 103479904112214, 700, 193, 5, 5, 5, 12 },
	["123473196299883"] = { 119804393051815, 700, 131, 5, 5, 5, 9 },
	["103832055405761"] = { 78986516097002, 700, 310, 23, 23, 23, 24 },
	["125192170525130"] = { 115485572161662, 700, 634, 5, 5, 5, 5 },
	["118785649440965"] = { 121690500437454, 700, 175, 9, 9, 9, 10 },
	["115755374758946"] = { 96325714255333, 665, 700, 5, 5, 5, 5 },
	["96609316302461"] = { 91310410703579, 700, 59, -1, -1, -1, -1 },
	["139238474736040"] = { 80819985567298, 700, 201, 14, 14, 14, 14 },
	["72255201982128"] = { 117614625323543, 700, 131, 5, 5, 5, 6 },
	["105496683105089"] = { 135696051917539, 700, 201, 14, 14, 13, 14 },
	["107626190343734"] = { 91089999841433, 700, 281, 13, 13, 13, 22 },
	["76850939570356"] = { 134345852693137, 700, 125, 5, 5, 5, 5 },
	["73937030672143"] = { 110322925886892, 700, 125, 5, 5, 5, 5 },
	["128952100773355"] = { 137777488887214, 700, 125, 5, 5, 5, 5 },
	["129392840226910"] = { 136155528609414, 700, 125, 5, 5, 5, 5 },
	["73646313229415"] = { 70651155072304, 688, 700, 30, 31, 30, 31 },
	["130381227243780"] = { 98660535825383, 686, 700, 20, 20, 20, 20 },
	["88161804514908"] = { 129180919380960, 700, 493, 5, 5, 5, 5 },
	["131912983081579"] = { 107568119446511, 700, 700, 42, 42, 49, 42 },
	["118147684330981"] = { 103738908144358, 700, 225, 14, 14, 13, 14 },
	["77317040960880"] = { 132440756495330, 641, 700, 34, 34, 34, 34 },
	["127062449162498"] = { 133663219103962, 688, 700, 30, 31, 31, 31 },
	["90197520262450"] = { 76240575759791, 700, 131, 5, 5, 5, 6 },
	["95125443680380"] = { 77041343297350, 700, 215, 12, 12, 12, 14 },
	["91846497745427"] = { 111937954498085, 700, 193, 5, 5, 5, 12 },
	["107377020050831"] = { 98544103038585, 700, 198, 7, 7, 7, 8 },
	["130643378669225"] = { 100695838489358, 700, 193, 5, 5, 5, 12 },
	["72950720650768"] = { 112969477861450, 700, 240, 12, 12, 12, 13 },
	["109714672458221"] = { 96357933206546, 700, 310, 23, 23, 23, 24 },
	["94257717489472"] = { 126998268703505, 700, 131, 5, 5, 5, 6 },
	["110428657945327"] = { 78805066970283, 700, 193, 5, 5, 5, 6 },
	["103553873357333"] = { 97830305955669, 700, 269, 13, 13, 13, 13 },
}

export type Spec = { Id: string, W: number, H: number, L: number, R: number, T: number, B: number }

local byId: { [string]: Spec } = {}
local oldToNew: { [string]: string } = {}

for old, r in pairs(RAW) do
	local w, h = r[2], r[3]
	local m = math.min(w, h)
	local function corner(b: number, size: number): number
		local c
		if b < 0 then
			c = math.floor(0.4 * h + 0.5) -- barre unie : bouts arrondis
		else
			c = math.max(math.floor(2.2 * b + 0.5), math.floor(0.12 * m + 0.5))
		end
		return math.min(c, math.floor(size / 2) - 2)
	end
	local spec: Spec = {
		Id = tostring(r[1]), W = w, H = h,
		L = corner(r[4], w), R = corner(r[5], w), T = corner(r[6], h), B = corner(r[7], h),
	}
	byId[spec.Id] = spec
	oldToNew[old] = spec.Id
end

function M.IdOf(image: string): string?
	return image:match("(%d+)")
end

-- Renvoie la spec d'une image (ancien ou nouvel id) + le nouvel id
function M.Lookup(image: string): (Spec?, string?)
	local id = M.IdOf(image)
	if not id then return nil, nil end
	local new = oldToNew[id] or id
	return byId[new], new
end

function M.NewId(old: string): string?
	return oldToNew[old]
end

-- Échelle des bords selon la taille réelle de l'élément
function M.ScaleFor(spec: Spec, size: Vector2): number
	if size.X < 1 or size.Y < 1 then return 0.2 end
	local s = M.Thin * math.min(size.X, size.Y) / math.min(spec.W, spec.H)
	s = math.min(s, 0.98 * size.X / (spec.L + spec.R), 0.98 * size.Y / (spec.T + spec.B))
	return math.max(s, 0.01)
end

-- Applique le 9-slice à un ImageLabel/ImageButton. Renvoie true si l'image est du kit.
function M.Apply(g: ImageLabel | ImageButton): boolean
	if g.ImageRectSize ~= Vector2.zero then return false end
	if g.ScaleType ~= Enum.ScaleType.Stretch and g.ScaleType ~= Enum.ScaleType.Slice then return false end
	if g:GetAttribute("NoSlice") then return false end
	local spec, new = M.Lookup(g.Image)
	if not spec or not new then return false end
	local target = "rbxassetid://" .. new
	if g.Image ~= target then g.Image = target end
	if g.ScaleType ~= Enum.ScaleType.Slice then g.ScaleType = Enum.ScaleType.Slice end
	local rect = Rect.new(spec.L, spec.T, spec.W - spec.R, spec.H - spec.B)
	if g.SliceCenter ~= rect then g.SliceCenter = rect end
	local s = M.ScaleFor(spec, g.AbsoluteSize)
	if math.abs(g.SliceScale - s) > 0.002 then g.SliceScale = s end
	return true
end

function M.IsKit(image: string): boolean
	return (M.Lookup(image)) ~= nil
end

return M
