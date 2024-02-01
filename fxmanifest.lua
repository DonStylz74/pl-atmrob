
fx_version 'cerulean'
lua54 'yes'
game 'gta5'

name 'ox_target'
author 'PulsePK'
version '1.0.0'

description 'Atm Robbery using OX_Target https://discord.gg/72Y7WKsP9M'


shared_scripts {
	'@ox_lib/init.lua',
    'config.lua',
	'locale.lua'
}

client_scripts {
	'client.lua'
}

server_scripts {
	'server.lua'
}

dependency {
	'ox_lib',
	'ox_target',
	'utk_fingerprint'
}
