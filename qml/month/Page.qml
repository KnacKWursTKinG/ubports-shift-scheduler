import QtQuick 2.12 as Quick

import Ubuntu.Components 1.3 as Components

Components.Page {
    header: Components.PageHeader {
        id: pageHeader

        trailingActionBar.actions: [
            Components.Action {
                iconName: "settings"
                onTriggered: {
                    stack.clear()
                    stack.push(Qt.resolvedUrl("../settings/Page.qml"))
                }
            },
            Components.Action {
                iconName: "calendar-today"
                enabled: main.currentRelativeIndex !== 0
                onTriggered: main.currentRelativeIndex = 0
            }
        ]

        Quick.Component.onCompleted: {
            dateObject.set(new Date())
        }
    }

    Quick.PathView {
        id: main

        // current index of 2 is the real index 0
        property int visibleIndex: 0

        currentIndex: 2
        onCurrentIndexChanged: {
            let realIndex = currentIndex + 1
            if (realIndex > 2) realIndex = 0
            visibleIndex = realIndex
        }

        // Update this property to move to a specific month (0 == today, -1 == prev. month, ...)
        property int currentRelativeIndex: 0

        snapMode: Quick.PathView.SnapOneItem
        antialiasing: true

        anchors {
            fill: parent
            topMargin: pageHeader.height
        }

        model: 3

        path: Quick.Path {
            startX: -(main.width / 2)
            startY: main.height / 2

            Quick.PathLine {
                x: (main.width) * 3 - main.width / 2
                relativeY: 0
            }
        }

        delegate: Quick.Component {
            Month {}
        }
    }

    Quick.QtObject {
        id: dateObject

        property int year: 2022
        property int month: 5

        function set(date) {
            year = date.getFullYear()
            month = date.getMonth()

            pageHeader.title = year.toString() +
                " / " + (month + 1).toString() +
                " - " + Qt.formatDate(date, "MMMM").toString()
        }

        function getCurrent() {
            return new Date(year, month, 1)
        }
    }
}
