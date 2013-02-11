-- {{{ For mcabber notifications
naughty.config.presets.online = {
    bg = "#1f880e80",
    fg = "#ffffff",
}
naughty.config.presets.chat = naughty.config.presets.online
naughty.config.presets.away = {
    bg = "#eb4b1380",
    fg = "#ffffff",
}
naughty.config.presets.xa = {
    bg = "#65000080",
    fg = "#ffffff",
}
naughty.config.presets.dnd = {
    bg = "#65340080",
    fg = "#ffffff",
}
naughty.config.presets.invisible = {
    bg = "#ffffff80",
    fg = "#000000",
}
naughty.config.presets.offline = {
    bg = "#64636380",
    fg = "#ffffff",
}
naughty.config.presets.requested = naughty.config.presets.offline
naughty.config.presets.error = {
    bg = "#ff000080",
    fg = "#ffffff",
}

muc_nick = "alparo"

function mcabber_event_hook(kind, direction, jid, msg)
    if kind == "MSG" then
        if direction == "IN" or direction == "MUC" then
            local filehandle = io.open(msg)
            local txt = filehandle:read("*all")
            filehandle:close()
            awful.util.spawn("rm "..msg)
            if direction == "MUC" and txt:match( "^<" .. muc_nick .. ">" ) then
                return
            end
            naughty.notify{
                icon = "chat_msg_recv",
                text = awful.util.escape(txt),
                title = jid
            }
        end
    elseif kind == "STATUS" then
        local mapping = {
            [ "O" ] = "online",
            [ "F" ] = "chat",
            [ "A" ] = "away",
            [ "N" ] = "xa",
            [ "D" ] = "dnd",
            [ "I" ] = "invisible",
            [ "_" ] = "offline",
            [ "?" ] = "error",
            [ "X" ] = "requested"
        }
        local status = mapping[direction]
        local iconstatus = status
        if not status then
            status = "error"
        end
        --if jid:match("icq") then
            --iconstatus = "icq/" .. status
        --end
        naughty.notify{
            preset = naughty.config.presets[status],
            text = jid
            --icon = iconstatus
        }
    end
end

naughty.config.icon_dirs = { awesome_config_path .. "naughtyicons/", "/usr/share/pixmaps/" }
