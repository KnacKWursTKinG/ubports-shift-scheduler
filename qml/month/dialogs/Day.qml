import QtQuick 2.12 as Quick
import QtQuick.Controls 2.12 as Controls

import Ubuntu.Components 1.3 as Components
import Ubuntu.Components.Popups 1.3 as Popups
import Ubuntu.Components.ListItems 1.3 as ListItems

import "../../js/helper.js" as Helper

Popups.Dialog {
    id: dayDialogue

    property var dayData

    signal close(string shift, string notes)

    Components.TextArea {
        id: dayDialogueNotes
        placeholderText: tr.get("NotesPlaceholder")
        text: dayDialogue.dayData.Notes
    }

    ListItems.Divider {}

    Components.Label {
        //horizontalAlignment: Text.AlignHCenter
        text: tr.get("SelectShift")
    }

    Controls.ComboBox {
        // Choose a shift
        id: dayDialogueShift

        property string currentShift: dayDialogue.dayData.Shift.Name

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
        // Reset
        text: tr.get("ResetShift")
        onTriggered: {
            const err = db.removeShift(db.buildID(year, month, day))
            if (err) console.error("error while removing shift:", err.error())

            dayDialogueShift.currentIndex = dayDialogueShift.model.indexOf(
                ctxObject.shiftHandler.getShift(
                    dayDialogue.dayData.Date.Year,
                    dayDialogue.dayData.Date.Month,
                    dayDialogue.dayData.Date.Day,
                )
            )
        }
    }

    ListItems.Divider {}

    Components.Button {
        // Close
        text: tr.get("Close")
        color: Components.UbuntuColors.green
        onTriggered: {
            close(dayDialogueShift.currentShift, dayDialogueNotes.text)
            PopupUtils.close(dayDialogue)
        }
    }
}
