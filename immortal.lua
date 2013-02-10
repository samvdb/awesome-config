------------------------------------------------
--            Awesome 3.5 rc.lua              --    
--           by TheImmortalPhoenix            --
-- http://theimmortalphoenix.deviantart.com/  --
------------------------------------------------


-- {{{ Required Libraries

awful           = require("awful")
awful.rules     = require("awful.rules")
awful.autofocus = require("awful.autofocus")
wibox           = require("wibox")
beautiful       = require("beautiful")
naughty         = require("naughty")
vicious         = require("vicious")

-- }}}

-- {{{ Autostart
exec /usr/binawesome >> ~/.logs/awesome/stdout 2>> ~/.logs/awesome/stderr

function run_once(cmd)
  findme = cmd
  firstspace = cmd:find(" ")
  if firstspace then
     findme = cmd:sub(0, firstspace-1)
  end
  awful.util.spawn_with_shell("pgrep -u $USER -x " .. findme .. " > /dev/null || (" .. cmd .. ")")
 end 

  -- run_once("compton -cCG -fF -o 0.38 -O 20 -I 20 -t 0.02 -l 0.02 -r 3.2 -D2")
  -- run_once("xcompmgr -fF -l -O -D1")
  -- run_once("xcompmgr -l -O -D1")
  -- run_once("sudo killall pulseaudio")
  -- run_once("sudo killall rtkit-daemon")
  -- run_once("sudo killall gconfd-2")
  run_once("sudo ./.scripts/connect")
  run_once("parcellite")
  -- run_once("dropbox start")
  -- run_once("pidgin")
  -- run_once("sleep 10 && sudo systemctl start mpd.service")
  run_once("xrdb -merge /home/luca/.Xdefaults")

-- }}}

-- {{{ Error Handling

-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = err })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable Definitions

-- Useful Paths
home = os.getenv("HOME")
confdir = home .. "/.config/awesome"
themes = confdir .. "/themes"

-- Choose Your Theme
active_theme = themes .. "/colored"

-- Themes define colours, icons, and wallpapers
-- beautiful.init("/usr/share/awesome/themes/default/theme.lua")
beautiful.init(active_theme .. "/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "urxvt"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor
gui_editor = "geany"
browser = "firefox"
fileman = "spacefm " .. home
cli_fileman = terminal .. " -title Ranger -e ranger "
music = terminal .. " -title Music -e ncmpcpp "
chat = terminal .. " -title Chat -e sh /home/luca/.scripts/weechat "
torrent = terminal .. " -title Torrent -e sh /home/luca/.scripts/torrent "
tasks = terminal .. " -e sudo htop "

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"
altkey = "Mod1"

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
{
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    -- awful.layout.suit.spiral.dwindle,
    -- awful.layout.suit.max,
    -- awful.layout.suit.max.fullscreen,
    -- awful.layout.suit.magnifier
}
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag({ "term ", "web ", "files ", "chat ", "media ", "work" }, s,
    -- tags[s] = awful.tag({ "¹", "´", "²", "©", "ê", "º" }, s,
  		       { layouts[6], layouts[6], layouts[6],
 			  layouts[6], layouts[6], layouts[6]
 		       })
    
    -- awful.tag.seticon(active_theme .. "/widgets/arch_10x10.png", tags[s][1])
    -- awful.tag.seticon(active_theme .. "/widgets/cat.png", tags[s][2])
    -- awful.tag.seticon(active_theme .. "/widgets/dish.png", tags[s][3])
    -- awful.tag.seticon(active_theme .. "/widgets/mail.png", tags[s][4])
    -- awful.tag.seticon(active_theme .. "/widgets/phones.png", tags[s][5])
    -- awful.tag.seticon(active_theme .. "/widgets/pacman.png", tags[s][6])
    
end

-- }}}

