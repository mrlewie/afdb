import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 2.15
import Qt5Compat.GraphicalEffects

import "../controls"
import "../components"

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

    // grid view
    GridView {
      id: moviesGridder
      width: parent.width
      height: parent.height
      anchors.fill: parent
      leftMargin: 20
      topMargin: 10
      cellWidth: imgWidth   + 30              // only way to space, 30 pixesl between
      cellHeight: imgHeight + (30 + 20) + 50  // only way to space, (title + year) + 50 pixels
      clip: true
      //cacheBuffer: 25000 // increase this to hold cards in memory longer
      model: moviesModel
      delegate: Loader {

        MoviesCoverCard {
          id: card
          imageSource: "file:///" + img_fcover_filename
          imageSourceWidth: imgWidth
          imageSourceHeight: imgHeight
          title: iafd_title ? iafd_title : raw_title
          year: iafd_year ? iafd_year : raw_year

          moviesCardClicked.onClicked: {
            castModel.get_cast(raw_folder)      // filter to cast of current movie
            scenesModel.get_scenes(raw_folder)  // filter to scenes of current movie
            moviesStackView.push("movie dev.qml", {'movieModel': model})  // move to movie page
          }

          moviesTitleClicked.onClicked: {
            castModel.get_cast(raw_folder)      // filter to cast of current movie
            scenesModel.get_scenes(raw_folder)  // filter to scenes of current movie
            moviesStackView.push("movie dev.qml", {'movieModel': model})  // move to movie page
          }

          moviesSelectClicked.onClicked: {
            moviesModel.log('Select clicked! todo...')
          }

          moviesEditClicked.onClicked: {
            moviesModel.log('Edit clicked! todo...')
          }

          moviesMoreClicked.onClicked: {
            moviesModel.log('Fetching metadata! todo...')
            moviesModel.sync_with_iafd_worker(index, raw_folder, raw_title, raw_year)
          }
        }
      }
    }
  }
}
