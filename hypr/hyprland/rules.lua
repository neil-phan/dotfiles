-- ######## Window rules ########

-- Disable blur for xwayland context menus
hl.window_rule({
    name = "windowrule-1",
    match = {
        class = "^()$",
        title = "^()$",
    },
    no_blur = true,
})

-- Disable blur for every window
hl.window_rule({
    name = "windowrule-2",
    match = {
        class = ".*",
    },
    no_blur = true,
})

-- Floating
hl.window_rule({
    name = "windowrule-3",
    match = {
        title = "^(Open File)(.*)$",
    },
    center = true,
    float = true,
})

hl.window_rule({
    name = "windowrule-4",
    match = {
        title = "^(Select a File)(.*)$",
    },
    center = true,
    float = true,
})

hl.window_rule({
    name = "windowrule-5",
    match = {
        title = "^(Choose wallpaper)(.*)$",
    },
    center = true,
    float = true,
    size = "(monitor_w*0.6) (monitor_h*0.65)",
})

hl.window_rule({
    name = "windowrule-6",
    match = {
        title = "^(Open Folder)(.*)$",
    },
    center = true,
    float = true,
})

hl.window_rule({
    name = "windowrule-7",
    match = {
        title = "^(Save As)(.*)$",
    },
    center = true,
    float = true,
})

hl.window_rule({
    name = "windowrule-8",
    match = {
        title = "^(Library)(.*)$",
    },
    center = true,
    float = true,
})

hl.window_rule({
    name = "windowrule-9",
    match = {
        title = "^(File Upload)(.*)$",
    },
    center = true,
    float = true,
})

hl.window_rule({
    name = "windowrule-10",
    match = {
        title = "^(.*)(wants to save)$",
    },
    center = true,
    float = true,
})

hl.window_rule({
    name = "windowrule-11",
    match = {
        title = "^(.*)(wants to open)$",
    },
    center = true,
    float = true,
})

hl.window_rule({
    name = "windowrule-12",
    match = {
        class = "^(blueberry\\.py)$",
    },
    float = true,
})

hl.window_rule({
    name = "windowrule-13",
    match = {
        class = "^(guifetch)$",
    },
    float = true,
})

hl.window_rule({
    name = "windowrule-14",
    match = {
        class = "^(pavucontrol)$",
    },
    float = true,
    size = "(monitor_w*0.45) (monitor_h*0.45)",
    center = true,
})

hl.window_rule({
    name = "windowrule-15",
    match = {
        class = "^(org.pulseaudio.pavucontrol)$",
    },
    float = true,
    size = "(monitor_w*0.45) (monitor_h*0.45)",
    center = true,
})

hl.window_rule({
    name = "windowrule-16",
    match = {
        class = "^(nm-connection-editor)$",
    },
    float = true,
    size = "(monitor_w*0.45) (monitor_h*0.45)",
    center = true,
})

hl.window_rule({
    name = "windowrule-17",
    match = {
        class = ".*plasmawindowed.*",
    },
    float = true,
})

hl.window_rule({
    name = "windowrule-18",
    match = {
        class = "kcm_.*",
    },
    float = true,
})

hl.window_rule({
    name = "windowrule-19",
    match = {
        class = ".*bluedevilwizard",
    },
    float = true,
})

hl.window_rule({
    name = "windowrule-20",
    match = {
        title = ".*Welcome",
    },
    float = true,
})

hl.window_rule({
    name = "windowrule-21",
    match = {
        title = "^(floating-garden Settings)$",
    },
    float = true,
})

hl.window_rule({
    name = "windowrule-22",
    match = {
        title = ".*Shell conflicts.*",
    },
    float = true,
})

hl.window_rule({
    name = "windowrule-23",
    match = {
        class = "org.freedesktop.impl.portal.desktop.kde",
    },
    float = true,
    size = "(monitor_w*0.6) (monitor_h*0.65)",
})

hl.window_rule({
    name = "windowrule-24",
    match = {
        class = "^(Zotero)$",
    },
    float = true,
    size = "(monitor_w*0.45) (monitor_h*0.45)",
})

-- Move
-- kde-material-you-colors spawns a window when changing dark/light theme. This is to make sure it doesn't interfere at all.
hl.window_rule({
    name = "windowrule-25",
    match = {
        class = "^(plasma-changeicons)$",
    },
    float = true,
    no_initial_focus = true,
    move = "(999999) (999999)",
})

-- stupid dolphin copy
hl.window_rule({
    name = "windowrule-26",
    match = {
        title = "^(Copying — Dolphin)$",
    },
    move = "(40) (80)",
})

-- Tiling
hl.window_rule({
    name = "windowrule-27",
    match = {
        class = "^dev\\.warp\\.Warp$",
    },
    float = false,
})

