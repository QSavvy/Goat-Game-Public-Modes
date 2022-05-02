---@type Plugin
local mode = ...
mode.name = "Goatmod"
mode.author = "Dingus"
-- Sandbox/racing mode

-- local servertps = mode.hooks.Logic.recentFiveSec
local readytoreset
local abouttoreset
local madesoccer
local madewalls


-- Defines maps
local deathmessages = {
	"died",
	"got flattened",
	"kersplonked",
	"got bwomped",
	"guessed what",
	"did a backflip",
	"explorded",
	"got dibbledooped",
	"hit the exotic cart",
	"perished",
	"smoked fat darts",
	"kissed the ground",
	"is six feet under",
	"isnt alive!! LOL!",
	"is tweaking",
	"... really?",
	"is kinda cute",
	"got dieded",
	"drove too fast",
	"sped on the highway",
	"is kinda silly lol",
	"forgot their seatbelt",
	"uhhhh...died? ig.",
	"is a furry",
	"slammed into a wall",
	"skrrt",
	"diiiiiiiiiiied",
	"played goat game",
	">:3c",
	"trick or treated",
	"exploded!!",
	"smoked a fat one",
	"is the CEO of fat dragons",
	"smoked weed",
	"went really really fast",
	"jetpacked into the ground",
	"was decimated",
	"got hacked",
	"[ERROR]",
	"got rick and mortied",
	"was goated",
	"was obama droned", 
	"was daskdhwiudjhfgbref",
	"stroked out",
	"had a heart attack",
	"got hit by a car",
	"expired",
	"went flying",
	"should see a doctor",
	"broke a couple bones",
	"has an 18 carrot run of bad luck",
	"IS IN YOUR WALLS",
	"needs a medic!",
	"got first stationed",
	"dialed 666", 
	"found a secret", 
	"was squid gamed omgggg squid game",
	"[insert death message here]",
	-- string.format("'s ip address is: %s.%s.%s.%s", ip1, ip1, ip2, ip2), 
	", Adieu!",
	"coded badly",
	"aaaaaaaaaaaaa",
	"goodbye!",
	"uses twitter",
	"misses the old days...",
	"shoulda stayed in school",
	"takes a drag from a ciggarette, reminiscing",
	"should watch cowboy bebop",
}

local function makeblockwall(x, y, z, orientation) -- will make a wall you cant walk through
	local blockwall = items.create(itemTypes[43], Vector(x, y, z), orientation)
	blockwall.isStatic = true
	blockwall.hasPhysics = true
end

local function maketablewithcomputer(x1, y1, z1, x2, y2, z2, orientation) -- will make a wall you cant walk through
	local tablee = items.create(itemTypes[41], Vector(x1, y1, z1), orientation)
	local computer = items.create(itemTypes[40], Vector(x2, y2, z2), orientation)
	tablee.isStatic = true
	tablee.hasPhysics = true
	computer.isStatic = true
	computer.hasPhysics = true
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
	server.state = 2
	server.time = 3600
	gameStarting = false
	math.randomseed(os.time())
	readytoreset = false
	abouttoreset = false
	madesoccer = nil
	madewalls = false
end 

function mode.hooks.Physics()
	for _, veh in ipairs(vehicles.getAll()) do
		if veh.type.index == 5 then
			veh.vel.y = veh.vel.y + server.gravity
		end
	end
end

