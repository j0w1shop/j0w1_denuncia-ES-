ESX = exports["es_extended"]:getSharedObject()

local isMenuOpen = false

-- Crear el NPC
Citizen.CreateThread(function()
    RequestModel(GetHashKey(Config.NPC.model))
    while not HasModelLoaded(GetHashKey(Config.NPC.model)) do
        Wait(1)
    end

    local npc = CreatePed(4, Config.NPC.model, Config.NPC.coords, Config.NPC.heading, false, true)
    TaskStartScenarioInPlace(npc, Config.NPC.Scenario, 0, true)
    SetEntityInvincible(npc, true)
    SetBlockingOfNonTemporaryEvents(npc, true)
    FreezeEntityPosition(npc, true)

    if Config.UseOxTarget then
        exports.ox_target:addLocalEntity(npc, {
            {
                name = 'denuncia_npc',
                label = 'Presentar Denuncia',
                icon = 'fas fa-exclamation-circle',
                onSelect = function()
                    OpenDenunciaMenu()
                end
            }
        })
    end
end)

-- Abrir la UI de denuncia
function OpenDenunciaMenu()
    if isMenuOpen then return end
    isMenuOpen = true
    SetNuiFocus(true, true)
    SendNUIMessage({action = "open"})
    ExecuteCommand('e clipboard')
end

-- Cerrar la UI de denuncia
RegisterNUICallback("close", function(data, cb)
    SetNuiFocus(false, false)
    isMenuOpen = false
    cb("ok")
    ExecuteCommand('reloadskin')
end)

-- Enviar la denuncia
RegisterNUICallback("submit", function(data, cb)
    TriggerServerEvent('denuncia:enviar', data.nombre, data.telefono, data.motivo)
    ESX.ShowNotification(Config.NotifyMSG, flash, saveToBrief, hudColorIndex)
    SetNuiFocus(false, false)
    isMenuOpen = false
    cb("ok")
end)

-- Dibujar el marker si no se usa ox_target
if not Config.UseOxTarget then
    Citizen.CreateThread(function()
        while true do
            local playerCoords = GetEntityCoords(PlayerPedId())
            local distance = #(playerCoords - Config.NPC.coords)

            if distance < 1.5 then
                DrawMarker(2, Config.NPC.coords.x, Config.NPC.coords.y, Config.NPC.coords.z + 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 0.5, 255, 0, 0, 200, false, true, 2, nil, nil, false)
                if distance < 1.0 then
                    SetTextComponentFormat('STRING')
                    AddTextComponentString('Pulsa ~INPUT_CONTEXT~ para presentar una denuncia')
                    DisplayHelpTextFromStringLabel(0, 0, 1, -1)

                    if IsControlJustReleased(0, 38) then -- E key
                        OpenDenunciaMenu()
                    end
                end
            end
            Wait(0)
        end
    end)
end
