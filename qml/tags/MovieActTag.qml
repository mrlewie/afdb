import QtQuick 2.15
import QtQuick.Controls 2.15
//import Qt5Compat.GraphicalEffects

Label {
    property string actTagText

    id: actTag
    topPadding: 1
    bottomPadding: 1
    leftPadding: 6
    rightPadding: 6
    text: actTagText
    font {
        family: "Arial"
        pixelSize: 12
        weight: Font.Normal
    }
    color: "#d8d8d8"
    verticalAlignment: Text.AlignVCenter

    background: Rectangle {
        id: actTagBackgroundColor
        color: "black"
        opacity: 0.25
        radius: 90
    }

    MouseArea {
        id: actTagMouseArea
        anchors.fill: actTagBackgroundColor
        cursorShape: Qt.PointingHandCursor
        hoverEnabled: true

        states: [
            State {
                name: "default"
                PropertyChanges {target: actTagBackgroundColor; color: "black"}
            },
            State {
                name: "hovered"
                PropertyChanges {target: actTagBackgroundColor; color: "#e5797f"}
            }
        ]

        transitions: [
            Transition {
                from: "default"
                to: "hovered"
                ColorAnimation {duration: 50; easing.type: Easing.InQuad}
            },
            Transition {
                from: "hovered"
                to: "default"
                ColorAnimation {duration: 50; easing.type: Easing.OutQuad}
            }
        ]

        onEntered: {
            actTagMouseArea.state = "hovered";
        }

        onExited: {
            actTagMouseArea.state = "default";
        }
    }
}
