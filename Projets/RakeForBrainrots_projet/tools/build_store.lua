-- build_store.lua : construit GUI.Frames.Store (boutique Robux) à partir du RobuxShop de Steal an Egg (ServerStorage.SAE_RobuxShop).
-- À lancer une fois dans Studio (Edit). Résultat = vraies instances dans StarterGui.
local Store = require(game.ReplicatedStorage.Shared.Config.Store)
local Eggs = require(game.ReplicatedStorage.Shared.Config.Eggs)
local gui = game.StarterGui.GUI
local old = gui.Frames:FindFirstChild("Store"); if old then old:Destroy() end
local src = game.ServerStorage.SAE_RobuxShop.Frame:Clone()
src.Name = "Store"; src.Visible = false; src.ZIndex = 2
src.AnchorPoint = Vector2.new(0.5, 0.5); src.Position = UDim2.fromScale(0.5, 0.5)
src.Size = UDim2.fromScale(0.72, 0.72)
for _, d in ipairs(src:GetDescendants()) do if d:IsA("LuaSourceContainer") then d:Destroy() end end
-- dégradé animé de l'offre limitée : fait côté contrôleur (StoreController)
src.Header.Title.Text = "Shop"
local sf = src.ScrollingFrame

local function priceText(p) return "R$" .. tostring(p.Price) end
local function setBuy(card, p, buyName)
	local btns = card:FindFirstChild("Btns", true)
	local buy = btns:FindFirstChild(buyName or "Buy")
	buy:SetAttribute("StoreKey", p.Key)
	local pr = buy:FindFirstChild("Price"); if pr then pr.Text = priceText(p) end
	-- pas de cadeau dans notre jeu : on retire le bouton Gift et le Buy prend toute la largeur
	for _, g in ipairs(btns:GetChildren()) do if g.Name:sub(1, 4) == "Gift" then g:Destroy() end end
	if not buyName then buy.Size = UDim2.fromScale(0.95, buy.Size.Y.Scale) end
end
local function fmt(n)
	if n >= 1e6 then return string.format("$%gM", n / 1e6) elseif n >= 1e3 then return string.format("$%gK", n / 1e3) end
	return "$" .. n
end

-- OFFRE LIMITÉE (œufs Void)
local lim = sf.LimitedEgg.Spacer
lim.EggName.Text = "VOID EGG"
lim.Label.Text = "Limited Time!"
local counts = {}
for i, p in ipairs(Store.Limited) do
	local b = lim.Btns:FindFirstChild("Buy" .. i)
	b:SetAttribute("StoreKey", p.Key)
	local pr = b:FindFirstChild("Price", true)
	if pr then pr.Text = priceText(p) end
	local t = b:FindFirstChild("Amount", true)
	if t then t.Text = p.Count .. (p.Count > 1 and " Eggs" or " Egg") end
	local op = b:FindFirstChild("OldPrice", true)
	if op then op.Text = tostring(math.floor(p.Price * 2.5)) end
	counts[i] = t and t.Text or "?"
