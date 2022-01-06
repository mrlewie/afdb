import QtQuick 2.0
import QtQuick.Controls 2.15

Rectangle {
    anchors.fill: parent
    color: "transparent"

    Button {
        id: testButton1
        anchors.centerIn: parent
        text: "actors!"

        onClicked: {
            actorsStackView.push("actor.qml")
        }
    }
}
