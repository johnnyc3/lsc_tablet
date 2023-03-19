fx_version 'adamant'
games {'gta5'}

data_file 'DLC_ITYP_REQUEST' 'stream/glibcat_mdt_prop.ytyp'

-- UI
ui_page "ui/index.html"
files {
	"ui/index.html",
	"ui/assets/clignotant-droite.svg",
	"ui/assets/clignotant-gauche.svg",
	"ui/assets/feu-position.svg",
	"ui/assets/feu-route.svg",
	"ui/assets/fuel.svg",
	"ui/fonts/fonts/Roboto-Bold.ttf",
	"ui/fonts/fonts/Roboto-Regular.ttf",
	"ui/script.js",
	"ui/style.css",
	"ui/debounce.min.js",
	"ui/config.json",
	"ui/css/*.css",
	"ui/font/fontello.eot",
	"ui/font/fontello.svg",
	"ui/font/fontello.ttf",
	"ui/font/fontello.woff",
	"ui/font/fontello.woff2",
	"ui/assets/*.png",
}

-- Client Scripts
client_scripts {
	"client.lua",
}
server_scripts {
	'server.lua',
	'@mysql-async/lib/MySQL.lua',
}