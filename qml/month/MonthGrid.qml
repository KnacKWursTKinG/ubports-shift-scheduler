import QtQuick 2.12 as Quick
import QtQuick.Layouts 1.11 as Layouts

Layouts.GridLayout {
    id: root

    property var date
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

    Quick.Repeater {
        id: repeater
        model: 42

        MonthGridItem {
            id: monthGridItem

            monthData: root.monthData[index]

            date: new Date(
                root.date.getFullYear(),
                root.date.getMonth(),
                index - root.date.getDay() + 1
            )

            disabled: date.getMonth() !== root.date.getMonth()

            border {
                color: ctxObject.gridBorder
                    ? theme.palette.normal.foreground
                    : "transparent"
            }
        }
    }
}
