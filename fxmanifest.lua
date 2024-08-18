fx_version 'cerulean'
game 'gta5'

description 'Script para denunciar sin necesidad de policias'

version '1.0.0'

client_scripts {
    'config.lua',
    'client/client.lua'
}

server_scripts {
    'config.lua',
    'server/server.lua'
}

ui_page 'html/ui.html'

files {
    'html/ui.html',
    'html/style.css',
    'html/script.js'
}

dependencies {
    'ox_target' -- Si utilizas ox_target, sino elimínalo
}
