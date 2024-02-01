ESX = exports['es_extended']:getSharedObject()
local lastRobberyTime = 0

ESX.RegisterServerCallback('pl-atmrobbery:checkforpolice', function(source, cb)
    local copcount = 0
    local xPlayers = ESX.GetPlayers()

    for i = 1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer.job.name == Config.JobName then
            copcount = copcount + 1
        end
    end

    if copcount >= Config.PoliceOnline then
        cb(true)
    else
        cb(false)
    end
end)

ESX.RegisterServerCallback('pl-atmrobbery:checktime', function(source, cb)
    local playerId = source
    local player = ESX.GetPlayerFromId(playerId)

    if (os.time() - lastRobberyTime) < Config.CooldownTimer and lastRobberyTime ~= 0 then
        local secondsRemaining = Config.CooldownTimer - (os.time() - lastRobberyTime)
        cb(false)
    else
        lastRobberyTime = os.time()
        cb(true)
    end
end)

RegisterServerEvent('pl-atmrobbery:MinigameResult')
AddEventHandler('pl-atmrobbery:MinigameResult', function(success)
    local src = source

    if not success then
        lastRobberyTime = 0 
    end
end)

RegisterNetEvent('pl-atmrobbery:GiveReward')
AddEventHandler('pl-atmrobbery:GiveReward', function(model, playerCoords)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local Identifier = xPlayer.getIdentifier(src)
    local PlayerName = xPlayer.getName()
    local distance = #(playerCoords - model.coords)

    if distance < 5 then
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer then
            xPlayer.addAccountMoney('black_money', Config.Reward)
            TriggerEvent('pl-atmnotify', 'You have robbed ' .. Config.Reward .. ' $')
        end
    else
        print('**Name:** '..PlayerName..'\n**Identifier:** '..Identifier..'** Attempted Exploit : Possible Hacker**')
    end
end)

RegisterNetEvent('pl-atmrobbery:server:policeAlert', function(text)
    local src = source
    local ped = GetPlayerPed(src)
    local coords = GetEntityCoords(ped)
    local players = ESX.GetPlayers()

    for _, v in pairs(players) do
        local xPlayer = ESX.GetPlayerFromId(v)
        
        if xPlayer and xPlayer.getJob().name == 'police' then
            local alertData = {title = "Alert", coords = {x = coords.x, y = coords.y, z = coords.z}, description = text}
            TriggerClientEvent('pl-atmrobbery:client:policeAlert', v, coords, text)
        end
    end
end)
