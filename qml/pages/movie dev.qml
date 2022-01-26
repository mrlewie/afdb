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
      spacing: 15

      Item {
        id: movieRootDetailsContainer
        implicitHeight: 450
        Layout.fillWidth: true

        GridLayout {
          id: movieDetailsGrid
          anchors.fill: parent
          columns: 2
          rows: 6
          flow: GridLayout.TopToBottom
          //Rectangle {anchors.fill: parent; color: "red"; opacity: 0.2}

          // details grid: cover image
          MovieCoverCard {
            id: movieDetailsCoverImage
            //Layout.minimumHeight: 416
            Layout.maximumHeight: 416
            Layout.fillWidth: false
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignTop
            Layout.margins: 15
            Layout.leftMargin: 25
            Layout.rowSpan: 6
            imageSource: "file:///" + movieModel.img_fcover_filename
            imageSourceWidth: 292
            imageSourceHeight: 416
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
            text: movieModel.iafd_title ? movieModel.iafd_title : movieModel.raw_title
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
              text: movieModel.iafd_year ? movieModel.iafd_year : movieModel.raw_year
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
              text: "X"
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
            Layout.maximumWidth: 500
            Layout.preferredHeight: 25
            Layout.fillWidth: true
            Layout.fillHeight: false
            Layout.margins: 15
            anchors {
              top: movieDetailsYearAgeRatingFlow.bottom
              topMargin: 10
            }
            spacing: 5
            visible: movieModel.iafd_acts != "" ? true : false

            Repeater {
              id: movieDetailsActsRepeater
              model: movieModel.iafd_acts.split(',')
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

            MoviePlayButton {
              iconPlayClicked.onClicked: {movieFunctions.open_movie(movieModel)}
            }

            MovieFolderButton {
              iconFolderClicked.onClicked: {movieFunctions.open_folder(movieModel)}
            }

            MovieWatchedButton {}

            MovieEditButton {}

            MovieMoreButton {}
          }

          // details grid: information
          Flow {
            id: movieDetailsInformationFlow
            Layout.minimumWidth: 350
            Layout.maximumWidth: 800
            Layout.minimumHeight: 0
            Layout.preferredHeight: movieDetailsInformationFlow.width > 704 ? 80 : 160 + 25  // works but a bit weak
            Layout.maximumHeight: 160 + 25  // works but a bit weak
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
              ["Length", movieModel.iafd_length],
              ["Directed by", movieModel.iafd_directors], // need lsit
              ["Distributor", movieModel.iafd_distributor],
              ["Studio", movieModel.iafd_studio],
              ["All-Girl", movieModel.iafd_all_girl],
              ["Compilation", movieModel.iafd_compilation],
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
            text: movieModel.iafd_synopsis ? movieModel.iafd_synopsis : movieModel.aebn_synopsis
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
            visible: movieDetailsSynopsisText.text ? true : false
          }
        }
      }

      Item {
        id: movieRootCastContainer
        implicitHeight: 225
        Layout.fillWidth: true

        ColumnLayout {
          id: moviCastColumnLayout
          anchors {
            fill: parent
          }
          spacing: 10

          Item {
            id: movieCastHeaderContainer
            Layout.minimumWidth: 250
            Layout.preferredHeight: 30
            Layout.fillWidth: true
            Layout.margins: 15
            Layout.leftMargin: 25
            Layout.alignment: Qt.AlignTop

            Label {
              id: movieCastHeaderLabel
              width: 100
              height: 30
              anchors {
                top: parent.top
                bottom: parent.bottom
                left: parent.left
              }
              text: "Cast"
              color: "#d8d8d8"
              font {
                family: "Arial"
                pixelSize: 18
                weight: Font.Bold
              }
              verticalAlignment: Text.AlignVCenter
            }

            // move to own component
            Image {
              id: movieCastHeaderRightButton
              width: 30
              height: 30
              anchors {
                top: parent.top
                bottom: parent.bottom
                right: parent.right
              }
              source: "../../images/svg_images/next.svg"
              sourceSize {
                width: 30
                height: 30
              }
              opacity: 0.25

              MouseArea {
                id: movieCastHeaderRightButtonMouseArea
                anchors {
                  fill: parent
                }

                onClicked: {
                  var arr = []
                  for (var i = 0; i < movieCastListView.count; i++) {
                    if (movieCastListView.itemAtIndex(i)) {
                      arr[i] = i
                    }
                  }
                  movieCastListView.positionViewAtIndex(arr.pop() - 3, ListView.Beginning)
                }
              }
            }

            // move to own component
            Image {
              id: movieCastHeaderLeftButton
              width: 30
              height: 30
              anchors {
                top: parent.top
                bottom: parent.bottom
                right: movieCastHeaderRightButton.left
                rightMargin: 5
              }
              source: "../../images/svg_images/prev.svg"
              sourceSize {
                width: 30
                height: 30
              }
              opacity: 0.25

              MouseArea {
                id: movieCastHeaderLeftButtonMouseArea
                anchors {
                  fill: parent
                }

                onClicked: {
                  var arr = []
                  for (var i = 0; i < movieCastListView.count; i++) {
                    if (movieCastListView.itemAtIndex(i)) {
                      arr[i] = i
                    }
                  }
                  movieCastListView.positionViewAtIndex(arr.reverse().pop() + 3, ListView.End)
                }
              }
            }
          }

          Rectangle{
            id: movieCastHeaderDivider
            implicitHeight: 1
            anchors {
              top: movieCastHeaderContainer.bottom
            }
            Layout.minimumWidth: 250
            Layout.fillWidth: true
            Layout.margins: 15
            Layout.leftMargin: 25
            Layout.alignment: Qt.AlignTop
            color: "#d8d8d8"
            opacity: 0.5
          }

          // USE A PATHVIEW THIS ALLOWS FOR ANIMATION DURING FLICKING
          ListView {
            id: movieCastListView
            height: 180
            Layout.fillWidth: true
            Layout.margins: 15
            Layout.leftMargin: 25
            Layout.alignment: Qt.AlignTop
            anchors {
              top: movieCastHeaderDivider.bottom
              topMargin: 10
            }
            orientation: Qt.Horizontal
            snapMode: ListView.SnapToItem
            spacing: 15
            clip: true
            interactive: false

            model: castModel
            delegate:

            MovieCastCard {
              id: movieCastCard
              anchors {
                top: movieCastHeaderDivider.bottom
              }
              imageSource: i_img_url
              imageSourceWidth: 100
              imageSourceHeight: 100
              firstName: i_name.split(' ').length < 2 ? i_name : i_name.substr(0, i_name.indexOf(' '))
              lastName: i_name.split(' ').length < 2 ? "" : i_name.substr(i_name.indexOf(' ') + 1)
              castCardContainerClicked.onClicked: {moviesModel.log('Clicked on cast card container!')}
              castCardIconClicked.onClicked: {moviesModel.log('Clicked on cast card icon!')}
              castNameClicked.onClicked: {moviesModel.log('Clicked on cast name!')}
            }
          }
        }
      }

      Item {
        id: movieRootScenesContainer
        implicitHeight: 450
        Layout.fillWidth: true

        ColumnLayout {
          id: moviScenesColumnLayout
          anchors {
            fill: parent
          }
          spacing: 10

          Item {
            id: movieScenesHeaderContainer
            Layout.minimumWidth: 250
            Layout.preferredHeight: 30
            Layout.fillWidth: true
            Layout.margins: 15
            Layout.leftMargin: 25
            Layout.alignment: Qt.AlignTop

            Label {
              id: movieScenesHeaderLabel
              width: 100
              height: 30
              anchors {
                top: parent.top
                bottom: parent.bottom
                left: parent.left
              }
              text: "Scenes"
              color: "#d8d8d8"
              font {
                family: "Arial"
                pixelSize: 18
                weight: Font.Bold
              }
              verticalAlignment: Text.AlignVCenter
            }
          }

          Rectangle{
            id: movieScenesHeaderDivider
            implicitHeight: 1
            anchors {
              top: movieScenesHeaderContainer.bottom
            }
            Layout.minimumWidth: 250
            Layout.fillWidth: true
            Layout.margins: 15
            Layout.leftMargin: 25
            Layout.alignment: Qt.AlignTop
            color: "#d8d8d8"
            opacity: 0.5
          }

          ListView {
            property var maxScenesWidth: 0

            id: movieScenesListView
            height: 420
            Layout.fillWidth: true
            Layout.margins: 15
            Layout.leftMargin: 25
            Layout.alignment: Qt.AlignTop
            anchors {
              top: movieScenesHeaderDivider.bottom
              topMargin: 10
            }
            orientation: Qt.Vertical
            snapMode: ListView.SnapToItem
            spacing: 0
            clip: true
            interactive: false

            model: scenesModel
            delegate:

            RowLayout {
              id: row
              height: 65
              anchors {
                left: parent.left
                right: parent.right
              }

              Label {
                id: sceneNumber
                width: 75
                height: 65
                text: i_scene_num //"Scene #"
                color: "white"
                font {
                  family: "Arial"
                  pixelSize: 14
                  weight: Font.Normal
                }
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
              }

              ListView {
                id: sceneCastListView
                width: i_scene_img_url.length * (45 + 7.5)
                //implicitWidth: movieScenesListView.maxScenesWidth
                Layout.minimumWidth: movieScenesListView.maxScenesWidth
                height: 65
                anchors {
                  left: sceneNumber.right
                  leftMargin: 30
                }
                orientation: Qt.Horizontal
                snapMode: ListView.SnapToItem
                spacing: 10


                model: i_scene_img_url
                delegate:

                MovieScenesCastCard {
                  id: movieScenesCastCard
                  anchors {
                    verticalCenter: parent.verticalCenter
                  }
                  imageSource: model.modelData
                  imageSourceWidth: 45
                  imageSourceHeight: 45
                  //firstName: i_name.split(' ').length < 2 ? i_name : i_name.substr(0, i_name.indexOf(' '))
                  //lastName: i_name.split(' ').length < 2 ? "" : i_name.substr(i_name.indexOf(' ') + 1)
                  //scenesCardContainerClicked.onClicked: {moviesModel.log('Clicked on cast card container!')}
                  //scenesCardIconClicked.onClicked: {moviesModel.log('Clicked on cast card icon!')}
                }

                Component.onCompleted: {
                  var newWidth = Math.max(sceneCastListView.width, movieScenesListView.maxScenesWidth)
                  movieScenesListView.maxScenesWidth = newWidth
                }
              }

              Flow {
                Layout.minimumWidth: 100
                Layout.maximumWidth: 250
                height: 65
                anchors {
                  left: sceneCastListView.right
                  leftMargin: 30
                }
                spacing: 3

                Repeater {
                  //id: movieDetailsActsRepeater
                  model: i_scene_acts
                  delegate:

                  MovieActTag {
                    //id: movieScenesActTag
                    actTagText: modelData
                    //scenesCardIconClicked.onClicked: {moviesModel.log('Clicked on cast card icon!')}
                  }
                }
              }

              // ListView {
              //   width: 200
              //   height: 65
              //   anchors {
              //     left: sceneCastListView.right
              //     leftMargin: 30
              //   }
              //   orientation: Qt.Horizontal
              //   snapMode: ListView.SnapToItem
              //   spacing: 3
              //
              //   model: i_scene_acts
              //   delegate:
              //
              //   MovieActTag {
              //     id: movieScenesActTag
              //     anchors {
              //       verticalCenter: parent.verticalCenter
              //     }
              //     actTagText: model.modelData
              //     //scenesCardIconClicked.onClicked: {moviesModel.log('Clicked on cast card icon!')}
              //   }
              //
              //   Rectangle {
              //     anchors.fill: parent
              //     opacity: 0.1
              //   }
              // }

            }
          }
        }
      }
    }
  }

  // set app background on load
  Component.onCompleted: {
    mainWindow.backgroundImageUrl = "file:///" + movieModel.img_fcover_filename
  }
}
