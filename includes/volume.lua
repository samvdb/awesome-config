-- {{{ Volume

volicon = wibox.widget.imagebox()
volicon:set_image(beautiful.widget_vol)
volumewidget = wibox.widget.textbox()
vicious.register( volumewidget, vicious.widgets.volume, 
	function (widgets, args)
		if args[1] == 0 or args[2] == "♩" then
			volicon:set_image(beautiful.widget_mute)
		else 
			volicon:set_image(beautiful.widget_vol)
		end
		return "<span color=\"#7788af\">" .. args[1] .. "%</span>"
	end, 2, "Master" )

volumewidget:buttons(awful.util.table.join(
    awful.button({ }, 1, function () awful.util.spawn("amixer -q sset Master toggle", false) end),
    awful.button({ }, 3, function () awful.util.spawn("".. terminal.. " -e alsamixer", true) end),
    awful.button({ }, 4, function () awful.util.spawn("amixer -q sset Master 1dB+", false) end),
    awful.button({ }, 5, function () awful.util.spawn("amixer -q sset Master 1dB-", false) end)
))

-- }}}