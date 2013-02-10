-- {{ IRC
require("widget.irc")
irc = widget.irc({ }, {
    text = "<span font_desc='Dejavu Sans 11'>&#x2318;</span>", -- PLACE OF INTEREST SIGN
})
irc:set_highlights({ "alterecco", "otherecco" })
irc:set_clientname("weechat-curses")
awful.widget.layout.margins[irc.widget] = { left = 1, right = 2, top = 1 }
	
}}
