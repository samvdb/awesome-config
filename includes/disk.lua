-- {{{ Hard Drives

fsicon = wibox.widget.imagebox()
fsicon:set_image(beautiful.widget_fs)
-- vicious.cache(vicious.widgets.fs)
fswidget = wibox.widget.textbox()
vicious.register(fswidget, vicious.widgets.fs, "<span color=\"#7788af\">${/ used_p}%</span>", 10)

local function dispdisk()
	local f, infos
	local capi = {
		mouse = mouse,
		screen = screen
	}

	f = io.popen("dfc -d | grep /dev/sda")
	infos = f:read("*all")
	f:close()

	showdiskinfo = naughty.notify( {
		text	= infos,
		timeout	= 0,
        position = "top_right",
        margin = 10,
        height = 77,
        width = 620,
        border_color = '#404040',
        border_width = 1,
        -- opacity = 0.95,
		screen	= capi.mouse.screen })
end

fswidget:connect_signal('mouse::enter', function () dispdisk(path) end)
fswidget:connect_signal('mouse::leave', function () naughty.destroy(showdiskinfo) end)

-- }}}