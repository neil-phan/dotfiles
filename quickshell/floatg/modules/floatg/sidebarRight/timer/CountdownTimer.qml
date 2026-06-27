import qs.services
import qs.modules.common
import qs.modules.common.widgets
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: root

    implicitHeight: contentColumn.implicitHeight
    implicitWidth: contentColumn.implicitWidth

    ColumnLayout {
        id: contentColumn
        anchors.fill: parent
        spacing: 0

        CircularProgress {
            Layout.alignment: Qt.AlignHCenter
            lineWidth: 8
            value: TimerService.countdownDuration > 0 ? TimerService.countdownSecondsLeft / TimerService.countdownDuration : 0
            implicitSize: 200
            enableAnimation: true

            StyledText {
                anchors.centerIn: parent
                text: {
                    let minutes = Math.floor(TimerService.countdownSecondsLeft / 60).toString().padStart(2, '0');
                    let seconds = Math.floor(TimerService.countdownSecondsLeft % 60).toString().padStart(2, '0');
                    return `${minutes}:${seconds}`;
                }
                font.pixelSize: 40
                color: Appearance.m3colors.m3onSurface
            }
        }

        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 6
            visible: !TimerService.countdownRunning

            RippleButton {
                implicitHeight: 28
                implicitWidth: 28
                font.pixelSize: Appearance.font.pixelSize.small
                colBackground: Appearance.colors.colLayer2
                colBackgroundHover: Appearance.colors.colLayer2Hover
                colRipple: Appearance.colors.colLayer2Active
                onClicked: TimerService.adjustCountdownDuration(-60)
                contentItem: StyledText {
                    anchors.centerIn: parent
                    text: "−"
                    color: Appearance.colors.colOnLayer2
                }
            }
            StyledText {
                text: Math.floor(TimerService.countdownDuration / 60) + "m"
                font.pixelSize: Appearance.font.pixelSize.small
                color: Appearance.m3colors.m3onSurface
                horizontalAlignment: Text.AlignHCenter
            }
            RippleButton {
                implicitHeight: 28
                implicitWidth: 28
                font.pixelSize: Appearance.font.pixelSize.small
                colBackground: Appearance.colors.colLayer2
                colBackgroundHover: Appearance.colors.colLayer2Hover
                colRipple: Appearance.colors.colLayer2Active
                onClicked: TimerService.adjustCountdownDuration(60)
                contentItem: StyledText {
                    anchors.centerIn: parent
                    text: "+"
                    color: Appearance.colors.colOnLayer2
                }
            }
        }

        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 10

            RippleButton {
                contentItem: StyledText {
                    anchors.centerIn: parent
                    horizontalAlignment: Text.AlignHCenter
                    text: TimerService.countdownRunning ? Translation.tr("Pause") : (TimerService.countdownSecondsLeft === TimerService.countdownDuration) ? Translation.tr("Start") : Translation.tr("Resume")
                    color: TimerService.countdownRunning ? Appearance.colors.colOnSecondaryContainer : Appearance.colors.colOnPrimary
                }
                implicitHeight: 35
                implicitWidth: 90
                enabled: TimerService.countdownSecondsLeft > 0
                font.pixelSize: Appearance.font.pixelSize.larger
                onClicked: TimerService.toggleCountdown()
                colBackground: TimerService.countdownRunning ? Appearance.colors.colSecondaryContainer : Appearance.colors.colPrimary
                colBackgroundHover: TimerService.countdownRunning ? Appearance.colors.colSecondaryContainer : Appearance.colors.colPrimary
            }

            RippleButton {
                implicitHeight: 35
                implicitWidth: 90

                onClicked: TimerService.resetCountdown()
                enabled: TimerService.countdownSecondsLeft < TimerService.countdownDuration

                font.pixelSize: Appearance.font.pixelSize.larger
                colBackground: Appearance.colors.colErrorContainer
                colBackgroundHover: Appearance.colors.colErrorContainerHover
                colRipple: Appearance.colors.colErrorContainerActive

                contentItem: StyledText {
                    anchors.centerIn: parent
                    horizontalAlignment: Text.AlignHCenter
                    text: Translation.tr("Reset")
                    color: Appearance.colors.colOnErrorContainer
                }
            }
        }
    }
}
