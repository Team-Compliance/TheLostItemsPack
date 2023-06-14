if not Encyclopedia then return end

Wiki = {}

--Encyclopeida Compatibility
Wiki.AncientRevelation = {
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
    },
    { -- Credits
        { str = "Credits", fsize = 2, clr = 3, halign = 0 },
        { str = "Coded by kittenchilly!" },
        { str = "Spritework by Demi!" },
    },
}
Encyclopedia.AddItem({
    ID = LostItemsPack.CollectibleType.ANCIENT_REVELATION,
    WikiDesc = Wiki.AncientRevelation,
    Pools = {
        Encyclopedia.ItemPools.POOL_ANGEL,
        Encyclopedia.ItemPools.POOL_GREED_ANGEL,
        Encyclopedia.ItemPools.POOL_ULTRA_SECRET,
    },
    Class = "Lost Items Pack",
    ModName = "Lost Items Pack"
})


--Beth's Heart
Wiki.BethsHeart = {
    { -- Effect
        { str = "Effect", fsize = 2, clr = 3, halign = 0 },
        { str = "Spawns a double-tap throwable familiar#Stores soul and black hearts to use as charges for the active item, maximum 6 pips of charge." },
        { str = "Half Soul Heart = 1 pip of charge. Soul Heart = 2 pips of charge. Black Heart = 3 pips of charge." },
        { str = "Pressing the 'CTRL' key will supply pips of charge to the active item." },
    },
    { -- Synergies
        { str = "Synergies", fsize = 2, clr = 3, halign = 0 },
        { str = "BFFS - Expands charge storage to 12 pips of charge." },
    },
    { -- Mod Compatibility
        { str = "Mod Compatibility", fsize = 2, clr = 3, halign = 0 },
        { str = "EID - Shows a description of the item." },
        { str = "Encyclopedia - Shows a description of the item." },
        { str = "Minimap Items - Shows a minimap icon of the item." },
        { str = "Immortal Hearts - Immortal Heart = 6 pips of charge when collected with Beth's Heart" },
    },
    { -- Trivia
        { str = "Trivia", fsize = 2, clr = 3, halign = 0 },
        { str = "Beth's Heart was one of the few items that was planned to be in Repentance but ultimately never came to fruition." },
        { str = "This is TC's third version of Beth's Heart. Originally, it was a trinket that had no familar, then a trinket with a familiar, and then an item." },
    },
    { -- Credits
        { str = "Credits", fsize = 2, clr = 3, halign = 0 },
        { str = "Coded by Akad, BrakeDude, and im_tem!" },
        { str = "Familiar animations by Firework!" },
        { str = "Translations by BrakeDude & Kotry!" },
    },
}
Encyclopedia.AddItem({
    ID = LostItemsPack.CollectibleType.BETHS_HEART,
    WikiDesc = Wiki.BethsHeart,
    Pools = {
        Encyclopedia.ItemPools.POOL_TREASURE,
        Encyclopedia.ItemPools.POOL_GREED_SHOP,
        Encyclopedia.ItemPools.POOL_BABY_SHOP,
    },
    Class = "Lost Items Pack",
    ModName = "Lost Items Pack"
})


