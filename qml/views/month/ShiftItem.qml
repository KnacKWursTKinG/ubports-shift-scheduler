import QtQuick 2.12

import Ubuntu.Components 1.3

import "../../components"

Rectangle {
    id: root

    property alias isVisible: container.visible

    property var dData

    property bool landscapeMode
    property bool disabled

    color: "transparent"

    Rectangle {
        id: container

        anchors {
            centerIn: parent
        }

        width: {
            const max = parent.width - border.width*3
            let current = (((label.text.length)*label.font.pixelSize)) + (label.font.pixelSize*0.15)
            return current > max ? max : current
        }
        height: label.font.pixelSize * 1.5

        radius: 5
        visible: !root.disabled
            && root.dData.Shift.Name && !root.dData.Shift.Hidden

        color: "transparent"

        border {
            color: ctxo.shiftBorder
                ? root.dData.Shift.Color || theme.palette.normal.base
                : "transparent"
        }

        Label {
            id: label

            width: parent.width
            height: parent.height
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter

            color: root.dData.Shift.Color
                || theme.palette.normal.baseText

            text: root.dData.Shift.Name
            textSize: TextSize.getSize(dData.Shift.Name, dData.Shift.Size)
            font.family: "Fira Code"

            elide: Text.ElideRight
        }
    }
}
