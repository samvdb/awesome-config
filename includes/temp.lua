-- {{{ Temp

tempicon = wibox.widget.imagebox()
tempicon:set_image(beautiful.widget_temp)
tempicon:buttons(awful.util.table.join(
    awful.button({ }, 1, function () awful.util.spawn("urxvt -e sudo powertop", false) end)
    -- awful.button({ }, 3, function () awful.util.spawn("sudo irqbalance", false) end)
))
tempwidget = wibox.widget.textbox()
vicious.register(tempwidget, vicious.widgets.thermal, "<span color=\"#ffaf5f\">$1°C</span>", 9, { "coretemp.0", "core"} )

local function disptemp()
	local f, infos
	local capi = {
		mouse = mouse,
		screen = screen
	}

	f = io.popen("sensors && sudo hddtemp /dev/sda")
	infos = f:read("*all")
	f:close()

	showtempinfo = naughty.notify( {
		text	= infos,
		timeout	= 0,
        position = "bottom_right",
        margin = 10,
        height = 230,
        width = 405,
        border_color = '#404040',
        border_width = 1,
        -- opacity = 0.95,
		screen	= capi.mouse.screen })
end

tempwidget:connect_signal('mouse::enter', function () disptemp(path) end)
tempwidget:connect_signal('mouse::leave', function () naughty.destroy(showtempinfo) end)

-- }}}