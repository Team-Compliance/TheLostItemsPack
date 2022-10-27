if not Encyclopedia then return end


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
