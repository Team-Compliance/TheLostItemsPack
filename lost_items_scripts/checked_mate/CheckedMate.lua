local CheckedMateMod = {}
local game = Game()
local Helpers = require("lost_items_scripts.Helpers")

local checkedMateDesc = Isaac.GetItemConfig():GetCollectible(LostItemsPack.CollectibleType.CHECKED_MATE)

-- Main code
local Settings = {
	Cooldown = 15,
	Damage = 20,
	SameSpaceMultiplier = 2,
	BFFmultiplier = 2,
	BFFmoves = 7,
	MaxRange = 20, -- In tiles
}

local States = {
	Idle = 0,
	Jump = 1,
	Moving = 2,
	Land = 3
}

local function ShouldGetNewTargetPosition(entity)
	local data = entity:GetData()
	local room = game:GetRoom()

	return (
		not data.targetGridPosition or
		data.targetGridPosition:Distance(entity.Position) ~= 5 or
		room:GetGridCollisionAtPos(data.targetGridPosition) ~= GridCollisionClass.COLLISION_NONE
	)
end

function CheckedMateMod.GridPathfind(entity, targetPosition, speedLimit)
	local data = entity:GetData()

	if ShouldGetNewTargetPosition(entity) then
		local room = game:GetRoom()
		local entityPosition = Helpers.GridAlignPosition(entity.Position)
		local targetPosition = Helpers.GridAlignPosition(targetPosition)

		local loopingPositions = {targetPosition}
		local indexedGrids = {}

		local index = 0
		while #loopingPositions > 0 do
			local temporaryLoop = {}

			for _, position in pairs(loopingPositions) do
				if room:IsPositionInRoom(position, 0) then
					if room:GetGridCollisionAtPos(position) == GridCollisionClass.COLLISION_NONE or index == 0 then
						local gridIndex = room:GetGridIndex(position)
						if not indexedGrids[gridIndex] then
							indexedGrids[gridIndex] = index

							for i = 1, 8 do
								table.insert(temporaryLoop, position + Vector(40, 0):Rotated(i * 45))
							end
						end
					end
				end
			end
			
			index = index + 1
			loopingPositions = temporaryLoop
		end

		local entityIndex = room:GetGridIndex(entityPosition)
		local index = indexedGrids[entityIndex] or 99999
		local choice = entityPosition

		for i = 1, 8 do
			local position = entityPosition + Vector(40, 0):Rotated(i * 45)
			local positionIndex = room:GetGridIndex(position)
			local value = indexedGrids[positionIndex]

			if value and value <= index then
				index = value
				choice = position
			end
		end

		data.targetGridPosition = choice
	end
end


function CheckedMateMod:checkedMateInit(entity)
	local room = game:GetRoom()
	entity.Position = room:GetGridPosition(room:GetGridIndex(entity.Position))

	entity.State = States.Idle
	entity.FireCooldown = Settings.Cooldown -- Fire cooldown is the move cooldown
	entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
	entity.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
end
LostItemsPack:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, CheckedMateMod.checkedMateInit, LostItemsPack.Entities.CHECKED_MATE.variant)


