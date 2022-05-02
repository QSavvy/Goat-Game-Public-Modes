---@type mode
local mode = ...
mode.name = "CTF"
mode.author = "Dingus"
-- Team Death Match Gamemode with 2 teams, flags.
-- lord help you if you actually read through this
-- i am proud of it tho
--hi


-- GLOBAL VARIABLES/ STUFF
local redscore = 0
local bluescore = 0 



local setupgame
local respawntimer = 0
local deathmessages = { -- death messages for death idk
    "died",
	"got shot",
	"died",
	"died",
	"failed",
	"was killed",
	"didnt survive that",
	"is dead",
	"got shidded on",
	"crashed their car",
}

-------------------------



-- FUNCTIONS I NEED -----------------
local function makeblockwall(x, y, z, orientation) -- will make a wall you cant walk through, orientation should be "orientations.n" or some other orientation rot matrix
    local blockwall = items.create(itemTypes[43], Vector(x, y, z), orientation)
	local blockwalltwo = items.create(itemTypes[43], Vector(x, y + 1, z), orientation)
    blockwall.isStatic = true
    blockwall.hasPhysics = true
	blockwalltwo.isStatic = true
	blockwalltwo.hasPhysics = true
end

local function makeblueflag() --makes the blue flag
	local blueflag = items.create(itemTypes[21], Vector(1040, 25, 1128), orientations.n)
	local boxstand = items.create(itemTypes[37], Vector(1040, 24.5, 1128), orientations.n)
	local boxstand2 = items.create(itemTypes[37], Vector(1040, 25.5, 1128), orientations.n)
	local boxstand3 = items.create(itemTypes[37], Vector(1040, 25.9, 1128), orientations.n)
	blueflag.data.blueflag = true
	blueflag.isStatic = true
	blueflag.hasPhysics = false
	blueflag.data.hasspoke = false
	blueflag.data.rotation = 90 -- increase this whenever you want to rotate it, in degrees
	blueflag.rot:set((pitchToRotMatrix(blueflag.data.rotation * math.pi / 180)))
	boxstand.isStatic = true
	boxstand.hasPhysics = false
	boxstand2.isStatic = true
	boxstand2.hasPhysics = false
	boxstand3.isStatic = true
	boxstand3.hasPhysics = false
end

local function makeredflag() -- makes the blue fl JUST KIDDING ITS THE RED FLAG HAHA
	local redflag = items.create(itemTypes[24], Vector(1464, 25, 1128), orientations.n)
	local boxstand = items.create(itemTypes[37], Vector(1464, 24.5, 1128), orientations.n)
	local boxstand2 = items.create(itemTypes[37], Vector(1464, 25.5, 1128), orientations.n)
	local boxstand3 = items.create(itemTypes[37], Vector(1464, 25.9, 1128), orientations.n)
	redflag.data.redflag = true
	redflag.isStatic = true
	redflag.hasPhysics = false
	redflag.data.hasspoke = false
	redflag.data.rotation = 90 -- increase this whenever you want to rotate it, in degrees
	redflag.rot:set((pitchToRotMatrix(redflag.data.rotation * math.pi / 180)))
	boxstand.isStatic = true
	boxstand.hasPhysics = false
	boxstand.isStatic = true
	boxstand.hasPhysics = false
	boxstand2.isStatic = true
	boxstand2.hasPhysics = false
	boxstand3.isStatic = true
	boxstand3.hasPhysics = false
end

local function makecars() -- makes two cars in each teams spawn when called
	local carone = vehicles.create(vehicleTypes.getByName("Van"), Vector(1024, 26, 1237), orientations.e, 2) -- blue team
	local cartwo = vehicles.create(vehicleTypes.getByName("Town Car"), Vector(1024, 26, 1224), orientations.e, 2)
	local carthree = vehicles.create(vehicleTypes.getByName("Hatchback"), Vector(1031, 26, 1230), orientations.e, 2)


	local carsix = vehicles.create(vehicleTypes.getByName("Van"), Vector(1480, 26, 1018), orientations.w, 1) -- red team
	local carfive = vehicles.create(vehicleTypes.getByName("Hatchback"), Vector(1482, 26, 1024), orientations.w, 1)
	local carfour = vehicles.create(vehicleTypes.getByName("Town Car"), Vector(1484, 26, 1031), orientations.w, 1)

	carone.data.timer = 0
	cartwo.data.timer = 0
	carthree.data.timer = 0
	carfour.data.timer = 0
	carfive.data.timer = 0
	carsix.data.timer = 0
