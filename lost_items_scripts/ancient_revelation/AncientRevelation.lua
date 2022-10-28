local AncientRevelation = {}

function AncientRevelation:OnPlayerInit(player)
    local data = player:GetData()
	data.AncientCount = player:GetCollectibleNum(LostItemsPack.CollectibleType.ANCIENT_REVELATION)
end
LostItemsPack:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, AncientRevelation.OnPlayerInit)

local function tearsUp(firedelay, val)
    local currentTears = 30 / (firedelay + 1)
    local newTears = currentTears + val
    return math.max((30 / newTears) - 1, -0.75)
end

function AncientRevelation:EvaluateCache(player, cacheFlag)
	for _ = 1, player:GetCollectibleNum(LostItemsPack.CollectibleType.ANCIENT_REVELATION) do
		if cacheFlag == CacheFlag.CACHE_FIREDELAY then
			player.MaxFireDelay = tearsUp(player.MaxFireDelay, 1)
		elseif cacheFlag == CacheFlag.CACHE_SHOTSPEED then
			player.ShotSpeed = player.ShotSpeed + 0.48
		elseif cacheFlag == CacheFlag.CACHE_FLYING then
			player.CanFly = true
		elseif cacheFlag == CacheFlag.CACHE_TEARCOLOR then
			player.TearColor = Color(player.TearColor.R, player.TearColor.G, player.TearColor.B, player.TearColor.A, 260/255, 250/255, 40/255)
			player.LaserColor = Color(player.LaserColor.R, player.LaserColor.G, player.LaserColor.B, player.LaserColor.A, 260/255, 250/255, 40/255)
		elseif cacheFlag == CacheFlag.CACHE_TEARFLAG then
			player.TearFlags = player.TearFlags | TearFlags.TEAR_SPECTRAL
			player.TearFlags = player.TearFlags | TearFlags.TEAR_TURN_HORIZONTAL
		end
	end
end
LostItemsPack:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, AncientRevelation.EvaluateCache)


function AncientRevelation:postPlayerUpdate(player)
	if not ComplianceImmortal then return end
	if player.Parent ~= nil then return end
	local data = player:GetData()
	if not data.lastSoulHearts then
		data.lastSoulHearts = 0
	end
	if player:GetPlayerType() == PlayerType.PLAYER_THESOUL_B then
		player = player:GetMainTwin()
	end
	if player:GetPlayerType() == PlayerType.PLAYER_THEFORGOTTEN then
		player = player:GetSubPlayer()
	end

	if player:GetCollectibleNum(LostItemsPack.CollectibleType.ANCIENT_REVELATION) == data.AncientCount then
		data.lastSoulHearts = player:GetSoulHearts()
	end
	data.AncientCount = player:GetCollectibleNum(LostItemsPack.CollectibleType.ANCIENT_REVELATION)

	if player:GetSoulHearts() > data.lastSoulHearts then
		player:AddSoulHearts(-4)

		ComplianceImmortal.AddImmortalHearts(player, 4)
	end
end
LostItemsPack:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, AncientRevelation.postPlayerUpdate)


