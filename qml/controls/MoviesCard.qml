import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 2.15
import Qt5Compat.GraphicalEffects

//https://fonts.google.com/icons?selected=Material+Icons&icon.query=dots



// movie card that shows cover image, title and year
Rectangle {
    property string inMovieTitle: ""
    property string inMovieYear: ""
    property string inImageSource: ""
    property int inImageWidth: 146
    property int inImageHeight: 208
    property int inSourceWidth: 200
    property int inSourceHeight: 200

    id: card
    width: inImageWidth
    height: inImageHeight
    color: "transparent"

    // card image area border for hover
    Rectangle {
        id: cardImageAreaBorder
        width: parent.width
        height: parent.height
        anchors.fill: parent
        color: "transparent"
        border.color: "#d05158"
        border.width: 2
        radius: 3
        opacity: 0
        z: 2
    }

    // top row of card icons TODO not implemented yet
    Grid {
        id: cardHoverIconsTop
        columns: 3
        height: 35
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }
        opacity: 0.0
        z: 2

        Rectangle {color: "transparent"; width: 35; height: 35}

        Rectangle {color: "transparent"; width: parent.width - 70; height: 35}

        Rectangle {color: "transparent"; width: 35; height: 35}
    }

    // bottom row of card icons
    Grid {
        id: cardHoverIconsBottom
        columns: 3
        height: 35
        anchors {
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }
        opacity: 0.0
        z: 2

        Rectangle {
            id: editCell
            color: "transparent"
            width: 35
            height: 35

            Image {
                id: editIcon
                width: parent.width
                height: parent.height
                anchors.fill: parent
                source: "../../images/svg_images/edit.svg"
                sourceSize {
                    width: 24
                    height: 24
                }
                scale: 0.6
                antialiasing: true
                opacity: 0.7

                // edit icon mouse area
                MouseArea {
                    id: editIconMouseArea
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    enabled: true
                    hoverEnabled: true

                    onEntered: {
                        editIconEntered.start();
                    }

                    onExited: {
                        editIconExited.start();
                    }

                    //onClicked: editPopup.open() // see https://doc.qt.io/qt-5/qml-qtquick-controls2-popup.html

                }

                // testing
                Popup {
                    id: editPopup
                    width: Overlay.overlay.width / 1.3
                    height: Overlay.overlay.height / 1.3
                    anchors.centerIn: Overlay.overlay
                    modal: true
                    focus: true
                    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent

                    transformOrigin: Popup.Left

                    // dimming color
                    Overlay.modal: Rectangle {
                        color: "#80000000"
                    }

                    // animation on open
                    enter: Transition {
                        NumberAnimation { property: "opacity"; from: 0.0; to: 1.0}
                    }

                    // animation on exit
                    exit: Transition {
                        NumberAnimation { property: "opacity"; from: 1.0; to: 0.0}
                    }

                }

                // animation for mouse enter icon
                NumberAnimation {
                    id: editIconEntered
                    targets: editIcon
                    properties: "opacity"
                    to: 1.0
                    duration: 50
                    easing: {type: Easing.InQuad}
                }

                // animation for mouse exit icon
                NumberAnimation {
                    id: editIconExited
                    targets: editIcon
                    properties: "opacity"
                    to: 0.7
                    duration: 50
                    easing: {type: Easing.OutQuad}
                }
            }
        }

        Rectangle {color: "transparent"; width: parent.width - 70; height: 35}

        Rectangle {
            id: dotsCell
            color: "transparent"
            width: 35
            height: 35

            Image {
                id: dotsIcon
                width: parent.width
                height: parent.height
                anchors.fill: parent
                source: "../../images/svg_images/vert_dots.svg"
                sourceSize {
                    width: 24
                    height: 24
                }
                scale: 0.7
                antialiasing: true
                opacity: 0.7

                // edit icon mouse area
                MouseArea {
                    id: dotsIconMouseArea
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    enabled: true
                    hoverEnabled: true

                    onEntered: {
                        dotsIconEntered.start();
                    }

                    onExited: {
                        dotsIconExited.start();
                    }

                    //onClicked: dotsPopup.open() // see https://doc.qt.io/qt-5/qml-qtquick-controls2-popup.html
                }

                // animation for mouse enter icon
                NumberAnimation {
                    id: dotsIconEntered
                    targets: dotsIcon
                    properties: "opacity"
                    to: 1.0
                    duration: 50
                    easing: {type: Easing.InQuad}
                }

                // animation for mouse exit icon
                NumberAnimation {
                    id: dotsIconExited
                    targets: dotsIcon
                    properties: "opacity"
                    to: 0.7
                    duration: 50
                    easing: {type: Easing.OutQuad}

                }
            }
        }
    }

    // card image area fill for hover
    Rectangle {
        id: cardImageAreaFill
        width: parent.width
        height: parent.height
        anchors.fill: parent
        color: "black"
        opacity: 0
        z: 1
    }

    // card image area
    Rectangle {
        id: cardImageArea
        width: parent.width
        height: parent.height
        color: "transparent"

        // movie cover image
        Image {
            id: coverImage
            width: inImageWidth
            height: inImageHeight
            source: 'file:///' + inImageSource
            sourceSize {
                width: inSourceWidth
                height: inSourceHeight
            }
            fillMode: Image.PreserveAspectCrop
            smooth: true
            asynchronous: true
            cache: true

            Component.onCompleted: cardImageLoaded.start()

            // animation for image fade in on load
            NumberAnimation on opacity {
                id: cardImageLoaded
                from: 0.0
                to: 1.0
                duration: 100
            }

            // enable effects for image
            layer.enabled: true
            layer.effect:

            // round edge effect
            OpacityMask {
                maskSource: Rectangle {
                    width: cardImageArea.width
                    height: cardImageArea.height
                    radius: 3
                    visible: false
                }
            }

            // image mouse area
            MouseArea {
                id: imageMouseArea
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                enabled: true
                hoverEnabled: true

                onEntered: {
                    cardEnteredShowBarsAndBorder.start();
                    cardEnteredShowAreaFill.start();
                }

                onExited: {
                    if (editIconMouseArea.containsMouse) {
                    }
                    else if (dotsIconMouseArea.containsMouse) {
                    }
                    else if (editIcon.opacity == 0.7 & dotsIcon.opacity == 0.7) {
                        cardExitedShowBarsAndBorder.start();
                        cardExitedShowAreaFill.start();

                        cardExitedShowAreaFill
                    }
                    else {
                    }
                }
            }


            // animation for showing border and icon bars on card entered
            NumberAnimation {
                id: cardEnteredShowBarsAndBorder
                targets: [cardImageAreaBorder, cardHoverIconsTop, cardHoverIconsBottom]
                properties: "opacity"
                to: 1.0
                duration: 50
                easing: {type: Easing.InQuad}
            }

            // animation for showing dimming area file card entered
            NumberAnimation {
                id: cardEnteredShowAreaFill
                targets: cardImageAreaFill
                properties: "opacity"
                to: 0.5
                duration: 50
                easing: {type: Easing.InQuad}
            }

            // animation for showing border and icon bars on card exited
            NumberAnimation {
                id: cardExitedShowBarsAndBorder
                targets: [cardImageAreaBorder, cardHoverIconsTop, cardHoverIconsBottom]
                properties: "opacity"
                to: 0.0
                duration: 50
                easing: {type: Easing.OutQuad}

            }

            // animation for showing dimming area file card exited
            NumberAnimation {
                id: cardExitedShowAreaFill
                targets: cardImageAreaFill
                properties: "opacity"
                to: 0.0
                duration: 50
                easing: {type: Easing.OutQuad}
            }
        }

        // enable effects for card
        layer.enabled: true
        layer.effect:

        // drop shadow effect
        DropShadow {
            transparentBorder: true
            horizontalOffset: 2
            verticalOffset: 2
            radius: 10
            color: "#bc000000"
        }
    }

    // movie title label
    Label {
        id: cardTitle
        width: parent.width
        height: 10
        anchors {
            top: cardImageArea.bottom
            left: parent.left
            topMargin: 15
        }
        text: inMovieTitle
        color: "#d8d8d8"
        font {
            family: "Arial"
            pixelSize: 13
            weight: Font.Bold
        }
        verticalAlignment: Text.AlignVCenter
        elide: Label.ElideRight
        z: 1
    }

    // movie year label
    Label {
        id: cardYear
        width: parent.width
        height: 8
        anchors {
            top: cardTitle.bottom
            left: parent.left
            topMargin: 10
        }
        text: inMovieYear
        color: "#d8d8d8"
        font {
            family: "Arial"
            pixelSize: 12
            weight: Font.Normal
        }
        verticalAlignment: Text.AlignVCenter
        opacity: 0.6
    }


}