-- {{{ Wibox

-- {{{ Clock

mytextclock = awful.widget.textclock()
mytextclockicon = wibox.widget.imagebox()
mytextclockicon:set_image(beautiful.widget_clock)

-- }}}

-- {{{ Kernel Info

sysicon = wibox.widget.imagebox()
sysicon:set_image(beautiful.widget_sys)
syswidget = wibox.widget.textbox()
vicious.register( syswidget, vicious.widgets.os, "<span color=\"#87af5f\">$2</span>")

-- }}}

-- {{{ Uptime

uptimeicon = wibox.widget.imagebox()
uptimeicon:set_image(beautiful.widget_uptime)
uptimewidget = wibox.widget.textbox()
vicious.register( uptimewidget, vicious.widgets.uptime, "<span color=\"#94738c\">$2.$3'</span>")

-- }}}

-- {{{ Temp

tempicon = wibox.widget.imagebox()
tempicon:set_image(beautiful.widget_temp)
tempicon:buttons(awful.util.table.join(
    awful.button({ }, 1, function () awful.util.spawn("urxvt -e sudo powertop", false) end)
    -- awful.button({ }, 3, function () awful.util.spawn("sudo irqbalance", false) end)
))
tempwidget = wibox.widget.textbox()
vicious.register(tempwidget, vicious.widgets.thermal, "<span color=\"#ffaf5f\">$1°C</span>", 9, { "coretemp.0", "core"} )

local function disptemp()
	local f, infos
	local capi = {
		mouse = mouse,
		screen = screen
	}

	f = io.popen("sensors && sudo hddtemp /dev/sda")
	infos = f:read("*all")
	f:close()

	showtempinfo = naughty.notify( {
		text	= infos,
		timeout	= 0,
        position = "bottom_right",
        margin = 10,
        height = 230,
        width = 405,
        border_color = '#404040',
        border_width = 1,
        -- opacity = 0.95,
		screen	= capi.mouse.screen })
end

tempwidget:connect_signal('mouse::enter', function () disptemp(path) end)
tempwidget:connect_signal('mouse::leave', function () naughty.destroy(showtempinfo) end)

-- }}}

-- {{{ Volume

volicon = wibox.widget.imagebox()
volicon:set_image(beautiful.widget_vol)
volumewidget = wibox.widget.textbox()
vicious.register( volumewidget, vicious.widgets.volume, "<span color=\"#7788af\">$1%</span>", 1, "Master" )
volumewidget:buttons(awful.util.table.join(
    awful.button({ }, 1, function () awful.util.spawn("amixer -q sset Master toggle", false) end),
    awful.button({ }, 3, function () awful.util.spawn("".. terminal.. " -e alsamixer", true) end),
    awful.button({ }, 4, function () awful.util.spawn("amixer -q sset Master 1dB+", false) end),
    awful.button({ }, 5, function () awful.util.spawn("amixer -q sset Master 1dB-", false) end)
))

-- }}}

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

-- {{{ Net

netdownicon = wibox.widget.imagebox()
netdownicon:set_image(beautiful.widget_netdown)
netupicon = wibox.widget.imagebox()
netupicon:set_image(beautiful.widget_netup)


wifidowninfo = wibox.widget.textbox()
vicious.register(wifidowninfo, vicious.widgets.net, "<span color=\"#ce5666\">${wlan0 down_kb}</span>", 1)

wifiupinfo = wibox.widget.textbox()
vicious.register(wifiupinfo, vicious.widgets.net, "<span color=\"#87af5f\">${wlan0 up_kb}</span>", 1)

local function dispip()
	local f, infos
	local capi = {
		mouse = mouse,
		screen = screen
	}

	f = io.popen("sh /home/luca/.scripts/ip")
	infos = f:read("*all")
	f:close()

	showip = naughty.notify( {
		text	= infos,
		timeout	= 0,
        position = "top_right",
        margin = 10,
        height = 33,
        width = 113,
        border_color = '#404040',
        border_width = 1,
        -- opacity = 0.95,
		screen	= capi.mouse.screen })
end

wifidowninfo:connect_signal('mouse::enter', function () dispip(path) end)
wifidowninfo:connect_signal('mouse::leave', function () naughty.destroy(showip) end)

-- }}}



-- {{{ Ram

memicon = wibox.widget.imagebox()
memicon:set_image(beautiful.widget_mem)
memwidget = wibox.widget.textbox()
vicious.register(memwidget, vicious.widgets.mem, "<span color=\"#7788af\">$2 MB</span>", 1)
memicon:buttons(awful.util.table.join(
    awful.button({ }, 1, function () awful.util.spawn("".. terminal.. " -e sudo htop", false) end)
))

-- }}}

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

-- {{{ Spacers

rbracket = wibox.widget.textbox()
rbracket:set_text(']')
lbracket = wibox.widget.textbox()
lbracket:set_text('[')
line = wibox.widget.textbox()
line:set_text('|')
space = wibox.widget.textbox()
space:set_text(' ')

-- }}}

-- {{{ Layout

-- Create a wibox for each screen and add it
mywibox = {}
mybottomwibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  -- Without this, the following
                                                  -- :isvisible() makes no sense
                                                  c.minimized = false
                                                  if not c:isvisible() then
                                                      awful.tag.viewonly(c:tags()[1])
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({ width=250 })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

for s = 1, screen.count() do
    
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt()
    
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                            awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                            awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                            awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                            awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))

    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s, border_width = 0, height = 20 })

    -- Widgets that are aligned to the left
    left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(mytaglist[s])
    left_layout:add(space)
    left_layout:add(space)
    left_layout:add(mpdwidget)
    left_layout:add(space)
    left_layout:add(space)
    left_layout:add(mypromptbox[s])

    -- Widgets that are aligned to the right
    right_layout = wibox.layout.fixed.horizontal()
    right_layout:add(netdownicon)
    right_layout:add(wifidowninfo)
    right_layout:add(space)
    right_layout:add(netupicon)
    right_layout:add(wifiupinfo)
    right_layout:add(space)
    right_layout:add(space)
    right_layout:add(memicon)
    right_layout:add(memwidget)
    right_layout:add(space)
    right_layout:add(space)
    right_layout:add(cpuicon)
    right_layout:add(cpuwidget)
    right_layout:add(baticon)
    right_layout:add(batwidget)
    right_layout:add(space)
    right_layout:add(space)
    right_layout:add(volicon)
    right_layout:add(volumewidget)
    right_layout:add(space)
    right_layout:add(space)
    right_layout:add(tempicon)
    right_layout:add(tempwidget)
    right_layout:add(space)
    right_layout:add(space)
    right_layout:add(uptimeicon)
    right_layout:add(uptimewidget)
    right_layout:add(space)
    right_layout:add(fsicon)
    right_layout:add(fswidget)
    right_layout:add(space)
    right_layout:add(space)
    right_layout:add(sysicon)
    right_layout:add(syswidget)
    right_layout:add(space)
    right_layout:add(space)
    right_layout:add(mytextclockicon)
    right_layout:add(mytextclock)
    right_layout:add(space)

    -- Now bring it all together
    layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_right(right_layout)

    mywibox[s]:set_widget(layout)
    
    -- Create the bottom wibox
    mybottomwibox[s] = awful.wibox({ position = "bottom", screen = s, border_width = 0, height = 20 })
    mybottomwibox[s].visible = false
    
    -- Widgets that are aligned to the left
    bottom_left_layout = wibox.layout.fixed.horizontal()
    bottom_left_layout:add(space) 

    -- Widgets that are aligned to the right
    bottom_right_layout = wibox.layout.fixed.horizontal()
    bottom_right_layout:add(space) 
    if s == 1 then bottom_right_layout:add(wibox.widget.systray()) end
    bottom_right_layout:add(mylayoutbox[s])

    -- Now bring it all together (with the tasklist in the middle)
    bottom_layout = wibox.layout.align.horizontal()
    bottom_layout:set_left(bottom_left_layout)
    bottom_layout:set_middle(mytasklist[s])
    bottom_layout:set_right(bottom_right_layout)
    mybottomwibox[s]:set_widget(bottom_layout)

end

-- }}}

