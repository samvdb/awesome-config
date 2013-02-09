local awful           = require("awful")
local wibox           = require("wibox")
local beautiful       = require("beautiful")
local vicious         = require("vicious")



-- {{ Battery 

baticon = wibox.widget.imagebox()
baticon:set_image(beautiful.widget_batt)

batwidget = wibox.widget.textbox()

vicious.register( batwidget, vicious.widgets.bat, "<span color=\"#8faf5f\">$1%</span>", 3, "BAT0")
baticon:buttons(awful.util.table.join(
    awful.button({ }, 1, function () awful.util.spawn("".. terminal.. " -geometry 80x18 -e saidar -c", false) end)
))

-- }}
