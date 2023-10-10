AddEventHandler('onServerResourceStart', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        updateData()
    end
end)
function updateData()
    if Config.Framework == 'qb' then 
        local plyInfo = MySQL.query.await('SELECT charinfo, citizenid FROM players')
        for i = 1, #plyInfo do 
            local results = plyInfo[i]
            local id = results.citizenid
            local characterInfo = results.charinfo
            local info = json.decode(characterInfo)
            local first = info.firstname
            local last = info.lastname 
            MySQL.update.await('UPDATE loaf_properties SET playername = ? WHERE owner = ?', {
                first .. ' ' .. last, id
            })
        end
    elseif Config.Framework == 'esx' then  
        local plyInfo = MySQL.query.await('SELECT identifier, firstname, lastname FROM users')
        for i = 1, #plyInfo do 
            local results = plyInfo[i]
            local id = results.identifier
            local first = results.firstname
            local last = results.lastname 
            MySQL.update.await('UPDATE loaf_properties SET playername = ? WHERE owner = ?', {
                first .. ' ' .. last, id
            })
        end
    end
    local coordinates = MySQL.query.await('SELECT entrance, id FROM loaf_houses')
    for i = 1, #coordinates do 
        local var = coordinates[i]
        local ent = var.entrance
        local ident = var.id
        local data = json.decode(ent)
        local x = data.x
        local y = data.y
        local z = data.z
        MySQL.update.await('UPDATE loaf_properties SET x = ? WHERE propertyid = ?', {
            x, ident
        })
        MySQL.update.await('UPDATE loaf_properties SET y = ? WHERE propertyid = ?', {
            y, ident
        })
        MySQL.update.await('UPDATE loaf_properties SET z = ? WHERE propertyid = ?', {
            z, ident
        })
    end
end
RegisterNetEvent('pullData', function()
    if Config.Framework == 'qb' then 
        local QBCore = exports['qb-core']:GetCoreObject()
        local src = source 
        local Player = QBCore.Functions.GetPlayer(src)
        local data = MySQL.query.await('SELECT propertyid, playername, x, y, z from loaf_properties WHERE menu = ?', {
            'true'
        })
        TriggerClientEvent('showMenu', src, data)
    elseif Config.Framework == 'esx' then 
        ESX = exports["es_extended"]:getSharedObject()
        local src = source
        local xPlayer = ESX.GetPlayerFromId(src)
        local data = MySQL.query.await('SELECT propertyid, playername, x, y, z from loaf_properties WHERE menu = ?', {
            'true'
        })
        TriggerClientEvent('showMenu', src, data)
    end
end)


