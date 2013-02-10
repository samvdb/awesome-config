-- {{{ Cpu
 
 -- Requires Saidar Unix utility 
--
-- #pacman -S libstatgrab pystatgrab
-- 
-- When cpu icon is clicked this curses util will be spawned

cpuicon = wibox.widget.imagebox()
cpuicon:set_image(beautiful.widget_cpu)
cpuwidget = wibox.widget.textbox()
vicious.register( cpuwidget, vicious.widgets.cpu, "<span color=\"#8faf5f\">$1%</span>", 3)

cpuicon:buttons(awful.util.table.join(
    awful.button({ }, 1, function () awful.util.spawn("".. terminal.. " -geometry 80x18 -e saidar -c", false) end)
))

-- }}}