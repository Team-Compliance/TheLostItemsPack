if not MiniMapiItemsAPI then return end

local frame = 1
local pillcrusherIcon = Sprite()
pillcrusherIcon:Load("gfx/ui/minimapitems/pillcrusher_icon.anm2", true)
MiniMapiItemsAPI:AddCollectible(CollectibleType.COLLECTIBLE_PILL_CRUSHER, pillcrusherIcon, "CustomIconPillCrusher", frame)