-- Picture-in-Picture
hl.window_rule({
    name = "windowrule-28",
    match = {
        title = "^([Pp]icture[-\\s]?[Ii]n[-\\s]?[Pp]icture)(.*)$",
    },
    float = true,
    keep_aspect_ratio = true,
    move = "((monitor_w*0.73)) ((monitor_h*0.72))",
    size = "(monitor_w*0.25) (monitor_h*0.25)",
    pin = true,
})

-- --- Tearing ---
hl.window_rule({
    name = "windowrule-29",
    match = {
        title = ".*\\.exe",
    },
    immediate = true,
})

hl.window_rule({
    name = "windowrule-30",
    match = {
        title = ".*minecraft.*",
    },
    immediate = true,
})

hl.window_rule({
    name = "windowrule-31",
    match = {
        class = "^(steam_app).*",
    },
    immediate = true,
})

-- Fix Jetbrain IDEs focus/rerendering problem
hl.window_rule({
    name = "windowrule-32",
    match = {
        class = "^jetbrains-.*$",
        float = 1,
        title = "^$|^\\s$|^win\\d+$",
    },
    no_initial_focus = true,
})

-- No shadow for tiled windows (matches windows that are not floating).
hl.window_rule({
    name = "windowrule-33",
    match = {
        float = 0,
    },
    no_shadow = true,
})

-- ######## Workspace rules ########
hl.workspace_rule({
    workspace = "special:special",
    gaps_out = 30,
})

-- ######## Layer rules ########
hl.layer_rule({
    name = "layerrule-1",
    match = {
        namespace = ".*",
    },
    xray = true,
})

-- layerrule = noanim, .*
hl.layer_rule({
    name = "layerrule-2",
    match = {
        namespace = "walker",
    },
    no_anim = true,
})

hl.layer_rule({
    name = "layerrule-3",
    match = {
        namespace = "selection",
    },
    no_anim = true,
})

hl.layer_rule({
    name = "layerrule-4",
    match = {
        namespace = "overview",
    },
    no_anim = true,
})

hl.layer_rule({
    name = "layerrule-5",
    match = {
        namespace = "anyrun",
    },
    no_anim = true,
})

hl.layer_rule({
    name = "layerrule-6",
    match = {
        namespace = "indicator.*",
    },
    no_anim = true,
    blur = true,
    ignore_alpha = 0.6,
})

hl.layer_rule({
    name = "layerrule-7",
    match = {
        namespace = "osk",
    },
    no_anim = true,
})

hl.layer_rule({
    name = "layerrule-8",
    match = {
        namespace = "hyprpicker",
    },
    no_anim = true,
})

hl.layer_rule({
    name = "layerrule-9",
    match = {
        namespace = "noanim",
    },
    no_anim = true,
})

hl.layer_rule({
    name = "layerrule-10",
    match = {
        namespace = "gtk-layer-shell",
    },
    blur = true,
    ignore_alpha = 0,
})

hl.layer_rule({
    name = "layerrule-11",
    match = {
        namespace = "launcher",
    },
    blur = true,
    ignore_alpha = 0.5,
})

hl.layer_rule({
    name = "layerrule-12",
    match = {
        namespace = "notifications",
    },
    blur = true,
    ignore_alpha = 0.69,
})

-- ags
hl.layer_rule({
    name = "layerrule-14",
    match = {
        namespace = "sideleft.*",
    },
    animation = "slide left",
})

hl.layer_rule({
    name = "layerrule-15",
    match = {
        namespace = "sideright.*",
    },
    animation = "slide right",
})

hl.layer_rule({
    name = "layerrule-16",
    match = {
        namespace = "session[0-9]*",
    },
    blur = true,
})

hl.layer_rule({
    name = "layerrule-17",
    match = {
        namespace = "bar[0-9]*",
    },
    blur = true,
    ignore_alpha = 0.6,
})

hl.layer_rule({
    name = "layerrule-18",
    match = {
        namespace = "barcorner.*",
    },
    blur = true,
    ignore_alpha = 0.6,
})

hl.layer_rule({
    name = "layerrule-19",
    match = {
        namespace = "dock[0-9]*",
    },
    blur = true,
    ignore_alpha = 0.6,
})

hl.layer_rule({
    name = "layerrule-20",
    match = {
        namespace = "overview[0-9]*",
    },
    blur = true,
    ignore_alpha = 0.6,
})

hl.layer_rule({
    name = "layerrule-21",
    match = {
        namespace = "cheatsheet[0-9]*",
    },
    blur = true,
    ignore_alpha = 0.6,
})

