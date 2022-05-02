---@type mode
local mode = ...
mode.name = "Community Service"
mode.author = "Dingus"
-- awesome
local amountoftrash = 950
local pickeduptrash = 0
local trashtable = {
    15,
    19,
    20,
    21,
    22,
    23,
    25,
    27,
    30,
    35,
    44,
    45,
    2,
    4,
    12,
    26,
    36,
    16,
    37,
}





function makeScaryBot()
    local bot = players.createBot()
	if bot ~= nil then
		bot.name = ''
		bot.team = team
		bot.gender = 1
		bot.skinColor = 7
		bot.hairColor = 0
		bot.hair = -1
        bot.eyeColor = math.random(1, 8)
		bot.head = -1
		bot.suitColor = 1
		bot.tieColor = 0
		bot.model = math.random(0, 1)
		bot:update()
		local botMan = humans.create(Vector(1995.89, 129.16, 1473), orientations.n, bot)
		if not botMan then
			bot:remove()
			error('Could not create bot')
		end
	end
end 



local itemmessages = {
    "we're alive you know.",
    "PLEASE I DONT WANT TO DIE",
    "IM ALIVE DONT KILL ME",
    "hello",
    "call it.",
    "theyre watching you.",
    "theres a way out of here. I know it.",
    "i know what you did.",
    "you deserve this.",
    "i deserve this.",
    "do you feel guilty...?",
    "you didnt take your pills this morning.",
    "this place isnt what it seems.",
    "collect it all, youll find it.",
    "dingus is watching you.",
    "why are you here...?",
    "hello",
    "hey",
    "something doesnt feel right...",
    "you okay? you seem ill....",
    "Time stands still here. You are in hell.",
    "A fate worse then death.",
    "4596",
    "a string of numbers is what you're looking for.",
    "can you feel that?",
    "Don't touch me.",
    "Goodbye.",
    "I'll see you in the next life.",
    "I see now.",
    "this is what I needed..",
    "I'm not trash.",
    "You're the one that should be thrown away.",
    "do you really know whats happening here?",
    "you can escape this.",
    "the doctors told you this would happen.",
    "You're inside your head right now.",
    "this isnt what you want...right?",
    "Anothers mans trash.",
    "Nihil hic es",
    ".....................",
    "boop!",
    "run.",
    "If they catch you, theyll just make you take more...",
    "Take me with you.",
    "You didnt see me.",
    "Got a light?",
    "Do you feel the weight of your sins.",
    "I do.",
    "You rat.",
    "Nothing but scum.",
    "Schizo.",
    "You'll get a call soon.",
    "Base32.",
    "You come with a clue.",
    "Stare. At. It.",
}




