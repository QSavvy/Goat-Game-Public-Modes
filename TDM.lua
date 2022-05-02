---@type Plugin
local mode = ...
mode.name = "TDM"
mode.author = "Dingus"

-- Defines maps
local maps = {
	{ { Vector(1440, 49, 1531.6), Vector(1503.6, 49, 1465) }, "Burger" },
	{ { Vector(1365, 62, 1365), Vector(1320, 29.15, 1313) }, "Mall" },
	{ { Vector(1191, 25.09, 1113), Vector(1315, 25.09, 1036) }, "Stores" },
	{ { Vector(1725, 28.84, 1007), Vector(1839, 65, 984) }, "Rio" },
	{ { Vector(1553, 24.84, 1110), Vector(1622, 46, 1033) }, "powerstation" },
	{ { Vector(1653, 25.09, 1142), Vector(1774, 55, 1217) }, "craneandcrates" },
	{ { Vector(1892, 40.84, 1510), Vector(1817, 40.84, 1582) }, "Suburbs" },
	{ { Vector(1627, 49.09, 1642), Vector(1536, 69, 1568) }, "PoolPark" },
	{ { Vector(1080, 24.67, 1609), Vector(1159, 43, 1737) }, "Truss" },
	{ { Vector(1837, 44.84, 1411), Vector(1915, 25.09, 1316) }, "bigbuildingnexttolumber" },
	{ { Vector(1656, 45.09, 1465), Vector(1727, 72.84, 1583) }, "GreenDiamond" },
	{ { Vector(1225, 109.09, 1561), Vector(1311, 113.09, 1583) }, "TwoTowersWithBridge" },
	{ { Vector(1553, 61.16, 1688), Vector(1627, 49.08, 1718) }, "rooms" },
	{ { Vector(1660, 35.84, 1303), Vector(1806, 93.54, 1413) }, "Lumber" },
	{ { Vector(1607, 44.87, 1403), Vector(1583, 108, 1358) }, "carbillboardbilding" },
	{ { Vector(1163, 25.09, 1219), Vector(1040, 38.69, 1145) }, "parkinglotwithbridge" },
	{ { Vector(1980, 100.87, 1472), Vector(2001, 172, 1497) }, "topofcasino" },
	{ { Vector(1263, 25.08, 1251), Vector(1309, 44.90, 1322) }, "Midas" },
	{ { Vector(1772, 28.84, 1734), Vector(1955, 32.84, 1787) }, "housesnearoxs" },
	{ { Vector(1319, 68, 1503), Vector(1190, 37.45, 1584) }, "theKARThing" },
}

local EVENTS = {
	-- [0] = { init = function() end, update = function() end, destroy = function() end },
	[1] = {
		init = function()
			server.gravity = 0.0019068486
			events.createMessage(0, "MOON GRAVITY ROUND", -1, 1)
		end,
		update = function() end,
		destroy = function() end,
	},
	[2] = {
		init = function()
			events.createMessage(0, "Light/Dark Round.", -1, 1)
		end,
		update = function()
			server.sunTime = server.sunTime + 2400
		end,
		destroy = function() end,
	},
	-- [3] = {
		-- init = function()
			-- events.createMessage(0, "TO THE MOTHERSHIP", -1, 1)
			-- for _, man in ipairs(humans.getAll()) do
				-- if man.isBleeding == true then
					-- man:addVelocity(Vector(0, 0.0060, 0))
				-- end
			-- end

		-- end,
		-- update = function() end,
		-- destroy = function() end,
	-- },
}
local EVENT_SELECTED = nil

