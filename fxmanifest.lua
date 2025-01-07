fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'G.A.S.T. Development'

version "1.0"

description  'The script manages stores, inventories, item prices, and item exchanges on a FiveM servers with ox_inventory and esx framework.'

shared_scripts { '@ox_lib/init.lua', 'configuration/*.lua', '@es_extended/locale.lua',
'locales/*.lua' }

client_scripts { 'client/*.lua' }

server_scripts { 'server/*.lua', '@oxmysql/lib/MySQL.lua' }

dependencies { 'ox_inventory' }
