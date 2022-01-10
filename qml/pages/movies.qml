import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 2.15
import Qt5Compat.GraphicalEffects

import "../controls"

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
      cellWidth: imgWidth   + 30  // only way to space
      cellHeight: imgHeight + 80  // only way to space
      clip: true
      //cacheBuffer: 25000 // increase this to hold cards in memory longer
      model: moviesModel
      delegate: Loader {

        MoviesCard {
          id: card
          inMovieTitle: i_title ? i_title : r_title
          inMovieYear: i_year ? i_year : r_year
          inImageSource: r_img_cover
          inImageWidth: imgWidth
          inImageHeight: imgHeight

          // mouse functions
          MouseArea {
            id: cardImageMouseArea
            anchors.fill: parent
            acceptedButtons: Qt.LeftButton | Qt.RightButton
            cursorShape: Qt.PointingHandCursor
            enabled: true

            // clicked on mouse area
            onClicked: {
              if (mouse.button == Qt.LeftButton) {

                // filter cast model to current movie
                castModel.get_cast(r_id)

                // filter scene model to current movie
                scenesModel.get_scenes(r_id)

                // move to movie page
                moviesStackView.push("movie dev.qml", {'movieModel': model})
              }
              else if (mouse.button == Qt.RightButton) {
                moviesModel.sync_with_iafd_worker(index, r_id, r_title, r_year)
              }
            }
          }
        }
      }
    }
  }

}
