LostItemsPack = RegisterMod("The Lost Items Pack", 1)

local json = require("json")

--Data that will persist between runs
LostItemsPack.RunPersistentData = {}
--Data that will reset between runs
LostItemsPack.PersistentData = {}

--Functions that will get called when there is no save data
LostItemsPack.CallOnNewSaveData = {}
--Functions that will be called when a new run is called
LostItemsPack.CallOnLoad = {}

--Constants and enums
LostItemsPack.CollectibleType = {
    ANCIENT_REVELATION = Isaac.GetItemIdByName("Ancient Revelation"),
    BETHS_HEART = Isaac.GetItemIdByName("Beth's Heart"),
    BLANK_BOMBS = Isaac.GetItemIdByName("Blank Bombs"),
    BOOK_OF_ILLUSIONS = Isaac.GetItemIdByName("Book of Illusions"),
    CHECKED_MATE = Isaac.GetItemIdByName("Checked Mate"),
    KEEPERS_ROPE = Isaac.GetItemIdByName("Keeper's Rope"),
    LUCKY_SEVEN = Isaac.GetItemIdByName("Lucky Seven"),
    PACIFIST = Isaac.GetItemIdByName("Pacifist"),
    PILL_CRUSHER = Isaac.GetItemIdByName("Pill Crusher"),
    SAFETY_BOMBS = Isaac.GetItemIdByName("Safety Bombs"),
    VOODOO_PIN = Isaac.GetItemIdByName("Voodoo Pin")
}

LostItemsPack.Entities = {
    BETHS_HEART = {
        type = EntityType.ENTITY_FAMILIAR,
        variant = Isaac.GetEntityVariantByName("Beth's Heart"),
        subtype = 0
    },

    BLANK_BOMB_EXPLOSION = {
        type = EntityType.ENTITY_EFFECT,
        variant = Isaac.GetEntityVariantByName("blank explosion"),
        subtype = 0
    },

    CHECKED_MATE = {
        type = EntityType.ENTITY_FAMILIAR,
        variant = Isaac.GetEntityVariantByName("Checked Mate"),
        subtype = 0
    },

    ILLUSION_HEART = {
        type = EntityType.ENTITY_PICKUP,
        variant = PickupVariant.PICKUP_HEART,
        subtype = 9000
    },

    KEEPERS_ROPE = {
        type = Isaac.GetEntityTypeByName("Hanging rope"),
        variant = Isaac.GetEntityVariantByName("Hanging rope"),
        subtype = 0
    },

    LUCKY_SEVEN_SLOT = {
        type = EntityType.ENTITY_SLOT,
        variant = Isaac.GetEntityVariantByName("Lucky Seven Slot"),
        subtype = 0
    },

    LUCKY_SEVEN_MACHINE_SPARKLES = {
        type = EntityType.ENTITY_EFFECT,
        variant = Isaac.GetEntityVariantByName("Machine Sparkles"),
        subtype = 0
    },

    LUCKY_SEVEN_CORD_END = {
        type = EntityType.ENTITY_EFFECT,
        variant = Isaac.GetEntityVariantByName("Crane Cord End"),
        subtype = 0
    },

    LUCKY_SEVEN_CORD_HANDLER = {
        type = EntityType.ENTITY_EFFECT,
        variant = Isaac.GetEntityVariantByName("Crane Cord Handler"),
        subtype = 0
    },

    LUCKY_SEVEN_CRANE_CORD = {
        type = EntityType.ENTITY_EVIS,
        variant = 10,
        subtype = 231
    },

    VOODOO_PIN_TEAR = {
        type = EntityType.ENTITY_TEAR,
        variant = Isaac.GetEntityVariantByName("Voodoo Pin Tear"),
        subtype = 0
    },

    VOODOO_PIN_SHATTER = {
        type = EntityType.ENTITY_EFFECT,
        variant = Isaac.GetEntityVariantByName("Voodoo Pin Shatter"),
        subtype = 0
    }
}

LostItemsPack.SFX = {
    PICKUP_ILLUSION = Isaac.GetSoundIdByName("PickupIllusion")
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

    Isaac.ExecuteCommand("reloadshaders")

    local isContinue = IsContinue()

    if isContinue and LostItemsPack:HasData() then
        local loadedData = json.decode(LostItemsPack:LoadData())
        LostItemsPack.PersistentData = loadedData.PersistentData
        LostItemsPack.RunPersistentData = loadedData.RunPersistentData
    else
        if LostItemsPack:HasData() then
            local loadedData = json.decode(LostItemsPack:LoadData())
            LostItemsPack.RunPersistentData = loadedData.RunPersistentData
        end

        if not LostItemsPack.RunPersistentData or not LostItemsPack.RunPersistentData.DisabledItems then
            LostItemsPack.RunPersistentData = {}
            LostItemsPack.RunPersistentData.DisabledItems = {}
            for _, funct in ipairs(LostItemsPack.CallOnNewSaveData) do
                funct()
            end
        end

        LostItemsPack.PersistentData = {}

        for _, funct in ipairs(LostItemsPack.CallOnLoad) do
            funct()
        end
    end
end
LostItemsPack:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, LostItemsPack.OnPlayerInit)


function LostItemsPack:OnGameExit()
    local saveData = {
        PersistentData = LostItemsPack.PersistentData,
        RunPersistentData = LostItemsPack.RunPersistentData
    }

    local jsonString = json.encode(saveData)
    LostItemsPack:SaveData(jsonString)
end
LostItemsPack:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, LostItemsPack.OnGameExit)

--Libs
require("lost_items_scripts.lib.DSSMenu")

--Other mods compat
require("lost_items_scripts.mod_compat.EIDCompat")
require("lost_items_scripts.mod_compat.EnyclopediaCompat")
require("lost_items_scripts.mod_compat.MinimapiCompat")

--Require main generic scripts
require("lost_items_scripts.BlockDisabledItems")

--Require main item scripts
require("lost_items_scripts.ancient_revelation.AncientRevelation")
require("lost_items_scripts.beths_heart.BethsHeart")
require("lost_items_scripts.blank_bombs.BlankBombs")
require("lost_items_scripts.checked_mate.CheckedMate")
require("lost_items_scripts.illusion_hearts.IllusionHearts")
require("lost_items_scripts.keepers_rope.KeepersRope")
require("lost_items_scripts.lucky_seven.LuckySeven")
require("lost_items_scripts.pacifist.Pacifist")
require("lost_items_scripts.pill_crusher.PillCrusher")
require("lost_items_scripts.safety_bombs.SafetyBombs")
require("lost_items_scripts.voodo_pin.VoodooPin")