-- }}}

-- {{{ Mouse Bindings

root.buttons(awful.util.table.join(
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))

-- }}}

-- {{{ Key Bindings

globalkeys = awful.util.table.join(
    awful.key({ modkey, "Control" }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey, "Control" }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey, "Control" }, "Escape", awful.tag.history.restore),
    awful.key({ modkey,           }, "Left",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "Right",
        function ()
            awful.client.focus.byidx(1)
            if client.focus then client.focus:raise() end
        end),

    -- Show/Hide Wibox
    awful.key({ modkey }, "b", function ()
    mywibox[mouse.screen].visible = not mywibox[mouse.screen].visible end),
    awful.key({ modkey, altkey }, "b", function ()
    mywibox[mouse.screen].visible = not mywibox[mouse.screen].visible
    mybottomwibox[mouse.screen].visible = not mybottomwibox[mouse.screen].visible end),
    awful.key({ altkey }, "b", function ()
    mybottomwibox[mouse.screen].visible = not mybottomwibox[mouse.screen].visible end),
    
    -- Layout manipulation
    awful.key({ modkey, altkey }, "Left", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, altkey }, "Right", function () awful.client.swap.byidx( -1)    end),
    
    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, altkey    }, "Return", function () awful.util.spawn( "sudo urxvt" ) end),
    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),
    
    -- Volume control
    awful.key({ altkey }, "plus", function () awful.util.spawn("amixer -q sset Master 1dB+", false) end),
    awful.key({ altkey }, "minus", function () awful.util.spawn("amixer -q sset Master 1dB-", false) end),
    
    -- Music control
    
    -- awful.key({ altkey,           }, "Up",      function () awful.util.spawn( "sh /home/luca/.scripts/play", false ) end),
    -- awful.key({ altkey,           }, "Down",    function () awful.util.spawn( "sh /home/luca/.scripts/stop", false ) end ),
    
    awful.key({ altkey,           }, "Up",      function () awful.util.spawn( "mpc toggle", false ) end),
    awful.key({ altkey,           }, "Down",    function () awful.util.spawn( "mpc stop", false ) end ),
    awful.key({ altkey,           }, "Left",    function () awful.util.spawn( "mpc prev", false ) end ),
    awful.key({ altkey,           }, "Right",   function () awful.util.spawn( "mpc next", false ) end ),
    
    awful.key({ modkey,        }, "Up",      function () awful.util.spawn( "sudo systemctl start mpd", false ) end),
    awful.key({ modkey,        }, "Down",    function () awful.util.spawn( "sudo systemctl stop mpd", false ) end),

    -- Control Brightness
    awful.key({ "Control" }, "9",      function () awful.util.spawn( "sudo ./.scripts/Brightness/brightness0", false ) end),
    awful.key({ "Control" }, "1",      function () awful.util.spawn( "sudo ./.scripts/Brightness/brightness1", false ) end),
    awful.key({ "Control" }, "2",      function () awful.util.spawn( "sudo ./.scripts/Brightness/brightness2", false ) end),
    awful.key({ "Control" }, "3",      function () awful.util.spawn( "sudo ./.scripts/Brightness/brightness3", false ) end),
    awful.key({ "Control" }, "4",      function () awful.util.spawn( "sudo ./.scripts/Brightness/brightness4", false ) end),
    awful.key({ "Control" }, "5",      function () awful.util.spawn( "sudo ./.scripts/Brightness/brightness5", false ) end),
    awful.key({ "Control" }, "6",      function () awful.util.spawn( "sudo ./.scripts/Brightness/brightness6", false ) end),
    awful.key({ "Control" }, "7",      function () awful.util.spawn( "sudo ./.scripts/Brightness/brightness7", false ) end),
    awful.key({ "Control" }, "8",      function () awful.util.spawn( "sudo ./.scripts/Brightness/brightness8", false ) end),

    -- Applications
    awful.key({ modkey,        }, "i",      function () awful.util.spawn(browser) end),
    awful.key({ modkey,        }, "j",      function () awful.util.spawn( "sudo sh ./.scripts/starttor", false ) end),
    awful.key({ modkey, altkey }, "j",      function () awful.util.spawn( "sudo sh ./.scripts/stoptor", false ) end),
    awful.key({ modkey,        }, "w",      function () awful.util.spawn( "iron", false ) end),
    awful.key({ modkey, altkey }, "w",      function () awful.util.spawn( "midori", false ) end),
    awful.key({ modkey,        }, "d",      function () awful.util.spawn( "dropbox start", false ) end),
    awful.key({ modkey, altkey }, "d",      function () awful.util.spawn( "dropbox stop", false ) end),
    awful.key({ modkey,        }, "e",      function () awful.util.spawn( "urxvt -title Elinks -e elinks", false ) end),
    awful.key({ modkey,        }, "n",      function () awful.util.spawn(music) end),
    awful.key({ modkey, altkey }, "n",      function () awful.util.spawn( "urxvt -title MusicInfo -e lyvi") end),
    awful.key({ modkey, altkey }, "c",      function () awful.util.spawn(chat) end),
    awful.key({ modkey,        }, "v",      function () awful.util.spawn(torrent) end),
    awful.key({ modkey, altkey }, "v",      function () awful.util.spawn( "torrent-search", false ) end),
    awful.key({ modkey,        }, "h",      function () awful.util.spawn(tasks) end),
    awful.key({ modkey,        }, "t",      function () awful.util.spawn( "urxvt -title Mail -e mutt", false ) end),
    awful.key({ modkey, altkey }, "t",      function () awful.util.spawn( "urxvt -title Feed -e newsbeuter", false ) end),
    awful.key({ modkey,        }, "m",      function () awful.util.spawn( "sh ./.scripts/start-motion", false ) end),
    awful.key({ modkey, altkey }, "m",      function () awful.util.spawn( "sh ./.scripts/stop-motion", false ) end),
    awful.key({ modkey,        }, "y",      function () awful.util.spawn( "urxvt -title Youtube -e youtube-viewer -m -C", false ) end),
    awful.key({ modkey,        }, "a",      function () awful.util.spawn( "urxvt -title Abook -e abook", false ) end),
    awful.key({ modkey,        }, "p",      function () awful.util.spawn( "spacefm", false ) end),
    awful.key({ modkey, altkey }, "p",      function () awful.util.spawn( "sudo spacefm /root", false ) end),
    awful.key({ modkey,        }, "r",      function () awful.util.spawn( "sh ./.scripts/restartwifi", false ) end),
    awful.key({ modkey,        }, "u",      function () awful.util.spawn( "sh ./.scripts/webcam", false ) end),
    awful.key({ modkey, altkey }, "u",      function () awful.util.spawn( "sh ./.scripts/wxcam", false ) end),
    awful.key({ modkey,        }, "g",      function () awful.util.spawn(gui_editor) end),
    awful.key({ modkey, altkey }, "g",      function () awful.util.spawn( "google-earth -fn -xos4-terminus-medium-r-normal--12-120-72-72-c-60-iso8859-9", false ) end),
    awful.key({ modkey, altkey }, "e",      function () awful.util.spawn(editor_cmd) end),
    awful.key({ "Control"      }, "space",  function () awful.util.spawn( "urxvt -e vim /home/luca/Desktop/thoughts.txt", false ) end),
    awful.key({ modkey,        }, "f",      function () awful.util.spawn(cli_fileman) end),
    awful.key({ modkey, altkey }, "f",      function () awful.util.spawn( "urxvt -title Ranger -e sudo ranger" ) end),
    awful.key({ modkey,        }, "k",      function () awful.util.spawn( "nowvideo-mplayer", false ) end),
    awful.key({ modkey, altkey }, "k",      function () awful.util.spawn( "nowvideo-vlc", false ) end),
    awful.key({ modkey,        }, "s",      function () awful.util.spawn( "nitrogen", false ) end),

    -- Take A Screenshot
    awful.key({ }, "Print", function () awful.util.spawn( "sh ./.scripts/scrot", false ) end),

    -- Shutdown
    awful.key({ }, "XF86PowerOff",          function () awful.util.spawn( "sudo sh ./.scripts/poweroff", false ) end),
    awful.key({ }, "Help",                  function () awful.util.spawn( "sudo sh ./.scripts/reboot", false ) end),
    -- awful.key({ modkey,        }, "l",      function () awful.util.spawn( "xset dpms force off", false ) end),
    awful.key({ modkey,        }, "l",      function () awful.util.spawn( "i3lock -bdi /media/Data/Dropbox/Photos/Wallpapers/guitar.png", false ) end),
    awful.key({ modkey, altkey }, "l",      function () awful.util.spawn( "slimlock", false ) end),
    awful.key({ modkey,        }, "x",      function () awful.util.spawn( "xkill", false ) end),
    -- awful.key({ modkey,        }, "q",      function () awful.util.spawn( "sh /home/luca/.scripts/switchtokde", false ) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ }, "XF86HomePage", awesome.quit),

    -- Prompt
    awful.key({ altkey }, "r",      function () mypromptbox[mouse.screen]:run() end),
    awful.key({ altkey }, "m",      function () awful.util.spawn( "dmenu_run -nb '#080808' -nf '#aaaaaa' -sf '#7788af' -sb '#080808' -fn '-*-termsyn-medium-r-normal-*-14-*-*-*-*-*-*-*' -f -h 20 -p 'Run application'", false ) end),
    awful.key({ altkey }, "n",      function () awful.util.spawn( "sudo dmenu_run -nb '#080808' -nf '#aaaaaa' -sf '#ce5666' -sb '#080808' -fn '*-termsyn-medium-r-normal-*-14-*-*-*-*-*-*-*' -f -h 20 -p 'Run application (root)'", false ) end),
    awful.key({ altkey }, "c",      function () awful.util.spawn( "dnetcfg -nb '#080808' -nf '#aaaaaa' -sf '#ffaf5f' -sb '#080808' -fn '-*-termsyn-medium-r-normal-*-14-*-*-*-*-*-*-*' -f -h 20", false ) end),
    awful.key({ altkey }, "v",      function () awful.util.spawn( "sh ./.scripts/connect", false ) end),
    awful.key({ altkey }, "b",      function () awful.util.spawn( "sh ./.scripts/disconnect", false ) end),
    awful.key({ altkey }, "q",      function () awful.util.spawn( "dpm -nb '#080808' -nf '#aaaaaa' -sf '#87af5f' -sb '#080808' -fn '-*-termsyn-medium-r-normal-*-14-*-*-*-*-*-*-*' -f -h 20", false ) end),
    
    awful.key({ altkey }, "w", function ()
        awful.prompt.run({ prompt = "<span color=\"#ffaf5f\">search </span>"}, mypromptbox[mouse.screen].widget,
	        function (command)
                awful.util.spawn("firefox 'https://duckduckgo.com/?q=!"..command.."'", false)
		        -- if tags[mouse.screen][2] then awful.tag.viewonly(tags[mouse.screen][2]) end
	        end)
    end)
)

