-- {{{ Kernel Info

sysicon = wibox.widget.imagebox()
sysicon:set_image(beautiful.widget_sys)
syswidget = wibox.widget.textbox()
vicious.register( syswidget, vicious.widgets.os, "<span color=\"#87af5f\">$2</span>")

-- }}}