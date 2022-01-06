import QtQuick 2.0
import QtQuick.Controls 2.15

// stackview object to handle actors -> actor
StackView {
    id: actorsStackView
    anchors.fill: parent
    clip: true
    initialItem: "actors.qml"
}
