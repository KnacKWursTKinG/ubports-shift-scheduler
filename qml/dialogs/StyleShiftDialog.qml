import QtQuick 2.12

import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
import Ubuntu.Components.ListItems 1.3

import "../components"

Dialog {
    id: root

    property string shiftName
    property alias shiftColor: colorPicker.currentColor
    property alias shiftTextSize: textSizePicker.size

    signal close(bool ok)

    Label {
        width: parent.width
        text: root.shiftName
        textSize: TextSize.getSize(root.shiftName, root.shiftTextSize)
        color: root.shiftColor || theme.palette.normal.baseText
        horizontalAlignment: Text.AlignHCenter
    }

    Divider {}

    Label {
        width: parent.width
        text: tr.get("TextSize")
        horizontalAlignment: Text.AlignHCenter
    }

    TextSizePicker {
        id: textSizePicker
        text: root.shiftName
    }

    Divider {}

    Label {
        width: parent.width
        text: tr.get("Color")
        horizontalAlignment: Text.AlignHCenter
    }

    ColorPicker {
        id: colorPicker
    }

    Divider {}

    Button {
        text: tr.get("Update")
        color: theme.palette.normal.positive
        onTriggered: {
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
