import QtQuick
import QtCore
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import org.qfield
import org.qgis
import Theme
import "."
import "plugin"

Item {
    id: mainLauncher
    property var mainWindow: iface.mainWindow()
    property bool wasLongPress: false

    // ================= PLUGINS =================

    FilterTool {
        id: filterTool
    }

    FiltreOldSchool {
        id: filtreOldSchool
    }

    PositionSettings {
        id: positionTool
    }

    DeleteTool {
        id: deleteTool
    }

    UpdateTool {
        id: updateTool
    }

    // ================= LONG PRESS BOUTON PRINCIPAL =================

    Timer {
        id: longPressTimer
        interval: 800
        repeat: false
        onTriggered: {
            mainLauncher.wasLongPress = true
            filterTool.removeAllFilters()
            filtreOldSchool.removeAllFilters()
            mainWindow.displayToast("Tous les Filtres réinitialisés")
            launcherBtn.opacity = 0.5
            restoreOpacityTimer.start()
        }
    }

    Timer {
        id: restoreOpacityTimer
        interval: 200
        onTriggered: launcherBtn.opacity = 1.0
    }

    // ================= BOUTON PRINCIPAL =================

    QfToolButton {
        id: launcherBtn
        iconSource: "plugin/icon.svg"
        iconColor: Theme.mainColor
        bgcolor: Theme.darkGray
        round: true

        onPressed: {
            mainLauncher.wasLongPress = false
            longPressTimer.start()
        }

        onReleased: {
            if (longPressTimer.running) {
                longPressTimer.stop()
                launcherDialog.open()
            }
        }
    }

    // ================= MENU =================

    Dialog {
        id: launcherDialog
        modal: true
        parent: mainLauncher.mainWindow.contentItem
        anchors.centerIn: parent
        width: Math.min(320, parent.width * 0.85)

        background: Rectangle {
            color: Theme.mainBackgroundColor
            radius: 8
            border.color: Theme.mainColor
            border.width: 2
        }

        contentItem: ColumnLayout {
            spacing: 12
            Layout.margins: 15

            Label {
                text: "Boîte à outils"
                font.bold: true
                font.pixelSize: 18
                Layout.alignment: Qt.AlignHCenter
            }

            // ---------- FILTRES CLASSIQUES ----------
            Button {
                text: "🔍 FILTRES"
                Layout.fillWidth: true
                Layout.preferredHeight: 48
                font.bold: true

                onClicked: {
                    launcherDialog.close()
                    filterTool.openFilterUI()
                }

                onPressAndHold: {
                    launcherDialog.close()
                    filterTool.removeAllFilters()
                }
            }

            // ---------- FILTRE OLD SCHOOL ----------
            Button {
                text: "🔍 FILTRES (ancien)"
                Layout.fillWidth: true
                Layout.preferredHeight: 48
                font.bold: true

                onClicked: {
                    launcherDialog.close()
                    filtreOldSchool.openFilterUI()
                }

                onPressAndHold: {
                    launcherDialog.close()
                    filtreOldSchool.removeAllFilters()
mainWindow.displayToast("Filtres (ancien) réinitialisés")
                }
            }

            // ---------- POSITION ----------
            Button {
                text: "🎨 Personnaliser Position"
                Layout.fillWidth: true
                Layout.preferredHeight: 48
                onClicked: {
                    launcherDialog.close()
                    positionTool.openSettings()
                }
            }

            // ---------- UPDATE ----------
            Button {
                text: "🔄 MISE À JOUR PROJET"
                Layout.fillWidth: true
                Layout.preferredHeight: 48
                onClicked: {
                    launcherDialog.close()
                    updateTool.openUpdateUI()
                }
            }

            // ---------- NETTOYAGE ----------
            Button {
                text: "🗑️ Nettoyer une couche"
                Layout.fillWidth: true
                Layout.preferredHeight: 48
                onClicked: {
                    launcherDialog.close()
                    deleteTool.openDeleteUI()
                }
            }
        }
    }

    Component.onCompleted: {
        iface.addItemToPluginsToolbar(launcherBtn)
    }
}