local BlankBombsMod = {}
local Helpers = require("lost_items_scripts.Helpers")

local BombsInRoom = {}
local RocketsAboutToExplode = {}


---@param bomb Entity
---@return boolean
local function IsBlankBomb(bomb)
	if not bomb then return false end
	if bomb.Type ~= EntityType.ENTITY_BOMB then return false end
	bomb = bomb:ToBomb()
	if bomb.Variant ~= BombVariant.BOMB_NORMAL and bomb.Variant ~= BombVariant.BOMB_GIGA and
	bomb.Variant ~= BombVariant.BOMB_ROCKET then return false end

	local player = Helpers.GetPlayerFromTear(bomb)
	if not player then return false end

	local isRandomNancyBlankBomb = false
	if player:HasCollectible(CollectibleType.COLLECTIBLE_NANCY_BOMBS) and not
	player:HasCollectible(LostItemsPack.CollectibleType.BLANK_BOMBS) then
		local rng = RNG()
		rng:SetSeed(bomb.InitSeed, 35)

		isRandomNancyBlankBomb = rng:RandomInt(100) < 7
	end

	if not player:HasCollectible(LostItemsPack.CollectibleType.BLANK_BOMBS) and not isRandomNancyBlankBomb then return false end

	return true
end


---@param bomb EntityBomb
local function CanBombInstaDetonate(bomb)
	local wasInRoom = false
	local bombPtr = GetPtrHash(bomb)
	for _, bombInRoom in ipairs(BombsInRoom) do
		if bombPtr == bombInRoom then
			wasInRoom = true
		end
	end

	return not (wasInRoom or bomb.IsFetus or bomb.Variant == BombVariant.BOMB_ROCKET or
	bomb.Variant == BombVariant.BOMB_GIGA or bomb.Variant == BombVariant.BOMB_ROCKET_GIGA)
end


function ScreenWobble(position)
	local abusedMonstro = Isaac.Spawn(EntityType.ENTITY_MONSTRO, 0, 0, position, Vector.Zero, nil)
	abusedMonstro = abusedMonstro:ToNPC()

	abusedMonstro.Visible = false
	abusedMonstro.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
	abusedMonstro.GridCollisionClass = GridCollisionClass.COLLISION_NONE
	abusedMonstro:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
	abusedMonstro.State = NpcState.STATE_STOMP

	local monstroSpr = abusedMonstro:GetSprite()
	monstroSpr:Play("JumpDown", true)
	monstroSpr:SetFrame(32)

	abusedMonstro:GetData().IsAbusedMonstro = true
end


---@param center Vector
---@param radius number
local function DoBlankEffect(center, radius)
	--Spawn cool explosion effect
	local blankExplosion = Isaac.Spawn(EntityType.ENTITY_EFFECT, LostItemsPack.Entities.BLANK_BOMB_EXPLOSION.variant, 0, center, Vector.Zero, nil)
	blankExplosion:GetSprite():Play("Explode", true)
	blankExplosion.DepthOffset = 9999
	blankExplosion.SpriteScale = blankExplosion.SpriteScale * (radius/90)
	blankExplosion.Color = Color(1, 1, 1, math.min(1, radius/90))

	--Do screen wobble
	ScreenWobble(center)

	--Remove projectiles in radius
	for _, projectile in ipairs(Isaac.FindByType(EntityType.ENTITY_PROJECTILE)) do
		projectile = projectile:ToProjectile()

		local realPosition = projectile.Position - Vector(0, projectile.Height)

		if realPosition:DistanceSquared(center) <= (radius * 3) ^ 2 then
			if projectile:HasProjectileFlags(ProjectileFlags.ACID_GREEN) or
			projectile:HasProjectileFlags(ProjectileFlags.ACID_RED) or
			projectile:HasProjectileFlags(ProjectileFlags.CREEP_BROWN) or
			projectile:HasProjectileFlags(ProjectileFlags.EXPLODE) or
			projectile:HasProjectileFlags(ProjectileFlags.BURST) or
			projectile:HasProjectileFlags(ProjectileFlags.ACID_GREEN) then
				--If the projectile has any flag that triggers on hit, we need to remove the projectile
				projectile:Remove()
			else
				projectile:Die()
			end
		end
	end

	--Push enemies back
	for _, entity in ipairs(Isaac.FindInRadius(center, radius * 3, EntityPartition.ENEMY)) do
		if entity:IsActiveEnemy(false) and entity:IsVulnerableEnemy() then
			local pushDirection = (entity.Position - center):Normalized()
			entity:AddVelocity(pushDirection * 30)
		end
	end
