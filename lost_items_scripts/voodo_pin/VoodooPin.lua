local VoodooPin = {}
local Helpers = require("lost_items_scripts.Helpers")

local MouseClick = {LEFT = 0, RIGHT = 1, WHEEL = 2, BACK = 3, FORWARD = 4}


function VoodooPin:UseVoodooPin(collectible, _, player, _, slot)
	local data = Helpers.GetData(player)
	if LostItemsPack.CollectibleType.VOODOO_PIN == collectible then
		if data.HoldVooodooPin ~= slot then
			data.HoldVooodooPin = slot
			player:AnimateCollectible(LostItemsPack.CollectibleType.VOODOO_PIN, "LiftItem", "PlayerPickup")
			data.VoodooWaitFrames = 20
		else
			data.HoldVooodooPin = nil
			data.VoodooWaitFrames = 0
			player:AnimateCollectible(LostItemsPack.CollectibleType.VOODOO_PIN, "HideItem", "PlayerPickup")
		end
		local returntable = {Discharge = false, Remove = false, ShowAnim = false} --don't discharge, don't remove item, don't show animation
		return returntable
	else
		data.HoldVooodooPin = nil
		data.VoodooWaitFrames = 0
	end
end
LostItemsPack:AddCallback(ModCallbacks.MC_USE_ITEM, VoodooPin.UseVoodooPin)


function VoodooPin:OnNewRoom()
    for playerNum = 0, Game():GetNumPlayers() - 1 do
        local player = Game():GetPlayer(playerNum)
        Helpers.GetData(player).HoldVooodooPin = nil
        Helpers.GetData(player).VoodooWaitFrames = 0
    end
end
LostItemsPack:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, VoodooPin.OnNewRoom)


--taiking damage to reset state/slot number
function VoodooPin:DamagedWithVoodoo(player,dmg,dmgFlags,dmgSource,dmgCountDownFrames)
	local data = Helpers.GetData(player:ToPlayer())
	if data.SwapedEnemy then
		local entity = dmgSource.Entity
		if entity and GetPtrHash(data.SwapedEnemy) ~= GetPtrHash(entity) then
			data.SwapedEnemy:TakeDamage(dmg, dmgFlags, dmgSource, dmgCountDownFrames * 2)
			return false
		end
	end
	Helpers.GetData(player).HoldVooodooPin = nil
	Helpers.GetData(player).VoodooWaitFrames = 0
	return nil
end
LostItemsPack:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, VoodooPin.DamagedWithVoodoo, EntityType.ENTITY_PLAYER)


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
LostItemsPack:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, VoodooPin.DamagedWispVoodoo, EntityType.ENTITY_FAMILIAR)


--shooting tears from bowl
function VoodooPin:VoodooThrow(player)

	local data = Helpers.GetData(player)
	data.Timer = data.Timer or 0
	if data.HoldVooodooPin ~= nil then
		if not (player:GetActiveItem(ActiveSlot.SLOT_PRIMARY) == LostItemsPack.CollectibleType.VOODOO_PIN and data.HoldVooodooPin == 0
		or player:GetActiveItem(ActiveSlot.SLOT_POCKET) == LostItemsPack.CollectibleType.VOODOO_PIN and data.HoldVooodooPin == 2) then
			data.HoldVooodooPin = nil
			player:AnimateCollectible(LostItemsPack.CollectibleType.VOODOO_PIN, "HideItem", "PlayerPickup")
			data.VoodooWaitFrames = 0
		end
	end
	if data.HoldVooodooPin then
		local idx = player.ControllerIndex
		local left = Input.GetActionValue(ButtonAction.ACTION_SHOOTLEFT,idx)
		local right = Input.GetActionValue(ButtonAction.ACTION_SHOOTRIGHT,idx)
		local up = Input.GetActionValue(ButtonAction.ACTION_SHOOTUP,idx)
		local down = Input.GetActionValue(ButtonAction.ACTION_SHOOTDOWN,idx)
		local mouseclick = Input.IsMouseBtnPressed(MouseClick.LEFT)
		if data.VoodooWaitFrames then
			data.VoodooWaitFrames = data.VoodooWaitFrames - 1
		else
			data.VoodooWaitFrames = 0
		end
		if (left > 0 or right > 0 or down > 0 or up > 0 or mouseclick) and data.VoodooWaitFrames <= 0 then
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
				if Helpers.GetCharge(player,data.HoldVooodooPin)-4 >= 0 then
					charge = Helpers.GetCharge(player,data.HoldVooodooPin)-4
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
LostItemsPack:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, VoodooPin.VoodooThrow)


--taiking damage to reset state/slot number
---@param tear EntityTear
---@param collider Entity
function VoodooPin:VoodooHit(tear,collider)
	local player = Helpers.GetPlayerFromTear(tear)
    if not player then return end

	local data = Helpers.GetData(player)
	local sfx = SFXManager()
	if collider:IsVulnerableEnemy() then
		data.SwapedEnemy = collider:ToNPC()
		if collider:IsBoss() then
			data.Timer = 150
		end

		Game():ShakeScreen(7)
		SFXManager():Play(SoundEffect.SOUND_DEVILROOM_DEAL, 0.5)

		for _ = 1, 2 + math.random(3), 1 do
			local spawningPos = tear.Position + Vector(0, tear.Height)
			local speed = Vector.One
			speed:Resize(math.random() * 3 + 2)
			speed = speed:Rotated(math.random(360))
			local particle = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_PARTICLE, 0, spawningPos, speed, nil)
			particle:GetSprite().Color = Color(0.1, 0.1, 0.1)
			particle.SpriteScale = Vector(0.7, 0.7)
		end
	end
	sfx:Play(SoundEffect.SOUND_SPLATTER,1,0,false)
end
LostItemsPack:AddCallback(ModCallbacks.MC_PRE_TEAR_COLLISION, VoodooPin.VoodooHit, LostItemsPack.Entities.VOODOO_PIN_TEAR.variant)


local voodoo = Sprite()
voodoo:Load("gfx/effects/voodoo_status.anm2", true)
voodoo:LoadGraphics()


function VoodooPin:RenderVoodooCurse(player)
	local data = Helpers.GetData(player)
	if not data.SwapedEnemy then return end

	data.SwapedEnemy:SetColor(Color(0.518, 0.15, 0.8), 2, 1, false, false)

	if Game():GetRoom():GetRenderMode() == RenderMode.RENDER_WATER_REFLECT then return end

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
	voodoo.Color = Color(1,1,1,0.8)
	voodoo:Render(Game():GetRoom():WorldToScreenPosition(data.SwapedEnemy.Position),Vector.Zero,Vector.Zero)
end


function VoodooPin:OnRender()
	for i = 0, Game():GetNumPlayers(), 1 do
		local player = Game():GetPlayer(i)
		VoodooPin:RenderVoodooCurse(player)
	end
end
LostItemsPack:AddCallback(ModCallbacks.MC_POST_RENDER, VoodooPin.OnRender)


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
LostItemsPack:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, VoodooPin.VoodooPinThrown, LostItemsPack.Entities.VOODOO_PIN_TEAR.variant)


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
LostItemsPack:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, VoodooPin.VoodooShatter, EntityType.ENTITY_TEAR)


function VoodooPin:VoodooShattered(pin)
	local sprite = pin:GetSprite()
	if sprite:IsFinished("Shatter") then
		pin:Remove()
	end
end
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