---@type Plugin
local mode = ...
mode.name = "deathrun"
mode.author = "Dingus"
-- A remake of the classic deathrun gamemode


debug = false -- Set to true if debugging, this turns off checks for stuff like all players dead and stuff, just do it if you're working on the gamemode pls thx

local function makeblockwall(x, y, z, orientation, isTrapWall, timerMax) -- will make a wall you cant walk through, orientation should be "orientations.n" or some other orientation rot matrix
    local blockwall = items.create(itemTypes[43], Vector(x, y, z), orientation)
	local blockwalltwo = items.create(itemTypes[43], Vector(x, y + 1, z), orientation)
    blockwall.isStatic = true
    blockwall.hasPhysics = true

	blockwalltwo.isStatic = true
	blockwalltwo.hasPhysics = true

	blockwall.data.isWall = true 
	blockwalltwo.data.isWall = true

	blockwalltwo.data.isTrapWall = isTrapWall
	blockwall.data.isTrapWall = isTrapWall

	blockwall.data.timerMax = timerMax
	blockwalltwo.data.timerMax = timerMax

	blockwall.data.timer = 0
	blockwalltwo.data.timer = 0
end

local function makewalkwall(x, y, z, orientation) -- will make a wall you cant walk through, orientation should be "orientations.n" or some other orientation rot matrix
    local peekwall = vehicles.create(vehicleTypes.getByName("Train"), Vector(x, y, z), orientation, 1)
	local peekwall2 = vehicles.create(vehicleTypes.getByName("Train"), Vector(x, y, z - 2.5), orientation, 1)
	peekwall2.rigidBody.isSettled = true
	peekwall.rigidBody.isSettled = true
end


local function makeButton(buttonNum, x, y, z, orientation)
	local button = items.create(itemTypes[37], Vector(x, y, z), orientation)
	button.isStatic = true
	button.hasPhysics = false
	button.data.isButton = true
	button.data.buttonNum = buttonNum
	button.data.hasBeenPushed = false
end



