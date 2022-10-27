local Helpers = {}

local turretList = {{831,10,-1}, {835,10,-1}, {887,-1,-1}, {951,-1,-1}, {815,-1,-1}, {306,-1,-1}, {837,-1,-1}, {42,-1,-1}, {201,-1,-1}, 
{202,-1,-1}, {203,-1,-1}, {235,-1,-1}, {236,-1,-1}, {804,-1,-1}, {809,-1,-1}, {68,-1,-1}, {864,-1,-1}, {44,-1,-1}, {218,-1,-1}, {877,-1,-1},
{893,-1,-1}, {915,-1,-1}, {291,-1,-1}, {295,-1,-1}, {404,-1,-1}, {409,-1,-1}, {903,-1,-1}, {293,-1,-1}, {964,-1,-1},}


function Helpers.HereticBattle(enemy)
	local room = Game():GetRoom()
	if room:GetType() == RoomType.ROOM_BOSS and room:GetBossID() == 81 and enemy.Type == EntityType.ENTITY_EXORCIST then
		return true
	end
	return false
end


function Helpers.IsTurret(enemy)
	for _,e in ipairs(turretList) do
		if e[1] == enemy.Type and (e[2] == -1 or e[2] == enemy.Variant) and (e[3] == -1 or e[3] == enemy.SubType) then
			return true
		end
	end
	return false
end


---@param allEnemies boolean
---@param noBosses boolean | nil
---@return EntityNPC[]
function Helpers.GetEnemies(allEnemies, noBosses)
	local enemies = {}
	for _,enemy in ipairs(Isaac.GetRoomEntities()) do
		enemy = enemy:ToNPC()
		if enemy and (enemy:IsVulnerableEnemy() or allEnemies) and enemy:IsActiveEnemy() and enemy:IsEnemy() 
		and not EntityRef(enemy).IsFriendly then
			if not enemy:IsBoss() or (enemy:IsBoss() and not noBosses) then
				if enemy.Type == EntityType.ENTITY_ETERNALFLY then
					enemy:Morph(EntityType.ENTITY_ATTACKFLY,0,0,-1)
				end
				if not Helpers.HereticBattle(enemy) and not Helpers.IsTurret(enemy) and enemy.Type ~= EntityType.ENTITY_BLOOD_PUPPY then
					table.insert(enemies,enemy)
				end
			end
		end
	end
	return enemies
end


---@param entity Entity
---@return table
function Helpers.GetData(entity)
	local data = entity:GetData()
	if not data.LostItemsPack then
		data.LostItemsPack = {}
	end
	return data
end


---@param player EntityPlayer
---@return integer
function Helpers.GetPlayerIndex(player)
    return player:GetCollectibleRNG(1):GetSeed()
end


---@param item CollectibleType
---@return boolean
function Helpers.AnyPlayerHasItem(item)
    for i = 0, Game():GetNumPlayers(), 1 do
        local player = Game():GetPlayer(i)

        if player:HasCollectible(item) then
            return true
        end
    end

    return false
end


---@param enemy Entity
---@return boolean
function Helpers.IsTargetableEnemy(enemy)
    return enemy:IsEnemy() and enemy:IsVulnerableEnemy() and enemy:IsActiveEnemy() and
    not (enemy:IsBoss() or enemy.Type == EntityType.ENTITY_FIREPLACE or
    (enemy.Type == EntityType.ENTITY_EVIS and enemy.Variant == 10))
end


---@param player EntityPlayer
function Helpers.DoesPlayerHaveRightAmountOfPickups(player)
    local has7Coins = player:GetNumCoins() % 10 == 7
    local has7Keys = player:GetNumKeys() % 10 == 7
    local has7Bombs = player:GetNumBombs() % 10 == 7
    local has7Poops = player:GetPoopMana() % 10 == 7

    return has7Bombs or has7Coins or has7Keys or has7Poops
end


---@param player EntityPlayer
function Helpers.GetLuckySevenTearChance(player)
    local has7Coins = player:GetNumCoins() % 10 == 7
    local has7Keys = player:GetNumKeys() % 10 == 7
    local has7Bombs = player:GetNumBombs() % 10 == 7
    local has7Poops = player:GetPoopMana() % 10 == 7

    local chance = 0

    if has7Coins then chance = chance + 2 end
    if has7Keys then chance = chance + 2 end
    if has7Bombs then chance = chance + 2 end
    if has7Poops then chance = chance + 2 end

    chance = math.max(0, math.min(15, chance + player.Luck))

    local mult = player:HasTrinket(TrinketType.TRINKET_TEARDROP_CHARM) and 3 or 1

    return chance * mult
