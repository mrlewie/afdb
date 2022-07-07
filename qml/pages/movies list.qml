import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 2.15
import Qt5Compat.GraphicalEffects

import "../controls"
import "../components"
import "../tags"

Rectangle {
  property double inImageDivider: 3.5
  property int imgWidth: 584 / inImageDivider
  property int imgHeight: 832 / inImageDivider

  id: moviesContainer
  width: parent.width
  height: parent.height
  anchors.fill: parent
  color: "transparent"

  // sub bar
  SubBar {
    id: subBar
  }

  // scroll area for movies grid
  ScrollView {
    id: moviesScroller
    width: parent.width
    height: parent.height
    anchors {
      top: subBar.bottom
      left: parent.left
      right: parent.right
      bottom: parent.bottom
    }
    clip : true

    ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

    ListView {
      id: moviesList
      width: parent.width
      height: parent.height
      spacing: 5

      model: moviesModel
      delegate:

        Item {
          id: container
          width: parent.width
          height: 150

          Rectangle {
            id: background
            anchors.fill: parent
            color: "white"
            opacity: index % 2 == 0 ? 0.025 : 0.0
          }

          MovieCoverCard {
            id: movieCard
            anchors {
              left: parent.left
              leftMargin: 20
              verticalCenter: container.verticalCenter
            }
            imageSource: "file:///" + img_fcover_filename
            imageSourceWidth: 83
            imageSourceHeight: 119
          }

          Label {
            id: movieTitle
            width: 300
            height: 15
            anchors {
              top: movieCard.top
              left: movieCard.right
              topMargin: 5
              leftMargin: 20
            }
            text: iafd_title ? iafd_title : raw_title
            color: "white"
            font {
              family: "Arial"
              pixelSize: 15
              weight: Font.DemiBold
              underline: false
            }
            verticalAlignment: Text.AlignVCenter
            elide: Label.ElideRight
            // Component.onCompleted: {
            //   if (movieTitle.paintedWidth >= imageSourceWidth) {
            //     width = imageSourceWidth
            //   }
            //   else {
            //     width = movieTitle.paintedWidth
            //   }
            // }

            // MouseArea {
            //   id: movieTitleMouseArea
            //   width: movieTitle.contentWidth
            //   height: movieTitle.contentWidth
            //   anchors {
            //     top: movieTitle.top
            //     horizontalCenter: movieTitle.horizontalCenter
            //   }
            //   cursorShape: Qt.PointingHandCursor
            //   hoverEnabled: true
            //   onEntered: {movieTitle.font.underline = true}
            //   onExited: {movieTitle.font.underline = false}
            // }
          }

          Label {
            id: movieYear
            width: 20
            height: 13
            anchors {
              top: movieTitle.bottom
              left: movieCard.right
              topMargin: 5
              leftMargin: 20
            }
            text: iafd_year ? iafd_year : raw_year
            color: "#d8d8d8"
            font {
              family: "Arial"
              pixelSize: 13
              weight: Font.Normal
            }
            verticalAlignment: Text.AlignVCenter
            opacity: 0.75
          }

          Label {
            id: movieLength
            width: 20
            height: 13
            anchors {
              top: movieTitle.bottom
              left: movieYear.right
              topMargin: 5
              leftMargin: 20
            }
            text: iafd_length ? iafd_length : ""
            color: "#d8d8d8"
            font {
              family: "Arial"
              pixelSize: 13
              weight: Font.Normal
            }
            verticalAlignment: Text.AlignVCenter
            opacity: 0.75
          }

          Flow {
            id: movieActs
            width: 750
            height: 20
            anchors {
              top: movieYear.bottom
              left: movieCard.right
              topMargin: 5
              leftMargin: 20
            }
            spacing: 5
            visible: iafd_acts != "" ? true : false

            Repeater {
              id: movieActsRepeater
              model: iafd_acts.split(',')
              delegate: MovieActTag {actTagText: modelData}
            }
          }

          Text {
            id: movieSynopsis
            width: 750
            height: 45
            anchors {
              top: movieActs.bottom
              left: movieCard.right
              topMargin: 10
              leftMargin: 20
            }
            text: iafd_synopsis ? iafd_synopsis : aebn_synopsis
            color: "white"
            font {
              family: "Arial"
              pixelSize: 13
              weight: Font.Normal
            }
            elide: Label.ElideRight
            lineHeight: 1.5
            verticalAlignment: Text.AlignTop
            wrapMode: Text.WordWrap
            clip: true
          }

      }
    }

    // grid view
    // GridView {
    //   id: moviesGridder
    //   width: parent.width
    //   height: parent.height
    //   anchors.fill: parent
    //   leftMargin: 20
    //   topMargin: 10
    //   cellWidth: imgWidth   + 30              // only way to space, 30 pixesl between
    //   cellHeight: imgHeight + (30 + 20) + 50  // only way to space, (title + year) + 50 pixels
    //   clip: true
    //   //cacheBuffer: 25000 // increase this to hold cards in memory longer
    //   model: moviesModel
    //   delegate: Loader {
    //
    //     MoviesCoverCard {
    //       id: card
    //       imageSource: "file:///" + img_fcover_filename
    //       imageSourceWidth: imgWidth
    //       imageSourceHeight: imgHeight
    //       title: iafd_title ? iafd_title : raw_title
    //       year: iafd_year ? iafd_year : raw_year
    //
    //       moviesCardClicked.onClicked: {
    //         castModel.get_cast(raw_folder)      // filter to cast of current movie
    //         scenesModel.get_scenes(raw_folder)  // filter to scenes of current movie
    //         moviesStackView.push("movie dev.qml", {'movieModel': model})  // move to movie page
    //       }
    //
    //       moviesTitleClicked.onClicked: {
    //         castModel.get_cast(raw_folder)      // filter to cast of current movie
    //         scenesModel.get_scenes(raw_folder)  // filter to scenes of current movie
    //         moviesStackView.push("movie dev.qml", {'movieModel': model})  // move to movie page
    //       }
    //
    //       moviesSelectClicked.onClicked: {
    //         moviesModel.log('Select clicked! todo...')
    //       }
    //
    //       moviesEditClicked.onClicked: {
    //         moviesModel.log('Edit clicked! todo...')
    //       }
    //
    //       moviesMoreClicked.onClicked: {
    //         moviesModel.log('Fetching metadata! todo...')
    //         moviesModel.sync_with_iafd_worker(index, raw_folder, raw_title, raw_year)
    //       }
    //     }
    //   }
    // }
  }
}
