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
    local input = lib.inputDialog(Strings.sell_price, {Strings.amount_input})
    local price = tonumber(input and input[1]) or 0
    price = math.max(price, 0)  -- Uistíme sa, že cena nie je negatívna
    TriggerEvent('ox_inventory:closeInventory')
    TriggerServerEvent('gast_jobshops:setData', shop, slot, math.floor(price))
    lib.notify({
        title = Strings.success,
        description = (Strings.item_stocked_desc):format(price),
        type = 'success'
    })
end)

-- Optimalizovaná slučka pre tvorbu NPC
Citizen.CreateThread(function()
    for job, v in pairs(Config.Shops) do
        if v.npcshopspawn.enabled then
            local npcHash = GetHashKey(v.npcshopspawn.name)
            RequestModel(npcHash)
            while not HasModelLoaded(npcHash) do Wait(1) end

            RequestAnimDict("mini@strip_club@idles@bouncer@base")
            while not HasAnimDictLoaded("mini@strip_club@idles@bouncer@base") do Wait(1) end

            local ped = CreatePed(4, v.npcshopspawn.hex, v.npcshopspawn.pedcoords, v.npcshopspawn.heading, false, true)
            FreezeEntityPosition(ped, true)
            SetEntityInvincible(ped, true)
            SetBlockingOfNonTemporaryEvents(ped, true)
            TaskPlayAnim(ped, "mini@strip_club@idles@bouncer@base", "base", 8.0, 0.0, -1, 1, 0, 0, 0, 0)
        end
    end
end)

-- Funkcia na vytvorenie Blipu
local function createBlip(coords, sprite, color, text, scale)
    local blip = AddBlipForCoord(coords[1], coords[2], coords[3])
    SetBlipSprite(blip, sprite)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, scale)
    SetBlipColour(blip, color)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(text)
    EndTextCommandSetBlipName(blip)
    return blip
end

-- Vytvorenie Blipov pre obchody
CreateThread(function()
    for job, v in pairs(Config.Shops) do
        if v.blip.enabled then
            createBlip(v.blip.coords, v.blip.sprite, v.blip.color, v.blip.string, v.blip.scale)
        end
    end
end)

-- Optimalizované pridávanie target zón pre obchody
CreateThread(function()
    for job, v in pairs(Config.Shops) do
        -- Stash zóna
        if v.locations.stash.enabled then
            exports.ox_target:addSphereZone({
                coords = v.locations.stash.coords,
                radius = v.locations.stash.range,
                debug = drawZones,
                options = {{
                    name = 'sphere',
                    event = 'gast_jobshops:stash',
                    icon = 'fa-solid fa-warehouse',
                    label = 'Sklad predajne',
                    groups = v.locations.stash.groups
                }}
            })
        end

        -- Obchodné zóny
        if v.locations.shop.enabled then
            local shopCoords = v.locations.shop.coords
            local shopRange = v.locations.shop.range
            exports.ox_target:addSphereZone({
                coords = shopCoords,
                radius = shopRange,
                debug = drawZones,
                options = {{
                    name = 'sphere',
                    event = 'gast_jobshops:store' .. job, -- Dynamické vytváranie názvu udalosti podľa jobu
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

-- Konsolidované spracovanie obchodných udalostí
RegisterNetEvent('gast_jobshops:storeglobal_trans')
AddEventHandler('gast_jobshops:storeglobal_trans', function()
    exports.ox_inventory:openInventory('shop', { type = 'global_trans', id = 1 })
end)

RegisterNetEvent('gast_jobshops:storeliehovar')
AddEventHandler('gast_jobshops:storeliehovar', function()
    exports.ox_inventory:openInventory('shop', { type = 'liehovar', id = 1 })
end)

RegisterNetEvent('gast_jobshops:storefarma')
AddEventHandler('gast_jobshops:storefarma', function()
    exports.ox_inventory:openInventory('shop', { type = 'farma', id = 1 })
end)


