pragma ComponentBehavior: Bound
import qs.services
import qs.modules.common
import qs.modules.common.widgets
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Bluetooth
import qs.modules.floatg.overlay.volumeMixer
import qs.modules.floatg.overlay.floatingImage
import qs.modules.floatg.overlay.recorder
import qs.modules.floatg.overlay.resources
import qs.modules.floatg.overlay.notes

DelegateChooser {
    id: root
    role: "identifier"

    DelegateChoice { roleValue: "floatingImage"; FloatingImage {} }
    DelegateChoice { roleValue: "recorder"; Recorder {} }
    DelegateChoice { roleValue: "resources"; Resources {} }
    DelegateChoice { roleValue: "notes"; Notes {} }
    DelegateChoice { roleValue: "volumeMixer"; VolumeMixer {} }
}
