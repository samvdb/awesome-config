------------------------------------------------
--         Full Color Awesome Theme           --    
--          by TheImmortalPhoenix             --
-- http://theimmortalphoenix.deviantart.com/  --
------------------------------------------------

-- {{{ Main

theme = {}
theme.confdir = os.getenv("HOME") .. "/.config/awesome/themes/colored"

-- }}}

-- {{{ Font

theme.font      = "Termsyn 14"

-- }}}

-- {{{ Colors

-- theme.bg_systray = theme.bg_normal

theme.bg_normal     = "#080808"
theme.bg_focus      = "#080808"
theme.bg_urgent     = "#080808"
theme.bg_minimize   = "#080808"

theme.fg_normal     = "#aaaaaa"
theme.fg_focus      = "#7788af"
theme.fg_urgent     = "#94738c"
theme.fg_minimize   = "#444444"

theme.fg_black      = "#424242"
theme.fg_red        = "#ce5666"
theme.fg_green      = "#80a673"
theme.fg_yellow     = "#ffaf5f"
theme.fg_blue       = "#7788af"
theme.fg_magenta    = "#94738c"
theme.fg_cyan       = "#778baf"
theme.fg_white      = "#aaaaaa"
theme.fg_blu        = "#8ebdde"

-- }}}

-- {{{ Borders

theme.border_width  = 1
theme.border_normal = "#202020"
theme.border_focus  = "#535d6c"
theme.border_marked = "#91231c"

-- }}}

-- {{{ Menu

theme.menu_height       = "8"
theme.menu_width        = "105"
theme.menu_border_width = "0"
theme.menu_fg_normal    = "#aaaaaa"   --color txt pip
theme.menu_fg_focus     = "#7788af"
theme.menu_bg_normal    = "#080808"   --background menu
theme.menu_bg_focus     = "#080808"

-- }}}

-- {{{ Icons

-- {{{  Widget icons

theme.widget_uptime     = theme.confdir .. "/widgets/magenta/ac_01.png"
theme.widget_cpu        = theme.confdir .. "/widgets/green/cpu.png"
theme.widget_temp       = theme.confdir .. "/widgets/yellow/temp.png"
theme.widget_mem        = theme.confdir .. "/widgets/cyan/mem.png"
theme.widget_fs         = theme.confdir .. "/widgets/cyan/usb.png"
theme.widget_netdown    = theme.confdir .. "/widgets/red/net_down_03.png"
theme.widget_netup      = theme.confdir .. "/widgets/green/net_up_03.png"
theme.widget_gmail      = theme.confdir .. "/widgets/magenta/mail.png"
theme.widget_sys        = theme.confdir .. "/widgets/green/dish.png"
theme.widget_pac        = theme.confdir .. "/widgets/green/pacman.png"
theme.widget_batt       = theme.confdir .. "/widgets/yellow/bat_full_01.png"
theme.widget_clock      = theme.confdir .. "/widgets/cyan/clock.png"
theme.widget_vol        = theme.confdir .. "/widgets/cyan/spkr_01.png"

-- }}}

-- {{{ Tag Icons

theme.widget_tag_arch     = theme.confdir .. "/widgets/magenta/arch_10x10.png"
theme.widget_tag_cat     = theme.confdir .. "/widgets/magenta/cat.png"
theme.widget_tag_dish     = theme.confdir .. "/widgets/magenta/dish.png"
theme.widget_tag_mail     = theme.confdir .. "/widgets/magenta/mail.png"
theme.widget_tag_phone     = theme.confdir .. "/widgets/magenta/phones.png"
theme.widget_tag_pacman     = theme.confdir .. "/widgets/magenta/pacman.png"

-- }}}


-- {{{ Taglist

theme.taglist_squares_sel   = theme.confdir .. "/taglist/squaref_b.png"
theme.taglist_squares_unsel = theme.confdir .. "/taglist/square_b.png"

--theme.taglist_squares_resize = "false"

-- }}}

-- {{{ Misc

theme.tasklist_floating_icon = theme.confdir .. "/floating.png"

-- }}}

-- {{{ Layout

theme.layout_tile       = theme.confdir .. "/layouts/tile.png"
theme.layout_tileleft   = theme.confdir .. "/layouts/tileleft.png"
theme.layout_tilebottom = theme.confdir .. "/layouts/tilebottom.png"
theme.layout_tiletop    = theme.confdir .. "/layouts/tiletop.png"
theme.layout_fairv      = theme.confdir .. "/layouts/fairv.png"
theme.layout_fairh      = theme.confdir .. "/layouts/fairh.png"
theme.layout_spiral     = theme.confdir .. "/layouts/spiral.png"
theme.layout_dwindle    = theme.confdir .. "/layouts/dwindle.png"
theme.layout_max        = theme.confdir .. "/layouts/max.png"
theme.layout_fullscreen = theme.confdir .. "/layouts/fullscreen.png"
theme.layout_magnifier  = theme.confdir .. "/layouts/magnifier.png"
theme.layout_floating   = theme.confdir .. "/layouts/floating.png"

-- }}}

-- }}}

return theme
