ESX = exports['es_extended']:getSharedObject()

local AtmModels = {'prop_fleeca_atm', 'prop_atm_01', 'prop_atm_02', 'prop_atm_03'}

for _, model in ipairs(AtmModels) do
    exports.ox_target:addModel(model, {
        {
            event = 'pl-atmrobberyattempt',
            label = 'Atm Robbery',
            icon = 'fas fa-money-bill-wave',
            model = model,
            distance = 1,
        }
    })
end

RegisterNetEvent('pl-atmrobberyattempt')
AddEventHandler('pl-atmrobberyattempt', function(model)
    local src = source

    ESX.TriggerServerCallback('pl-atmrobbery:checkforpolice', function(enoughpolice)
        if enoughpolice then

                ESX.TriggerServerCallback('pl-atmrobbery:checktime', function(time)
                    if time then
                        Wait(200)
                        if Config.PoliceNotify then
                        TriggerServerEvent('pl-atmrobbery:server:policeAlert', 'ATM Robbery in progress')
                        end
                        lib.progressBar({
                            duration = Config.InitialHackDuration,
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
                        TriggerEvent('pl-atmrobbery:StartMinigame', model)
                    else
                        TriggerEvent('pl-atmnotify', Language["Notification"]["wait_robbery"])
                    end
                end)
        end
    end)
end)

RegisterNetEvent('pl-atmrobbery:StartMinigame')
AddEventHandler('pl-atmrobbery:StartMinigame', function(model)
    local src = source
    local playerPed = GetPlayerPed(-1)
    local playerCoords = GetEntityCoords(playerPed)
    local distance = #(playerCoords - model.coords)

    if distance < 3 then
        TriggerEvent("utk_fingerprint:Start", 1, 6, 1, function(outcome, reason)
            if outcome == true then
                lib.progressBar({
                    duration = Config.LootAtmDuration,
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
                TriggerServerEvent('pl-atmrobbery:GiveReward', model, playerCoords)
            elseif outcome == false then
                TriggerServerEvent('pl-atmrobbery:MinigameResult', false)
                TriggerEvent('pl-atmnotify', Language["Notification"]["failed_robbery"])
            end
        end)
    end
end)

RegisterNetEvent('pl-atmnotify')
AddEventHandler('pl-atmnotify', function(msg)
    ESX.ShowNotification(msg)
end)


RegisterNetEvent('pl-atmrobbery:client:policeAlert', function(coords, text)
    local street1, street2 = GetStreetNameAtCoord(coords.x, coords.y, coords.z)
    local street1name = GetStreetNameFromHashKey(street1)
    local street2name = GetStreetNameFromHashKey(street2)
    TriggerEvent("pl-atmnotify",''..text..' at '..street1name.. ' ' ..street2name, 'info')
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