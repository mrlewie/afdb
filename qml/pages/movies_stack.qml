import QtQuick 2.15
import QtQuick.Controls 2.15

// stackview object to handle movies -> movie
StackView {
  id: moviesStackView
  anchors.fill: parent
  initialItem: "movies.qml"
  clip: true
}

