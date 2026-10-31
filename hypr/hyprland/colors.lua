hl.config({
    general = {
        col = {
            active_border = "rgba(9d8e81AA)",
            inactive_border = "rgba(50453aAA)",
        },
    },
    misc = {
        background_color = "rgba(18120cFF)",
    },
})

hl.window_rule({
    name = "windowrule-pinned-border",
    match = {
        pin = 1,
    },
    border_color = "rgba(faba73AA) rgba(faba7377)",
})