--Blank bombs
Wiki.BlankBombs = {
    { -- Effect
        { str = "Effect", fsize = 2, clr = 3, halign = 0 },
        { str = "Gives the player 5 bombs." },
        { str = "Blank Bombs explode instantly upon pressing the bomb key. -50% bomb damage." },
        { str = "Press the Drop Key + Bomb Key to place normal bombs. 100% bomb damage." },
        { str = "The player is immune from their own bomb damage." },
        { str = "Blank Bomb explosions destroy all enemy projectiles within a radius." },
        { str = "Blank Bomb explosions knock back enemies within a radius." },
    },
    { -- Mod Compatibility
        { str = "Mod Compatibility", fsize = 2, clr = 3, halign = 0 },
        { str = "EID - Shows a description for the item." },
        { str = "Encyclopedia - Shows a more detailed description for the item." },
        { str = "Minimap Items - Shows a minimap icon for the item." },
    },
    { -- Trivia
        { str = "Trivia", fsize = 2, clr = 3, halign = 0 },
        { str = "Blank Bombs were a scrapped item concept from the acclaimed Antibirth mod." },
    },
    { -- Credits
        { str = "Credits", fsize = 2, clr = 3, halign = 0 },
        { str = "Coded by kittenchilly and Thicco Catto!" },
        { str = "Spritework by ALADAR and Demi!" },
        { str = "Translations by BrakeDude & Kotry!" },
    },
}
Encyclopedia.AddItem({
    ID = LostItemsPack.CollectibleType.BLANK_BOMBS,
    WikiDesc = Wiki.BlankBombs,
    Pools = {
        Encyclopedia.ItemPools.POOL_TREASURE,
        Encyclopedia.ItemPools.POOL_GREED_TREASURE,
        Encyclopedia.ItemPools.POOL_BOMB_BUM,
    },
    Class = "Lost Items Pack",
    ModName = "Lost Items Pack"
})


--Checked Mate
Wiki.CheckedMate = {
    { -- Effect
        { str = "Effect", fsize = 2, clr = 3, halign = 0 },
        { str = "Spawns a familiar that moves by jumping from tile to tile." },
        { str = "20 AOE damage is delt upon each landing." },
        { str = "If the familiar lands directly on a monster, 40 damage is delt." },
    },
    { -- Synergies
        { str = "Synergies", fsize = 2, clr = 3, halign = 0 },
        { str = "BFFS! - Checked Mate moves like a queen piece from chess instead of a king piece. All damage is doubled." },
        { str = "RC Remote - The direction of Checked Mate's movement is controlled by the player's directional movements." },
    },
    { -- Mod Compatibility
        { str = "Mod Compatibility", fsize = 2, clr = 3, halign = 0 },
        { str = "EID - Shows a description for the item." },
        { str = "Encyclopedia - Shows a more detailed description for the item." },
        { str = "Minimap Items - Shows a minimap icon for the item." },
    },
    { -- Trivia
        { str = "Trivia", fsize = 2, clr = 3, halign = 0 },
        { str = "Checked mate was a scrapped item from the cancelled Antibirth update. It was originally a passive item whos intended effect was to clear the room if a champion was killed." },
        { str = "Checked Mate is the only familar whos sprite has changes other than size upon obtaining BFFS!." },
    },
    { -- Credits
        { str = "Credits", fsize = 2, clr = 3, halign = 0 },
        { str = "Coded by kittenchilly, PixelPlz and Thicco Catto!" },
        { str = "Animations by Firework!" },
        { str = "BFFS! spritework by Amy!" },
        { str = "Translations by BrakeDude & Kotry!" },
        { str = "Special thanks to Xalum for helping with the improved pathfinding code!" },
    },
}
Encyclopedia.AddItem({
    ID = LostItemsPack.CollectibleType.CHECKED_MATE,
    WikiDesc = Wiki.CheckedMate,
    Pools = {
        Encyclopedia.ItemPools.POOL_TREASURE,
        Encyclopedia.ItemPools.POOL_GREED_TREASURE,
        Encyclopedia.ItemPools.POOL_GOLDEN_CHEST,
        Encyclopedia.ItemPools.POOL_WOODEN_CHEST,
        Encyclopedia.ItemPools.POOL_BABY_SHOP,
    },
    Class = "Lost Items Pack",
    ModName = "Lost Items Pack"
})
if Sewn_API then
    Sewn_API:AddEncyclopediaUpgrade(
        LostItemsPack.Entities.CHECKED_MATE.variant,
        "Increases damage",
        "Increases damage further and range"
    )
end


