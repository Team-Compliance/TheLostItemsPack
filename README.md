# TheLostItemsPack

Items included:
- Ancient Revelation --done
- Beth's Heart --done
- Blank Bombs --done
- Book of Illusions/Illusion Hearts --done
- Checked Mate --done
- Keeper's Rope --done
- Lucky Seven --done
- Pacifist --done
- Pill Crusher --done
- Safety Bombs --done
- Voodoo Pin --done
- Dice Bombs --done
  - Salt Shaker?
  - Lunch Box?

? = maybe

Dice Bombs API:
- First, check if The Lost Items Pack are enabled:
  - if LostItemsPack then
      --your code
    end
- Second, you need to add your dice using DiceBombs.AddDice(diceID, gfxNormal, gfxGolden)
  - diceID - ID of dice
  - gfxNormal (optional) - full path to gfx for that dice bomb
  - gfxGolden (optional) - full path to gfx for that dice bomb when player has golden bomb
  - if gfxNormal and gfxGolden are empty or not string value, bomb will use default modded bomb gfx
- Then you add ON_DICE_BOMB_EXPLOSION callback:
  - yourmod:AddCallback(LostItemsPack.Callbacks.ON_DICE_BOMB_EXPLOSION, function(_, bomb, player, radius)
          --your code
    end, diceID)
      - bomb - bomb entity
      - player - player, that placed that bomb
      - radius - supposed area of effect (you can ignore and set your area of effect)
  - you HAVE TO add diceID or that callback won't run
  - returning true will also activate D6 effect
  
(To-do) Item tweaks:
- Safety Bombs = synergies
  - Abyss synergy
  - Sticky Bombs synergy = Enemies that go within the radius of bombs get the slowness effect --done
  - Hot Bombs synergy = Enemies that go within the radius of bombs get the burn effect --done
  - Bob's Curse synergy = Enemies that go within the radius of bombs get the poison effect --done
  - Butt Bombs synergy = Enemies that go within the radius of bombs get confusion --done
  - Nancy Bombs synergy = The Safety Bombs effect is in the Nancy Bombs effect pool --done
- Keeper's Rope = decrease the coin despawn time to more closely match Tainted Keeper --done
- Pacifist = interactions with special rooms to make it more viable --done
	- Skipping Treasure Rooms, Shops, Planetariums, Vaults, and/or Dice Rooms gives you a golden chest on the next floor --done
	- Skipping Curse Rooms and/or Devil Deal Rooms gives you a red chest on the next floor --done
	- Skipping Normal/Boss Challenge Rooms gives you a stone chest on the next floor --done
	- Skipping Sacrifice Rooms gives you a Spiked Chest on the next floor --done
	- Skipping Libraries and/or Bedrooms gives you a Wooden Chest on the next floor --done
	- Skipping Angel Rooms gives you an Eternal Chest on the next floor --done
	- Skipping Secret Rooms, Super Secret Rooms, and/or Ultra Secret Rooms gives you an Old Chest on the next floor (if you open the rooms but don’t go inside of it) --done
	- Skipping Crawl Spaces gives you a Haunted Chest on the next floor --done
- Blank Bombs = damage decrease to 25% with golden bombs --done
- Illusion Hearts = polish, clones don't have visible HP, poofing sfx when they disappear. Also maybe a Bethany interaction where picking up illusion hearts spawns a special wisp
- Checked Mate = RC Remote synergy --done
- Voodoo Pin = visual polish

(To-do) Misc:
- MCM or DSS options to allow people to disable items they don't like
- Make things global so that other modders can use them