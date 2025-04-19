local cashObjects = {}

local atmModels = {
    ["prop_atm_01"] = vector3(0.202237, -0.20293, 0.779063),
    ["prop_atm_02"] = vector3(0.01,0.11,0.92),
    ["prop_atm_03"] = vector3(-0.14,-0.01,0.88),
    ["prop_fleeca_atm"] = vector3(0.127, 0.017, 1.0)
}


for _, model in ipairs(Config.AtmModels) do
    if Config.Target == 'ox-target' then
        local options = {}
        if Config.EnableHacking then
            table.insert(options, {
                event = 'pl_atmrobbery_hack',
                label = locale('hack_atm_label'),
                icon = 'fas fa-laptop-code',
                model = model,
                distance = 1,
                items = Config.HackingItem,
            })
        end
        if Config.EnableDrilling then
            table.insert(options, {
                event = 'pl_atmrobbery_drill',
                label = locale('drill_atm_label'),
                icon = 'fas fa-tools',
                model = model,
                distance = 1,
                items = Config.DrillItem,
            })
        end
        exports.ox_target:addModel(model, options)
        
    elseif Config.Target == 'qb-target' then
        local options = {}
        if Config.EnableHacking then
            table.insert(options, {
                type = "client",
                event = 'pl_atmrobbery_hack',
                icon = 'fas fa-laptop-code',
                label = locale('hack_atm_label'),
                model = model,
                item = Config.HackingItem,
            })
        end
        if Config.EnableDrilling then
            table.insert(options, {
                type = "client",
                event = 'pl_atmrobbery_drill',
                icon = 'fas fa-tools',
                label = locale('drill_atm_label'),
                model = model,
                item = Config.DrillItem,
            })
        end
        exports['qb-target']:AddTargetModel(model, {
            options = options,
            distance = 1.0
        })
    end
end

function AddCashToTarget(cash,atmCoords)
    if Config.Target == 'qb-target' then
        exports['qb-target']:AddTargetEntity(cash, {
            options = {
                {
                    type = "client",
                    event = "pl_atmrobbery:pickupCash",
                    icon = "fas fa-money-bill-wave",
                    label = locale('pick_up_cash'),
                    atmCoords = atmCoords
                }
            },
            distance = 1.5
        })
    elseif Config.Target == 'ox-target' then
        exports.ox_target:addLocalEntity(cash, {
            {
                event = "pl_atmrobbery:pickupCash",
                icon = "fas fa-money-bill-wave",
                label = locale('pick_up_cash'),
                args = atmCoords
            }
        })
    end
end

RegisterNetEvent('pl_atmrobbery:notification')
AddEventHandler('pl_atmrobbery:notification', function(message, type)
    if Config.Notify == 'ox' then
        TriggerEvent('ox_lib:notify', {description = message, type = type or "success"})
    elseif Config.Notify == 'esx' then
        TriggerEvent("esx:showNotification", message)
    elseif Config.Notify == 'okok' then
        TriggerEvent('okokNotify:Alert', message, 6000, type)
    elseif Config.Notify == 'qb' then
        TriggerEvent("QBCore:Notify", message, type, 6000)
    elseif Config.Notify == 'wasabi' then
        exports.wasabi_notify:notify("ATM ROBBERY", message, 6000, type, false, 'fas fa-ghost')
    elseif Config.Notify == 'custom' then
        -- Add your custom notifications here
    end
end)

