ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)

Citizen.CreateThread(function()
    TriggerEvent('disc-base:registerItemUse', 'lockpick', function(source, item)
        TriggerClientEvent('disc-hotwire:hotwire', source, true)
    end)
end)
RegisterNetEvent('ARPF:removeKit')
AddEventHandler('ARPF:removeKit', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    xPlayer.removeInventoryItem('lockpick', 1)
end)

RegisterServerEvent('disc-hotwire:givereward')
AddEventHandler('disc-hotwire:givereward', function(cashreward,itemreward, count)
    local xPlayer = ESX.GetPlayerFromId(source)
    if cashreward ~= nil then 
        xPlayer.addMoney(cashreward)
    elseif itemreward ~= nil then 
        xPlayer.addInventoryItem(itemreward, count)
    end
end)

RegisterNetEvent('ARPF:GiveKeys')
AddEventHandler('ARPF:GiveKeys', function(closestplayer,veh,plate)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    nameplayer = GetPlayerName(_source)
    TriggerClientEvent("ARPF:recivekeys", closestplayer, nameplayer,veh,plate)
end)


ESX.RegisterServerCallback('disc-hotwire:checkOwner', function(source, cb, plate)
    local player = ESX.GetPlayerFromId(source)
    MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @identifier AND plate = @plate', {
        ['@identifier'] = player.identifier,
        ['@plate'] = plate
    }, function(results)
        cb(#results == 1)
    end)
end)