IllusionMod = {} --For API
local IllusionModLocal = {} --For local functions, so other mods don't have access to these
local sfxManager = SFXManager()
local game = Game()
local hud = game:GetHUD()
local Helpers = require("lost_items_scripts.Helpers")


LostItemsPack.CallOnNewSaveData[#LostItemsPack.CallOnNewSaveData+1] = function ()
    LostItemsPack.RunPersistentData.IllusionClonesPlaceBombs = false
    LostItemsPack.RunPersistentData.IllusionHeartSpawnChance = 20
end

LostItemsPack.CallOnLoad[#LostItemsPack.CallOnLoad+1] = function ()
    LostItemsPack.PersistentData.IllusionPlayersData = {}
    LostItemsPack.PersistentData.IllusionFamiliarsData = {}
end


local TransformationItems = {
	[PlayerForm.PLAYERFORM_DRUGS] = Isaac.GetItemIdByName("Spun transform"),
	[PlayerForm.PLAYERFORM_MOM] = Isaac.GetItemIdByName("Mom transform"),
	[PlayerForm.PLAYERFORM_GUPPY] = Isaac.GetItemIdByName("Guppy transform"),
	[PlayerForm.PLAYERFORM_LORD_OF_THE_FLIES] = Isaac.GetItemIdByName("Fly transform"),
	[PlayerForm.PLAYERFORM_BOB] = Isaac.GetItemIdByName("Bob transform"),
	[PlayerForm.PLAYERFORM_MUSHROOM] = Isaac.GetItemIdByName("Mushroom transform"),
	[PlayerForm.PLAYERFORM_BABY] = Isaac.GetItemIdByName("Baby transform"),
	[PlayerForm.PLAYERFORM_ANGEL] = Isaac.GetItemIdByName("Angel transform"),
	[PlayerForm.PLAYERFORM_EVIL_ANGEL] = Isaac.GetItemIdByName("Devil transform"),
	[PlayerForm.PLAYERFORM_POOP] = Isaac.GetItemIdByName("Poop transform"),
	[PlayerForm.PLAYERFORM_BOOK_WORM] = Isaac.GetItemIdByName("Book transform"),
	[PlayerForm.PLAYERFORM_SPIDERBABY] = Isaac.GetItemIdByName("Spider transform"),
}

local ForbiddenItems = {
	CollectibleType.COLLECTIBLE_1UP,
	CollectibleType.COLLECTIBLE_DEAD_CAT,
	CollectibleType.COLLECTIBLE_INNER_CHILD,
	CollectibleType.COLLECTIBLE_GUPPYS_COLLAR,
	CollectibleType.COLLECTIBLE_LAZARUS_RAGS,
	CollectibleType.COLLECTIBLE_ANKH,
	CollectibleType.COLLECTIBLE_JUDAS_SHADOW,
}

local ForbiddenPCombos = {
	{PlayerType = PlayerType.PLAYER_THELOST_B, Item = CollectibleType.COLLECTIBLE_BIRTHRIGHT},
}

function IllusionMod.AddForbiddenItem(i)
	table.insert(ForbiddenItems,i)
end

function IllusionMod.AddForbiddenCharItem(type, i)
	table.insert(ForbiddenPCombos,{PlayerType = type, Item = i})
end


local function BlackList(collectible)
	for _,i in ipairs(ForbiddenItems) do
		if i == collectible then
			return true
		end
	end
	return false
end

local function CanBeRevived(pType,withItem)
	for _,v in ipairs(ForbiddenPCombos) do
		if v.PlayerType == pType and v.Item == withItem then
			return true
		end
	end
	return false
end


function IllusionMod:GetIllusionData(entity,forgottenB)
    if not entity then return end

	forgottenB = forgottenB or false

    local data
    local index

    if entity.Type == EntityType.ENTITY_PLAYER then
        local player = entity:ToPlayer()
        if player:GetPlayerType() == PlayerType.PLAYER_THESOUL_B and forgottenB then
            player = player:GetOtherTwin()
        end

        index = Helpers.GetPlayerIndex(player)
        data = LostItemsPack.PersistentData.IllusionPlayersData
    elseif entity.Type == EntityType.ENTITY_FAMILIAR then
        index = entity:ToFamiliar().InitSeed
        data = LostItemsPack.PersistentData.IllusionFamiliarsData
    end

    if not data then return end

    for _, value in ipairs(data) do
        if value.index == index then
            return value.data
        end
    end

    data[#data+1] = {index = index, data = {}}

    return data[#data].data
end

local function RemoveIllusionData(entity, forgottenB)
    if not entity then return end

	forgottenB = forgottenB or false

    local data
    local index

    if entity.Type == EntityType.ENTITY_PLAYER then
        local player = entity:ToPlayer()
        if player:GetPlayerType() == PlayerType.PLAYER_THESOUL_B and forgottenB then
            player = player:GetOtherTwin()
        end

        index = Helpers.GetPlayerIndex(player)
        data = LostItemsPack.PersistentData.IllusionPlayersData
    elseif entity.Type == EntityType.ENTITY_FAMILIAR then
        index = entity:ToFamiliar().InitSeed
        data = LostItemsPack.PersistentData.IllusionFamiliarsData
    end

    for i, value in ipairs(data) do
        if value.index == index then
            table.remove(data, i)
        end
    end
end

function IllusionModLocal:UpdateClones(p)
	local data = IllusionMod:GetIllusionData(p)
    if not data then return end
	if data.IsIllusion then
		if p:IsDead()  then
			--p.Visible = false
			if p:GetPlayerType() ~= PlayerType.PLAYER_THELOST and p:GetPlayerType() ~= PlayerType.PLAYER_THELOST_B 
			and p:GetPlayerType() ~= PlayerType.PLAYER_THESOUL_B then
				p:GetSprite():SetLayerFrame(PlayerSpriteLayer.SPRITE_GHOST,0)
			end
			if p:GetSprite():IsFinished("Death") or p:GetSprite():IsFinished("ForgottenDeath") then
				p:GetSprite():SetFrame(70)
				if p:GetPlayerType() ~= PlayerType.PLAYER_THELOST and p:GetPlayerType() ~= PlayerType.PLAYER_THELOST_B and
				p:GetPlayerType() ~= PlayerType.PLAYER_THESOUL and p:GetPlayerType() ~= PlayerType.PLAYER_THESOUL_B  and p:GetPlayerType() ~= PlayerType.PLAYER_THEFORGOTTEN_B
				and not p:GetEffects():HasNullEffect(NullItemID.ID_LOST_CURSE) then
					p:ChangePlayerType(PlayerType.PLAYER_THELOST)
					local offset = (p:GetPlayerType() ~= PlayerType.PLAYER_THEFORGOTTEN or p:GetPlayerType() ~= PlayerType.PLAYER_THEFORGOTTEN_B) and Vector(30 * p.SpriteScale.X,0) or Vector.Zero
                    ---@diagnostic disable-next-line: param-type-mismatch
					local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, -1, p.Position + offset, Vector.Zero, p)
					local sColor = poof:GetSprite().Color
					local color = Color(sColor.R, sColor.G, sColor.B, 0.7, 0.518, 0.15, 0.8)
					local s = poof:GetSprite()
					s.Color = color
					sfxManager:Play(SoundEffect.SOUND_BLACK_POOF)
				end
			end
		end
		if not p:IsDead() then
			if p.Parent and (not p.Parent:Exists() or p.Parent:IsDead()) then
				p:Die()
				p:AddMaxHearts(-p:GetMaxHearts())
				p:AddSoulHearts(-p:GetSoulHearts())
				p:AddBoneHearts(-p:GetBoneHearts())
				p:AddGoldenHearts(-p:GetGoldenHearts())
				p:AddEternalHearts(-p:GetEternalHearts())
				p:AddHearts(-p:GetHearts())
				--Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, -1, p.Position, Vector.Zero, p)
			end
		end
		p:GetEffects():RemoveCollectibleEffect(CollectibleType.COLLECTIBLE_HOLY_MANTLE)
	end
end
LostItemsPack:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, IllusionModLocal.UpdateClones)

function IllusionModLocal:CloneRoomUpdate()
	for i = 0, game:GetNumPlayers()-1 do
		local p = Isaac.GetPlayer(i)
		local data = IllusionMod:GetIllusionData(p)
        if not data then return end
		if data.IsIllusion and p:IsDead() then
			p:GetSprite():SetFrame(70)
			p:ChangePlayerType(PlayerType.PLAYER_THELOST)
			Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, -1, p.Position, Vector.Zero, p)
		end
	end
