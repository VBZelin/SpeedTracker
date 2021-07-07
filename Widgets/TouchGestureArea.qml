import QtQuick 2.15
import QtQuick.Controls 2.15

import ArcGIS.AppFramework 1.0

Rectangle {
    id: root

    property color shadowColor: colors.black_100

    property bool isPressed: state === "Pressed"
    property bool isEnabled: true

    property real normalOpacity: 0.0
    property real pressOpacity: 0.12

    signal clicked()
    signal hold()

    Item {
        anchors.fill: parent
    }

    Rectangle {
        id: background

        anchors.fill: parent

        radius: root.radius
        color: shadowColor
        opacity: 0
    }

    states: [
        State {
            name: "Pressed"

            PropertyChanges {
                target: background
                opacity: pressOpacity
            }
        }
    ]

    transitions: [
        Transition {
            from: "";
            to: "Pressed"

            OpacityAnimator {
                duration: constants.normalDuration
            }
        }
    ]

    MouseArea {
        anchors.fill: parent

        onPressed: {
            if (root.isEnabled)
                root.state = "Pressed";
        }

        onReleased: {
            if (root.isEnabled)
                root.state = "";
        }

        onClicked: {
            if (root.isEnabled)
                root.clicked();
        }

        onCanceled: {
            if (root.isEnabled)
                root.state = "";
        }

        onPressAndHold: {
            if (root.isEnabled)
                hold();
        }
    }
}