end


function mode.onEnable(isReload)
	tick = 0
	second = 0
	minute = 0
	server.type = TYPE_ROUND

end


function mode.hooks.ResetGame(reason)
	tick = 0
	second = 0
	minute = 0
	math.randomseed(os.time())
    server.state = 1
    server.time = 3600
	setupgame = false
    gameStarting = false
	respawntimer = 0
	server.roundTeamDamage = 100
	server.type = TYPE_ROUND
	for _, ply in ipairs(players.getAll()) do
		ply.data.hasdied = nil
	end
end


------------------------

function mode.hooks.Logic()
    server.time = server.time - 1
	server.roundTeamDamage = 100

    tick = tick + 1

    if server.time == 0 then -- round time handling
		if server.state == 1 then
			server.state = 2
			server.time = 25155 --7250 is 2 mins
			server.sunTime = (math.random(8, 17) * 60 * 60 * 62.5)  -- random time between 9 am and 7pm
		elseif server.state == 2 then
			if not gameEnding then -- ROUND ENDING
				gameEnding = true
				events.createMessage(0, "Round over.", -1, 2)
				server.time = 600
			else
                gameEnding = false
				server:reset()
				server.time = 3600
				end
			end
		end


    if tick == 60 then-- tick stuff
		tick = 0
		second = second + 1
		if second == 60 then
			second = 0
			minute = minute + 1
		end
	end



------------------------------------------------ taken from GG
	if tick == 59 then
		for _, man in ipairs(humans.getAll()) do
			-- if man.player.isAdmin == true then
			-- 	man.data.timer = 20 
			-- end

			if not man.vehicle then
				man.data.timer = 0
			else
			if man.vehicle then
				man.data.timer = man.data.timer + 1
			end
			if man.data.timer >= 20 and man.data.hassaidboost == nil and man.vehicleSeat == 0 then
				man.data.timer = 20
				man.data.canboost = true
				man:speak("Boost ready", 0)
				man.data.hassaidboost = true
				events.createSound(28, man.pos, 1, 3)
				end
			end
		end
	end

	for _, man in ipairs(humans.getAll()) do
		
		if not man.player then  -- remove dead bodies
			man:remove()
		end


		if man.isBleeding == true then -- no more bleeding
			man.isBleeding = false
		end

		if man.data.timer == 18 and man.data.has8 == nil and man.vehicleSeat == 0 then --boost 8 beep
			events.createSound(28, man.vehicle.pos, 1, 1)
			man.data.has8 = true
		end

		if man.data.timer == 19 and man.data.has9 == nil and man.vehicleSeat == 0 then --boost 9 beep
			events.createSound(28, man.vehicle.pos, 1, 2)
			man.data.has9 = true
		end

		if man.vehicle and bit32.band(man.inputFlags, 16) == 16 and man.data.canboost and man.vehicle.health > 0 and man.vehicleSeat == 0 then --boost
			man.vehicle.rigidBody.vel:add(-((man.vehicle.rigidBody.rot:getRight())/2))
			--man.vehicle.rigidBody.vel:add(((man.vehicle.rigidBody.rot:getUp())/10))
			man.data.canboost = nil
			man.data.timer = 0
			man.data.hassaidboost = nil
			man.vehicle.health = 100  --commented out for now
			man.data.has8 = nil
			man.data.has9 = nil
			events.createExplosion(man.vehicle.pos) --creates an explosion that doesnt do damage, the code below just does the explosion sound, no longer needed!
			--events.createSound(48, man.vehicle.pos, 1, 3)
		end
	end

