local BethsHeart = {}
local Helpers = require("lost_items_scripts.Helpers")
local bethsheartdesc = Isaac.GetItemConfig():GetCollectible(LostItemsPack.CollectibleType.BETHS_HEART)

function BethsHeart:GetSlot(player,slot)
	local charge = player:GetActiveCharge(slot) + player:GetBatteryCharge(slot)
	local battery = player:HasCollectible(CollectibleType.COLLECTIBLE_BATTERY)
	local item = Isaac:GetItemConfig():GetCollectible(player:GetActiveItem(slot))
	if player:GetActiveItem(slot) == CollectibleType.COLLECTIBLE_ALABASTER_BOX then
		if charge < item.MaxCharges then
			return nil
		end
	elseif player:GetActiveItem(slot) > 0 and charge < item.MaxCharges * (battery and 2 or 1) and player:GetActiveItem(slot) ~= CollectibleType.COLLECTIBLE_ERASER then
		return slot
	elseif slot < ActiveSlot.SLOT_POCKET then
		slot = BethsHeart:GetSlot(player,slot + 1)
		return slot
	end
	return nil
end

function BethsHeart:OverCharge(player,slot,item)
    ---@diagnostic disable-next-line: param-type-mismatch
	local effect = Isaac.Spawn(1000,49,1, player.Position+Vector(0,1),Vector.Zero,nil)
	effect:GetSprite().Offset = Vector(0,-22)
end

local DIRECTION_VECTOR = {
	[Direction.NO_DIRECTION] = Vector(0, 1),	-- when you don't shoot or move, you default to HeadDown
	[Direction.LEFT] = Vector(-1, 0),
	[Direction.UP] = Vector(0, -1),
	[Direction.RIGHT] = Vector(1, 0),
	[Direction.DOWN] = Vector(0, 1)
}


function BethsHeart:HeartCollectibleUpdate(player)
	local numFamiliars = player:GetCollectibleNum(LostItemsPack.CollectibleType.BETHS_HEART) +
	player:GetEffects():GetCollectibleEffectNum(LostItemsPack.CollectibleType.BETHS_HEART)

	player:CheckFamiliar(LostItemsPack.Entities.BETHS_HEART.variant, numFamiliars, player:GetCollectibleRNG(LostItemsPack.CollectibleType.BETHS_HEART), bethsheartdesc)	
end

function BethsHeart:BethsHeartInit(heart)
	heart:AddToFollowers()
	heart.State = 0
end

function BethsHeart:BethsHeartUpdate(heart)
	local player = heart.Player
	local bff = player:HasCollectible(CollectibleType.COLLECTIBLE_BFFS) and 2 or 1
	if heart.Hearts > 6 * bff then
		heart.Hearts = 6 * bff
	end
	local heartspr=heart:GetSprite()
	if not heartspr:IsPlaying("Idle"..heart.Hearts) then
		heartspr:Play("Idle"..heart.Hearts,false)
	end
	if not heartspr:IsOverlayPlaying("Charge"..heart.Hearts) then
		heartspr:PlayOverlay("Charge"..heart.Hearts,false)
	end

	if heart.State ~= 1 then
		heart:FollowParent()
		heart.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
	else
		heart:RemoveFromFollowers()
		heart.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NOPITS
	end

	if heart.State == 1 then
		for _,soulheart in pairs(Isaac.FindInRadius(heart.Position,15 + 5 * (bff-1),EntityPartition.PICKUP)) do
			if soulheart.Variant == PickupVariant.PICKUP_HEART and not soulheart:GetSprite():IsPlaying("Collect") then
				local restoreamount=0
				if soulheart.SubType == 902 then
					restoreamount=6
				elseif soulheart.SubType == HeartSubType.HEART_BLACK then
					restoreamount=3
				elseif soulheart.SubType == HeartSubType.HEART_SOUL then
					restoreamount=2
				elseif soulheart.SubType == HeartSubType.HEART_HALF_SOUL then
					restoreamount=1
				end
				if (not soulheart:ToPickup():IsShopItem()) and restoreamount>0 then
					if player:GetPlayerType() ~= PlayerType.PLAYER_BETHANY then
						if heart.Hearts < 6 * bff then
							heart.Hearts=heart.Hearts+restoreamount
							local effect = Isaac.Spawn(1000,49,4,heart.Position,Vector.Zero,heart)
							effect:GetSprite().Offset = Vector(0,-11)
							SFXManager():Play(171,1)
							soulheart:GetSprite():Play("Collect")
							soulheart:Die()
							soulheart.EntityCollisionClass=0
						end
					end
				end
			end
		end
		if heart:CollidesWithGrid() then
			heart.Velocity = Vector.Zero
			heart.State = 2
		end
	end
	if heart.State == 2 then
		local target = player
		if player:HasCollectible(CollectibleType.COLLECTIBLE_KING_BABY) then
			for _,king in ipairs(Isaac.FindByType(3,FamiliarVariant.KING_BABY)) do
				local baby = king:ToFamiliar()
				if GetPtrHash(baby.Player) == GetPtrHash(player) then
					target = baby
				end
			end
		end
		if (heart.Position - target.Position):Length() <= 70 then
			heart.State = 0
			heart:AddToFollowers()
		end
	end
