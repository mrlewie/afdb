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
  property variant movieModel

  id: movieContainer
  anchors.fill: parent

  SubBar {
    id: subBar

    // temp
    Button {
      width: 75
      height: 25
      text: "Back"
      anchors {
        top: parent.top
        left: parent.left
      }
      onClicked: {
        moviesStackView.pop()
        mainWindow.backgroundImageUrl = ""
      }
    }
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

      Rectangle {
        id: movieRootDetailsContainer
        Layout.preferredHeight: 450
        anchors.fill: parent
        color: "transparent"

        GridLayout {
          id: movieDetailsGrid
          anchors.fill: parent
          columns: 2
          rows: 6
          flow: GridLayout.TopToBottom
          //Rectangle {anchors.fill: parent; color: "red"; opacity: 0.2}

          // details grid: cover image
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
            Layout.leftMargin: 25
            Layout.rowSpan: 6
            source: "file:///" + movieModel.r_img_cover
            sourceSize {
              width: 292
              height: 416
            }
            fillMode: Image.Pad
            smooth: true
            asynchronous: true
            cache: true
          }

          // details grid: title
          Label {
            id: movieDetailsMainTitleLabel
            Layout.minimumWidth: 250
            Layout.maximumWidth: 800
            Layout.preferredHeight: 25
            Layout.fillWidth: true
            Layout.fillHeight: false
            Layout.alignment: Qt.AlignTop
            Layout.margins: 15
            Layout.topMargin: 25
            text: movieModel.i_title ? movieModel.i_title : movieModel.r_title
            color: "white"
            font {
              family: "Arial"
              pixelSize: 24
              weight: Font.Bold
            }
            verticalAlignment: Text.AlignVCenter
            elide: Label.ElideRight
            //Rectangle {anchors.fill: parent; color: "red"; opacity: 0.2}
          }

          // details grid: year, age, rating
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
              text: movieModel.i_year ? movieModel.i_year : movieModel.r_year
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

          // details grid: acts
          Flow {
            id: movieDetailsActsFlow
            Layout.minimumWidth: 250
            Layout.maximumWidth: 400
            Layout.preferredHeight: 25
            Layout.fillWidth: true
            Layout.fillHeight: false
            Layout.margins: 15
            anchors {
              top: movieDetailsYearAgeRatingFlow.bottom
              topMargin: 10
            }
            spacing: 5
            visible: movieModel.i_acts != "" ? true : false

            Repeater {
              id: movieDetailsActsRepeater
              model: movieModel.i_acts.split(', ')
              delegate: MovieActTag {actTagText: modelData}
            }
          }

          // details grid: play, watched, favourite, edit, more
          Flow {
            id: movieDetailsButtonsFlow
            Layout.minimumWidth: 250
            Layout.preferredHeight: 35
            Layout.fillWidth: true
            Layout.fillHeight: false
            Layout.margins: 15
            anchors {
              top: movieDetailsActsFlow.bottom
              topMargin: 25
            }
            spacing: 10

            MoviePlayButton {}

            MovieWatchedButton {}

            MovieEditButton {}

            MovieMoreButton {}
          }

          Flow {
            id: movieDetailsInformationFlow
            Layout.minimumWidth: 350
            Layout.maximumWidth: 800
            Layout.minimumHeight: 0
            Layout.maximumHeight: 80
            Layout.fillWidth: true
            Layout.fillHeight: false
            Layout.margins: 15
            anchors {
              top: movieDetailsButtonsFlow.bottom
              topMargin: 25
            }
            flow: Flow.LeftToRight
            spacing: 5

            Repeater {
              id: movieDetailsInformationRepeater
              model: [
                ["Length", "todo"],
                ["Directed by", "to, do".split(', ')],
                ["Distributor", movieModel.i_distributor],
                ["Studio", movieModel.i_distributor],
                ["All-Girl", "todo"],
                ["Compilation", movieModel.compilation],
                ["Video", "todo"],
                ["Audio", "todo"]
              ]
              delegate:

              Row {
                id: movieDetailsInformationRow

                Label {
                  id: movieDetailsInformationLabel
                  width: 125
                  height: 20
                  text: modelData[0]
                  color: "#d8d8d8"
                  font {
                    family: "Arial"
                    pixelSize: 12
                    weight: Font.Bold
                    capitalization: Font.AllUppercase
                  }
                  opacity: 0.75
                  verticalAlignment: Text.AlignVCenter
                  //background: Rectangle {anchors.fill: parent; color: "aqua"; opacity: 0.25}
                  visible: modelData[1] != "" ? true : false
                }

                Label {
                  id: movieDetailsInformationValue
                  width: 225
                  height: 20
                  text: modelData[1]
                  color: "white"
                  font {
                    family: "Arial"
                    pixelSize: 15
                    weight: Font.Normal
                  }
                  verticalAlignment: Text.AlignVCenter
                  //background: Rectangle {anchors.fill: parent; color: "aqua"; opacity: 0.25}
                  visible: modelData[1] != "" ? true : false
                }
              }
            }
          }

          // details grid: synopsis
          Text {
            id: movieDetailsSynopsisText
            Layout.minimumWidth: 0
            Layout.maximumWidth: 800
            Layout.minimumHeight: 0
            Layout.maximumHeight: 75
            Layout.fillWidth: true
            Layout.fillHeight: false
            Layout.margins: 15
            anchors {
              top: movieDetailsInformationFlow.bottom
              topMargin: 40 // huh? should it be 25?
            }
            text: movieModel.i_synopsis
            color: "white"
            font {
              family: "Arial"
              pixelSize: 15
              weight: Font.Normal
            }
            lineHeight: 1.5
            verticalAlignment: Text.AlignTop
            wrapMode: Text.WordWrap
            clip: true
            visible: movieModel.i_synopsis != "" ? true : false
          }

          MovieReadMoreButton {
            id: movieDetailsSynopsisExpandButton
            Layout.preferredWidth: 100
            Layout.preferredHeight: 20
            Layout.fillWidth: true
            Layout.fillHeight: false
            Layout.margins: 15
            anchors {
              top: movieDetailsSynopsisText.bottom
              left: movieDetailsSynopsisText.left
              topMargin: 2
            }
            visible: movieModel.i_synopsis != "" ? true : false
          }
        }
      }
    }
  }

  Component.onCompleted: {
    mainWindow.backgroundImageUrl = "file:///" + movieModel.r_img_cover  // set background image
  }
}
