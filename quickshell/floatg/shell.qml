//@ pragma UseQApplication
//@ pragma Env QS_NO_RELOAD_POPUP=1
//@ pragma Env QT_QUICK_CONTROLS_STYLE=Basic
//@ pragma Env QT_QUICK_FLICKABLE_WHEEL_DECELERATION=10000

// Adjust this to make the shell smaller or larger
//@ pragma Env QT_SCALE_FACTOR=1

import qs.modules.common
import qs.modules.floatg.background
import qs.modules.floatg.bar
import qs.modules.floatg.cheatsheet
import qs.modules.floatg.dock
import qs.modules.floatg.lock
import qs.modules.floatg.mediaControls
import qs.modules.floatg.notificationPopup
import qs.modules.floatg.onScreenDisplay
import qs.modules.floatg.onScreenKeyboard
import qs.modules.floatg.overview
import qs.modules.floatg.polkit
import qs.modules.floatg.regionSelector
import qs.modules.floatg.screenCorners
import qs.modules.floatg.sessionScreen
import qs.modules.floatg.sidebarLeft
import qs.modules.floatg.sidebarRight
import qs.modules.floatg.overlay
import qs.modules.floatg.verticalBar
import qs.modules.floatg.wallpaperSelector

import QtQuick
import QtQuick.Window
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import qs.services

ShellRoot {
    id: root

    // Force initialization of some singletons
    Component.onCompleted: {
        MaterialThemeLoader.reapplyTheme()
        Hyprsunset.load()
        ConflictKiller.load()
        Cliphist.refresh()
        Wallpapers.load()
        Updates.load()
    }

    // Load enabled stuff
    // Well, these loaders only *allow* them to be loaded, to always load or not is defined in each component
    // The media controls for example is not loaded if it's not opened
    PanelLoader { identifier: "floatgBar"; extraCondition: !Config.options.bar.vertical; component: Bar {} }
    PanelLoader { identifier: "floatgBackground"; component: Background {} }
    PanelLoader { identifier: "floatgCheatsheet"; component: Cheatsheet {} }
    PanelLoader { identifier: "floatgDock"; extraCondition: Config.options.dock.enable; component: Dock {} }
    PanelLoader { identifier: "floatgLock"; component: Lock {} }
    PanelLoader { identifier: "floatgMediaControls"; component: MediaControls {} }
    PanelLoader { identifier: "floatgNotificationPopup"; component: NotificationPopup {} }
    PanelLoader { identifier: "floatgOnScreenDisplay"; component: OnScreenDisplay {} }
    PanelLoader { identifier: "floatgOnScreenKeyboard"; component: OnScreenKeyboard {} }
    PanelLoader { identifier: "floatgOverlay"; component: Overlay {} }
    PanelLoader { identifier: "floatgOverview"; component: Overview {} }
    PanelLoader { identifier: "floatgPolkit"; component: Polkit {} }
    PanelLoader { identifier: "floatgRegionSelector"; component: RegionSelector {} }
    PanelLoader { identifier: "floatgScreenCorners"; component: ScreenCorners {} }
    PanelLoader { identifier: "floatgSessionScreen"; component: SessionScreen {} }
    PanelLoader { identifier: "floatgSidebarLeft"; component: SidebarLeft {} }
    PanelLoader { identifier: "floatgSidebarRight"; component: SidebarRight {} }
    PanelLoader { identifier: "floatgVerticalBar"; extraCondition: Config.options.bar.vertical; component: VerticalBar {} }
    PanelLoader { identifier: "floatgWallpaperSelector"; component: WallpaperSelector {} }

    ReloadPopup {}

    component PanelLoader: LazyLoader {
        required property string identifier
        property bool extraCondition: true
        active: Config.ready && Config.options.enabledPanels.includes(identifier) && extraCondition
    }

    // Panel families
    property list<string> families: ["floatg"]
    property var panelFamilies: ({
        "floatg": ["floatgBar", "floatgBackground", "floatgCheatsheet", "floatgDock", "floatgLock", "floatgMediaControls", "floatgNotificationPopup", "floatgOnScreenDisplay", "floatgOnScreenKeyboard", "floatgOverlay", "floatgOverview", "floatgPolkit", "floatgRegionSelector", "floatgScreenCorners", "floatgSessionScreen", "floatgSidebarLeft", "floatgSidebarRight", "floatgVerticalBar", "floatgWallpaperSelector"],
    })
    function cyclePanelFamily() {
        const currentIndex = families.indexOf(Config.options.panelFamily)
        const nextIndex = (currentIndex + 1) % families.length
        Config.options.panelFamily = families[nextIndex]
        Config.options.enabledPanels = panelFamilies[Config.options.panelFamily]
    }

    IpcHandler {
        target: "panelFamily"

        function cycle(): void {
            root.cyclePanelFamily()
        }
    }

    GlobalShortcut {
        name: "panelFamilyCycle"
        description: "Cycles panel family"

        onPressed: root.cyclePanelFamily()
    }
}
