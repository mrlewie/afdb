import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 2.15

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
