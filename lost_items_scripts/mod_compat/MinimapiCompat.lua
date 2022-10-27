if not MiniMapiItemsAPI then return end

local frame = 1
local minimapiIconsSprite = Sprite()
minimapiIconsSprite:Load("gfx/ui/minimapitems/lost_items_pack_icons.anm2", true)

--Lucky seven
MiniMapiItemsAPI:AddCollectible(LostItemsPack.CollectibleType.BLANK_BOMBS, minimapiIconsSprite, "CustomIconBlankBombs", frame)

--Lucky seven
MiniMapiItemsAPI:AddCollectible(LostItemsPack.CollectibleType.LUCKY_SEVEN, minimapiIconsSprite, "CustomIconLuckySeven", frame)

--Pill crusher
MiniMapiItemsAPI:AddCollectible(LostItemsPack.CollectibleType.PILL_CRUSHER, minimapiIconsSprite, "CustomIconPillCrusher", frame)