end


function BlankBombsMod:OnNewRoom()
	BombsInRoom = {}
	for _, bomb in ipairs(Isaac.FindByType(EntityType.ENTITY_BOMB)) do
		bomb = bomb:ToBomb()

		if IsBlankBomb(bomb) then
			local sprite = bomb:GetSprite()

            ---@diagnostic disable-next-line: param-type-mismatch
			if bomb:HasTearFlags(TearFlags.TEAR_GOLDEN_BOMB) then
				sprite:ReplaceSpritesheet(0, "gfx/items/pick ups/bombs/costumes/blank_bombs_gold.png")
			else
				sprite:ReplaceSpritesheet(0, "gfx/items/pick ups/bombs/costumes/blank_bombs.png")
			end
			sprite:LoadGraphics()

			table.insert(BombsInRoom, GetPtrHash(bomb))
		end
	end
end
LostItemsPack:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, BlankBombsMod.OnNewRoom)


---@param bomb EntityBomb
function BlankBombsMod:OnBombInitLate(bomb)
	if bomb.Variant == BombVariant.BOMB_GIGA then return end

	local sprite = bomb:GetSprite()

	local spritesheetPreffix = ""
	local spritesheetSuffix = ""

	if bomb.Variant == BombVariant.BOMB_ROCKET then
		spritesheetPreffix = "rocket_"
    ---@diagnostic disable-next-line: param-type-mismatch
	elseif bomb:HasTearFlags(TearFlags.TEAR_BRIMSTONE_BOMB) then
		spritesheetPreffix = "brimstone_"
	end

    ---@diagnostic disable-next-line: param-type-mismatch
	if bomb:HasTearFlags(TearFlags.TEAR_GOLDEN_BOMB) then
		spritesheetSuffix = "_gold"
	end

	sprite:ReplaceSpritesheet(0, "gfx/items/pick ups/bombs/costumes/" .. spritesheetPreffix .. "blank_bombs" .. spritesheetSuffix .. ".png")
	sprite:LoadGraphics()

	--Instantly explode if player isn't pressing ctrl
	if not CanBombInstaDetonate(bomb) then return end

	local player = Helpers.GetPlayerFromTear(bomb)
    if not player then return end
	local controller = player.ControllerIndex

	if not Input.IsActionPressed(ButtonAction.ACTION_DROP, controller) then
		if not player:HasEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK) then
			player:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK)
			player:GetData().AddNoKnockBackFlag = 2
		end

		bomb.ExplosionDamage = bomb.ExplosionDamage / 2
		if player:HasGoldenBomb() then bomb.ExplosionDamage = bomb.ExplosionDamage / 2 end
		bomb:SetExplosionCountdown(0)
	end
end


---@param bomb EntityBomb
function BlankBombsMod:BombUpdate(bomb)
	if not IsBlankBomb(bomb) then return end

	if bomb.FrameCount == 1 then
		BlankBombsMod:OnBombInitLate(bomb)
	end

	local sprite = bomb:GetSprite()
	if sprite:IsPlaying("Explode") then
        ---@diagnostic disable-next-line: param-type-mismatch
		if bomb:HasTearFlags(TearFlags.TEAR_SCATTER_BOMB) then
			for _, scatterBomb in ipairs(Isaac.FindByType(EntityType.ENTITY_BOMB)) do
				if scatterBomb.FrameCount == 0 then
					table.insert(BombsInRoom, GetPtrHash(scatterBomb))
				end
			end
		end

		local explosionRadius = Helpers.GetBombExplosionRadius(bomb)
        ---@diagnostic disable-next-line: param-type-mismatch
		if bomb:HasTearFlags(TearFlags.TEAR_GIGA_BOMB) then
			explosionRadius = 99999
		end
		DoBlankEffect(bomb.Position, explosionRadius)
	end
