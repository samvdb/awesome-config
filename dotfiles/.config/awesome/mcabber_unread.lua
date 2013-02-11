-- This is for mcabber unread messages in statusbar
function mcabber_unread ()
    local UNRDFILE = "/tmp/event.unread"
    local unread

    local fh = io.open(UNRDFILE)
    if not fh then return "" end

    unread = fh:read("*l")
    fh:close()

    if unread and unread ~= "0" then return "["..unread.."]" end
    return ""
end
