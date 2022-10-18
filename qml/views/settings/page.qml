import QtQuick 2.12
import QtQuick.Layouts 1.11

import Ubuntu.Components 1.3

Page {
    header: PageHeader {
        id: pageHeader
        title: tr.get("Settings")

        leadingActionBar.actions: [
            Action {
                iconName: "back"
                onTriggered: {
                    const err = ctxObject.saveConfig()
                    if (err)
                        console.error()

                    stack.clear() // this will reload the main page with new settings
                    stack.push(Qt.resolvedUrl("../month/page.qml"))
                }
            }
        ]
    }

    ScrollView {
        id: settingsView

        anchors.top: pageHeader.bottom
        width: parent.width
        height: parent.height - pageHeader.height

        ColumnLayout {
            spacing: units.gu(1.5)

            width: settingsView.width

            // Start Date (TextField: year, month, day)
            ListItem {
                Layout.fillWidth: true
                divider.visible: false

                ListItemLayout {
                    title.text: tr.get("StartDate")
                    subtitle.text: tr.get("ShiftRhythmInfo")

                    Layout.preferredWidth: parent.width

                    RowLayout {
                        spacing: units.gu(0.5)

                        TextField {
                            id: settingsStartYear
                            Layout.preferredWidth: font.pixelSize * 6
                            hasClearButton: false
                            placeholderText: "YYYY"
                            inputMethodHints: Qt.ImhDigitsOnly
                            validator: IntValidator {
                                bottom: new Date().getFullYear() - 100
                                top: new Date().getFullYear() + 100
                            }

                            onTextChanged: {
                                if (acceptableInput) {
                                    intern.startDate.year = parseInt(text)
                                }
                            }
                        }

                        TextField {
                            id: settingsStartMonth
                            Layout.preferredWidth: font.pixelSize * 4
                            hasClearButton: false
                            placeholderText: "MM"
                            inputMethodHints: Qt.ImhDigitsOnly
                            validator: IntValidator {
                                bottom: 1
                                top: 12
                            }

                            onTextChanged: {
                                if (acceptableInput) {
                                    intern.startDate.month = parseInt(text)
                                }
                            }
                        }

                        TextField {
                            id: settingsStartDay
                            Layout.preferredWidth: font.pixelSize * 4
                            hasClearButton: false
                            placeholderText: "DD"
                            inputMethodHints: Qt.ImhDigitsOnly
                            validator: IntValidator {
                                bottom: 1
                                top: 32
                            }

                            onTextChanged: {
                                if (acceptableInput) {
                                    intern.startDate.day = parseInt(text)
                                }
                            }
                        }
                    }
                }
            }

            // Shift Steps (TextField)
            ColumnLayout { // <<-
                Layout.fillWidth: true
                Layout.margins: units.gu(2)
                spacing: units.gu(0.75)

                ColumnLayout {
                    Layouts.Layout.fillWidth: true

                    Label {
                        text: tr.get("ShiftRhythm")
                        textSize: Label.Medium
                    }

                    Label {
                        text: tr.get("ShiftRhythmInfo")
                        textSize: Label.Small
                    }
                }

                TextField {
                    id: settingsShiftSteps

                    Layout.fillWidth: true

                    placeholderText: tr.get("CommaSeparatedString")
                    onTextChanged: {
                        if (acceptableInput) {
                            intern.shiftSteps = text.split(",")
                                .map((step) => step.trim())
                                .filter((step) => !!step)
                        }
                    }
                }
            }

            // Shift Config (Button)
            ListItem {
                Layout.fillWidth: true
                divider.visible: false

                ListItemLayout {
                    title.text: tr.get("ShiftConfig")
                    subtitle.text: tr.get("EditShiftInfo")

                    Icon {
                        SlotsLayout.position: SlotsLayout.Trailing
                        width: units.gu(3)
                        height: width
                        name: "go-next"
                        asynchronous: true
                    }
                }

                onClicked: {
                    for (let step of JSON.parse(ctxObject.shiftHandler.qmlGetSteps())) {
                        if (!ctxObject.shiftHandler.shiftsConfig.exists(step))
                            ctxObject.shiftHandler.shiftsConfig.append(step, "", 0, false)
                    }

                    stack.push(Qt.resolvedUrl("../edit-shifts/page.qml"))
                }
            }

            // Enable/Disable Grid Border (Checkbox)
            ListItem {
                Layout.fillWidth: true
                divider.visible: false

                onClicked: {
                    gridBorderCheckBox.checked = !gridBorderCheckBox.checked
                }

                ListItemLayout {
                    title.text: tr.get("GridBorder")

                    CheckBox {
                        id: gridBorderCheckBox

                        SlotsLayout.position: SlotsLayout.Trailing

                        onCheckedChanged: ctxObject.gridBorder = checked
                        Component.onCompleted: checked = ctxObject.gridBorder
                    }
                }
            }

            // Enable/Disable Shift Border
            ListItem {
                Layout.fillWidth: true
                divider.visible: false

                onClicked: {
                    shiftBorderCheckBox.checked = !shiftBorderCheckBox.checked
                }

                ListItemLayout {
                    title.text: tr.get("ShiftBorder")

                    CheckBox {
                        id: shiftBorderCheckBox

                        SlotsLayout.position: SlotsLayout.Trailing

                        onCheckedChanged: ctxObject.shiftBorder = checked
                        Component.onCompleted: checked = ctxObject.shiftBorder
                    }
                }
            }

            // Theme Selection Item
            ColumnLayout {
                Layout.fillWidth: true
                Layout.margins: units.gu(2)
                spacing: units.gu(0.75)

                ColumnLayout {
                    Layout.fillWidth: true

                    Label {
                        text: tr.get("Theme")
                        textSize: Label.Medium
                    }
                }

                OptionSelector {
                    id: themeSelector

                    model: [
                        "System",
                        "Ubuntu.Components.Themes.Ambiance",
                        "Ubuntu.Components.Themes.SuruDark"
                    ]


                    Layout.fillWidth: true
                    selectedIndex: ctxObject.theme === "" ? 0 : model.indexOf(ctxObject.theme)

                    onDelegateClicked: {
                        let selectedTheme = model[index]
                        if (selectedTheme === "System") selectedTheme = ""
                        ctxObject.theme = selectedTheme
                        theme.name = ctxObject.theme
                    }
                }
            }
        }
    }

    QtObject {
        id: intern

        // to prevent `onShiftStepsChanged` from saving while `onCompleted` is running
        property bool _save: false

        property var startDate: ({ "year": 0, "month": 0, "day": 0 })

        property var shiftSteps: []
        onShiftStepsChanged: {
            if (_save) { // update the backend
                const err = ctxObject.shiftHandler.qmlSetSteps(JSON.stringify(shiftSteps))
                if (err) console.error()
            }
        }

        function load() {
            _save = false

            startDate = ctxObject.shiftHandler.startDate
            settingsStartYear.text = startDate.year   // TextField
            settingsStartMonth.text = startDate.month // TextField
            settingsStartDay.text = startDate.day     // TextField

            shiftSteps = JSON.parse(ctxObject.shiftHandler.qmlGetSteps())
            settingsShiftSteps.text = shiftSteps.join(",") // TextField - NOTE: will be replaced with the edit-shift-rhythm component 

            _save = true
        }

        Quick.Component.onCompleted: laod()
    }
}
