import QtQuick 2.12 as Quick
import QtQuick.Layouts 1.11 as Layouts

import Ubuntu.Components 1.3 as Components

// Grid Header (Sun-Sat)
Layouts.GridLayout {
    id: root

    property int pointSize: 14

    columns: 7
    rows: 1
    columnSpacing: 0
    rowSpacing: 0

    height: pointSize * 3

    anchors {
        top: parent.top
        right: parent.right
        rightMargin: columnSpacing
        left: parent.left
        leftMargin: columnSpacing
    }

    Quick.Repeater {
        model: 7

        Quick.Rectangle {
            Layouts.Layout.fillHeight: true
            Layouts.Layout.fillWidth: true

            color: theme.palette.normal.background

            border {
                color: settings.gridBorder
                    ? theme.palette.normal.foreground
                    : "transparent"
            }

            Components.Label {
                anchors.centerIn: parent

                font.underline: true
                font.bold: true

                textSize: Components.Label.Medium
                text: {
                    switch (index) {
                    case 0:
                        return tr.get("SundayShort")
                    case 1:
                        return tr.get("MondayShort")
                    case 2:
                        return tr.get("TuesdayShort")
                    case 3:
                        return tr.get("WednesdayShort")
                    case 4:
                        return tr.get("ThursdayShort")
                    case 5:
                        return tr.get("FridayShort")
                    case 6:
                        return tr.get("SaturdayShort")
                    }
                }
            }
        }
    }
}
