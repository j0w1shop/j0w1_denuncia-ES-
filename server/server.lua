ESX = exports["es_extended"]:getSharedObject()

local DiscordWebhook = Config.WebhookURL

RegisterServerEvent('denuncia:enviar')
AddEventHandler('denuncia:enviar', function(nombre, telefono, motivo)
    local embed = {
        {
            ["title"] = "**⚠️ NUEVA DENUNCIA**",
        ["description"] = "¡Hola compañeros! Soy Manolo y aqui os dejo una denuncia que acaban de poner:",
            ["color"] = 000080,  -- Rojo en decimal (0xFF0000 en hexadecimal)
            ["fields"] = {
                {
                    ["name"] = "**📛 Nombre:**",
                    ["value"] = string.format("`%s`", nombre),  -- El nombre resaltado como código
                    ["inline"] = true
                },
                {
                    ["name"] = "**📞 Teléfono:**",
                    ["value"] = string.format("`%s`", telefono),  -- El teléfono resaltado como código
                    ["inline"] = true
                },
                {
                    ["name"] = "**📝 Motivo de la Denuncia:**",
                    ["value"] = string.format("*%s*", motivo),  -- El motivo en cursiva
                    ["inline"] = false
                }
            },
            ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
        }
    }

    PerformHttpRequest(DiscordWebhook, function(err, text, headers) end, 'POST', json.encode({embeds = embed}), { ['Content-Type'] = 'application/json' })
end)
