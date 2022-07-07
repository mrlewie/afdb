import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 2.15

//import QtLocation 5.8
//import QtPositioning 5.8

//import Qt5Compat.GraphicalEffects


//import "../buttons"
import "../controls"
//import "../components"
//import "../labels"
//import "../tags"

Item {
  //property variant movieModel

  id: homeContainer
  anchors.fill: parent

  SubBar {
    id: subBar

    // temp
    // Button {
    //   width: 75
    //   height: 25
    //   text: "Back"
    //   anchors {
    //     top: parent.top
    //     left: parent.left
    //   }
    //   onClicked: {
    //     //moviesStackView.pop()
    //     //mainWindow.backgroundImageUrl = ""
    //   }
    // }
  }

  ScrollView {
    id: homeScroller
    anchors {
      top: subBar.bottom
      left: parent.left
      right: parent.right
      bottom: parent.bottom
    }

    Rectangle {
      anchors.fill: parent
      color: "red"
      opacity: 0.5
    }

    Map {
        id: map
        anchors.fill: parent
        zoomLevel: (maximumZoomLevel - minimumZoomLevel)/2
        center {
            latitude: 59.9485
            longitude: 10.7686
        }
    }

  }
}
