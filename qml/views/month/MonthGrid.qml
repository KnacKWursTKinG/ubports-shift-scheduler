import QtQuick 2.12
import QtQuick.Layouts 1.11

GridLayout {
    id: root

    property var month
    property var monthData

    columns: 7
    rows: 6
    columnSpacing: 0
    rowSpacing: 0

    anchors {
        top: gridHeader.bottom
        topMargin: rowSpacing
        right: parent.right
        rightMargin: columnSpacing
        bottom: parent.bottom
        bottomMargin: rowSpacing
        left: parent.left
        leftMargin: columnSpacing
    }

    clip: true

    Repeater {
        id: repeater
        model: 42

        GridItem {
            id: monthGridItem

            dayData: root.monthData[index]
            disabled: dayData.Date.Month !== root.month

            border {
                color: ctxObject.gridBorder
                    ? theme.palette.normal.foreground
                    : "transparent"
            }
        }
    }
}
