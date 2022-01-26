import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 2.15

import "../buttons"

Item {
    id: topBar
    height: 45
    anchors {
        top: parent.top
        left: parent.left
        right: parent.right
        topMargin: 5
        leftMargin: 5
        rightMargin: 5
    }
    clip: true

    Rectangle {
        id: topBarFillColor
        anchors.fill: parent
        color: "black"
        radius: 5
        opacity: 0.15
    }

    RowLayout {
        id: topBarRow
        anchors {
            top: parent.top
            bottom: parent.bottom
            left: parent.left
            topMargin: 5
            bottomMargin: 5
            leftMargin: 10
        }
        clip: true
        spacing: 15

        GenericIconButton {
            id: topBarBurgerButton
            inIconSource: "../../images/svg_images/burger.svg"
            onClicked: {
                topBarBurgerButton.isPressed = false;  // override click event
            }
        }

        Label {
            id: topBarLogo
            anchors {
                top : parent.top
                bottom: parent.bottom
                topMargin: 5
                bottomMargin: 5
            }
            text: "AFDB"
            verticalAlignment: Text.AlignVCenter
            font {
                family: "Arial"
                pixelSize: 16
                weight: Font.Bold
            }
            color: "#d8d8d8"
        }

        // https://doc.qt.io/qt-5.12/qtlocation-places-items-searchbar-qml.html
        Item {
            width: 300
            anchors {
                top: parent.top
                bottom: parent.bottom
                topMargin: 5
                bottomMargin: 5
            }

            Rectangle {
                anchors.fill: parent
                color: "white"
                opacity: 0.10
                radius: 90
            }

            RowLayout {
                id: searchBar
                anchors.fill: parent

                Image {
                    id: searchButton
                    anchors {
                        left: parent.left
                        leftMargin: 5
                    }
                    source: "../../images/svg_images/search.svg"
                    sourceSize {
                        width: 16
                        height: 16
                    }
                }

                TextArea {
                    id: searchText
                    anchors {
                        left: searchButton.right
                        right: parent.right
                        leftMargin: 5
                        rightMargin: 10
                    }
                    color: "#d8d8d8"

                    background: Rectangle {
                        color: "transparent"
                    }

                }

            }
        }
    }
}
