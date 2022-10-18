// NOTE: New Component!
import QtQuick 2.12

import Ubuntu.Components 1.3

Page {
    header: PageHeader {
        id: pageHeader
        title: tr.get("ShiftRhythm") // TODO: add tr?

        leadingActionBar.actions: [
            Components.Action {
                iconName: "back"
                onTriggered: {
                    stack.pop()
                }
            }
        ]
    }

    // TODO: drag'n'drop thing here...
    // ...
}
