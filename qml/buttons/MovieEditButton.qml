import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 2.15
import Qt5Compat.GraphicalEffects

//https://fonts.google.com/icons?selected=Material+Icons&icon.query=dots

Item {
    id: movieEditButton
    width: 40
    height: 30

    Rectangle {
        id: movieEditButtonBackground
        anchors.fill: parent
        color: "black"
        opacity: 0.25
        radius: 5
    }

    Rectangle {
        id: movieEditButtonFill
        anchors.fill: parent
        color: "white"
        opacity: 0.0
        radius: 5
    }

    Image {
        id: movieEditButtonIcon
        width: 20
        height: 20
        anchors {
            verticalCenter: parent.verticalCenter
            horizontalCenter: parent.horizontalCenter
        }
        source: "../../images/svg_images/edit.svg"
        sourceSize {
            width: 20
            height: 20
        }
        fillMode: Image.PreserveAspectFit

        ColorOverlay {
            id: movieEditButtonIconColor
            anchors.fill: parent
            source: parent
            color: "#d8d8d8"
        }
    }

    MouseArea {
        id: movieEditButtonMouseArea
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        hoverEnabled: true

        states: [
            State {
                name: "default"
                PropertyChanges {target: movieEditButtonFill; opacity: 0.0}
            },
            State {
                name: "hovered"
                PropertyChanges {target: movieEditButtonFill; opacity: 0.3}
            }
        ]

        transitions: [
            Transition {
                from: "default"
                to: "hovered"
                NumberAnimation {properties: "opacity"; duration: 50; easing.type: Easing.InQuad}
            },
            Transition {
                from: "hovered"
                to: "default"
                NumberAnimation {properties: "opacity"; duration: 50; easing.type: Easing.OutQuad}
            }
        ]

        onEntered: {
            movieEditButtonMouseArea.state = "hovered";
        }

        onExited: {
            movieEditButtonMouseArea.state = "default";
        }
    }
}
