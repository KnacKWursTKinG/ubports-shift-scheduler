import QtQuick 2.12 as Quick

import Ubuntu.Components 1.3 as Components
import Ubuntu.Components.Popups 1.3 as Popups
import Ubuntu.Components.Pickers 1.3 as Pickers


Popups.Dialog {
    id: root

    property alias pickerDate: picker.date

    signal close(bool ok)

    Pickers.DatePicker {
        // TODO: change the color highlight somehow
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

        Quick.Component.onCompleted: {
            // Fix this stupid white on white stuff on SuruDark
            data[12].highlightBackgroundColor = "#00000000"
            data[12].highlightColor = "#00000000"
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
