import QtQuick 2.12
import QtQuick.Layouts 1.11

import Lomiri.Components 1.3
import Lomiri.Components.Popups 1.3

import "../../components"
import "../../dialogs"

Page {
    header: PageHeader {
        id: pageHeader
        title: tr.get("ShiftConfig")

        Component {
            id: addDialog

            NewShiftDialog {
                onClose: function (ok) {
                    if (ok) {
                        // force a reload
                        view.model = 0
                        view.model = ctxo.shiftHandler.shiftsConfig.count()
                    }
                }
            }
        }

        leadingActionBar.actions: [
            Action {
                iconName: "back"
                onTriggered: stack.pop()
            }
        ]

        trailingActionBar.actions: [
            Action {
                iconName: "add"
                onTriggered: PopupUtils.open(addDialog)
            }
        ]
    }

    ListView {
        id: view

        anchors {
            top: pageHeader.bottom
            right: parent.right
            bottom: parent.bottom
            left: parent.left
        }

        model: ctxo.shiftHandler.shiftsConfig.count()

        delegate: ListItem {
            property var shiftItem: ctxo.shiftHandler.shiftsConfig.getIndex(index)

            height: layout.height

            leadingActions: ListItemActions {
                actions: [
                    Action {
                        iconName: "delete"
                        onTriggered: {
                            ctxo.shiftHandler.shiftsConfig.remove(shiftItem.name)
                            view.model = ctxo.shiftHandler.shiftsConfig.count()
                        }
                    }
                ]
            }

            trailingActions: ListItemActions {
                actions: [
                    Action {
                        iconName: "settings"
                        onTriggered: PopupUtils.open(editShiftSettings)
                    }
                ]
            }

            Component {
                id: editShiftSettings

                StyleShiftDialog {
                    shiftName: shiftItem.name
                    shiftColor: shiftItem.color
                    shiftTextSize: shiftItem.size

                    onClose: {
                        if (ok) {
                            // update
                            ctxo.shiftHandler.shiftsConfig.set(
                                shiftName, shiftName, //  <origin>, <shift name>
                                shiftColor,
                                shiftTextSize,
                                shiftItem.hidden
                            )
                            // and reload list item
                            shiftItem = ctxo.shiftHandler.shiftsConfig.getIndex(index)
                        }
                    }
                }
            }

            ListItemLayout {
                id: layout

                title.text: shiftItem.name
                title.textSize: TextSize.getSize(shiftItem.name, shiftItem.size)
                title.font.family: "Fira Code"
                title.color: shiftItem.color || theme.palette.normal.baseText

                HiddenCheckBox {
                    id: hiddenCheckBox
                    item: shiftItem
                }
            }
        }
    }
}
