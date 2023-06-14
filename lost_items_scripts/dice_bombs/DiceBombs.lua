local DiceBombs = {}
local mod = LostItemsPack
local Helpers = require("lost_items_scripts.Helpers")

---@param bomb EntityBomb
function DiceBombs:D1BombExplode(bomb)
    print("D1")
end

---@param bomb EntityBomb
function DiceBombs:D4BombExplode(bomb)
    print("D4")
end

---@param bomb EntityBomb
function DiceBombs:D6BombExplode(bomb)
    local radius = bomb.RadiusMultiplier

    for i, entity in ipairs(Isaac.FindInRadius(bomb.Position, radius * 40)) do
        if entity.Type == EntityType.ENTITY_PICKUP and entity.Variant == PickupVariant.PICKUP_COLLECTIBLE then
            if 1 + 1 == 2 then --todo: check if item is not in blacklist
                entity:ToPickup():Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, 0)
                Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, entity.Position, Vector.Zero, nil)
            end
        end
    end
end

---@param bomb EntityBomb
function DiceBombs:D8BombExplode(bomb)
    print("D8")
end

---@param bomb EntityBomb
function DiceBombs:D20BombExplode(bomb)
    local radius = bomb.RadiusMultiplier

    for i, entity in ipairs(Isaac.FindInRadius(bomb.Position, radius * 40)) do
        if entity.Type == EntityType.ENTITY_PICKUP and entity.Variant < PickupVariant.PICKUP_COLLECTIBLE then
            entity:ToPickup():Morph(EntityType.ENTITY_PICKUP, 0, 0)
        end
    end
end

---@param bomb EntityBomb
function DiceBombs:SpindownBombExplode(bomb)
    print("Spindown")
end

---@param bomb EntityBomb
function DiceBombs:EternalBombExplode(bomb)
    print("Eternal")
end

DiceBombSynergies = {
	[CollectibleType.COLLECTIBLE_D1] = {
        DiceBombs.D1BombExplode,
        DiceBombs.D6BombExplode,
        DiceBombs.D20BombExplode
    },
	[CollectibleType.COLLECTIBLE_D4] = {
        DiceBombs.D4BombExplode,
        DiceBombs.D6BombExplode,
        DiceBombs.D20BombExplode
    },
    [CollectibleType.COLLECTIBLE_D8] = {
        DiceBombs.D6BombExplode,
        DiceBombs.D8BombExplode,
        DiceBombs.D20BombExplode
    },
    [CollectibleType.COLLECTIBLE_D100] = {
        DiceBombs.D1BombExplode,
        DiceBombs.D4BombExplode,
        DiceBombs.D6BombExplode,
        DiceBombs.D8BombExplode,
        DiceBombs.D20BombExplode
    },
    [CollectibleType.COLLECTIBLE_ETERNAL_D6] = {
        DiceBombs.D20BombExplode,
        DiceBombs.SpindownBombExplode
    },
    [CollectibleType.COLLECTIBLE_SPINDOWN_DICE] = {
        DiceBombs.D20BombExplode,
        DiceBombs.SpindownBombExplode
    },
}

DiceBombSpritesheets = {
    [CollectibleType.COLLECTIBLE_D1] = "",
    [CollectibleType.COLLECTIBLE_D4] = "",
    [CollectibleType.COLLECTIBLE_D8] = "",
    [CollectibleType.COLLECTIBLE_D100] = "",
    [CollectibleType.COLLECTIBLE_ETERNAL_D6] = "",
    [CollectibleType.COLLECTIBLE_SPINDOWN_DICE] = "",
}

DiceBombItemBlacklist = {
    CollectibleType.COLLECTIBLE_DADS_NOTE
}

local dicebombsprite = ""
local png = ".png"
local goldpng = "_gold.png"

---@param bomb EntityBomb
function DiceBombs:BombUpdate(bomb)
	local player = Helpers.GetPlayerFromTear(bomb)
	local data = Helpers.GetData(bomb)
	
	if player then
		if bomb.FrameCount == 1 then
			if bomb.Type == EntityType.ENTITY_BOMB then
				if bomb.Variant ~= BombVariant.BOMB_THROWABLE then
					if player:HasCollectible(mod.CollectibleType.DICE_BOMBS) then
						if data.DiceBombVariant == nil then
							data.DiceBombVariant = player:GetActiveItem()
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
					if bomb:HasTearFlags(TearFlags.TEAR_GOLDEN_BOMB) then
						--sprite:ReplaceSpritesheet(0, DiceBombSpritesheets[data.DiceBombVariant]..goldpng or dicebombsprite..goldpng)
					else
						--sprite:ReplaceSpritesheet(0, sprite:ReplaceSpritesheet(0, DiceBombSpritesheets[data.DiceBombVariant]..png or dicebombsprite..png))
					end
					sprite:LoadGraphics()
				end
			end
		end
		
		if sprite:IsPlaying("Explode") then
            if DiceBombSynergies[data.DiceBombVariant] then
                for i, func in pairs(DiceBombSynergies[data.DiceBombVariant]) do
                    func(bomb)
                end
            else 
                DiceBombs:D6BombExplode(bomb)
                DiceBombs:D20BombExplode(bomb)
            end
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_BOMB_UPDATE, DiceBombs.BombUpdate)