end

function BethsHeart:BethInputUpdate(player)
	for _,heart in ipairs(Isaac.FindByType(3, LostItemsPack.Entities.BETHS_HEART.variant)) do
		if GetPtrHash(player) == GetPtrHash(heart:ToFamiliar().Player) then
			heart = heart:ToFamiliar()
			local heartData = Helpers.GetData(heart)
			local idx = player.ControllerIndex
			if Input.IsActionTriggered(ButtonAction.ACTION_DROP, idx) and heart.Hearts > 0 then
				local slot = BethsHeart:GetSlot(player,ActiveSlot.SLOT_PRIMARY)
				local charge = player:GetActiveCharge(slot) + player:GetBatteryCharge(slot)
				local item = Isaac:GetItemConfig():GetCollectible(player:GetActiveItem(slot))
				local battery = player:HasCollectible(CollectibleType.COLLECTIBLE_BATTERY) and 2 or 1
				if charge < item.MaxCharges * battery and item.ChargeType ~= 1 then
					---@diagnostic disable-next-line: param-type-mismatch
					Game():GetHUD():FlashChargeBar(player, slot)
					local charging
					if charge + heart.Hearts < item.MaxCharges * battery then
						charging = charge + heart.Hearts
						heart.Hearts = 0
					else
						charging = item.MaxCharges * battery
						heart.Hearts = heart.Hearts + charge - item.MaxCharges * battery
					end
					player:SetActiveCharge(charging, slot)
					SFXManager():Play(SoundEffect.SOUND_BATTERYCHARGE)
					BethsHeart:OverCharge(player)
				elseif item.ChargeType == 1 and charge < item.MaxCharges * battery then
					for i = 1,battery do
						if heart.Hearts > 0 and charge < item.MaxCharges * battery then
							player:FullCharge(slot)
							charge = player:GetActiveCharge(slot) + player:GetBatteryCharge(slot)
							heart.Hearts = heart.Hearts - 1
						else
							break
						end
					end
					BethsHeart:OverCharge(player)
				end
			end

			if not heartData.ShootButtonState and heart.State == 0 then
				if Input.IsActionTriggered(4, idx) then
				heartData.ShootButtonPressed = 4
				heartData.ShootButtonState = "listening for second tap"
				heartData.PressFrame = Game():GetFrameCount()
				elseif Input.IsActionTriggered(5, idx) then
					heartData.ShootButtonPressed = 5
					heartData.ShootButtonState = "listening for second tap"
					heartData.PressFrame = Game():GetFrameCount()
				elseif Input.IsActionTriggered(6, idx) then
					heartData.ShootButtonPressed = 6
					heartData.ShootButtonState = "listening for second tap"
					heartData.PressFrame = Game():GetFrameCount()
				elseif Input.IsActionTriggered(7, idx) then
					heartData.ShootButtonPressed = 7
					heartData.ShootButtonState = "listening for second tap"
					heartData.PressFrame = Game():GetFrameCount()
				end
			end

			if heartData.ShootButtonPressed and heartData.PressFrame and (Game():GetFrameCount() <= heartData.PressFrame + 10) and heart.State == 0 then
				if not Input.IsActionTriggered(heartData.ShootButtonPressed, idx) and heartData.ShootButtonState == "listening for second tap" then
					heartData.ShootButtonState = "button released"
				end
				
				if heartData.ShootButtonState == "button released" and Input.IsActionTriggered(heartData.ShootButtonPressed, idx) then
					heart.State = 1
					---@diagnostic disable-next-line: assign-type-mismatch
					heart.Velocity =  DIRECTION_VECTOR[player:GetFireDirection()]:Resized(12) + heart.Velocity / 2
					heartData.ShootButtonState = nil
					heartData.ShootButtonPressed = nil
					heartData.PressFrame = nil
				end
			else
				heartData.ShootButtonState = nil
				heartData.ShootButtonPressed = nil
				heartData.PressFrame = nil
			end

		end
	end
end

LostItemsPack:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, BethsHeart.BethsHeartInit, LostItemsPack.Entities.BETHS_HEART.variant)
LostItemsPack:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, BethsHeart.BethsHeartUpdate, LostItemsPack.Entities.BETHS_HEART.variant)
LostItemsPack:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, BethsHeart.BethInputUpdate)
LostItemsPack:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, BethsHeart.HeartCollectibleUpdate,CacheFlag.CACHE_FAMILIARS)