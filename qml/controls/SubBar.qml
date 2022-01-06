import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 2.15
import Qt5Compat.GraphicalEffects

// sub bar of app that contains page resize
Rectangle {
    id: subBar
    height: 45
    anchors {
        top: parent.top
        left: parent.left
        right: parent.right
        topMargin: 5
        leftMargin: 5
        rightMargin: 5
    }
    color: "transparent"

    Rectangle {
        id: subBarContainer
        anchors.fill: parent
        color: "transparent"

        // left part of bar that has logo
        RowLayout {
            id: leftRowContainer
        }
    }
}

/*##^##
Designer {
    D{i:0;height:40;width:800}
}
##^##*/
