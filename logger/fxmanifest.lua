fx_version 'cerulean'
game 'gta5'

author 'Your Name'
description 'Your description'
version '1.0.0'

shared_script 'config.json'

server_scripts {
    '@ox-logger/lib/logger.lua',
    'server.lua'
}

client_scripts {
    'client.lua'
}