end
LostItemsPack:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, IllusionModLocal.CloneRoomUpdate)

function IllusionMod:addIllusion(player, isIllusion)
	local id = game:GetNumPlayers() - 1
	local playerType = player:GetPlayerType()
	if playerType == PlayerType.PLAYER_JACOB then
		player = player:GetOtherTwin()
		playerType = PlayerType.PLAYER_ESAU
	end
	if playerType == PlayerType.PLAYER_THESOUL_B then
		playerType = PlayerType.PLAYER_THEFORGOTTEN_B
	end
	if playerType == PlayerType.PLAYER_THESOUL then
		playerType = PlayerType.PLAYER_THEFORGOTTEN
	end
	Isaac.ExecuteCommand('addplayer 15 '..player.ControllerIndex)
	local _p = Isaac.GetPlayer(id + 1)
	local d = IllusionMod:GetIllusionData(_p)
    if not d then return end
	if playerType == PlayerType.PLAYER_LAZARUS_B or playerType == PlayerType.PLAYER_LAZARUS2_B then
		_p:ChangePlayerType(0)
		if playerType == PlayerType.PLAYER_LAZARUS_B then
			d.TaintedLazA = true
		else
			d.TaintedLazB = true
		end
		local costume = playerType == PlayerType.PLAYER_LAZARUS_B and NullItemID.ID_LAZARUS_B or NullItemID.ID_LAZARUS2_B
		_p:AddNullCostume(costume)
	else
		_p:ChangePlayerType(playerType)
	end
	if isIllusion then
		_p.Parent = player
		hud:AssignPlayerHUDs()
		
		for i=1, Isaac.GetItemConfig():GetCollectibles().Size - 1 do
			if not BlackList(i) and not CanBeRevived(playerType,i) then
				local itemConfig = Isaac.GetItemConfig()
				local itemCollectible = itemConfig:GetCollectible(i)
				if itemCollectible then
                    ---@diagnostic disable-next-line: param-type-mismatch
					if not _p:HasCollectible(i) and player:HasCollectible(i) and itemCollectible.Tags & ItemConfig.TAG_QUEST ~= ItemConfig.TAG_QUEST then
						if itemCollectible.Type ~= ItemType.ITEM_ACTIVE then
							for j=1, player:GetCollectibleNum(i) do
                                ---@diagnostic disable-next-line: param-type-mismatch
								_p:AddCollectible(i,0,false)
							end
						end
					end
				end
			end
		end
		for i = 2, 0, -1 do
            ---@diagnostic disable-next-line: param-type-mismatch
			local c = _p:GetActiveItem(i)
			if c > 0 then
                ---@diagnostic disable-next-line: param-type-mismatch
				_p:RemoveCollectible(c,false,i)
			end
		end

		for transformation, transformationItem in pairs(TransformationItems) do
			if player:HasPlayerForm(transformation) then
				for _ = 1, 3, 1 do
					_p:AddCollectible(transformationItem)
				end
			end
		end
		
		_p:AddMaxHearts(-_p:GetMaxHearts())
		_p:AddSoulHearts(-_p:GetSoulHearts())
		_p:AddBoneHearts(-_p:GetBoneHearts())
		_p:AddGoldenHearts(-_p:GetGoldenHearts())
		_p:AddEternalHearts(-_p:GetEternalHearts())
		_p:AddHearts(-_p:GetHearts())

		_p:AddMaxHearts(2)
		_p:AddHearts(2)

		d.IsIllusion = true
		if playerType == PlayerType.PLAYER_THEFORGOTTEN_B then
			local dl = IllusionMod:GetIllusionData(_p:GetOtherTwin())
            if not dl then return end
			dl.IsIllusion = true
			_p:GetOtherTwin().Parent = player:GetOtherTwin()
		end
		local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, -1, _p.Position, Vector.Zero, _p)

		local sColor = poof:GetSprite().Color
		local color = Color(sColor.R, sColor.G, sColor.B, 0.7, 0.518, 0.15, 0.8)
		local s = poof:GetSprite()
		s.Color = color
	end
	_p:PlayExtraAnimation("Appear")
	_p:AddCacheFlags(CacheFlag.CACHE_ALL)
	_p:EvaluateItems()
	return _p