clientkeys = awful.util.table.join(
    awful.key({ altkey            }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey,           }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey, "Shift"   }, "r",      function (c) c:redraw()                       end),
    awful.key({ "Control"         }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ "Control"         }, ",",      function (c) c.minimized = not c.minimized    end),
    awful.key({ "Control"         }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        screen = mouse.screen
                        if tags[screen][i] then
                            awful.tag.viewonly(tags[screen][i])
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      screen = mouse.screen
                      if tags[screen][i] then
                          awful.tag.viewtoggle(tags[screen][i])
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.movetotag(tags[client.focus.screen][i])
                      end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.toggletag(tags[client.focus.screen][i])
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)

-- }}}

-- {{{ Rules

awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = true,
                     keys = clientkeys,
                     maximized_vertical = false,
                     maximized_horizontal = false,
                     buttons = clientbuttons,
	                 size_hints_honor = false
                    }
   },
    { rule = { class = "Vlc" },
      properties = { tag = tags[1][5], switchtotag = true } },

    { rule = { class = "Vlc", name = "Playlist" },
      properties = { tag = tags[1][5], floating = true, switchtotag = true } },

    { rule = { class = "Gsharkdown.py" },
      properties = { tag = tags[1][5], switchtotag = true } },

    { rule = { class = "Gimp" },
      properties = { tag = tags[1][6] } },

    { rule = { class = "Xfburn" },
      properties = { tag = tags[1][6] } },

    { rule = { instance = "plugin-container" },
      properties = { floating = true } },

    { rule = { class = "Amule" },
      properties = { tag = tags[1][2] } },

    { rule = { class = "Firefox" },
      properties = { tag = tags[1][2], } },
    
    { rule = { class = "Iron" },
      properties = { tag = tags[1][2], } },

    { rule = { class = "Firefox" , instance = "DTA" },
      properties = { tag = tags[1][2], floating = true } },

    { rule = { class = "Firefox" , instance = "Toplevel" },
      properties = { tag = tags[1][2], floating = true } },

    { rule = { class = "Firefox" , instance = "Browser" },
      properties = { tag = tags[1][2], floating = true } },

    { rule = { class = "Firefox" , instance = "Download" },
      properties = { tag = tags[1][2], floating = true } },

    { rule = { class = "Firefox" , name = "Install user style" },
      properties = { tag = tags[1][2], floating = true } },

    { rule = { class = "Midori" },
      properties = { tag = tags[1][2], switchtotag = true } },

    { rule = { class = "xterm" },
      properties = { tag = tags[1][1], switchtotag = true } },

    { rule = { class = "xterm", name = "saidar" },
      properties = { tag = tags[1][6], switchtotag = true, floating = true } },

    { rule = { class = "xterm", name = "Music" },
      properties = { tag = tags[1][5], switchtotag = true } },

    { rule = { class = "xterm", name = "MusicInfo" },
      properties = { tag = tags[1][5], switchtotag = true } },

    { rule = { class = "xterm", name = "Mail" },
      properties = { tag = tags[1][4], switchtotag = true } },

    { rule = { class = "xterm", name = "Chat" },
      properties = { tag = tags[1][4], switchtotag = true } },
    
    { rule = { class = "xterm", name = "Torrent" },
      properties = { tag = tags[1][3], switchtotag = true } },

    { rule = { class = "xterm", name = "Feed" },
      properties = { tag = tags[1][4], switchtotag = true } },

    { rule = { class = "xterm", name = "Ranger" },
      properties = { tag = tags[1][3], switchtotag = true } },

    { rule = { class = "xterm", name = "ranger:~" },
      properties = { tag = tags[1][3], switchtotag = true } },

    { rule = { class = "xterm", name = "Youtube" },
      properties = { tag = tags[1][2], switchtotag = true } },

    { rule = { class = "xterm", name = "Abook" },
      properties = { tag = tags[1][4], switchtotag = true } },

    { rule = { class = "xterm", name = "Elinks" },
      properties = { tag = tags[1][2], switchtotag = true } },

    { rule = { class = "xterm", name = "http://duckduckgo.com/lite DuckDuckGo - ELinks" },
      properties = { tag = tags[1][2], switchtotag = true } },

    { rule = { class = "URxvt" },
      properties = { tag = tags[1][1], switchtotag = true }, callback = awful.client.setslave },

    { rule = { class = "URxvt", name = "saidar" },
      properties = { tag = tags[1][6], switchtotag = true, floating = true } },

    { rule = { class = "URxvt", name = "Music" },
      properties = { tag = tags[1][5], switchtotag = true } },

    { rule = { class = "URxvt", name = "MusicInfo" },
      properties = { tag = tags[1][5], switchtotag = true } },

    { rule = { class = "URxvt", name = "Mail" },
      properties = { tag = tags[1][4], switchtotag = true } },

    { rule = { class = "URxvt", name = "Chat" },
      properties = { tag = tags[1][4], switchtotag = true } },
    
    { rule = { class = "URxvt", name = "Torrent" },
      properties = { tag = tags[1][3], switchtotag = true } },

    { rule = { class = "URxvt", name = "Feed" },
      properties = { tag = tags[1][4], switchtotag = true } },

    { rule = { class = "URxvt", name = "Ranger" },
      properties = { tag = tags[1][3], switchtotag = true } },

    { rule = { class = "URxvt", name = "ranger:~" },
      properties = { tag = tags[1][3], switchtotag = true } },

    { rule = { class = "URxvt", name = "Youtube" },
      properties = { tag = tags[1][2], switchtotag = true } },

    { rule = { name = "xcalc" },
      properties = { tag = tags[1][6], switchtotag = true, floating = true } },

    { rule = { class = "URxvt", name = "Abook" },
      properties = { tag = tags[1][4], switchtotag = true } },

    { rule = { class = "URxvt", name = "Elinks" },
      properties = { tag = tags[1][2], switchtotag = true } },

    { rule = { class = "URxvt", name = "http://duckduckgo.com/lite DuckDuckGo - ELinks" },
      properties = { tag = tags[1][2], switchtotag = true } },

    { rule = { class = "Display" },
      properties = { tag = tags[1][1], floating = true } },

    { rule = { class = "Gajim" },
      properties = { tag = tags[1][4], floating = true, switchtotag = true } },
 
    { rule = { class = "Turpial" },
      properties = { tag = tags[1][4] } },

    { rule = { class = "Skype" },
      properties = { tag = tags[1][4], floating = true } },

    { rule = { class = "Pidgin" },
      properties = { tag = tags[1][4], floating = true } },

    { rule = { class = "Viewnior" },
      properties = { tag = tags[1][5], switchtotag = true } },
    
    { rule = { class = "feh" },
      properties = { tag = tags[1][5], switchtotag = true } },

    { rule = { class = "Qalculate-gtk" },
      properties = { tag = tags[1][6], floating = true, switchtotag = true } },
    
    { rule = { class = "Qjackctl" },
      properties = { tag = tags[1][6], floating = true } },
    
    { rule = { class = "Convertall.py" },
      properties = { tag = tags[1][6], switchtotag = true } },
    
    { rule = { class = "Spacefm" },
      properties = { tag = tags[1][3], switchtotag = true } },

    { rule = { class = "Gucharmap" },
      properties = { tag = tags[1][3], switchtotag = true } },

    { rule = { class = "Nitrogen" },
      properties = { tag = tags[1][3], switchtotag = true } },

    { rule = { class = "Geany" },
      properties = { tag = tags[1][3], switchtotag = true } },
    
    { rule = { class = "Zathura" },
      properties = { tag = tags[1][5], switchtotag = true } },

    { rule = { class = "llpp" },
      properties = { tag = tags[1][5], switchtotag = true } },

    { rule = { instance = "VCLSalFrame", class = "libreoffice-writer" },
      properties = { tag = tags[1][3], switchtotag = true } },

    { rule = { class = "libreoffice-impress" },
      properties = { tag = tags[1][3], switchtotag = true } },

    { rule = { class = "libreoffice-math" },
      properties = { tag = tags[1][3], floating = true, switchtotag = true } },

    { rule = { class = "libreoffice-calc" },
      properties = { tag = tags[1][3], switchtotag = true } },

    -- { rule = { class = "Abiword" },
      -- properties = { tag = tags[1][3], switchtotag = true } },
    
    -- { rule = { class = "Gnumeric" },
      -- properties = { tag = tags[1][3], switchtotag = true } },

    -- { rule = { class = "GWepCrackGui" },
      -- properties = { tag = tags[1][2], floating = true } },

    { rule = { class = "Torrent-search" },
      properties = { tag = tags[1][3] } },
    
    { rule = { class = "TuxGuitar" },
      properties = { tag = tags[1][5] } },

    { rule = { class = "mplayer2" },
      properties = { tag = tags[1][5], switchtotag = true } },

    { rule = { class = "mplayer2", name = "Webcam" },
      properties = { tag = tags[1][5], switchtotag = true, floating = true } },
    
    { rule = { class = "Wxcam" },
      properties = { tag = tags[1][5], switchtotag = true, floating = true } },

    { rule = { class = "Acidrip" },
      properties = { tag = tags[1][5] } },

    { rule = { class = "Unetbootin.elf" },
      properties = { tag = tags[1][6], switchtotag = true } },
    
    -- { rule = { class = "Wxcam" },
      -- properties = { tag = tags[1][5], switchtotag = true } },

    { rule = { class = "Bleachbit" },
      properties = { tag = tags[1][3] } },

    { rule = { class = "Amdcccle" },
      properties = { tag = tags[1][6] } },
     
    { rule = { class = "Googleearth-bin" },
      properties = { tag = tags[1][6] } },
    
    -- { rule = { class = "Palimpsest" },
      -- properties = { tag = tags[1][3], switchtotag = true } },

    -- { rule = { class = "Hardinfo" },
      -- properties = { tag = tags[1][3] } },
    
    { rule = { class = "Gpartedbin" },
      properties = { tag = tags[1][3], switchtotag = true } },
}