--CAR CRASH SYSTEM
	-- REWRITTEN --
	for _, veh in ipairs(vehicles.getAll()) do --remove dead cars after 30 seconds

		if veh.health <= 1 and tick == 49 then
			veh.data.timer = veh.data.timer + 1
		end

		if veh.data.timer == 30 and veh.type ~= vehicleTypes.getByName("Helicopter") then
			veh:remove()
		end

		if veh.type ~= vehicleTypes.getByName("Helicopter") then
			if veh.data.lastHealth ~= nil then
				if math.abs(veh.data.lastHealth - veh.health) > 40 then -- Car has crashed.
			   -- Breaks windows and creates a sound.
					veh:updateDestruction(0, 0, veh.pos, veh.vel)
					events.createSound(25, veh.pos, 1, 1)
					events.createSound(48, veh.pos, 1, 1)
					local bonebreak = math.random(1,2)
					for _, man in ipairs(humans.getAll()) do
						if man.vehicle == veh then -- This human is inside the crashing car.
							man.data.fling = veh.data.lastVel
							man.vehicle = nil
							man.damage = 60
							if bonebreak == 1 then
								man:applyDamage(math.random(0,15), math.random(50,100))
								local secondbone = math.random(0,1)
								if secondbone == 0 and bonebreak == 1 then
									man:applyDamage(math.random(0,15), math.random(50,100))
								end
							end
							man:addVelocity(Vector(man.data.fling.x * 2, math.abs(man.data.fling.y)/4, man.data.fling.z * 2))
						end
					end
				end
			end
		end
	  -- Fills the lastHealth variable.
		veh.data.lastVel = veh.vel
		veh.data.lastHealth = veh.health

	end

