local LuckySeven = {}
local Helpers = require("lost_items_scripts.Helpers")

LostItemsPack.CallOnLoad[#LostItemsPack.CallOnLoad+1] = function ()
    LostItemsPack.PersistentData.PlayersCollectedLuckySeven = {}
end


LostItemsPack.LuckySevenRegularSlot = require("lost_items_scripts.lucky_seven.lucky_seven_scripts.special_slots.RegularSlot")
LostItemsPack.LuckySevenSpecialSlots = {
    require("lost_items_scripts.lucky_seven.lucky_seven_scripts.special_slots.BloodDonationMachine"),
    require("lost_items_scripts.lucky_seven.lucky_seven_scripts.special_slots.DonationMachine"),
    require("lost_items_scripts.lucky_seven.lucky_seven_scripts.special_slots.FortuneTellingMachine"),
    require("lost_items_scripts.lucky_seven.lucky_seven_scripts.special_slots.Electrifier"),
    require("lost_items_scripts.lucky_seven.lucky_seven_scripts.special_slots.CraneGame"),
}
---@type Entity[]
LostItemsPack.LuckySevenSlotsInRoom = {}


--Main LuckySeven code
require("lost_items_scripts.lucky_seven.lucky_seven_scripts.HUDSparks")
require("lost_items_scripts.lucky_seven.lucky_seven_scripts.LuckySevenTears")
require("lost_items_scripts.lucky_seven.lucky_seven_scripts.LuckySevenLasers")
require("lost_items_scripts.lucky_seven.lucky_seven_scripts.SlotsManager")
require("lost_items_scripts.lucky_seven.lucky_seven_scripts.LuckySevenBoneSwing")
require("lost_items_scripts.lucky_seven.lucky_seven_scripts.LuckySevenLudovico")


---@param player EntityPlayer
function LuckySeven:OnPeffectUpdate(player)
    if not player:HasCollectible(LostItemsPack.CollectibleType.LUCKY_SEVEN) then return end

    local playerIndex = Helpers.GetPlayerIndex(player)
    for _, otherPlayerIndex in ipairs(LostItemsPack.PersistentData.PlayersCollectedLuckySeven) do
        if playerIndex == otherPlayerIndex then return end
    end

    if not player.Parent then
        local room = Game():GetRoom()
        for _ = 1, 7, 1 do
            local spawningPos = room:FindFreePickupSpawnPosition(player.Position, 1, true)
            Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, CoinSubType.COIN_PENNY, spawningPos, Vector.Zero, player)
        end
    end

    LostItemsPack.PersistentData.PlayersCollectedLuckySeven[#LostItemsPack.PersistentData.PlayersCollectedLuckySeven+1] = playerIndex
end
LostItemsPack:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, LuckySeven.OnPeffectUpdate)


---@param player EntityPlayer
function LuckySeven:OnCache(player)
    if player:HasCollectible(LostItemsPack.CollectibleType.LUCKY_SEVEN) then return end

    player.Luck = player.Luck + 2 * player:GetCollectibleNum(LostItemsPack.CollectibleType.LUCKY_SEVEN)
end
LostItemsPack:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, LuckySeven.OnCache, CacheFlag.CACHE_LUCK)