-- }}}

-- {{{ Signals

-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
    -- Enable sloppy focus
    c:connect_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end

    local titlebars_enabled = false
    if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
        -- Widgets that are aligned to the left
        local left_layout = wibox.layout.fixed.horizontal()
        left_layout:add(awful.titlebar.widget.iconwidget(c))

        -- Widgets that are aligned to the right
        local right_layout = wibox.layout.fixed.horizontal()
        right_layout:add(awful.titlebar.widget.floatingbutton(c))
        right_layout:add(awful.titlebar.widget.maximizedbutton(c))
        right_layout:add(awful.titlebar.widget.stickybutton(c))
        right_layout:add(awful.titlebar.widget.ontopbutton(c))
        right_layout:add(awful.titlebar.widget.closebutton(c))

        -- The title goes in the middle
        local title = awful.titlebar.widget.titlewidget(c)
        title:buttons(awful.util.table.join(
                awful.button({ }, 1, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.move(c)
                end),
                awful.button({ }, 3, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.resize(c)
                end)
                ))

        -- Now bring it all together
        local layout = wibox.layout.align.horizontal()
        layout:set_left(left_layout)
        layout:set_right(right_layout)
        layout:set_middle(title)

        awful.titlebar(c):set_widget(layout)
    end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

-- }}}
