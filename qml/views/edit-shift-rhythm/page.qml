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
                    currentShiftSteps.save()
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
                currentShiftSteps.save()
                stack.push(Qt.resolvedUrl("../edit-shifts/page.qml"))
            }
        }
    }

    function load() {
        currentShiftStepsEdit.text = ctxObject.shiftHandler.stepsText
    }

    function save() {
        ctxObject.shiftHandler.stepsText = currentShiftStepsEdit.text

        const err = ctxObject.shiftHandler.qmlParseSteps()
        if (err) {
            console.error("error:", err.error())
        } else {
            for (let step of JSON.parse()) {
                console.log(`step: "%s"`, step)
                if (!ctxObject.shiftHandler.shiftsConfig.exists(step)) {
                    ctxObject.shiftHandler.shiftsConfig.append(step, "", 0, false)
                }
            }
        }
    }

    Rectangle {
        id: currentShiftSteps
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
            id: currentShiftStepsEdit
            anchors.fill: parent
            anchors.margins: units.gu(0.25)
            placeholderText: tr.get("CommaSeparatedString")
        }
    }

    Connections {
        target: stack
        onCurrentPageChanged: {
            if (stack.currentPage === page) {
                currentShiftSteps.load()
            }
        }
    }
}