hl.layer_rule({
    name = "layerrule-22",
    match = {
        namespace = "sideright[0-9]*",
    },
    blur = true,
    ignore_alpha = 0.6,
})

hl.layer_rule({
    name = "layerrule-23",
    match = {
        namespace = "sideleft[0-9]*",
    },
    blur = true,
    ignore_alpha = 0.6,
})

hl.layer_rule({
    name = "layerrule-24",
    match = {
        namespace = "osk[0-9]*",
    },
    blur = true,
    ignore_alpha = 0.6,
})

-- Quickshell
hl.layer_rule({
    name = "layerrule-25",
    match = {
        namespace = "quickshell:.*",
    },
    blur_popups = true,
    blur = true,
    ignore_alpha = 0.79,
})

hl.layer_rule({
    name = "layerrule-26",
    match = {
        namespace = "quickshell:bar",
    },
    animation = "slide",
})

hl.layer_rule({
    name = "layerrule-27",
    match = {
        namespace = "quickshell:actionCenter",
    },
    no_anim = true,
})

hl.layer_rule({
    name = "layerrule-28",
    match = {
        namespace = "quickshell:cheatsheet",
    },
    animation = "slide bottom",
})

hl.layer_rule({
    name = "layerrule-29",
    match = {
        namespace = "quickshell:dock",
    },
    animation = "slide bottom",
})

hl.layer_rule({
    name = "layerrule-30",
    match = {
        namespace = "quickshell:screenCorners",
    },
    animation = "popin 120%",
})

hl.layer_rule({
    name = "layerrule-31",
    match = {
        namespace = "quickshell:lockWindowPusher",
    },
    no_anim = true,
})

hl.layer_rule({
    name = "layerrule-32",
    match = {
        namespace = "quickshell:notificationPopup",
    },
    animation = "fade",
})

hl.layer_rule({
    name = "layerrule-33",
    match = {
        namespace = "quickshell:overlay",
    },
    no_anim = true,
    ignore_alpha = 1,
})

hl.layer_rule({
    name = "layerrule-34",
    match = {
        namespace = "quickshell:overview",
    },
    no_anim = true,
})

hl.layer_rule({
    name = "layerrule-35",
    match = {
        namespace = "quickshell:osk",
    },
    animation = "slide bottom",
})

hl.layer_rule({
    name = "layerrule-36",
    match = {
        namespace = "quickshell:polkit",
    },
    no_anim = true,
})

hl.layer_rule({
    name = "layerrule-37",
    match = {
        namespace = "quickshell:popup",
    },
    xray = false,
})

hl.layer_rule({
    name = "layerrule-38",
    match = {
        namespace = "quickshell:popup",
    },
    ignore_alpha = 1,
})

hl.layer_rule({
    name = "layerrule-39",
    match = {
        namespace = "quickshell:mediaControls",
    },
    ignore_alpha = 1,
})

hl.layer_rule({
    name = "layerrule-40",
    match = {
        namespace = "quickshell:reloadPopup",
    },
    animation = "slide",
})

hl.layer_rule({
    name = "layerrule-41",
    match = {
        namespace = "quickshell:regionSelector",
    },
    no_anim = true,
})

hl.layer_rule({
    name = "layerrule-42",
    match = {
        namespace = "quickshell:screenshot",
    },
    no_anim = true,
})

hl.layer_rule({
    name = "layerrule-43",
    match = {
        namespace = "quickshell:session",
    },
    blur = true,
    no_anim = true,
    ignore_alpha = 0,
})

hl.layer_rule({
    name = "layerrule-44",
    match = {
        namespace = "quickshell:sidebarRight",
    },
    animation = "slide right",
})

hl.layer_rule({
    name = "layerrule-45",
    match = {
        namespace = "quickshell:sidebarLeft",
    },
    animation = "slide left",
})

hl.layer_rule({
    name = "layerrule-46",
    match = {
        namespace = "quickshell:verticalBar",
    },
    animation = "slide",
})

hl.layer_rule({
    name = "layerrule-47",
    match = {
        namespace = "quickshell:wallpaperSelector",
    },
    animation = "slide top",
})

hl.layer_rule({
    name = "layerrule-48",
    match = {
        namespace = "quickshell:wNotificationCenter",
    },
    no_anim = true,
})

hl.layer_rule({
    name = "layerrule-49",
    match = {
        namespace = "quickshell:wOnScreenDisplay",
    },
    no_anim = true,
})

hl.layer_rule({
    name = "layerrule-50",
    match = {
        namespace = "quickshell:wStartMenu",
    },
    no_anim = true,
})

-- Launchers need to be FAST
hl.layer_rule({
    name = "layerrule-51",
    match = {
        namespace = "gtk4-layer-shell",
    },
    no_anim = true,
})

