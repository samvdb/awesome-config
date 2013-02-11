-- Standard awesome library
require("awful")
require("awful.autofocus")
require("awful.rules")
-- Theme handling library
require("beautiful")
-- Notification library
require("naughty")
require("wicked")
require("scratch")
-- Battery Widget
require("battery")


-- {{{ Variable definitions
-- This is for dopath to open files from awesome home directory
function dopath(file)
  dofile(awesome_config_path .. file)
end

awesome_config_path = os.getenv("XDG_CONFIG_HOME") .. "/awesome/"
home = os.getenv("HOME")

-- Themes define colours, icons, and wallpapers
beautiful.init(awesome_config_path .. "theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "urxvtc"
editor = os.getenv("EDITOR") or "nano"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
{
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
--    awful.layout.suit.spiral,
--    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier,
    awful.layout.suit.floating
}
-- }}}

-- Included files {{{
dopath("tags.lua")
dopath("menu.lua")
dopath("wibox.lua")
dopath("bindings.lua")
dopath("rules.lua")
dopath("signals.lua")
dopath("mcabber_unread.lua")
-- }}}

-- vim:foldmethod=marker