--Illusion Hearts - Book Of Illusions
Wiki.BookOfIllusions = {
    { -- Effect
        { str = "Effect", fsize = 2, clr = 3, halign = 0 },
        { str = "Spawns an illusion clone when used." },
        { str = "Illusion clones are the same character as you, with the same starting stats and items." },
        { str = "Illusion clones control like Esau, but cannot pickup any items or pickups." },
        { str = "Illusion clones always die in one hit." },
    },
    { -- Mod Compatibility
        { str = "Mod Compatibility", fsize = 2, clr = 3, halign = 0 },
        { str = "EID - Shows a description for the item." },
        { str = "Encyclopedia - Shows a more detailed description for the item." },
        { str = "Minimap Items - Shows a minimap icon for the item." },
    },
    { -- Trivia
        { str = "Trivia", fsize = 2, clr = 3, halign = 0 },
        { str = "This has the same effect as picking up an Illusion Heart." },
        { str = "Book of Illusions was an unused item in Antibirth, with its effect being the same as and complimentary to the unused Illusion Hearts." },
    },
    { -- Credits
        { str = "Credits", fsize = 2, clr = 3, halign = 0 },
        { str = "Coded by Akad, BrakeDude, kittenchilly, and Thicco Catto!" },
        { str = "Special thanks to Mark Shwedow for the Illusion Heart SFX!" },
    },
}
Encyclopedia.AddItem({
    ID = LostItemsPack.CollectibleType.BOOK_OF_ILLUSIONS,
    WikiDesc = Wiki.BookOfIllusions,
    Pools = {
        Encyclopedia.ItemPools.POOL_DEVIL,
        Encyclopedia.ItemPools.POOL_LIBRARY,
        Encyclopedia.ItemPools.POOL_GREED_DEVIL,
    },
    Class = "Lost Items Pack",
    ModName = "Lost Items Pack"
})


--Keeper's Rope
Wiki.KeepersRope = {
    { -- Effect
        { str = "Effect", fsize = 2, clr = 3, halign = 0 },
        { str = "Grants flight." },
        { str = "-2 Luck down when not playing as Keeper or Tainted Keeper." },
        { str = "When monsters spawn they have a 25% chance to contain 1-3 pennies." },
        { str = "When playing as Keeper monsters have 16.7% chance to contain 1-2 pennies." },
        { str = "When playing as Tainted Keeper monsters have 12.5% chance to contain 1 penny." },
        { str = "The pennies can be extracted by inflicting damage on the monsters." },
        { str = "The pennies disappear after 2 seconds." },
    },
    { -- Notes
        { str = "Notes", fsize = 2, clr = 3, halign = 0 },
        { str = "Monsters containing pennies are indicated by a transluscent penny hovering over their heads." },
        { str = "This item has a chance of spawning after blowing up a shopkeeper, similarly to Head of the Keeper, Steam Sale, and Coupon." },
    },
    { -- Synergies
        { str = "Synergies", fsize = 2, clr = 3, halign = 0 },
        { str = "Dad's Key - Dropped coins have a 33% chance to be replaced with keys." },
        { str = "Mr. Boom - Dropped coins have a 33% chance to be replaced with bombs." },
        { str = "Crooked Penny - Dropped coins have a 50% chance to be doubled." },
        { str = "Humbling Bundle - Dropped coins, bombs, and keys have a 50% chance to be doubled." },
        { str = "BOGO Bombs - Dropped bombs from the Mr. Boom synergy have a 100% chance to be doubled." },
    },
    { -- Mod Compatibility
        { str = "Mod Compatibility", fsize = 2, clr = 3, halign = 0 },
        { str = "EID - Shows a description for the item." },
        { str = "Encyclopedia - Shows a more detailed description for the item." },
        { str = "Minimap Items - Shows a minimap icon for the item." },
    },
    { -- Trivia
        { str = "Trivia", fsize = 2, clr = 3, halign = 0 },
        { str = "Keeper's Rope was one of the few cancelled items that was originally planned to be in Repentance." },
        { str = "According to its unlock paper sprite, Keeper's Rope was supposed to look similar to the item Transendence, so similar in fact that Team Compliance decided to edit it in order to avoid potential confusion." },
    },
    { -- Credits
        { str = "Credits", fsize = 2, clr = 3, halign = 0 },
        { str = "Coded by Akad and BrakeDude!" },
        { str = "Spritework by ALADAR!" },
    },
}
Encyclopedia.AddItem({
    ID = LostItemsPack.CollectibleType.KEEPERS_ROPE,
    WikiDesc = Wiki.KeepersRope,
    Pools = {
        Encyclopedia.ItemPools.POOL_SECRET,
        Encyclopedia.ItemPools.POOL_GREED_SECRET,
    },
    Class = "Lost Items Pack",
    ModName = "Lost Items Pack"
})


