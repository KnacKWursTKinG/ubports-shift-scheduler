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
                    // TODO: also save the text formatting (ex: 3 steps, newline, 2 steps, newline, space, tab, 2 steps)
                    const err = ctxObject.shiftHandler.qmlSetSteps(JSON.stringify(currentShiftSteps.getSteps()))
                    if (err) console.error("error while save shift rhythm:", err)
                    stack.pop()
                }
            }
        ]
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

        function load() {
            // TODO: load shifts configuration for highlighting?
        }

        function getSteps() {
            const steps = []
            for (let line of currentShiftStepsEdit.text.split("\n")) {
                for (let step of line.split(",")) {
                    step = step.trim()
                    if (step) {
                        steps.push(step)
                    }
                }
            }
            return steps
        }

        // TODO: add info label about formatting (newlines)

        TextArea {
            // TODO: input should be like this github tags input field
            id: currentShiftStepsEdit
            text: JSON.parse(ctxObject.shiftHandler.qmlGetSteps()).join(",")
            anchors.fill: parent
            anchors.margins: units.gu(0.25)
            placeholderText: tr.get("CommaSeparatedString")
        }

        Button {
            anchors.right: currentShiftStepsEdit.right
            anchors.rightMargin: units.gu(0.25)
            anchors.bottom: currentShiftStepsEdit.bottom
            anchors.bottomMargin: units.gu(0.25)
            text: tr.get("ShiftConfig")
            onClicked: {
                stack.push(Qt.resolvedUrl("../edit-shifts/page.qml"))
            }
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
