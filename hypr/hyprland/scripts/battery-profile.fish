#!/usr/bin/env fish

function is_on_ac
    for d in /sys/class/power_supply/*
        set -l name (basename $d)
        if string match -qr '^(AC|ADP)' $name
            set -l f $d/online
            if test -f $f; and test (cat $f) = "1"
                return 0
            end
        end
    end
    return 1
end

function apply_battery
    hyprctl eval 'hl.config({ decoration = { blur = { passes = 1, size = 8 }, shadow = { enabled = false }, dim_inactive = false } })' >/dev/null
end

function apply_ac
    hyprctl eval 'hl.config({ decoration = { blur = { passes = 3, size = 15 }, shadow = { enabled = true }, dim_inactive = true } })' >/dev/null
end

function apply
    if is_on_ac
        apply_ac
    else
        apply_battery
    end
end

set -l mode $argv[1]
test -z "$mode"; and set mode apply

switch $mode
    case apply
        apply
    case watch
        apply
        udevadm monitor --subsystem-match=power_supply --udev 2>/dev/null | while read -l line
            sleep 0.3
            apply
        end
    case '*'
        echo "Usage: "(status filename)" {apply|watch}" >&2
        exit 1
end
