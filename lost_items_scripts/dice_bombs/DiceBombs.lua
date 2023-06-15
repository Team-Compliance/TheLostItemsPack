local DiceBombsLocal = {}
DiceBombs = {}
local mod = LostItemsPack
local Helpers = require("lost_items_scripts.Helpers")

local DiceBombItemBlacklist = {
    [CollectibleType.COLLECTIBLE_POLAROID] = true,
    [CollectibleType.COLLECTIBLE_NEGATIVE] = true,
    [CollectibleType.COLLECTIBLE_DADS_NOTE] = true,
    [CollectibleType.COLLECTIBLE_NULL] = true
}

local DiceBombPickupBlacklist = {
    [PickupVariant.PICKUP_BED] = true,
    [PickupVariant.PICKUP_BIGCHEST] = true,
    [PickupVariant.PICKUP_MOMSCHEST] = true,
    [PickupVariant.PICKUP_SHOPITEM] = true,
    [PickupVariant.PICKUP_THROWABLEBOMB] = true,
    [PickupVariant.PICKUP_TROPHY] = true,
    [PickupVariant.PICKUP_COLLECTIBLE] = true
}

---@param bomb EntityBomb
function DiceBombsLocal:D1BombExplode(bomb, player, radius)
    local pickup
    for i, entity in ipairs(Isaac.FindInRadius(bomb.Position, radius)) do
        if entity.Type == EntityType.ENTITY_PICKUP and not DiceBombPickupBlacklist[entity.Variant] then
        pickup = entity
        end
    end
    if pickup then
        if pickup.Variant ~= PickupVariant.PICKUP_BOMB then
            Isaac.Spawn(EntityType.ENTITY_PICKUP, pickup.Variant, 0, bomb.Position, Vector.Zero, nil)
        else 
            Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_BOMB, BombSubType.BOMB_NORMAL, bomb.Position, Vector.Zero, nil)
        end
    end
    return true
end
mod:AddCallback(LostItemsPack.Callbacks.ON_DICE_BOMB_EXPLOSION, DiceBombsLocal.D1BombExplode, CollectibleType.COLLECTIBLE_D1)

---@param bomb EntityBomb
function DiceBombsLocal:D4BombExplode(bomb, player, radius)
    for i, entity in ipairs(Isaac.FindInRadius(bomb.Position, radius)) do
        if entity.Type == EntityType.ENTITY_PLAYER and entity.Variant == 0 then
            entity:ToPlayer():UseActiveItem(CollectibleType.COLLECTIBLE_D4, 1)
        end
    end
    return true
end
mod:AddCallback(LostItemsPack.Callbacks.ON_DICE_BOMB_EXPLOSION, DiceBombsLocal.D4BombExplode, CollectibleType.COLLECTIBLE_D4)

---@param bomb EntityBomb
function DiceBombsLocal:D6BombExplode(bomb, player, radius)		
    for i, entity in ipairs(Isaac.FindInRadius(bomb.Position, radius)) do
        if entity.Type == EntityType.ENTITY_PICKUP and entity.Variant == PickupVariant.PICKUP_COLLECTIBLE then
            if not DiceBombItemBlacklist[entity.SubType] then
                entity:ToPickup():Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, 0, true)
                Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, entity.Position, Vector.Zero, nil)
            end
        end
    end
end
mod:AddCallback(LostItemsPack.Callbacks.ON_DICE_BOMB_EXPLOSION, DiceBombsLocal.D6BombExplode, CollectibleType.COLLECTIBLE_D6)

---@param bomb EntityBomb
function DiceBombsLocal:D8BombExplode(bomb, player, radius)
    for i, entity in ipairs(Isaac.FindInRadius(bomb.Position, radius)) do
        if entity.Type == EntityType.ENTITY_PLAYER and entity.Variant == 0 then
            entity:ToPlayer():UseActiveItem(CollectibleType.COLLECTIBLE_D8, 1)
        end
    end
    return true
end
mod:AddCallback(LostItemsPack.Callbacks.ON_DICE_BOMB_EXPLOSION, DiceBombsLocal.D8BombExplode, CollectibleType.COLLECTIBLE_D8)

---@param bomb EntityBomb
function DiceBombsLocal:D20BombExplode(bomb, player, radius)
    for i, entity in ipairs(Isaac.FindInRadius(bomb.Position, radius)) do
        if entity.Type == EntityType.ENTITY_PICKUP and not DiceBombPickupBlacklist[entity.Variant] then
            entity:ToPickup():Morph(EntityType.ENTITY_PICKUP, 0, 0)
        end
    end
    return true
end
mod:AddCallback(LostItemsPack.Callbacks.ON_DICE_BOMB_EXPLOSION, DiceBombsLocal.D20BombExplode, CollectibleType.COLLECTIBLE_D20)

