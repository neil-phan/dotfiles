local function group_workspace(n)
    local ws = hl.get_active_workspace()
    local current = ws and ws.id or 1
    return math.floor((current - 1) / 10) * 10 + n
end

local function focus_workspace(n)
    return function() hl.dispatch(hl.dsp.focus({ workspace = group_workspace(n) })) end
end

local function send_to_workspace(n)
    return function() hl.dispatch(hl.dsp.window.move({ workspace = group_workspace(n), follow = false })) end
end

local function bind(keys, action, opts)
    hl.bind(keys, action, opts)
    if keys:find("SUPER", 1, true) and not keys:find("Super_", 1, true) and not keys:find("mouse", 1, true) then
        hl.bind(keys, hl.dsp.global("quickshell:searchToggleReleaseInterrupt"), { non_consuming = true })
    end
end

hl.define_submap("global", function()
    -- Lines ending with `# [hidden]` won't be shown on cheatsheet
    -- Lines starting with #! are section headings

    --!
    --#! Shell
    -- These absolutely need to be on top, or they won't work consistently

    bind("catchall", hl.dsp.global("quickshell:searchToggleReleaseInterrupt"), { non_consuming = true, transparent = true, ignore_mods = true })
    bind("SUPER + Super_L", hl.dsp.global("quickshell:searchToggleRelease"), { ignore_mods = true, description = "Toggle search" })
    bind("SUPER + Super_R", hl.dsp.global("quickshell:searchToggleRelease"), { ignore_mods = true, description = "Toggle search" })
    bind("SUPER + Super_L", hl.dsp.exec_cmd("qs -c $qsConfig ipc call TEST_ALIVE || pkill fuzzel || fuzzel"))
    bind("SUPER + Super_R", hl.dsp.exec_cmd("qs -c $qsConfig ipc call TEST_ALIVE || pkill fuzzel || fuzzel"))
    bind("CTRL + Super_L", hl.dsp.global("quickshell:searchToggleReleaseInterrupt"))
    bind("CTRL + Super_R", hl.dsp.global("quickshell:searchToggleReleaseInterrupt"))
    bind("SUPER + mouse:272", hl.dsp.global("quickshell:searchToggleReleaseInterrupt"))
    bind("SUPER + mouse:273", hl.dsp.global("quickshell:searchToggleReleaseInterrupt"))
    bind("SUPER + mouse:274", hl.dsp.global("quickshell:searchToggleReleaseInterrupt"))
    bind("SUPER + mouse:275", hl.dsp.global("quickshell:searchToggleReleaseInterrupt"))
    bind("SUPER + mouse:276", hl.dsp.global("quickshell:searchToggleReleaseInterrupt"))
    bind("SUPER + mouse:277", hl.dsp.global("quickshell:searchToggleReleaseInterrupt"))
    bind("SUPER + mouse_up", hl.dsp.global("quickshell:searchToggleReleaseInterrupt"))
    bind("SUPER + mouse_down", hl.dsp.global("quickshell:searchToggleReleaseInterrupt"))

    bind("Super_L", hl.dsp.global("quickshell:workspaceNumber"), { transparent = true, ignore_mods = true })
    bind("Super_R", hl.dsp.global("quickshell:workspaceNumber"), { transparent = true, ignore_mods = true })
    bind("SUPER + Tab", hl.dsp.global("quickshell:overviewWorkspacesToggle"))
    bind("SUPER + V", hl.dsp.global("quickshell:overviewClipboardToggle"), { description = "Clipboard history >> clipboard" })
    bind("SUPER + A", hl.dsp.global("quickshell:sidebarRightToggle"), { description = "Toggle right sidebar" })
    bind("SUPER + Slash", hl.dsp.global("quickshell:cheatsheetToggle"), { description = "Toggle cheatsheet" })
    bind("SUPER + K", hl.dsp.global("quickshell:oskToggle"), { description = "Toggle on-screen keyboard" })
    bind("SUPER + M", hl.dsp.global("quickshell:mediaControlsToggle"), { description = "Toggle media controls" })
    bind("SUPER + Z", hl.dsp.global("quickshell:overlayToggle"))
    bind("CTRL + ALT + Delete", hl.dsp.global("quickshell:sessionToggle"), { description = "Toggle session menu" })
    bind("SUPER + J", hl.dsp.global("quickshell:barToggle"), { description = "Toggle bar" })
    bind("SHIFT + SUPER + ALT + Slash", hl.dsp.exec_cmd("qs -p ~/.config/quickshell/$qsConfig/welcome.qml"))

    bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("qs -c $qsConfig ipc call brightness increment || brightnessctl s 5%+"), { locked = true, repeating = true })
    bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("qs -c $qsConfig ipc call brightness decrement || brightnessctl s 5%-"), { locked = true, repeating = true })
    bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%+ -l 1.5"), { locked = true, repeating = true })
    bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%-"), { locked = true, repeating = true })

    bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_SINK@ toggle"), { locked = true })
    bind("SUPER + SHIFT + M", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_SINK@ toggle"), { locked = true, description = "Toggle mute" })
    bind("ALT + XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_SOURCE@ toggle"), { locked = true })
    bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_SOURCE@ toggle"), { locked = true })
    bind("SUPER + ALT + M", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_SOURCE@ toggle"), { locked = true, description = "Toggle mic" })
    bind("SUPER + SHIFT + A", hl.dsp.exec_cmd("qs -c $qsConfig ipc call audio cycleSink"), { description = "Cycle audio output" })
    bind("CTRL + SUPER + T", hl.dsp.global("quickshell:wallpaperSelectorToggle"), { description = "Toggle wallpaper selector" })
    bind("CTRL + SUPER + ALT + T", hl.dsp.global("quickshell:wallpaperSelectorRandom"), { description = "Select random wallpaper" })
    bind("CTRL + SUPER + T", hl.dsp.exec_cmd("qs -c $qsConfig ipc call TEST_ALIVE || ~/.config/quickshell/$qsConfig/scripts/colors/switchwall.sh"), { description = "Change wallpaper" })
    bind("CTRL + SUPER + R", hl.dsp.exec_cmd("killall ags agsv1 gjs ydotool qs quickshell; qs -c $qsConfig &"))

    --#! Utilities
    -- Screenshot, Record, OCR, Color picker, Clipboard history
    bind("SUPER + V", hl.dsp.exec_cmd("qs -c $qsConfig ipc call TEST_ALIVE || pkill fuzzel || cliphist list | fuzzel --match-mode fzf --dmenu | cliphist decode | wl-copy"), { description = "Copy clipboard history entry" })
    bind("SUPER + SHIFT + S", hl.dsp.global("quickshell:regionScreenshot"))
    bind("SUPER + SHIFT + S", hl.dsp.exec_cmd("qs -c $qsConfig ipc call TEST_ALIVE || ~/.config/hypr/hyprland/scripts/snip_imagemagick.sh"))
    -- OCR
    bind("SUPER + SHIFT + X", hl.dsp.global("quickshell:regionOcr"))
    bind("SUPER + SHIFT + T", hl.dsp.global("quickshell:regionOcr"))
    bind("SUPER + SHIFT + X", hl.dsp.exec_cmd("qs -c $qsConfig ipc call TEST_ALIVE || pidof slurp || grim -g \"$(slurp $SLURP_ARGS)\" \"/tmp/ocr_image.png\" && tesseract \"/tmp/ocr_image.png\" stdout -l $(tesseract --list-langs | awk 'NR>1{print $1}' | tr '\\\\n' '+' | sed 's/\\\\+$/\\\\n/') | wl-copy && rm \"/tmp/ocr_image.png\""))
    bind("SUPER + SHIFT + T", hl.dsp.exec_cmd("qs -c $qsConfig ipc call TEST_ALIVE || pidof slurp || grim -g \"$(slurp $SLURP_ARGS)\" \"/tmp/ocr_image.png\" && tesseract \"/tmp/ocr_image.png\" stdout -l $(tesseract --list-langs | awk 'NR>1{print $1}' | tr '\\\\n' '+' | sed 's/\\\\+$/\\\\n/') | wl-copy && rm \"/tmp/ocr_image.png\""))
    -- Color picker
    bind("SUPER + SHIFT + C", hl.dsp.exec_cmd("hyprpicker -a"), { description = "Color picker" })
    -- Fullscreen screenshot
    bind("Print", hl.dsp.exec_cmd("grim - | wl-copy"), { locked = true })
    bind("CTRL + Print", hl.dsp.exec_cmd("mkdir -p $(xdg-user-dir PICTURES)/Screenshots && grim $(xdg-user-dir PICTURES)/Screenshots/Screenshot_\"$(date '+%Y-%m-%d_%H.%M.%S')\".png"), { locked = true, non_consuming = true })
    bind("CTRL + Print", hl.dsp.exec_cmd("grim - | wl-copy"), { locked = true, non_consuming = true })
    -- Recording stuff
    bind("SUPER + SHIFT + R", hl.dsp.global("quickshell:regionRecord"), { locked = true })
    bind("SUPER + SHIFT + R", hl.dsp.exec_cmd("qs -c $qsConfig ipc call TEST_ALIVE || ~/.config/quickshell/$qsConfig/scripts/videos/record.sh"), { locked = true })
    bind("SUPER + ALT + R", hl.dsp.global("quickshell:regionRecord"), { locked = true })
    bind("SUPER + ALT + R", hl.dsp.exec_cmd("qs -c $qsConfig ipc call TEST_ALIVE || ~/.config/quickshell/$qsConfig/scripts/videos/record.sh"), { locked = true })
    bind("CTRL + ALT + R", hl.dsp.exec_cmd("~/.config/quickshell/$qsConfig/scripts/videos/record.sh --fullscreen"), { locked = true })
    bind("SUPER + SHIFT + ALT + R", hl.dsp.exec_cmd("~/.config/quickshell/$qsConfig/scripts/videos/record.sh --fullscreen --sound"), { locked = true })
    -- AI
    bind("SUPER + SHIFT + ALT + mouse:273", hl.dsp.exec_cmd("~/.config/hypr/hyprland/scripts/ai/primary-buffer-query.sh"), { description = "Generate AI summary for selected text" })

    --!
    --#! Window
    -- Focusing
    bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true })
    bind("SUPER + mouse:274", hl.dsp.window.drag(), { mouse = true })
    bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })
    --/# bind = Super, ←/↑/→/↓,, # Focus in direction
    bind("SUPER + Left", hl.dsp.focus({ direction = "left" }))
    bind("SUPER + Right", hl.dsp.focus({ direction = "right" }))
    bind("SUPER + Up", hl.dsp.focus({ direction = "up" }))
    bind("SUPER + Down", hl.dsp.focus({ direction = "down" }))
    bind("SUPER + BracketLeft", hl.dsp.focus({ direction = "left" }))
    bind("SUPER + BracketRight", hl.dsp.focus({ direction = "right" }))
    --/# bind = Super+Shift, ←/↑/→/↓,, # Move in direction
    bind("SUPER + SHIFT + Left", hl.dsp.window.move({ direction = "l" }))
    bind("SUPER + SHIFT + Right", hl.dsp.window.move({ direction = "r" }))
    bind("SUPER + SHIFT + Up", hl.dsp.window.move({ direction = "u" }))
    bind("SUPER + SHIFT + Down", hl.dsp.window.move({ direction = "d" }))
    bind("ALT + F4", hl.dsp.window.close())
    bind("SUPER + Q", hl.dsp.window.close())
    bind("SUPER + SHIFT + ALT + Q", hl.dsp.exec_cmd("hyprctl kill"))

    -- Window split ratio
    --/# binde = Super, ;/',, # Adjust split ratio
    bind("SUPER + Semicolon", hl.dsp.layout("splitratio -0.1"), { repeating = true })
    bind("SUPER + Apostrophe", hl.dsp.layout("splitratio +0.1"), { repeating = true })
    -- Positioning mode
    bind("SUPER + ALT + Space", hl.dsp.window.float({ action = "toggle" }))
    bind("SUPER + D", hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }))
    bind("SUPER + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))
    bind("SUPER + ALT + F", hl.dsp.window.fullscreen_state({ internal = 0, client = 3, action = "toggle" }))
    bind("SUPER + P", hl.dsp.window.pin())

    --/# bind = Super+Alt, Hash,, # Send to workspace # (1, 2, 3,...)
    -- We use raw keycodes because some keyboard layouts register number keys as different chars. The codes can be verified with `wev`
    bind("SUPER + ALT + code:10", send_to_workspace(1))
    bind("SUPER + ALT + code:11", send_to_workspace(2))
    bind("SUPER + ALT + code:12", send_to_workspace(3))
    bind("SUPER + ALT + code:13", send_to_workspace(4))
    bind("SUPER + ALT + code:14", send_to_workspace(5))
    bind("SUPER + ALT + code:15", send_to_workspace(6))
    bind("SUPER + ALT + code:16", send_to_workspace(7))
    bind("SUPER + ALT + code:17", send_to_workspace(8))
    bind("SUPER + ALT + code:18", send_to_workspace(9))
    bind("SUPER + ALT + code:19", send_to_workspace(10))
    -- keypad numbers
    bind("SUPER + ALT + code:87", send_to_workspace(1))
    bind("SUPER + ALT + code:88", send_to_workspace(2))
    bind("SUPER + ALT + code:89", send_to_workspace(3))
    bind("SUPER + ALT + code:83", send_to_workspace(4))
    bind("SUPER + ALT + code:84", send_to_workspace(5))
    bind("SUPER + ALT + code:85", send_to_workspace(6))
    bind("SUPER + ALT + code:79", send_to_workspace(7))
    bind("SUPER + ALT + code:80", send_to_workspace(8))
    bind("SUPER + ALT + code:81", send_to_workspace(9))
    bind("SUPER + ALT + code:90", send_to_workspace(10))

    -- #/# bind = Super+Shift, Scroll ↑/↓,, # Send to workspace left/right
    bind("SUPER + SHIFT + mouse_down", hl.dsp.window.move({ workspace = "r-1" }))
    bind("SUPER + SHIFT + mouse_up", hl.dsp.window.move({ workspace = "r+1" }))
    bind("SUPER + ALT + mouse_down", hl.dsp.window.move({ workspace = "-1" }))
    bind("SUPER + ALT + mouse_up", hl.dsp.window.move({ workspace = "+1" }))

    --/# bind = Super+Shift, Page_↑/↓,, # Send to workspace left/right
    bind("SUPER + ALT + Page_Down", hl.dsp.window.move({ workspace = "+1" }))
    bind("SUPER + ALT + Page_Up", hl.dsp.window.move({ workspace = "-1" }))
    bind("SUPER + SHIFT + Page_Down", hl.dsp.window.move({ workspace = "r+1" }))
    bind("SUPER + SHIFT + Page_Up", hl.dsp.window.move({ workspace = "r-1" }))
    bind("CTRL + SUPER + SHIFT + Right", hl.dsp.window.move({ workspace = "r+1" }))
    bind("CTRL + SUPER + SHIFT + Left", hl.dsp.window.move({ workspace = "r-1" }))

    bind("CTRL + SUPER + S", hl.dsp.workspace.toggle_special("special"))

    --#! Workspace
    -- Switching
    --/# bind = Super, Hash,, # Focus workspace # (1, 2, 3,...)
    -- We use raw keycodes because some keyboard layouts register number keys as different chars. The codes can be verified with `wev`
    bind("SUPER + code:10", focus_workspace(1))
    bind("SUPER + code:11", focus_workspace(2))
    bind("SUPER + code:12", focus_workspace(3))
    bind("SUPER + code:13", focus_workspace(4))
    bind("SUPER + code:14", focus_workspace(5))
    bind("SUPER + code:15", focus_workspace(6))
    bind("SUPER + code:16", focus_workspace(7))
    bind("SUPER + code:17", focus_workspace(8))
    bind("SUPER + code:18", focus_workspace(9))
    bind("SUPER + code:19", focus_workspace(10))
    -- keypad numbers
    bind("SUPER + code:87", focus_workspace(1), { dont_inhibit = true })
    bind("SUPER + code:88", focus_workspace(2), { dont_inhibit = true })
    bind("SUPER + code:89", focus_workspace(3), { dont_inhibit = true })
    bind("SUPER + code:83", focus_workspace(4), { dont_inhibit = true })
    bind("SUPER + code:84", focus_workspace(5), { dont_inhibit = true })
    bind("SUPER + code:85", focus_workspace(6), { dont_inhibit = true })
    bind("SUPER + code:79", focus_workspace(7), { dont_inhibit = true })
    bind("SUPER + code:80", focus_workspace(8), { dont_inhibit = true })
    bind("SUPER + code:81", focus_workspace(9), { dont_inhibit = true })
    bind("SUPER + code:90", focus_workspace(10), { dont_inhibit = true })

    --/# bind = Ctrl+Super, ←/→,, # Focus left/right
    bind("CTRL + SUPER + Right", hl.dsp.focus({ workspace = "r+1" }))
    bind("CTRL + SUPER + Left", hl.dsp.focus({ workspace = "r-1" }))
    --/# bind = Ctrl+Super+Alt, ←/→,, # [hidden] Focus busy left/right
    bind("CTRL + SUPER + ALT + Right", hl.dsp.focus({ workspace = "m+1" }))
    bind("CTRL + SUPER + ALT + Left", hl.dsp.focus({ workspace = "m-1" }))
    --/# bind = Super, Page_↑/↓,, # Focus left/right
    bind("SUPER + Page_Down", hl.dsp.focus({ workspace = "+1" }))
    bind("SUPER + Page_Up", hl.dsp.focus({ workspace = "-1" }))
    bind("CTRL + SUPER + Page_Down", hl.dsp.focus({ workspace = "r+1" }))
    bind("CTRL + SUPER + Page_Up", hl.dsp.focus({ workspace = "r-1" }))
    --/# bind = Super, Scroll ↑/↓,, # Focus left/right
    bind("SUPER + mouse_up", hl.dsp.focus({ workspace = "+1" }))
    bind("SUPER + mouse_down", hl.dsp.focus({ workspace = "-1" }))
    bind("CTRL + SUPER + mouse_up", hl.dsp.focus({ workspace = "r+1" }))
    bind("CTRL + SUPER + mouse_down", hl.dsp.focus({ workspace = "r-1" }))
    --# Special
     -- bind = Super, S, togglespecialworkspace, # Toggle scratchpad
    bind("SUPER + mouse:275", hl.dsp.workspace.toggle_special("special"))
    bind("CTRL + SUPER + BracketLeft", hl.dsp.focus({ workspace = "-1" }))
    bind("CTRL + SUPER + BracketRight", hl.dsp.focus({ workspace = "+1" }))
    bind("CTRL + SUPER + Up", hl.dsp.focus({ workspace = "r-5" }))
    bind("CTRL + SUPER + Down", hl.dsp.focus({ workspace = "r+5" }))

    --#! Virtual machines
    bind("SUPER + ALT + F1", function()
        hl.exec_cmd("notify-send 'Entered Virtual Machine submap' 'Keybinds disabled. Hit Super+Alt+F1 to escape' -a 'Hyprland'")
        hl.dispatch(hl.dsp.submap("virtual-machine"))
    end)


    --!
    -- Testing
    bind("SUPER + ALT + f11", hl.dsp.exec_cmd("bash -c 'RANDOM_IMAGE=$(find ~/Pictures -type f | grep -v -i \"nipple\" | grep -v -i \"pussy\" | shuf -n 1); ACTION=$(notify-send \"Test notification with body image\" \"This notification should contain your user account <b>image</b> and <a href=\\\"https://discord.com/app\\\">Discord</a> <b>icon</b>. Oh and here is a random image in your Pictures folder: <img src=\\\"$RANDOM_IMAGE\\\" alt=\\\"Testing image\\\"/>\" -a \"Hyprland keybind\" -p -h \"string:image-path:/var/lib/AccountsService/icons/$USER\" -t 6000 -i \"discord\" -A \"openImage=Profile image\" -A \"action2=Open the random image\" -A \"action3=Useless button\"); [[ $ACTION == *openImage ]] && xdg-open \"/var/lib/AccountsService/icons/$USER\"; [[ $ACTION == *action2 ]] && xdg-open \\\"$RANDOM_IMAGE\\\"'"))
    bind("SUPER + ALT + f12", hl.dsp.exec_cmd("bash -c 'RANDOM_IMAGE=$(find ~/Pictures -type f | grep -v -i \"nipple\" | grep -v -i \"pussy\" | shuf -n 1); ACTION=$(notify-send \"Test notification\" \"This notification should contain a random image in your <b>Pictures</b> folder and <a href=\\\"https://discord.com/app\\\">Discord</a> <b>icon</b>.\\n<i>Flick right to dismiss!</i>\" -a \"Discord (fake)\" -p -h \"string:image-path:$RANDOM_IMAGE\" -t 6000 -i \"discord\" -A \"openImage=Profile image\" -A \"action2=Useless button\"); [[ $ACTION == *openImage ]] && xdg-open \"/var/lib/AccountsService/icons/$USER\"'"))
    bind("SUPER + ALT + Equal", hl.dsp.exec_cmd("notify-send \"Urgent notification\" \"Ah hell no\" -u critical -a 'Hyprland keybind'"))

    --#! Session
    bind("SUPER + L", hl.dsp.exec_cmd("loginctl lock-session"), { description = "Lock" })
    bind("SUPER + SHIFT + L", hl.dsp.exec_cmd("systemctl suspend || loginctl suspend"), { locked = true, description = "Suspend system" })
    -- bindl=,switch:on:Lid Switch, exec, systemctl suspend || loginctl suspend # [hidden] Suspend when laptop lid is closed, uncomment if for whatever reason it's not the default behavior
    bind("CTRL + SHIFT + ALT + SUPER + Delete", hl.dsp.exec_cmd("systemctl poweroff || loginctl poweroff"), { description = "Shutdown" })

    --#! Screen
    -- Zoom
    bind("SUPER + Minus", hl.dsp.exec_cmd("qs -c $qsConfig ipc call zoom zoomOut"), { repeating = true })
    bind("SUPER + Equal", hl.dsp.exec_cmd("qs -c $qsConfig ipc call zoom zoomIn"), { repeating = true })
    bind("SUPER + Minus", hl.dsp.exec_cmd("qs -c $qsConfig ipc call TEST_ALIVE || ~/.config/hypr/hyprland/scripts/zoom.sh decrease 0.1"), { repeating = true })
    bind("SUPER + Equal", hl.dsp.exec_cmd("qs -c $qsConfig ipc call TEST_ALIVE || ~/.config/hypr/hyprland/scripts/zoom.sh increase 0.1"), { repeating = true })
    -- Zoom with keypad
    bind("SUPER + code:82", hl.dsp.exec_cmd("qs -c $qsConfig ipc call zoom zoomOut"), { repeating = true })
    bind("SUPER + code:86", hl.dsp.exec_cmd("qs -c $qsConfig ipc call zoom zoomIn"), { repeating = true })
    bind("SUPER + code:82", hl.dsp.exec_cmd("qs -c $qsConfig ipc call TEST_ALIVE || ~/.config/hypr/hyprland/scripts/zoom.sh decrease 0.1"), { repeating = true })
    bind("SUPER + code:86", hl.dsp.exec_cmd("qs -c $qsConfig ipc call TEST_ALIVE || ~/.config/hypr/hyprland/scripts/zoom.sh increase 0.1"), { repeating = true })

    --#! Media
    bind("SUPER + SHIFT + N", hl.dsp.exec_cmd("playerctl next || playerctl position `bc <<< \"100 * $(playerctl metadata mpris:length) / 1000000 / 100\"`"), { locked = true })
    bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next || playerctl position `bc <<< \"100 * $(playerctl metadata mpris:length) / 1000000 / 100\"`"), { locked = true })
    bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
    bind("SUPER + SHIFT + ALT + mouse:275", hl.dsp.exec_cmd("playerctl previous"))
    bind("SUPER + SHIFT + ALT + mouse:276", hl.dsp.exec_cmd("playerctl next || playerctl position `bc <<< \"100 * $(playerctl metadata mpris:length) / 1000000 / 100\"`"))
    bind("SUPER + SHIFT + B", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
    bind("SUPER + SHIFT + P", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
    bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
    bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })

    --#! Apps
    bind("SUPER + Return", hl.dsp.exec_cmd("~/.config/hypr/hyprland/scripts/launch_first_available.sh \"${TERMINAL}\" \"ghostty\" \"alacritty\" \"wezterm\" \"konsole\" \"kgx\" \"uxterm\" \"xterm\""))
    bind("SUPER + T", hl.dsp.exec_cmd("~/.config/hypr/hyprland/scripts/launch_first_available.sh  \"${TERMINAL}\" \"ghostty\" \"alacritty\" \"wezterm\" \"konsole\" \"kgx\" \"uxterm\" \"xterm\""))
    bind("CTRL + ALT + T", hl.dsp.exec_cmd("~/.config/hypr/hyprland/scripts/launch_first_available.sh \"${TERMINAL}\" \"ghostty\" \"alacritty\" \"wezterm\" \"konsole\" \"kgx\" \"uxterm\" \"xterm\""))
    bind("SUPER + E", hl.dsp.exec_cmd("~/.config/hypr/hyprland/scripts/launch_first_available.sh \"dolphin\" \"nautilus\" \"nemo\" \"thunar\" \"${TERMINAL}\" \"ghostty -e fish -c yazi\""))
    bind("SUPER + W", hl.dsp.exec_cmd("~/.config/hypr/hyprland/scripts/launch_first_available.sh \"firefox\" \"google-chrome-stable\" \"zen-browser\"  \"brave\" \"chromium\" \"microsoft-edge-stable\" \"opera\" \"librewolf\""))
    bind("SUPER + C", hl.dsp.exec_cmd("ghostty -e nvim"))
    bind("SUPER + X", hl.dsp.exec_cmd("obsidian"))
    bind("SUPER + I", hl.dsp.exec_cmd("XDG_CURRENT_DESKTOP=gnome ~/.config/hypr/hyprland/scripts/launch_first_available.sh \"qs -p ~/.config/quickshell/$qsConfig/settings.qml\" \"systemsettings\" \"gnome-control-center\" \"better-control\""))

    -- Cursed stuff
    --# Make window not amogus large
    bind("CTRL + SUPER + Backslash", hl.dsp.window.resize({ x = 640, y = 480 }))
end)

hl.define_submap("virtual-machine", function()
    hl.bind("SUPER + ALT + F1", function()
        hl.exec_cmd("notify-send 'Exited Virtual Machine submap' 'Keybinds re-enabled' -a 'Hyprland'")
        hl.dispatch(hl.dsp.submap("global"))
    end)
end)
