import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 2.15
import Qt5Compat.GraphicalEffects

Item {
  property string imageSource
  property int imageSourceWidth
  property int imageSourceHeight
  property string title
  property string year

  property alias moviesCardClicked: cardMouseAreaOuter
  property alias moviesTitleClicked: movieTitleMouseArea
  property alias moviesSelectClicked: cardIconSelectMouseArea
  property alias moviesEditClicked: cardIconEditMouseArea
  property alias moviesMoreClicked: cardIconMoreMouseArea

  id: fullContainer
  width: imageSourceWidth
  height: imageSourceHeight + 30 + 20  // bottom labels

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
        id: cardIconSelectMouseArea
        width: cardIconSelectContainer.width
        height: cardIconSelectContainer.height
        anchors {
          top: parent.top
          left: parent.left
        }
        cursorShape: Qt.PointingHandCursor
        hoverEnabled: true
        onEntered: {iconSelectHovered.start()}
        onExited: {iconSelectUnhovered.start()}

        NumberAnimation {
          id: iconSelectHovered
          target: cardIconSelect
          properties: "opacity"
          from: 0.75
          to: 1.0
          duration: 200
          easing {type: Easing.InQuad}
        }

        NumberAnimation {
          id: iconSelectUnhovered
          target: cardIconSelect
          properties: "opacity"
          from: 1.0
          to: 0.75
          duration: 200
          easing {type: Easing.OutQuad}
        }
      }

      MouseArea {
        id: cardIconEditMouseArea
        width: cardIconEditContainer.width
        height: cardIconEditContainer.height
        anchors {
          bottom: parent.bottom
          left: parent.left
        }
        cursorShape: Qt.PointingHandCursor
        hoverEnabled: true
        onEntered: {iconEditHovered.start()}
        onExited: {iconEditUnhovered.start()}

        NumberAnimation {
          id: iconEditHovered
          target: cardIconEdit
          properties: "opacity"
          from: 0.75
          to: 1.0
          duration: 200
          easing {type: Easing.InQuad}
        }

        NumberAnimation {
          id: iconEditUnhovered
          target: cardIconEdit
          properties: "opacity"
          from: 1.0
          to: 0.75
          duration: 200
          easing {type: Easing.OutQuad}
        }
      }

      MouseArea {
        id: cardIconMoreMouseArea
        width: cardIconMoreContainer.width
        height: cardIconMoreContainer.height
        anchors {
          bottom: parent.bottom
          right: parent.right
        }
        cursorShape: Qt.PointingHandCursor
        hoverEnabled: true
        onEntered: {iconMoreHovered.start()}
        onExited: {iconMoreUnhovered.start()}

        NumberAnimation {
          id: iconMoreHovered
          target: cardIconMore
          properties: "opacity"
          from: 0.75
          to: 1.0
          duration: 200
          easing {type: Easing.InQuad}
        }

        NumberAnimation {
          id: iconMoreUnhovered
          target: cardIconMore
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

      Item {
        id: cardIconSelectContainer
        width: 35
        height: 35
        anchors {
          top: parent.top
          left: parent.left
        }

        Image {
          id: cardIconSelect
          anchors {
            centerIn: parent
          }
          source: "../../images/svg_images/circle_open.svg"
          sourceSize {
            width: 24
            height: 24
          }
          scale: 0.85
          opacity: 0.75
        }
      }

      Item {
        id: cardIconEditContainer
        width: 35
        height: 35
        anchors {
          bottom: parent.bottom
          left: parent.left
        }

        Image {
          id: cardIconEdit
          anchors {
            centerIn: parent
          }
          source: "../../images/svg_images/edit.svg"
          sourceSize {
            width: 24
            height: 24
          }
          scale: 0.90
          opacity: 0.75
        }
      }

      Item {
        id: cardIconMoreContainer
        width: 35
        height: 35
        anchors {
          bottom: parent.bottom
          right: parent.right
        }

        Image {
          id: cardIconMore
          anchors {
            centerIn: parent
          }
          source: "../../images/svg_images/vert_dots.svg"
          sourceSize {
            width: 24
            height: 24
          }
          scale: 1.0
          opacity: 0.75
        }
      }
    }
  }

  Label {
    id: movieTitle
    height: 15
    anchors {
      top: cardContainer.bottom
      left: parent.left
      topMargin: 15
    }
    text: title
    color: "white"
    font {
      family: "Arial"
      pixelSize: 13
      weight: Font.DemiBold
      underline: false
    }
    verticalAlignment: Text.AlignVCenter
    elide: Label.ElideRight
    Component.onCompleted: {
      if (movieTitle.paintedWidth >= imageSourceWidth) {
        width = imageSourceWidth
      }
      else {
        width = movieTitle.paintedWidth
      }
    }

    MouseArea {
      id: movieTitleMouseArea
      width: movieTitle.contentWidth
      height: movieTitle.contentWidth
      anchors {
        top: movieTitle.top
        horizontalCenter: movieTitle.horizontalCenter
      }
      cursorShape: Qt.PointingHandCursor
      hoverEnabled: true
      onEntered: {movieTitle.font.underline = true}
      onExited: {movieTitle.font.underline = false}
    }
  }

  Label {
    id: movieYear
    width: parent.width
    height: 15
    anchors {
      top: movieTitle.bottom
      left: cardContainer.left
      topMargin: 5
    }
    text: year
    color: "#d8d8d8"
    font {
      family: "Arial"
      pixelSize: 13
      weight: Font.Normal
    }
    verticalAlignment: Text.AlignVCenter
    opacity: 0.75
  }
}