end

function IllusionModLocal:CloneCache(p, _)
	local d = IllusionMod:GetIllusionData(p)
    if not d then return end
	if d.IsIllusion then
		--local color = Color(0.518, 0.22, 1, 0.45)
		local sColor = p:GetSprite().Color
		local color = Color(sColor.R, sColor.G, sColor.B, 0.45,0.518, 0.15, 0.8)
		local s = p:GetSprite()
		s.Color = color
	else
		d = nil
	end
end
LostItemsPack:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, IllusionModLocal.CloneCache)

function IllusionModLocal:HackyLazWorkAround(player,cache)
	local d = IllusionMod:GetIllusionData(player)
    if not d then return end
	if d.IsIllusion then
		if d.TaintedLazA == true then
			if cache == CacheFlag.CACHE_RANGE then
				player.TearRange = player.TearRange - 80
			end
		elseif d.TaintedLazB == true then
			if cache == CacheFlag.CACHE_DAMAGE then
				player.Damage = player.Damage * 1.50
			elseif cache == CacheFlag.CACHE_FIREDELAY then
				player.MaxFireDelay = player.MaxFireDelay + 1
			elseif cache == CacheFlag.CACHE_SPEED then
				player.MoveSpeed = player.MoveSpeed - 0.1
			elseif cache == CacheFlag.CACHE_LUCK then
				player.Luck = player.Luck - 2
			end
		end
	end
