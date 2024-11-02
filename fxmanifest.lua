
fx_version 'cerulean'
lua54 'yes'
game 'gta5'

name 'Pulse ATM Robbery'
author 'PulsePK'
version '1.1.0'

description 'Atm Robbery by PulseScripts https://discord.gg/72Y7WKsP9M'

shared_scripts {
	'@ox_lib/init.lua',
    'config.lua'
}

client_scripts {
	'client/main.lua',
	'client/bridge/*'
}

server_scripts {
	'server/main.lua',
	'server/bridge/*'
}

dependency {
	'ox_lib',
	'utk_fingerprint' -- if not using this comment this
}

files {
    'locales/en.json'
}
