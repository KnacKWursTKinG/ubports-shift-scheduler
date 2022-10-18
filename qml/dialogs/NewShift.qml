import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3

// TODO: ...
Popups.Dialog {
    id: root

    signal close(bool ok)

    title: tr.get("NewShift")

    Components.TextField {
        id: addShiftName
        placeholderText: tr.get("Name")
    }

    Components.Button {
        text: tr.get("Add")
        color: theme.palette.normal.positive
        enabled: !!addShiftName.text
        onTriggered: {
            if (!ctxObject.shiftHandler.shiftsConfig.exists(addShiftName.text)) {
                ctxObject.shiftHandler.shiftsConfig.append(addShiftName.text, "", 0, false)
            }
            // else: shift already exists, do nothing

            close(true)
            PopupUtils.close(root)
        }
    }

    Components.Button {
        text: tr.get("Cancel")
        onTriggered: {
            close(false)
            PopupUtils.close(root)
        }
    }
}
