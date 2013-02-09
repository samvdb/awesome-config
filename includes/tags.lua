

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
    
    awful.tag.seticon(beautiful.widget_tag_arch, tags[s][1])
    awful.tag.seticon(beautiful.widget_tag_cat, tags[s][2])
    awful.tag.seticon(beautiful.widget_tag_dish, tags[s][3])
    awful.tag.seticon(beautiful.widget_tag_mail, tags[s][4])
    awful.tag.seticon(beautiful.widget_tag_phones, tags[s][5])
    awful.tag.seticon(beautiful.widget_tag_pacman, tags[s][6]) 
end

-- }}}
