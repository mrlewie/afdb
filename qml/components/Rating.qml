import QtQuick 2.0
import Qt5Compat.GraphicalEffects

Row {
    property int currentClicked: -1

    id: ratingRow

    Repeater {
        id: ratingRepeater
        model: 5

        Item {
            id: starContainer
            width: 15
            height: 15

            Image {
                id: starIconSelected
                width: parent.width
                height: parent.height
                source: "../../images/svg_images/star_selected.svg"
                sourceSize {
                    width: parent.width
                    height: parent.height
                }
                opacity: index <= currentClicked ? 1.0 : 0.0

                ColorOverlay {
                    id: starIconSelectedColor
                    source: starIconSelected
                    color: "#d8d8d8"
                }
            }

            Image {
                id: starIconUnselected
                width: parent.width
                height: parent.height
                source: "../../images/svg_images/star_unselected.svg"
                sourceSize {
                    width: parent.width
                    height: parent.height
                }
                opacity: 1.0

                ColorOverlay {
                    id: starIconUnselectedColor
                    source: starIconUnselected
                    color: "#d8d8d8"
                }
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                hoverEnabled: true

                onClicked: {
                    currentClicked = index
                }
            }
        }
    }
}


