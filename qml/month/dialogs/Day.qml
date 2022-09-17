import QtQuick 2.12 as Quick
import QtQuick.Controls 2.12 as Controls

import Ubuntu.Components 1.3 as Components
import Ubuntu.Components.Popups 1.3 as Popups
import Ubuntu.Components.ListItems 1.3 as ListItems

import "../../js/helper.js" as Helper

Popups.Dialog {
    id: root

    property var date
    property alias shift: dayShift.currentShift
    property alias notes: dayNotes.text

    signal close()

    Components.TextArea {
        id: dayNotes
        placeholderText: tr.get("NotesPlaceholder")
    }

    ListItems.Divider {}

    Components.Label {
        text: tr.get("SelectShift")
    }

    Controls.ComboBox {
        // Choose a shift
        id: dayShift

        property string currentShift

        model: Quick.ListModel {
            function indexOf(value) {
                for (var idx = 0; idx < count; idx++) {
                    if (get(idx).text === value) {
                        return idx
                    }
                }

                return -1
            }
        }

        onCurrentTextChanged: {
            currentShift = currentText
        }

        Quick.Component.onCompleted: {
            const count = ctxObject.shiftHandler.shiftsConfig.count()
            for (var idx = 0; idx < count; idx++) {
                const name = ctxObject.shiftHandler.shiftsConfig.getNamePerIndex(idx)
                model.append({ "text": name })
            }

            currentIndex = model.indexOf(currentShift)
        }
    }

    Components.Button {
        property string original: ctxObject.shiftHandler.getShift(
            root.date.Year, root.date.Month, root.date.Day
        )

        // Reset
        text: tr.get("ResetShift")
        color: theme.palette.normal.negative
        enabled: original !== dayShift.currentShift
        onTriggered: {
            // get  the original shift
            const originalShift = ctxObject.shiftHandler.getShift(
                root.date.Year, root.date.Month, root.date.Day
            )

            // update will remove shift from the database
            // because it's no custom shift
            monthHandler.updateShift(
                root.date.Year, root.date.Month, root.date.Day,
                originalShift
            )

            // update combo box index
            dayShift.currentIndex = dayShift.model.indexOf(originalShift)
        }
    }

    Components.Button {
        // Close
        text: tr.get("Update")
        color: theme.palette.normal.positive
        onTriggered: {
            close(dayShift.currentShift, dayNotes.text)
            PopupUtils.close(root)
        }
    }

    ListItems.Divider {}

    Components.Button {
        text: tr.get("Cancel")
        onTriggered: {
            PopupUtils.close(root)
        }
    }
}