// THIS IS THE NEW CODE FOR MOVIES CARDS, BASED ON MOVIE CARD
// import QtQuick 2.15
// import QtQuick.Controls 2.15
// import QtQuick.Layouts 2.15
// import Qt5Compat.GraphicalEffects
//
// // details grid: cover image
// Item {
//   property string imageSource
//   property int imageSourceWidth
//   property int imageSourceHeight
//
//   id: movieCardContainer
//   width: imageSourceWidth
//   height: imageSourceHeight
//
//   Rectangle {
//     anchors.fill: movieDetailsCoverImage
//     color: "black"
//     opacity: 0.75
//     radius: 5
//     layer {
//       enabled: true
//       effect: DropShadow {
//         transparentBorder: true
//         horizontalOffset: 2
//         verticalOffset: 2
//         radius: 10
//       }
//     }
//   }
//
//   Image {
//     id: movieCardImage
//     anchors.fill: parent
//     source: imageSource
//     sourceSize {
//       width: imageSourceWidth
//       height: imageSourceHeight
//     }
//     fillMode: Image.PreserveAspectCrop
//     smooth: true
//     asynchronous: true
//     cache: true
//     layer {
//       enabled: true
//       effect: OpacityMask {
//         maskSource: Rectangle {
//           width: movieCardImage.width
//           height: movieCardImage.height
//           radius: 5
//           visible: false
//         }
//       }
//     }
//
//     //Component.onCompleted: cardImageLoaded.start()
//
//   }
//
//   MouseArea {
//     id: movieCardMouseAreaOuter
//     anchors.fill: parent
//     cursorShape: Qt.PointingHandCursor
//     hoverEnabled: true
//
//     MouseArea {
//       id: iconTopLeftMouseArea
//       width: 50
//       height: 50
//       anchors {
//         top: parent.top
//         left: parent.left
//       }
//       cursorShape: Qt.PointingHandCursor
//       hoverEnabled: true
//
//       //onClicked: {}
//     }
//   }
//
//   Rectangle {
//     id: movieCardBorderBorderFillIcons
//     anchors.fill: parent
//     color: "#A6000000"
//     border {
//       width: 3
//       color: "#d05158"
//     }
//     radius: 5
//     opacity: movieCardMouseAreaOuter.containsMouse ? 1.0 : 0.0
//
//     Item {
//       id: iconTopLeftContainer
//       width: 50
//       height: 50
//       anchors.fill: iconTopLeftMouseArea
//
//       Image {
//         id: iconTopLeft
//         anchors.centerIn: parent
//         source: "../../images/svg_images/edit.svg"
//         sourceSize {
//           width: 30
//           height: 30
//         }
//         opacity: iconTopLeftMouseArea.containsMouse ? 1.0 : 0.75
//       }
//     }
//   }
// }
