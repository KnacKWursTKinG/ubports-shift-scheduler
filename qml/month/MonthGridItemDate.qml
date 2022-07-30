import QtQuick 2.12 as Quick

import Ubuntu.Components 1.3 as Components

Quick.Rectangle {
    id: root

    property var dayData
    property bool disabled

    color: "transparent"

    Quick.Rectangle {
        id: container

        anchors {
            centerIn: parent
        }

        width: label.height + units.gu(2)
        height: label.width + units.gu(2)

        radius: 5
        color: root.dayData.Today ? "orange": "transparent"

        Components.Label {
            id: label
            color: {
                if (root.disabled) {
                    return theme.palette.disabled.baseText
                }

                return root.dayData.Notes
                    ? Components.UbuntuColors.red
                    : theme.palette.normal.baseText
            }

            anchors {
                centerIn: parent
            }

            textSize: Components.Label.Medium
            text: root.dayData.Date.Day

            font.bold: !root.disabled
        }
    }
}
