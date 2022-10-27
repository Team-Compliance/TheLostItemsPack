PillCrusher = {}
local PillCrusherLocal = {} --So all the callback functions are not in a global
local mod = LostItemsPack
local Helpers = require("lost_items_scripts.Helpers")

LostItemsPack.CallOnLoad[#LostItemsPack.CallOnLoad+1] = function ()
	LostItemsPack.PersistentData.LastPillUsed = -1
	LostItemsPack.PersistentData.MonsterTeleTable = {}
	LostItemsPack.PersistentData.HPUpDownEnemies = {}
end

local BloomAmount = 0
local blurspeed = 0.07
local ActivateBloom = false

--FF Helpers
mod.FFPillColours = {
    --Normal
    101,102,103,104,105,106,107,108,109,110,
    111,112,113,114,115,116,117,118,119,120,
    --Horse
    2149,2150,2151,2152,2153,2154,2155,2156,2157,2158,
    2159,2160,2161,2162,2163,2164,2165,2166,2167,2168
}
--Just lets you pass isFFPill[101] or somethin to test it
local isFFPill = {}
do
    for i = 1, #mod.FFPillColours do
        isFFPill[mod.FFPillColours[i]] = true
    end
end


--API
local CrushedPillEffects = {}
local CrushedPillsRoom = {}

---@param pillEffect PillEffect
---@param name string
---@param func fun(player: EntityPlayer, rng: RNG, isGolden: boolean, isHorse: boolean, pillColor: PillColor)?
function PillCrusher:AddPillCrusherEffect(pillEffect, name, func)
	if not func then
		func = function () end
	end
	CrushedPillEffects[pillEffect] = {name = name, func = func}
end


---@param pillEffect PillEffect
---@return boolean
function PillCrusher:HasCrushedPill(pillEffect)
	return CrushedPillsRoom[pillEffect] ~= nil
end


---@param pillEffect PillEffect
---@return integer
function PillCrusher:GetCrushedPillNum(pillEffect)
	local num = CrushedPillsRoom[pillEffect]
	if not num then num = 0 end
	return num
end


function PillCrusher:ResetCrushedPillPerRoom()
	CrushedPillsRoom = {}
end
LostItemsPack:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, PillCrusher.ResetCrushedPillPerRoom)