end
-- les 7 vignettes de l'offre : nos brainrots Legendary / Mythic / Secret avec leur vraie chance dans l'œuf Void
do
	local B = require(game.ReplicatedStorage.Shared.Config.Brainrots)
	local w = Eggs.ById.VoidEgg.Rarities
	local function top(r, n)
		local l = table.clone(B.ByRarity[r]); table.sort(l, function(a, b) return a.Income < b.Income end)
		local res = {}
		for i = #l - n + 1, #l do table.insert(res, l[i]) end
		return res, #l
	end
	local picks = {}
	local L, nL = top("Legendary", 2); local M, nM = top("Mythic", 2); local S, nS = top("Secret", 3)
	for _, b in ipairs(L) do table.insert(picks, { b, w.Legendary / nL }) end
	for _, b in ipairs(M) do table.insert(picks, { b, w.Mythic / nM }) end
	for _, b in ipairs(S) do table.insert(picks, { b, (w.Secret or 0) / nS }) end
	for i = 1, 7 do
		local f = lim.Frame:FindFirstChild(tostring(i))
		local b, pct = picks[i][1], picks[i][2]
		for _, n in ipairs({ "Icon", "Icon2" }) do local ic = f:FindFirstChild(n); if ic then ic.Visible = false end end
		local vp = Instance.new("ViewportFrame"); vp.Name = "View"; vp.BackgroundTransparency = 1
		vp.Size = UDim2.fromScale(0.9, 0.9); vp.Position = UDim2.fromScale(0.05, 0.02); vp.ZIndex = f.Icon.ZIndex + 1
		vp:SetAttribute("Brainrot", b.Id); vp.Parent = f
		f.Amount.Text = pct >= 1 and string.format("%d%%", math.floor(pct + 0.5)) or string.format("%.1f%%", pct)
		f.Amount.ZIndex = vp.ZIndex + 1
		local lab = f:FindFirstChild("Label"); if lab then lab.Text = string.upper(b.Rarity); lab.ZIndex = vp.ZIndex + 1 end
	end
	local bg = lim.bg
	for _, n in ipairs({ "Icon", "MechanicalVersion" }) do local ic = bg:FindFirstChild(n); if ic then ic.Visible = false end end
	local vp = Instance.new("ViewportFrame"); vp.Name = "EggView"; vp.BackgroundTransparency = 1
	vp.Position = bg.Icon.Position; vp.Size = bg.Icon.Size; vp.AnchorPoint = bg.Icon.AnchorPoint; vp.ZIndex = bg.Icon.ZIndex + 1
	vp:SetAttribute("Egg", "Void"); vp.Parent = bg
end
for _, g in ipairs(lim.Btns:GetChildren()) do if g.Name:sub(1, 4) == "Gift" then g:Destroy() end end
lim.Btns.Size = UDim2.fromScale(lim.Btns.Size.X.Scale * 0.85, lim.Btns.Size.Y.Scale)

-- PASSES (2 → 4 cartes, 2 lignes)
local passes = sf.Passes
passes.Size = UDim2.new(1, 0, passes.Size.Y.Scale * 2, 0)
passes.SectionTitle.Position = UDim2.fromScale(passes.SectionTitle.Position.X.Scale, 0.0095)
passes.SectionTitle.Size = UDim2.fromScale(passes.SectionTitle.Size.X.Scale, 0.084)
local g, m = passes.Growth, passes.Money
for _, c in ipairs({ g, m }) do c.Size = UDim2.fromScale(c.Size.X.Scale, c.Size.Y.Scale / 2) end
g.Position = UDim2.fromScale(g.Position.X.Scale, 0.33); m.Position = UDim2.fromScale(m.Position.X.Scale, 0.33)
local luck = g:Clone(); luck.Name = "Luck"; luck.Position = UDim2.fromScale(g.Position.X.Scale, 0.72); luck.Parent = passes
local vip = m:Clone(); vip.Name = "VIP"; vip.Position = UDim2.fromScale(m.Position.X.Scale, 0.72); vip.Parent = passes
g.Name = "Hatch"
local cards = { Money = m, Hatch = g, Luck = luck, VIP = vip }
local icons = { Luck = "rbxassetid://81193001619814", VIP = "rbxassetid://81195562015915" }
for _, p in ipairs(Store.Passes) do
	local c = cards[p.Key]
	c.Title.Text = p.Name
	c.Desc.Text = p.Desc
	if icons[p.Key] then c.Icon.Image = icons[p.Key] end
	setBuy(c, p)
end

