pragma ComponentBehavior: Bound
import qs
import qs.services
import qs.modules.common
import qs.modules.common.functions
import qs.modules.common.panels.lock
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Hyprland

LockScreen {
    id: root

    lockSurface: LockSurface {
        context: root.context
    }

    // Push everything down
    property var windowData: []
    function saveWindowPositionAndTile() {
        root.windowData = HyprlandData.windowList.filter(w => (w.floating && w.workspace.id === HyprlandData.activeWorkspace.id));
        root.windowData.forEach(w => {
            Hyprland.dispatch(`hl.dsp.window.pseudo({ window = "address:${w.address}" })`);
            Hyprland.dispatch(`hl.dsp.window.float({ action = "disable", window = "address:${w.address}" })`);
            Hyprland.dispatch(`hl.dsp.window.move({ workspace = ${w.workspace.id}, follow = false, window = "address:${w.address}" })`);
        });
    }
    function restoreWindowPositionAndTile() {
        root.windowData.forEach(w => {
            Hyprland.dispatch(`hl.dsp.window.float({ action = "enable", window = "address:${w.address}" })`);
            Hyprland.dispatch(`hl.dsp.window.move({ x = ${w.at[0]}, y = ${w.at[1]}, window = "address:${w.address}" })`);
            Hyprland.dispatch(`hl.dsp.window.pseudo({ window = "address:${w.address}" })`);
        });
    }
    Variants {
        model: Quickshell.screens
        delegate: Scope {
            required property ShellScreen modelData
            property bool shouldPush: GlobalStates.screenLocked
            onShouldPushChanged: {
                if (shouldPush) {
                    root.saveWindowPositionAndTile();
                } else {
                    root.restoreWindowPositionAndTile();
                }
            }
        }
    }
}