function DispatchAlert()
    if Config.Dispatch == 'default' then
        TriggerServerEvent('pl_atmrobbery:server:policeAlert', locale('dispatch_message'))
    elseif Config.Dispatch == 'ps' then
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        local street1, street2 = GetStreetNameAtCoord(coords.x, coords.y, coords.z)
        local street1name = GetStreetNameFromHashKey(street1)
        local street2name = GetStreetNameFromHashKey(street2)
        local alert = {
            coords = coords,
            message = locale('dispatch_message')..street1name.. ' ' ..street2name,
            dispatchCode = '10-90',
            description = 'ATM Robbery',
            radius = 0,
            sprite = 431,
            color = 1,
            scale = 1.0,
            length = 3
        }
        exports["ps-dispatch"]:CustomAlert(alert)
    elseif Config.Dispatch == 'qs' then
        local playerData = exports['qs-dispatch']:GetPlayerInfo()
        TriggerServerEvent('qs-dispatch:server:CreateDispatchCall', {
            job = Config.Police.Job,
            callLocation = playerData.coords,
            callCode = { code = '10-90', snippet = 'ATM Robbery' },
            message = "street_1: ".. playerData.street_1.. " street_2: ".. playerData.street_2.."",
            flashes = false, -- No flashing icon
            image = nil,
            blip = {
                sprite = 431,
                scale = 1.2,
                colour = 1,
                flashes = true,
                text = 'ATM Robbery',
                time = (30 * 1000), 
            }
        })
    elseif Config.Dispatch == 'aty' then
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        local street1, street2 = GetStreetNameAtCoord(coords.x, coords.y, coords.z)
        local street1name = GetStreetNameFromHashKey(street1)
        local street2name = GetStreetNameFromHashKey(street2)
        TriggerServerEvent("aty_dispatch:server:customDispatch",
            "ATM Robbery",          -- title
            "10-90",                -- code
            street1name ' ' ..street2name, -- location
            coords,      -- coords (vector3)
            nil,         -- gender
            nil, -- vehicle name
            nil, -- vehicle object (optional)
            nil, -- weapon (not needed for ATM robbery)
            431, -- blip sprite (robbery icon)
            Config.Police.Job -- jobs to notify
            )

    elseif Config.Dispatch == 'rcore_disptach' then
        local playerData = exports['rcore_dispatch']:GetPlayerData()
        exports['screenshot-basic']:requestScreenshotUpload('InsertWebhookLinkHERE', "files[]", function(val)
            local image = json.decode(val)
            local alert = {
                code = '10-90 - ATM Robbery',
                default_priority = 'low',
                coords = playerData.coords,
                job = Config.Police.Job,
                text = 'ATM Robbery in progress on ' ..playerData.street_1,
                type = 'alerts',
                blip_time = 30,
                image = image.attachments[1].proxy_url,
                blip = {
                    sprite = 431,
                    colour = 1,
                    scale = 1.0,
                    text = '10-990 - ATM Robbery',
                    flashes = false,
                    radius = 0,
                }
            }
        TriggerServerEvent('rcore_dispatch:server:sendAlert', alert)
    end)
    elseif Config.Dispatch == 'custom' then

    end
end

RegisterNetEvent('pl_atmrobbery_drill')
AddEventHandler('pl_atmrobbery_drill', function(data)
    local entity = data.entity
    local atmModel = GetEntityModel(entity)

    if entity and DoesEntityExist(entity) then
        local atmCoords = GetEntityCoords(entity)
        if not IsPedHeadingTowardsPosition(PlayerPedId(), atmCoords.x,atmCoords.y,atmCoords.z,10.0) then
			TaskTurnPedToFaceCoord(PlayerPedId(), atmCoords.x,atmCoords.y,atmCoords.z, 1500)
		end
        local enoughpolice = lib.callback.await('pl_atmrobbery:checkforpolice', false)
        if enoughpolice then
            local checktime = lib.callback.await('pl_atmrobbery:checktime', false)
            if checktime then
                Wait(1000)
                if Config.Police.notify then
                    DispatchAlert()
                end
                TriggerEvent("Drilling:Start",function(success)
                    if (success) then
                      TriggerEvent('pl_atmrobbery_drill:success',entity, atmCoords, atmModel)
                    else
                      TriggerServerEvent('pl_atmrobbery:MinigameResult', false)
                    end
                end)
            else
                TriggerEvent('pl_atmrobbery:notification', locale('wait_robbery'),'error')
            end
        else
            TriggerEvent('pl_atmrobbery:notification', locale('not_enough_police'),'error')
        end
    end
end)
RegisterNetEvent('pl_atmrobbery_hack')
AddEventHandler('pl_atmrobbery_hack', function(data)
    local entity = data.entity
    local atmModel = GetEntityModel(entity)

    if entity and DoesEntityExist(entity) then
        local atmCoords = GetEntityCoords(entity)
        if not IsPedHeadingTowardsPosition(PlayerPedId(), atmCoords.x,atmCoords.y,atmCoords.z,10.0) then
			TaskTurnPedToFaceCoord(PlayerPedId(), atmCoords.x,atmCoords.y,atmCoords.z, 1500)
		end
        local enoughpolice = lib.callback.await('pl_atmrobbery:checkforpolice', false)
        if enoughpolice then
            local checktime = lib.callback.await('pl_atmrobbery:checktime', false)
            if checktime then
                Wait(1000)
                if Config.Police.notify then
                    DispatchAlert()
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
                TriggerEvent('pl_atmrobbery:StartMinigame', entity, atmCoords, atmModel)
            else
                TriggerEvent('pl_atmrobbery:notification', locale('wait_robbery'),'error')
            end
        else
            TriggerEvent('pl_atmrobbery:notification', locale('not_enough_police'),'error')
        end
    end
    
end)

function LootATM(atmCoords)
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

        TriggerServerEvent('pl_atmrobbery:GiveReward',atmCoords)
end

