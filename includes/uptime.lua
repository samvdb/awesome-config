-- {{{ Uptime

uptimeicon = wibox.widget.imagebox()
uptimeicon:set_image(beautiful.widget_uptime)
uptimewidget = wibox.widget.textbox()
vicious.register( uptimewidget, vicious.widgets.uptime, "<span color=\"#94738c\">$2.$3'</span>")

-- }}}