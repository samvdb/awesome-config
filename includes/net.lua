-- {{{ Net

netdownicon = wibox.widget.imagebox()
netdownicon:set_image(beautiful.widget_netdown)
netupicon = wibox.widget.imagebox()
netupicon:set_image(beautiful.widget_netup)


wifidowninfo = wibox.widget.textbox()
vicious.register(wifidowninfo, vicious.widgets.net, "<span color=\"#ce5666\">${wlan0 down_kb}</span>", 1)

wifiupinfo = wibox.widget.textbox()
vicious.register(wifiupinfo, vicious.widgets.net, "<span color=\"#87af5f\">${wlan0 up_kb}</span>", 1)

local function dispip()
	local f, infos
	local capi = {
		mouse = mouse,
		screen = screen
	}

	f = io.popen("sh " .. scripts .."/ip")
	infos = f:read("*all")
	f:close()

	showip = naughty.notify( {
		text	= infos,
		timeout	= 0,
        position = "top_right",
        margin = 10,
        height = 33,
        width = 113,
        border_color = '#404040',
        border_width = 1,
        -- opacity = 0.95,
		screen	= capi.mouse.screen })
end

wifidowninfo:connect_signal('mouse::enter', function () dispip(path) end)
wifidowninfo:connect_signal('mouse::leave', function () naughty.destroy(showip) end)

-- }}}