local spawnpoints = {}
local availableSpecials = {}
local currentMap
local deathmessages = {
	"obliterated",
	"assassinated",
	"murdered",
	"held hands with",
	"glombledomped on",
	"dibbledooped",
	"bwomped",
	"decimated",
	"RDM'd",
	"shitted on",
	"killed",
	"JFK'd",
	"whacked",
	"wolloped",
	"discombobulated",
	"did what's right to",
	"glomped =3c",
	"pulverized",
	"perswaggled",
	"claimed the bounty on",
	"executed",
	"shagged",
	"exterminated",
	"zapped",
	"deleted",
	"dingus'd",
	"voted off",
	"hacked",
	"doxxed",
	"tool'd",
	"slapped",
	"bricked",
	"lagged out",
	"alt f4'd",
	"esc e'd",
	"rick and mortied",
	"pumped",
	"ratiod",
	":')",
	"hired",
	"had petition not signed by",
	"headbutt",
	"silenced",
	"dunked on",
	"farded on",
	"sold out",
	"sold cheats to",
	"bamboozled",
	"removed social credit from",
	"expired",
	"ran over",
	"badly coded",
	"loves",
	"dated",
	"fired",
	"death stranding'd",
	"<3",
	"pretzled",
	"funnied",
	"tattled on",
	"trolled",
	"pooped on",
	"complicated",
	"divorced",
	"1984'd",
	"snowballed",
	"had an affair with",
	"pizza'd",
	"antidisestablishmented",
	"skrunklied",
	"intimidated",
	"[ERROR]",
	"404'd",
	"beat down",
	"furried",
	"vored",
	"worked on",
	"sdkfjhgdfkjhgdsf",
	"dingus was here",
	"stopped trolling",
	"sprayed down",
	"tagged",
	"mag dumped",
	"ended",
	"cancelled",
	"promoted",
	"goated",
	"saul goodman'd",
	"malcom in the middled",
	"fried",
	"deep fried",
	"bashed",
	"smoked",
	"jerma'd",
	"pissed on",
	"smoked weed with",
	"cried with",
	"diced",
	"fatalitied",
	"won the standoff with",
	"came out of the closet to",
	"flossed on",
	"cranked 90's on",
	"fortnite",
	"gave an 18 karot run of bad luck to",
	"bullied",
	"popped",
	"smelled",
	"sniffed",
	"met",
	"came into contact with",
	"coughed on",
	"gave covid to",
	"drone striked",
	"EMP'd",
	"set fire to",
	"kissed",
	"twerked on",
	"hit a lick on",
	"dranked",
	"what",
	"did something to",
	"did nothing to",
	"subrosa'd",
	"eliminatored",
	"accidentally killed",
	"respecfully talked to",
	"squished",
	"world mode'd",
	"nuked",
	"DDOS'd",
	"had a snack with",
	"folded",
}
function mode.onEnable(isReload)
	tick = 0
	second = 0
	minute = 0
	server.type = TYPE_ROUND
	if not isReload then
		server:reset()
	end
end

