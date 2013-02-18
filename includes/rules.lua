-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    -- { rule = { },
    --   properties = { border_width = beautiful.border_width,
    --                  border_color = beautiful.border_normal,
    --                  focus = awful.client.focus.filter,
    --                  keys = clientkeys,
    --                  buttons = clientbuttons } },

    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = true,
                     keys = clientkeys,
                     maximized_vertical = TRUE,
                     maximized_horizontal = false,
                     buttons = clientbuttons,
                     size_hints_honor = false } },
   
-- {{ Chat 

    { rule = { class = "urxvt_weechat" },
	properties = { tag = tags[2][4] }},

-- }}

-- {{ Coding

    { rule = { class = "sublime_text" },
	properties = { tag = tags[2][2] }},

-- }} 

-- {{ Terminals / Git 

    { rule = { class = "urxvt_git_full" },
	properties = { tag = tags[1][1] }},
    { rule = { class = "urxvt_git_cercom" },
	properties = { tag = tags[1][1] }},
    { rule = { class = "urxvt_log" },
	properties = { tag = tags[1][1],
		maximized_horizontal = true } },
-- }} 	

    { rule = { class = "xterm" },
      properties = { floating = true } },
    { rule = { class = "urxvt" },
      properties = { floating = true } },
    { rule = { class = "MPlayer" },
      properties = { floating = true } },
    { rule = { class = "pinentry" },
      properties = { floating = true } },
    { rule = { class = "gimp" },
      properties = { floating = true } },
    -- Set Firefox to always map on tags number 2 of screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { tag = tags[1][2] } },
}
-- }}}