end


---@param enemy Entity
---@param player EntityPlayer
---@param rng RNG
function Helpers.TurnEnemyIntoGoldenMachine(enemy, player, rng)
    Game():ShakeScreen(7)
    SFXManager():Play(SoundEffect.SOUND_CASH_REGISTER)
    enemy:Remove()

    local machinesToUse = {}

    for _, luckySevenSlot in ipairs(LostItemsPack.LuckySevenSpecialSlots) do
        if luckySevenSlot:CanSpawn(player) then
            machinesToUse[#machinesToUse+1] = luckySevenSlot
        end
    end

    local chosenMachine = machinesToUse[rng:RandomInt(#machinesToUse)+1] or LostItemsPack.LuckySevenRegularSlot

    local luckySevenSlotEntity = Isaac.Spawn(EntityType.ENTITY_SLOT, LostItemsPack.Entities.LUCKY_SEVEN_SLOT.variant, 0, enemy.Position, Vector.Zero, nil)
    local data = Helpers.GetData(luckySevenSlotEntity)
    data.LuckySevenSlotObject = chosenMachine
    data.SlotTimeout = data.LuckySevenSlotObject.TIMEOUT
    data.SlotPlayer = player
    data.LuckySevenSlotObject:__Init(luckySevenSlotEntity)
    luckySevenSlotEntity:AddEntityFlags(EntityFlag.FLAG_NO_QUERY)

    LostItemsPack.LuckySevenSlotsInRoom[#LostItemsPack.LuckySevenSlotsInRoom+1] = luckySevenSlotEntity

    local sparkles = Isaac.Spawn(EntityType.ENTITY_EFFECT, LostItemsPack.Entities.LUCKY_SEVEN_MACHINE_SPARKLES.variant, 0, luckySevenSlotEntity.Position, Vector.Zero, luckySevenSlotEntity)
    sparkles.DepthOffset = 20
    data.MachineSparkles = sparkles

    local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, luckySevenSlotEntity.Position, Vector.Zero, luckySevenSlotEntity)

    luckySevenSlotEntity:SetColor(Color(1, 1, 1, 1, 1, 1, 117 / 255), 20, 1, true, false)
    poof.Color = Color(1, 1, 1, 1, 1, 1, 117 / 255)
end


---@param v1 Vector
---@param v2 Vector
---@return number
local function ScalarProduct(v1, v2)
    return v1.X * v2.X + v1.Y * v2.Y
end


---@param laser EntityLaser
---@param entity Entity
function Helpers.DoesLaserHitEntity(laser, entity)
    local targetSamples = {
        entity.Position,
        entity.Position + Vector(entity.Size * entity.SizeMulti.X, 0),
        entity.Position + Vector(-entity.Size * entity.SizeMulti.X, 0),
        entity.Position + Vector(0, entity.Size * entity.SizeMulti.Y),
        entity.Position + Vector(0, -entity.Size * entity.SizeMulti.Y),
    }
    ---@type VectorList
    ---@diagnostic disable-next-line: assign-type-mismatch
    local samplePoints = laser:GetSamples()
    local laserSize = laser.Size

    --From https://math.stackexchange.com/questions/190111/how-to-check-if-a-point-is-inside-a-rectangle
    for i = 0, samplePoints.Size-2, 1 do
        local point1 = samplePoints:Get(i)
        local point2 = samplePoints:Get(i+1)

        local side = (point1 - point2):Rotated(90):Resized(laserSize)

        local cornerA = point1 + side
        local cornerB = point2 + side
        local cornerD = point1 - side

        for _, targetPos in ipairs(targetSamples) do
            local AM = targetPos - cornerA
            local AB = cornerB - cornerA
            local AD = cornerD - cornerA
    
            local AMpAB = ScalarProduct(AM, AB)
            local ABpAB = ScalarProduct(AB, AB)
            local AMpAD = ScalarProduct(AM, AD)
            local ADpAD = ScalarProduct(AD, AD)
    
            if 0 < AMpAB and AMpAB < ABpAB and 0 < AMpAD and AMpAD < ADpAD then
                return true
            end
        end
    end
end


return Helpers