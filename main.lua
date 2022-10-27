LostItemsPack = RegisterMod("The Lost Items Pack", 1)

local json = require("json")

LostItemsPack.PersistentData = {}
LostItemsPack.CallOnLoad = {}

LostItemsPack.CollectibleType = {
    PILL_CRUSHER = Isaac.GetItemIdByName("Pill Crusher")
}


--Amazing save manager
local continue = false
local function IsContinue()
    local totPlayers = #Isaac.FindByType(EntityType.ENTITY_PLAYER)

    if totPlayers == 0 then
        if Game():GetFrameCount() == 0 then
            continue = false
        else
            local room = Game():GetRoom()
            local desc = Game():GetLevel():GetCurrentRoomDesc()

            if desc.SafeGridIndex == GridRooms.ROOM_GENESIS_IDX then
                if not room:IsFirstVisit() then
                    continue = true
                else
                    continue = false
                end
            else
                continue = true
            end
        end
    end

    return continue
end


function LostItemsPack:OnPlayerInit()
    if #Isaac.FindByType(EntityType.ENTITY_PLAYER) ~= 0 then return end

    local isContinue = IsContinue()

    if isContinue and LostItemsPack:HasData() then
        LostItemsPack.PersistentData = json.decode(LostItemsPack:LoadData())
    else
        LostItemsPack.PersistentData = {}

        for _, funct in ipairs(LostItemsPack.CallOnLoad) do
            funct()
        end
    end
end
LostItemsPack:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, LostItemsPack.OnPlayerInit)


function LostItemsPack:OnGameExit()
    local jsonString = json.encode(LostItemsPack.PersistentData)
    LostItemsPack:SaveData(jsonString)
end
LostItemsPack:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, LostItemsPack.OnGameExit)


--Other mods compat
require("lost_items_scripts.mod_compat.EIDCompat")
require("lost_items_scripts.mod_compat.MinimapiCompat")

--Require main item scripts
require("lost_items_scripts.pill_crusher.PillCrusher")