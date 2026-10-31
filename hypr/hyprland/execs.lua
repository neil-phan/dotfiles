hl.on("hyprland.start", function()
    hl.exec_cmd("qs -c $qsConfig")
    hl.exec_cmd("bash -c '[ -f ~/.config/hypr/custom/scripts/__restore_video_wallpaper.sh ] && ~/.config/hypr/custom/scripts/__restore_video_wallpaper.sh'")
    hl.exec_cmd("hyprsunset --identity")

    hl.exec_cmd("gnome-keyring-daemon --start --components=secrets")
    hl.exec_cmd("hypridle")
    hl.exec_cmd("dbus-update-activation-environment --all")
    hl.exec_cmd("sleep 1 && dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")

    hl.exec_cmd("easyeffects --hide-window --service-mode")

    hl.exec_cmd("~/.config/hypr/hyprland/scripts/battery-profile.fish watch")

    hl.exec_cmd("wl-paste --type text --watch bash -c 'cliphist store && qs -c $qsConfig ipc call cliphistService update'")
    hl.exec_cmd("wl-paste --type image --watch bash -c 'cliphist store && qs -c $qsConfig ipc call cliphistService update'")

    hl.exec_cmd("hyprctl setcursor Bibata-Modern-Classic 36")
    hl.exec_cmd("echo 'Xft.dpi: 144' | xrdb -merge")
end)
