import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 2.15
import Qt5Compat.GraphicalEffects

Item {
  property string imageSource
  property int imageSourceWidth
  property int imageSourceHeight
  property string firstName
  property string lastName

  property alias castCardContainerClicked: cardMouseAreaOuter
  property alias castCardIconClicked: cardIconMouseArea
  property alias castNameClicked: castNameMouseArea

  id: fullContainer
  width: imageSourceWidth
  height: imageSourceHeight + 20 + 40  // bottom labels

  Item {
    id: cardContainer
    width: imageSourceWidth
    height: imageSourceHeight

    Rectangle {
      id: cardDropShadow
      anchors {
        fill: parent
      }
      color: "#2b3547"
      opacity: 0.75
      radius: 90
      layer {
        enabled: imageSource ? true : false
        effect: DropShadow {
          transparentBorder: true
          horizontalOffset: 2
          verticalOffset: 2
          radius: 5
        }
      }
    }

    Image {
      id: cardImage
      anchors {
        fill: parent
      }
      source: imageSource
      sourceSize {
        width: imageSourceWidth
        height: imageSourceHeight
      }
      fillMode: Image.PreserveAspectCrop
      smooth: true
      asynchronous: true
      cache: true
      layer {
        enabled: true
        effect: OpacityMask {
          maskSource: Rectangle {
            width: cardImage.width
            height: cardImage.height
            radius: 90
            visible: false
          }
        }
      }
      Component.onCompleted: {cardImageLoaded.start()}

      NumberAnimation {
        id: cardImageLoaded
        target: cardImage
        properties: "opacity"
        from: 0.0
        to: 1.0
        duration: 75
        easing {type: Easing.InQuad}
      }
    }

    MouseArea {
      id: cardMouseAreaOuter
      anchors {
        fill: parent
      }
      cursorShape: Qt.PointingHandCursor
      hoverEnabled: true
      onEntered: {cardHovered.start()}
      onExited: {cardUnhovered.start()}

      NumberAnimation {
        id: cardHovered
        target: cardBorderFillIcons
        properties: "opacity"
        from: 0.0
        to: 1.0
        duration: 75
        easing {type: Easing.InQuad}
      }

      NumberAnimation {
        id: cardUnhovered
        target: cardBorderFillIcons
        properties: "opacity"
        from: 1.0
        to: 0.0
        duration: 75
        easing {type: Easing.OutQuad}
      }

      MouseArea {
        id: cardIconMouseArea
        width: cardIcon.width
        height: cardIcon.height
        anchors {
          centerIn: parent
        }
        cursorShape: Qt.PointingHandCursor
        hoverEnabled: true
        onEntered: {iconHovered.start()}
        onExited: {iconUnhovered.start()}

        NumberAnimation {
          id: iconHovered
          target: cardIcon
          properties: "opacity"
          from: 0.75
          to: 1.0
          duration: 200
          easing {type: Easing.InQuad}
        }

        NumberAnimation {
          id: iconUnhovered
          target: cardIcon
          properties: "opacity"
          from: 1.0
          to: 0.75
          duration: 200
          easing {type: Easing.OutQuad}
        }
      }
    }

    Rectangle {
      id: cardBorderFillIcons
      anchors {
        fill: parent
      }
      color: "#A6000000"
      border {
        width: 3
        color: "#d05158"
      }
      radius: 90
      opacity: 0.0

      Image {
        id: cardIcon
        width: 48
        height: 48
        anchors {
          centerIn: parent
        }
        source: "../../images/svg_images/southeast.svg"
        sourceSize {
          width: 48
          height: 48
        }
        opacity: 0.75
      }
    }
  }

  Item {
    id: nameContainer
    width: imageSourceWidth
    height: 60
    anchors {
      top: cardContainer.bottom
      topMargin: 10
    }

    Label {
      id: castFirstName
      height: 20
      anchors {
        top: cardContainer.bottom
        left: parent.left
        right: parent.right
      }
      text: firstName
      color: "white"
      font {
        family: "Arial"
        pixelSize: 13
        weight: Font.Normal
        underline: false
      }
      horizontalAlignment: Text.AlignHCenter
      verticalAlignment: Text.AlignTop
      elide: Label.ElideRight
    }

    Label {
      id: castLastName
      height: 40
      anchors {
        top: castFirstName.bottom
        left: parent.left
        right: parent.right
      }
      text: lastName
      color: "white"
      font {
        family: "Arial"
        pixelSize: 13
        weight: Font.Normal
        underline: false
      }
      horizontalAlignment: Text.AlignHCenter
      verticalAlignment: Text.AlignTop
      wrapMode: Text.WordWrap
      elide: Label.ElideRight
    }

    MouseArea {
      id: castNameMouseArea
      width: Math.max(castFirstName.contentWidth, castLastName.contentWidth)
      height: castFirstName.contentHeight + castLastName.contentHeight
      anchors {
        top: castFirstName.top
        horizontalCenter: nameContainer.horizontalCenter

      }
      cursorShape: Qt.PointingHandCursor
      hoverEnabled: true
      onEntered: {
        castFirstName.font.underline = true
        castLastName.font.underline = true
      }
      onExited: {
        castFirstName.font.underline = false
        castLastName.font.underline = false
      }
    }
  }
}
