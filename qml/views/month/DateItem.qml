import QtQuick 2.12

import Lomiri.Components 1.3

Rectangle {
    id: root

    color: "transparent"

    property var dData
    property bool disabled

    Rectangle {
        id: container

        anchors {
            centerIn: parent
        }

        width: label.height + units.gu(2)
        height: label.width + units.gu(2)

        radius: 5
        color: root.dData.Today ? "orange": "transparent"

        Label {
            id: label
            color: {
                if (root.disabled) {
                    return theme.palette.disabled.baseText
                }

                return root.dData.Notes
                    ? UbuntuColors.red
                    : theme.palette.normal.baseText
            }

            anchors {
                centerIn: parent
            }

            textSize: Label.Medium
            text: root.dData.Date.Day

            font.bold: !root.disabled
        }
    }
}
