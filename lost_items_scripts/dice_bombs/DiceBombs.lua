local DiceBombs = {}
local mod = LostItemsPack
local Helpers = require("lost_items_scripts.Helpers")

---@param bomb EntityBomb
function DiceBombs:D1BombExplode(bomb)
    local player = Helpers.GetPlayerFromTear(bomb)
    local isBomber = player and player:HasCollectible(CollectibleType.COLLECTIBLE_BOMBER_BOY)
    local radius = Helpers.GetBombRadiusFromDamage(bomb.ExplosionDamage,isBomber)
			
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
end

---@param bomb EntityBomb
function DiceBombs:D4BombExplode(bomb)
    local player = Helpers.GetPlayerFromTear(bomb)
    local isBomber = player and player:HasCollectible(CollectibleType.COLLECTIBLE_BOMBER_BOY)
    local radius = Helpers.GetBombRadiusFromDamage(bomb.ExplosionDamage,isBomber)
			
    for i, entity in ipairs(Isaac.FindInRadius(bomb.Position, radius)) do
        if entity.Type == EntityType.ENTITY_PLAYER and entity.Variant == 0 then
            entity:ToPlayer():UseActiveItem(CollectibleType.COLLECTIBLE_D4, 1)
        end
    end
end

---@param bomb EntityBomb
function DiceBombs:D6BombExplode(bomb)
    local player = Helpers.GetPlayerFromTear(bomb)
    local isBomber = player and player:HasCollectible(CollectibleType.COLLECTIBLE_BOMBER_BOY)
    local radius = Helpers.GetBombRadiusFromDamage(bomb.ExplosionDamage,isBomber)
			
    for i, entity in ipairs(Isaac.FindInRadius(bomb.Position, radius)) do
        if entity.Type == EntityType.ENTITY_PICKUP and entity.Variant == PickupVariant.PICKUP_COLLECTIBLE then
            if not DiceBombItemBlacklist[entity.SubType] then
                entity:ToPickup():Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, 0, true)
                Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, entity.Position, Vector.Zero, nil)
            end
        end
    end
end

---@param bomb EntityBomb
function DiceBombs:D8BombExplode(bomb)
    local player = Helpers.GetPlayerFromTear(bomb)
    local isBomber = player and player:HasCollectible(CollectibleType.COLLECTIBLE_BOMBER_BOY)
    local radius = Helpers.GetBombRadiusFromDamage(bomb.ExplosionDamage,isBomber)

    for i, entity in ipairs(Isaac.FindInRadius(bomb.Position, radius)) do
        if entity.Type == EntityType.ENTITY_PLAYER and entity.Variant == 0 then
            entity:ToPlayer():UseActiveItem(CollectibleType.COLLECTIBLE_D8, 1)
        end
    end
end

---@param bomb EntityBomb
function DiceBombs:D20BombExplode(bomb)
    local player = Helpers.GetPlayerFromTear(bomb)
    local isBomber = player and player:HasCollectible(CollectibleType.COLLECTIBLE_BOMBER_BOY)
    local radius = Helpers.GetBombRadiusFromDamage(bomb.ExplosionDamage,isBomber)

    for i, entity in ipairs(Isaac.FindInRadius(bomb.Position, radius)) do
        if entity.Type == EntityType.ENTITY_PICKUP and not DiceBombPickupBlacklist[entity.Variant] then
            entity:ToPickup():Morph(EntityType.ENTITY_PICKUP, 0, 0)
        end
    end
end

---@param bomb EntityBomb
function DiceBombs:SpindownBombExplode(bomb)
    local player = Helpers.GetPlayerFromTear(bomb)
    local isBomber = player and player:HasCollectible(CollectibleType.COLLECTIBLE_BOMBER_BOY)
    local radius = Helpers.GetBombRadiusFromDamage(bomb.ExplosionDamage,isBomber)
    
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

