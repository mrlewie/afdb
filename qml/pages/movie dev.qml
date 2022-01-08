import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 2.15
import Qt5Compat.GraphicalEffects

import "../buttons"
import "../controls"
import "../components"
import "../labels"
import "../tags"

Item {
  property int inImageWidth: 584 / 4
  property int inImageHeight: 832 / 4

  id: movieContainer
  anchors.fill: parent

  SubBar {
    id: subBar
  }

  ScrollView {
    id: movieScroller
    anchors {
      top: subBar.bottom
      left: parent.left
      right: parent.right
      bottom: parent.bottom
    }

    ColumnLayout {
      id: movieRootColumnContainer
      anchors.fill: parent
      spacing: 20
      //model: moviesModel
      //delegate: Loader {}

      Rectangle {
        id: movieRootDetailsContainer
        Layout.preferredHeight: 500
        //implicitHeight: 500  // need this... hence rectangle
        anchors.fill: parent
        color: "transparent"

        GridLayout {
          id: movieDetailsGrid
          anchors.fill: parent
          columns: 2
          rows: 5
          flow: GridLayout.TopToBottom
          Rectangle {anchors.fill: parent; color: "red"; opacity: 0.2}

          Image {
            id: movieDetailsCoverImage
            Layout.minimumWidth: 292
            Layout.maximumWidth: 292
            Layout.minimumHeight: 416
            Layout.maximumHeight: 416
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignTop
            Layout.margins: 15
            Layout.rowSpan: 5
            source: "file:///" + "g:/Images/Covers/134569.jpg"
            sourceSize {
              width: 292
              height: 416
            }
            fillMode: Image.Pad
            smooth: true
            asynchronous: true
            cache: true
          }

          Label {
            id: movieDetailsMainTitleLabel
            Layout.preferredHeight: 25
            Layout.fillWidth: true
            Layout.fillHeight: false
            Layout.alignment: Qt.AlignTop
            Layout.margins: 15
            Layout.topMargin: 25
            text: "Latina Anal Heartbreakers and Other Dirty Butt Fucking Sluts 2: The Revenge"   //i_title ? i_title : r_title
            color: "white"
            font {
              family: "Arial"
              pixelSize: 24
              weight: Font.Bold
            }
            verticalAlignment: Text.AlignVCenter
            elide: Label.ElideRight
            Rectangle {anchors.fill: parent; color: "red"; opacity: 0.2}
          }

          Flow {
            id: movieDetailsYearAgeRatingFlow
            Layout.preferredHeight: 25
            Layout.fillWidth: true
            Layout.fillHeight: false
            Layout.margins: 15
            anchors {
              top: movieDetailsMainTitleLabel.bottom
              topMargin: 10
            }
            spacing: 25

            Label {
              id: movieDetailsYearLabel
              height: 25
              text: "2002" //i_year ? i_year : r_year
              color: "white"
              font {
                family: "Arial"
                pixelSize: 18
                weight: Font.Bold
              }
              verticalAlignment: Text.AlignVCenter
            }

            Label {
              id: movieDetailsAgeLabel
              height: 25
              leftPadding: 8
              rightPadding: 8
              text: "X" //i_age ? i_age : r_age
              color: "white"
              font {
                family: "Arial"
                pixelSize: 14
                weight: Font.Bold
              }
              verticalAlignment: Text.AlignVCenter
              background: Rectangle {
                color: "black"
                opacity: 0.4
                radius: 5
              }
            }

            Rating {
              id: movieDetailsRatingWidget
              starSize: 23
              starScale: 0.75
              currentClicked: 2   //i_rating ? i_rating : i_rating
            }
          }

          Flow {
            id: movieDetailsActsFlow
            Layout.preferredHeight: 25
            Layout.fillWidth: true
            Layout.fillHeight: false
            Layout.margins: 15
            anchors {
              top: movieDetailsYearAgeRatingFlow.bottom
              topMargin: 10
            }
            spacing: 3

            Repeater {
              id: movieDetailsActsRepeater
              model: [{"act": "Anal"}, {"act": "Double Anal"}, {"act": "Double Penetration"}, {"act": "Facial"}]  // do pyside
              delegate: MovieActTag {actTagText: modelData.act}
            }
          }
        }
      }
    }
  }
}
