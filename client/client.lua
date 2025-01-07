ESX = exports['es_extended']:getSharedObject()

RegisterNetEvent('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
    ESX.PlayerLoaded = true
end)

RegisterNetEvent('esx:onPlayerLogout', function()
    table.wipe(ESX.PlayerData)
    ESX.PlayerLoaded = false
end)

RegisterNetEvent('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)

RegisterNetEvent('gast_jobshops:setProductPrice')
AddEventHandler('gast_jobshops:setProductPrice', function(shop, slot)
    local input = lib.inputDialog(Locales[Config.Locale]['sell_price'], {Locales[Config.Locale]['amount_input']})
    local price = tonumber(input and input[1]) or 0
    price = math.max(price, 0)

    TriggerEvent('ox_inventory:closeInventory')
    TriggerServerEvent('gast_jobshops:setData', shop, slot, math.floor(price))

    if Config.notifications == "ox_lib" then
        lib.notify({
            title = Locales[Config.Locale]['success'],
            description = (Locales[Config.Locale]['item_stocked_desc']):format(price),
            type = 'success'
        })
    elseif Config.notifications == "esx_default" then
        ESX.ShowNotification('~g~' .. Locales[Config.Locale]['success'] .. ': ' .. (Locales[Config.Locale]['item_stocked_desc']):format(price))
    end
end)

Citizen.CreateThread(function()
    for _, v in pairs(Config.Shops) do
        if v.npcshopspawn.enabled then
            local npcHash = GetHashKey(v.npcshopspawn.name)
            if not HasModelLoaded(npcHash) then
                RequestModel(npcHash)
                while not HasModelLoaded(npcHash) do Wait(1) end
            end

            if not HasAnimDictLoaded("mini@strip_club@idles@bouncer@base") then
                RequestAnimDict("mini@strip_club@idles@bouncer@base")
                while not HasAnimDictLoaded("mini@strip_club@idles@bouncer@base") do Wait(1) end
            end

            local ped = CreatePed(4, v.npcshopspawn.hex, v.npcshopspawn.pedcoords, v.npcshopspawn.heading, false, true)
            FreezeEntityPosition(ped, true)
            SetEntityInvincible(ped, true)
            SetBlockingOfNonTemporaryEvents(ped, true)
            TaskPlayAnim(ped, "mini@strip_club@idles@bouncer@base", "base", 8.0, 0.0, -1, 1, 0, 0, 0, 0)
        end
    end
end)

-- Blips creation
CreateThread(function()
    for _, v in pairs(Config.Shops) do
        if v.blip.enabled then
            local blip = AddBlipForCoord(v.blip.coords)
            SetBlipSprite(blip, v.blip.sprite)
            SetBlipDisplay(blip, 4)
            SetBlipScale(blip, v.blip.scale)
            SetBlipColour(blip, v.blip.color)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(v.blip.string)
            EndTextCommandSetBlipName(blip)
        end
    end
end)

-- Target Zones creation
CreateThread(function()
    for _, v in pairs(Config.Shops) do
        if v.locations.stash.enabled then
            exports.ox_target:addSphereZone({
                coords = v.locations.stash.coords,
                radius = v.locations.stash.range,
                debug = drawZones,
                options = {{
                    name = 'sphere',
                    event = 'gast_jobshops:stash',
                    icon = 'fa-solid fa-warehouse',
                    label = Locales[Config.Locale]['store_inventory'],
                    groups = v.locations.stash.groups
                }}
            })
        end

        if v.locations.shop.enabled then
            exports.ox_target:addSphereZone({
                coords = v.locations.shop.coords,
                radius = v.locations.shop.range,
                debug = drawZones,
                options = {{
                    name = 'sphere',
                    event = 'gast_jobshops:store' .. v.type, -- Dynamicky použije typ obchodu
                    icon = 'fa-sharp fa-solid fa-cart-shopping',
                    label = v.label
                }}
            })
        end
    end
end)

-- Konsolidované spracovanie udalosti stash
RegisterNetEvent('gast_jobshops:stash')
AddEventHandler('gast_jobshops:stash', function()
    local jobName = ESX.PlayerData.job.name
    if Config.Shops[jobName] and Config.Shops[jobName].locations.stash.enabled then
        exports.ox_inventory:openInventory('stash', jobName)
    end
end)

-- Konsolidované obchodné udalosti
CreateThread(function()
    for _, v in pairs(Config.Shops) do
        RegisterNetEvent('gast_jobshops:store' .. v.type)
        AddEventHandler('gast_jobshops:store' .. v.type, function()
            exports.ox_inventory:openInventory('shop', { type = v.type, id = 1 })
        end)
    end
end)
