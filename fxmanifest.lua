fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'G.A.S.T. Dev'
description  'Job manager v1.0'

shared_scripts { '@ox_lib/init.lua', 'configuration/*.lua', '@es_extended/locale.lua',
'locales/*.lua' }

client_scripts { 'client/*.lua' }

server_scripts { 'server/*.lua', '@oxmysql/lib/MySQL.lua' }

dependencies { 'ox_inventory' }
