local PacifistMod = {}
local game = Game()

local PickupsToSpawn = 0
local ChestsToSpawn = 0

function PacifistMod:PacifistEffect(player)
	local sprite = player:GetSprite()
	if player:HasCollectible(LostItemsPack.CollectibleType.PACIFIST) and sprite:IsPlaying("Trapdoor") then
		if PickupsToSpawn == 0 then
			local level = game:GetLevel()
			local rooms = level:GetRooms()
			for i = 0, rooms.Size - 1 do
				local room = rooms:Get(i)
				if room.Data.Type ~= RoomType.ROOM_SUPERSECRET and room.Data.Type ~= RoomType.ROOM_ULTRASECRET then -- based off of world card which doesn't reveal these
					if not room.Clear then
						PickupsToSpawn = PickupsToSpawn + 1
						if room.Data.Type == RoomType.ROOM_SHOP or room.Data.Type == RoomType.ROOM_TREASURE then
							ChestsToSpawn = ChestsToSpawn + 1
							PickupsToSpawn = PickupsToSpawn - 1
						end
					end
				end
			end
		end
	end
end
LostItemsPack:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, PacifistMod.PacifistEffect)


function PacifistMod:PickupsDrop() -- Spawn pickups every level after pickup
	for p = 0, game:GetNumPlayers() - 1 do
		local player = game:GetPlayer(p)
		if player:HasCollectible(LostItemsPack.CollectibleType.PACIFIST) then
			if PickupsToSpawn > 0 then
				SFXManager():Play(SoundEffect.SOUND_THUMBSUP, 1, 0)
				player:AnimateHappy()
			end

			for _ = 1, PickupsToSpawn do
				Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_NULL, 2, game:GetRoom():FindFreePickupSpawnPosition(player.Position, 0, true), Vector.Zero, player)
			end
			-- Guaranteed Golden Chests if you skip a Treasure or Shop room
			for _ = 1, ChestsToSpawn do
				Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_LOCKEDCHEST, ChestSubType.CHEST_CLOSED, game:GetRoom():FindFreePickupSpawnPosition(player.Position, 0, true), Vector.Zero, player)
			end
		end
	end
	PickupsToSpawn = 0
	ChestsToSpawn = 0
end
LostItemsPack:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, PacifistMod.PickupsDrop)