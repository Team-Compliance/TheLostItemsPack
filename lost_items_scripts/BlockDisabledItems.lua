local BlockDisabledItems = {}


function BlockDisabledItems:OnGameStart(isContinue)
    if isContinue then return end

    local itemPool = Game():GetItemPool()

    for _, disabledItem in ipairs(LostItemsPack.RunPersistentData.DisabledItems) do
        itemPool:RemoveCollectible(disabledItem)
    end
end
LostItemsPack:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, BlockDisabledItems.OnGameStart)


-- function BlockDisabledItems:PostGetCollectible(selectedItem, poolType, decrease, seed)
--     local isDisabledItem = false

--     for _, disabledItem in ipairs(LostItemsPack.RunPersistentData.DisabledItems) do
--         if selectedItem == disabledItem then
--             isDisabledItem = true
--             break
--         end
--     end

--     if not isDisabledItem then return end

--     local itemPool = Game():GetItemPool()

--     local rng = RNG()
--     rng:SetSeed(seed, 35)

--     return itemPool:GetCollectible(poolType, decrease, rng:Next())
-- end
-- LostItemsPack:AddCallback(ModCallbacks.MC_POST_GET_COLLECTIBLE, BlockDisabledItems.PostGetCollectible)