#!/usr/bin/env bash
set -euo pipefail

SCALE_A="1"
SCALE_B="1.5"
CONF="${HOME}/.config/hypr/monitors.conf"

python - <<'PY'
import json
import os
import subprocess
from pathlib import Path

scale_a = float(os.environ.get("SCALE_A", "1"))
scale_b = float(os.environ.get("SCALE_B", "1.5"))
conf_path = Path(os.environ.get("CONF", ""))

try:
    data = json.loads(subprocess.check_output(["hyprctl", "-j", "monitors"]))
except Exception as exc:
    raise SystemExit(f"failed to read monitors from hyprctl: {exc}")

if not data:
    raise SystemExit("no monitors reported by hyprctl")

m = next((x for x in data if x.get("focused")), None) or data[0]
monitor = m.get("name")
if not monitor:
    raise SystemExit("monitor name missing from hyprctl")

cur_scale = float(m.get("scale", scale_b))
threshold = (scale_a + scale_b) / 2.0
new_scale = scale_a if cur_scale >= threshold else scale_b

width = m.get("width")
height = m.get("height")
refresh = m.get("refreshRate") or m.get("refreshRateHz") or m.get("refresh")
if width is None or height is None or refresh is None:
    raise SystemExit("missing width/height/refresh from hyprctl monitor data")

x = m.get("x", 0)
y = m.get("y", 0)

rate = ("{:.2f}".format(float(refresh))).rstrip("0").rstrip(".")

subprocess.check_call([
    "hyprctl",
    "keyword",
    "monitor",
    f"{monitor},{width}x{height}@{rate},{x}x{y},{new_scale}",
])

if conf_path.exists():
    text = conf_path.read_text()
    lines = text.splitlines()
    out = []
    updated = False
    for line in lines:
        if line.strip().startswith(f"monitor={monitor},"):
            before, *comment = line.split("#", 1)
            parts = before.split(",")
            if len(parts) >= 4:
                parts[3] = str(new_scale)
            else:
                while len(parts) < 3:
                    parts.append("")
                parts.append(str(new_scale))
            line = ",".join(parts)
            if comment:
                line += "#" + comment[0]
            updated = True
        out.append(line)
    if updated:
        conf_path.write_text("\n".join(out) + "\n")

# Swap toolkit scaling env vars so they don't compound with compositor scale
if new_scale == scale_b:
    # Going to 1.5x compositor — toolkit should be 1x
    qt_scale, cursor_size = "1", "24"
else:
    # Going to 1.0x compositor — toolkit should be 1.5x
    qt_scale, cursor_size = "1.5", "36"

for var, val in [("QT_SCALE_FACTOR", qt_scale), ("XCURSOR_SIZE", cursor_size)]:
    subprocess.run(["hyprctl", "keyword", "env", f"{var},{val}"])

subprocess.run(["hyprctl", "setcursor", "Bibata-Modern-Classic", cursor_size])

try:
    subprocess.run(["notify-send", "Hyprland", f"{monitor} scale set to {new_scale}"])
except Exception:
    pass
PY

# Restart Quickshell to pick up new QT_SCALE_FACTOR
qsConfig="${XDG_CONFIG_HOME:-$HOME/.config}/quickshell/floatg/shell.qml"
if command -v qs &>/dev/null && [[ -f "$qsConfig" ]]; then
    pkill -f "qs.*$qsConfig" 2>/dev/null || true
    qs -c "$qsConfig" &
    disown
fi
