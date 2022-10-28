local VoodooPin = {}
local Helpers = require("lost_items_scripts.Helpers")

local MouseClick = {LEFT = 0, RIGHT = 1, WHEEL = 2, BACK = 3, FORWARD = 4}


function VoodooPin:UseVoodooPin(_, _, player, _, slot)
	local data = Helpers.GetData(player)
	if data.HoldVooodooPin ~= slot then
		data.HoldVooodooPin = slot
		player:AnimateCollectible(LostItemsPack.CollectibleType.VOODOO_PIN, "LiftItem", "PlayerPickup")
	else
		data.HoldVooodooPin = nil
		player:AnimateCollectible(LostItemsPack.CollectibleType.VOODOO_PIN, "HideItem", "PlayerPickup")
	end
	local returntable = {Discharge = false, Remove = false, ShowAnim = false} --don't discharge, don't remove item, don't show animation
	return returntable
end

function VoodooPin:OnNewRoom()
    for playerNum = 0, Game():GetNumPlayers() - 1 do
        local player = Game():GetPlayer(playerNum)
        Helpers.GetData(player).HoldVooodooPin = nil
    end
end

--taiking damage to reset state/slot number
function VoodooPin:DamagedWithVoodoo(player,dmg,dmgFlags,dmgSource,dmgCountDownFrames)
	local data = Helpers.GetData(player:ToPlayer())
	if data.SwapedEnemy then
		local entity = dmgSource.Entity
		if GetPtrHash(data.SwapedEnemy) ~= GetPtrHash(entity) then
			data.SwapedEnemy:TakeDamage(dmg, dmgFlags, dmgSource, dmgCountDownFrames * 2)
			return false
		end
	end
	Helpers.GetData(player).HoldVooodooPin = nil
	return nil
end

--taiking damage to reset state/slot number
function VoodooPin:DamagedWispVoodoo(wisp,dmg,dmgFlags,dmgSource,dmgCountDownFrames)
	if wisp.Variant == FamiliarVariant.WISP and wisp.SubType == LostItemsPack.CollectibleType.VOODOO_PIN then
		local entity = dmgSource.Entity
		
		if entity.Type == EntityType.ENTITY_PROJECTILE then
			entity = entity.SpawnerEntity
		end
		entity:TakeDamage(dmg * 2, dmgFlags, dmgSource, dmgCountDownFrames)
	end
	return nil
end

--shooting tears from bowl
function VoodooPin:VoodooThrow(player)

	local data = Helpers.GetData(player)
	data.Timer = data.Timer or 0
	if data.HoldVooodooPin ~= nil then
		if player:GetActiveItem(ActiveSlot.SLOT_SECONDARY) == LostItemsPack.CollectibleType.VOODOO_PIN then
			data.HoldVooodooPin = ActiveSlot.SLOT_SECONDARY
		elseif player:GetActiveItem(ActiveSlot.SLOT_PRIMARY) == LostItemsPack.CollectibleType.VOODOO_PIN then
			data.HoldVooodooPin = ActiveSlot.SLOT_PRIMARY
		end
	end
	if data.HoldVooodooPin then
		local idx = player.ControllerIndex
		local left = Input.GetActionValue(ButtonAction.ACTION_SHOOTLEFT,idx)
		local right = Input.GetActionValue(ButtonAction.ACTION_SHOOTRIGHT,idx)
		local up = Input.GetActionValue(ButtonAction.ACTION_SHOOTUP,idx)
		local down = Input.GetActionValue(ButtonAction.ACTION_SHOOTDOWN,idx)
		local mouseclick = Input.IsMouseBtnPressed(MouseClick.LEFT)
		if left > 0 or right > 0 or down > 0 or up > 0 or mouseclick then
			local shootVector
			if mouseclick then
				shootVector = (Input.GetMousePosition(true) - player.Position):Normalized()
			else
				shootVector = Vector(right-left,down-up):Normalized()
			end
			local vecShoot = shootVector * 10 + player.Velocity
			Isaac.Spawn(EntityType.ENTITY_TEAR,LostItemsPack.Entities.VOODOO_PIN_TEAR.variant,0,player.Position,vecShoot,player):ToTear()
			
			local charge
			if data.HoldVooodooPin ~= -1 then
				if Helpers.GetCharge(player,data.HoldVooodooPin)-3 >= 0 then
					charge = Helpers.GetCharge(player,data.HoldVooodooPin)-3
				else
					charge = 0
				end
				player:SetActiveCharge(charge,data.HoldVooodooPin)
			end
			data.HoldVooodooPin = nil
			player:AnimateCollectible(LostItemsPack.CollectibleType.VOODOO_PIN, "HideItem", "PlayerPickup")
			if player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES) then
				for _=1, 3 do
					player:AddWisp(LostItemsPack.CollectibleType.VOODOO_PIN, player.Position)
				end
			end
		end
	end
	if data.SwapedEnemy then
		if data.SwapedEnemy:IsDead() or not data.SwapedEnemy:Exists() then
			data.SwapedEnemy = nil
			data.Timer = 0
			player:SetMinDamageCooldown(60)
		elseif data.SwapedEnemy:IsBoss() then
			if data.Timer > 0 then
				data.Timer = data.Timer - 1
			elseif data.Timer <= 0 then
				data.SwapedEnemy = nil
				player:SetMinDamageCooldown(60)
			end
		end
	end
