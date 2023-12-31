local OlLooper = {}
local Helpers = require("lost_items_scripts.Helpers")
OlLooper.ID = LostItemsPack.CollectibleType.OL_LOOPER
OlLooper.HEAD_HELPER = LostItemsPack.Entities.OL_LOOPER_HEAD_HELPER
OlLooper.NECK = LostItemsPack.Entities.OL_LOOPER_NECK

--The head can move without speed limitation within the free range.
--When it exits the free range it will be slowed (like forgotten's soul)
--until it reaches the allowed range.
OlLooper.HEAD_FREE_RANGE = 120
OlLooper.HEAD_ALLOWED_RANGE = 250
OlLooper.HEAD_VELOCITY = 8
OlLooper.HEAD_ACCEL = 0.3
OlLooper.HEAD_RETURN_VELOCITY = 0.07

OlLooper.NUM_NECK_PIECES = 10

OlLooper.CONTACT_DAMAGE_RANGE = 20
--Directly multiplies player's damage
OlLooper.CONTACT_DAMAGE_MULT = 1.5
--Deal damage every x frames
OlLooper.CONTACT_DAMAGE_FREQUENCY = 4


---@param player EntityPlayer
---@return Entity?
local function GetHeadHelper(player)
    ---@type EntityRef?
    local headHelper = Helpers.GetData(player).OlLooperHeadHelper

    if not headHelper then
        return
    end

    if not headHelper.Entity:Exists() then
        return
    end

    return headHelper.Entity
end


---@param player EntityPlayer
---@return Entity
local function CreateHeadHelper(player)
    local headHelper = Isaac.Spawn(
        OlLooper.HEAD_HELPER.type,
        OlLooper.HEAD_HELPER.variant,
        OlLooper.HEAD_HELPER.subtype,
        player.Position,
        Vector.Zero,
        player
    )
    headHelper:ClearEntityFlags(EntityFlag.FLAG_APPEAR)

    headHelper.DepthOffset = 10

    Helpers.GetData(player).OlLooperHeadHelper = EntityRef(headHelper)
    return headHelper
end


---@param player EntityPlayer
local function RemoveHeadHelper(player)
    local headHelper = GetHeadHelper(player)

    if headHelper then
        Helpers.GetData(player).OlLooperHeadHelper = nil
        headHelper:Remove()
    end
end


---@param player EntityPlayer
local function TrySpawnLight(player)
    local data = Helpers.GetData(player)
    ---@type EntityRef
    local lightRef = data.OlLooperLight

    if not lightRef or not lightRef.Entity or not lightRef.Entity:Exists() then
        local light = Isaac.Spawn(
            EntityType.ENTITY_EFFECT,
            EffectVariant.LIGHT,
            0,
            player.Position - player.PositionOffset,
            Vector.Zero,
            player
        ):ToEffect()
        light.Parent = player

        light.ParentOffset = -player.PositionOffset
        light:FollowParent(player)

        light:Update()
        light.Color = Color(1, 1, 1, 1, 1, 1, 1)
        light.SpriteScale = Vector(3, 3)

        data.OlLooperLight = EntityRef(light)
        lightRef = data.OlLooperLight
    end

    local light = lightRef.Entity:ToEffect()
    light.ParentOffset = -player.PositionOffset
end


---@param player EntityPlayer
---@return EntityEffect[]?
local function GetNeckPieces(player)
    ---@type EntityRef[]?
    local neck = Helpers.GetData(player).OlLooperNeckPieces

    if not neck then
        return
    end

    if #neck == 0 then
        return
    end

    if not neck[1].Entity:Exists() then
        return
    end

    local effects = {}
    for _, neckPiece in ipairs(neck) do
        effects[#effects+1] = neckPiece.Entity:ToEffect()
    end
    return effects
end


---@param player EntityPlayer
local function RemoveNeckPieces(player)
    local neckPieces = GetNeckPieces(player)
    if neckPieces then
        for _, neckPiece in ipairs(neckPieces) do
            neckPiece:Remove()
        end

        Helpers.GetData(player).OlLooperNeckPieces = nil
    end
end


---@param player EntityPlayer
---@return EntityEffect[]
local function CreateNeckPieces(player)
    RemoveNeckPieces(player)

    local entityRefs = {}
    local effects = {}

    for _ = 1, OlLooper.NUM_NECK_PIECES, 1 do
        local neckPiece = Isaac.Spawn(
            OlLooper.NECK.type,
            OlLooper.NECK.variant,
            OlLooper.NECK.subtype,
            player.Position,
            Vector.Zero,
            player
        ):ToEffect()

        neckPiece.DepthOffset = 20

        entityRefs[#entityRefs+1] = EntityRef(neckPiece)
        effects[#effects+1] = neckPiece
    end

    Helpers.GetData(player).OlLooperNeckPieces = entityRefs
    return effects
end


---@param player EntityPlayer
function OlLooper:OnPlayerRender(player)
    local data = Helpers.GetData(player)

    if not player:HasCollectible(OlLooper.ID) then
        if data.UsedToHaveOlLooper then
            RemoveHeadHelper(player)
            RemoveNeckPieces(player)
            player.TearsOffset = Vector(0, 0)
            player.PositionOffset = Vector(0, 0)
            data.UsedToHaveOlLooper = nil
        end

        return
    end

    data.UsedToHaveOlLooper = true

    TrySpawnLight(player)

    if Helpers.IsPlayingExtraAnimation(player) then
        player.PositionOffset = Vector(0, 0)
        return
    end

    player.PositionOffset = Vector(100000, 100000)

    local renderPosition = Isaac.WorldToScreen(player.Position)

    player:RenderBody(renderPosition)
    player:RenderTop(renderPosition)
end
LostItemsPack:AddCallback(
    ModCallbacks.MC_POST_PLAYER_RENDER,
    OlLooper.OnPlayerRender
)


---@param player EntityPlayer
function OlLooper:OnPeffectUpdate(player)
    if player:HasCollectible(OlLooper.ID) then
        local headHelper = GetHeadHelper(player)
        if not headHelper then
            headHelper = CreateHeadHelper(player)
        end

        local posOffset = headHelper.Position - player.Position
        player.TearsOffset = posOffset
    else
        RemoveHeadHelper(player)
    end
end
LostItemsPack:AddCallback(
    ModCallbacks.MC_POST_PEFFECT_UPDATE,
    OlLooper.OnPeffectUpdate
)


---@param headHelper Entity
---@param player EntityPlayer
local function HandleHeadMovement(headHelper, player)
    local data = Helpers.GetData(headHelper)

    local fireDir = player:GetFireDirection()

    local prevFireDir = data.PrevDirection or Direction.NO_DIRECTION
    data.PrevDirection = fireDir

    if fireDir == Direction.NO_DIRECTION and prevFireDir ~= Direction.NO_DIRECTION then
        data.MovementProgress = 0
        data.StartMovementPos = headHelper.Position
    end

    if Helpers.IsPlayingExtraAnimation(player) then
        data.MovementProgress = 1
        data.PrevDirection = fireDir

        headHelper.Position = player.Position
        headHelper.Velocity = player.Velocity
    elseif fireDir == Direction.NO_DIRECTION then
        local newPos = player.Position

        local movementProgress = data.MovementProgress or 1

        if movementProgress < 1 then
            local t = Helpers.EaseOutBack(movementProgress)
            newPos = Helpers.Lerp(data.StartMovementPos, player.Position, t)

            data.MovementProgress = math.min(movementProgress + OlLooper.HEAD_RETURN_VELOCITY, 1)
        end

        headHelper.Velocity = newPos - headHelper.Position
    else
        local shootingInput = player:GetShootingInput()
        local targetVelocity = shootingInput:Resized(OlLooper.HEAD_VELOCITY)
        local newVelocity = Helpers.Lerp(headHelper.Velocity, targetVelocity, OlLooper.HEAD_ACCEL)

        local distanceToPlayer = headHelper.Position:Distance(player.Position)

        if distanceToPlayer > OlLooper.HEAD_FREE_RANGE then
            local max = OlLooper.HEAD_ALLOWED_RANGE - OlLooper.HEAD_FREE_RANGE
            local current = distanceToPlayer - OlLooper.HEAD_FREE_RANGE
            local ratio = current / max

            local resistance = (headHelper.Position - player.Position):Resized(OlLooper.HEAD_VELOCITY * ratio)
            newVelocity = newVelocity - resistance
        end

        headHelper.Velocity = newVelocity
    end
end


---@param headHelper Entity
---@param player EntityPlayer
local function DealContactDamage(headHelper, player)
    if headHelper:IsFrame(OlLooper.CONTACT_DAMAGE_FREQUENCY, headHelper.InitSeed) then
        local enemies = Isaac.FindInRadius(
            headHelper.Position,
            OlLooper.CONTACT_DAMAGE_RANGE,
            EntityPartition.ENEMY
        )
        for _, enemy in ipairs(enemies) do
            local ref = EntityRef(enemy)
            if not ref.IsFriendly and enemy:IsActiveEnemy() and enemy:IsVulnerableEnemy() then
                local damage = player:GetTearPoisonDamage() * OlLooper.CONTACT_DAMAGE_MULT
                enemy:TakeDamage(damage, 0, EntityRef(player), 0)
            end
        end
    end
end


---@param headHelper Entity
function OlLooper:OnHeadHelperUpdate(headHelper)
    local spawner = headHelper.SpawnerEntity
    if not spawner then
        headHelper:Remove()
        return
    end

    local player = spawner:ToPlayer()
    if not player then
        headHelper:Remove()
        return
    end

    HandleHeadMovement(headHelper, player)
    DealContactDamage(headHelper, player)
end
LostItemsPack:AddCallback(
    ModCallbacks.MC_FAMILIAR_UPDATE,
    OlLooper.OnHeadHelperUpdate,
    OlLooper.HEAD_HELPER.variant
)


---@param player EntityPlayer
---@param headPos Vector
function RenderPlayerHead(player, headPos)
    local renderPos = Isaac.WorldToScreen(headPos)
    player:RenderGlow(renderPos)
    player:RenderHead(renderPos)
end


---@param player EntityPlayer
---@param headPos Vector
function RenderPlayerNeck(player, headPos)
    local neckPieces = GetNeckPieces(player)
    if not neckPieces then
        neckPieces = CreateNeckPieces(player)
    end

    local playerPos = player.Position + Vector(0, -17)
    local neckPos = headPos + Vector(0, -17)

    local numPieces = #neckPieces
    local segments = numPieces + 1
    local direction = neckPos - playerPos
    local distance = playerPos:Distance(neckPos)
    local distanceStep = distance/segments

    for i = 1, segments-1, 1 do
        local neckPiece = neckPieces[i]
        local targetPos = playerPos + direction:Resized(i * distanceStep)
        neckPiece.Velocity = targetPos - neckPiece.Position
    end
end


---@param headHelper Entity
function OlLooper:OnHeadHelperRender(headHelper)
    local spawner = headHelper.SpawnerEntity
    if not spawner then
        headHelper:Remove()
        return
    end

    local player = spawner:ToPlayer()
    if not player then
        headHelper:Remove()
        return
    end

    RenderPlayerHead(player, headHelper.Position)
    RenderPlayerNeck(player, headHelper.Position)
end
LostItemsPack:AddCallback(
    ModCallbacks.MC_POST_FAMILIAR_RENDER,
    OlLooper.OnHeadHelperRender,
    OlLooper.HEAD_HELPER.variant
)