function CheckedMateMod:checkedMateUpdate(entity)
	local sprite = entity:GetSprite()
	local room = game:GetRoom()
	local bff = entity.Player:HasCollectible(CollectibleType.COLLECTIBLE_BFFS)
	local data = entity:GetData()


	if entity:IsFrame(2, 0) then
		local suffix = ""
		if bff == true then
			suffix = "_bffs"
		end
		for i = 0, sprite:GetLayerCount() do
			sprite:ReplaceSpritesheet(i, "gfx/familiar/checked_mate" .. suffix .. ".png")
		end
		sprite:LoadGraphics()
	end

	entity.Velocity = Vector.Zero


	-- Cooldown
	if entity.State == States.Idle then
		if not sprite:IsPlaying("Idle") then
			sprite:Play("Idle", true)
		end

		if entity.FireCooldown <= 0 then
			entity.State = States.Jump
		else
			entity.FireCooldown = entity.FireCooldown - 1
		end


	-- Jump
	elseif entity.State == States.Jump then
		if not sprite:IsPlaying("Jump") then
			sprite:Play("Jump", true)
		end
		
		if sprite:IsEventTriggered("Jump") then
			entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
			entity.GridCollisionClass = GridCollisionClass.COLLISION_NONE
			SFXManager():Play(SoundEffect.SOUND_SCAMPER, 0.9)

		elseif sprite:IsEventTriggered("Move") then
			entity.State = States.Moving
			
			entity.Keys = 0
			-- Amount of moves it can do
			entity.Coins = 1
			if bff == true then
				entity.Coins = Settings.BFFmoves
			end

			entity:PickEnemyTarget(Settings.MaxRange * 40, 0, 1, Vector.Zero, 0)
			if entity.Target == nil then
				entity.Target = entity.Player
			end
			
			if entity.Target then
				CheckedMateMod.GridPathfind(entity, entity.Target.Position, 3)
			end
			--entity.TargetPosition = room:GetGridPosition(room:GetGridIndex(entity.Position + ((entity.Target.Position - entity.Position):Normalized() * 40)))

			-- Get clamped angle to go in with BFFs extra steps
			entity.OrbitAngleOffset = (entity.Position - data.targetGridPosition):GetAngleDegrees()
			if entity.OrbitAngleOffset >= -22.5 and entity.OrbitAngleOffset <= 22.5 then
				entity.OrbitAngleOffset = 0
			elseif entity.OrbitAngleOffset > 22.5 and entity.OrbitAngleOffset < 67.5 then
				entity.OrbitAngleOffset = 45
			elseif entity.OrbitAngleOffset >= 67.5 and entity.OrbitAngleOffset <= 112.5 then
				entity.OrbitAngleOffset = 90
			elseif entity.OrbitAngleOffset > 112.5 and entity.OrbitAngleOffset < 157.5 then
				entity.OrbitAngleOffset = 135
			elseif entity.OrbitAngleOffset < -22.5 and entity.OrbitAngleOffset > -67.5 then
				entity.OrbitAngleOffset = -45
			elseif entity.OrbitAngleOffset <= -67.5 and entity.OrbitAngleOffset >= -112.5 then
				entity.OrbitAngleOffset = -90
			elseif entity.OrbitAngleOffset < -112.5 and entity.OrbitAngleOffset > -157.5 then
				entity.OrbitAngleOffset = -135
			else
				entity.OrbitAngleOffset = 180
			end
			entity.TargetPosition = room:GetGridPosition(room:GetGridIndex(entity.Position - (Vector.FromAngle(entity.OrbitAngleOffset) * 40)))
		end


	-- Move
	elseif entity.State == States.Moving then
		if not sprite:IsPlaying("Move") then
			sprite:Play("Move", true)
		end
		
		-- Check if it moved above target or if target position is above grid entities
		if entity.Target and entity.Target.Position:Distance(entity.Position) <= 80 then
			entity.Keys = 1
		end
		
		if entity.Position:Distance(entity.TargetPosition) > 2 and room:GetGridCollisionAtPos(entity.TargetPosition) <= 0 then
			entity.Position = (entity.Position + (entity.TargetPosition - entity.Position) * 0.35)
		else
			entity.Coins = entity.Coins - 1
			if entity.Coins <= 0 or entity.Keys == 1 then
				entity.State = States.Land
				entity.Position = room:GetGridPosition(room:GetGridIndex(entity.Position))
			else
				entity.TargetPosition = room:GetGridPosition(room:GetGridIndex(entity.Position - (Vector.FromAngle(entity.OrbitAngleOffset) * 40)))
			end
		end


	-- Land
	elseif entity.State == States.Land then
		if not sprite:IsPlaying("Land") then
			sprite:Play("Land", true)
		end

		if sprite:IsEventTriggered("Land") then
			entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ENEMIES
			entity.GridCollisionClass = GridCollisionClass.COLLISION_SOLID
			SFXManager():Play(SoundEffect.SOUND_FETUS_FEET, 1.2, 0, false, 0.8, 0)

			-- Stomp
			for _,v in pairs(Isaac.GetRoomEntities()) do
				if v.Type > 9 and v.Type < 1000 and v.EntityCollisionClass ~= EntityCollisionClass.ENTCOLL_NONE and v:IsActiveEnemy()
				and room:GetGridPosition(room:GetGridIndex(entity.Position)):Distance(room:GetGridPosition(room:GetGridIndex(v.Position))) <= 80 then
					local multiplier = 1
					if bff == true then
						multiplier = multiplier * Settings.BFFmultiplier
					end
					if room:GetGridPosition(room:GetGridIndex(v.Position)) == room:GetGridPosition(room:GetGridIndex(entity.Position)) then
						multiplier = multiplier * Settings.SameSpaceMultiplier
					end

					v:TakeDamage(Settings.Damage * multiplier, DamageFlag.DAMAGE_CRUSH | DamageFlag.DAMAGE_IGNORE_ARMOR, EntityRef(entity), 0)
					if v:HasMortalDamage() then
						v:AddEntityFlags(EntityFlag.FLAG_EXTRA_GORE)
					end
				end
			end

		elseif sprite:IsEventTriggered("Move") then
			entity.State = States.Idle
			entity.FireCooldown = Settings.Cooldown
		end
	end
end
LostItemsPack:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, CheckedMateMod.checkedMateUpdate, LostItemsPack.Entities.CHECKED_MATE.variant)


function CheckedMateMod:checkedMateNewRoom()
	for i, f in pairs(Isaac.GetRoomEntities()) do
		if f.Type == EntityType.ENTITY_FAMILIAR and f.Variant == LostItemsPack.Entities.CHECKED_MATE.variant then
			local room = game:GetRoom()
			f.Position = room:GetGridPosition(room:GetGridIndex(f:ToFamiliar().Player.Position))

			f:ToFamiliar().State = States.Idle
			f:ToFamiliar().FireCooldown = 0
			f.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ENEMIES
			f.GridCollisionClass = GridCollisionClass.COLLISION_SOLID
		end
	end
end
LostItemsPack:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, CheckedMateMod.checkedMateNewRoom)



function CheckedMateMod:checkedMateCheck(player)
	local numFamiliars = player:GetCollectibleNum(LostItemsPack.CollectibleType.CHECKED_MATE) + player:GetEffects():GetCollectibleEffectNum(LostItemsPack.CollectibleType.CHECKED_MATE)
	
	player:CheckFamiliar(LostItemsPack.Entities.CHECKED_MATE.variant, numFamiliars, player:GetCollectibleRNG(LostItemsPack.CollectibleType.CHECKED_MATE), checkedMateDesc)	
end
LostItemsPack:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, CheckedMateMod.checkedMateCheck, CacheFlag.CACHE_FAMILIARS)
