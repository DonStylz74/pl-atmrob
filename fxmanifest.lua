
fx_version 'cerulean'
lua54 'yes'
game 'gta5'

name 'Pulse ATM Robbery'
author 'PulseScripts'
version '1.2.6'

description 'Atm Robbery by PulseScripts https://discord.gg/72Y7WKsP9M'

shared_scripts {
	'@ox_lib/init.lua',
    'config.lua',
}

client_scripts {
	'client/main.lua'
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server/bridge/*',
	'server/main.lua'
}

files {
	'locales/*.json'
}

dependency {
	'ox_lib'
}

