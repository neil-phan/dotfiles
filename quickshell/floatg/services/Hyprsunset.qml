pragma Singleton

import QtQuick
import qs.modules.common
import Quickshell
import Quickshell.Io

/**
 * Hyprsunset nightlight service with automatic scheduling and manual toggle.
 * Controls the hyprsunset daemon via hyprctl commands (daemon started at boot with --identity).
 */
Singleton {
    id: root
    property string from: Config.options?.light?.night?.from ?? "19:00" 
    property string to: Config.options?.light?.night?.to ?? "06:30"
    property bool automatic: Config.options?.light?.night?.automatic && (Config?.ready ?? true)
    property int colorTemperature: Config.options?.light?.night?.colorTemperature ?? 5000
    property bool shouldBeOn
    property bool firstEvaluation: true
    property bool active: false

    property int fromHour: Number(from.split(":")[0])
    property int fromMinute: Number(from.split(":")[1])
    property int toHour: Number(to.split(":")[0])
    property int toMinute: Number(to.split(":")[1])

    property int clockHour: DateTime.clock.hours
    property int clockMinute: DateTime.clock.minutes

    property var manualActive
    property int manualActiveHour
    property int manualActiveMinute

    onClockMinuteChanged: reEvaluate()
    onAutomaticChanged: {
        root.manualActive = undefined;
        root.firstEvaluation = true;
        reEvaluate();
    }

    function inBetween(t, from, to) {
        if (from < to) {
            return (t >= from && t <= to);
        } else {
            // Wrapped around midnight
            return (t >= from || t <= to);
        }
    }

    function reEvaluate() {
        const t = clockHour * 60 + clockMinute;
        const from = fromHour * 60 + fromMinute;
        const to = toHour * 60 + toMinute;
        const manualActive = manualActiveHour * 60 + manualActiveMinute;

        if (root.manualActive !== undefined && (inBetween(from, manualActive, t) || inBetween(to, manualActive, t))) {
            root.manualActive = undefined;
        }
        root.shouldBeOn = inBetween(t, from, to);
        firstEvaluation = false;
        root.ensureState();
    }

    onShouldBeOnChanged: ensureState()
    function ensureState() {
        if (!root.automatic || root.manualActive !== undefined)
            return;
        if (root.shouldBeOn) {
            root.enable();
        } else {
            root.disable();
        }
    }

    function load() { } // Dummy to force init

    function enable() {
        root.active = true;
        Quickshell.execDetached(["bash", "-c", `hyprctl hyprsunset temperature ${root.colorTemperature} || hyprsunset --temperature ${root.colorTemperature}`]);
    }

    function disable() {
        root.active = false;
        Quickshell.execDetached(["hyprctl", "hyprsunset", "identity"]);
    }

    function fetchState() {
        fetchProc.running = true;
    }

    Process {
        id: fetchProc
        running: true
        command: ["bash", "-c", "hyprctl hyprsunset temperature"]
        stdout: StdioCollector {
            id: stateCollector
            onStreamFinished: {
                const output = stateCollector.text.trim();
                if (output.length == 0 || output.startsWith("Couldn't"))
                    root.active = false;
                else
                    root.active = (output != "6500");
            }
        }
    }

    function toggle(active = undefined) {
        if (root.manualActive === undefined) {
            root.manualActive = root.active;
            root.manualActiveHour = root.clockHour;
            root.manualActiveMinute = root.clockMinute;
        }

        root.manualActive = active !== undefined ? active : !root.manualActive;
        if (root.manualActive) {
            root.enable();
        } else {
            root.disable();
        }
    }

    Connections {
        target: Config.options.light.night
        function onColorTemperatureChanged() {
            if (!root.active) return;
            Quickshell.execDetached(["hyprctl", "hyprsunset", "temperature", `${Config.options.light.night.colorTemperature}`]);
        }
    }

    function reapplyTemperature() {
        const shouldApply = root.manualActive !== undefined ? root.manualActive :
                            root.automatic ? root.shouldBeOn : root.active;
        if (shouldApply) {
            root.active = true;
            Quickshell.execDetached(["hyprctl", "hyprsunset", "temperature", `${root.colorTemperature}`]);
        }
    }

    Timer {
        id: refreshTimer
        interval: 500
        onTriggered: root.reapplyTemperature()
    }

    // Refresh on DPMS wake / unlock - reapply color temperature since display driver resets gamma
    IpcHandler {
        target: "hyprsunset"
        function refresh() { refreshTimer.restart(); }
    }

    Connections {
        target: GlobalStates
        function onScreenLockedChanged() {
            if (!GlobalStates.screenLocked) refreshTimer.restart();
        }
    }
}
