import qs.services
import qs.modules.common
import qs.modules.common.widgets
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Io

Item {
    id: root
    required property var scopeRoot
    property int sidebarPadding: 10
    property string notesText: ""
    anchors.fill: parent

    function focusActiveItem() {
        notesInput.forceActiveFocus()
    }

    ColumnLayout {
        anchors {
            fill: parent
            margins: sidebarPadding
        }
        spacing: sidebarPadding

        RowLayout {
            Layout.fillWidth: true
            StyledText {
                text: Translation.tr("Scratchpad")
                font.pixelSize: Appearance.font.pixelSize.normal
                color: Appearance.colors.colOnLayer0
            }
            Item { Layout.fillWidth: true }
            RippleButtonWithIcon {
                buttonRadius: Appearance.rounding.small
                materialIcon: "delete"
                mainText: Translation.tr("Clear Notes")
                onClicked: {
                    root.notesText = ""
                    notesInput.text = ""
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            radius: Appearance.rounding.normal
            color: Appearance.colors.colLayer1

            MaterialTextArea {
                id: notesInput
                anchors.fill: parent
                anchors.margins: 8
                placeholderText: Translation.tr("Type anything here...")
                text: root.notesText
                wrapMode: TextEdit.Wrap
                onTextChanged: root.notesText = text
            }
        }
    }

}
