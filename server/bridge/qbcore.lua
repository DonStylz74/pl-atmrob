local QBCore = GetResourceState('qb-core'):find('start') and exports['qb-core']:GetCoreObject() or nil

if not QBCore then return end

function getPlayer(target)
    local xPlayer = QBCore.Functions.GetPlayer(target)
    return xPlayer
end

function getPlayers(target)
    local xPlayer = QBCore.Functions.GetPlayers(target)
    return xPlayer
end

function getPlayerName(target)
    local xPlayer = QBCore.Functions.GetPlayer(target)

    return xPlayer.PlayerData.charinfo.firstname .. " " .. xPlayer.PlayerData.charinfo.lastname
end

function getPlayerIdentifier(target)
    local xPlayer = QBCore.Functions.GetPlayer(target)

    return xPlayer.PlayerData.citizenid
end

function GetJob(target)
    local xPlayer = QBCore.Functions.GetPlayer(target)
    return xPlayer.PlayerData.job.name
end

function AddPlayerMoney(Player,account,TotalBill)
    local source = Player.PlayerData.source
    if account == 'bank' then
        Player.Functions.AddMoney('bank', TotalBill)
    elseif account == 'cash' then
        Player.Functions.AddMoney('cash', TotalBill)
    elseif account == 'dirty' then
        if Config.Inv == 'newqb' then
            local info = {worth = TotalBill}
            exports['qb-inventory']:AddItem(source, 'markedbills', 1, false, info)
            TriggerClientEvent('qb-inventory:client:ItemBox', source, QBCore.Shared.Items['markedbills'], "add", info)
        elseif Config.Inv == 'qb' then
            local info = {worth = TotalBill}
            Player.Functions.AddItem('markedbills', 1, false, info)
            TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items['markedbills'], "add", info)
        end
    end
end