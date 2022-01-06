import QtQuick 2.15
import QtQuick.Controls 2.15

Label {
    id: movieDetailsCoreSynopsisReadMoreButton
    text: "Read More"  // add icon
    color: "#d8d8d8"
    font {
        family: "Arial"
        pixelSize: 13
        weight: Font.Bold
        capitalization: Font.AllUppercase
    }
    opacity: 0.75
    verticalAlignment: Text.AlignVCenter

    MouseArea {
        id: movieDetailsCoreSynopsisReadMoreMouseArea
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        hoverEnabled: true

        states: [
            State {
                name: "default"
                PropertyChanges {
                    target: movieDetailsCoreSynopsisReadMoreButton
                    color: "#d8d8d8"
                    opacity: 0.75
                }
            },
            State {
                name: "hovered"
                PropertyChanges {
                    target: movieDetailsCoreSynopsisReadMoreButton
                    color: "white"
                    opacity: 1.0
                }
            }
        ]

        transitions: [
            Transition {
                from: "default"
                to: "hovered"
                ParallelAnimation {
                    ColorAnimation {duration: 50; easing.type: Easing.InQuad}
                    NumberAnimation {properties: "opacity"; duration: 50; easing.type: Easing.InQuad}
                }
            },
            Transition {
                from: "hovered"
                to: "default"
                ParallelAnimation {
                    ColorAnimation {duration: 50; easing.type: Easing.OutQuad}
                    NumberAnimation {properties: "opacity"; duration: 50; easing.type: Easing.OutQuad}
                }
            }
        ]

        onEntered: {
            movieDetailsCoreSynopsisReadMoreMouseArea.state = "hovered";
        }

        onExited: {
            movieDetailsCoreSynopsisReadMoreMouseArea.state = "default";
        }
    }
}
