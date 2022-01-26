import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 2.15
import Qt5Compat.GraphicalEffects

Rectangle {
  property alias iconPlayClicked: moviePlayButtonMouseArea

  id: moviePlayButton
  width: 80
  height: 30
  color: "#d05158"
  radius: 5

  Image {
    id: moviePlayButtonIcon
    width: 24
    height: 24
    anchors {
      top: parent.top
      bottom: parent.bottom
      left: parent.left
      leftMargin: 5
    }
    source: "../../images/svg_images/play.svg"
    sourceSize {
      width: 24
      height: 24
    }
    fillMode: Image.PreserveAspectFit

    ColorOverlay {
      id: moviePlayButtonIconColor
      anchors.fill: parent
      source: parent
      color: "black"
    }
  }

  Label {
    id: moviePlayButtonText
    anchors {
      top: parent.top
      bottom: parent.bottom
      left: moviePlayButtonIcon.right
      right: parent.right
      leftMargin: 5
    }
    text: "Play"
    color: "black"
    font {
      family: "Arial"
      pixelSize: 12
      weight: Font.Normal
      capitalization: Font.AllUppercase
    }
    verticalAlignment: Text.AlignVCenter
  }

  MouseArea {
    id: moviePlayButtonMouseArea
    anchors.fill: parent
    cursorShape: Qt.PointingHandCursor
    hoverEnabled: true

    states: [
    State {
      name: "default"
      PropertyChanges {target: moviePlayButton; color: "#d05158"}
    },
    State {
      name: "hovered"
      PropertyChanges {target: moviePlayButton; color: "#e5797f"}
    }
    ]

    transitions: [
    Transition {
      from: "default"
      to: "hovered"
      ColorAnimation {duration: 50; easing.type: Easing.InQuad}
    },
    Transition {
      from: "hovered"
      to: "default"
      ColorAnimation {duration: 50; easing.type: Easing.OutQuad}
    }
    ]

    onEntered: {
      moviePlayButtonMouseArea.state = "hovered";
    }

    onExited: {
      moviePlayButtonMouseArea.state = "default";
    }
  }
}
