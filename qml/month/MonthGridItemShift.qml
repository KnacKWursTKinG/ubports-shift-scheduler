import QtQuick 2.12 as Quick

import Ubuntu.Components 1.3 as Components

import "../js/helper.js" as Helper
import "../js/textSize.js" as TextSize

Quick.Rectangle {
    id: root

    property alias isVisible: container.visible

    property var dayData

    property bool landscapeMode
    property bool disabled

    color: "transparent"

    Quick.Rectangle {
        id: container

        anchors {
            centerIn: parent
        }

        width: {
            const maxWidth = parent.width - border.width * 2
            let newWidth = (label.text.length + 3) * label.font.pointSize

            if (newWidth > maxWidth) {
                return maxWidth
            }

            return newWidth
        }
        height: label.font.pointSize * 3

        radius: 5
        visible: !root.disabled
            && root.dayData.Shift.Name && !root.dayData.Shift.Hidden

        color: "transparent"

        border {
            color: ctxObject.shiftBorder
                ? root.dayData.Shift.Color || theme.palette.normal.base
                : "transparent"
        }

        Components.Label {
            id: label

            width: parent.width
            height: parent.height
            horizontalAlignment: Quick.Text.AlignHCenter
            verticalAlignment: Quick.Text.AlignVCenter

            color: root.dayData.Shift.Color
                || theme.palette.normal.baseText

            text: root.dayData.Shift.Name
            textSize: TextSize.get(dayData.Shift.Name, dayData.Shift.Size)

            font.italic: true

            elide: Quick.Text.ElideRight
        }
    }
}