---Lucky Seven
Wiki.LuckySeven = {
    { -- Effect
        { str = "Effect", fsize = 2, clr = 3, halign = 0 },
        { str = "Whenever one of the player's pickups count ends in a 7 (07, 17, 27 and so on), Isaac will have chance to shoot out a golden tear." },
        { str = "If a golden tear hits a monster, it will spawn a slot machine that shoots out money tears in random directions for 3 seconds." },
        { str = "The machine will explode after the 3 seconds pass." },
        { str = "The remains of the machine disappear 1 second after the explosion." },
    },
    { -- Notes
        { str = "Notes", fsize = 2, clr = 3, halign = 0 },
        { str = "Unlike normal slot machines, the ones spawned from Lucky Seven will not drop any pickups after exploding." },
        { str = "The Lucky Seven slot machine explosions do not harm the player." },
    },
    { -- Synergies
        { str = "Synergies", fsize = 2, clr = 3, halign = 0 },
        { str = "IV Bag - Spawns a special donation machine that spawns creep and explodes into big blood tears." },
        { str = "Keeper's Box - Spawns a special donation machine that drops coins on monsters similarly to Ultra Greed." },
        { str = "Crystal Ball - Spawns a special fortune machine that shoots rays of light." },
        { str = "Tammy's Head - Spawns a special crane machine that grabs monsters and holds them in place with a claw. Maximum of 5 monsters." },
        { str = "Brimstone - Beams inherit the tear effect." },
        { str = "Technology items - Lasers inherit the tear effect." },
    },
    { -- Mod Compatibility
        { str = "Mod Compatibility", fsize = 2, clr = 3, halign = 0 },
        { str = "EID - Shows a description for the item." },
        { str = "Encyclopedia - Shows a more detailed description for the item." },
        { str = "Minimap Items - Shows a minimap icon for the item." },
    },
    { -- Trivia
        { str = "Trivia", fsize = 2, clr = 3, halign = 0 },
        { str = "Lucky Seven was one of the few items that were apart of the Antibirth update, which never came to fruition." },
        { str = "There is a secret synergy, have fun finding it :)" },
    },
    { -- Credits
        { str = "Credits", fsize = 2, clr = 3, halign = 0 },
        { str = "Coded by BrakeDude, fly_6 and Thicco Catto!" },
        { str = "Spritework by Akad, Chug all This and Demi!" },
    },
}
Encyclopedia.AddItem({
    ID = LostItemsPack.CollectibleType.LUCKY_SEVEN,
    WikiDesc = Wiki.LuckySeven,
    Pools = {
        Encyclopedia.ItemPools.POOL_TREASURE,
        Encyclopedia.ItemPools.POOL_CRANE_GAME,
        Encyclopedia.ItemPools.POOL_GREED_SHOP,
    },
    Class = "Lost Items Pack",
    ModName = "Lost Items Pack"
})


--Pacifist
Wiki.Pacifist = {
    { -- Effect
        { str = "Effect", fsize = 2, clr = 3, halign = 0 },
        { str = "After entering a new floor, gives pickups based on how many rooms haven't been cleared on the previous floor." },
        { str = "Skipping special rooms will reward the player with chests." },
        { str = "Different types of special rooms will spawn different types of chests." },
    },
    { -- Notes
        { str = "Notes", fsize = 2, clr = 3, halign = 0 },
        { str = "Skipping angel or deal rooms, and crawlspaces (if the corresponding entrances spawn) will also spawn rewards." },
    },
    { -- Mod Compatibility
        { str = "Mod Compatibility", fsize = 2, clr = 3, halign = 0 },
        { str = "EID - Shows a description for the item." },
        { str = "Encyclopedia - Shows a more detailed description for the item." },
        { str = "Minimap Items - Shows a minimap icon for the item." },
    },
    { -- Trivia
        { str = "Trivia", fsize = 2, clr = 3, halign = 0 },
        { str = "Pacifist was one of the few items that were apart of the Antibirth update, which never came to fruition." },
    },
    { -- Credits
        { str = "Credits", fsize = 2, clr = 3, halign = 0 },
        { str = "Coded by kittenchilly and Thicco Catto!" },
    },
}
Encyclopedia.AddItem({
    ID = LostItemsPack.CollectibleType.PACIFIST,
    WikiDesc = Wiki.Pacifist,
    Pools = {
        Encyclopedia.ItemPools.POOL_ANGEL
    },
    Class = "Lost Items Pack",
    ModName = "Lost Items Pack"
})


