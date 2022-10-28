if not Encyclopedia then return end


--Encyclopeida Compatibility
local WikiAncientRevelation = {
    { -- Effect
        { str = "Effect", fsize = 2, clr = 3, halign = 0 },
        { str = "Grants 2 soul hearts (Or 2 immortal hearts if that mod is installed)" },
        { str = "Grants flight." },
        { str = "Grants spectral tears." },
        { str = "+0.48 Shot Speed up." },
        { str = "+1 Fire Rate up." },
        { str = "Tears turn 90 degrees to target enemies that they may have missed." },
    },
    { -- Mod Compatibility
        { str = "Mod Compatibility", fsize = 2, clr = 3, halign = 0 },
        { str = "EID - Shows a description of the item." },
        { str = "Encyclopedia - Shows a description of the item." },
        { str = "Minimap Items - Shows a minimap icon of the item." },
        { str = "Immortal Hearts - Upon pickup, the item gives 2 immortal hearts instead of 2 soul hearts." },
    },
    { -- Trivia
        { str = "Trivia", fsize = 2, clr = 3, halign = 0 },
        { str = "This item was what Revelation originally was in the Antibirth mod." },
        { str = "This mod was primarily coded by kittenchilly!" },
    },
}
Encyclopedia.AddItem({
    ID = LostItemsPack.CollectibleType.ANCIENT_REVELATION,
    WikiDesc = WikiAncientRevelation,
    Pools = {
        Encyclopedia.ItemPools.POOL_ANGEL,
        Encyclopedia.ItemPools.POOL_GREED_ANGEL,
    },
})


--Beth's Heart
local WikiBethsHeart = {
    { -- Effect
        { str = "Effect", fsize = 2, clr = 3, halign = 0 },
        { str = "Spawns a throwable familiar#Stores soul and black hearts to use as charges for the active item, maximum 6 pips of charge." },
        { str = "Half Soul Heart = 1 pip of charge. Soul Heart = 2 pips of charge. Black Heart = 3 pips of charge. Immortal Heart = 6 pips of charge." },
        { str = "Pressing the 'CTRL' key will supply pips of charge to the active item." },
    },
    { -- Notes
        { str = "Notes", fsize = 2, clr = 3, halign = 0 },
        { str = "Getting BFFS! expands charge storage to 12 pips of charge." },
        { str = "Double tapping in one direction will launch Beth's Heart that direction." },
    },
    { -- Trivia
        { str = "Trivia", fsize = 2, clr = 3, halign = 0 },
        { str = "Beth's Heart was one of the few items that was planned to be in Repentance but ultimately never came to fruition." },
        { str = "This is TC's third version of Beth's Heart. Originally, it was a trinket that had no familar, then a trinket with a familiar, and then an item." },

    },
    { -- Credits
        { str = "Credits", fsize = 2, clr = 3, halign = 0 },
        { str = "Team Compliance Director: Sillst" },
        { str = "Coders: Akad, anchikai., BrakeDude" },
        { str = "Artists: Michael¿?, Sillst, Soaring___Sky, The Demisemihemidemisemiquaver" },
        { str = "Translators: BrakeDude, Kotry" },
        { str = "Playtesters: Akad, anchikai., BrakeDude, Kotry, Sillst" },
        { str = "Shoutout to im_tem for doing the familiar code!" },
    },
}

Encyclopedia.AddItem({
    ID = LostItemsPack.CollectibleType.BETHS_HEART,
    WikiDesc = WikiBethsHeart,
    Pools = {
        Encyclopedia.ItemPools.POOL_TREASURE,
        Encyclopedia.ItemPools.POOL_ANGEL,
        Encyclopedia.ItemPools.POOL_GREED_TREASURE,
        Encyclopedia.ItemPools.POOL_GREED_ANGEL,
    },
})


