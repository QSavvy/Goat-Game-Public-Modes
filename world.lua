---@type Plugin
local mode = ...
mode.name = 'World'
mode.author = 'Dingus'
-- lets do this.




local serverVersion = "0.7"

mode:addEnableHandler(function (isReload)
	server.type = TYPE_WORLD
	if not isReload then
		server:reset()
	end
end)
function mode.hooks.PostResetGame()
	server.worldCrimeNoSpawn = 600
	server.worldMinCash = 1000
	server.worldTraffic = 150
	server.worldStartCash = 1000
	server.worldCrimeCivCiv = 20
	server.worldCrimeCivTeam = 20
	server.worldCrimeTeamCiv = 30
	server.worldCrimeTeamTeam = 0
	server.worldCrimeTeamTeamInBase = 10
	server.maxPlayers = 80
	--server.crimeNoBuy = 100

	tick = 0

	vehicleTypes[12].price = 60000 -- Heli
	
	
	itemTypes[9].price = 500-- UZI
	itemTypes[10].price = 50 -- UZI MAG






end

function mode.hooks.Logic()

	if tick < 60 then
		tick = tick + 1
	else  
		tick = 0
	end

	if tick == 30 then
		for _, man in ipairs(humans.getAll()) do
			man.stamina = 127

			if man.isAlive == false then
				 -- removes dead bodies 
					man.data.timer = man.data.timer + 1
			end
			if man.data.timer == 10 then -- bodies stay for 10 seconds!! 
				man:remove()  
			end
			
			if man.data.beenGivenPaper ~= true then 
				if isVectorInCuboid(man.pos, Vector(2992, 44, 1507), Vector(2895, 17, 1569)) then
					if man:getInventorySlot(0).primaryItem == nil and man.isAlive then
						local memo = items.create(itemTypes[34], man.pos, orientations.n)
						memo:setMemo(string.format("Welcome to Goat Game World, %s! [V%s]\nCurrent player count: %s        Discord: Discord.gg/JzbvtVTBFv\n\nThis server is mainly vanilla right now besides\na few changes, mainly parkour, helis, and car crashes\n\n/parkour | parkour help\n/color | change your shirt\n/prot | see your protection status\n/necklace | change your necklace (donator only)\n/credits | credits! (Thank u guys)\n\nEnjoy your time here! Hopefully we can make this a fun server!\n\n\nWHATS NEW (4/30/22):\n- Server has been put on a VPN to prevent the DDOSing\n network performance may be degraded, apologies.\n- Car crashes disabled for now\n- Bots have a 1/5 chance to drop knife on death\n- Added Emotes (/e)\n\nTO-DO\n- TPS Fixes", man.player.name, serverVersion, players.getCount()))
						man:mountItem(memo, 0)
						man.data.beenGivenPaper = true 
					end
				end
			end
		end 
	
		for _, ply in ipairs(players.getAll()) do
			if ply.spawnTimer > 0 then
				ply.spawnTimer = 0
			end 
		end 
	end

end -- end of logic hook


mode:addHook("EconomyCarMarket", function()
    for k, v in ipairs(buildings.getAll()) do
        if v.type == 3 then
            local car = v:getShopCar(1)
            local veh = vehicleTypes[12]
            car.type = veh
            car.color = math.random(0, 5)
            car.price = veh.price
        end
    end
end)


mode:addHook("PostHumanCreate", function(Human)
	Human.data.timer = 0
	if Human.player.isBot ~= true then	
		if Human.player.team == 17 then
			Human.suitColor = Human.player.account.data.colorpicked or math.random(1, 10)
			
		end
	else -- bots spawning with knife
		if math.random(1,5) == 1 then
			local knife = items.create(itemTypes[27], Human.pos, orientations.n)
			Human:mountItem(knife, 4)
			knife.data.isKnife = true
			knife.data.belongsTo = Human.index
		end
	end
		
end)