function makeTrash()
    for i = 1,amountoftrash do
        local trash = items.create(itemTypes[trashtable[math.random(#trashtable)]], vecRandBetween(Vector(1583.18, 53.15, 1689.15), Vector(1553.02, 61.85, 1718.78)), orientations.n)
        trash.data.isTrash = true
        trash.data.collecttimer = 0
    end
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
	gameStarting = false
	math.randomseed(os.time())
    server.time = 36000
    trashcollected = 0

end


function mode.hooks.Logic()
    --server.sunTime = 3600000
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
    if server.state == 1 then -- not sure this is needed?
		server.state = 2
		server.gravity = server.defaultGravity
        makeTrash()
        makeScaryBot()
	end

    if tick % 2 == 0 then 
        server.time = math.random(1000, 10000)
        if server.time == 2000 then 
            events.createSound(math.random(43, 46), Vector(1570, 54, 1701), 4, math.random(1,2))
            server.sunTime = 0
            blinktimer = 3 
        end
        if server.time == 3000 then
            events.createSound(27, vecRandBetween(Vector(1596.07, 20, 1687.98), Vector(1551.69, 80, 1720.30)), 1, 1)

        end

    end



    if blinktimer ~= 0 and blinktimer ~= nil and tick == 59 then 
        blinktimer = blinktimer - 1
    end

    if blinktimer == 0 or blinktimer == nil then 
        server.sunTime = 3825000
    end
    


    if pickeduptrash == amountoftrash - 10 then 
        pickeduptrash = 0
        server:reset()
        for _, ply in ipairs(players.getAll()) do
            if ply.isBot == false then
                ply:sendMessage("Thanks for picking up all that trash!")
                ply:sendMessage("Heres some more!")
                ply.account.data.trashScore = 0
            end
        end
    end
            

    for _, ply in ipairs(players.getAll()) do -- spawn ppl in if the server resets/havent died yet     
        if tick == 10 or tick == 20 or tick == 30 or tick == 40 or tick == 50 or tick == 1 then
            ply.money = math.random(1,999)
            ply:updateFinance()
        end
        
        
        
        
        if ply.human == nil and server.state == 2 then
			local man = humans.create(vecRandBetween(Vector(1594.89, 53.16, 1689.29), Vector(1585.29, 53.16, 1717.99)), orientations.s, ply)
            local memo = items.create(itemTypes[34], man.pos, orientations.n)
            local randomsuitcolor = math.random(1, 10)
            local randomsuittype = math.random(0, 2)

            if man.player.account.data.trashScore == nil then 
                man.player.account.data.trashScore = 0
            end

            man.data.timer = 0
            memo.data.belongsto = man.index
            man:mountItem(memo, 3)



            if man.player.account.data.zerooutmoney == nil then -- for some reason, some ppl have like 7000 dollars joining the server, so to stop people from having that I do this everytime they spawn
                man.player.account.money = 0 
                man.player.money = 0
                man.player:updateFinance()
                man.player.account.data.zerooutmoney = true
           end

            if man.player and man.player.account.data.necklacepreference ~= nil then -- requires Donator Necklace plugin
                man.necklace = man.player.account.data.necklacepreference
            end

            if man.player and man.player.account.data.colorpicked == nil  then -- color changer (requires my plugin for it)
                man.suitColor = randomsuitcolor
            elseif man.player and man.player.account.data.colorpicked ~= nil then
                man.suitColor = man.player.account.data.colorpicked
            end

            if man.player and man.player.account.data.suitpicked == nil then -- suit changer
                man.model = randomsuittype
            elseif man.player and man.player.account.data.colorpicked ~= nil then
                man.model = man.player.account.data.suitpicked
            end

        end

        
    end
 
    if minute == 15 and second == 1 and tick == 30 then -- server reset stuff
        chat.announce("1 minute left to collect all this trash!")
    end
    

    if minute == 16 then -- server reset
        server:reset()
    end



    for _, itm in ipairs(items.getAll()) do
        
        if tick == 59 then 
            if itm.type == itemTypes[39] then
                itm:computerIncrementLine()
                itm:computerSetLine(itm.computerCurrentLine, pcmessages[math.random(#pcmessages)])
            end
        end

        if itm.type == itemTypes[34] and itm.data.welcomesign ~= true then
            local memochange = math.random(1,1000)
            local messagechange = math.random(1,4)
            if memochange > 4 then
                itm:setMemo("Job: 2\n\nWelcome back, you hard worker!\n\nWe got a new job today, \nseems that this apartment is totally TRASHED! haha!\n\n\nHelp keep the public healthy and pick up all this trash!\n\nOnce again of course we will be watching you.\nIt's just standard procedure!")
            else
                if messagechange == 1 then 
                    itm:setMemo("Job: 2\n\nWelcome back, you hard worker!\n\nWe got a new job today, \nseems that this apartment is totally TRASHED! haha!\n\n\nHelp keep the public healthy and pick up all this trash!\n\nOnce again of course we will be watching you.\nIt's just standard procedure!\n\n\n\n\n\n\n\n\n                   help me")
                elseif messagechange == 2 then
                    itm:setMemo("Job: 2\n\nWelcome back, you hard worker!\n\nWe got a new job today, \nseems that this apartment is totally TRASHED! haha!\n\n\nHelp keep the public healthy and pick up all this trash!\n\nOnce again of course we will be watching you.\nIt's just standard procedure!\n\n\n\n\n\n(NDIuMzkzNjA4LCAtNzIuMjk4MDcw)")
                elseif messagechange == 3 then 
                    itm:setMemo("Job: 2\n\nWelcome back, you hard worker!\n\nWe got a new job today, \nseems that this apartment is totally TRASHED! haha!\n\n\nHelp keep the public healthy and pick up all this trash!\n\nOnce again of course we will be watching you.\nIt's just standard procedure!\n\n\n\n\n\n\n\n\n\n\n                               Revelation 8:2   ")
                elseif messagechange == 4 then
                    itm:setMemo("Job: 2\n\nWelcome back, you hard worker!\n\nWe got a new job today, \nseems that this apartment is totally TRASHED! haha!\n\n\nHelp keep the public healthy and pick up all this trash!\n\nOnce again of course we will be watching you.\nIt's just standard procedure!\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n(NB2HI4DTHIXS62JONFWWO5LSFZRW63JPMZZESQTDIR4C42TQM4======)")

                else end
                
            end 
        end 


        if not isVectorInCuboid(itm.pos, Vector(1583.18, 47, 1689.15), Vector(1553.02, 67, 1718.78)) and tick == 59 and itm.data.isTrash then
            pickeduptrash = pickeduptrash + 1
            itm:remove()
        end 


        if itm.parentHuman and itm.data.isTrash == true then 
            if itm.data.beepone == nil then 
                events.createSound(39, itm.pos, 0.5, 4)
                itm.data.beepone = true
                local speakchance = math.random(1,30)
                local scaryroomchance = math.random(1,400)
                if speakchance == 1 then 
                    itm:speak(itemmessages[math.random(#itemmessages)], 0)
                end

                if scaryroomchance == 1 then 
                    itm.parentHuman.data.scaryRoom = true 
                    itm.parentHuman.data.scaryTimer = 0
                    itm.parentHuman.data.lastPos = itm.parentHuman.pos:clone()
                    itm.parentHuman.damage = 50
                    itm.parentHuman:teleport(Vector(1995.83, 129.16, 1486.12))
                    
                    
                end
            end

            if itm.data.collecttimer ~= nil and itm.data.collecttimer < 2 and tick == 59 then 
                itm.data.collecttimer = itm.data.collecttimer + 1
            end 

            if itm.data.collecttimer == 2 then 
                itm.parentHuman.player:sendMessage("Trash collected!")
                itm.parentHuman.player.account.data.trashScore = itm.parentHuman.player.account.data.trashScore + 1
                itm.parentHuman.player:sendMessage(string.format("Your total trash score: %s", itm.parentHuman.player.account.data.trashScore))
                if itm.parentHuman.player.account.data.trashScore == 100 or itm.parentHuman.player.account.data.trashScore == 200 or itm.parentHuman.player.account.data.trashScore == 300 or itm.parentHuman.player.account.data.trashScore == 400 or itm.parentHuman.player.account.data.trashScore == 500 or itm.parentHuman.player.account.data.trashScore == 600 or itm.parentHuman.player.account.data.trashScore == 700 or itm.parentHuman.player.account.data.trashScore == 800 or itm.parentHuman.player.account.data.trashScore == 900 then
                    chat.announce(string.format("%s has picked up %s pieces of trash!", itm.parentHuman.player.name, itm.parentHuman.player.account.data.trashScore))
                    chat.announce("They earn (1) Freedom Point!")
                end
                pickeduptrash = pickeduptrash + 1
                events.createSound(39, itm.pos, 0.5, 6)
                itm:remove()
            end

        end
    end

    
    for _, man in ipairs(humans.getAll()) do
        if man.data.scaryTimer ~= nil and tick == 1 then 
            man.data.scaryTimer = man.data.scaryTimer + 1

            events.createSound(50, man.pos, 4, 3)
              
            
        end

        if man.data.scaryTimer == 2 and man.isAlive and isVectorInCuboid(man.pos, Vector(1988.94, 122, 1468.92), Vector(2004.27, 145, 1498.86)) == true and man.data.scaryRoom == true then 
            man:teleport(man.data.lastPos)
            man.damage = 0
            man.data.scaryRoom = nil
            man.data.scaryTimer = nil
        end



        if tick == 59 and man.isAlive and man.player and man.player.isBot == false then
            if man.isAlive and isVectorInCuboid(man.pos, Vector(1596.07, 20, 1687.98), Vector(1551.69, 80, 1720.30)) == false and man.data.scaryRoom == nil then 
                local sniperhitchance = math.random(1,4)
                events.createSound(math.random(71, 76), Vector(1598, 66, 1598), 6, 0.5)
                if sniperhitchance ~= 1 then 
                    --events.createBullet(1, Vector(1597.96, 66.15, 1599.83), yawToRotMatrix(-man.viewYaw), nil)
                    local bonechance = math.random(0,15)
                    local manHead = man:getRigidBody(bonechance)
                    for i = 1,5 do
                        events.createBulletHit(1, manHead.pos, normal)
                    end
                    --chat.announce(string.format("%s should pick up more trash.", man.player.name))
                    manHead.vel:add(Vector(0, 0.2, 0.3))
                    man:applyDamage(bonechance, math.random(70,100))
                    --man.isAlive = false
                else
                    events.createBulletHit(0, man.pos, normal)
                end
            end




        end


        man.stamina = 127
    --     if man.isAlive ~= true and man.data.zerooutmoney == true and man.data.gavemoney ~= true and man.player.data.lasthitby then
    --         local givemoneyto = findOnePlayer(man.player.data.lasthitby)
    --         for _, ply in ipairs(players.getAll()) do
    --             if givemoneyto == ply.name then
    --                 ply.account.money = ply.account.money + 1
    --                 ply.money = ply.money + 1
    --                 ply:updateFinance()
    --                 man.data.gavemoney = true
    --             end
    --         end
    --     end


        if not man.player then -- removes dead bodies 
            if tick == 59 then
                man.data.timer = man.data.timer + 1
            end
            if man.data.timer == 10 then -- bodies stay for 10 seconds!! 
                man:remove()  
            end

            for _, itm in ipairs(items.getAll()) do -- removes all bonds associated with items that get deleted
                if itm.data.belongsto == man.index then
                    for _, bond in ipairs(bonds.getAll()) do
                        if bond.body == itm.rigidBody then
                            bond.despawnTime = 0
                            bond.isActive = false
                        end
                    end
                    itm:remove()
                end





            end
        end      
    end


end