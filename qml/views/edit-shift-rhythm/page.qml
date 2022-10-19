// NOTE: New Component!
import QtQuick 2.12

import Ubuntu.Components 1.3
import Ubuntu.Components.ListItems 1.3

Page {
    id: page

    header: PageHeader {
        id: pageHeader
        title: tr.get("ShiftRhythm")

        leadingActionBar.actions: [
            Action {
                iconName: "back"
                onTriggered: {
                    page.save()
                    stack.pop()
                }
            }
        ]

        Button {
            anchors.right: parent.right
            anchors.rightMargin: units.gu(1)
            anchors.verticalCenter: parent.verticalCenter
            text: tr.get("ShiftConfig")
            onClicked: {
                page.save()
                stack.push(Qt.resolvedUrl("../edit-shifts/page.qml"))
            }
        }
    }

    function load() {
        stepsEditArea.text = ctxObject.shiftHandler.stepsText
    }

    function save() {
        ctxObject.shiftHandler.stepsText = stepsEditArea.text

        ctxObject.shiftHandler.qmlParseSteps()
        for (let step of JSON.parse(ctxObject.shiftHandler.qmlGetStepsArray())) {
            if (!ctxObject.shiftHandler.shiftsConfig.exists(step)) {
                ctxObject.shiftHandler.shiftsConfig.append(step, "", 0, false)
            }
        }
    }

    Rectangle {
        color: "transparent"
        anchors.top: parent.top
        anchors.topMargin: pageHeader.height + units.gu(0.5)
        anchors.right: parent.right
        anchors.rightMargin: units.gu(0.5)
        anchors.left: parent.left
        anchors.leftMargin: units.gu(0.5)
        anchors.bottom: parent.bottom
        anchors.bottomMargin: units.gu(0.5)
        clip: true

        TextArea {
            // TODO: how about using FiraCode font for this edit field
            id: stepsEditArea
            anchors.fill: parent
            anchors.margins: units.gu(0.25)
            placeholderText: tr.get("CommaSeparatedString")
            font.family: "Fira Code"
        }
    }

    Connections {
        target: stack
        onCurrentPageChanged: {
            if (stack.currentPage === page) {
                page.load()
            }
        }
    }
}
