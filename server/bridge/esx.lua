local ESX = GetResourceState('es_extended'):find('start') and exports['es_extended']:getSharedObject() or nil

if not ESX then return end

function getPlayer(target)
    local xPlayer = ESX.GetPlayerFromId(target)
    return xPlayer
end

function getPlayers()
    local xPlayer = ESX.GetPlayers()
    return xPlayer
end

function getPlayerName(target)
    local xPlayer = ESX.GetPlayerFromId(target)
    return xPlayer.getName()
end

function getPlayerIdentifier(target)
    local xPlayer = ESX.GetPlayerFromId(target)
    return xPlayer.getIdentifier()
end

function GetJob(target)
    local xPlayer = ESX.GetPlayerFromId(target)
    return xPlayer.getJob().name
end

function AddPlayerMoney(Player,account,TotalBill)
    if account == 'bank' then
        Player.addAccountMoney('bank', TotalBill)
    elseif account == 'dirty' then
        Player.addAccountMoney('black_money', TotalBill)
    elseif account == 'cash' then
        Player.addAccountMoney('money', TotalBill)
    end
end