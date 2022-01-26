import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 2.15
import Qt5Compat.GraphicalEffects

Item {
  property alias iconFolderClicked: movieFolderButtonMouseArea

  id: movieFolderButton
  width: 40
  height: 30

  Rectangle {
    id: movieFolderButtonBackground
    anchors.fill: parent
    color: "black"
    opacity: 0.25
    radius: 5
  }

  Rectangle {
    id: movieFolderButtonFill
    anchors.fill: parent
    color: "white"
    opacity: 0.0
    radius: 5
  }

  Image {
    id: movieFolderButtonIcon
    width: 20
    height: 20
    anchors {
      verticalCenter: parent.verticalCenter
      horizontalCenter: parent.horizontalCenter
    }
    source: "../../images/svg_images/folder.svg"
    sourceSize {
      width: 20
      height: 20
    }
    fillMode: Image.PreserveAspectFit

    ColorOverlay {
      id: movieFolderButtonIconColor
      anchors.fill: parent
      source: parent
      color: "#d8d8d8"
    }
  }

  MouseArea {
    id: movieFolderButtonMouseArea
    anchors.fill: parent
    cursorShape: Qt.PointingHandCursor
    hoverEnabled: true

    states: [
    State {
      name: "default"
      PropertyChanges {target: movieFolderButtonFill; opacity: 0.0}
    },
    State {
      name: "hovered"
      PropertyChanges {target: movieFolderButtonFill; opacity: 0.3}
    }
    ]

    transitions: [
    Transition {
      from: "default"
      to: "hovered"
      NumberAnimation {properties: "opacity"; duration: 50; easing.type: Easing.InQuad}
    },
    Transition {
      from: "hovered"
      to: "default"
      NumberAnimation {properties: "opacity"; duration: 50; easing.type: Easing.OutQuad}
    }
    ]

    onEntered: {
      movieFolderButtonMouseArea.state = "hovered";
    }

    onExited: {
      movieFolderButtonMouseArea.state = "default";
    }
  }
}
