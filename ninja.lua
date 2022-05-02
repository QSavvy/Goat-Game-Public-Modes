---@type Plugin
local mode = ...
mode.name = "Ninja"
mode.author = "Dingus"
-- A remake of the classic ninja Mode 

local function makeblockwall(x, y, z, orientation) -- will make a wall you cant walk through
    local blockwall = items.create(itemTypes[43], Vector(x, y, z), orientation)
    blockwall.isStatic = true
    blockwall.hasPhysics = true
end

local function makecarstep(x, y, z) -- makes steps
    --local step = items.create(itemTypes[38], Vector(x, y, z), orientation)
    local step = items.create(itemTypes[38], Vector(x, y, z), orientations.n)
   
    step.isStatic = true
    step.hasPhysics = true
    --step.rigidBody.rot = pitchToRotMatrix(180)
    local carstep = vehicles.create(vehicleTypes.getByName("Town Car"), Vector(x, y, z), orientations.e, math.random(0, 5))
    carstep.controllableState = 0
    if step then 
        carstep.rigidBody:bondTo(step.rigidBody, Vector(0, 0, 0), Vector(0, 0, 0))
        --carstep.rigidBody.rot = rollToRotMatrix(90)
    end

    -- if amountofcars == amounttoplace and madecase ~= true then 
    --     local case = items.create(itemTypes[15], Vector(x, (y + 1), z, orientations.n))
    --     case.hasPhysics = false
    --     case.rigidBody:bontTo(step.rigidBody, Vector(0, 0, 0), Vector(0, 1, 0))
    --     madecase = true
    -- end
end

local function finishline(pos) --finish line stuff
	for _, man in ipairs(humans.getAll()) do
		if man.pos:distSquare(pos) < 4 and man.player.data.hasWon ~= true then
			man.player.data.hasWon = true
			chat.announce(string.format("%s wins!!", man.player.name))
            someonewon = true

		end
	end
end

local deathmessages = { -- death messages for death idk
	"splatted",
    "died",
    "hit the ground",
    "fell to their death",
    "went really fast (downward)",
    "diiiiiiiied",
    "expired",
    ", goodbye!", 
    "was squid gamed omgggg squid game",
    "dieddddddddd",
    "got hurt", 
    "trick or treated", 
    "fell off the platform",
    "IS IN YOUR WALLS",
    "did a backflip",
    "played goat game",
}


function mode.onEnable(isReload)
	tick = 0
	second = 0
	minute = 0
	server.type = TYPE_ROUND
end
local madecase
local madeplatforms 
local deathcount 
local amountofcars
local amounttoplace
local lastcarz = 0
local someonewon
function mode.hooks.ResetGame(reason)
	tick = 0
	second = 0
	minute = 0
	server.state = 2
	server.time = 14500
    madeplatforms = false
    deathcount = 0
    amountofcars = 0
    madecase = false
    amounttoplace = math.random(players.getCount(), players.getCount() * 2)
    someonewon = false
	math.randomseed(os.time())
    for _, ply in ipairs(players.getAll()) do
        ply.data.hasDied = false
        ply.data.hasbeenarmed = false
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

    if server.state == 1 then --makes it 2 mins 
		server.state = 2
		server.sunTime = 2592000 -- 7 am
		server.gravity = server.defaultGravity
	end

    if server.state == 2 and server.time == 60 then -- play sound/ annouce that nobody won if time runs out
        chat.announce("Nobody wins")
        for _, man in ipairs(humans.getAll()) do
            events.createSound(27, man.pos, 1, 1)
        end
    end
    if server.state == 2 and server.time == 0 and players.getCount() >= 1 then -- if time runs out then reset the server
        server:reset()
    end

 -------------------------------------------------------------------------   
    for _, ply in ipairs(players.getAll()) do -- spawn ppl in if the server resets/havent died yet
		if ply.human == nil and server.state == 2 and ply.data.hasDied == false then
			local man = humans.create(Vector(math.random(1046, 1080), 165, 1783), orientations.n, ply)
            ply.data.saiddeath = false
            ply.data.hasWon = false
        end

        if ply.data.saiddeath == false then -- death messages
			if ply.human.isAlive == false then -- death messages
				chat.announce(string.format("%s %s", ply.name, deathmessages[math.random(#deathmessages)]))
                ply.data.saiddeath = true
                ply.data.hasDied = true 
                deathcount = deathcount + 1
            end	
		end
        if ply.data.hasWon == true and ply.data.hasbeenarmed ~= true then
            local wID = math.random(6) * 2 - 1
            ply.human:arm(wID, 5)
            ply.data.hasbeenarmed = true
        end
    
    
    end
  
    
    
    
    
    if humans.getCount() <= 0 and players.getCount() >= 1 then -- reset if everyones dead
        server:reset()
    end
    
    --for _, veh in ipairs(vehicles.getAll()) do
    --    if veh.data.numberinline == amounttoplace  then
    --        veh.data.islast = true

    --    else
    --        veh.data.islast = false
   --     end
   -- end

    local increment = 0
    local updown = 0

    for _, man in ipairs(humans.getAll()) do -- finish line (find a way to make the vector the last cars vector)
        if not man.player then -- removes dead bodies 
            man:remove()
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

    -- setting up building -------------------------------------------------
    if madeplatforms ~= true then -- this blocks off the door way, runs once per game so pretty much anything that needs to be done once a game can be put here 
        makeblockwall(1086, 165, 1796, orientations.n)
        makeblockwall(1086, 166, 1796, orientations.n)
        madeplatforms = true
    end
    
 
    for _, itm in ipairs(items.getAll()) do
        if itm.type == itemTypes[38] then -- if its pickedup, drop
			if itm.parentHuman and tick == 30 then 
				itm:unmount()
			end
        end
    end




    while amountofcars ~= amounttoplace do -- this actually places the cars
        amountofcars = amountofcars + 1
        increment = increment + 2.3
        updown = updown + math.random(-0.5, 0.5)
        makecarstep(1062, (164 + updown), (1768 - increment))
        lastcarz = (1768 - increment)

    end
    --if tick == 30 then -- debugging
     --   chat.announce(string.format("%s", lastcarz))
   -- end

    finishline(Vector(1062, 164 + updown, lastcarz))


    -- if amountofcars >= amounttoplace then
    --     if madecase ~= true then
    --         items.create(itemTypes[15], Vector(lastcarposx, (lastcarposy + 1), lastcarposz, orientations.n))
    --         case.hasPhysics = false
    --         case.isStatic = true
    --         chat.announce("case made!")
    --         madecase = true

    --     end
    -- end





end -- end of logic hook


function mode.hooks.LogicRound()
	return hook.override
end