---Pill Crusher
Wiki.PillCrusher = {
    { -- Effect
        { str = "Effect", fsize = 2, clr = 3, halign = 0 },
        { str = "Spawns a random pill on pickup." },
        { str = "Crushing a pill activates a unique alternate effect, typically not affecting the player but rather the enemies, room, or floor." },
        { str = "Pills have a chance to spawn after completing a room." },
    },
    { -- Notes
        { str = "Notes", fsize = 2, clr = 3, halign = 0 },
        { str = "The names of pills do not get revealed if they are crushed." },
    },
    { -- Synergies
        { str = "Synergies", fsize = 2, clr = 3, halign = 0 },
        { str = "Book of Virtues - Spawns unique pill wisps that have different effects." },
    },
    { -- Mod Compatibility
        { str = "Mod Compatibility", fsize = 2, clr = 3, halign = 0 },
        { str = "EID - Shows a description for the item." },
        { str = "Encyclopedia - Shows a more detailed description for the item." },
        { str = "Minimap Items - Shows a minimap icon for the item." },
        { str = "Fiend Folio - Pill effects." },
    },
    { -- Trivia
        { str = "Trivia", fsize = 2, clr = 3, halign = 0 },
        { str = "Pill Crusher was a cut item from Antibirth and Repentance. The sprite is in the game's files and there were videos of certain effects." },
    },
    { -- Credits
        { str = "Credits", fsize = 2, clr = 3, halign = 0 },
        { str = "Coded by Akad, BrakeDude, kittenchilly and Thicco Catto!" },
    }, 
}
Encyclopedia.AddItem({
    ID = LostItemsPack.CollectibleType.PILL_CRUSHER,
    WikiDesc = Wiki.PillCrusher,
    Pools = {
        Encyclopedia.ItemPools.POOL_SHOP,
        Encyclopedia.ItemPools.POOL_GREED_SHOP,
    },
    Class = "Lost Items Pack",
    ModName = "Lost Items Pack"
})


--Safety Bombs
Wiki.SafetyBombs = {
    { -- Effect
        { str = "Effect", fsize = 2, clr = 3, halign = 0 },
        { str = "+5 bombs." },
        { str = "Placed bombs will not explode until the player leaves its explosion radius." },
    },
    { -- Synergies
        { str = "Synergies", fsize = 2, clr = 3, halign = 0 },
        { str = "Bob's Curse - Enemies that go within the radius of bombs get the poison effect." },
        { str = "Butt Bombs - Enemies that go within the radius of bombs get confusion." },
        { str = "Hot Bombs - Enemies that go within the radius of bombs get the burn effect." },
        { str = "Sticky Bombs - Enemies that go within the radius of bombs get the slowness effect." },
        { str = "Nancy Bombs - The Safety Bombs effect is in the Nancy Bombs effect pool." },
    },
    { -- Trivia
        { str = "Trivia", fsize = 2, clr = 3, halign = 0 },
        { str = "Safety Bombs was an unused idea from Antibirth, it only existed in concept art." },
    },
    { -- Credits
        { str = "Credits", fsize = 2, clr = 3, halign = 0 },
        { str = "Coded by BrakeDude, kittenchilly and Thicco Catto!" },
        { str = "Spritework by Demi!" },
    },
}
Encyclopedia.AddItem({
    ID = LostItemsPack.CollectibleType.SAFETY_BOMBS,
    WikiDesc = Wiki.SafetyBombs,
    Pools = {
        Encyclopedia.ItemPools.POOL_TREASURE,
        Encyclopedia.ItemPools.POOL_GREED_TREASURE,
        Encyclopedia.ItemPools.POOL_BOMB_BUM,
    },
    Class = "Lost Items Pack",
    ModName = "Lost Items Pack"
})


