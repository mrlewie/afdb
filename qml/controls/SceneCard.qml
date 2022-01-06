import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 2.15
import Qt5Compat.GraphicalEffects

Rectangle {
    property int inWidth: 50
    property int inHeight: 50
    property string inImageUrl: "../../../../Downloads/Hentai/6169c3d05523a.jpg"
    property string inName: ""

    //id: card
    width: inWidth
    height: inHeight
    color: "transparent"

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
        width: inWidth
        height: inHeight
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
            }
        }

        // cast member image
        Image {
            id: cardImage
            anchors.fill: parent
            source: inImageUrl
            opacity: 1.0
            fillMode: Image.PreserveAspectCrop
            smooth: true
            asynchronous: true
            cache: true

            // this doesnt seem to work on first download, only after in cache
            // fade in when completed
            //Component.onCompleted: cardImageLoaded.start()

            // animation for image fade in on load
            //NumberAnimation on opacity {
                //id: cardImageLoaded
                //from: 0.0
                //to: 1.0
                //duration: 100
            //}

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
}

/*##^##
Designer {
    D{i:0;formeditorZoom:2;height:50;width:50}
}
##^##*/
