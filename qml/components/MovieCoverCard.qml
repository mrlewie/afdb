import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 2.15
import Qt5Compat.GraphicalEffects

Item {
  property string imageSource
  property int imageSourceWidth
  property int imageSourceHeight

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
    radius: 5
    layer {
      enabled: imageSource == "file:///" | "" ? false : true
      effect: DropShadow {
        transparentBorder: true
        horizontalOffset: 2
        verticalOffset: 2
        radius: 10
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
          radius: 5
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
    anchors.fill: parent
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
    radius: 5
    opacity: 0.0

    Image {
      id: cardIcon
      width: 96
      height: 96
      anchors {
        centerIn: parent
      }
      source: "../../images/svg_images/zoom_in.svg"
      sourceSize {
        width: 96
        height: 96
      }
      opacity: 0.75
    }
  }
}
