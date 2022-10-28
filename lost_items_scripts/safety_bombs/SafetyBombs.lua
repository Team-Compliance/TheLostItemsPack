local SafetyBombsMod = {}
local Helpers = require("lost_items_scripts.Helpers")



function SafetyBombsMod:BombUpdate(bomb)
	local player = Helpers.GetPlayerFromTear(bomb)
	local data = bomb:GetData()
	local fuseCD = 30
	local isBomber
	if player then
		if bomb.FrameCount == 1 then
			if bomb.Type == EntityType.ENTITY_BOMB then
				if bomb.Variant ~= BombVariant.BOMB_THROWABLE then
					if player:HasCollectible(LostItemsPack.CollectibleType.SAFETY_BOMBS) then
						if data.isSafetyBomb == nil then
							data.isSafetyBomb = true
						end
					end
				end
			end
		end
		if player:HasTrinket(TrinketType.TRINKET_SHORT_FUSE) then
			fuseCD = 2
		end
		isBomber = player:HasCollectible(CollectibleType.COLLECTIBLE_BOMBER_BOY)
	end

	if data.isSafetyBomb then
		if bomb.FrameCount == 1 then
			if bomb.Variant == BombVariant.BOMB_NORMAL then
				if not bomb:HasTearFlags(TearFlags.TEAR_BRIMSTONE_BOMB) then
					local sprite = bomb:GetSprite()
					if bomb:HasTearFlags(TearFlags.TEAR_GOLDEN_BOMB) then
						sprite:ReplaceSpritesheet(0, "gfx/items/pick ups/bombs/costumes/safety_bombs_gold.png")
					else
						sprite:ReplaceSpritesheet(0, "gfx/items/pick ups/bombs/costumes/safety_bombs.png")
					end
					sprite:LoadGraphics()
				end
			end
		end
		
		for i, p in ipairs(Isaac.FindInRadius(bomb.Position, Helpers.GetBombRadiusFromDamage(bomb.ExplosionDamage,isBomber) * bomb.RadiusMultiplier, EntityPartition.PLAYER)) do
			bomb:SetExplosionCountdown(fuseCD) -- temporary until we can get explosion countdown directly
			--bomb:SetExplosionCountdown(bomb.ExplosionCountdown)
			break
		end
	end
end
LostItemsPack:AddCallback(ModCallbacks.MC_POST_BOMB_UPDATE, SafetyBombsMod.BombUpdate)


local function DoRenderRadar(bomb)
	local data = bomb:GetData()
	local player = Helpers.GetPlayerFromTear(bomb)
	local isBomber = player and player:HasCollectible(CollectibleType.COLLECTIBLE_BOMBER_BOY)
	data.BombRadar.SafetyBombTrigger = false
	for i, p in ipairs(Isaac.FindInRadius(bomb.Position, Helpers.GetBombRadiusFromDamage(bomb.ExplosionDamage,isBomber) * bomb.RadiusMultiplier, EntityPartition.PLAYER)) do
		data.BombRadar.SafetyBombTrigger = true
	end
	if not Game():IsPaused() then
		if data.BombRadar.SafetyBombTrigger then
			if data.BombRadar.SafetyBombTransparency < 1 then
				data.BombRadar.SafetyBombTransparency = data.BombRadar.SafetyBombTransparency + 0.05
			end
		elseif data.BombRadar.SafetyBombTransparency > 0 then
			data.BombRadar.SafetyBombTransparency = data.BombRadar.SafetyBombTransparency - 0.05
		end
	end
	if data.BombRadar.SafetyBombTransparency > 0 then
		if not Game():IsPaused() then
			data.BombRadar.Sprite:Update()
		end
		data.BombRadar.Sprite.Color = Color(1,1,1,data.BombRadar.SafetyBombTransparency)
		data.BombRadar.Sprite:Render(Game():GetRoom():WorldToScreenPosition(bomb.Position))
	elseif data.BombRadar.SafetyBombTransparency <= 0 then
		data.BombRadar = nil
	end
end
function SafetyBombsMod:BombRadar(bomb)
	local data = bomb:GetData()
	
	if data.isSafetyBomb then
		if not data.BombRadar then
			local player = Helpers.GetPlayerFromTear(bomb)
			local isBomber = player and player:HasCollectible(CollectibleType.COLLECTIBLE_BOMBER_BOY)
			local mul = Helpers.GetBombRadiusFromDamage(bomb.ExplosionDamage,isBomber) / 75 * bomb.RadiusMultiplier
			data.BombRadar = {}
			data.BombRadar.Sprite = Sprite()
			data.BombRadar.Sprite:Load("gfx/safetybombsradar.anm2",true)
			data.BombRadar.Sprite:Play("Idle")
			data.BombRadar.Sprite.Scale = Vector(1.4*mul,1.4*mul)
			data.BombRadar.Sprite.PlaybackSpeed = 0.4
			data.BombRadar.SafetyBombTransparency = 0
			data.BombRadar.SafetyBombTrigger = false
		else
			DoRenderRadar(bomb)
		end
	end
end
LostItemsPack:AddCallback(ModCallbacks.MC_POST_BOMB_RENDER, SafetyBombsMod.BombRadar)