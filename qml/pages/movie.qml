import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 2.15
import Qt5Compat.GraphicalEffects

import "../controls"

Rectangle {
    property string r_id: ""
    //property string r_title
    property string r_year
    property string r_img_cover
    property string i_title
    property string i_year
    property string i_distributor
    property string i_studio
    //property string i_length
    property string i_compilation
    property string i_synopsis
    property string i_acts

    property int inImageWidth: 584 / 4
    property int inImageHeight: 832 / 4

    property int idx

    id: content
    anchors.fill: parent
    width: parent.width
    height: parent.height
    color: "transparent"

    // sub bar holding
    SubBar {
        id: subBar
    }

    //https://stackoverflow.com/questions/59853985/how-do-to-get-single-item-detail-page-from-listview-page-using-qml
    Item {
        anchors.fill: subBar

        ListView {
            anchors.fill: parent
            model: moviesModel.get(257)
            delegate:  Text {
                text: r_title
            }
        }


    }


    // scroll area
    ScrollView {
        id: movieScroller
        width: parent.width
        height: parent.height
        anchors {
            top: subBar.bottom
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }
        clip: true

        contentHeight: moviePane.height + moviePane.height + scenePane.height

        // modify scroll bar here
        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

        // previous button
        Button {
            id: prevButton
            text: "Back"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: -500
            anchors.horizontalCenterOffset: 750

            onClicked: {
                moviesStackView.pop()

                // update app background to empty cover
                mainWindow.backgroundImageUrl = ""
            }
        }

        // panel that holds top level movie info
        Rectangle {
            id: moviePane
            height: 620
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
            }
            color: "transparent"

            // movie cover
            MoviesCard {
                id: movieCard
                anchors {
                    top: parent.top
                    left: parent.left
                    topMargin : 20
                    leftMargin: 20
                }
                inImageWidth: 389
                inImageHeight: 555
                inImageSource: r_img_cover
                inSourceWidth: 750
                inSourceHeight: 750

                // mouse area
                // todo
            }

            // todo this could be column with 3 rows, when one missing, moves up
            // general metadata area
            Rectangle {
                id: generalMeta
                height: 100
                anchors {
                    top: parent.top
                    left: movieCard.right
                    right: parent.right
                    topMargin : 40
                    leftMargin: 40
                    rightMargin: 40
                }
                color: "transparent"

                // movie title value
                Label {
                    id: movieTitle
                    height: 40
                    anchors {
                        top: parent.top
                        left: parent.left
                        right: parent.right
                    }
                    text: i_title ? i_title : r_title
                    color: "#d8d8d8"
                    font {
                        family: "Arial"
                        pointSize: 24
                        weight: Font.Bold
                    }
                    verticalAlignment: Text.AlignVCenter
                    elide: Label.ElideRight
                }

                // movie year value
                Label {
                    id: movieYear
                    height: 30
                    anchors {
                        top: movieTitle.bottom
                        left: parent.left
                        right: parent.right
                    }
                    color: "#d8d8d8"
                    text: i_year ? i_year : r_year
                    font {
                        family: "Arial"
                        pointSize: 16
                        weight: Font.DemiBold
                    }
                    verticalAlignment: Text.AlignVCenter
                }

                // movie length value
                Label {
                    id: movieLength
                    height: 30
                    anchors {
                        top: movieYear.bottom
                        left: parent.left
                        right: parent.right
                    }
                    color: "#d8d8d8"
                    text: "1 hr 20 min"  // todo hook up
                    font {
                        family: "Arial"
                        pointSize: 14
                        weight: Font.Medium
                    }
                    verticalAlignment: Text.AlignVCenter
                }
            }

            // general movie buttons (play, bookmark)
            Rectangle {
                id: generalButtons
                height: 40
                anchors {
                    top: generalMeta.bottom
                    left: movieCard.right
                    right: parent.right
                    topMargin : 5
                    leftMargin: 40
                    rightMargin: 40
                }
                color: "transparent"

                // play button
                Button {
                    id: playButton
                    width: 70
                    anchors {
                        top: parent.top
                        bottom: parent.bottom
                        left: parent.left
                        topMargin: 7
                        bottomMargin: 7
                    }
                    text: "PLAY"
                    font {
                        family: "Arial"
                        pointSize: 16
                        weight: Font.Bold
                    }
                    flat: true

                    // button background
                    background: Rectangle {
                        color: "#d05158"
                        border.width: 0
                        radius: 5
                    }

                    onClicked: {
                        moviesModel.test("G:\\Film\\Complete", r_id, r_id)
                    }

                }
            }

            // detailed metadata area
            Rectangle {
                id: detailedMeta
                height: 125
                anchors {
                    top: generalButtons.bottom
                    left: movieCard.right
                    right: parent.right
                    topMargin: 5
                    leftMargin: 40
                    rightMargin: 40
                }
                color: "transparent"

                // directors label
                Label {
                    id: directorsLabel
                    width: 120
                    height: 25
                    anchors {
                        top: parent.top
                        left: parent.left
                    }
                    text: "Directors"
                    color: "#d8d8d8"
                    font {
                        family: "Arial"
                        pointSize: 12
                        weight: Font.Normal
                    }
                    verticalAlignment: Text.AlignVCenter
                }

                // directors value
                Label {
                    id: directorsValue
                    width: 500
                    height: 25
                    anchors {
                        top: parent.top
                        left: directorsLabel.right
                        leftMargin: 10
                    }
                    text: "Mike Cunt"
                    color: "#d8d8d8"
                    font {
                        family: "Arial"
                        pointSize: 12
                        weight: Font.Bold
                    }
                    verticalAlignment: Text.AlignVCenter
                }

                // studio label
                Label {
                    id: studioLabel
                    width: 120
                    height: 25
                    anchors {
                        top: directorsLabel.bottom
                        left: parent.left
                    }
                    text: "Studio"
                    color: "#d8d8d8"
                    font {
                        family: "Arial"
                        pointSize: 12
                        weight: Font.Normal
                    }
                    verticalAlignment: Text.AlignVCenter
                }

                // studio value
                Label {
                    id: studioValue
                    width: 500
                    height: 25
                    anchors {
                        top: directorsValue.bottom
                        left: studioLabel.right
                        leftMargin: 10
                    }
                    text: i_studio ? i_studio : i_distributor
                    color: "#d8d8d8"
                    font {
                        family: "Arial"
                        pointSize: 12
                        weight: Font.Bold
                    }
                    verticalAlignment: Text.AlignVCenter
                }

                // compilation label
                Label {
                    id: compilationLabel
                    width: 120
                    height: 25
                    anchors {
                        top: studioLabel.bottom
                        left: parent.left
                    }
                    text: "Compilation"
                    color: "#d8d8d8"
                    font {
                        family: "Arial"
                        pointSize: 12
                        weight: Font.Normal
                    }
                    verticalAlignment: Text.AlignVCenter
                }

                // compilation value
                Label {
                    id: compilationValue
                    width: 500
                    height: 25
                    anchors {
                        top: studioLabel.bottom
                        left: compilationLabel.right
                        leftMargin: 10
                    }
                    text: i_compilation ? i_compilation : ""
                    color: "#d8d8d8"
                    font {
                        family: "Arial"
                        pointSize: 12
                        weight: Font.Bold
                    }
                    verticalAlignment: Text.AlignVCenter
                }
            }

            // acts metadata area
            Column {
                id: actsMeta
                height: 75
                anchors {
                    top: detailedMeta.bottom
                    left: movieCard.right
                    right: parent.right
                    topMargin: 5
                    leftMargin: 40
                    rightMargin: 40
                }
                //spacing: 2

                // acts label
                Label {
                    id: actsLabel
                    width: parent.width
                    height: 25
                    anchors {
                        top: parent.top
                        left: parent.left
                        right: parent.right
                    }
                    text: "Acts"
                    color: "#d8d8d8"
                    font {
                        family: "Arial"
                        pointSize: 12
                        weight: Font.Normal
                    }
                    verticalAlignment: Text.AlignVCenter
                }

                // acts value
                Label {
                    id: actsValue
                    width: parent.width
                    //height: 75
                    anchors {
                        top: actsLabel.bottom
                        left: parent.left
                        right: parent.right
                    }
                    text: i_acts ? i_acts : ""
                    color: "#d8d8d8"
                    font {
                        family: "Arial"
                        pointSize: 12
                        weight: Font.Bold
                    }
                    verticalAlignment: Text.AlignVCenter
                    wrapMode: Text.WordWrap
                }
            }

            // synopsis metadata area  todo: this needs a bit more work!
            Column {
                id: synopsisMeta
                height: 100
                anchors {
                    top: actsMeta.bottom
                    bottom: movieCard.bottom
                    left: movieCard.right
                    right: parent.right
                    topMargin: 5
                    bottomMargin: 5
                    leftMargin: 40
                    rightMargin: 40
                }
                clip: true

                // synopsis label
                Label {
                    id: synopsisLabel
                    width: parent.width
                    height: 25
                    anchors {
                        top: parent.top
                        left: parent.left
                        right: parent.right
                    }
                    text: "Synopsis"
                    color: "#d8d8d8"
                    font {
                        family: "Arial"
                        pointSize: 12
                        weight: Font.Normal
                    }
                    verticalAlignment: Text.AlignVCenter
                }

                // synopsis value
                ScrollView {
                    id: synopsisScroller
                    height: parent.height
                    width: parent.width / 1.5  //testing
                    anchors {
                        top: synopsisLabel.bottom
                        bottom: parent.bottom
                        left: parent.left
                        //right: parent.right  // testing
                    }
                    ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
                    ScrollBar.vertical.policy: ScrollBar.AlwaysOff  // may want to create a button instead

                    // synopsis text area
                    TextArea {
                        id: synopsisValue
                        anchors.fill: parent
                        leftPadding: 0
                        text: i_synopsis ? i_synopsis : ""
                        color: "#d8d8d8"
                        font {
                            family: "Arial"
                            pointSize: 12
                            weight: Font.Bold
                        }
                        verticalAlignment: Text.AlignTop
                        wrapMode: Text.WordWrap
                        readOnly: true

                        // disable background color
                        background: Rectangle {
                            color: "transparent"
                        }
                    }
                }
            }
        }

        // panel that holds cast avatars and names
        Rectangle {
            id: castPane
            height: 200
            anchors {
                top: moviePane.bottom
                left: parent.left
                right: parent.right
                topMargin: 5
                leftMargin: 20
                rightMargin: 20 // 0
            }
            color: "transparent"

            // cast header heading
            Label {
                id: castHeader
                height: 30
                anchors {
                    top: parent.top
                    left: parent.left
                    right: parent.right
                }
                color: "#d8d8d8"
                text: "Cast"
                font {
                    family: "Arial"
                    pointSize: 13
                    weight: Font.Bold
                }
                verticalAlignment: Text.AlignVCenter

                // cast header divider line
                Rectangle{
                    id: castHeaderDivider
                    height: 1
                    width: parent.width
                    anchors {
                        top: parent.bottom
                        left: parent.left
                        right: parent.right
                    }
                    color: "#d8d8d8"
                    opacity: 0.25
                }
            }

            // list of cast members
            ListView {
                id: castListView
                anchors {
                    top: castHeader.bottom
                    bottom: parent.bottom
                    left: parent.left
                    right: parent.right
                    topMargin: 10
                }
                orientation: ListView.Horizontal

                model: castModel
                delegate:

                CastCard{
                    id: castCard
                    inImageWidth: 100
                    inImageHeight: 100
                    inCastName: i_name
                    inCastImageUrl: i_img_url
                }
            }
        }

        // panel that holds scenes
        Rectangle {
            id: scenePane
            height: 500
            anchors {
                top: castPane.bottom
                left: parent.left
                right: parent.right
                topMargin: 5
                leftMargin: 20
                rightMargin: 20 // 0
            }
            color: "transparent"

            // scene header heading
            Label {
                id: sceneHeader
                height: 30
                anchors {
                    top: parent.top
                    left: parent.left
                    right: parent.right
                }
                color: "#d8d8d8"
                text: "Scenes"
                font {
                    family: "Arial"
                    pointSize: 13
                    weight: Font.Bold
                }
                verticalAlignment: Text.AlignVCenter

                // scene header divider line
                Rectangle{
                    id: sceneHeaderDivider
                    height: 1
                    width: parent.width
                    anchors {
                        top: parent.bottom
                        left: parent.left
                        right: parent.right
                    }
                    color: "#d8d8d8"
                    opacity: 0.25
                }
            }

            ListView {
                id: sceneListView
                anchors {
                    top: sceneHeader.bottom
                    bottom: parent.bottom
                    left: parent.left
                    right: parent.right
                    topMargin: 10
                }
                model: scenesModel
                delegate:

                Column {
                    width : parent.width
                    height: 75

                    // scene label
                    Label {
                        id: sceneNumber
                        width: 75
                        height: 100
                        anchors {
                            top: parent.top
                            bottom: parent.bottom
                            left: parent.left
                        }
                        color: "#d8d8d8"
                        text: i_scene_num
                        font {
                            family: "Arial"
                            pointSize: 11
                            weight: Font.DemiBold
                        }
                        verticalAlignment: Text.AlignVCenter
                    }


                    // row of cast images
                    RowLayout {
                        id: temp
                        anchors {
                            top: parent.top
                            bottom: parent.bottom
                            left: sceneNumber.right
                            //right: parent.right
                        }
                        //width:  // this could use get_max_cast_count to dynamically resize
                        spacing: 10

                        Repeater {
                            model: i_scene_img_url
                            delegate:

                            SceneCard {
                                inWidth: 50
                                inHeight: 50
                                inImageUrl: model.modelData
                                inName: ""  // todo make this a tool tip on hover
                                Layout.alignment: Qt.AlignVCenter
                            }
                        }
                    }

                    // row of acts
                    RowLayout {
                        id: temp2
                        anchors {
                            top: parent.top
                            bottom: parent.bottom
                            left: temp.right
                            //right: parent.right
                            leftMargin: 20
                        }
                        //width: 250
                        spacing: 5

                        Repeater {
                            model: i_scene_acts
                            delegate:

                            Item {
                                id: actTag
                                anchors {
                                    left: temp.right
                                    leftMargin: 10
                                }

                                Rectangle {
                                    id: actBackground
                                    anchors{
                                        top: actText.top
                                        bottom: actText.bottom
                                        left: actText.left
                                        right: actText.right
                                        topMargin: -1
                                        bottomMargin: -1
                                        leftMargin: -5
                                        rightMargin: -5
                                    }
                                    color: "pink"
                                    radius: 90
                                }

                                Label {
                                    id: actText
                                    text: model.modelData
                                    color: "black"
                                    font {
                                        family: "Arial"
                                        pointSize: 10
                                        weight: Font.Normal
                                    }
                                    verticalAlignment: Text.AlignVCenter
                                }

                            }
                        }
                    }
                }
            }
        }
    }
}


/*##^##
Designer {
    D{i:0;formeditorZoom:0.5;height:1080;width:1920}
}
##^##*/
