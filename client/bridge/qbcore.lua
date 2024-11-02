local QBCore = GetResourceState('qb-core'):find('start') and exports['qb-core']:GetCoreObject() or nil

if not QBCore then return end

function Notification(message, type)
    QBCore.Functions.Notify(message, type)
end