local function GetRandomPillCrusherEffect(rng)
	local pillEffects = {}

	for pillEffect, _ in pairs(CrushedPillEffects) do
		table.insert(pillEffects, pillEffect)
	end

	local chosenPill = pillEffects[rng:RandomInt(#pillEffects) + 1]

	return {CrushedPillEffects[chosenPill], chosenPill}
end

--Vanilla pill effects
require("lost_items_scripts.pill_crusher.pill_effects.48HourEnergy")
require("lost_items_scripts.pill_crusher.pill_effects.Addicted")
require("lost_items_scripts.pill_crusher.pill_effects.Amnesia")
require("lost_items_scripts.pill_crusher.pill_effects.BadGas")
require("lost_items_scripts.pill_crusher.pill_effects.BadTrip")
require("lost_items_scripts.pill_crusher.pill_effects.BallsOfSteel")
require("lost_items_scripts.pill_crusher.pill_effects.BombsAreKeys")
require("lost_items_scripts.pill_crusher.pill_effects.ExplosiveDiarrhea")
require("lost_items_scripts.pill_crusher.pill_effects.FriendsTillTheEnd")
require("lost_items_scripts.pill_crusher.pill_effects.FullHealth")
require("lost_items_scripts.pill_crusher.pill_effects.Gulp")
require("lost_items_scripts.pill_crusher.pill_effects.HealthDown")
require("lost_items_scripts.pill_crusher.pill_effects.HealthUp")
require("lost_items_scripts.pill_crusher.pill_effects.Hematemesis")
require("lost_items_scripts.pill_crusher.pill_effects.Horf")
require("lost_items_scripts.pill_crusher.pill_effects.IFoundPills")
require("lost_items_scripts.pill_crusher.pill_effects.ImDrowsy")
require("lost_items_scripts.pill_crusher.pill_effects.ImExcited")
require("lost_items_scripts.pill_crusher.pill_effects.InfestedExclamation")
require("lost_items_scripts.pill_crusher.pill_effects.InfestedQuestion")
require("lost_items_scripts.pill_crusher.pill_effects.Larger")
require("lost_items_scripts.pill_crusher.pill_effects.LemonParty")
require("lost_items_scripts.pill_crusher.pill_effects.LuckDown")
require("lost_items_scripts.pill_crusher.pill_effects.LuckUp")
require("lost_items_scripts.pill_crusher.pill_effects.Paralysis")
require("lost_items_scripts.pill_crusher.pill_effects.Percs")
require("lost_items_scripts.pill_crusher.pill_effects.Pheromones")
require("lost_items_scripts.pill_crusher.pill_effects.PowerPill")
require("lost_items_scripts.pill_crusher.pill_effects.PrettyFly")
require("lost_items_scripts.pill_crusher.pill_effects.Puberty")
require("lost_items_scripts.pill_crusher.pill_effects.QuestionMark")
require("lost_items_scripts.pill_crusher.pill_effects.RangeDown")
require("lost_items_scripts.pill_crusher.pill_effects.RangeUp")
require("lost_items_scripts.pill_crusher.pill_effects.Relax")
require("lost_items_scripts.pill_crusher.pill_effects.RetroVision")
require("lost_items_scripts.pill_crusher.pill_effects.RUAWizard")
require("lost_items_scripts.pill_crusher.pill_effects.SeeForever")
require("lost_items_scripts.pill_crusher.pill_effects.ShotSpeedDown")
require("lost_items_scripts.pill_crusher.pill_effects.ShotSpeedUp")
require("lost_items_scripts.pill_crusher.pill_effects.Smaller")
require("lost_items_scripts.pill_crusher.pill_effects.SomethingsWrong")
require("lost_items_scripts.pill_crusher.pill_effects.SpeedDown")
require("lost_items_scripts.pill_crusher.pill_effects.SpeedUp")
require("lost_items_scripts.pill_crusher.pill_effects.Sunshine")
require("lost_items_scripts.pill_crusher.pill_effects.TearsDown")
require("lost_items_scripts.pill_crusher.pill_effects.TearsUp")
require("lost_items_scripts.pill_crusher.pill_effects.Telepills")
require("lost_items_scripts.pill_crusher.pill_effects.Vurp")
require("lost_items_scripts.pill_crusher.pill_effects.XLax")

--Main mod
local function Lerp(a, b, t)
	return a + (b-a) * 0.2 * t
end


function PillCrusherLocal:BloomShader(shader)
	if shader == "PillCrusherBloom" then
		local params = {
			BloomAmount = BloomAmount,
			Ratio = {BloomAmount /3, BloomAmount / 2}
		}
		if ActivateBloom == true then
			if BloomAmount >= 2.1 then
				ActivateBloom = false
				blurspeed = 0.01
			else
				BloomAmount = BloomAmount + blurspeed
				blurspeed = Lerp(blurspeed, 0.01, 0.06)
			end
		elseif BloomAmount > 0.1 then
			BloomAmount = BloomAmount - blurspeed
			blurspeed = Lerp(blurspeed, 0.2, 0.08)
		elseif BloomAmount < 0.1 then
			BloomAmount = 0
			blurspeed = 0.07
		end
		return params
	end
end
mod:AddCallback(ModCallbacks.MC_GET_SHADER_PARAMS, PillCrusherLocal.BloomShader)


---@param rng RNG
---@param player EntityPlayer
function PillCrusherLocal:UsePillCrusher(_, rng, player)
	local truePillColor = player:GetPill(0)
	if truePillColor == 0 then return end

	local pillColorToCheckEffect = truePillColor
	local itemPool = Game():GetItemPool()
	local pillEffect = itemPool:GetPillEffect(pillColorToCheckEffect, player)

	--Fiend folio compatibility bs (ffs why wouldn't they just make it an api)
	if FiendFolio then
		if isFFPill[truePillColor] then
			if truePillColor > PillColor.PILL_GIANT_FLAG then
				pillColorToCheckEffect = FiendFolio.savedata.run.PillCopies[tostring(truePillColor-PillColor.PILL_GIANT_FLAG)]
				pillEffect = itemPool:GetPillEffect(pillColorToCheckEffect, player)
				--FiendFolio.savedata.run.IdentifiedRunPills[tostring(pillColorToCheckEffect)] = true
			else
				pillColorToCheckEffect = FiendFolio.savedata.run.PillCopies[tostring(truePillColor)]
				pillEffect = itemPool:GetPillEffect(pillColorToCheckEffect, player)
				--FiendFolio.savedata.run.IdentifiedRunPills[tostring(pillColorToCheckEffect)] = true
			end
		end
	end

	local showName = itemPool:IsPillIdentified(pillColorToCheckEffect)

	if pillEffect == PillEffect.PILLEFFECT_VURP and LostItemsPack.PersistentData.LastPillUsed >= 0 then
		pillEffect = LostItemsPack.PersistentData.LastPillUsed
		LostItemsPack.PersistentData.LastPillUsed = PillEffect.PILLEFFECT_VURP
	else
		LostItemsPack.PersistentData.LastPillUsed = pillEffect
	end

	local crushedPillEffect = CrushedPillEffects[pillEffect]

	local isGolden = truePillColor == PillColor.PILL_GOLD or truePillColor == (PillColor.PILL_GOLD | PillColor.PILL_GIANT_FLAG)
	local isHorse = truePillColor & PillColor.PILL_GIANT_FLAG == PillColor.PILL_GIANT_FLAG

	if isGolden or pillEffect == PillEffect.PILLEFFECT_EXPERIMENTAL then
		crushedPillEffect, pillEffect = table.unpack(GetRandomPillCrusherEffect(rng))
	end

	local name
	if not crushedPillEffect then
		name = Isaac.GetItemConfig():GetPillEffect(pillEffect).Name
	else
		if pillEffect == PillEffect.PILLEFFECT_EXPERIMENTAL then
			name = "Experimental Treatment"
		else
			name = crushedPillEffect.name
		end

		crushedPillEffect.func(player, rng, isGolden, isHorse, truePillColor)
	end

	local mult = isHorse and 2 or 1
	if CrushedPillsRoom[pillEffect] then
		CrushedPillsRoom[pillEffect] = CrushedPillsRoom[pillEffect] + 1 * mult
	else
		CrushedPillsRoom[pillEffect] = 1 * mult
	end

	if isHorse then
		SFXManager():Play(SoundEffect.SOUND_BONE_SNAP)
	else
		SFXManager():Play(SoundEffect.SOUND_BONE_BREAK)
	end

	if showName then
		Game():GetHUD():ShowItemText(name, "")
	end
	local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, player.Position, Vector.Zero, nil)
	poof.Color = Color(1, 1, 1, 1, 0.5, 0.5, 0.5)
	poof.SpriteScale = Vector(0.6, 0.6)
	ActivateBloom = true

	if not isGolden or rng:RandomInt(100) < 10 then
		player:SetPill(0, 0)

		if player:HasTrinket(TrinketType.TRINKET_ENDLESS_NAMELESS) and rng:RandomInt(100) < 25 then
			local spawningPos = Game():GetRoom():FindFreePickupSpawnPosition(player.Position, 1, true)
			Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_PILL, truePillColor, spawningPos, Vector.Zero, nil)
		end
	end

	local pillCrushingAnim = Sprite()
	pillCrushingAnim:Load("gfx/pillcrusher_active_anim.anm2", true)
	pillCrushingAnim:Play("Idle", true)

	player:AnimatePickup(pillCrushingAnim)
end
mod:AddCallback(ModCallbacks.MC_USE_ITEM, PillCrusherLocal.UsePillCrusher, LostItemsPack.CollectibleType.PILL_CRUSHER)


function PillCrusherLocal:AddPill(player)
    local data = Helpers.GetData(player)
	if not data then return end

    data.pilldrop = data.pilldrop or player:GetCollectibleNum(LostItemsPack.CollectibleType.PILL_CRUSHER)

    if data.pilldrop < player:GetCollectibleNum(LostItemsPack.CollectibleType.PILL_CRUSHER) then
		local room = Game():GetRoom()
		local spawningPos = room:FindFreePickupSpawnPosition(player.Position, 1, true)
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_PILL, 0, spawningPos, Vector.Zero, player):ToPickup()
        data.pilldrop = player:GetCollectibleNum(LostItemsPack.CollectibleType.PILL_CRUSHER)
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, PillCrusherLocal.AddPill)


