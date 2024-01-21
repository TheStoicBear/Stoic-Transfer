-- Command: /towner [carid] [targetid] OR /towner (to list owned cars with IDs)
RegisterCommand('towner', function(source, args)
    local playerId = tonumber(source)

    if #args == 0 then
        -- If no arguments provided, list owned cars with IDs
        ListOwnedCars(playerId)
    elseif #args == 2 then
        -- If two arguments provided, transfer ownership
        local vehicleId = tonumber(args[1])
        local targetPlayerId = tonumber(args[2])
        TransferVehicleOwnership(playerId, vehicleId, targetPlayerId)
    else
        -- Invalid syntax
        TriggerClientEvent('chatMessage', playerId, 'SYSTEM', {255, 0, 0}, 'Invalid syntax. Use /towner [carid] [targetid] or /towner')
    end
end)

-- Function to transfer vehicle ownership
function TransferVehicleOwnership(playerId, vehicleId, targetPlayerId)
    local success = NDCore.transferVehicleOwnership(vehicleId, playerId, targetPlayerId)

    if success then
        TriggerClientEvent('chatMessage', playerId, 'SYSTEM', {255, 255, 255}, 'Vehicle ownership transferred successfully.')
    else
        TriggerClientEvent('chatMessage', playerId, 'SYSTEM', {255, 0, 0}, 'Failed to transfer vehicle ownership.')
    end
end

-- Function to list owned cars with IDs
function ListOwnedCars(playerId)
    local player = NDCore.getPlayer(playerId)
    local vehicles = NDCore.getVehicles(player.id)

    if #vehicles > 0 then
        TriggerClientEvent('chatMessage', playerId, 'SYSTEM', {255, 255, 255}, 'Your owned cars:')
        for i = 1, #vehicles do
            local veh = vehicles[i]
            TriggerClientEvent('chatMessage', playerId, 'SYSTEM', {255, 255, 255}, veh.id .. ': ' .. GetVehicleDisplayInfo(veh))
        end
    else
        TriggerClientEvent('chatMessage', playerId, 'SYSTEM', {255, 255, 255}, 'You do not own any cars.')
    end
end

-- Function to get display info for a vehicle
function GetVehicleDisplayInfo(vehicle)
    return 'Plate: ' .. vehicle.plate .. ', Stored: ' .. tostring(vehicle.stored) .. ', Impounded: ' .. tostring(vehicle.impounded) .. ', Stolen: ' .. tostring(vehicle.stolen) .. ', Available: ' .. tostring(vehicle.available)
end