function mode.hooks.ResetGame(reason)
	tick = 0
	second = 0
	minute = 0
	server.state = 1
	server.time = 3600
	currentMap = maps[math.random(#maps)]
	spawnpoints = {}
	availableSpecials = {}
	gameStarting = false
	for _, ply in ipairs(players.getAll()) do
		ply.data.kills = 0
	end
	EVENT_SELECTED = nil
end

-- Creates spawn points every time a map is loaded (THIS WORKS LIKE BUTTS MAKE SURE TO FIX IT SO IT ONLY RAYCASTS TOP DOWN AND NOT FROM A RANDOM VECTOR)
local function generateSpawnPoints()
	while #spawnpoints < 40 do
		local point = vecRandBetween(currentMap[1][1], currentMap[1][2])
		-- Ensures the spots can be stood on
		local hit1, hit2, hit3, hit4, hit5
		hit1 = physics.lineIntersectLevel(point, Vector(point.x, point.y - 2, point.z), false).hit
		hit2 = physics.lineIntersectLevel(point, Vector(point.x + 1, point.y - 2, point.z + 1), false).hit
		hit3 = physics.lineIntersectLevel(point, Vector(point.x + 1, point.y - 2, point.z - 1), false).hit
		hit4 = physics.lineIntersectLevel(point, Vector(point.x - 1, point.y - 2, point.z + 1), false).hit
		hit5 = physics.lineIntersectLevel(point, Vector(point.x - 1, point.y - 2, point.z - 1), false).hit
		if hit1 and hit2 and hit3 and hit4 and hit5 then
			point.y = point.y + 0.5
			table.insert(spawnpoints, point)
		end
	end
end

-- Part 1 of "who the fuck shot me"
function mode.hooks.LineIntersectHuman(man, posA, posB)
	if man.player then
		for _, bul in ipairs(bullets.getAll()) do
			if bul.pos:dist(posA) == 0 then
				local bullet, ply2, man2 = bul, bul.player, bul.player ~= nil and bul.player.human
				if man.isAlive then
					man.data.shotBy = ply2
					man.data.deathResolved = 0
				end
				break
			end
		end
	end
end

function mode.hooks.Physics()
    -- 600 here should be the number that gets set to server.time in gameEnding
    if server.state == 2 and gameEnding and tick % (11 - math.floor((600 - server.time) / server.TPS)) == 0 then
        return hook.override
    end

end

function mode.hooks.Logic()
	server.time = server.time - 1
	server.roundTeamDamage = 0

	-- Framework logic to shift through game phases/states
	if server.time == 0 then
		if server.state == 1 then
			server.state = 2
			server.time = 7250 --7250 is 2 mins
			server.sunTime = 1944000 -- 9 am
			server.gravity = server.defaultGravity
			generateSpawnPoints()
			if math.random(1, 4) == 1 then
				EVENT_SELECTED = math.random(#EVENTS)
			end
			if EVENT_SELECTED then
				EVENTS[EVENT_SELECTED].init()
			end
		elseif server.state == 2 then
			if not gameEnding then
				gameEnding = true
                if EVENT_SELECTED then
                    EVENTS[EVENT_SELECTED].destroy()
                end
				events.createMessage(0, "Round over.", -1, 2)
				server.time = 600
				local highestKills
				local highestKillCount = 0
				for _, man in ipairs(humans.getAll()) do
					events.createSound(47, man.pos, 0.5, math.random(5, 7))
				end
				
				
				for _, ply in ipairs(players.getAll()) do
					if ply.data.kills > highestKillCount then
						highestKills = ply.name
						highestKillCount = ply.data.kills
					end
				end
				if highestKills ~= nil then
					events.createMessage(
						0,
						string.format("MVP: %s, Kill count: %s", highestKills, highestKillCount),
						-1,
						1
					)
				else
					events.createMessage(
						0,
						string.format("MVP: Nobody? You guys know what mode you're playing, right?")
					)
				end
			else
                gameEnding = false
				server:reset()
				server.time = 3600
			end
		end
	end
	if EVENT_SELECTED then
		EVENTS[EVENT_SELECTED].update()
	end

	-- Ticks for logic
	tick = tick + 1

	if tick == 60 then
		tick = 0
		second = second + 1
		if second == 60 then
			second = 0
			minute = minute + 1
		end
	end

	-- Values to be counted
	local readyCount = 0

	-- Iterates through all players by creating a table that results from players.getAll()
	for _, ply in ipairs(players.getAll()) do
		if ply.data.kills == nil then
			ply.data.kills = 0
		end

		-- If the player has no human and the game is in play, create a human for them and arm them
		if ply.human == nil and server.state == 2 then
			local man = humans.create(spawnpoints[math.random(#spawnpoints)], orientations.w, ply)
			local wID = math.random(6) * 2 - 1
			man:arm(wID, 6)
			local mag = items.create(itemTypes[wID + 1], man:getInventorySlot(0).primaryItem.pos, orientations.n)
			man:getInventorySlot(0).primaryItem:mountItem(mag)
			man:getInventorySlot(0).primaryItem.bullets = 1
			man:mountItem(man:getInventorySlot(1).primaryItem, 5)
			local bandage = items.create(itemTypes[math.random(13, 14)], man.pos, orientations.n)
			man:mountItem(bandage, 6)
		end

		-- If player is ready, add 1 to readyCount
		if ply.isReady then
			readyCount = readyCount + 1
		end	
		
	end
		
		
		
		
		
	
	-- If 50% of players are ready, lower the time until start (if needed) and announce the game is starting momentarily
	if readyCount >= players.getCount() * 0.5 and not gameStarting then
		gameStarting = true
		events.createMessage(0, "Goat time. Do /goat if you need to respawn!", -1, 1)
		events.createMessage(0, "Also join the Discord! discord.gg/JzbvtVTBFv", -1, 1)
		if server.time > 300 then
			server.time = 300
		end
	end

	for _, man in ipairs(humans.getAll()) do
		local randomsuitcolor = math.random(1, 10)
		local randomsuittype = math.random(0, 1)
		local randomtie = math.random(1, 10)
		local fiftyfifty = math.random(0, 1)
		--randomizes your suit, color, and if you have a tie
		if man.player and man.suitColor == 0 then
			man.suitColor = randomsuitcolor
			man.model = randomsuittype
			if fiftyfifty == 1 then
				man.tieColor = randomtie
			else
			end
		end

		if not man.player then -- removes dead bodies
			man.tieColor = 0
			man:remove()
		end
		if man.bloodLevel < 51 then --stops you from being downed
			man.isAlive = false
			man.tieColor = 0
			man.suitColor = 0
		end
		
		
		
		-- kills if too high up
		
		-- if man.pos.x > 

		-- If a person dies within two ticks of being shot, announces who killed them and gives the player a kill (for score), as well as awarding them money
		-- Also known as part 2 of "who the fuck shot me"
		if man.data.deathResolved ~= nil then
			man.data.deathResolved = man.data.deathResolved + 1
			if not man.isAlive then
				man.data.deathResolved = nil
				man.data.shotBy.data.kills = man.data.shotBy.data.kills + 1
				man.data.shotBy.money = man.data.shotBy.money + 100
				man.data.shotBy:updateFinance()
				local weapon
				if man.data.shotBy.human:getInventorySlot(0).primaryItem.data.special ~= nil then
					weapon = man.data.shotBy.human:getInventorySlot(0).primaryItem.data.special
				else
					weapon = man.data.shotBy.human:getInventorySlot(0).primaryItem.type.name
				end
				if man.player ~= nil then
					if not man.player.isBot and man.player.name ~= nil and man.data.shotBy.name ~= nil then
						events.createMessage(0, string.format("%s %s %s (%s, %s meters)", man.data.shotBy.name, deathmessages[math.random(#deathmessages)], man.player.name, weapon, tostring(math.floor(man.pos:dist(man.data.shotBy.human.pos))) ), -1, 1)
					elseif man.player.isBot and man.data.shotBy.name ~= nil then
						events.createMessage(
							0,
							string.format(
								"%s %s a bot (%s, %s meters)",
								man.data.shotBy.name,
								deathmessages[math.random(#deathmessages)],
								man.data.shotBy.human:getInventorySlot(0).primaryItem.data.special
									or man.data.shotBy.human:getInventorySlot(0).primaryItem.type.name,
								tostring(math.floor(man.pos:dist(man.data.shotBy.human.pos)))
							),
							-1,
							1
						)
					end
				end
			elseif man.data.deathResolved > 1 then
				man.data.deathResolved = nil
			end
		
		end
		
		
		-- sprint 
		-- if bit32.band(man.inputFlags, 16) == 16 then
			-- man:addVelocity(Vector((math.sin(man.viewYaw)/2000), 0.000, -(math.cos(man.viewYaw)/2000)))
		-- end
		
	-- Jetpack Function
	--	man.data.jetSoundCool = math.max((man.data.jetSoundCool or 0) - 1, 0)
	--	if bit32.band(man.inputFlags, 4) == 4 and man.bloodLevel > 60 then
	--		man:addVelocity(Vector((math.sin(man.viewYaw)/2000), 0.0030, -(math.cos(man.viewYaw)/2000)))
	--		if man.data.jetSoundCool < 1 then
	--			man.data.jetSoundCool = 0.1 * server.TPS
	--			events.createSound(28, man.pos, 1, man.pos.y / 200) --sound 28, 250
	--		end
	--	end
		--double jump
		-- local hasjumped = false
		-- if bit32.band(man.inputFlags, 4) == 4 and man.isOnGround == false and hasjumped == false then
			-- hasjumped = true
			-- if bit32.band(man.inputFlags, 4) == 4 and hasjumped == true then
				-- hasjumped = false
				-- man:addVelocity(Vector(0, 0.0050, 0))
				-- end
			-- end
			
			
		-- admin launch self input
		-- if bit32.band(man.inputFlags, 8) == 8 and bit32.band(man.inputFlags, 4) == 4 then
			-- for _, ply in ipairs(players.getAll()) do
				-- if ply.isAdmin == true then
					-- man:addVelocity(Vector(0, 0.2, 0))
					
				-- end
			-- end
		-- end
		
		
		-- makes beeping sound when dead
		-- if not man.isAlive then
			-- events.createSound(28, man.pos, 1, 1)
		-- end
		-- if man.isBleeding == true then
			-- man:addVelocity(Vector(0, 1, 0))
			-- events.createSound(28, man.pos, 1, man.pos.y / 200)
		-- end

		-- Bandage Regen
		if man.progressBar == 255 then
			man.chestHP = 100
			man.headHP = 100
			man.leftArmHP = 100
			man.rightArmHP = 100
			man.leftLegHP = 100
			man.rightLegHP = 100
			man.bloodLevel = 100
		end

		-- Infinite Stamina
		man.stamina = 127
	end


	for _, itm in ipairs(items.getAll()) do
		if itm.physicsSettled == true then
			itm:remove()
		end
	end



end



function mode.hooks.LogicRound()
	return hook.override
end
