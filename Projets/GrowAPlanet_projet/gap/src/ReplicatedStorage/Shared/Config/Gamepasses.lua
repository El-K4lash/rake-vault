--!strict
-- ReplicatedStorage/Shared/Config/Gamepasses
-- Id = 0 tant que le pass n'est pas créé sur le site Roblox (Creator Hub).

return {
	DoubleMoney = { Id = 0, Name = "x2 Money",       Price = 399 },
	DoubleLuck  = { Id = 0, Name = "x2 Luck",        Price = 299 },
	FastHatch   = { Id = 0, Name = "Fast Hatch",     Price = 249, Value = 0.5 }, -- timers x0.5 (cumulable avec l'upgrade)
	ExtraSlots  = { Id = 0, Name = "+2 Equip Slots", Price = 199, Value = 2 },
	FourthSpawner = { Id = 0, Name = "4th Spawner",  Price = 349 },
	AutoHatch   = { Id = 0, Name = "Auto Hatch",     Price = 149 },
	VIP         = { Id = 0, Name = "VIP",            Price = 499, MoneyBonus = 0.25 }, -- +25 % argent, tag VIP
}
