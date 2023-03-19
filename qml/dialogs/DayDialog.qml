import QtQuick 2.12
import QtQuick.Controls 2.12

import Lomiri.Components 1.3
import Lomiri.Components.Popups 1.3
import Lomiri.Components.ListItems 1.3

Dialog {
    id: root

    property var date
    property alias shift: dayShift.currentShift
    property alias notes: dayNotes.text

    signal close()

    TextArea {
        id: dayNotes
        placeholderText: tr.get("NotesPlaceholder")
    }

    Divider {}

    Label {
        text: tr.get("SelectShift")
    }

    ComboBox {
        // Choose a shift
        id: dayShift

        property string currentShift

        model: ListModel {
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

        Component.onCompleted: {
            const count = ctxo.shiftHandler.shiftsConfig.count()
            for (var idx = 0; idx < count; idx++) {
                const name = ctxo.shiftHandler.shiftsConfig.getNamePerIndex(idx)
                model.append({ "text": name })
            }

            currentIndex = model.indexOf(currentShift)
        }
    }

    Button {
        property string original: ctxo.shiftHandler.getShift(
            root.date.Year, root.date.Month, root.date.Day
        )

        // Reset
        text: tr.get("ResetShift")
        color: theme.palette.normal.negative
        enabled: original !== dayShift.currentShift
        onTriggered: {
            // get  the original shift
            const originalShift = ctxo.shiftHandler.getShift(
                root.date.Year, root.date.Month, root.date.Day
            )

            // update will remove shift from the database
            // because it's no custom shift
            mh.updateShift(
                root.date.Year, root.date.Month, root.date.Day,
                originalShift
            )

            // update combo box index
            dayShift.currentIndex = dayShift.model.indexOf(originalShift)
        }
    }

    Divider {}

    Button {
        // Close
        text: tr.get("Update")
        color: theme.palette.normal.positive
        onTriggered: {
            close(dayShift.currentShift, dayNotes.text)
            PopupUtils.close(root)
        }
    }

    Button {
        text: tr.get("Cancel")
        onTriggered: {
            PopupUtils.close(root)
        }
    }
}
