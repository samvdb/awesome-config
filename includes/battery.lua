-- {{ Battery 



baticon = wibox.widget.imagebox()
baticon:set_image(beautiful.widget_batt)

batwidget = wibox.widget.textbox()

vicious.register( batwidget, vicious.widgets.bat, "<span color=\"#8faf5f\">$1$2% [$3]</span>", 30, "BAT0")


-- }}
