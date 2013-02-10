-- -----------------------------------------------------------------------------
-- AWESOME NOTIFICATION PLUGIN
-- -----------------------------------------------------------------------------
--
-- This plugin is used together with an awesome notification widget.
--
-- It exposes one buffer command `awesome' which toggles the notifications for
-- the channel on/off. Other than that it just pipes any notifications (properly
-- escaped) through awesome-client, and talks to a handler there with the
-- signature `tools.irc.notify(server, message)'. In addition it requires the
-- handlers `tools.irc.clear()' and `tools.irc.activity(channels)'
--
-- For an example of an awesome widget that uses this plugin, have a look at:
-- http://github.com/alterecco/config/blob/master/config/awesome/widget/irc.lua
-- 
-- ----------------------------------------------------------------------------

-- ----------------------------------------------------------------------------
-- TODO/MAYBE/SUGGESTIONS:
-- ----------------------------------------------------------------------------
--
-- - Update highlight handling once version 0.3.1.1 hits the street
--
-- ----------------------------------------------------------------------------

version = "0.1"
weechat.register("naughtynotice", "alterecco", version, "GPL", "Naughty Notices for Awesome WM", "", "")

weechat.hook_signal("*,irc_in2_PRIVMSG", "receive", "")
weechat.hook_signal("*,irc_in2_JOIN", "receive", "")

weechat.hook_signal("hotlist_changed", "toggle_hotlist", "")

weechat.hook_command("awesome", "Mark current channel to pass messages to awesome", "", "", "", "toggle_ignore", "")

ignored_channels = {}

function toggle_hotlist()
    if os.getenv("DISPLAY") then
        local active = {}
        local hotlist = weechat.infolist_get("hotlist", "", "")
        -- if we have buffers in the hotlist then check if they should be
        -- added as active (if they are irc buffers).
        if hotlist then
            while weechat.infolist_next(hotlist) == 1 do
                local b = weechat.infolist_pointer(hotlist, "buffer_pointer")
                local c = weechat.buffer_get_string(b, "localvar_channel")
                if weechat.info_get("irc_is_channel", c) then
                    table.insert(active, c)
                end
            end
            weechat.infolist_free(hotlist)
        end
        if #active == 0 then
            os.execute("echo 'tools.irc.clear()' | awesome-client")
        else
            os.execute(string.format("echo 'tools.irc.activity(%q)' | awesome-client", table.concat(active, " ")))
        end
    end
end

-- Pipe message and data to awesome
function receive(data, sig, message)
    if os.getenv("DISPLAY") then
        local channel = string.match(message, ".- .- :?(.[^%s]+)")
        local server = string.sub(sig, 1, string.find(sig, ",", 0, true)-1)
        if channel and server and not ignored_channels[server .. "." .. channel] then
            -- check if the notify settings allow us to pass the message
            local pass = false
            local buffer = weechat.buffer_search("irc", server .. "." .. channel)
            if buffer then
                local notify = weechat.buffer_get_integer(buffer, "notify")
                if notify == 1 then
                    -- get the message itself
                    local m = string.gsub(message, ".[^ ]+", "", 3):sub(3)

                    -- XXX: one day... one day...
                    -- XXX: if version > 0.3.1.1 then we can get highlights easily
                    -- local highlights = weechat.buffer_get_string(buffer, "highlight_words")
                    -- i have been told this will be available in the future
                    -- if weechat.string_has_highlight(m, highlights) == 1 then
                    --     pass = true
                    -- end

                    -- we have to jump through some hoops to get the highlights
                    -- and do the actual matching ourself
                    local nick = weechat.info_get("irc_nick", server)
                    local highlights = weechat.config_string(weechat.config_get("weechat.look.highlight")) .. "," .. nick
                    -- replace * with .* so we can do lua pattern matching
                    highlights = string.gsub(highlights, "%*", ".*")
                    -- weechat.log_print(highlights)
                    for word in string.gmatch(highlights, "[^,].[^,]+") do
                        -- weechat.log_print("Match on: " .. word)
                        if string.find(m, word) then
                            pass = true
                            break
                        end
                    end
                elseif notify > 1 then
                    pass = true
                end
            end
            if pass then
                -- escape quotes in the message
                message = message:gsub("['&<>\"]", { ["'"] = "&apos;", ["\""] = "&quot;", ["<"] = "&lt;", [">"] = "&gt;", ["&"] = "&amp;" })
                os.execute(string.format("echo 'tools.irc.notify(%q, %q)' | awesome-client", server, message))
            end
        end
    end
end

-- Toggle ignore flag on channel
function toggle_ignore(data, buf, args)
    -- if channel is an irc channel then proceed
    local plugin = weechat.buffer_get_string(buf, "plugin")
    if plugin and plugin == 'irc' then
        -- full channel name, with server
        local channel = weechat.buffer_get_string(buf, "name")
        if ignored_channels[channel] then
            ignored_channels[channel] = nil
            weechat.print(buf, "Channel " .. channel .. " removed from awesome notification ignore list")
        else
            ignored_channels[channel] = true
            weechat.print(buf, "Channel " .. channel .." added to awesome notification ignore list")
        end
    else
        weechat.print(buf, "Command must be run on a channel")
    end

    return weechat.WEECHAT_RC_OK
end

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:encoding=utf-8:textwidth=80