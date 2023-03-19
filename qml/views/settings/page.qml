import QtQuick 2.12
import QtQuick.Layouts 1.11

import Lomiri.Components 1.3

Page {
    header: PageHeader {
        id: pageHeader
        title: tr.get("Settings")

        leadingActionBar.actions: [
            Action {
                iconName: "back"
                onTriggered: {
                    const err = ctxo.saveConfig()
                    if (err)
                        console.error()

                    //stack.clear() // this will reload the main page with new settings
                    //stack.push(Qt.resolvedUrl("../month/page.qml"))
                    stack.pop()
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
                    subtitle.text: tr.get("StartDateInfo")

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

            // Shift Rhythm
            ListItem {
                Layout.fillWidth: true
                divider.visible: false 

                ListItemLayout {
                    title.text: tr.get("ShiftRhythm")
                    subtitle.text: tr.get("ShiftRhythmInfo")

                    Icon {
                        SlotsLayout.position: SlotsLayout.Trailing
                        width: units.gu(3)
                        height: width
                        name: "go-next"
                        asynchronous: true
                    }
                }

                onClicked: {
                    stack.push(Qt.resolvedUrl("../edit-shift-rhythm/page.qml"))
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

                        onCheckedChanged: ctxo.gridBorder = checked
                        Component.onCompleted: checked = ctxo.gridBorder
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

                        onCheckedChanged: ctxo.shiftBorder = checked
                        Component.onCompleted: checked = ctxo.shiftBorder
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
                    selectedIndex: ctxo.theme === "" ? 0 : model.indexOf(ctxo.theme)

                    onDelegateClicked: {
                        let selectedTheme = model[index]
                        if (selectedTheme === "System") selectedTheme = ""
                        ctxo.theme = selectedTheme
                        theme.name = ctxo.theme
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

        function load() {
            _save = false

            startDate = ctxo.shiftHandler.startDate
            settingsStartYear.text = startDate.year   // TextField
            settingsStartMonth.text = startDate.month // TextField
            settingsStartDay.text = startDate.day     // TextField

            _save = true
        }

        Component.onCompleted: load()
    }
}