--Voodoo Pin
Wiki.VoodooPin = {
    { -- Effect
        { str = "Effect", fsize = 2, clr = 3, halign = 0 },
        { str = "Isaac holds up a voodoo pin that can be thrown." },
        { str = "If the pin hits a monster, all damage taken by Isaac will be redirected to that monster." },
        { str = "This effect lasts for 10 seconds if the monster is not killed within that timeframe." },
        { str = "Hitting bosses has 25% chance to proc. Lasts for 3-4 seconds." },
    },
    { -- Notes
        { str = "Notes", fsize = 2, clr = 3, halign = 0 },
        { str = "This item can be used for certain strategies involving Demon Beggars, Blood Banks, or the IV Bag item." },
    },
    { -- Mod Compatibility
        { str = "Mod Compatibility", fsize = 2, clr = 3, halign = 0 },
        { str = "EID - Shows a description for the item." },
        { str = "Encyclopedia - Shows a more detailed description for the item." },
        { str = "Minimap Items - Shows a minimap icon for the item." },
    },
    { -- Trivia
        { str = "Trivia", fsize = 2, clr = 3, halign = 0 },
        { str = "Voodoo Pin was an item from the Antibirth mod that was reworked into an Afterbirth DLC item called Dull Razor." },
        { str = "Voodoo Pin was one of the few items not imported into Repentance alongside Book of Despair, Bowl of Tears, Donkey Jawbone, Knife Piece 3, Menorah, and Stone Bombs." },
    },
    { -- Credits
        { str = "Credits", fsize = 2, clr = 3, halign = 0 },
        { str = "Coded by BrakeDude and Thicco Catto!" },
        { str = "Spritework by Amy!" },
    },
}
Encyclopedia.AddItem({
    ID = LostItemsPack.CollectibleType.VOODOO_PIN,
    WikiDesc = Wiki.VoodooPin,
    Pools = {
        Encyclopedia.ItemPools.POOL_SHOP,
        Encyclopedia.ItemPools.POOL_GREED_SHOP,
    },
    Class = "Lost Items Pack",
    ModName = "Lost Items Pack"
})

--Update 2

--Safety Bombs
Wiki.DiceBombs = {
    { -- Effect
        { str = "Effect", fsize = 2, clr = 3, halign = 0 },
        { str = "+5 bombs." },
        { str = "Collectibles within the explosion radius will be rerolled." },
        { str = "Holding dice active items will add additional effects." },
    },
    { -- Synergies
        { str = "Synergies", fsize = 2, clr = 3, halign = 0 },
        { str = "D1 - Duplicates one pickup within the explosion radius." },
        { str = "D4 - Rerolls the items of any player within the explosion radius." },
        { str = "D8 - Rerolls the stats of any player within the explosion radius." },
        { str = "D20 - Rerolls pickups within the explosion radius." },
        { str = "D100 - Combines the effects of D1, D4, D8 and D20." },
        { str = "Spindown Dice - collectibles will be replaced with the previous internal ID collectible." },
    },
    { -- Trivia
        { str = "Trivia", fsize = 2, clr = 3, halign = 0 },
        { str = "Dice Bombs was an unused idea from Repentance. The concept was mentioned in an AMA by _kilburn." },
    },
    { -- Credits
        { str = "Credits", fsize = 2, clr = 3, halign = 0 },
        { str = "Coded by ratratrat!" },
        { str = "Spritework by Demi!" },
    },
}
Encyclopedia.AddItem({
    ID = LostItemsPack.CollectibleType.DICE_BOMBS,
    WikiDesc = Wiki.DiceBombs,
    Pools = {
        Encyclopedia.ItemPools.POOL_SECRET,
        Encyclopedia.ItemPools.POOL_BOMB_BUM,
    },
    Class = "Lost Items Pack",
    ModName = "Lost Items Pack"
})