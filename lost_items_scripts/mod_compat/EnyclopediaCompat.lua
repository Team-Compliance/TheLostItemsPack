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


--Checked Mate
local WikiCheckedMate = {
    { -- Effect
        { str = "Effect", fsize = 2, clr = 3, halign = 0 },
        { str = "Spawns a familiar that moves by jumping from tile to tile." },
        { str = "20 AOE damage is delt upon each landing." },
        { str = "If the familiar lands directly on a monster, 40 damage is delt." },
    },
    { -- Synergies
        { str = "Synergies", fsize = 2, clr = 3, halign = 0 },
        { str = "BFFS! = Checked Mate moves like a queen piece from chess instead of a king piece. All damage is doubled." },
    },
    { -- Trivia
        { str = "Trivia", fsize = 2, clr = 3, halign = 0 },
        { str = "Checked mate was a scrapped item from the cancelled Antibirth update. It was originally a passive item whos intended effect was to clear the room if a champion was killed." },
        { str = "Checked Mate is the only familar whos sprite has changes other than size upon obtaining BFFS!." },
    },
}
Encyclopedia.AddItem({
    ID = LostItemsPack.CollectibleType.CHECKED_MATE,
    WikiDesc = WikiCheckedMate,
    Pools = {
        Encyclopedia.ItemPools.POOL_TREASURE,
        Encyclopedia.ItemPools.POOL_GREED_TREASURE,
        Encyclopedia.ItemPools.POOL_GOLDEN_CHEST,
        Encyclopedia.ItemPools.POOL_WOODEN_CHEST,
        Encyclopedia.ItemPools.POOL_BABY_SHOP,
    },
})


--Illusion Hearts - Book Of Illusions
local WikiBookOfIllusions = {
    { -- Effect
        { str = "Effect", fsize = 2, clr = 3, halign = 0 },
        { str = "Spawns an illusion clone when used." },
        { str = "Illusion clones are the same character as you, with the same starting stats and items." },
        { str = "Illusion clones control like Esau, but cannot pickup any items or pickups." },
        { str = "Illusion clones always die in one hit." },
    },
    { -- Trivia
        { str = "Trivia", fsize = 2, clr = 3, halign = 0 },
        { str = "This has the same effect as picking up an Illusion Heart." },
        { str = "Book of Illusions was an unused item in Antibirth, with its effect being the same as and complimentary to the unused Illusion Hearts." },
    },
}
Encyclopedia.AddItem({
    ID = LostItemsPack.CollectibleType.BOOK_OF_ILLUSIONS,
    WikiDesc = WikiBookOfIllusions,
    Pools = {
        Encyclopedia.ItemPools.POOL_ANGEL,
        Encyclopedia.ItemPools.POOL_DEVIL,
        Encyclopedia.ItemPools.POOL_LIBRARY,
        Encyclopedia.ItemPools.POOL_GREED_ANGEL,
        Encyclopedia.ItemPools.POOL_GREED_DEVIL,
    },
})


--Keeper's Rope
local WikiKeepersRope = {
    { -- Effect
        { str = "Effect", fsize = 2, clr = 3, halign = 0 },
        { str = "Grants flight." },
        { str = "-2 Luck down when not playing as Keeper or Tainted Keeper." },
        { str = "When monsters spawn they have a 25% chance to contain 1-3 pennies." },
        { str = "When playing as Keeper monsters have 16.7% chance to contain 1-2 pennies." },
        { str = "When playing as Tainted Keeper monsters have 12.5% chance to contain 1 penny." },
        { str = "The pennies can be extracted by inflicting damage on the monsters." },
        { str = "The pennies disappear after 3 seconds." },
    },
    { -- Notes
        { str = "Notes", fsize = 2, clr = 3, halign = 0 },
        { str = "Monsters containing pennies are indicated by a transluscent penny hovering over their heads." },
        { str = "This item has a chance of spawning after blowing up a shopkeeper, similarly to Head of the Keeper, Steam Sale, and Coupon." },
    },
    { -- Synergies
        { str = "Synergies", fsize = 2, clr = 3, halign = 0 },
        { str = "Dad's Key: Dropped coins have a 33% chance to be replaced with keys." },
        { str = "Mr. Boom: Dropped coins have a 33% chance to be replaced with bombs." },
        { str = "Crooked Penny: Dropped coins have a 50% chance to be doubled." },
        { str = "Humbling Bundle: Dropped coins, bombs, and keys have a 50% chance to be doubled." },
        { str = "BOGO Bombs: Dropped bombs from the Mr. Boom synergy have a 100% chance to be doubled." },
    },
    { -- Trivia
        { str = "Trivia", fsize = 2, clr = 3, halign = 0 },
        { str = "Keeper's Rope was one of the few cancelled items that was originally planned to be in Repentance." },
        { str = "According to its unlock paper sprite, Keeper's Rope was supposed to look similar to the item Transendence, so similar in fact that Team Compliance decided to edit it in order to avoid potential confusion." },
        { str = "The original Keeper's Rope mod was made by Akad!" },
        { str = "This mod was primarily coded by BrakeDude!" },
    },
}
Encyclopedia.AddItem({
    ID = LostItemsPack.CollectibleType.KEEPERS_ROPE,
    WikiDesc = WikiKeepersRope,
    Pools = {
        Encyclopedia.ItemPools.POOL_SECRET,
        Encyclopedia.ItemPools.POOL_GREED_SECRET,
        Encyclopedia.ItemPools.POOL_GREED_SHOP,
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
