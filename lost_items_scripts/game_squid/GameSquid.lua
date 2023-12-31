local GameSquid = {}
local Helpers = require("lost_items_scripts.Helpers")
GameSquid.ID = LostItemsPack.TrinketType.GAME_SQUID
GameSquid.BASE_CHANCE = 0.05
--This chance will be added for each multiplier
GameSquid.EXTRA_CHANCE = 0.03
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