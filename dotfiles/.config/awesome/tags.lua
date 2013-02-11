-- Tags
-- Define a tag table which hold all screen tags.
tags = {}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = {}
    tags[s][1] = tag({name = "trm"})
    tags[s][1].screen = s
    awful.layout.set(layouts[1], tags[s][1])
    tags[s][2] = tag({ name = "vim" })
    tags[s][2].screen = s
    awful.layout.set(layouts[1], tags[s][2])
    tags[s][3] = tag({ name = "web" })
    tags[s][3].screen = s
    awful.layout.set(layouts[9], tags[s][3])
    tags[s][4] = tag({ name = "rss" })
    tags[s][4].screen = s
    awful.layout.set(layouts[1], tags[s][4])
    tags[s][5] = tag({ name = "wrk" })
    tags[s][5].screen = s
    awful.layout.set(layouts[1], tags[s][5])
    tags[s][6] = tag({ name = "doc" })
    tags[s][6].screen = s
    awful.layout.set(layouts[1], tags[s][6])
    tags[s][7] = tag({ name = "mail" })
    tags[s][7].screen = s
    awful.layout.set(layouts[1], tags[s][7])
    tags[s][8] = tag({ name = "trsh" })
    tags[s][8].screen = s
    awful.layout.set(layouts[9], tags[s][8])

    -- I'm sure you want to see at least one tag.
    tags[s][1].selected = true
end
