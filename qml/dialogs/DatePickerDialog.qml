import QtQuick 2.12

import Lomiri.Components 1.3
import Lomiri.Components.Popups 1.3
import Lomiri.Components.Pickers 1.3

Dialog {
    id: root

    property alias pickerDate: picker.date

    signal close(bool ok)

    DatePicker {
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

        Component.onCompleted: {
            // Fix this stupid white on white stuff on SuruDark
            if (theme.name.match(/SuruDark/)) {
                data[12].highlightBackgroundColor = "#00000000"
                data[12].highlightColor = "#00000000"
            }
        }
    }

    Button {
        text: tr.get("Select")
        color: theme.palette.normal.focus
        onTriggered: {
            enabled = false
            cancel.enabled = false
            close(true)
            PopupUtils.close(root)
        }
    }

    Button {
        id: cancel

        text: tr.get("Cancel")
        onTriggered: {
            close(false)
            PopupUtils.close(root)
        }
    }
}
