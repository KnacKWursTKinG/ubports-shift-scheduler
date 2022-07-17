import QtQuick 2.12 as Quick
import QtQuick.Controls 2.12 as Controls

import Ubuntu.Components 1.3 as Components
import Ubuntu.Components.Popups 1.3 as Popups
import Ubuntu.Components.ListItems 1.3 as ListItems

import "../../js/helper.js" as Helper

Popups.Dialog {
    id: dayDialogue

    property int year: 0
    property int month: 0
    property int day: 0

    signal close(string shift, string notes)

    Components.TextArea {
        id: dayDialogueNotes
        placeholderText: tr.get("NotesPlaceholder")

        Quick.Component.onCompleted: text = db.getNotes(db.buildID(year, month, day))
    }

    ListItems.Divider {}

    Components.Label {
        //horizontalAlignment: Text.AlignHCenter
        text: tr.get("SelectShift")
    }

    Controls.ComboBox {
        // Choose a shift
        id: dayDialogueShift

        property string currentShift: ""

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
            const count = settings.shifts.config.count()
            for (var idx = 0; idx < count; idx++) {
                const name = settings.shifts.config.getNamePerIndex(idx)
                model.append({ "text": name })
            }

            currentShift = Helper.getShift(year, month, day)
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
                settings.shifts.getShift(year, month, day)
            )
        }
    }

    ListItems.Divider {}

    Components.Button {
        // Close
        text: tr.get("Close")
        onTriggered: {
            close(dayDialogueShift.currentShift, dayDialogueNotes.text)
            PopupUtils.close(dayDialogue)
        }
    }
}