DiceBombSynergies = {
	[CollectibleType.COLLECTIBLE_D1] = {
        DiceBombs.D1BombExplode,
        DiceBombs.D6BombExplode,
    },
	[CollectibleType.COLLECTIBLE_D4] = {
        DiceBombs.D4BombExplode,
        DiceBombs.D6BombExplode,
    },
    [CollectibleType.COLLECTIBLE_D6] = {
        DiceBombs.D6BombExplode,
    },
    [CollectibleType.COLLECTIBLE_D8] = {
        DiceBombs.D6BombExplode,
        DiceBombs.D8BombExplode,
    },
    [CollectibleType.COLLECTIBLE_D20] = {
        DiceBombs.D6BombExplode,
        DiceBombs.D20BombExplode,
    },
    [CollectibleType.COLLECTIBLE_D100] = {
        DiceBombs.D1BombExplode,
        DiceBombs.D4BombExplode,
        DiceBombs.D6BombExplode,
        DiceBombs.D8BombExplode,
        DiceBombs.D20BombExplode
    },
    [CollectibleType.COLLECTIBLE_SPINDOWN_DICE] = {
        DiceBombs.SpindownBombExplode
    },
}

DiceBombItemBlacklist = {
    [CollectibleType.COLLECTIBLE_POLAROID] = true,
    [CollectibleType.COLLECTIBLE_NEGATIVE] = true,
    [CollectibleType.COLLECTIBLE_DADS_NOTE] = true,
    [CollectibleType.COLLECTIBLE_NULL] = true
}

DiceBombPickupBlacklist = {
    [PickupVariant.PICKUP_BED] = true,
    [PickupVariant.PICKUP_BIGCHEST] = true,
    [PickupVariant.PICKUP_MOMSCHEST] = true,
    [PickupVariant.PICKUP_SHOPITEM] = true,
    [PickupVariant.PICKUP_THROWABLEBOMB] = true,
    [PickupVariant.PICKUP_TROPHY] = true
}

DiceBombSpritesheets = {
    [CollectibleType.COLLECTIBLE_D1] = "",
    [CollectibleType.COLLECTIBLE_D4] = "",
    [CollectibleType.COLLECTIBLE_D6] = "",
    [CollectibleType.COLLECTIBLE_D8] = "",
    [CollectibleType.COLLECTIBLE_D20] = "",
    [CollectibleType.COLLECTIBLE_D100] = "",
    [CollectibleType.COLLECTIBLE_ETERNAL_D6] = "",
    [CollectibleType.COLLECTIBLE_SPINDOWN_DICE] = "",
}

local png = ".png"
local goldpng = "_gold.png"

---@param bomb EntityBomb
function DiceBombs:BombUpdate(bomb)
	local player = Helpers.GetPlayerFromTear(bomb)
	local data = Helpers.GetData(bomb)
	
	if player then
		if bomb.FrameCount == 1 then
			if bomb.Type == EntityType.ENTITY_BOMB then
				if player:HasCollectible(mod.CollectibleType.DICE_BOMBS) then
					if data.DiceBombVariant == nil then
                        data.DiceBombVariant = CollectibleType.COLLECTIBLE_D6
						for i = 0, 3 do
                            if DiceBombSynergies[player:GetActiveItem(i)] then
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
		local sprite = bomb:GetSprite()

		if bomb.FrameCount == 1 then
			if bomb.Variant == BombVariant.BOMB_NORMAL then
				if not bomb:HasTearFlags(TearFlags.TEAR_BRIMSTONE_BOMB) then
					if not bomb:HasTearFlags(TearFlags.TEAR_GOLDEN_BOMB) then
						--sprite:ReplaceSpritesheet(0, DiceBombSpritesheets[data.DiceBombVariant]..png)
					else
						--sprite:ReplaceSpritesheet(0, DiceBombSpritesheets[data.DiceBombVariant]..goldpng)
					end
					sprite:LoadGraphics()
				end
			end
		end
		
		if sprite:IsPlaying("Explode") then
            for i, func in pairs(DiceBombSynergies[data.DiceBombVariant]) do
                func(_, bomb)
            end
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_BOMB_UPDATE, DiceBombs.BombUpdate)