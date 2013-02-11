-- Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awful.util.getdir("config") .. "/rc.lua" },
   { "restart", awesome.restart },
   { "quit", awesome.quit }
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "mcabber", "screen -c " .. home .. "/.mcabber/screenrc -d -m -S mcabber" },
                                    { "nvidia-settings", "nvidia-settings" },
                                    { "rtorrent", "urxvtc -title rtorrent -e sh -c 'ssh -t alparo@elysium dtach -a /tmp/rtorrent'" },
                                    { "open terminal", terminal },
                                    { "open red terminal", root_terminal }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = image(beautiful.awesome_icon),
                                     menu = mymainmenu })
