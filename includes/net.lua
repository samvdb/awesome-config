-- {{{ Net

-- netdownicon = wibox.widget.imagebox()
-- netdownicon:set_image(beautiful.widget_netdown)
-- netupicon = wibox.widget.imagebox()
-- netupicon:set_image(beautiful.widget_netup)

neticon = wibox.widget.imagebox()
neticon:set_image(beautiful.widget_net_wired)

-- vicious.register(neticon, vicious.widgets.net, "", 2, "eth0");

neticon:buttons(awful.util.table.join(
    awful.button({ }, 1, function () awful.util.spawn("wicd-client -n", false) end)
))


-- wifiicon = wibox.widget.imagebox()
-- wifiicon:set_image(beautiful.widget_net_wifi_01)

-- vicious.register(neticon, vicious.widgets.net, 
-- 	function (widget, args)
-- 		if args["{ip}"] != nil then



		 
-- 		end
-- 	end, "eth0")


-- wifidowninfo = wibox.widget.textbox()
-- vicious.register(wifidowninfo, vicious.widgets.net, "<span color=\"#ce5666\">${wlan0 down_kb}</span>", 1)

-- wifiupinfo = wibox.widget.textbox()
-- vicious.register(wifiupinfo, vicious.widgets.net, "<span color=\"#87af5f\">${wlan0 up_kb}</span>", 1)

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

neticon:connect_signal('mouse::enter', function () dispip(path) end)
neticon:connect_signal('mouse::leave', function () naughty.destroy(showip) end)

-- }}}