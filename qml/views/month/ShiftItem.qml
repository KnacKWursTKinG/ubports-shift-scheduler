import QtQuick 2.12

import Ubuntu.Components 1.3

import "../../components"

Rectangle {
    id: root

    property alias isVisible: container.visible

    property var dayData

    property bool landscapeMode
    property bool disabled

    color: "transparent"

    Rectangle {
        id: container

        anchors {
            centerIn: parent
        }

        width: {
            const maxWidth = parent.width - border.width * 2
            let newWidth = (label.text.length + 1) * label.font.pixelSize

            if (newWidth > maxWidth) {
                return maxWidth
            }

            return newWidth
        }
        height: label.font.pixelSize * 2

        radius: 5
        visible: !root.disabled
            && root.dayData.Shift.Name && !root.dayData.Shift.Hidden

        color: "transparent"

        border {
            color: ctxObject.shiftBorder
                ? root.dayData.Shift.Color || theme.palette.normal.base
                : "transparent"
        }

        Label {
            id: label

            width: parent.width
            height: parent.height
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter

            color: root.dayData.Shift.Color
                || theme.palette.normal.baseText

            text: root.dayData.Shift.Name
            textSize: TextSize.getSize(dayData.Shift.Name, dayData.Shift.Size)

            font.italic: true

            elide: Text.ElideRight
        }
    }
}