--Blank bombs
local WikiBlankBombs = {
    { -- Effect
        { str = "Effect", fsize = 2, clr = 3, halign = 0 },
        { str = "Gives the player 5 bombs." },
        { str = "Blank Bombs explode instantly upon pressing the bomb key. -50% bomb damage." },
        { str = "Press the Drop Key + Bomb Key to place normal bombs. 100% bomb damage." },
        { str = "The player is immune from their own bomb damage." },
        { str = "Blank Bomb explosions destroy all enemy projectiles within a radius." },
        { str = "Blank Bomb explosions knock back enemies within a radius." },
    },
    { -- Interactions
        { str = "Interactions", fsize = 2, clr = 3, halign = 0 },
        { str = "External Item Descriptions: Provides a description for the item." },
        { str = "Encyclopedia: Provides a more detailed description for the item." },
        { str = "MinimapiItemsAPI: Provides a minimap icon for the item." },
    },
    { -- Trivia
        { str = "Trivia", fsize = 2, clr = 3, halign = 0 },
        { str = "Blank Bombs were a scrapped item concept from the acclaimed Antibirth mod." },
        { str = "This item was coded by kittenchilly and Thicco Catto, with spritework done by Royal, ALADAR, and Demi!" },
    },
}
Encyclopedia.AddItem({
    ID = LostItemsPack.CollectibleType.BLANK_BOMBS,
    WikiDesc = WikiBlankBombs,
    Pools = {
        Encyclopedia.ItemPools.POOL_TREASURE,
        Encyclopedia.ItemPools.POOL_GREED_TREASURE,
        Encyclopedia.ItemPools.POOL_BOMB_BUM,
    },
})


---Lucky Seven
local WikiLuckySeven = {
    { -- Effect
        { str = "Effect", fsize = 2, clr = 3, halign = 0 },
        { str = "Whenever one of the player's pickup counts ends in a 7 (07, 17, 27 and so on), Isaac will have chance to shoot out a golden tear." },
        { str = "If a golden tear hits a monster, it will spawn a slot machine that shoots out money tears in random directions for 3 seconds." },
        { str = "The machine will explode after the 3 seconds pass." },
        { str = "The remains of the machine disappear 1 second after the explosion." },
    },
    { -- Notes
        { str = "Notes", fsize = 2, clr = 3, halign = 0 },
        { str = "Unlike normal slot machines, the ones spawned from Lucky Seven will not drop any pickups after exploding." },
        { str = "" },
    },
    { -- Trivia
        { str = "Trivia", fsize = 2, clr = 3, halign = 0 },
        { str = "Lucky Seven was one of the few items that were apart of the Antibirth update, which never came to fruition." },
    },
}
Encyclopedia.AddItem({
    ID = LostItemsPack.CollectibleType.LUCKY_SEVEN,
    WikiDesc = WikiLuckySeven,
    Pools = {
        Encyclopedia.ItemPools.POOL_TREASURE,
        Encyclopedia.ItemPools.POOL_CRANE_GAME,
        Encyclopedia.ItemPools.POOL_GREED_SHOP,
    },
})


---Pill Crusher
local WikiPillCrusher = {
    { -- Effect
        { str = "Effect", fsize = 2, clr = 3, halign = 0 },
        { str = "Whenever one of the player's coin count ends in a 7 (07, 17, 27 and so on), Isaac will have chance to shoot out a golden tear." },
        { str = "If a golden tear hits a monster, it will spawn a slot machine that shoots out money tears in random directions for 3 seconds." },
        { str = "The machine will explode after the 3 seconds pass." },
        { str = "The remains of the machine disappear 1 second after the explosion." },
    },
    { -- Notes
        { str = "Notes", fsize = 2, clr = 3, halign = 0 },
        { str = "Unlike normal slot machines, the ones spawned from Lucky Seven will not drop any pickups after exploding." },
        { str = "" },
    },
    { -- Trivia
        { str = "Trivia", fsize = 2, clr = 3, halign = 0 },
        { str = "Lucky Seven was one of the few items that were apart of the Antibirth update, which never came to fruition." },
    },
}
Encyclopedia.AddItem({
    ID = LostItemsPack.CollectibleType.PILL_CRUSHER,
    WikiDesc = WikiPillCrusher,
    Pools = {
        Encyclopedia.ItemPools.POOL_SHOP,
        Encyclopedia.ItemPools.POOL_GREED_SHOP,
    },
})
