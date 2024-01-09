local GameSquid = {}
local Helpers = require("lost_items_scripts.Helpers")
GameSquid.ID = LostItemsPack.TrinketType.GAME_SQUID
GameSquid.BASE_CHANCE = 0.05
--This chance will be added for each multiplier
GameSquid.EXTRA_CHANCE = 0.03
GameSquid.BASE_LASER_CHANCE = 0.02
GameSquid.EXTRA_LASER_CHANCE = 0.05
GameSquid.LASER_SLOW_DURATION = 0.0
GameSquid.TEAR_COLOR = Color(0.1, 0.1, 0.1, 1)


---@param tear EntityTear
function GameSquid:OnFireTear(tear)
    local player = Helpers.GetPlayerFromTear(tear)
    if not player then return end
    if not player:HasTrinket(GameSquid.ID) then return end

    local rng = player:GetTrinketRNG(GameSquid.ID)

    local extraChance = GameSquid.EXTRA_CHANCE * player:GetTrinketMultiplier(GameSquid.ID)
    local chance = GameSquid.BASE_CHANCE + extraChance

    if rng:RandomFloat() < chance then
        tear:AddTearFlags(TearFlags.TEAR_SLOW)
        Helpers.GetData(tear).IsGameSquidTear = true

        tear.Color = Color(GameSquid.TEAR_COLOR.R, GameSquid.TEAR_COLOR.G, GameSquid.TEAR_COLOR.B)
    end
end
LostItemsPack:AddCallback(
    ModCallbacks.MC_POST_FIRE_TEAR,
    GameSquid.OnFireTear
)


---@param entity Entity
function GameSquid:OnEntityRemoved(entity)
    local data = Helpers.GetData(entity)

    if data.IsGameSquidTear then
        Isaac.Spawn(
            EntityType.ENTITY_EFFECT,
            EffectVariant.PLAYER_CREEP_BLACK,
            0,
            entity.Position,
            Vector.Zero,
            entity
        )
    end
end
LostItemsPack:AddCallback(
    ModCallbacks.MC_POST_ENTITY_REMOVE,
    GameSquid.OnEntityRemoved
)


---@param entity Entity
---@param flags DamageFlag
---@param source EntityRef
function GameSquid:OnEntityDamage(entity, _, flags, source)
    if not Helpers.IsTargetableEnemy(entity) then return end
    if source.Type ~= EntityType.ENTITY_PLAYER then return end
    local player = source.Entity:ToPlayer()
    if not player:HasTrinket(GameSquid.ID) or
    player:HasCollectible(CollectibleType.COLLECTIBLE_LUDOVICO_TECHNIQUE) then return end
    if flags & DamageFlag.DAMAGE_LASER == 0 then return end

    local rng = player:GetTrinketRNG(GameSquid.ID)

    local extraChance = GameSquid.EXTRA_LASER_CHANCE * player:GetTrinketMultiplier(GameSquid.ID)
    local chance = GameSquid.BASE_LASER_CHANCE + extraChance

    if rng:RandomFloat() < chance then
        entity:AddSlowing(EntityRef(player), 3, 1, Color(1, 1, 1, 1, 0.2, 0.2, 0.2))

        Isaac.Spawn(
            EntityType.ENTITY_EFFECT,
            EffectVariant.PLAYER_CREEP_BLACK,
            0,
            entity.Position,
            Vector.Zero,
            player
        )
    end
end
LostItemsPack:AddCallback(
    ModCallbacks.MC_ENTITY_TAKE_DMG,
    GameSquid.OnEntityDamage
)