function PillCrusherLocal:spawnPill(rng, pos)
	local room = Game():GetRoom()
	local spawnposition = room:FindFreePickupSpawnPosition(pos)
	local spawned = false
	for i=0, Game():GetNumPlayers()-1 do
		local player = Isaac.GetPlayer(i)
		if player:HasCollectible(LostItemsPack.CollectibleType.PILL_CRUSHER) and rng:RandomInt(100) < 15 and not spawned then
			local pill = Isaac.Spawn(5, 70, 0, spawnposition, Vector.Zero, player)
			if player:HasCollectible(CollectibleType.COLLECTIBLE_CONTRACT_FROM_BELOW) then
				Isaac.Spawn(5, 70, pill.SubType, spawnposition, Vector.Zero, player)
			end
			spawned = true
		end
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, PillCrusherLocal.spawnPill)


function PillCrusherLocal:item_effect()
	for i=0, Game():GetNumPlayers()-1 do
		local player = Isaac.GetPlayer(i)
		local rng = player:GetCollectibleRNG(LostItemsPack.CollectibleType.PILL_CRUSHER)
		if player:HasCollectible(LostItemsPack.CollectibleType.PILL_CRUSHER) == true and Game():IsGreedMode() == true then
			Isaac.Spawn(5, 70, 0, player.Position, Vector.FromAngle(mod:GetRandomNumber(0, 360, rng)):Resized(3), player)
			Isaac.Spawn(5, 70, 0, player.Position, Vector.FromAngle(mod:GetRandomNumber(0, 360, rng)):Resized(3), player)
			Isaac.Spawn(5, 70, 0, player.Position, Vector.FromAngle(mod:GetRandomNumber(0, 360, rng)):Resized(3), player)
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, PillCrusherLocal.item_effect)


function PillCrusherLocal:DefaultWispInit(wisp)
	local player = wisp.Player
	if player:HasCollectible(LostItemsPack.CollectibleType.PILL_CRUSHER) then
		if wisp.SubType == LostItemsPack.CollectibleType.PILL_CRUSHER then
			--Wtf is this
			wisp.SubType = CollectibleType.COLLECTIBLE_MOMS_BOTTLE_PILLS
		end
	end
end
mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, PillCrusherLocal.DefaultWispInit, FamiliarVariant.WISP)