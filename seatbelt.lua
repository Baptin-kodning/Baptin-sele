ESX = nil
local isSeatbeltOn = false
local playerPed = PlayerPedId()

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        playerPed = PlayerPedId()

        if IsPedInAnyVehicle(playerPed, false) then
            local vehicle = GetVehiclePedIsIn(playerPed, false)
            if IsControlJustReleased(0, 82) then -- 20 is the key code for 'Z'
                isSeatbeltOn = not isSeatbeltOn
                
                if isSeatbeltOn then
                    TriggerEvent('esx:showNotification', 'Du har taget din sikkerhedssele på.')
                else
                    TriggerEvent('esx:showNotification', 'Du har taget din sikkerhedssele af.')
                end
            end
            
            if not isSeatbeltOn then
                local speed = GetEntitySpeed(vehicle) * 3.6 -- convert m/s to km/h
                if speed > 50.0 then
                    local coords = GetEntityCoords(playerPed)
                    if IsEntityInAir(vehicle) or IsVehicleInBurnout(vehicle) or HasEntityCollidedWithAnything(vehicle) then
                        SetEntityCoords(playerPed, coords.x, coords.y, coords.z - 0.47, true, true, true, false)
                        SetEntityVelocity(playerPed, GetEntityVelocity(vehicle))
                        TaskLeaveVehicle(playerPed, vehicle, 4160)
                        Citizen.Wait(1000)
                        SetPedToRagdoll(playerPed, 1000, 1000, 0, 0, 0, 0)
                    end
                end
            end
        else
            isSeatbeltOn = false 
        end
    end
end)

-- Notification function to show a message on the screen
RegisterNetEvent('esx:showNotification')
AddEventHandler('esx:showNotification', function(msg)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(msg)
    DrawNotification(false, false)
end)