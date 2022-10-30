local Helpers = require "lost_items_scripts.Helpers"
local PacifistMod = {}
local game = Game()

LostItemsPack.CallOnLoad[#LostItemsPack.CallOnLoad+1] = function ()
	LostItemsPack.PersistentData.PacifistLevels = {}
end

local SpecialRoomPickups = {
	[RoomType.ROOM_TREASURE] = PickupVariant.PICKUP_LOCKEDCHEST,
	[RoomType.ROOM_SHOP] = PickupVariant.PICKUP_LOCKEDCHEST,
	[RoomType.ROOM_PLANETARIUM] = PickupVariant.PICKUP_LOCKEDCHEST,
	[RoomType.ROOM_DICE] = PickupVariant.PICKUP_LOCKEDCHEST,
	[RoomType.ROOM_CHEST] = PickupVariant.PICKUP_LOCKEDCHEST,

	[RoomType.ROOM_CURSE] = PickupVariant.PICKUP_REDCHEST,
	[RoomType.ROOM_DEVIL] = PickupVariant.PICKUP_REDCHEST,

	[RoomType.ROOM_CHALLENGE] = PickupVariant.PICKUP_BOMBCHEST,

	[RoomType.ROOM_SACRIFICE] = PickupVariant.ROOM_SACRIFICE,

	[RoomType.ROOM_LIBRARY] = PickupVariant.PICKUP_WOODENCHEST,
	[RoomType.ROOM_ISAACS] = PickupVariant.PICKUP_WOODENCHEST,

	[RoomType.ROOM_ANGEL] = PickupVariant.PICKUP_ETERNALCHEST,
}

local HasSelectedPickups = false
local PickupsToSpawn = {}

local function GetPacifistLevel()
	local level = game:GetLevel()

	for _, pacifistLevel in ipairs(LostItemsPack.PersistentData.PacifistLevels) do
		if pacifistLevel.stage == level:GetStage() and
		pacifistLevel.ascent == level:IsAscent() then
			return pacifistLevel
		end
	end

	LostItemsPack.PersistentData.PacifistLevels[#LostItemsPack.PersistentData.PacifistLevels+1] = {
		stage = level:GetStage(),
		ascent = level:IsAscent()
	}

	return LostItemsPack.PersistentData.PacifistLevels[#LostItemsPack.PersistentData.PacifistLevels]
end


function PacifistMod:PacifistEffect(player)
	if not player:HasCollectible(LostItemsPack.CollectibleType.PACIFIST) then return end
	if HasSelectedPickups then return end
	local sprite = player:GetSprite()
	if not sprite:IsPlaying("Trapdoor") then return end

	HasSelectedPickups = true

	local level = game:GetLevel()
	local rooms = level:GetRooms()

	for i = 0, rooms.Size - 1 do
		local roomDesc = rooms:Get(i)
		local roomData = roomDesc.Data
		local roomType = roomData.Type

		local pickupToSpawn = SpecialRoomPickups[roomType]

		if (roomType == RoomType.ROOM_SECRET or roomType == RoomType.ROOM_SUPERSECRET or
		roomType == RoomType.ROOM_ULTRASECRET) and roomDesc.DisplayFlags > 0 then
			pickupToSpawn = PickupVariant.PICKUP_OLDCHEST
		end

		if not pickupToSpawn then
			pickupToSpawn = PickupVariant.PICKUP_NULL
		end

		if not roomDesc.Clear then
			PickupsToSpawn[#PickupsToSpawn+1] = pickupToSpawn
		end
	end

	local pacifistLevel = GetPacifistLevel()

	if pacifistLevel.HasSpawnedAngel then
		local roomDesc = level:GetRoomByIdx(GridRooms.ROOM_DEVIL_IDX)

		if not roomDesc.Clear then
			PickupsToSpawn[#PickupsToSpawn+1] = PickupVariant.PICKUP_ETERNALCHEST
		end
	end

	if pacifistLevel.HasSpawnedDevil then
		local roomDesc = level:GetRoomByIdx(GridRooms.ROOM_DEVIL_IDX)

		if not roomDesc.Clear then
			PickupsToSpawn[#PickupsToSpawn+1] = PickupVariant.PICKUP_REDCHEST
		end
	end

	if pacifistLevel.HasSpawnedCrawlSpace then
		local roomDesc = level:GetRoomByIdx(GridRooms.ROOM_DUNGEON_IDX)

		if not roomDesc.Clear then
			PickupsToSpawn[#PickupsToSpawn+1] = PickupVariant.PICKUP_HAUNTEDCHEST
		end
	end
end
LostItemsPack:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, PacifistMod.PacifistEffect)


function PacifistMod:OnUpdate()
	local room = game:GetRoom()
	for doorSlot = 0, DoorSlot.NUM_DOOR_SLOTS, 1 do
		---@diagnostic disable-next-line: param-type-mismatch
		local door = room:GetDoor(doorSlot)

		if door then
			local isDealRoom = door.TargetRoomIndex == GridRooms.ROOM_DEVIL_IDX
			local isAngelRoom = door.TargetRoomType == RoomType.ROOM_ANGEL
			local isDevilRoom = door.TargetRoomType == RoomType.ROOM_DEVIL

			if isDealRoom then
				local pacifistLevel = GetPacifistLevel()
				
				if isAngelRoom then
					pacifistLevel.HasSpawnedAngel = true
				end

				if isDevilRoom then
					pacifistLevel.HasSpawnedDevil = true
				end
			end
		end
	end

	for i = 0, room:GetGridSize(), 1 do
		local gridEntity = room:GetGridEntity(i)

		if gridEntity and
		gridEntity:GetType() == GridEntityType.GRID_STAIRS and
		gridEntity:GetVariant() == 0 then
			local pacifistLevel = GetPacifistLevel()
			pacifistLevel.HasSpawnedCrawlSpace = true
		end
	end
end
LostItemsPack:AddCallback(ModCallbacks.MC_POST_UPDATE, PacifistMod.OnUpdate)


function PacifistMod:PickupsDrop() -- Spawn pickups every level after pickup
	if #PickupsToSpawn <= 0 then return end

	local pacifistPlayer
	for i = 0, game:GetNumPlayers() - 1 do
		local player = game:GetPlayer(i)

		if player:HasCollectible(LostItemsPack.CollectibleType.PACIFIST) then
			SFXManager():Play(SoundEffect.SOUND_THUMBSUP, 1, 0)
			player:AnimateHappy()
			pacifistPlayer = player
		end
	end

	if not pacifistPlayer then return end

	for _, pickupVariant in ipairs(PickupsToSpawn) do
		local subtype = ChestSubType.CHEST_CLOSED

		if pickupVariant == PickupVariant.PICKUP_NULL then
			subtype = 2
		end

		local spawningPos = game:GetRoom():FindFreePickupSpawnPosition(pacifistPlayer.Position, 0, true)

		Isaac.Spawn(EntityType.ENTITY_PICKUP, pickupVariant, subtype, spawningPos, Vector.Zero, pacifistPlayer)
	end

	PickupsToSpawn = {}
	HasSelectedPickups = false
end
LostItemsPack:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, PacifistMod.PickupsDrop)