-- {{ Battery 

baticon = wibox.widget.imagebox()
baticon:set_image(beautiful.widget_batt)

batwidget = wibox.widget.textbox()

vicious.register( batwidget, vicious.widgets.bat, "<span color=\"#8faf5f\">$1 $2 $3%</span>", 60, "BAT0")
baticon:buttons(awful.util.table.join(
    awful.button({ }, 1, function () awful.util.spawn("".. terminal.. " -geometry 80x18 -e saidar -c", false) end)
))

-- }}
