import Ubuntu.Components 1.3 as Components
import Ubuntu.Components.Popups 1.3 as Popups

Popups.Dialog {
    id: addShiftDialogue

    signal close(bool ok)

    title: tr.get("NewShift")

    Components.TextField {
        id: addShiftName
        placeholderText: tr.get("Name")
    }

    Components.Button {
        text: tr.get("Ok")
        enabled: !!addShiftName.text
        onTriggered: {
            if (!settings.shifts.config.exists(addShiftName.text)) {
                settings.shifts.config.append(addShiftName.text, "", 0, false)
            }
            // else: shift already exists, do nothing

            close(true)
            PopupUtils.close(addShiftDialogue)
        }
    }

    Components.Button {
        text: tr.get("Cancel")
        onTriggered: {
            close(false)
            PopupUtils.close(addShiftDialogue)
        }
    }
}