---@param bomb EntityBomb
function DiceBombsLocal:SpindownBombExplode(bomb, player, radius)
    for i, entity in ipairs(Isaac.FindInRadius(bomb.Position, radius)) do
        if entity.Type == EntityType.ENTITY_PICKUP and entity.Variant == PickupVariant.PICKUP_COLLECTIBLE then
            if not DiceBombItemBlacklist[entity.SubType] then
                local itemshift = entity.SubType - 1
                while true do
                    if (ItemConfig.Config.IsValidCollectible(itemshift) and Isaac.GetItemConfig():GetCollectible(itemshift):IsAvailable()) or itemshift <= 1 then
                        entity:ToPickup():Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, itemshift, true)
                        Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, entity.Position, Vector.Zero, nil)
                        break
                    end
                    itemshift = itemshift - 1
                end
            end
        end
    end
end
mod:AddCallback(LostItemsPack.Callbacks.ON_DICE_BOMB_EXPLOSION, DiceBombsLocal.SpindownBombExplode, CollectibleType.COLLECTIBLE_SPINDOWN_DICE)

mod:AddCallback(LostItemsPack.Callbacks.ON_DICE_BOMB_EXPLOSION, function(_, bomb, player, radius)
    DiceBombsLocal:D1BombExplode(bomb, player, radius)
    DiceBombsLocal:D4BombExplode(bomb, player, radius)
    DiceBombsLocal:D6BombExplode(bomb, player, radius)
    DiceBombsLocal:D8BombExplode(bomb, player, radius)
    DiceBombsLocal:D20BombExplode(bomb, player, radius)
end, CollectibleType.COLLECTIBLE_D100)

local DiceBombSpritesheets = {
    [CollectibleType.COLLECTIBLE_D1] = "dice_d1",
    [CollectibleType.COLLECTIBLE_D4] = "dice_d4",
    [CollectibleType.COLLECTIBLE_D6] = "dice_d6",
    [CollectibleType.COLLECTIBLE_D8] = "dice_d8",
    [CollectibleType.COLLECTIBLE_D20] = "dice_d20",
    [CollectibleType.COLLECTIBLE_D100] = "dice_d100",
    [CollectibleType.COLLECTIBLE_SPINDOWN_DICE] = "dice_spindown",
}

function DiceBombs.AddDice(diceID, gfx)
    if diceID and type(diceID) == "number" and not DiceBombSpritesheets[diceID] then
        DiceBombSpritesheets[diceID] = gfx and "dice_"..gfx or "dice_modded"
    end
end

DiceBombs.GetPlayerFromTear = Helpers.GetPlayerFromTear
DiceBombs.GetBombRadiusFromDamage = Helpers.GetBombRadiusFromDamage

---@param bomb EntityBomb
function DiceBombsLocal:BombUpdate(bomb)
	local player = Helpers.GetPlayerFromTear(bomb)
	local data = Helpers.GetData(bomb)
	
	if player and not data.DiceBombVariant then
		if bomb.FrameCount == 1 then
			if bomb.Type == EntityType.ENTITY_BOMB then
				if player:HasCollectible(mod.CollectibleType.DICE_BOMBS) then
					if data.DiceBombVariant == nil then
                        data.DiceBombVariant = CollectibleType.COLLECTIBLE_D6
						for i = 0, 3 do
                            if DiceBombSpritesheets[player:GetActiveItem(i)] then
                                data.DiceBombVariant = player:GetActiveItem(i)
                                break
                            end
                        end
					end
				end
			end
		end
	end
	
	if data.DiceBombVariant then
        local diceBombGFX = DiceBombSpritesheets[CollectibleType.COLLECTIBLE_D6]
        if DiceBombSpritesheets[data.DiceBombVariant] then
            diceBombGFX = DiceBombSpritesheets[data.DiceBombVariant]
        end
		local sprite = bomb:GetSprite()

		if bomb.FrameCount == 1 then
			if bomb.Variant == BombVariant.BOMB_NORMAL then
				if not bomb:HasTearFlags(TearFlags.TEAR_BRIMSTONE_BOMB) then
					if not bomb:HasTearFlags(TearFlags.TEAR_GOLDEN_BOMB) then
						sprite:ReplaceSpritesheet(0, "gfx/items/pick ups/bombs/costumes/"..diceBombGFX..".png")
					else
						sprite:ReplaceSpritesheet(0, "gfx/items/pick ups/bombs/costumes/"..diceBombGFX.."_gold.png")
					end
					sprite:LoadGraphics()
				end
			end
		end
		
		if sprite:IsPlaying("Explode") then
            --[[for i, func in pairs(DiceBombSynergies[data.DiceBombVariant]) do
                func(_, bomb)
            end]]
            local callbacks = Isaac.GetCallbacks(LostItemsPack.Callbacks.ON_DICE_BOMB_EXPLOSION)
            local d6Ran = false
            local isBomber = player:HasCollectible(CollectibleType.COLLECTIBLE_BOMBER_BOY)
            local radius = Helpers.GetBombRadiusFromDamage(bomb.ExplosionDamage, isBomber)
            for _, callback in ipairs(callbacks) do
                if callback.Param and callback.Param == data.DiceBombVariant then
                    local ret = callback.Function(callback.Mod, bomb, player, radius)
                    if ret ~= nil and type(ret) == "boolean" and ret == true and not d6Ran then
                        d6Ran = true
                        DiceBombsLocal:D6BombExplode(bomb, player, radius)
                    end
                end
            end
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_BOMB_UPDATE, DiceBombsLocal.BombUpdate)