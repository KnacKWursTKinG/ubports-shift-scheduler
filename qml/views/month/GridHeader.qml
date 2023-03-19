import QtQuick 2.12
import QtQuick.Layouts 1.11

import Lomiri.Components 1.3

// Grid Header (Sun-Sat)
GridLayout {
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

    Repeater {
        model: 7

        Rectangle {
            Layout.fillHeight: true
            Layout.fillWidth: true

            color: theme.palette.normal.background

            border {
                color: ctxo.gridBorder
                    ? theme.palette.normal.foreground
                    : "transparent"
            }

            Label {
                anchors.centerIn: parent

                font.underline: true
                font.bold: true

                textSize: Label.Medium
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