RegisterNetEvent('pl_atmrobbery:StartMinigame')
AddEventHandler('pl_atmrobbery:StartMinigame', function(entity, atmCoords, atmModel)

    if Config.Hacking.Minigame == 'utk_fingerprint' then
        TriggerEvent("utk_fingerprint:Start", 1, 6, 1, function(outcome, reason)
            if outcome == true then
                if not Config.MoneyDrop then
                    LootATM(atmCoords)
                else
                    TriggerEvent("pl_atmrobbery:spitCash",entity, atmCoords, atmModel)
                end
            elseif outcome == false then
                TriggerServerEvent('pl_atmrobbery:MinigameResult', false)
                TriggerEvent('pl_atmrobbery:notification', locale('failed_robbery'),'error')
            end
        end)
    elseif Config.Hacking.Minigame == 'ox_lib' then
        local outcome = lib.skillCheck({'easy', 'easy', {areaSize = 60, speedMultiplier = 1}, 'easy'}, {'w', 'a', 's', 'd'})
        if outcome == true then
            if not Config.MoneyDrop then
                LootATM(atmCoords)
            else
                TriggerEvent("pl_atmrobbery:spitCash",entity, atmCoords, atmModel)
            end
        elseif outcome == false then
            TriggerServerEvent('pl_atmrobbery:MinigameResult', false)
            TriggerEvent('pl_atmrobbery:notification', locale('failed_robbery'),'error')
        end
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

RegisterNetEvent("pl_atmrobbery:pickupCash")
AddEventHandler("pl_atmrobbery:pickupCash", function(data)
    local entity = data.entity
    local playerPed = PlayerPedId()
    local atmCoords
    if Config.Target == 'ox-target' then
        atmCoords = data.args
    elseif Config.Target == 'qb-target' then
        atmCoords = data.atmCoords
    end
    RequestAnimDict("pickup_object")
    while not HasAnimDictLoaded("pickup_object") do
        Wait(10)
    end

    TaskPlayAnim(playerPed, "pickup_object", "pickup_low", 8.0, -8.0, -1, 48, 0, false, false, false)

    Wait(1000)

    if DoesEntityExist(entity) then
        DeleteEntity(entity)
        TriggerServerEvent('pl_atmrobbery:GiveReward', atmCoords)
    end
    ClearPedTasks(playerPed)
end)
local function getModelNameFromHash(hash)
    for modelName, _ in pairs(atmModels) do
        if GetHashKey(modelName) == hash then
            return modelName
        end
    end
    return nil -- Not found
end

RegisterNetEvent("pl_atmrobbery_drill:success")
AddEventHandler("pl_atmrobbery_drill:success", function(atmEntity, atmCoords, atmModel)
    local cashModel = "hei_prop_heist_cash_pile"
    RequestModel(cashModel)
    while not HasModelLoaded(cashModel) do
        Wait(10)
    end

    local atmForward = GetEntityForwardVector(atmEntity)
    local atmHeading = GetEntityHeading(atmEntity)

    local dropOffset
    local atmModelName = getModelNameFromHash(atmModel)
    if atmModels[atmModelName] then
        dropOffset = atmModels[atmModelName]
    end
    local dropPosition = atmCoords + dropOffset
    for i = 1, Config.Reward.drill_cash_pile do 
        Wait(150)

        local cash = CreateObject(GetHashKey(cashModel), dropPosition.x, dropPosition.y, dropPosition.z, true, true, true)
        SetEntityHeading(cash, atmHeading)

        local forceX = atmForward.x * 2
        local forceY = atmForward.y * 2
        local forceZ = 0.2

        SetEntityVelocity(cash, forceX, forceY, forceZ)
        AddCashToTarget(cash,atmCoords)
        table.insert(cashObjects, cash)
    end
end)

RegisterNetEvent("pl_atmrobbery:spitCash")
AddEventHandler("pl_atmrobbery:spitCash", function(atmEntity, atmCoords, atmModel)
    local cashModel = "prop_anim_cash_pile_01"
    RequestModel(cashModel)
    while not HasModelLoaded(cashModel) do
        Wait(10)
    end

    local atmForward = GetEntityForwardVector(atmEntity)
    local atmHeading = GetEntityHeading(atmEntity)

    local dropOffset
    local atmModelName = getModelNameFromHash(atmModel)
    if atmModels[atmModelName] then
        dropOffset = atmModels[atmModelName]
    end
    local dropPosition = atmCoords + dropOffset
    for i = 1, Config.Reward.hack_cash_pile do 
        Wait(150)

        local cash = CreateObject(GetHashKey(cashModel), dropPosition.x, dropPosition.y, dropPosition.z, true, true, true)
        SetEntityHeading(cash, atmHeading)
        local forceX = atmForward.x * 2 
        local forceY = atmForward.y * 2
        local forceZ = 0.2

        SetEntityVelocity(cash, forceX, forceY, forceZ)
        AddCashToTarget(cash,atmCoords)
        table.insert(cashObjects, cash)
    end
end)

function DeleteCashObjects()
    for _, cash in pairs(cashObjects) do
        if Config.Target == 'ox-target' then
            exports.ox_target:removeEntity(cash)
        elseif Config.Target == 'qb-target' then
            exports['qb-target']:RemoveTargetEntity(cash)
        end
        DeleteEntity(cash)
    end
    cashObjects = {}
end


AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        DeleteCashObjects() 
    end
end)

