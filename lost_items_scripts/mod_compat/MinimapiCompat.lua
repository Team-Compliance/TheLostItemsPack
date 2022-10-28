if not MiniMapiItemsAPI then return end

local frame = 1
local minimapiIconsSprite = Sprite()
minimapiIconsSprite:Load("gfx/ui/minimapitems/lost_items_pack_icons.anm2", true)

--Ancient Revelation
MiniMapiItemsAPI:AddCollectible(LostItemsPack.CollectibleType.ANCIENT_REVELATION, minimapiIconsSprite, "CustomIconAncientRevelation", frame)

--Beth's Heart
MiniMapiItemsAPI:AddCollectible(LostItemsPack.CollectibleType.BETHS_HEART, minimapiIconsSprite, "CustomIconBethsHeart", frame)

--Blank Bombs
MiniMapiItemsAPI:AddCollectible(LostItemsPack.CollectibleType.BLANK_BOMBS, minimapiIconsSprite, "CustomIconBlankBombs", frame)

--Checked Mate
MiniMapiItemsAPI:AddCollectible(LostItemsPack.CollectibleType.CHECKED_MATE, minimapiIconsSprite, "CustomIconCheckedMate", frame)

--Lucky Seven
MiniMapiItemsAPI:AddCollectible(LostItemsPack.CollectibleType.LUCKY_SEVEN, minimapiIconsSprite, "CustomIconLuckySeven", frame)

--Pill Crusher
MiniMapiItemsAPI:AddCollectible(LostItemsPack.CollectibleType.PILL_CRUSHER, minimapiIconsSprite, "CustomIconPillCrusher", frame)