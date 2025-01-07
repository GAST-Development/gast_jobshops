ESX = exports['es_extended']:getSharedObject()
local swapHooks, createHooks = {}, {}

CreateThread(function()
    while GetResourceState('ox_inventory') ~= 'started' do 
        Wait(1000) 
    end

    for k, v in pairs(Config.Shops) do
        local stash = {
            id = k,
            label = v.label .. ' ' .. Locales[Config.Locale]['inventory'],
            slots = 50,
            weight = 100000,
        }
        exports.ox_inventory:RegisterStash(stash.id, stash.label, stash.slots, stash.weight)
        
        local items = exports.ox_inventory:GetInventoryItems(k, false)
        local stashItems = {}

        if items and #items > 0 then
            for _, item in pairs(items) do
                if item and item.name and item.metadata and item.metadata.shopData then
                    local price = item.metadata.shopData.price or 0
                    table.insert(stashItems, { 
                        name = item.name, 
                        metadata = item.metadata, 
                        count = item.count, 
                        price = price 
                    })
                end
            end

            local x, y, z = table.unpack(v.locations.shop.coords)
            exports.ox_inventory:RegisterShop(k, {
                name = v.label,
                inventory = stashItems,
                locations = { vec3(x, y, z) }
            })
        end

        swapHooks[k] = exports.ox_inventory:registerHook('swapItems', function(payload)
            if payload.fromInventory == k then
                TriggerEvent('gast_jobshops:refreshShop', k)
            elseif payload.toInventory == k and tonumber(payload.fromInventory) ~= nil then
                TriggerClientEvent('gast_jobshops:setProductPrice', payload.fromInventory, k, payload.toSlot)
            end
        end, {})

        createHooks[k] = exports.ox_inventory:registerHook('createItem', function(payload)
            local metadata = payload.metadata
            if metadata and metadata.shopData then
                local price = metadata.shopData.price
                exports.ox_inventory:RemoveItem(metadata.shopData.shop, payload.item.name, payload.count)
                TriggerEvent('esx_addonaccount:getSharedAccount', 'society_' .. metadata.shopData.shop, function(account)
                    account.addMoney(price)
                end)
            end
        end, {})
    end
end)

RegisterServerEvent('gast_jobshops:refreshShop', function(shop)
    Wait(250) 
    local items = exports.ox_inventory:GetInventoryItems(shop, false)
    local stashItems = {}

    if items and #items > 0 then
        for _, item in pairs(items) do
            if item and item.name and item.metadata and item.metadata.shopData then
                table.insert(stashItems, { 
                    name = item.name, 
                    metadata = item.metadata, 
                    count = item.count, 
                    price = item.metadata.shopData.price 
                })
            end
        end

        exports.ox_inventory:RegisterShop(shop, {
            name = Config.Shops[shop].label,
            inventory = stashItems,
            locations = { Config.Shops[shop].locations.shop.coords }
        })
    end
end)

RegisterServerEvent('gast_jobshops:setData', function(shop, slot, price)
    local item = exports.ox_inventory:GetSlot(shop, slot)
    if not item then return end
    local metadata = item.metadata
    if metadata then
        metadata.shopData = { shop = shop, price = price }
        exports.ox_inventory:SetMetadata(shop, slot, metadata)
        TriggerEvent('gast_jobshops:refreshShop', shop)
    end
end)

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    for _, hook in pairs(swapHooks) do
        exports.ox_inventory:removeHooks(hook)
    end
    for _, hook in pairs(createHooks) do
        exports.ox_inventory:removeHooks(hook)
    end
end)