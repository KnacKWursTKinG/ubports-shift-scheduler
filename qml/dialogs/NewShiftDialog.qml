import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3

Dialog {
    id: root

    signal close(bool ok)

    title: tr.get("NewShift")

    TextField {
        id: addShiftName
        placeholderText: tr.get("Name")
    }

    Button {
        text: tr.get("Add")
        color: theme.palette.normal.positive
        enabled: !!addShiftName.text
        onTriggered: {
            if (!ctxo.shiftHandler.shiftsConfig.exists(addShiftName.text)) {
                ctxo.shiftHandler.shiftsConfig.append(addShiftName.text, "", 0, false)
            }
            // else: shift already exists, do nothing

            close(true)
            PopupUtils.close(root)
        }
    }

    Button {
        text: tr.get("Cancel")
        onTriggered: {
            close(false)
            PopupUtils.close(root)
        }
    }
}
