

for _, model in ipairs(Config.AtmModels) do
    if Config.Target == 'qtarget' then
        exports['qtarget']:AddTargetModel(model, {
            options = {
                {
                    event = 'pl_atmrobberyattempt',
                    icon = 'fas fa-money-bill-wave',
                    label = 'ATM Robbery',
                    model = model,
                }
            },
            distance = 1.0
        })
    elseif Config.Target == 'ox-target' then
        exports.ox_target:addModel(model, {
            {
                event = 'pl_atmrobberyattempt',
                label = 'ATM Robbery',
                icon = 'fas fa-money-bill-wave',
                model = model,
                distance = 1,
            }
        })
    elseif Config.Target == 'qb-target' then
        exports['qb-target']:AddTargetModel(model, {
            options = {
                {
                    type = "client",
                    event = 'pl_atmrobberyattempt',
                    icon = 'fas fa-money-bill-wave',
                    label = 'ATM Robbery',
                    model = model,
                }
            },
            distance = 1.0
        })
    end
end

RegisterNetEvent('pl_atmrobbery:notification')
AddEventHandler('pl_atmrobbery:notification', function(message, type)

    if Config.Notify == 'ox' then
        TriggerEvent('ox_lib:notify', {description = message, type = type or "success"})
    elseif Config.Notify == 'esx' then
        Notification(message)
    elseif Config.Notify == 'okok' then
        TriggerEvent('okokNotify:Alert', message, 6000, type)
    elseif Config.Notify == 'qb' then
        Notification(message, type)
    elseif Config.Notify == 'wasabi' then
        exports.wasabi_notify:notify('Halloween', message, 6000, type, false, 'fas fa-ghost')
    elseif Config.Notify == 'custom' then
        -- Add your custom notifications here
    end
end)

RegisterNetEvent('pl_atmrobberyattempt')
AddEventHandler('pl_atmrobberyattempt', function(data)
    local entity = data.entity
    if entity and DoesEntityExist(entity) then
        local atmcoords = GetEntityCoords(entity)
        if not IsPedHeadingTowardsPosition(PlayerPedId(), atmcoords, 10.0) then
			TaskTurnPedToFaceCoord(PlayerPedId(), atmcoords, 1500)
		end
        local enoughpolice = lib.callback.await('pl_atmrobbery:checkforpolice', false)
        if enoughpolice then
            local checktime = lib.callback.await('pl_atmrobbery:checktime', false)
            if checktime then
                Wait(200)
                if Config.Police.notify then
                    TriggerServerEvent('pl_atmrobbery:server:policeAlert', 'ATM Robbery in progress')
                end
                lib.progressBar({
                    duration = Config.Hacking.InitialHackDuration,
                    label = 'Initializing Hack',
                    useWhileDead = false,
                    canCancel = false,
                    disable = {
                        car = true,
                        move = true,
                        combat = true,
                    },
                    anim = {
                        dict = 'missheist_jewel@hacking',
                        clip = 'hack_loop',
                    }
                })
                TriggerEvent('pl_atmrobbery:StartMinigame', model,atmcoords)
            else
                TriggerEvent('pl_atmrobbery:notification', locale("wait_robbery"),'error')
            end
        else
            TriggerEvent('pl_atmrobbery:notification', locale("not_enough_police"),'error')
        end
    end
    
end)

function LootATM(outcome,model,atmcoords)
    if outcome == true then
        lib.progressBar({
            duration = Config.Hacking.LootAtmDuration,
            label = 'Collecting Cash',
            useWhileDead = false,
            canCancel = false,
            disable = {
                car = true,
                move = true,
                combat = true,
            },
            anim = {
                dict = 'oddjobs@shop_robbery@rob_till',
                clip = 'loop', 
            }
        })
        TriggerServerEvent('pl_atmrobbery:GiveReward', model,atmcoords)
    elseif outcome == false then
        TriggerServerEvent('pl_atmrobbery:MinigameResult', false)
        TriggerEvent('pl_atmrobbery:notification', locale("failed_robbery"),'error')
    end
end

RegisterNetEvent('pl_atmrobbery:StartMinigame')
AddEventHandler('pl_atmrobbery:StartMinigame', function(model,atmcoords)
    local playerPed = GetPlayerPed(-1)

    if Config.Hacking.Minigame == 'utk_fingerprint' then
        TriggerEvent("utk_fingerprint:Start", 1, 6, 1, function(outcome, reason)
            LootATM(outcome,model,atmcoords)
        end)
    elseif Config.Hacking.Minigame == 'ox_lib' then
        local outcome = lib.skillCheck({'easy', 'easy', {areaSize = 60, speedMultiplier = 2}, 'easy'}, {'w', 'a', 's', 'd'})
        LootATM(outcome,model,atmcoords)
    end
end)


RegisterNetEvent('pl_atmrobbery:client:policeAlert', function(coords, text)
    local street1, street2 = GetStreetNameAtCoord(coords.x, coords.y, coords.z)
    local street1name = GetStreetNameFromHashKey(street1)
    local street2name = GetStreetNameFromHashKey(street2)
    TriggerEvent("pl_atmrobbery:notification",''..text..' at '..street1name.. ' ' ..street2name, 'success')
    PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
    local transG = 250
    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    local blip2 = AddBlipForCoord(coords.x, coords.y, coords.z)
    local blipText = text
    SetBlipSprite(blip, 60)
    SetBlipSprite(blip2, 161)
    SetBlipColour(blip, 1)
    SetBlipColour(blip2, 1)
    SetBlipDisplay(blip, 4)
    SetBlipDisplay(blip2, 8)
    SetBlipAlpha(blip, transG)
    SetBlipAlpha(blip2, transG)
    SetBlipScale(blip, 0.8)
    SetBlipScale(blip2, 2.0)
    SetBlipAsShortRange(blip, false)
    SetBlipAsShortRange(blip2, false)
    PulseBlip(blip2)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName(blipText)
    EndTextCommandSetBlipName(blip)
    while transG ~= 0 do
        Wait(180 * 4)
        transG = transG - 1
        SetBlipAlpha(blip, transG)
        SetBlipAlpha(blip2, transG)
        if transG == 0 then
            RemoveBlip(blip)
            return
        end
    end
end)