import QtQuick 2.12 as Quick
import QtQuick.Layouts 1.11 as Layouts

Layouts.GridLayout {
    id: root

    property var date

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
        model: 42

        MonthGridItem {
            id: monthGridItem

            date: new Date(
                root.date.getFullYear(),
                root.date.getMonth(),
                index - root.date.getDay() + 1
            )

            disabled: date.getMonth() !== root.date.getMonth()

            border {
                color: settings.gridBorder
                    ? theme.palette.normal.foreground
                    : "transparent"
            }
        }
    }
}