-----------------------------







    local readyCount = 0 -- readying up
	for _, ply in ipairs(players.getAll()) do
		ply.teamSwitchTimer = 0
		if ply.human == nil and server.state == 2 and ply.data.hasdied == nil and ply.team ~= nil then
			if ply.team == 0 then
				local man = humans.create(Vector(1496, 26, math.random(1038, 1012)), orientations.w, ply)
				man.suitColor = 8
				man.model = 1
				man.player.data.saiddeath = false
				if ply.account.data.weaponSelectionNum == nil then
					local wID = math.random(6) * 2 - 1
					man:arm(wID, 6)
					man.player:sendMessage("The blue flag is at the end of the middle road.")
					man.player:sendMessage("You are RED TEAM!!!")
					local bandage = items.create(itemTypes[13], man.pos, orientations.s)
					man:mountItem(bandage, 6)
					man.player.data.deathtimer = 10
				elseif ply.account.data.weaponSelectionNum ~= nil then
					local wID = ply.account.data.weaponSelectionNum
					man:arm(wID, 6)
					man.player:sendMessage("The blue flag is at the end of the middle road.")
					man.player:sendMessage("You are RED TEAM!!!")
					local bandage = items.create(itemTypes[13], man.pos, orientations.n)
					man:mountItem(bandage, 6)
					man.player.data.deathtimer = 10
				end
			elseif ply.team == 1 then
				local man = humans.create(Vector(1011, 25, math.random(1219, 1243)), orientations.e, ply)
				man.suitColor = 4
				man.model = 1
				man.player.data.saiddeath = false
				if ply.account.data.weaponSelectionNum == nil then
					local wID = math.random(6) * 2 - 1
					man:arm(wID, 6)
					man.player:sendMessage("The red flag is at the end of the middle road.")
					man.player:sendMessage("You are BLUE TEAM!!!")
					local bandage = items.create(itemTypes[13], man.pos, orientations.w)
					man:mountItem(bandage, 6)
					man.player.data.deathtimer = 10
				elseif ply.account.data.weaponSelectionNum ~= nil then
					local wID = ply.account.data.weaponSelectionNum
					man:arm(wID, 6)
					man.player:sendMessage("The red flag is at the end of the middle road.")
					man.player:sendMessage("You are BLUE TEAM!!!")
					local bandage = items.create(itemTypes[13], man.pos, orientations.w)
					man:mountItem(bandage, 6)
					man.player.data.deathtimer = 10
				end
			else
				if ply.team ~= 0 and ply.team ~= 1 then
					local fiftyfifty = math.random(0, 100)
					ply:sendMessage("Sorry, only Gold or Mons!")
					ply:sendMessage("You've been randomly assigned a team")
					if fiftyfifty >= 50 then
						ply.team = 1
						ply:update()
					elseif fiftyfifty < 50 then
						ply.team = 0
						ply:update()
					end
				end
			end
		end

		-- If player is ready, add 1 to readyCount
		if ply.isReady then
			readyCount = readyCount + 1
		end
		if ply.data.hasdied ~= true and server.state == 2 then -- sets that ppl cant respawn until the respawn timer happens (see below)
			if ply.human and ply.human.isAlive == false then
				ply.data.hasdied = true
			end
		end

	end









	----------------- RESPAWN TIMER
	for _, itm in ipairs(items.getAll()) do
		if itm.type == itemTypes[36] and itm.physicsSettled ~= false then -- prevents ropes from being settled
			itm.physicsSettled = false
		end
	end

	if tick == 59 and server.state == 2 then 
		respawntimer = respawntimer + 1
	end

	if respawntimer == 45 then
		for _, ply in ipairs(players.getAll()) do
			if ply.data.hasdied == true and ply.human == nil then
				ply.data.hasdied = nil
			end
			ply:sendMessage("Both teams respawned!")
		end

		for _, itm in ipairs(items.getAll()) do -- remove all physics settled items EXCEPT DISKS, WALLS, etc
			if itm.type ~= itemTypes[21] and itm.type ~= itemTypes[24] and itm.type ~= itemTypes[14] and itm.type ~= itemTypes[43] and itm.type ~= itemTypes[13] and itm.type ~= itemTypes[37] and itm.type ~= itemTypes[36] and itm.physicsSettled == true then
				itm:remove()
			end
		end



		for _, veh in ipairs(vehicles.getAll()) do --removes veh's in spawn so they dont stack
			if isVectorInCuboid(veh.pos, Vector(1496.97, 50, 1013.85), Vector(1465, 20, 1038)) or isVectorInCuboid(veh.pos, Vector(1012.34, 50, 1243), Vector(1037, 20, 1218.68)) then
				veh:remove()
			end
		end

		makecars()
		
		respawntimer = 0
	end
	if respawntimer == 30 and tick == 30 then 
		for _, ply in ipairs(players.getAll()) do
			if not ply.human then
				ply:sendMessage("You will respawn in 15 seconds.")
			end
		end
	end




	----------------------------

	if readyCount >= players.getCount() * 0.5 and not gameStarting then
		gameStarting = true
		for _, ply in ipairs(players.getAll()) do
			ply:sendMessage("Select your weapon with /weapon!")
			ply:sendMessage("Type /goat to respawn!")
			ply:sendMessage(" ")
			ply:sendMessage("Join the Discord! discord.gg/JzbvtVTBFv")
		end
		if server.time > 300 then
			server.time = 300
		end
	end
	---------------------- respawn stuff

	for _, man in ipairs(humans.getAll()) do

		if server.state == 2 and man.isAlive == true and man.suitColor == 8 then -- if red team is in blue
			if isVectorInCuboid(man.pos, Vector(1007.91, 50, 1247.73), Vector(1040.22, 20, 1213.65)) and (tick % 2) == 0 then
				if man.vehicle ~= nil then
					man.vehicle:remove()
				end
				man:speak("Too close to enemy spawn", 0)
				man.isAlive = false
			end
		end

		if server.state == 2 and man.isAlive == true and man.suitColor == 4 then -- if blue team is in red
			if isVectorInCuboid(man.pos, Vector(1465, 20, 1038), Vector(1499.66, 50, 1012.48)) and (tick % 2) == 0  then
				if man.vehicle ~= nil then
					man.vehicle:remove()
				end
				man:speak("Too close to enemy spawn", 0)
				man.isAlive = false
			end
		end


		if not isVectorInCuboid(man.pos, Vector(1504.77, 400, 1005.17), Vector(982.50, 22.89, 1300.50)) and tick == 59 and man.isAlive == true and man.player.isAdmin ~= true then --death timer
			man.player.data.deathtimer = man.player.data.deathtimer - 1
			man:speak("Out of bounds!", 0)
			man:speak(string.format("%s warnings left!!", man.player.data.deathtimer), 0)
		end

		if man.player ~= nil and man.player.data.deathtimer == 0 and man.isAlive then
			man.isAlive = false
		end
		man.stamina = 127 -- inf stamina
		if man.progressBar == 255 then -- bandage stuff
			man.chestHP = 100
			man.headHP = 100
			man.leftArmHP = 100
			man.rightArmHP = 100
			man.leftLegHP = 100
			man.rightLegHP = 100
			man.bloodLevel = 100
			man.damage = 0
		end

	end


	------------setting up game shit!!!
	if setupgame ~= true and server.state == 2 then
		makecars()
		makeblueflag()
		makeredflag()
		
		
		-- red spawn wall
		
		makeblockwall(1499, 24.5, 1038, orientations.s) -- look I know this could be done with a for loop, but what ever.
		makeblockwall(1497, 24.5, 1038, orientations.s)
		makeblockwall(1495, 24.5, 1038, orientations.s)
		makeblockwall(1493, 24.5, 1038, orientations.s)
		makeblockwall(1491, 24.5, 1038, orientations.s)
		makeblockwall(1489, 24.5, 1038, orientations.s)


		-- blue spawn wall 

		makeblockwall(1008, 24.5, 1218, orientations.s) -- look I know this could be done with a for loop, but what ever.
		makeblockwall(1010, 24.5, 1218, orientations.s)
		makeblockwall(1012, 24.5, 1218, orientations.s)
		makeblockwall(1014, 24.5, 1218, orientations.s)
		makeblockwall(1016, 24.5, 1218, orientations.s)
		makeblockwall(1018, 24.5, 1218, orientations.s)



		-- red barrier wall
		makeblockwall(1504.14, 24.5, 1140.72, orientations.w)
		makeblockwall(1504.14, 24.5, 1138, orientations.w)
		makeblockwall(1504.14, 24.5, 1136, orientations.w)
		makeblockwall(1504.14, 24.5, 1134, orientations.w)
		makeblockwall(1504.14, 24.5, 1132, orientations.w)
		makeblockwall(1504.14, 24.5, 1130, orientations.w)
		makeblockwall(1504.14, 24.5, 1128, orientations.w)
		makeblockwall(1504.14, 24.5, 1126, orientations.w)
		makeblockwall(1504.14, 24.5, 1124, orientations.w)
		makeblockwall(1504.14, 24.5, 1122, orientations.w)
		makeblockwall(1504.14, 24.5, 1120, orientations.w)
		makeblockwall(1504.14, 24.5, 1118, orientations.w)
		makeblockwall(1504.14, 24.5, 1116, orientations.w)
		makeblockwall(1504.14, 24.5, 1115, orientations.w)

		-- blue spawn camp wall parking lot
		makeblockwall(1128.26, 24.5, 1248, orientations.s)
		makeblockwall(1130, 24.5, 1248, orientations.s)
		makeblockwall(1132.26, 24.5, 1248, orientations.s)
		makeblockwall(1134.26, 24.5, 1248, orientations.s)
		makeblockwall(1136.26, 24.5, 1248, orientations.s)
		makeblockwall(1138.26, 24.5, 1248, orientations.s)
		makeblockwall(1140.26, 24.5, 1248, orientations.s)
		makeblockwall(1142.26, 24.5, 1248, orientations.s)
		makeblockwall(1143.26, 24.5, 1248, orientations.s)
		




		setupgame = true
	end
	------------------------------------------

	for _, itm in ipairs(items.getAll()) do -- this could probably be done better but whatever
	---------------- DISK OUT OF BOUNDS RESET!!!!
		if not isVectorInCuboid(itm.pos, Vector(982.50, 20, 1300.50), Vector(1504.78, 100, 1005.17)) and tick == 59 and itm.data.blueflag == true then
			for _, ply in ipairs(players.getAll()) do
				ply:sendMessage("Blue flag went out of bounds, respawning it.")
				itm:remove()
				makeblueflag()
			end
		end
		if not isVectorInCuboid(itm.pos, Vector(982.50, 20, 1300.50), Vector(1504.78, 100, 1005.17)) and tick == 59 and itm.data.redflag == true then
			for _, ply in ipairs(players.getAll()) do
				ply:sendMessage("Red flag went out of bounds, respawning it.")
				itm:remove()
				makeredflag()
			end
		end
		--------------------------

				----------------------
		if itm.data.blueflag == true and tick == 59 then -- flag beeping/respawn
			events.createSound(28, itm.pos, 1, 1)
			if itm.physicsSettled == true and itm.parentHuman == nil then
				itm:speak(string.format("Respawning in: %s", itm.data.respawntimer), 1)
				itm.data.respawntimer = itm.data.respawntimer - 1
			end
			if itm.physicsSettled ~= true then
				itm.data.respawntimer = 60
			end
			if itm.data.respawntimer == 0 then
				for _, ply in ipairs(players.getAll()) do
					ply:sendMessage("Blue Flag hasnt been touched in a minute")
					ply:sendMessage("Respawning it.")
				end
				itm:remove()
				makeblueflag()
			end
		end

		if itm.data.redflag == true and tick == 59 then
			events.createSound(28, itm.pos, 1, 1)
			if itm.physicsSettled == true and itm.parentHuman == nil then
				itm:speak(string.format("Respawning in: %s", itm.data.respawntimer), 1)
				itm.data.respawntimer = itm.data.respawntimer - 1
			end
			if itm.physicsSettled ~= true then
				itm.data.respawntimer = 60
			end
			if itm.data.respawntimer == 0 then
				for _, ply in ipairs(players.getAll()) do
					ply:sendMessage("Red Flag hasnt been touched in a minute")
					ply:sendMessage("Respawning it.")
				end
				itm:remove()
				makeredflag()
			end


		end
			---------------------




		if itm.type == itemTypes[37] and itm.parentHuman then -- dont let ppl pick up boxes
			itm:unmount()
		end



		-- blue flag logic
		if itm.data.blueflag == true and itm.parentHuman ~= nil then --grabbing flag stuff
			if itm.parentHuman.player.team ~= 0 then -- blue flag
				if itm.pos:distSquare(Vector(1040, 25, 1128)) <= 2 then
					itm.parentHuman:speak("Flag is safe", 0)
					itm:unmount()
				elseif itm.pos:distSquare(Vector(1040, 25, 1128)) >= 2 then
					itm.parentHuman:speak("Flag returned!", 0)
					for _, ply in ipairs(players.getAll()) do
						ply:sendMessage(string.format("Blue flag returned by: %s!", itm.parentHuman.player.name))
					end
					itm:remove()
					makeblueflag()
				end

			elseif itm.parentHuman.player.team == 0 then
				itm.hasPhysics = true
				itm.isStatic = false
				if itm.parentHuman.data.hasspoke == nil then
					itm.parentHuman:speak("TAKE THE FLAG TO YOUR SPAWN", 0)
					itm.parentHuman.data.hasspoke = true
				end

				for _, ply in ipairs(players.getAll()) do
					if itm.data.hasspoke ~= true then
						for _, ply in ipairs(players.getAll()) do
							ply:sendMessage(string.format("%s has the blue flag!!", itm.parentHuman.player.name))
							if ply.human and ply.human.suitColor == 4 then
								events.createSound(28, ply.human.pos, 1, 1)
							end
						end
						itm.data.hasspoke = true
					end
				end
			end
		end

		if itm.data.blueflag == true and isVectorInCuboid(itm.pos, Vector(1465, 50, 1038), Vector(1504, 20, 1005)) and tick == 30 then
			events.createExplosion(itm.pos)
			events.createSound(47, Vector(1253, 46, 1127), 1, 1) -- middle of map
			events.createSound(47, Vector(1483, 46, 1024), 1, 1) -- red spawn
			events.createSound(47, Vector(1036, 46, 1220), 1, 1) -- blue spawn
			redscore = redscore + 1
			for _, ply in ipairs(players.getAll()) do
				ply:sendMessage("RED TEAM WON!!")
				ply:sendMessage(string.format("Red team score: %s", redscore))
				if ply.team == 0 then 
					ply.money = ply.money + 100
					ply:updateFinance()
				end
				if itm.parentHuman ~= nil then
					ply:sendMessage(string.format("Flag captured by: %s", itm.parentHuman.player.name))
					ply.money = ply.money + 500
					ply:updateFinance()
				end
			end
			itm:remove()
			--server:reset()
			server.time = 1
		end

		if itm.data.blueflag and itm.data.hasspoke == true and itm.parentHuman == nil and tick == 30 then
			itm.data.hasspoke = nil
		end


		----------------- red flag logic
		if itm.data.redflag == true and itm.parentHuman ~= nil then --grabbing flag stuff
			if itm.parentHuman.player.team ~= 1 then -- red
				if itm.pos:distSquare(Vector(1464, 25, 1128)) <= 2 then
					itm.parentHuman:speak("Flag is safe", 0)
					itm:unmount()
				elseif itm.pos:distSquare(Vector(1464, 25, 1128)) >= 2 then
					itm.parentHuman:speak("Flag returned!", 0)
					for _, ply in ipairs(players.getAll()) do
						ply:sendMessage(string.format("Red flag returned by: %s!", itm.parentHuman.player.name))
					end
					itm:remove()
					makeredflag()
				end

			elseif itm.parentHuman.player.team == 1 then
				itm.hasPhysics = true
				itm.isStatic = false
				if itm.parentHuman.data.hasspoke == nil then
					itm.parentHuman:speak("TAKE THE FLAG TO YOUR SPAWN", 0)
					itm.parentHuman.data.hasspoke = true
				end

				for _, ply in ipairs(players.getAll()) do
					if itm.data.hasspoke ~= true then
						for _, ply in ipairs(players.getAll()) do
							ply:sendMessage(string.format("%s has the red flag!!", itm.parentHuman.player.name))
							if ply.human and ply.human.suitColor == 8 then
								events.createSound(28, ply.human.pos, 1, 1)
							end
						end
						itm.data.hasspoke = true
					end
				end
			end
		end

		if itm.data.redflag == true and isVectorInCuboid(itm.pos, Vector(1012.34, 50, 1243), Vector(1037, 20, 1218.68)) and tick == 30 then
			events.createExplosion(itm.pos)
			events.createSound(47, Vector(1253, 46, 1127), 1, 1) -- middle of map
			events.createSound(47, Vector(1483, 46, 1024), 1, 1) -- red spawn
			events.createSound(47, Vector(1036, 46, 1220), 1, 1) -- blue spawn
			bluescore = bluescore + 1
			for _, ply in ipairs(players.getAll()) do
				ply:sendMessage("BLUE TEAM WON!!")
				ply:sendMessage(string.format("Blue team score: %s", bluescore))
				if ply.team == 1 then 
					ply.money = ply.money + 100
					ply:updateFinance()
				end
				if itm.parentHuman ~= nil then
					ply:sendMessage(string.format("Flag captured by: %s", itm.parentHuman.player.name))
					ply.money = ply.money + 500
					ply:updateFinance()
				end

			end
			itm:remove()
			--server:reset()
			server.time = 1
		end

		if itm.data.redflag and itm.data.hasspoke == true and itm.parentHuman == nil and tick == 30 then
			itm.data.hasspoke = nil
		end


		for _, ply in ipairs(players.getAll()) do
			if ply.data.saiddeath == false then -- death messages
				if ply.human.isAlive == false then -- death messages
					chat.announce(string.format("%s %s", ply.name, deathmessages[math.random(#deathmessages)]))
					ply.data.saiddeath = true
				end
			end
		end












	end



end	-- end of logic hook

function mode.hooks.LogicRound()
	return hook.override
end