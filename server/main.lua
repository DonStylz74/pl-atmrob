
local lastRobberyTime = 0
local resourceName = 'pl-atmrob'
lib.versionCheck('pulsepk/pl-atmrob')
lib.locale()

local isEsExtendedStarted = GetResourceState('es_extended') == 'started'
local isQbCoreStarted = GetResourceState('qb-core') == 'started'


--credits to Lation for checkforpolice
--https://github.com/IamLation/lation_247robbery
lib.callback.register('pl_atmrobbery:checkforpolice', function()
    
    local copCount, jobs = 0, {}
    for _, job in pairs(Config.Police.Job) do
        jobs[job] = true
    end
    local requiredJob = Config.Police.Job
    local requiredCount = Config.Police.required

    if isEsExtendedStarted then
        for _, player in pairs(getPlayers()) do
            if jobs[player.getJob().name] then
                copCount = copCount + 1
            end
        end
    elseif isQbCoreStarted then
        for _, playerId in pairs(getPlayers()) do
            local player = getPlayer(playerId)
            if jobs[player.PlayerData.job.name] and player.PlayerData.job.onduty then
                copCount = copCount + 1
            end
        end
    end
    return copCount >= requiredCount
end)


lib.callback.register('pl_atmrobbery:checktime', function()
    local timePassed = os.time() - lastRobberyTime

    if lastRobberyTime ~= 0 and timePassed < Config.CooldownTimer then
        return false, Config.CooldownTimer - timePassed
    end

    lastRobberyTime = os.time()
    return true
end)



RegisterServerEvent('pl_atmrobbery:MinigameResult')
AddEventHandler('pl_atmrobbery:MinigameResult', function(success)
    if not success then
        lastRobberyTime = 0 
    end
end)
RegisterNetEvent('pl_atmrobbery:GiveReward')
AddEventHandler('pl_atmrobbery:GiveReward', function(atmCoords)
    local src = source
    local Player = getPlayer(src)
    local Identifier = getPlayerIdentifier(src)
    local PlayerName = getPlayerName(src)
    local ped = GetPlayerPed(src)
    local distance = GetEntityCoords(ped)
    if #(distance - atmCoords) <= 5 then
        if Player then
            if not Config.MoneyDrop then
                AddPlayerMoney(Player,Config.Reward.account,Config.Reward.reward)
            else
                AddPlayerMoney(Player,Config.Reward.account,Config.Reward.cash_prop_value)
                TriggerClientEvent('pl_atmrobbery:notification',src,locale('server_pickup_cash', Config.Reward.cash_prop_value), 'success')
            end
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
    local requiredJob = Config.Police.Job

    if isEsExtendedStarted then
        for _, player in pairs(getPlayers()) do
            if player.getJob().name == requiredJob then
                TriggerClientEvent('pl_atmrobbery:client:policeAlert', player.source, coords, text)
            end
        end
    elseif isQbCoreStarted then
        for _, playerId in pairs(getPlayers()) do
            local player = getPlayer(playerId)
            if player.PlayerData.job.name == requiredJob and player.PlayerData.job.onduty then
                TriggerClientEvent('pl_atmrobbery:client:policeAlert', playerId, coords, text)
            end
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

