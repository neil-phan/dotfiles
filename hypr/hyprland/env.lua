local home = os.getenv("HOME")

hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")

hl.env("XDG_DATA_DIRS", home .. "/.local/share/flatpak/exports/share:/var/lib/flatpak/exports/share:/usr/local/share:/usr/share")

hl.env("QT_QPA_PLATFORM", "wayland")
hl.env("QT_QPA_PLATFORMTHEME", "kde")
hl.env("XDG_MENU_PREFIX", "plasma-")

hl.env("FLOATING_GARDEN_VIRTUAL_ENV", home .. "/.local/state/quickshell/.venv")

hl.env("TERMINAL", "ghostty")
