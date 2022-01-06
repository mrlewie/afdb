import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 2.15
import Qt5Compat.GraphicalEffects

//https://fonts.google.com/icons?selected=Material+Icons&icon.query=dots

MouseArea {
    property string inIconSource: ""
    property string inButtonText: ""
    property bool isPressed: false

    id: sideMenuButtonMouseArea
    height: 30
    anchors {
        left: parent.left
        right: parent.right
    }
    cursorShape: Qt.PointingHandCursor
    enabled: true
    hoverEnabled: true

    RowLayout {
        id: sideMenuButtonRowLayout
        anchors.fill: parent
        spacing: 15

        Rectangle {
            id: buttonHighlighter
            width: 2
            anchors {
                top : parent.top
                bottom: parent.bottom
                left: parent.left
            }
            color: "#d05158"
            opacity: isPressed ? 1.0 : 0.0
        }

        Image {
            id: buttonLeftIcon
            width: 24
            height: 24
            anchors {
                top : parent.top
                bottom: parent.bottom
                left: buttonHighlighter.right
                leftMargin: 8
            }
            source: inIconSource
            sourceSize {
                width: 24
                height: 24
            }
            fillMode: Image.PreserveAspectFit

            ColorOverlay {
                id: buttonLeftIconColor
                anchors.fill: buttonLeftIcon
                source: buttonLeftIcon
                color: "#d8d8d8"
            }
        }

        Label {
            id: buttonText
            anchors {
                top : parent.top
                bottom: parent.bottom
                left: buttonLeftIcon.right
                right: parent.right
                leftMargin: 15
            }
            text: inButtonText
            verticalAlignment: Text.AlignVCenter
            font {
                family: "Arial"
                pixelSize: 15
                weight: Font.DemiBold
            }
            color: "#d8d8d8"
        }
    }

    states: [
        State {
            name: "default"
            PropertyChanges {target: buttonHighlighter; color: "#d8d8d8"}
            PropertyChanges {target: buttonLeftIconColor; color: "#d8d8d8"}
            PropertyChanges {target: buttonText; color: "#d8d8d8"}
        },

        State {
            name: "contains"
            PropertyChanges {target: buttonHighlighter; color: "white"}
            PropertyChanges {target: buttonLeftIconColor; color: "white"}
            PropertyChanges {target: buttonText; color: "white"}
        },

        State {
            name: "clicked"
            PropertyChanges {target: buttonHighlighter; color: "#d05158"}
            PropertyChanges {target: buttonLeftIconColor; color: "#d05158"}
            PropertyChanges {target: buttonText; color: "#d05158"}
        },

        State {
            name: "reset"
            PropertyChanges {target: buttonHighlighter; color: "#d8d8d8"; opacity: 0.0}
            PropertyChanges {target: buttonLeftIconColor; color: "#d8d8d8"}
            PropertyChanges {target: buttonText; color: "#d8d8d8"}
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
            NumberAnimation {duration: 100; easing.type: Easing.InOutQuad}
        }
    ]

    onEntered: {
        sideMenuButtonMouseArea.state = "contains";
    }

    onExited: {
        if (isPressed == true) {
            sideMenuButtonMouseArea.state = "clicked";
        }
        else {
            sideMenuButtonMouseArea.state = "default";
        }
    }

    onClicked: {
        if (isPressed == false) {
            isPressed = true;
        }
    }

    function resetButton () {
        isPressed = false;
        sideMenuButtonMouseArea.state = "reset";
    }

}


/*##^##
Designer {
    D{i:0;formeditorZoom:2;height:30;width:200}
}
##^##*/
