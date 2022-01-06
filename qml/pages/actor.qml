import QtQuick 2.0
import QtQuick.Controls 2.15

Item {
    anchors.fill: parent

    Text {
        anchors.centerIn: parent
        text: "Whoaaaa!!!"
    }

    Button {
        id: testButton
        anchors.centerIn: parent
        text: "go back..."

        onClicked: {
            actorsStackView.pop()
        }

    }
}
