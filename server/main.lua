
local lastRobberyTime = 0
local resourceName = 'pl-atmrob'
lib.versionCheck('pulsepk/pl-atmrob')

lib.callback.register('pl_atmrobbery:checkforpolice', function()
    local src = source
    local copcount = 0
    local xPlayers = getPlayers(src)
    for i = 1, #xPlayers, 1 do
        local xPlayer = getPlayer(xPlayers[i])
        if GetJob(src) == Config.Police.Job then
            copcount = copcount + 1
        end
    end
    print(copcount)
    if copcount >= Config.Police.required then
        return true
    else
        return false
    end
end)

lib.callback.register('pl_atmrobbery:checktime', function()
    local playerId = source
    local player = getPlayer(playerId)

    if (os.time() - lastRobberyTime) < Config.CooldownTimer and lastRobberyTime ~= 0 then
        local secondsRemaining = Config.CooldownTimer - (os.time() - lastRobberyTime)
        return false
    else
        lastRobberyTime = os.time()
        return true
    end
end)


RegisterServerEvent('pl_atmrobbery:MinigameResult')
AddEventHandler('pl_atmrobbery:MinigameResult', function(success)
    if not success then
        lastRobberyTime = 0 
    end
end)

RegisterNetEvent('pl_atmrobbery:GiveReward')
AddEventHandler('pl_atmrobbery:GiveReward', function(model,atmcoords)
    local src = source
    local Player = getPlayer(src)
    local Identifier = getPlayerIdentifier(src)
    local PlayerName = getPlayerName(src)
    local ped = GetPlayerPed(src)
    local distance = GetEntityCoords(ped)
    if #(distance - atmcoords) <= 5 then
        if Player then
            AddPlayerMoney(Player,Config.Reward.account,Config.Reward.amount)
            TriggerClientEvent('pl_atmrobbery:notification',src,'You have robbed ' .. Config.Reward.amount .. ' $', 'success')
        end
    else
        print('**Name:** '..PlayerName..'\n**Identifier:** '..Identifier..'** Attempted Exploit : Possible Hacker**')
    end
end)

RegisterNetEvent('pl_atmrobbery:server:policeAlert', function(text)
    local src = source
    local ped = GetPlayerPed(src)
    local coords = GetEntityCoords(ped)
    local players = getPlayers()

    for _, v in pairs(players) do
        local xPlayer = getPlayer(v)
        
        if xPlayer and GetJob(src) == 'police' then
            local alertData = {title = "Alert", coords = {x = coords.x, y = coords.y, z = coords.z}, description = text}
            TriggerClientEvent('pl_atmrobbery:client:policeAlert', v, coords, text)
        end
    end
end)

local WaterMark = function()
    SetTimeout(1500, function()
        print('^1['..resourceName..'] ^2Thank you for Downloading the Script^0')
        print('^1['..resourceName..'] ^2If you encounter any issues please Join the discord https://discord.gg/c6gXmtEf3H to get support..^0')
        print('^1['..resourceName..'] ^2Enjoy a secret 20% OFF any script of your choice on https://pulsescripts.tebex.io/freescript^0')
        print('^1['..resourceName..'] ^2Using the coupon code: SPECIAL20 (one-time use coupon, choose wisely)^0')
    
    end)
end

WaterMark()