local function selectGoat()
	plys = players.getAll()
	for i = 1,2 do -- spawn ppl in if the server resets/havent died yet
		local man = plys[math.random(#plys)]
		if man.human == nil and server.state == 2 and man.data.hasDied == false then
			man.data.isButtonPusher = true
			man:sendMessage("You are the GOAT")
			man.criminalRating = 400
			man.data.isAllowedToTrainWalk = true
			goatcount = goatcount + 1
		end
	end
end


local function activateTrap(buttonNum) -- this is the function where the traps are actually made and executed



	if buttonNum == 1 then -- first trap
		-- back wall
		makeblockwall(2063, 48.84, 1451, orientations.e, true, 5)
		makeblockwall(2063, 48.84, 1448, orientations.e, true, 5)
		makeblockwall(2063, 48.84, 1445, orientations.e, true, 5)
		makeblockwall(2063, 48.84, 1442, orientations.e, true, 5)
		makeblockwall(2063, 48.84, 1441, orientations.e, true, 5)



		--front wall 
		makeblockwall(2056, 48.84, 1451, orientations.e, true, 5)
		makeblockwall(2056, 48.84, 1448, orientations.e, true, 5)
		makeblockwall(2056, 48.84, 1445, orientations.e, true, 5)
		makeblockwall(2056, 48.84, 1442, orientations.e, true, 5)
		makeblockwall(2056, 48.84, 1441, orientations.e, true, 5)
		
		local car = vehicles.create(vehicleTypes.getByName("Train"), Vector(2057, 70, 1450), yawToRotMatrix(0), math.random(0,5))
		local cartwo = vehicles.create(vehicleTypes.getByName("Train"), Vector(2060, 70, 1450), yawToRotMatrix(0), math.random(0,5))
		car.data.isTrapCar = true
		cartwo.data.isTrapCar = true
		car.rigidBody.vel:add(Vector(0, -1, 0))
		cartwo.rigidBody.vel:add(Vector(0, -1, 0))

	elseif buttonNum == 2 then
		makeblockwall(2052, 48.84, 1451, orientations.e, true, 5)
		makeblockwall(2052, 48.84, 1448, orientations.e, true, 5)
		makeblockwall(2052, 48.84, 1445, orientations.e, true, 5)
		makeblockwall(2052, 48.84, 1442, orientations.e, true, 5)
		makeblockwall(2052, 48.84, 1441, orientations.e, true, 5)



		--front wall 
		makeblockwall(2045, 48.84, 1451, orientations.e, true, 5)
		makeblockwall(2045, 48.84, 1448, orientations.e, true, 5)
		makeblockwall(2045, 48.84, 1445, orientations.e, true, 5)
		makeblockwall(2045, 48.84, 1442, orientations.e, true, 5)
		makeblockwall(2045, 48.84, 1441, orientations.e, true, 5)

	

	
		for _, man in ipairs(humans.getAll()) do
			if man.isAlive and isVectorInCuboid(man.pos, Vector(2052, 47, 1451), Vector(2045, 70, 1441)) and man.player.data.isRunner == true then
				events.createExplosion(man.pos)
				man:addVelocity(Vector(0, 0.2, 0)) -- more funny without the instadeath lol
				man.isAlive = false 
			end
		end



	
	elseif buttonNum == 3 then

		makeblockwall(2023, 48.84, 1451, orientations.e, true, 5)
		makeblockwall(2023, 48.84, 1448, orientations.e, true, 5)
		makeblockwall(2023, 48.84, 1445, orientations.e, true, 5)
		makeblockwall(2023, 48.84, 1442, orientations.e, true, 5)
		makeblockwall(2023, 48.84, 1441, orientations.e, true, 5)



		--front wall 
		makeblockwall(2016, 48.84, 1451, orientations.e, true, 5)
		makeblockwall(2016, 48.84, 1448, orientations.e, true, 5)
		makeblockwall(2016, 48.84, 1445, orientations.e, true, 5)
		makeblockwall(2016, 48.84, 1442, orientations.e, true, 5)
		makeblockwall(2016, 48.84, 1441, orientations.e, true, 5)
		
		for _, man in ipairs(humans.getAll()) do
			if isVectorInCuboid(man.pos, Vector(2022.72, 60, 1440.83), Vector(2016.01, 20, 1452.74)) and man.isAlive and man.player.data.isRunner == true then
				events.createBulletHit(1, man.pos, normal)
				man:addVelocity(Vector(0, 0, 0.2)) -- more funny without the instadeath lol
				man.isAlive = false 
			end
		end



		for i = 1,50 do 
			--local bullet1 = bullets.create(2, Vector(2022, 49, 1441), Vector(0, 0, 5), nil)
			--local bullet2 = bullets.create(2, Vector(2021, 49, 1441), Vector(0, 0, 5), nil)
			--local bullet3 = bullets.create(2, Vector(2020, 49, 1441), Vector(0, 0, 5), nil)
			--local bullet4 = bullets.create(2, Vector(2019, 49, 1441), Vector(0, 0, 5), nil)
			--local bullet5 = bullets.create(2, Vector(2018, 49, 1441), Vector(0, 0, 5), nil)
			--local bullet6 = bullets.create(2, Vector(2017, 49, 1441), Vector(0, 0, 5), nil)
			--local bullet7 = bullets.create(2, Vector(2016, 49, 1441), Vector(0, 0, 5), nil)

			events.createBullet(2, Vector(2022, 49, 1441.30), Vector(0, 0, 5), nil)
			events.createBullet(2, Vector(2021, 49, 1441.30), Vector(0, 0, 5), nil)
			events.createBullet(2, Vector(2020, 49, 1441.30), Vector(0, 0, 5), nil)
			events.createBullet(2, Vector(2019, 49, 1441.30), Vector(0, 0, 5), nil)
			events.createBullet(2, Vector(2018, 49, 1441.30), Vector(0, 0, 5), nil)
			events.createBullet(2, Vector(2017, 49, 1441.30), Vector(0, 0, 5), nil)
			events.createBullet(2, Vector(2016, 49, 1441.30), Vector(0, 0, 5), nil)

			events.createSound(76, Vector(2019, 29, 1441), 1, 1)


		
		end 


	elseif buttonNum == 4 then 
		
		
		makeblockwall(1972, 48.84, 1451, orientations.e, true, 5)
		makeblockwall(1972, 48.84, 1448, orientations.e, true, 5)
		makeblockwall(1972, 48.84, 1445, orientations.e, true, 5)
		makeblockwall(1972, 48.84, 1442, orientations.e, true, 5)
		makeblockwall(1972, 48.84, 1441, orientations.e, true, 5)



		--front wall 
		makeblockwall(1965, 48.84, 1451, orientations.e, true, 5)
		makeblockwall(1965, 48.84, 1448, orientations.e, true, 5)
		makeblockwall(1965, 48.84, 1445, orientations.e, true, 5)
		makeblockwall(1965, 48.84, 1442, orientations.e, true, 5)
		makeblockwall(1965, 48.84, 1441, orientations.e, true, 5)
		

		for _, man in ipairs(humans.getAll()) do
			
			if isVectorInCuboid(man.pos, Vector(1971.93, 60, 1440.89), Vector(1964.93, 20, 1451.98)) and man.isAlive and man.player.data.isRunner == true then
				local fiftyfifty = math.random(0,1)


				if fiftyfifty == 1 then 
					man:speak("50/50 chance failed!", 1)
					
					man:addVelocity(Vector(0, 0.4, 0))
				elseif fiftyfifty == 0 then
					man:speak("50/50 chance passed!", 1)
				end
			end
		end

	elseif buttonNum == 5 then

		makeblockwall(1952, 48.84, 1451, orientations.e, true, 5)
		makeblockwall(1952, 48.84, 1448, orientations.e, true, 5)
		makeblockwall(1952, 48.84, 1445, orientations.e, true, 5)
		makeblockwall(1952, 48.84, 1442, orientations.e, true, 5)
		makeblockwall(1952, 48.84, 1441, orientations.e, true, 5)



		--front wall 
		makeblockwall(1947, 48.84, 1451, orientations.e, true, 5)
		makeblockwall(1947, 48.84, 1448, orientations.e, true, 5)
		makeblockwall(1947, 48.84, 1445, orientations.e, true, 5)
		makeblockwall(1947, 48.84, 1442, orientations.e, true, 5)
		makeblockwall(1947, 48.84, 1441, orientations.e, true, 5)

		for _, man in ipairs(humans.getAll()) do
			
			if isVectorInCuboid(man.pos, Vector(1947, 60, 1441), Vector(1952, 20, 1451)) and man.isAlive and man.player.data.isRunner == true then
				events.createBulletHit(2, man.pos, normal)
				man:teleport(Vector(1987, -0.33, 1442))
			end




		end



			
	elseif buttonNum == 6 then
		makeblockwall(1926, 48.84, 1451, orientations.e, true, 5)
		makeblockwall(1926, 48.84, 1448, orientations.e, true, 5)
		makeblockwall(1926, 48.84, 1445, orientations.e, true, 5)
		makeblockwall(1926, 48.84, 1442, orientations.e, true, 5)
		makeblockwall(1926, 48.84, 1441, orientations.e, true, 5)



		--front wall 
		makeblockwall(1934, 48.84, 1451, orientations.e, true, 5)
		makeblockwall(1934, 48.84, 1448, orientations.e, true, 5)
		makeblockwall(1934, 48.84, 1445, orientations.e, true, 5)
		makeblockwall(1934, 48.84, 1442, orientations.e, true, 5)
		makeblockwall(1934, 48.84, 1441, orientations.e, true, 5)


		local burger1 = items.create(itemTypes[30], Vector(1930, 60, 1451), orientations.n)
		local burger2 = items.create(itemTypes[30], Vector(1930, 60, 1448), orientations.n)
		local burger3 = items.create(itemTypes[30], Vector(1930, 60, 1446), orientations.n)
		local burger4 = items.create(itemTypes[30], Vector(1930, 60, 1444), orientations.n)
		burger1.data.isBomb = true
		burger2.data.isBomb = true
		burger3.data.isBomb = true
		burger4.data.isBomb = true
		
		
		burger1:speak("mmm burger!!!", 1)
		burger2:speak("Burger time!!", 1)
		burger3:speak("i love burgers!!", 1)
		burger4:speak("spongebob", 1)



		



	elseif buttonNum == 7 then
			
		makeblockwall(1913, 48.84, 1451, orientations.e, true, 5)
		makeblockwall(1913, 48.84, 1448, orientations.e, true, 5)
		makeblockwall(1913, 48.84, 1445, orientations.e, true, 5)
		makeblockwall(1913, 48.84, 1442, orientations.e, true, 5)
		makeblockwall(1913, 48.84, 1441, orientations.e, true, 5)



		--front wall 
		makeblockwall(1903, 48.84, 1451, orientations.e, true, 5)
		makeblockwall(1903, 48.84, 1448, orientations.e, true, 5)
		makeblockwall(1903, 48.84, 1445, orientations.e, true, 5)
		makeblockwall(1903, 48.84, 1442, orientations.e, true, 5)
		makeblockwall(1903, 48.84, 1441, orientations.e, true, 5)

		for _, man in ipairs(humans.getAll()) do
			
			if isVectorInCuboid(man.pos, Vector(1903.04, 44, 1452), Vector(1912.97, 55, 1441.24)) and man.isAlive and man.player.data.isRunner == true then
				local rigidBodyMan = man:getRigidBody(math.random(0,15))
				local rope = items.create(itemTypes[36], Vector(man.pos.x, man.pos.y + 10, man.pos.z), orientations.n)
				rope.rigidBody:bondToLevel(Vector(0, 0, 0), Vector(man.pos.x, man.pos.y + 10, man.pos.z))
				rope.rigidBody:bondTo(rigidBodyMan, Vector(0,-0.2,0), Vector(0,0,0))
			end




		end
	
			
	else end


end

local function pushButton(buttonNum, plyName) -- executed when a button is pushed
	if debug == true then 
		for _, ply in ipairs(players.getAll()) do
			ply:sendMessage(string.format("Button %s pushed by: %s", buttonNum, plyName))
		end
	end
	activateTrap(buttonNum)

end




local deathmessages = { -- death messages
    "was eliminated",
	"was squid gamed",
	"was eliminated",
}


function mode.onEnable(isReload)
	tick = 0
	second = 0
	minute = 0
	server.type = TYPE_ROUND
end
local redlighttimer = 0
local goatkillcount
local playerkillcount
local madeplatforms 
local fiftyfiftydoor
local redlightbuffer = 0
local playerkillcount
function mode.hooks.ResetGame(reason)
	tick = 0
	second = 0
	minute = 0
	server.state = STATE_GAME
	server.time = 14500
    madeplatforms = false
	gameStarting = false
	goatslost = false
	allplayerslost = false
	math.randomseed(os.time())
	fiftyfiftydoor = math.random(1,2)
	goatkillcount = 0
	playerkillcount = 0
	inplaycount = 0
	goatcount = 0
	for _, ply in ipairs(players.getAll()) do
        ply.data.hasDied = false
        ply.data.hasbeenarmed = false
		ply.data.isButtonPusher = false
		ply.criminalRating = 0
		ply.data.isRunner = false
		ply.data.isAllowedToTrainWalk = false
    end
end 




function mode.hooks.Logic()
    server.time = server.time - 1
    server.roundTeamDamage = 0
   
   
   
    tick = tick + 1
    if tick == 60 then
		tick = 0
		second = second + 1
		if second == 60 then
			second = 0
			minute = minute + 1
		end
	end


	if goatkillcount == goatcount and goatslost ~= true and server.state == 2 and debug == false then
		server.time = 1
		goatslost = true
	end

	if playerkillcount == inplaycount and allplayerslost ~= true and server.state == 2 and debug == false then
		server.time = 1
		allplayerslost = true
	end


	if server.time == 0 then -- round time handling
		if server.state == 1 then
			server.state = 2
			server.time = 22290 --7250 is 2 mins
			server.sunTime = (math.random(8, 15) * 60 * 60 * 62.5)-- random time
			selectGoat()
		elseif server.state == 2 then
			if not gameEnding then -- ROUND ENDING
				if goatslost ~= true then 
					if allplayerslost ~= true then 
						gameEnding = true
						events.createMessage(0, "Games over! Time ran out!", -1, 2)
						server.time = 600
					else 
						gameEnding = true
						events.createMessage(0, "Games over! Everyone died!", -1, 2)
						server.time = 600
					end
				else
					gameEnding = true
					events.createMessage(0, "Goats Eliminated!", -1, 2)
					server.time = 600
				end
			else
                gameEnding = false
				server:reset()
				server.time = 3600
				end
			end
		end
	

		-- readying up stuff
		local readyCount = 0
		for _, ply in ipairs(players.getAll()) do
			ply.teamSwitchTimer = 0
			if ply.isReady then
				readyCount = readyCount + 1
			end
		end 
		if readyCount >= players.getCount() * 0.5 and not gameStarting then
			gameStarting = true
			for _, ply in ipairs(players.getAll()) do
				ply:sendMessage("GET READY TO DIE!!!!!!!!!!!!!")
				ply:sendMessage(" ")
				ply:sendMessage("Join the Discord! discord.gg/JzbvtVTBFv :)")
			end
			if server.time > 300 then
				server.time = 300
			end
		end
		----------------------


 -------------------------------------------------------------------------   



 	
    for _, ply in ipairs(players.getAll()) do -- spawn ppl in if the server resets/havent died yet

		
		if ply.human == nil and server.state == 2 and ply.data.hasDied == false then
			
			if ply.data.isButtonPusher == true then 
				local man = humans.create(Vector(2078, 52, math.random(1440, 1437)), orientations.n, ply)
            	man.data.timer = 0
				ply.data.saiddeath = false
			else 
				local man = humans.create((vecRandBetween(Vector(2079.47, 49, 1441.81), Vector(2064.45, 49, 1451.48))), orientations.n, ply)
            	man.data.timer = 0
				ply.data.saiddeath = false
				ply:sendMessage("Get to the end and eliminate the GOATS")
				ply.data.isRunner = true 
				ply.data.isAllowedToTrainWalk = false
				inplaycount = inplaycount + 1
			end

        end

        if ply.data.saiddeath == false and server.state == 2 then -- When player dies
			if ply.human.isAlive == false then -- death messages/hasdied
				chat.announce(string.format("%s %s", ply.name, deathmessages[math.random(#deathmessages)]))
                ply.data.saiddeath = true
                ply.data.hasDied = true 
				if ply.data.isButtonPusher then
					goatkillcount = goatkillcount + 1
				end
				if ply.data.isRunner then
					playerkillcount = playerkillcount + 1
				end


            end	
		end

    
    
    end
  ----------------------------------




    for _, man in ipairs(humans.getAll()) do



		if man.isAlive and server.state == 2 then -- finish line / goat TP 
			if (tick % 2 == 0) then
				if isVectorInCuboid(man.pos, Vector(1895.45, 60, 1447.39), Vector(1894.08, 20, 1449.70)) then -- finish line
					man.player.data.isAllowedToTrainWalk = true
					man:teleport(Vector(2078, 52, math.random(1440, 1437)))
					man.player:sendMessage("You win!")
					man.player:sendMessage("Eliminate the GOATS!")
					local wID = math.random(6) * 2 - 1
					man:arm(wID, 6)
					chat.announce(string.format("%s wins!", man.player.name))
				end
			end

			if tick == 30 then 
				if man.player.data.isAllowedToTrainWalk == true and isVectorInCuboid(man.pos, Vector(1895.02, 50, 1440.95), Vector(2080.18, 58, 1435.36)) ~= true and debug == false then -- goat TP
					man:teleport(Vector(1898, 52, math.random(1440, 1437)))
					man.player:sendMessage("Be careful!")
				end
			end


		end



		if man.isAlive and man.player.data.isButtonPusher == true and server.state == 2 then
			man.stamina = 127
		end


        if fiftyfiftydoor == 1 then -- 50/50 doors
			if isVectorInCuboid(man.pos, Vector(2038.76, 60, 1444.36), Vector(2039.10, 20, 1442.68)) and man.isAlive then
				events.createExplosion(man.pos)
				events.createBulletHit(1, man.pos, normal)
				man:addVelocity(Vector(0, 0.05, 0))
				man.isAlive = false
			end
		elseif fiftyfiftydoor == 2 then
			if isVectorInCuboid(man.pos, Vector(2038.34, 60, 1447.67), Vector(2038.79, 20, 1449.36)) and man.isAlive then
				events.createExplosion(man.pos)
				events.createBulletHit(1, man.pos, normal)
				man:addVelocity(Vector(0, 0.05, 0))
				man.isAlive = false
			end
		end
		
		
		
		
		
		
		
		
		
		
		
		if not man.player then -- removes dead bodies 
            if tick == 59 then
                man.data.timer = man.data.timer + 1
            end
            if man.data.timer == 10 then -- bodies stay for 10 seconds!! 
                man:remove()  
            end
		end


        if man.vehicle ~= nil then -- dont let people in cars
            man.vehicle = nil
        end

        local randomsuitcolor = math.random(1, 10)
        local randomsuittype = math.random(0, 1)
            
        if man.player and man.suitColor == 0 then
            man.suitColor = randomsuitcolor
            man.model = randomsuittype
        end

    end

    -- setting up walls and buttons ------------------------------------------------- I KNOW THIS CAN BE DONE IN A LOOP BUT WHO CARES
    if madeplatforms ~= true then -- sets up everything
		-- buttons
			makeButton(1, 2060, 52, 1439, orientations.n)
			makeButton(2, 2050, 52, 1439, orientations.n)
			makeButton(3, 2020, 52, 1439, orientations.n)
			makeButton(4, 1970, 52, 1439, orientations.n)
			makeButton(5, 1950, 52, 1439, orientations.n)
			makeButton(6, 1930, 52, 1439, orientations.n)
			makeButton(7, 1910, 52, 1439, orientations.n)

		-- 


		-- walls 
			-- side walls 
			local increment = 0
			local incrementtwo = 0 
			for i = 1,62 do 
				makeblockwall(2079 - increment, 48.84, 1452, orientations.n)
				increment = increment + 3
			end

			for i = 1,12 do -- trains
				makewalkwall(2079 - incrementtwo, 48.84, 1440, orientations.w)
				incrementtwo = incrementtwo + 16
			end


			-- 50/50 doors
			makeblockwall(2039, 48.84, 1441, orientations.e)
			makeblockwall(2039, 48.84, 1446, orientations.e)
			makeblockwall(2039, 48.84, 1451, orientations.e)

			-- spawn doors
			makeblockwall(2064, 48.84, 1451, orientations.e, true, 10)
			makeblockwall(2064, 48.84, 1448, orientations.e, true, 10)
			makeblockwall(2064, 48.84, 1445, orientations.e, true, 10)
			makeblockwall(2064, 48.84, 1442, orientations.e, true, 10)
			makeblockwall(2064, 48.84, 1441, orientations.e, true, 10)



			-- rlgl entrance
			makeblockwall(2000, 46.3, 1441, orientations.e)
			makeblockwall(2000, 46.3, 1443, orientations.e)
			makeblockwall(2000, 46.3, 1446, orientations.e)
			makeblockwall(2000, 46.3, 1449, orientations.e)
			makeblockwall(2000, 46.3, 1451, orientations.e)


			makeblockwall(1975, 46.3, 1441, orientations.e)
			makeblockwall(1975, 46.3, 1443, orientations.e)
			makeblockwall(1975, 46.3, 1446, orientations.e)
			makeblockwall(1975, 46.3, 1449, orientations.e)
			makeblockwall(1975, 46.3, 1451, orientations.e)


			

			-- ending wall
			makeblockwall(1895, 48.84, 1441, orientations.e)
			makeblockwall(1895, 48.84, 1443, orientations.e)
			makeblockwall(1895, 48.84, 1446, orientations.e)
			makeblockwall(1895, 48.84, 1451, orientations.e)

		madeplatforms = true
    end


	if tick == 59 then -- red light green light
		

		local rlglchance = math.random(1,4)
		
		if rlglchance == 3 and redlighttimer == 0 then
			redlighttimer = 6
			redlight = true
			local stopsign = items.create(itemTypes[24], Vector(1975, 51, 1446), orientations.n)
			stopsign.isStatic = true 
			stopsign.hasPhysics = false
			stopsign.data.isStopSign = true
			stopsign.data.rotation = 90 -- increase this whenever you want to rotate it, in degrees
			
			stopsign.rot:set(axisAngleToRotMatrix (Vector(0,0,1), (stopsign.data.rotation * math.pi / 180)))



			for _, man in ipairs(humans.getAll()) do
				if isVectorInCuboid(man.pos, Vector(1975, 60, 1440.90), Vector(2000, 40, 1453.43)) and man.isAlive and man.player.data.isRunner == true then -- and man.player.data.isRunner == true
					events.createSound(28, man.pos)
					man:speak("Red Light!", 0)
				end
			end 
		end
			

		if redlight == true then
			for _, man in ipairs(humans.getAll()) do
				if redlighttimer <= 5 and relighttimer ~= 0 then 
					if isVectorInCuboid(man.pos, Vector(1975, 60, 1440.90), Vector(2000, 40, 1453.43)) and man.isAlive and man.player.data.isRunner == true then
						local rigidBodyMan = man:getRigidBody(0)
						if math.abs(rigidBodyMan.vel.x) > 0.015 or math.abs(rigidBodyMan.vel.y) > 0.015 or math.abs(rigidBodyMan.vel.z) > 0.015 then
							events.createSound(math.random(71, 76), Vector(1975, 51, 1446), 1, 0.5)
							local manHead = man:getRigidBody(3)
							for i = 1,5 do
								events.createBulletHit(1, manHead.pos, normal)
							end
							manHead.vel:add(Vector(0.7, 0.2, 0))
							man.isAlive = false
						end
					end
				end
			end
		end
		
		if redlighttimer > 0 then
			redlighttimer = redlighttimer - 1
		end

		

		if redlighttimer == 0 and rlglchance ~= 3 then
			redlight = false
			for _, itm in ipairs(items.getAll()) do
				if itm.data.isStopSign == true then
					itm:remove()
				end
			end



			for _, man in ipairs(humans.getAll()) do
				if isVectorInCuboid(man.pos, Vector(1975, 60, 1440.90), Vector(2000, 40, 1453.43)) and man.isAlive and man.player.data.isRunner == true then
					events.createSound(37, man.pos)
					man:speak("Green light!", 0)
				end
			end 
		end



	end





 
    for _, itm in ipairs(items.getAll()) do

		if itm.data.isBomb == true and itm.physicsSettled == true then
			events.createExplosion(itm.pos)
			
			
			itm:explode()
			itm:remove()
		end


		if itm.type == itemTypes[37] and itm.data.isButton == true then -- Button code
			if itm.parentHuman and tick >= 0 then 
				if itm.data.hasBeenPushed ~= true then
					pushButton(itm.data.buttonNum, itm.parentHuman.player.name)
					itm:unmount()
					events.createSound(37, itm.pos, 1, 2)
					if debug == false then 
						itm.data.hasBeenPushed = true 
					end
				else 
					itm.parentHuman.player:sendMessage("This button has been pushed")
					events.createSound(28, itm.pos, 1, 1)
					itm:unmount()
				end
			end
        end

		if itm.type == itemTypes[43] and itm.data.isWall == true and itm.parentHuman and (tick % 2 == 0) then -- make walls ungrabbable
			itm:unmount()
		end 

		if itm.type == itemTypes[43] and itm.data.isTrapWall == true and server.state == 2 then -- removes trap walls
			if tick == 59 then
				itm.data.timer = itm.data.timer + 1
			end


			if itm.data.timer == itm.data.timerMax and itm.data.isTrapWall then
				itm:remove()
			end
		end




    end

	for _, veh in ipairs(vehicles.getAll()) do
		if veh.data.isTrapCar == true then 
			if veh.data.despawnTimer == nil then
				veh.data.despawnTimer = 0
			end

			if tick == 59 then
				veh.data.despawnTimer = veh.data.despawnTimer + 1
			end

			if veh.data.despawnTimer == 5 then
				veh:remove()
			end
		end
	end


 

end -- end of logic hook


function mode.hooks.LogicRound()
	return hook.override
end

-- function mode.hooks.PostPhysics()
-- 	for _, itm in ipairs(items.getAll()) do
        
-- 		if itm.type == itemTypes[37] and itm.data.isMovingBlock == true and server.state == 2 then
-- 			flux.to(itm.pos, 2, { x = 2028 }):after(itm.pos, 1, { x = 2040 })
-- 			flux.to(itm.rigidBody.pos, 2, { x = 2028 }):after(itm.rigidBody.pos, 1, { x = 2030 })
-- 		end
-- 	end
-- end 