function mode.hooks.Logic()

	server.roundTeamDamage = 0
	server.time = 7250
	if server.state == 1 then --makes it 2 mins 
		server.state = 2
		if server.time < 7250 then
			server.time = 7250
			end
		server.sunTime = 1575000 -- 7 am
		server.gravity = server.defaultGravity
	end
	-- Ticks for logic
	tick = tick + 1
	if tick < 61 then 
		server.sunTime = server.sunTime + 31.25 -- sun going across the sky
	end
	
	if tick == 60 then
		tick = 0
		second = second + 1
		if second == 60 then
			second = 0
			minute = minute + 1
		end
	end
	
	
	-- should reset the server every 20 mins, cause why not
	if minute == 19 and readytoreset == false then
		events.createMessage(0, "Server will reset in one minute", -1, 1)
		events.createMessage(0, "to fix any potential lag", -1, 1)
		readytoreset = true
	end
	
	if minute == 19 and second == 50 and abouttoreset == false then
		events.createSound(47, Vector(1423, 233, 1434), 1, 1)
		events.createMessage(0, "SERVER RESETTING IN 10 SECONDS", -1, 1)
		abouttoreset = true
	end
	
	if minute == 20 then
		server:reset()
	end
		
	
	

	
	
	
	
	
	
	
	for _, itm in ipairs(items.getAll()) do -- sets the memo text as well as the despawn and soccer
		if madesoccer == nil then 
			local soccerball = items.create(itemTypes[35], Vector(1728, 29, 1758.01), orientations.n)
			soccerball.hasPhysics = true 
			soccerball.isStatic = false
			madesoccer = true
		
		end
		
		if itm.type == itemTypes[35] then -- if its pickedup, drop
			if itm.parentHuman and tick == 30 then 
				itm:unmount()
			end
		
		
		
			if not isVectorInCuboid(itm.pos, Vector(1696, 37, 1775), Vector(1760, 27, 1739.98)) then -- deletes if it leaves the field
				events.createSound(28, itm.pos, 1, 1)
				itm:remove()
				madesoccer = nil
			end
			
			if isVectorInCuboid(itm.pos, Vector(1696.50, 28, 1764), Vector(1691.79, 33, 1752.31)) then -- goal one
				events.createExplosion(itm.pos)
				events.createSound(27, itm.pos, 1, 1)
				itm:remove()
				madesoccer = nil
			end
			if isVectorInCuboid(itm.pos, Vector(1759.33, 28, 1764), Vector(1764.24, 33, 1752.04)) then -- goal two
				events.createSound(27, itm.pos, 1, 1)
				events.createExplosion(itm.pos)
				itm:remove()
				madesoccer = nil

				
			end
		end
		itm:setMemo("Hello!\nThis is a currently buggy/barebones racing gamemode.\nPlease join the Discord for updates and suggestions!\ndiscord.gg/JzbvtVTBFv\n/tp to teleport, not case sensitive\n/goat to respawn\n\nJetpack controls\n Shift: enable\n Space: Up/Down\n LMB/RMB: Forward/Back\n Scroll: Speed (Zoomed is faster)\n Where you look is direction\n\nSpawn a car by dialing 12, the next number will be the type.\n1: Town Car\n2: Turbo\n3: Hatchback\n4: Van\n5: Battlebus\nPress shift in a car to boost every 10 seconds\n\nDial 111 if youd like to disable boosts, dial again to renable.\n\nThis gamemode was made by DINGUS!! :D Enjoy!")
		
		if itm.physicsSettled == true and itm.type ~= itemTypes[35] and itm.type ~= itemTypes[36] and itm.type ~= itemTypes[43] and itm.type ~= itm.type ~= itemTypes[44] and itm.type ~= itm.type ~= itemTypes[41] and itm.type ~= itm.type ~= itemTypes[40] then --removes dropped items EXCEPT THE SOCCER BALL
			itm:remove()
		end
		
		if itm.type == itemTypes[25] and tick == 30 and itm.data.hassaid == true then --resets the phones .data.hassaid table every second
			itm.data.hassaid = nil
		end
		
		if itm.type == itemTypes[36] and itm.physicsSettled == true then
			itm.physicsSettled = false
		end
		
		
		
		------------------------------------ logic to spawn cars --------------------------------------------------------
		if itm.type == itemTypes[25] and itm.data.hassaid == nil and itm.parentHuman ~= nil then -- town car
			if itm.enteredPhoneNumber == 121 and itm.parentHuman.vehicle == nil then
				if itm.parentHuman.data.vehamount >= 3 then
					itm:speak("Too many cars!", 0)
					itm:speak("Respawn to clear them", 0)
					itm.data.hassaid = true
					itm.enteredPhoneNumber = 0
				else 
					itm:speak("Spawned Town Car", 0)
					itm.data.hassaid = true
					itm.data.lastnum = itm.enteredPhoneNumber
					
					local pos = itm.parentHuman.pos:clone()
					pos.x = pos.x + (4 * math.cos(itm.parentHuman.viewYaw))
					pos.y = pos.y + 0.5
					pos.z = pos.z + (4 * math.sin(itm.parentHuman.viewYaw))
					
					local car = vehicles.create(vehicleTypes.getByName("Town Car"), pos, yawToRotMatrix(itm.parentHuman.viewYaw), math.random(0,5))		
					itm.enteredPhoneNumber = 0
									
					if car then
						itm.parentHuman.vehicle = car
						itm.parentHuman.vehicleSeat = 0
						itm.parentHuman.data.vehamount = itm.parentHuman.data.vehamount + 1
						itm.parentHuman.vehicle.data.belongsto = itm.parentHuman.index 
					end
				
				end
			end
		end
		
		if itm.type == itemTypes[25] and itm.data.hassaid == nil and itm.parentHuman ~= nil then  -- turbo
			if itm.enteredPhoneNumber == 122 and itm.parentHuman.vehicle == nil then
				if itm.parentHuman.data.vehamount >= 3 then
					itm:speak("Too many cars!", 0)
					itm:speak("Respawn to clear them", 0)
					itm.data.hassaid = true
					itm.enteredPhoneNumber = 0
				else 
					itm:speak("Spawned Turbo", 0)
					itm.data.hassaid = true
					itm.data.lastnum = itm.enteredPhoneNumber
					
					local pos = itm.parentHuman.pos:clone()
					pos.x = pos.x + (4 * math.cos(itm.parentHuman.viewYaw))
					pos.y = pos.y + 0.5
					pos.z = pos.z + (4 * math.sin(itm.parentHuman.viewYaw))
					
					local car = vehicles.create(vehicleTypes.getByName("Turbo"), pos, yawToRotMatrix(itm.parentHuman.viewYaw), math.random(0,5))		
					itm.enteredPhoneNumber = 0
					
					if car then
						itm.parentHuman.vehicle = car
						itm.parentHuman.vehicleSeat = 0
						itm.parentHuman.data.vehamount = itm.parentHuman.data.vehamount + 1
						itm.parentHuman.vehicle.data.belongsto = itm.parentHuman.index 
					end
				
				end
			end
		end
		
		if itm.type == itemTypes[25] and itm.data.hassaid == nil and itm.parentHuman ~= nil then  --hatchback
			if itm.enteredPhoneNumber == 123 and itm.parentHuman.vehicle == nil then
				if itm.parentHuman.data.vehamount >= 3 then
					itm:speak("Too many cars!", 0)
					itm:speak("Respawn to clear them", 0)
					itm.data.hassaid = true
					itm.enteredPhoneNumber = 0
				else 
					itm:speak("Spawned Hatchback", 0)
					itm.data.hassaid = true
					itm.data.lastnum = itm.enteredPhoneNumber
					
					local pos = itm.parentHuman.pos:clone()
					pos.x = pos.x + (4 * math.cos(itm.parentHuman.viewYaw))
					pos.y = pos.y + 0.5
					pos.z = pos.z + (4 * math.sin(itm.parentHuman.viewYaw))
					
					local car = vehicles.create(vehicleTypes.getByName("Hatchback"), pos, yawToRotMatrix(itm.parentHuman.viewYaw), math.random(0,5))		
					itm.enteredPhoneNumber = 0
					
					if car then
						itm.parentHuman.vehicle = car
						itm.parentHuman.vehicleSeat = 0
						itm.parentHuman.data.vehamount = itm.parentHuman.data.vehamount + 1
						itm.parentHuman.vehicle.data.belongsto = itm.parentHuman.index 
					end
				
				end
			end
		end
		
		if itm.type == itemTypes[25] and itm.data.hassaid == nil and itm.parentHuman ~= nil then  -- van
			if itm.enteredPhoneNumber == 124 and itm.parentHuman.vehicle == nil then
				if itm.parentHuman.data.vehamount >= 3 then
					itm:speak("Too many cars!", 0)
					itm:speak("Respawn to clear them", 0)
					itm.data.hassaid = true
					itm.enteredPhoneNumber = 0
				else 
					itm:speak("Spawned Van", 0)
					itm.data.hassaid = true
					itm.data.lastnum = itm.enteredPhoneNumber
					
					local pos = itm.parentHuman.pos:clone()
					pos.x = pos.x + (4 * math.cos(itm.parentHuman.viewYaw))
					pos.y = pos.y + 0.5
					pos.z = pos.z + (4 * math.sin(itm.parentHuman.viewYaw))
					
					local car = vehicles.create(vehicleTypes.getByName("Van"), pos, yawToRotMatrix(itm.parentHuman.viewYaw), math.random(0,5))		
					itm.enteredPhoneNumber = 0
					
					if car then
						itm.parentHuman.vehicle = car
						itm.parentHuman.vehicleSeat = 0
						itm.parentHuman.data.vehamount = itm.parentHuman.data.vehamount + 1
						itm.parentHuman.vehicle.data.belongsto = itm.parentHuman.index 
					end
				
				end
			end
		end
		
		if itm.type == itemTypes[25] and itm.data.hassaid == nil and itm.parentHuman ~= nil then  -- battlebus
			if itm.enteredPhoneNumber == 125 and itm.parentHuman.vehicle == nil then
				if itm.parentHuman.data.vehamount >= 3 then
					itm:speak("Too many cars!", 0)
					itm:speak("Respawn to clear them", 0)
					itm.data.hassaid = true
					itm.enteredPhoneNumber = 0
				else 
					itm:speak("Spawned Battlebus", 0)
					itm.data.hassaid = true
					itm.data.lastnum = itm.enteredPhoneNumber
					
					local pos = itm.parentHuman.pos:clone()
					pos.x = pos.x + (4 * math.cos(itm.parentHuman.viewYaw))
					pos.y = pos.y + 0.5
					pos.z = pos.z + (4 * math.sin(itm.parentHuman.viewYaw))
					local heli = vehicles.create(vehicleTypes.getByName("Helicopter"), Vector(pos.x, pos.y, pos.z), yawToRotMatrix(itm.parentHuman.viewYaw), math.random(0,5))		
					heli.data.belongsto = itm.parentHuman.index
					itm.enteredPhoneNumber = 0
					if heli then
						itm.parentHuman.vehicle = heli
						itm.parentHuman.vehicleSeat = 0
						itm.parentHuman.data.vehamount = itm.parentHuman.data.vehamount + 1
						itm.parentHuman.vehicle.data.belongsto = itm.parentHuman.index 
					end
				
				end
			end
		end
		

		
		------------------------------------------------------------------------------------------------------------------------------------------
		
		
		
		
		
		if itm.type == itemTypes[25] and itm.data.hassaid == nil and itm.parentHuman ~= nil then -- secret lol
			if itm.enteredPhoneNumber == 666 and itm.parentHuman.vehicle == nil then
				itm.parentHuman:addVelocity(Vector(0, 7, 0))
				itm.parentHuman:speak("Criminal", 2)
			end
		end
		
	
		
		if itm.type == itemTypes[25] and itm.data.hassaid == nil and itm.parentHuman ~= nil then -- bomb vest lol
			if itm.enteredPhoneNumber == 911 and itm.parentHuman.vehicle == nil and itm.parentHuman.data.suicidevest == nil then
				itm:speak("Suicide vest activated", 2)
				itm.parentHuman.data.suicidevest = true
				itm.parentHuman.data.vesttimer = 0
				itm.data.willexplode = true
			end
		end
	
		if itm.type == itemTypes[25] and itm.data.hassaid == nil and itm.parentHuman ~= nil then -- secret burger lol
			if itm.enteredPhoneNumber == 420 and itm.parentHuman.vehicle == nil then
				local burger = items.create(itemTypes[30], itm.parentHuman.pos, orientations.n)
				itm.parentHuman:mountItem(burger, 1)
				itm.enteredPhoneNumber = 0
				itm.parentHuman:speak("i got mad munchies  bc    i smoke weed", 2)
				itm.parentHuman:speak("i smoke weed and kill people with my car", 2)
			end
		end
		
		if itm.type == itemTypes[25] and itm.data.hassaid == nil and itm.parentHuman ~= nil then -- Sets if arcade mode is enabled
			if itm.enteredPhoneNumber == 111 then
				if itm.parentHuman.player.data.arcadesetting == 1 then
					itm:speak("Boosts Disabled", 0)
					itm.parentHuman.player.data.arcadesetting = 0
					itm.enteredPhoneNumber = 0
				else 
					itm:speak("Boosts Enabled", 0)
					itm.parentHuman.player.data.arcadesetting = 1
					itm.enteredPhoneNumber = 0
				end
					
			end
		end	
	end
	
	if tick == 30 then
		for _, veh in ipairs(vehicles.getAll()) do -- soccer security
			if isVectorInCuboid(veh.pos, Vector(1696, 37, 1775), Vector(1760, 27, 1739.98)) then
				veh.lastDriver.human.isAlive = false
				veh:remove()
			end
		end
		for _, man in ipairs(humans.getAll()) do 
			if isVectorInCuboid(man.pos, Vector(1696, 37, 1775), Vector(1760, 27, 1739.98)) then
				if man.data.suicidevest ~= nil then
					man.isAlive = false
				end
			end
		end
	end
	
	


	for _, man in ipairs(humans.getAll()) do -- burger secret guns
		if isVectorInCuboid(man.pos, Vector(1464, 72, 1472), Vector(1467, 76.64, 1475)) == true and man.data.hasbeenarmed == nil and man.isStanding == true then -- burger arm
			local wID = math.random(6) * 2 - 1
			man:arm(wID, 1)
			local mag = items.create(itemTypes[wID + 1], man:getInventorySlot(0).primaryItem.pos, orientations.n)
			man:getInventorySlot(0).primaryItem:mountItem(mag)
			man:getInventorySlot(0).primaryItem.bullets = 1
			man:mountItem(man:getInventorySlot(1).primaryItem, 5)
			man:speak("Secrets...", 0)
			man.data.hasbeenarmed = true
		end
	end

	-- human boost timer
	if tick == 59 then
		for _, man in ipairs(humans.getAll()) do
			if not man.vehicle then
				man.data.timer = 0
			else
			if man.vehicle then
				man.data.timer = man.data.timer + 1
			end
			if man.data.timer >= 10 and man.data.hassaidboost == nil and man.vehicleSeat == 0 and man.player.data.arcadesetting == 1 then
				man.data.timer = 10
				man.data.canboost = true
				man:speak("Boost ready", 0)
				man.data.hassaidboost = true
				events.createSound(28, man.pos, 1, 3)
				end
			end
		end

		for _, man in ipairs(humans.getAll()) do -- suicide vest beeper and explosion
			if man.data.suicidevest == true then
				if tick == 59 then
				man.data.vesttimer = man.data.vesttimer + 1
				events.createSound(37, man.pos, 1, 3)
				end
				if man.data.vesttimer == 9 then
					man:speak("silly time!", 1)
					events.createSound(27, man.pos, 1, 1)
				end
				
				if man.data.vesttimer == 10 then
					man.data.vesttimer = nil
					man.data.suicidevest = nil
					events.createExplosion(man.pos)
					local phonebomb = items.create(itemTypes[25], man.pos, orientations.n)
					man:mountItem(phonebomb, man:getInventorySlot(0).primaryItem)
					man:getInventorySlot(0).primaryItem:explode()
				end
			end
		end
	end

	-- boost function

	for _, man in ipairs(humans.getAll()) do
		if man.data.timer == 8 and man.data.has8 == nil and man.vehicleSeat == 0 and man.player.data.arcadesetting == 1 then --boost 8 beep
			events.createSound(28, man.vehicle.pos, 1, 1)
			man.data.has8 = true
		end
		
		if man.data.timer == 9 and man.data.has9 == nil and man.vehicleSeat == 0 and man.player.data.arcadesetting == 1 then --boost 9 beep
			events.createSound(28, man.vehicle.pos, 1, 2)
			man.data.has9 = true
		end
		
		if man.vehicle and bit32.band(man.inputFlags, 16) == 16 and man.data.canboost and man.vehicle.health > 0 and man.vehicleSeat == 0 and man.player.data.arcadesetting == 1 then --boost
			man.vehicle.rigidBody.vel:add(-((man.vehicle.rigidBody.rot:getRight())/2))
			man.vehicle.rigidBody.vel:add(((man.vehicle.rigidBody.rot:getUp())/10))
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

	-- If the player has no human and the game is in play, create a human for them and spawns them with a memo/phone, also automatically sets the man.data.arcadesetting for boosts
	for _, ply in ipairs(players.getAll()) do
		if ply.human == nil and server.state == 2 then
			if ply.data.spawnpoint == nil then
				local man = humans.create(Vector(math.random(1365, 1619), 50, 1463), orientations.n, ply)
				local memo = items.create(itemTypes[34], man.pos, orientations.n)
				local phone = items.create(itemTypes[25], man.pos, orientations.n)
				local knife = items.create(itemTypes[27], man.pos, orientations.n)
				man:mountItem(memo, 3)
				man:mountItem(phone, 6)
				man:mountItem(knife, 5)
				ply.human.data.hasbeenarmed = nil
				ply.human.data.vehamount = 0
				ply.data.saiddeath = false
				if ply.data.arcadesetting == nil then 
					ply.data.arcadesetting = 1
				end
			else 
				local mane = humans.create(Vector(ply.data.spawnpoint.x, ply.data.spawnpoint.y + 1, ply.data.spawnpoint.z), orientations.n, ply)
				local phone = items.create(itemTypes[25], mane.pos, orientations.n)
				local memo = items.create(itemTypes[34], mane.pos, orientations.n)
				mane:mountItem(phone, 6)
				mane:mountItem(memo, 3)
				ply.human.data.vehamount = 0
				if ply.data.arcadesetting == nil then 
					ply.data.arcadesetting = 1
				end
				
			end
		
		end
		
	
	
		if ply.data.saiddeath == false then 
			if ply.human.isAlive == false then -- death messages
				chat.announce(string.format("%s %s", ply.name, deathmessages[math.random(#deathmessages)]))
				ply.data.saiddeath = true
			end	
		end
	end
	
	
	
	-- appearence randomizer 
	for _, man in ipairs(humans.getAll()) do
		local randomsuitcolor = math.random(1, 10)
		local randomsuittype = math.random(0, 1)
		local fiftyfifty = math.random(0, 1)
		
		if man.player and man.suitColor == 0 then
			man.suitColor = randomsuitcolor
			man.model = randomsuittype
		end
		
		if man.isBleeding == true then
			man.isBleeding = nil
		end

		if not man.player then -- removes dead bodies and their cars
			for _, veh in ipairs(vehicles.getAll()) do
				if veh.data.belongsto == man.index then
					veh:remove()
				else
					end
				-- if vehicleTypes.getByName("Helicopter") and veh.data.belongsto == man.index then
					-- if veh.data.heliindex ~= nil then
						-- veh:remove()
					-- end
				-- end
				-- if vehicleTypes.getByName("Train") and veh.data.belongsto == man.index then
					-- veh:remove()
					
				-- end
			end
			for _, itm in ipairs(items.getAll()) do
				if itm.data.belongsto == man.index then
					itm:remove()
				else
					end
			
			end

			
			man:remove()
			
		end
		
		
		--kills if too high up (commented out until an issue with hight comes up)
		if man.pos.y > 4000 and tick == 30 then
			
			man:speak("Too high!", 0)
		end
		
		-- kill ceiling
		if man.pos.y > 5000 then
			man.isAlive = false
		end

	-- Jetpack Function
		if bit32.band(man.inputFlags, 16) == 16 and man.bloodLevel > 60 and man.vehicle == nil then
			if bit32.band(man.inputFlags, 4) == 4 then
				man:addVelocity(Vector(0, 0.0035, 0))
				if bit32.band(man.inputFlags, 1) == 1 then -- input flag 1 is lmb
					if man.zoomLevel == 2 then
						man:addVelocity(Vector((math.sin(man.viewYaw)/500), 0, -(math.cos(man.viewYaw)/500)))
						end
					if man.zoomLevel == 0 or man.zoomLevel == 1 then
						man:addVelocity(Vector((math.sin(man.viewYaw)/2000), 0, -(math.cos(man.viewYaw)/2000)))
						end
				elseif bit32.band(man.inputFlags, 2) == 2 then	
					if man.zoomLevel == 2 then
						man:addVelocity(Vector(-(math.sin(man.viewYaw)/500), 0, (math.cos(man.viewYaw)/500)))
						end
					
					if man.zoomLevel == 0 or man.zoomLevel == 1 then
						man:addVelocity(Vector(-(math.sin(man.viewYaw)/2000), 0, (math.cos(man.viewYaw)/2000)))
						end
				end
		man:getRigidBody(0).rot = rollToRotMatrix(0)
		man:getRigidBody(1).rot = rollToRotMatrix(0)
		man:getRigidBody(2).rot = rollToRotMatrix(0)
		man:getRigidBody(0).rot = yawToRotMatrix(man.viewYaw)
		man:getRigidBody(1).rot = yawToRotMatrix(man.viewYaw)
		man:getRigidBody(2).rot = yawToRotMatrix(man.viewYaw)
		-- if tick == 0 or tick == 20 or tick == 40 or tick == 59 then -- this is the sound jetpacks make, commented out as the large amount of sounds playing would lag the server :/
			-- events.createSound(28, man.pos, 1, man.pos.y / 100) 
			-- end
		end
		end



		-- Bandage Regen
		if man.progressBar == 255 then
			man.chestHP = 100
			man.headHP = 100
			man.leftArmHP = 100
			man.rightArmHP = 100
			man.leftLegHP = 100
			man.rightLegHP = 100
			man.bloodLevel = 100
			man.damage = 0
		end

		-- Infinite Stamina
		
		man.stamina = 127
	end
	
	

	
	
	
	
end
	



function mode.hooks.LogicRound()
	return hook.override
end