end
LostItemsPack:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, IllusionModLocal.HackyLazWorkAround)

function IllusionModLocal:preIllusionHeartPickup(pickup, collider)
	local player = collider:ToPlayer()
	if player then
		local d = IllusionMod:GetIllusionData(player)
        if not d then return end
		if d.IsIllusion or player.Parent then
			return d.IsIllusion and true or pickup:IsShopItem()
		else
			d = nil
		end
		if pickup.Variant == PickupVariant.PICKUP_HEART and pickup.SubType == LostItemsPack.Entities.ILLUSION_HEART.subtype then
			pickup.Velocity = Vector.Zero
			pickup.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
			pickup:GetSprite():Play("Collect", true)
			pickup:Die()
			IllusionMod:addIllusion(player, true)
			sfxManager:Play(LostItemsPack.SFX.PICKUP_ILLUSION,1,0,false)
			return true
		end
	end
end
LostItemsPack:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, IllusionModLocal.preIllusionHeartPickup)

function IllusionModLocal:preIllusionWhiteFlame(p, collider)
	if collider.Type == EntityType.ENTITY_FIREPLACE and collider.Variant == 4 then
		local d = IllusionMod:GetIllusionData(p)
        if not d then return end
		if d.IsIllusion or p.Parent then
			p:Kill()
			p:AddMaxHearts(-p:GetMaxHearts())
			p:AddSoulHearts(-p:GetSoulHearts())
			p:AddBoneHearts(-p:GetBoneHearts())
			p:AddGoldenHearts(-p:GetGoldenHearts())
			p:AddEternalHearts(-p:GetEternalHearts())
			p:AddHearts(-p:GetHearts())
		end
	end
end
LostItemsPack:AddCallback(ModCallbacks.MC_PRE_PLAYER_COLLISION, IllusionModLocal.preIllusionWhiteFlame)

function IllusionModLocal:postPickupInit(pickup)
	local rng = pickup:GetDropRNG()
	if pickup.SubType == HeartSubType.HEART_GOLDEN and pickup:GetSprite():GetAnimation() == "Appear" then
		if rng:RandomFloat() > (1 - LostItemsPack.RunPersistentData.IllusionHeartSpawnChance*0.01) then
			pickup:Morph(pickup.Type, pickup.Variant, LostItemsPack.Entities.ILLUSION_HEART.subtype)
		end
	end
