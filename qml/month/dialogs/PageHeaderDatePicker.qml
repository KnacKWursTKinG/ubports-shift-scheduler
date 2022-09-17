import Ubuntu.Components 1.3 as Components
import Ubuntu.Components.Popups 1.3 as Popups
import Ubuntu.Components.Pickers 1.3 as Pickers


Popups.Dialog {
    id: root

    property alias pickerDate: picker.date

    signal close(bool ok)

    Pickers.DatePicker {
        id: picker
        mode: "Years|Months"
        minimum: {
            const today = new Date()
            return new Date(today.getFullYear() - 100, today.getMonth())
        }
        maximum: {
            const today = new Date()
            return new Date(today.getFullYear() + 100, today.getMonth())
        }
    }

    Components.Button {
        text: tr.get("Select")
        color: theme.palette.normal.focus
        onTriggered: {
            enabled = false
            cancel.enabled = false
            close(true)
            PopupUtils.close(root)
        }
    }

    Components.Button {
        id: cancel

        text: tr.get("Cancel")
        onTriggered: {
            close(false)
            PopupUtils.close(root)
        }
    }
}