-- ŒUFS (ancienne section SPEED)
local eggs = sf.Speed
eggs.Name = "Eggs"
eggs.SectionTitle.Text = "EGGS"
for i, p in ipairs(Store.Eggs) do
	local c = eggs:FindFirstChild("c" .. i)
	local def = Eggs.ById[p.Egg]
	c.Title.Text = string.format('<font color="#00FF00">x%d</font> <font color="#FFFFFF">%s</font>', p.Count, string.upper(def.Zone))
	-- icône remplacée par une vue 3D de l'œuf (remplie par StoreController)
	local vp = Instance.new("ViewportFrame")
	vp.Name = "EggView"; vp.BackgroundTransparency = 1; vp.AnchorPoint = c.Icon.AnchorPoint
	vp.Position = c.Icon.Position; vp.Size = c.Icon.Size; vp.ZIndex = c.Icon.ZIndex
	vp:SetAttribute("Egg", def.Model)
	vp.Parent = c
	c.Icon.Visible = false
	setBuy(c, p)
end

-- ARGENT
local cash = sf.Money
cash.Name = "Cash"
cash.SectionTitle.Text = "MONEY"
for i, p in ipairs(Store.Cash) do
	local c = cash:FindFirstChild("c" .. i)
	c.Title.Text = fmt(p.Amount)
	setBuy(c, p)
end

src.Parent = gui.Frames

-- ===== habillage façon K4 (comme les autres fenêtres) : en-tête, icône, titre, croix, fond =====
-- (relancer cette partie seule si besoin : elle prend le style de la fenêtre Codes)
do
	local st = gui.Frames.Store
	local codes = gui.Frames.Codes
	local r = 1.98
	local hh = math.min(0.2, r / 5.64)
	local hw = math.min(1, hh * 5.64 / r)
	local bgTop = hh * 0.45
	for _, n in ipairs({ "Header", "Close", "Background", "Backing" }) do local o = st:FindFirstChild(n); if o then o:Destroy() end end
	for _, s in ipairs(st:GetChildren()) do if s:IsA("UIStroke") then s:Destroy() end end
	st.Image = ""; st.ImageTransparency = 1; st.BackgroundTransparency = 1
	local ar = st:FindFirstChildOfClass("UIAspectRatioConstraint"); if ar then ar.AspectRatio = r; ar.AspectType = Enum.AspectType.FitWithinMaxSize end
	local bk = codes.Backing:Clone(); bk.Position = UDim2.new(0, 4, bgTop, 4); bk.Size = UDim2.new(1, -8, 1 - bgTop, -8); bk.Parent = st
	local bg = codes.Background:Clone(); bg.Position = UDim2.fromScale(0, bgTop); bg.Size = UDim2.fromScale(1, 1 - bgTop); bg.Image = "rbxassetid://75109179445868"; bg.Parent = st
	local head = codes.Header:Clone(); head.Position = UDim2.fromScale(0, 0); head.Size = UDim2.fromScale(1, hh) -- toute la largeur, comme les autres
	head.Image = "rbxassetid://129392840226910" -- en-tête vert (K4)
	head.Icon.Image = gui.HUD.Left.Store.Icon.Image -- même icône que le bouton Shop du HUD
	head.Title.Text = "SHOP"
	head.Parent = st
	local cl = codes.Close:Clone(); cl.Position = UDim2.fromScale(0.985, hh * 0.06); cl.Size = UDim2.fromScale(hh * 0.88 * 0.916 / r, hh * 0.88); cl.Parent = st
	local sf = st.ScrollingFrame
	sf.AnchorPoint = Vector2.new(0.5, 0); sf.Position = UDim2.fromScale(0.5, hh * 0.82 + 0.03); sf.Size = UDim2.fromScale(0.955, 1 - hh * 0.82 - 0.06)
	sf.ZIndex = 2
end