end
LostItemsPack:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, IllusionModLocal.postPickupInit, PickupVariant.PICKUP_HEART)

function IllusionModLocal:onUseBookOfIllusions(_, _, player, flags)
	if GiantBookAPI then
		GiantBookAPI.playGiantBook("Appear", "Illusions.png", Color(0.2, 0.1, 0.3, 1, 0, 0, 0), Color(0.117, 0.0117, 0.2, 1, 0, 0, 0), Color(0, 0, 0, 0.8, 0, 0, 0), SoundEffect.SOUND_BOOK_PAGE_TURN_12)
	end
	sfxManager:Play(SoundEffect.SOUND_BOOK_PAGE_TURN_12, 1, 0, false, 1)

	IllusionMod:addIllusion(player, true)

	-- returning any values interrupts any callbacks that come after it
	if flags & UseFlag.USE_NOANIM == 0 then
		player:AnimateCollectible(LostItemsPack.CollectibleType.BOOK_OF_ILLUSIONS, "UseItem", "PlayerPickupSparkle")
	end
end
LostItemsPack:AddCallback(ModCallbacks.MC_USE_ITEM, IllusionModLocal.onUseBookOfIllusions, LostItemsPack.CollectibleType.BOOK_OF_ILLUSIONS)

function IllusionModLocal:onEntityTakeDamage(tookDamage)
	local data = IllusionMod:GetIllusionData(tookDamage)
    if not data then return end
	if data.IsIllusion then
        tookDamage:Kill() --doples always die in one hit, so the hud looks nicer. ideally i'd just get rid of the hud but that doesnt seem possible
        local p = tookDamage:ToPlayer()
        p:AddMaxHearts(-p:GetMaxHearts())
        p:AddSoulHearts(-p:GetSoulHearts())
        p:AddBoneHearts(-p:GetBoneHearts())
        p:AddGoldenHearts(-p:GetGoldenHearts())
        p:AddEternalHearts(-p:GetEternalHearts())
        p:AddHearts(-p:GetHearts())
	else
		RemoveIllusionData(tookDamage)
	end
end
LostItemsPack:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, IllusionModLocal.onEntityTakeDamage, EntityType.ENTITY_PLAYER)

function IllusionModLocal:AfterDeath(e)
	if e.Type == EntityType.ENTITY_PLAYER then
	    RemoveIllusionData(e)
	end
end
LostItemsPack:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, IllusionModLocal.AfterDeath)

function IllusionModLocal:DarkEsau(e)
	if e.SpawnerEntity and e.SpawnerEntity:ToPlayer() then
		local p = e.SpawnerEntity:ToPlayer()
		local d = IllusionMod:GetIllusionData(p)
        if not d then return end
		if d.IsIllusion then
			local s = e:GetSprite().Color
			local color = Color(s.R, s.G, s.B, 0.45,0.518, 0.15, 0.8)
			local s = e:GetSprite()
			s.Color = color
		end
	end
end
LostItemsPack:AddCallback(ModCallbacks.MC_POST_NPC_RENDER, IllusionModLocal.DarkEsau, EntityType.ENTITY_DARK_ESAU)

function IllusionModLocal:ClonesControls(entity,hook,action)
	if entity ~= nil and entity.Type == EntityType.ENTITY_PLAYER and not LostItemsPack.RunPersistentData.IllusionClonesPlaceBombs then
		local p = entity:ToPlayer()
		local d = IllusionMod:GetIllusionData(p)
        if not d then return end
		if d.IsIllusion then
			if (hook == InputHook.GET_ACTION_VALUE or hook == InputHook.IS_ACTION_PRESSED) and p:GetSprite():IsPlaying("Appear") then
				return hook == InputHook.GET_ACTION_VALUE and 0 or false
			end
			if hook == InputHook.IS_ACTION_TRIGGERED and (action == ButtonAction.ACTION_BOMB or action == ButtonAction.ACTION_PILLCARD or
			action == ButtonAction.ACTION_ITEM or p:GetSprite():IsPlaying("Appear")) then
				return false
			end
		end
	end
end
LostItemsPack:AddCallback(ModCallbacks.MC_INPUT_ACTION, IllusionModLocal.ClonesControls)
