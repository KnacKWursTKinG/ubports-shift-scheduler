import QtQuick 2.12 as Quick
import QtQuick.Layouts 1.11 as Layouts

import Ubuntu.Components 1.3 as Components
import Ubuntu.Components.Popups 1.3 as Popups

import "./components"
import "./dialogs" as Dialogs

import "../js/textSize.js" as TextSize

Components.Page {
    header: Components.PageHeader {
        id: pageHeader
        title: tr.get("ShiftConfig")

        Quick.Component {
            id: addDialog

            Dialogs.AddShift {
                onClose: function (ok) {
                    if (ok) {
                        // force a reload
                        view.model = 0
                        view.model = settings.shifts.config.count()
                    }
                }
            }
        }

        leadingActionBar.actions: [
            Components.Action {
                iconName: "back"
                onTriggered: {
                    stack.pop()
                }
            }
        ]

        trailingActionBar.actions: [
            Components.Action {
                iconName: "add"
                onTriggered: {
                    PopupUtils.open(addDialog)
                }
            }
        ]
    }

    Quick.ListView {
        id: view

        anchors {
            top: pageHeader.bottom
            right: parent.right
            bottom: parent.bottom
            left: parent.left
        }

        model: settings.shifts.config.count()

        delegate: Components.ListItem {
            property var shiftItem: settings.shifts.config.getIndex(index)

            height: layout.height

            leadingActions: Components.ListItemActions {
                actions: [
                    Components.Action {
                        iconName: "delete"
                        onTriggered: {
                            settings.shifts.config.remove(shiftItem.name)
                            view.model = settings.shifts.config.count()
                        }
                    }
                ]
            }

            trailingActions: Components.ListItemActions {
                actions: [
                    Components.Action {
                        iconName: "settings"
                        onTriggered: PopupUtils.open(editShiftSettings)
                    }
                ]
            }

            Quick.Component {
                id: editShiftSettings

                Dialogs.EditShiftSettings {
                    item: shiftItem
                }
            }

            Components.ListItemLayout {
                id: layout

                title.text: shiftItem.name
                title.color: shiftItem.shiftColor || theme.palette.normal.baseText
                title.textSize: TextSize.get(shiftItem)

                HiddenCheckBox {
                    id: hiddenCheckBox

                    item: shiftItem
                }
            }
        }
    }
}