end

--taiking damage to reset state/slot number
function VoodooPin:VoodooHit(tear,collider,low)
	local player = Helpers.GetPlayerFromTear(tear)
    if not player then return end
	local data = Helpers.GetData(player)
	local sfx = SFXManager()
	if collider:IsVulnerableEnemy() then
		data.SwapedEnemy = collider:ToNPC()
		if collider:IsVulnerableEnemy() and collider:IsBoss() then
			data.Timer = 150
		end
	end
	sfx:Play(SoundEffect.SOUND_SPLATTER,1,0,false)
end

local voodoo = Sprite()
voodoo:Load("gfx/effects/voodoo_status.anm2", true)
voodoo:LoadGraphics()

function VoodooPin:RenderVoodooCurse(player)
	if Game():GetRoom():GetRenderMode() == RenderMode.RENDER_WATER_REFLECT then return end
	local data = Helpers.GetData(player)
	if data.SwapedEnemy then
		if not voodoo:IsPlaying("Curse") then
			voodoo:Play("Curse")
			voodoo.PlaybackSpeed = 0.4
		elseif not Game():IsPaused() then
			voodoo:Update()
		end
		local size = data.SwapedEnemy.Size < 20 and data.SwapedEnemy.Size or 20
		voodoo.Scale = Vector(1.3, 1.3)
        ---@diagnostic disable-next-line: assign-type-mismatch
		voodoo.Offset = data.SwapedEnemy:GetSprite().Offset - Vector(0.8, size * (data.SwapedEnemy.SizeMulti.Y * 2.8))
		voodoo.Color = Color(1,1,1,0.6)
		voodoo:Render(Game():GetRoom():WorldToScreenPosition(data.SwapedEnemy.Position),Vector.Zero,Vector.Zero)
	end
end

function VoodooPin:VoodooPinThrown(pin)
	pin.CollisionDamage = 1
	local sprite = pin:GetSprite()
	sprite.Rotation = pin.Velocity:Normalized():GetAngleDegrees()
	if pin.FrameCount == 1 then
		local sfx = SFXManager()
		if sfx:IsPlaying(SoundEffect.SOUND_TEARS_FIRE) then
			sfx:Stop(SoundEffect.SOUND_TEARS_FIRE)
			sfx:Play(SoundEffect.SOUND_SHELLGAME,1,0,false)
		end
	end
end

function VoodooPin:VoodooShatter(pin)
	if pin.Variant == LostItemsPack.Entities.VOODOO_PIN_TEAR.variant then
		local shatters = Isaac.Spawn(EntityType.ENTITY_EFFECT,LostItemsPack.Entities.VOODOO_PIN_SHATTER.variant,0,pin.Position,Vector.Zero,pin):GetSprite()
		local sfx = SFXManager()
		shatters.Rotation = pin:GetSprite().Rotation
		shatters.Offset = Vector(0,pin:ToTear().Height)
		shatters:Play("Shatter",true)
		sfx:Play(SoundEffect.SOUND_STONE_IMPACT,1,0,false)
	end
end

function VoodooPin:VoodooShattered(pin)
	local sprite = pin:GetSprite()
	if sprite:IsFinished("Shatter") then
		pin:Remove()
	end
end



LostItemsPack:AddCallback(ModCallbacks.MC_PRE_TEAR_COLLISION, VoodooPin.VoodooHit, LostItemsPack.Entities.VOODOO_PIN_TEAR.variant)
LostItemsPack:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, VoodooPin.VoodooThrow)
LostItemsPack:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, VoodooPin.DamagedWithVoodoo, EntityType.ENTITY_PLAYER)
LostItemsPack:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, VoodooPin.DamagedWispVoodoo, EntityType.ENTITY_FAMILIAR)
LostItemsPack:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, VoodooPin.OnNewRoom)
LostItemsPack:AddCallback(ModCallbacks.MC_USE_ITEM, VoodooPin.UseVoodooPin, LostItemsPack.CollectibleType.VOODOO_PIN)
LostItemsPack:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, VoodooPin.VoodooPinThrown, LostItemsPack.Entities.VOODOO_PIN_TEAR.variant)
LostItemsPack:AddCallback(ModCallbacks.MC_POST_PLAYER_RENDER, VoodooPin.RenderVoodooCurse)
LostItemsPack:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, VoodooPin.VoodooShatter, EntityType.ENTITY_TEAR)
LostItemsPack:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, VoodooPin.VoodooShattered, LostItemsPack.Entities.VOODOO_PIN_SHATTER.variant)

local entitySpawnData = {}
LostItemsPack:AddCallback(ModCallbacks.MC_PRE_ENTITY_SPAWN, function(_, type, variant, subType, position, velocity, spawner, seed)
	entitySpawnData[seed] = {
		Type = type,
		Variant = variant,
		SubType = subType,
		Position = position,
		Velocity = velocity,
		SpawnerEntity = spawner,
		InitSeed = seed
	}
end)
LostItemsPack:AddCallback(ModCallbacks.MC_POST_TEAR_INIT, function(_, entity)
	local seed = entity.InitSeed
	local data = Helpers.GetData(entity)
	data.SpawnData = entitySpawnData[seed]
end)
LostItemsPack:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, function(_, entity)
	local data = Helpers.GetData(entity)
	data.SpawnData = nil
end)
LostItemsPack:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
	entitySpawnData = {}
end)
