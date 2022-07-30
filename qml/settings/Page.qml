import QtQuick 2.12 as Quick
import QtQuick.Layouts 1.11 as Layouts

import Ubuntu.Components 1.3 as Components

Components.Page {
    header: Components.PageHeader {
        id: pageHeader
        title: tr.get("Settings")

        leadingActionBar.actions: [
            Components.Action {
                iconName: "back"
                onTriggered: {
                    const err = ctxObject.saveConfig()
                    if (err)
                        console.error()

                    stack.clear() // this will reload the main page with new settings
                    stack.push(Qt.resolvedUrl("../month/Page.qml"))
                }
            }
        ]
    }

    Components.ScrollView {
        id: settingsView

        anchors.top: pageHeader.bottom
        width: parent.width
        height: parent.height - pageHeader.height

        Layouts.ColumnLayout {
            spacing: units.gu(1.5)

            width: settingsView.width

            // Start Date (TextField: year, month, day)
            Components.ListItem { // <<-
                Layouts.Layout.fillWidth: true
                divider.visible: false

                Components.ListItemLayout {
                    title.text: tr.get("StartDate")
                    subtitle.text: tr.get("ShiftRhythmInfo")

                    Layouts.Layout.preferredWidth: parent.width

                    Layouts.RowLayout {
                        spacing: units.gu(0.5)

                        Components.TextField {
                            id: settingsStartYear
                            Layouts.Layout.preferredWidth: font.pixelSize * 6
                            hasClearButton: false
                            placeholderText: "YYYY"
                            inputMethodHints: Qt.ImhDigitsOnly
                            validator: Quick.IntValidator {
                                bottom: new Date().getFullYear() - 100
                                top: new Date().getFullYear() + 100
                            }

                            onTextChanged: {
                                if (acceptableInput) {
                                    intern.startDate.year = parseInt(text)
                                }
                            }
                        }

                        Components.TextField {
                            id: settingsStartMonth
                            Layouts.Layout.preferredWidth: font.pixelSize * 4
                            hasClearButton: false
                            placeholderText: "MM"
                            inputMethodHints: Qt.ImhDigitsOnly
                            validator: Quick.IntValidator {
                                bottom: 1
                                top: 12
                            }

                            onTextChanged: {
                                if (acceptableInput) {
                                    intern.startDate.month = parseInt(text)
                                }
                            }
                        }

                        Components.TextField {
                            id: settingsStartDay
                            Layouts.Layout.preferredWidth: font.pixelSize * 4
                            hasClearButton: false
                            placeholderText: "DD"
                            inputMethodHints: Qt.ImhDigitsOnly
                            validator: Quick.IntValidator {
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
            } // ->>

            // Shift Steps (TextField)
            Layouts.ColumnLayout { // <<-
                Layouts.Layout.fillWidth: true
                Layouts.Layout.margins: units.gu(2)
                spacing: units.gu(0.75)

                Layouts.ColumnLayout {
                    Layouts.Layout.fillWidth: true

                    Components.Label {
                        text: tr.get("ShiftRhythm")
                        textSize: Components.Label.Medium
                    }

                    Components.Label {
                        text: tr.get("ShiftRhythmInfo")
                        textSize: Components.Label.Small
                    }
                }

                Components.TextField {
                    id: settingsShiftSteps

                    Layouts.Layout.fillWidth: true

                    placeholderText: tr.get("CommaSeparatedString")
                    onTextChanged: {
                        if (acceptableInput) {
                            intern.shiftSteps = text.split(",")
                                .map((step) => step.trim())
                                .filter((step) => !!step)
                        }
                    }
                }
            } // ->>

            // Shift Config (Button)
            Components.ListItem { // <<-
                Layouts.Layout.fillWidth: true
                divider.visible: false

                Components.ListItemLayout {
                    title.text: tr.get("ShiftConfig")
                    subtitle.text: tr.get("EditShiftInfo")

                    Components.Icon {
                        Components.SlotsLayout.position: Components.SlotsLayout.Trailing
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

                    stack.push(Qt.resolvedUrl("./EditShiftPage.qml"))
                }
            } // ->>

            // Enable/Disable Grid Border (Checkbox)
            Components.ListItem { // <<-
                Layouts.Layout.fillWidth: true
                divider.visible: false

                onClicked: {
                    gridBorderCheckBox.checked = !gridBorderCheckBox.checked
                }

                Components.ListItemLayout {
                    title.text: tr.get("GridBorder")

                    Components.CheckBox {
                        id: gridBorderCheckBox

                        Components.SlotsLayout.position: Components.SlotsLayout.Trailing

                        onCheckedChanged: ctxObject.gridBorder = checked
                        Quick.Component.onCompleted: checked = ctxObject.gridBorder
                    }
                }
            } // ->>

            // Enable/Disable Shift Border
            Components.ListItem { // <<-
                Layouts.Layout.fillWidth: true
                divider.visible: false

                onClicked: {
                    shiftBorderCheckBox.checked = !shiftBorderCheckBox.checked
                }

                Components.ListItemLayout {
                    title.text: tr.get("ShiftBorder")

                    Components.CheckBox {
                        id: shiftBorderCheckBox

                        Components.SlotsLayout.position: Components.SlotsLayout.Trailing

                        onCheckedChanged: ctxObject.shiftBorder = checked
                        Quick.Component.onCompleted: checked = ctxObject.shiftBorder
                    }
                }
            } // ->>

            // Theme Selection Item
            Layouts.ColumnLayout { // <<-
                Layouts.Layout.fillWidth: true
                Layouts.Layout.margins: units.gu(2)
                spacing: units.gu(0.75)

                Layouts.ColumnLayout {
                    Layouts.Layout.fillWidth: true

                    Components.Label {
                        text: tr.get("Theme")
                        textSize: Components.Label.Medium
                    }
                }

                Components.OptionSelector {
                    id: themeSelector

                    model: [
                        "System",
                        "Ubuntu.Components.Themes.Ambiance",
                        "Ubuntu.Components.Themes.SuruDark"
                    ]


                    Layouts.Layout.fillWidth: true
                    selectedIndex: ctxObject.theme === "" ? 0 : model.indexOf(ctxObject.theme)

                    onDelegateClicked: {
                        let selectedTheme = model[index]
                        if (selectedTheme === "System") selectedTheme = ""
                        ctxObject.theme = selectedTheme
                        theme.name = ctxObject.theme
                    }
                }
            } // ->>
        }
    }

    Quick.QtObject { // <<- handle: startDate, shiftSteps
        id: intern

        // to prevent `onShiftStepsChanged` from saving while `onCompleted` is running
        property bool _save: false

        property var startDate: ({ "year": 0, "month": 0, "day": 0 })
        property var shiftSteps: []

        onShiftStepsChanged: {
            if (_save) {
                const err = ctxObject.shiftHandler.qmlSetSteps(JSON.stringify(shiftSteps))
                if (err) console.error()
            }
        }

        Quick.Component.onCompleted: {
            startDate = ctxObject.shiftHandler.startDate
            settingsStartYear.text = startDate.year
            settingsStartMonth.text = startDate.month
            settingsStartDay.text = startDate.day

            shiftSteps = JSON.parse(ctxObject.shiftHandler.qmlGetSteps())
            settingsShiftSteps.text = shiftSteps.join(",")

            _save = true
        }
    } // ->>
}
