-- {{ Battery 



baticon = wibox.widget.imagebox()
baticon:set_image(beautiful.widget_batt)

batwidget = wibox.widget.textbox()

vicious.register( batwidget, vicious.widgets.bat, 
	function(widget, args)

		local current = args[2]
		if current < 10 and args[1] == "-" then
			  color = beautiful.fg_widget_value_important
			  -- Maybe we want to display a small warning?
			  if current ~= batwidget.lastwarn then
			     batwidget.lastid = naughty.notify(
				{ title = "Battery low!",
				  preset = naughty.config.presets.critical,
				  timeout = 20,
				  text = "Battery level is currently " ..
				     current .. "%.\n" .. args[3] ..
				     " left before running out of power.",
				  beautiful.widget_batt_empty,
				  replaces_id = batwidget.lastid }).id
			     batwidget.lastwarn = current
			  end
       	end     
		return "<span color=\"" .. battery_color .. "\">"  .. args[2] .. "% [" .. args[3] .. "]</span>"
	end, 30, "BAT0")




-- }}