end
LostItemsPack:AddCallback(ModCallbacks.MC_POST_BOMB_UPDATE, BlankBombsMod.BombUpdate)


function BlankBombsMod:OnMonstroUpdate(monstro)
	if monstro:GetData().IsAbusedMonstro then

		SFXManager():Stop(SoundEffect.SOUND_FORESTBOSS_STOMPS)

		for _, effect in ipairs(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.POOF02)) do
			if effect.FrameCount == 0 then
				effect:Remove()
			end
		end

		monstro:Remove()
	end
end
LostItemsPack:AddCallback(ModCallbacks.MC_NPC_UPDATE, BlankBombsMod.OnMonstroUpdate, EntityType.ENTITY_MONSTRO)


---@param rocket EntityEffect
function BlankBombsMod:OnEpicFetusRocketUpdate(rocket)
	if rocket.Timeout ~= 0 then return end

	local ptrHash = GetPtrHash(rocket)

	local isGonnaExplode = false

	for i, otherPtr in ipairs(RocketsAboutToExplode) do
		if ptrHash == otherPtr then
			table.remove(RocketsAboutToExplode, i)
			isGonnaExplode = true
		end
	end

	if isGonnaExplode then
		DoBlankEffect(rocket.Position, 90)
	else
		table.insert(RocketsAboutToExplode, ptrHash)
	end
end
LostItemsPack:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, BlankBombsMod.OnEpicFetusRocketUpdate, EffectVariant.ROCKET)


---@param entity Entity
---@param source EntityRef
function BlankBombsMod:OnPlayerDamage(entity, _, _, source)
	local bomb = source.Entity
	if not IsBlankBomb(bomb) then return end

	local bombPlayer = Helpers.GetPlayerFromTear(bomb)
	local player = entity:ToPlayer()

    if not bombPlayer then return end

	if Helpers.GetPlayerIndex(player) == Helpers.GetPlayerIndex(bombPlayer) then
		return false
	end
end
LostItemsPack:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, BlankBombsMod.OnPlayerDamage, EntityType.ENTITY_PLAYER)


---@param player EntityPlayer
function BlankBombsMod:OnPlayerUpdate(player)
	if not player:GetData().AddNoKnockBackFlag then return end

	player:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK)

	player:GetData().AddNoKnockBackFlag = player:GetData().AddNoKnockBackFlag - 1

	if player:GetData().AddNoKnockBackFlag == 0 then
		player:GetData().AddNoKnockBackFlag = nil
	end
end
LostItemsPack:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, BlankBombsMod.OnPlayerUpdate)


---@param effect EntityEffect
function BlankBombsMod:OnBlankExplosionUpdate(effect)
	local spr = effect:GetSprite()

	if spr:IsFinished("Explode") then
		effect:Remove()
	end
end
LostItemsPack:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, BlankBombsMod.OnBlankExplosionUpdate, LostItemsPack.Entities.BLANK_BOMB_EXPLOSION.variant)


---@param locust EntityFamiliar
---@param collider Entity
function BlankBombsMod:OnLocustCollision(locust, collider)
	if locust.SubType ~= LostItemsPack.CollectibleType.BLANK_BOMBS then return end
	if collider.Type ~= EntityType.ENTITY_PROJECTILE then return end

	local projectile = collider:ToProjectile()

	if projectile:HasProjectileFlags(ProjectileFlags.ACID_GREEN) or
	projectile:HasProjectileFlags(ProjectileFlags.ACID_RED) or
	projectile:HasProjectileFlags(ProjectileFlags.CREEP_BROWN) or
	projectile:HasProjectileFlags(ProjectileFlags.EXPLODE) or
	projectile:HasProjectileFlags(ProjectileFlags.BURST) or
	projectile:HasProjectileFlags(ProjectileFlags.ACID_GREEN) then
		--If the projectile has any flag that triggers on hit, we need to remove the projectile
		projectile:Remove()
	else
		projectile:Die()
	end
end
LostItemsPack:AddCallback(ModCallbacks.MC_PRE_FAMILIAR_COLLISION, BlankBombsMod.OnLocustCollision, FamiliarVariant.ABYSS_LOCUST)