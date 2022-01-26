import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 2.15
import Qt5Compat.GraphicalEffects

//https://fonts.google.com/icons?selected=Material+Icons&icon.query=dots

Item {
    property int inImageWidth: 100
    property int inImageHeight: 100
    property string inCastImageUrl: ""
    property string inCastName: ""

    id: card
    width: inImageWidth + 20
    height: inImageHeight + 50

    Row {
        id: cardRow

        // card image area border for hover
        Rectangle {
            id: cardBorder
            width: cardImageArea.width
            height: cardImageArea.height
            anchors.fill: cardImageArea
            color: "transparent"
            border.color: "#d05158"
            border.width: 2
            radius: width * 0.5
            opacity: 0.0
            z: 3
        }

        // card image area fill for hover
        Rectangle {
            id: cardFill
            width: cardImageArea.width
            height: cardImageArea.height
            anchors.fill: cardImageArea
            color: "black"
            radius: width * 0.5
            opacity: 0.0
            z: 2
        }

        // card image area drop shadow
        Rectangle {
            id: cardShadow
            width: cardImageArea.width
            height: cardImageArea.height
            anchors.fill: cardImageArea
            color: "black"
            radius: width * 0.5
            z:0

            // enable effects
            layer.enabled: true
            layer.effect:

            // drop shadow effect
            DropShadow {
                transparentBorder: true
                horizontalOffset: 1
                verticalOffset: 1
                radius: 10
                color: "#bc000000"
            }
        }

        // image area of cast card
        Rectangle {
            id: cardImageArea
            width: inImageWidth
            height: inImageHeight
            color: "grey"

            // enable effects for image
            layer.enabled: true
            layer.effect:

            // circular mask effect
            OpacityMask {
                maskSource: Rectangle {
                    width: cardImageArea.width
                    height: cardImageArea.height
                    radius: width * 0.5
                    visible: false
                    cache: true
                }
            }

            // cast member image
            Image {
                id: cardImage
                anchors.fill: parent
                source: inCastImageUrl
                opacity: 0.0
                fillMode: Image.PreserveAspectCrop
                smooth: true
                asynchronous: true
                cache: true

                // this doesnt seem to work on first download, only after in cache
                // fade in when completed
                Component.onCompleted: cardImageLoaded.start()

                // animation for image fade in on load
                NumberAnimation on opacity {
                    id: cardImageLoaded
                    from: 0.0
                    to: 1.0
                    duration: 100
                }

                // image mouse area
                MouseArea {
                    id: cardImageMouseArea
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    enabled: true
                    hoverEnabled: true

                    onEntered: {
                        cardEnteredShowBorder.start();
                        cardEnteredShowAreaFill.start();
                    }

                    onExited: {
                        cardExitedRemoveBorder.start();
                        cardExitedRemoveAreaFill.start();
                    }
                }

                // animation for showing border
                NumberAnimation {
                    id: cardEnteredShowBorder
                    targets: cardBorder
                    properties: "opacity"
                    to: 1.0
                    duration: 25
                    easing: {type: Easing.InQuad}
                }

                // animation for showing fill area
                NumberAnimation {
                    id: cardEnteredShowAreaFill
                    targets: cardFill
                    properties: "opacity"
                    to: 0.5
                    duration: 25
                    easing: {type: Easing.InQuad}
                }

                // animation for removing border
                NumberAnimation {
                    id: cardExitedRemoveBorder
                    targets: cardBorder
                    properties: "opacity"
                    to: 0.0
                    duration: 25
                    easing: {type: Easing.OutQuad}
                }

                // animation for removing border
                NumberAnimation {
                    id: cardExitedRemoveAreaFill
                    targets: cardFill
                    properties: "opacity"
                    to: 0.0
                    duration: 25
                    easing: {type: Easing.OutQuad}
                }
            }
        }

        // cast name
        Label {
            id: castName
            anchors {
                top: cardImageArea.bottom
                left: cardImageArea.left
                right: cardImageArea.right
                topMargin: 5
                leftMargin: 20
                rightMargin: 20
            }
            color: "#d8d8d8"
            text: inCastName
            font {
                family: "Arial"
                pixelSize: 13
                weight: Font.Medium
            }
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            elide: Label.ElideRight
            wrapMode: Text.WordWrap
        }
    }
}

/*##^##
Designer {
    D{i:0;height:100;width:100}D{i:1}
}
##^##*/
