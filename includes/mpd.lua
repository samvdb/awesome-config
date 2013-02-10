-- {{{ MPD

mpdwidget = wibox.widget.textbox()
vicious.register(mpdwidget, vicious.widgets.mpd,
function(widget, args)

string = "<span color='" .. beautiful.fg_blue .. "'>" .. args["{Title}"] .. "</span> <span color='" .. beautiful.fg_black .. "'>-</span> <span color='" .. beautiful.fg_white .. "'>" .. args["{Artist}"] .. "</span>"

-- play
if (args["{state}"] == "Play") then
mpdwidget.visible = true
return string

-- pause
elseif (args["{state}"] == "Pause") then
mpdwidget.visible = true
return "<span color='" .. beautiful.fg_red.."'>mpd</span> <span color='" .. beautiful.fg_white.."'>paused</span>"

-- stop
elseif (args["{state}"] == "Stop") then
mpdwidget.visible = true
return "<span color='" .. beautiful.fg_red.."'>mpd</span> <span color='" .. beautiful.fg_white.."'>stopped</span>"

-- not running
else
mpdwidget.visible = true
return "<span color='" .. beautiful.fg_red.."'>mpd</span> <span color='" .. beautiful.fg_white.."'>off</span>"
end

end, 1)

-- }}}