-- ===== boutons d'achat au style K4 (bouton vert du kit) + icône Robux à la place de "R$" =====
do
	local st = gui.Frames.Store
	local GREEN, ORANGE = "rbxassetid://72484859487238", "rbxassetid://130202638558172"
	local ROBUX = "rbxassetid://104564734060803"
	for _, b in ipairs(st:GetDescendants()) do
		if b:IsA("ImageButton") and b:GetAttribute("StoreKey") then
			for _, c in ipairs(b:GetChildren()) do
				if c:IsA("UIGradient") or (c:IsA("UIStroke")) or c.Name == "Pattern" or (c:IsA("Frame") and c.Name == "Frame") then c:Destroy() end
			end
			b.BackgroundTransparency = 1
			b.Image = (b.Name == "Buy4") and ORANGE or GREEN
			b.ScaleType = Enum.ScaleType.Stretch
			local price = b:FindFirstChild("Price") :: TextLabel
			if price then
				-- ligne centrée : [icône Robux][prix]
				local row = Instance.new("Frame"); row.Name = "PriceRow"; row.BackgroundTransparency = 1
				row.AnchorPoint = Vector2.new(0.5, 0.5); row.Position = UDim2.fromScale(0.5, 0.5); row.Size = UDim2.fromScale(0.9, 0.7)
				row.ZIndex = price.ZIndex; row.Parent = b
				local l = Instance.new("UIListLayout"); l.FillDirection = Enum.FillDirection.Horizontal; l.HorizontalAlignment = Enum.HorizontalAlignment.Center
				l.VerticalAlignment = Enum.VerticalAlignment.Center; l.Padding = UDim.new(0.02, 0); l.SortOrder = Enum.SortOrder.LayoutOrder; l.Parent = row
				local ic = Instance.new("ImageLabel"); ic.Name = "RobuxIcon"; ic.BackgroundTransparency = 1; ic.Image = ROBUX; ic.LayoutOrder = 1
				ic.SizeConstraint = Enum.SizeConstraint.RelativeYY; ic.Size = UDim2.fromScale(0.95, 0.95); ic.ZIndex = price.ZIndex; ic.Parent = row
				price.Text = (price.Text:gsub("R%$", ""))
				price.Parent = row; price.LayoutOrder = 2; price.AnchorPoint = Vector2.new(0, 0); price.Position = UDim2.new()
				price.SizeConstraint = Enum.SizeConstraint.RelativeYY
				price.Size = UDim2.fromScale(0.62 * math.max(#price.Text, 2), 1)
				price.TextXAlignment = Enum.TextXAlignment.Left
			end
			local op = b:FindFirstChild("OldPrice") :: TextLabel?
			if op then op.Text = (op.Text:gsub("R%$", "")) end
		end
	end
end

-- ===== cartes sombres comme les cartes Index / Base (au lieu du blanc de Steal an Egg) =====
do
	local sf = gui.Frames.Store.ScrollingFrame
	for _, sec in ipairs({ "Passes", "Eggs", "Cash" }) do
		for _, card in ipairs(sf[sec]:GetChildren()) do
			if card:IsA("ImageLabel") or card:IsA("ImageButton") then
				card.Image = ""; card.ImageTransparency = 0
				card.BackgroundTransparency = 0; card.BackgroundColor3 = Color3.fromRGB(58, 62, 82)
				local g = card:FindFirstChild("Glow"); if g then g:Destroy() end
				-- les UIStroke d'origine (avec dégradé) empêchent l'affichage de toutes les cartes sauf une : on les remplace
				for _, c in ipairs(card:GetChildren()) do
					if c:IsA("UIGradient") or c:IsA("UIStroke") then c:Destroy() end
				end
				local st = Instance.new("UIStroke"); st.Color = Color3.fromRGB(20, 22, 32); st.Thickness = 2.5
				st.ApplyStrokeMode = Enum.ApplyStrokeMode.Border; st.Parent = card
				local cn = card:FindFirstChildOfClass("UICorner") or Instance.new("UICorner"); cn.CornerRadius = UDim.new(0, 10); cn.Parent = card
			end
		end
	end
	for _, b in ipairs(gui.Frames.Store:GetDescendants()) do
		if b.Name == "PriceRow" then b.Size = UDim2.fromScale(0.9, 0.85) end
	end
end

return "Store ok " .. #gui.Frames.Store:GetDescendants()
