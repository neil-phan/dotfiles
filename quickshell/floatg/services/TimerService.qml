pragma Singleton
pragma ComponentBehavior: Bound

import qs.services
import qs.modules.common

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    property int countdownDuration: Persistent.states.timer.countdown.duration || Config.options.time.countdown.duration
    property bool countdownRunning: Persistent.states.timer.countdown.running
    property int countdownSecondsLeft: countdownDuration

    onCountdownDurationChanged: {
        if (!countdownRunning) {
            countdownSecondsLeft = countdownDuration;
            Persistent.states.timer.countdown.start = getCurrentTimeInSeconds();
        }
    }

    property bool stopwatchRunning: Persistent.states.timer.stopwatch.running
    property int stopwatchTime: 0
    property int stopwatchStart: Persistent.states.timer.stopwatch.start
    property var stopwatchLaps: Persistent.states.timer.stopwatch.laps

    // General
    Component.onCompleted: {
        if (!stopwatchRunning)
            stopwatchReset();
    }

    function getCurrentTimeInSeconds() {
        return Math.floor(Date.now() / 1000);
    }

    function getCurrentTimeIn10ms() {  // Stopwatch uses 10ms
        return Math.floor(Date.now() / 10);
    }

    function refreshCountdown() {
        const elapsed = getCurrentTimeInSeconds() - Persistent.states.timer.countdown.start;
        countdownSecondsLeft = Math.max(0, countdownDuration - elapsed);
        if (countdownSecondsLeft <= 0) {
            Persistent.states.timer.countdown.running = false;
            Quickshell.execDetached(["notify-send", "Timer", Translation.tr("⏰ Time's up!"), "-a", "Shell"]);
            if (Config.options.sounds.timer) {
                Audio.playSystemSound("alarm-clock-elapsed");
            }
        }
    }

    Timer {
        id: countdownTimer
        interval: 200
        running: root.countdownRunning
        repeat: true
        onTriggered: refreshCountdown()
    }

    function toggleCountdown() {
        if (countdownSecondsLeft <= 0) return;
        Persistent.states.timer.countdown.running = !countdownRunning;
        if (Persistent.states.timer.countdown.running) {
            Persistent.states.timer.countdown.start = getCurrentTimeInSeconds() - (countdownDuration - countdownSecondsLeft);
        }
    }

    function resetCountdown() {
        Persistent.states.timer.countdown.running = false;
        countdownSecondsLeft = countdownDuration;
        Persistent.states.timer.countdown.start = getCurrentTimeInSeconds();
    }

    function adjustCountdownDuration(delta) {
        Persistent.states.timer.countdown.duration = Math.max(60, countdownDuration + delta);
    }

    // Stopwatch
    function refreshStopwatch() {  // Stopwatch stores time in 10ms
        stopwatchTime = getCurrentTimeIn10ms() - stopwatchStart;
    }

    Timer {
        id: stopwatchTimer
        interval: 10
        running: root.stopwatchRunning
        repeat: true
        onTriggered: refreshStopwatch()
    }

    function toggleStopwatch() {
        if (root.stopwatchRunning)
            stopwatchPause();
        else
            stopwatchResume();
    }

    function stopwatchPause() {
        Persistent.states.timer.stopwatch.running = false;
    }

    function stopwatchResume() {
        if (stopwatchTime === 0) Persistent.states.timer.stopwatch.laps = [];
        Persistent.states.timer.stopwatch.running = true;
        Persistent.states.timer.stopwatch.start = getCurrentTimeIn10ms() - stopwatchTime;
    }

    function stopwatchReset() {
        stopwatchTime = 0;
        Persistent.states.timer.stopwatch.laps = [];
        Persistent.states.timer.stopwatch.running = false;
    }

    function stopwatchRecordLap() {
        Persistent.states.timer.stopwatch.laps.push(stopwatchTime);
    }
}
