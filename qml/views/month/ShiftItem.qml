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
            const max = parent.width - border.width*2
            let current = (((label.text.length)*label.font.pixelSize)) + (label.font.pixelSize*0.15)
            return current > max ? max : current
        }
        height: label.font.pixelSize * 1.35

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

            elide: Text.ElideRight
            Component.onCompleted: {
                console.log(label.font.letterSpacing, label.font.wordSpacing)
            }
        }
    }
}
