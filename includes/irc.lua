-- -----------------------------------------------------------------------------
-- IRC NOTIFICATION WIDGET
-- -----------------------------------------------------------------------------
--
-- This widget works together with an IRC client to keep you informed of
-- activity. It exposes a few functions that can be called over awesome-client,
-- and it is then up to your irc client to make use of these.
--
-- The functions exposed include a function for sending notifications via
-- naughty, functions for displaying which channels have activity, and
-- functions to clear the state.
--
-- By right clicking the widget you can toggle the notification mode (all,
-- hightlight, offline) and by left clicking you can clear the activity mark.
--
-- Any suggestions for improvement are welcome.
--
-- ----------------------------------------------------------------------------

-- ----------------------------------------------------------------------------
-- USAGE
-- ----------------------------------------------------------------------------
--
-- Proper use of this widget requires some setup.
--
-- First of all you must 'require' the widget
--   require("widget.irc")
-- Then build a widget to use in your wibox. It can be configured quite a bit.
--   irc = widget.irc({ }, {
--     text         = "<span font_desc='Dejavu Sans 11'>IRC</span>",
--     highlights   = { "nick1", "nick2", "sometextofinterest" },
--     clientname   = "weechat-curses",
--   })
--
-- Inside the wibox itself you use `widget' parameter to get the widget itself
--   irc.widget
--
-- A description of the options follows
--
-- The functions exposed on the irc object are:
--
-- notify (server, message):
--   both are strings, server should be the server, message the complete raw
--   message. It will get parse and displayed as appropriate.
--
-- activity (channels):
--   recieves a space sepatated string of irc channels with activity.
--
-- clear:
--   clears the actiuvity list
--
-- clear_notifications:
--   clears notifications on screen
--   good for binding to a keystroke
--
-- ----------------------------------------------------------------------------

-- ----------------------------------------------------------------------------
-- OPTIONS
-- ----------------------------------------------------------------------------
--
-- Several options can be set.
--
-- text: string
--   The text to show in the widget. Can be anything supported by your font
--   Try looking at the unicode table for nice characters
--
-- highlights: table
--   A table of keywords to trigger highlights (permanent notifications)
--
-- state: numeric, custom 
--   State is an integer that controls when to send notifications.
--   0: Always send (whatever the irc client sends, notify it) 
--   1: Only send highlights (check if what the irc client sends matches a
--      highlight string... if so, send, else disregard)
--   2: Notifications offline
--
-- clientname: string
--   The name of the IRC client window. No notifications will be shown if it is
--   the focused ontop window. The name of your client can be gotten throught
--   awesome itself `client.focus.name', or with xprops (WM_NAME). The string in
--   clientname is matched loosely, so you don't need a complete match.
--
-- width: numeric, pixels
--   The width of the naughty popups
--
-- Colors: hexadecimal color values, eg: "#333333" or "#999"
--   fg_normal:     Normal foreground
--   fg_highlight:  Color when notifications are highlight only
--   fg_offline:    Color when notifications are offline
--   fg_active:     Color when activity is registered
--
--   Colors can also be set in your beautiful theme, in a `irc' subtable:
--
--     theme.irc = {}
--     theme.irc.fg_normal     = "#999999"
--     theme.irc.fg_highlight  = "#ff669d"
--     theme.irc.fg_offline    = "#444444"
--     theme.irc.fg_active     = "#bfff00"
--
--   If no colors are set, sensible defaults are used
--
-- --------------------------
-- Setting options at runtime
-- --------------------------
-- All of the above options can be set at runtime by calling a function on the
-- irc object, named as the option prefixed by 'set_'.
-- As an example, using the setup from above, one can do
--    echo "irc:set_fg_offline = '#111111'" | awesome-client
-- to change the fg_offline color at any time.
-- These options can be bound to keys, so you can manipulate your setup easily.
--
-- -----------------------------------------------------------------------------

-- ----------------------------------------------------------------------------
-- TODO/MAYBE/SUGGESTIONS:
-- ----------------------------------------------------------------------------
--
-- - Handle different servers better
-- - Experiment more with clear_notifications... make sure it works properly.
--
-- ----------------------------------------------------------------------------


local setmetatable = setmetatable
local ipairs = ipairs
local pairs = pairs
local tostring = tostring
local table = table
local os = os
local string = string

local button = require("awful.button")
local tooltip = require("awful.tooltip")
local util = require("awful.util")
local naughty = require("naughty")
local beautiful = require("beautiful")

local capi = {
    widget = wibox.widget,
    client = client,
}

module("widget.irc")

local properties = {
    "text", "clientname", "highlights", "state", "width",
    "fg_active", "fg_highlight", "fg_offline", "fg_normal",
}

local notifications = {}

local function notify(data, server, message)

    -- if we are not offline, we send
    local send = not (data.state == 2)
    local highlight = false

    -- if we have the irc client focused and on top then dont send
    if capi.client.focus and
        data.clientname and
        string.find(capi.client.focus.name, data.clientname, 0, true) then
        if not capi.client.ontop then send = false end
    end

    if send then

        -- split the message into it's components
        local nick = string.sub(message, 2, string.find(message, "!", 0, true)-1)
        local signal = string.match(message, ".- (.[^%s]+)")
        local channel = string.match(message, ".- .- :?(.[^%s]+)")
        local msg = string.match(message, ".- .- .- :(.+)")

        local args = {}
        if signal == "JOIN" then
            args.text = "<b>" .. nick .. "</b> joined <b>" .. channel .. "</b>"
        elseif signal == "PRIVMSG" then
            args.title = nick .. " on " .. channel
            -- wrap the line nicely
            args.text = util.linewrap(msg)

            -- check if we should highlight the notification
            for _, v in pairs(data.highlights) do
                if string.find(msg, v) then
                    args.title = args.title .. " at " ..  os.date("%H:%M")
                    args.timeout = 0
                    args.border_color = "#990011"
                    highlight = true
                end
            end
        end

        -- set some fixed values
        args.width = data.width

        local n;

        if data.state == 0 or (data.state == 1 and highlight) then
            n = naughty.notify(args)
        end

        if n.box.screen and highlight then
            table.insert(notifications, n)
        end
    end
end

local function status (data)
    local status = ""
    if data.state == 0 then
        status = "<span color='" .. data.fg_normal .. "'>All</span>"
    elseif data.state == 1 then
        status = "<span color='" .. data.fg_highlight .. "'>Highlight</span>"
    elseif data.state == 2 then
        status = "<span color='" .. data.fg_offline .. "'>None</span>"
    end

    local text = "Status: " .. status
    if data.active then
        text = text .. "\nActivity:" 
        for chan in string.gmatch(data.active, "[^%s].[^%s]+") do
            text = text .. "\n  <span color='#ffffff'>" .. chan .. "</span>"
        end
    end

    data._status = naughty.notify({
        text = text,
        timeout = 0,
    })
end

local function toggle (data)
    data.state = data.state + 1
    if data.state > 2 then data.state = 0 end
end

local function update (data)
    local text = ""
    local fg = data.fg_normal
    if data.state == 1 then
        fg = data.fg_highlight
    end
    if data.active then
        fg = data.fg_active
    end
    if data.state == 2 then
        fg = data.fg_offline
    end
    text = text .. "<span color='" .. fg .. "'>" .. data.text .. "</span>"
    if data._status then
        data.widget:emit_signal("mouse::leave")
        data.widget:emit_signal("mouse::enter")
    end
    data.widget.text = text
end

-- Build properties function
for _, prop in ipairs(properties) do
    if not _M["set_" .. prop] then
        _M["set_" .. prop] = function(data, value)
            data[prop] = value
            update(data)
            return data
        end
    end
end

-- @param args Standard arguments for textbox widget.
-- @param props Properties controlling the display
-- text The text to show
-- highlights A table of keywords to trigger highlights
-- state What state to start the widget in
-- clientname The name of the client window. No notifications will
--            be shown if it is the focused ontop window  
-- width The width of the naughty popups
-- fg_normal Normal foreground
-- fg_highlight Color when notifications are highlight only
-- fg_offline Color when notifications are offline
-- fg_active Color when activity is registered
function new(args, props)
    local args = args or {}
    local props = props or {}
    local theme = beautiful.get()
    theme = theme.irc or {}

    props.text          = props.text or "IRC"
    props.hightlights   = props.hightlights or {}
    props.state         = props.state or 0
    props.clientname    = props.clientname or nil
    props.width         = props.width or 450

    props.fg_normal      = props.fg_normal    or theme.fg_normal    or "#ffffff"
    props.fg_highlight   = props.fg_highlight or theme.fg_highlight or "#ff8800"
    props.fg_offline     = props.fg_offline   or theme.fg_offline   or "#444444"
    props.fg_active      = props.fg_active    or theme.fg_active    or "#bfff00"

    local irc = props

    args.type = "textbox"
    irc.widget = capi.widget(args)
    irc.widget.align = args.align or "center"

    -- add the mouse buttons
    irc.widget:buttons(util.table.join(
        button({ }, 1, function () irc.clear() end), -- LEFT MOUSE: clear highlight
        button({ }, 3, function () toggle(irc); update(irc) end) -- MIDDLE MOUSE: toggle state
    ))

    -- add mouseover status
    irc._status = nil
    irc.widget:add_signal("mouse::enter", function () status(irc) end)
    irc.widget:add_signal("mouse::leave", function () if irc._status then naughty.destroy(irc._status); irc._status = nil end end)
 
    -- define the functions that are called externally
    irc.notify = function (server, message) notify(irc, server, message) end

    irc.active = nil
    irc.activity = function (channels)
        irc.active = channels
        update(irc)
    end
    irc.clear = function ()
        irc.active = nil
        update(irc)
    end
    irc.clear_notifications = function ()
        for i,n in ipairs(notifications) do
            if n.box.screen then
                naughty.destroy(n)
            end
            table.remove(notifications, i)
        end
    end

    -- Set methods
    for _, prop in ipairs(properties) do
        irc["set_" .. prop] = _M["set_" .. prop]
    end

    update(irc)
    return irc
end

setmetatable(_M, { __call = function(_, ...) return new(...) end })

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:encoding=utf-8:textwidth=80