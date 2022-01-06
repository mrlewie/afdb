import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 2.15
import Qt5Compat.GraphicalEffects

//https://fonts.google.com/icons?selected=Material+Icons&icon.query=dots

MouseArea {
    property int inIconSize: 24
    property string inIconSource: ""
    property bool isPressed: false

    id: genericIconButtonMouseArea
    width: inIconSize
    height: inIconSize
    cursorShape: Qt.PointingHandCursor
    enabled: true
    hoverEnabled: true

    Image {
        id: genericIconButtonIcon
        anchors.fill: parent
        source: inIconSource
        sourceSize {
            width: 24
            height: 24
        }
        fillMode: Image.PreserveAspectFit

        ColorOverlay {
            id: genericIconButtonIconColor
            anchors.fill: genericIconButtonIcon
            source: genericIconButtonIcon
            color: "#d8d8d8"
        }
    }

    states: [
        State {
            name: "default"
            PropertyChanges {target: genericIconButtonIconColor; color: "#d8d8d8"}
        },

        State {
            name: "contains"
            PropertyChanges {target: genericIconButtonIconColor; color: "white"}
        },

        State {
            name: "clicked"
            PropertyChanges {target: genericIconButtonIconColor; color: "#d05158"}
        },

        State {
            name: "reset"
            PropertyChanges {target: genericIconButtonIconColor; color: "#d8d8d8"}
        }
    ]

    transitions: [
        Transition {
            from: "default"
            to: "contains"
            reversible: true
            ColorAnimation {duration: 100; easing.type: Easing.InOutQuad}
        },

        Transition {
            from: "clicked"
            to: "contains"
            reversible: true
            ColorAnimation {duration: 100; easing.type: Easing.InOutQuad}
        },

        Transition {
            to: "reset"
            reversible: true
            ColorAnimation {duration: 100; easing.type: Easing.InOutQuad}
        }
    ]

    onEntered: {
        genericIconButtonMouseArea.state = "contains";
    }

    onExited: {
        if (isPressed == true) {
            genericIconButtonMouseArea.state = "clicked";
        }
        else {
            genericIconButtonMouseArea.state = "default";
        }
    }

    onClicked: {
        if (isPressed == false) {
            isPressed = true;
        }
    }
}
