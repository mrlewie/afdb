import QtQuick 2.0
import Qt5Compat.GraphicalEffects

Row {
  property int starSize: 25
  property double starScale: 0.75
  property int currentClicked: -1

  id: ratingRow
  height: starSize

  Repeater {
    id: ratingRepeater
    model: 5

    Item {
      id: starContainer
      width: starSize
      height: starSize

      Image {
        id: starIconSelected
        width: starSize
        height: starSize
        source: "../../images/svg_images/star_selected.svg"
        sourceSize {
          width: starSize
          height: starSize
        }
        scale: starScale
        opacity: index <= currentClicked ? 1.0 : 0.0

        ColorOverlay {
          id: starIconSelectedColor
          source: starIconSelected
          color: "#d8d8d8"
        }
      }

      Image {
        id: starIconUnselected
        width: starSize
        height: starSize
        source: "../../images/svg_images/star_unselected.svg"
        sourceSize {
          width: starSize
          height: starSize
        }
        scale: starScale
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
