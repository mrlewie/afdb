import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 2.15
import Qt5Compat.GraphicalEffects

import "../buttons"
import "../controls"
import "../components"
import "../tags"

Item {
    property int inImageWidth: 584 / 4
    property int inImageHeight: 832 / 4

    id: movieContainer
    anchors.fill: parent

    Rectangle {
      anchors.fill: parent
      color: "yellow"
      opacity: 0.1
    }

    SubBar {
        id: subBar
    }

    ScrollView {
        id: movieScroller
        width: parent.width
        height : parent.height
        //contentWidth: parent.width
        //contentHeight: parent.height
        anchors {
            top: subBar.bottom
            //left: parent.left
            //right: parent.right
            //bottom: parent.bottom
        }

        ColumnLayout {
            id: movieColumn
            anchors.fill: parent
            //spacing: 20
            //model: moviesModel
            //delegate: Loader {}

            RowLayout {
                id: movieDetailsRow
                anchors.fill: parent
                spacing: 15

                //convert this to unique movie card
                Image {
                    id: movieDetailsCoverImage
                    //width: 292
                    //height: 416
                    Layout.fillWidth: false
                    Layout.fillHeight: false
                    Layout.margins: 15
                    source: "file:///" + "g:/Images/Covers/134569.jpg"
                    sourceSize {
                        width: 292
                        height: 416
                    }
                    fillMode: Image.PreserveAspectCrop
                    smooth: true
                    asynchronous: true
                    cache: true
                }

                Item {
                    id: movieDetailsContainer
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.minimumWidth: 200
                    Layout.minimumHeight: 316   // movie cover - 100
                    Layout.preferredHeight: 416  // same as movie cover
                    Layout.maximumHeight: 516    // movie cover + 100
                    Layout.topMargin: 25
                    Layout.bottomMargin: 15
                    Layout.leftMargin: 15
                    Layout.rightMargin: 15

                    // temp
                    Rectangle {
                      anchors.fill: parent
                      color: "pink"
                      opacity: 0.25
                    }

                    ColumnLayout {
                        id: movieDetailsCoreColumn
                        //anchors.fill: parent
                        // anchors {
                        //     top: parent.top
                        //     left: parent.left
                        //     right: parent.right
                        // }
                        spacing: 10

                        Label {
                            id: movieDetailsCoreTitle
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            Layout.minimumWidth: parent.Layout.minimumWidth
                            Layout.preferredWidth: movieContainer.width / 1.5
                            Layout.maximumWidth: movieContainer.width
                            //Layout.minimumWidth: movieDetailsContainer.width
                            //Layout.fillWidth: true
                            //Layout.maximumWidth: Screen.width / 2

                            text: "Latina Anal Heartbreakers and Other Dirty Butt Fucking Sluts 2: The Revenge"   //i_title ? i_title : r_title
                            color: "white"
                            font {
                                family: "Arial"
                                pixelSize: 24
                                weight: Font.Bold
                            }
                            verticalAlignment: Text.AlignVCenter
                            elide: Label.ElideRight
                        }

                        RowLayout {
                          enabled: false
                          visible: false
                            id: movieDetailsCoreRow
                            anchors {
                                left: parent.left
                                right: parent.right
                            }
                            spacing: 25

                            Label {
                                id: movieDetailsCoreYear
                                text: "2002" //i_year ? i_year : r_year
                                color: "white"
                                font {
                                    family: "Arial"
                                    pixelSize: 15
                                    weight: Font.Bold
                                }
                                verticalAlignment: Text.AlignVCenter
                            }

                            Label {
                                id: movieDetailsCoreAge
                                text: "X" //i_age
                                color: "white"
                                font {
                                    family: "Arial"
                                    pixelSize: 12
                                    weight: Font.Normal
                                }
                                verticalAlignment: Text.AlignVCenter
                                topPadding: 2
                                bottomPadding: 2
                                leftPadding: 6
                                rightPadding: 6
                                background: Rectangle {
                                    color: "black"
                                    opacity: 0.4
                                    radius: 5
                                }

                                ToolTip.delay: 500
                                ToolTip.timeout: 2500
                                ToolTip.visible: "Age Rating" ? movieDetailsCoreAgeMouseArea.containsMouse : false
                                ToolTip.text: "Age Rating"

                                MouseArea {
                                    id: movieDetailsCoreAgeMouseArea
                                    anchors.fill: parent
                                    hoverEnabled: true
                                }
                            }

                            Rating {
                                id: movieDetailsCoreRating
                                currentClicked: 2 // i_rating
                            }
                        }
                    }

                    Flow {
                        enabled: false
                        visible: false

                        id: movieDetailsCoreActsFlow
                        height: 12
                        anchors {
                            top: movieDetailsCoreColumn.bottom
                            left: parent.left
                            right: parent.right
                            topMargin: 15
                        }
                        spacing: 3

                        Repeater {
                            id: movieDetailsCoreActsRepeater
                            model: [{"act": "Anal"}, {"act": "Double Anal"}, {"act": "Double Penetration"}, {"act": "Facial"}]  // do pyside
                            delegate: MovieActTag {
                                actTagText: modelData.act
                            }
                        }
                    }

                    Flow {
                        enabled: false
                        visible: false

                        id: movieDetailsCoreControlsFlow
                        height: 35
                        anchors {
                            top: movieDetailsCoreActsFlow.bottom
                            left: parent.left
                            right: parent.right
                            topMargin: 35
                        }
                        spacing: 10

                        MoviePlayButton {
                        }

                        MovieWatchedButton {
                        }

                        MovieEditButton {
                        }

                        MovieMoreButton {
                        }
                    }

                    Flow {
                      enabled: false
                      visible: false

                        id: movieDetailsCoreInfoFlow
                        height: 100
                        anchors {
                            top: movieDetailsCoreControlsFlow.bottom
                            left: parent.left
                            right: parent.right
                            topMargin: 25
                        }
                        spacing: 5
                        flow: Flow.TopToBottom

                        Repeater {
                            id: movieDetailsCoreInfoRepeater
                            model: [["Length", "1 hr 47 mins"], ["Directed by", "Raymond Balboa"],
                                ["Distributor", "LFP Video Inc"], ["Studio", "LFP Video Inc"],
                                ["All-Girl", "No"], ["Compilation", "No"], ["Video", "540p (H.264)"],
                                ["Audio", "English (AAC Stereo)"]]  // do pyside
                            delegate:

                                Row {
                                height: 20
                                spacing: 5

                                Label {
                                    width: 125
                                    height: parent.height
                                    text: modelData[0]
                                    color: "#d8d8d8"
                                    font {
                                        family: "Arial"
                                        pixelSize: 13
                                        weight: Font.Bold
                                        capitalization: Font.AllUppercase
                                    }
                                    opacity: 0.75
                                    verticalAlignment: Text.AlignVCenter

                                    background: Rectangle {anchors.fill: parent; color: "aqua"; opacity: 0.25; visible: false}
                                }

                                Label {
                                    width: 200
                                    height: parent.height
                                    text: modelData[1]
                                    color: "white"
                                    font {
                                        family: "Arial"
                                        pixelSize: 15
                                        weight: Font.Normal
                                    }
                                    verticalAlignment: Text.AlignVCenter

                                    // temp
                                    background: Rectangle {anchors.fill: parent; color: "aqua"; opacity: 0.25; visible: false}
                                }
                            }
                        }
                    }

                    Item {
                        enabled: false
                        visible: false

                        id: movieDetailsCoreSynopsis
                        height: 73
                        anchors {
                            top: movieDetailsCoreInfoFlow.bottom
                            //bottom: movieDetailsCoverImage.bottom
                            left: parent.left
                            right: parent.right
                            topMargin: 25
                        }

                        ScrollView {
                            id: movieDetailsCoreSynopsisScrollView
                            height: parent.height
                            anchors.fill: parent
                            ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
                            ScrollBar.vertical.policy: ScrollBar.AlwaysOff
                            clip: true

                            TextArea {
                                id: movieDetailsCoreSynopsisTextArea
                                anchors.fill: parent
                                topPadding: 0
                                bottomPadding: 0
                                leftPadding: 0
                                rightPadding: 0

                                //text: i_synopsis ? i_synopsis : ""
                                text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Eget lorem dolor sed viverra. Volutpat sed cras ornare arcu dui vivamus. Consequat mauris nunc congue nisi. Nibh ipsum consequat nisl vel pretium. Ut enim blandit volutpat maecenas volutpat blandit aliquam. Quis commodo odio aenean sed adipiscing. Molestie ac feugiat sed lectus vestibulum mattis ullamcorper velit. Eget nullam non nisi est sit amet. Netus et malesuada fames ac turpis egestas integer eget. Facilisi cras fermentum odio eu feugiat pretium nibh ipsum. Sed euismod nisi porta lorem mollis. Purus gravida quis blandit turpis. Turpis in eu mi bibendum neque egestas. Fames ac turpis egestas integer eget aliquet nibh praesent. Sit amet mattis vulputate enim nulla aliquet porttitor lacus luctus. Quisque id diam vel quam elementum pulvinar etiam. Non curabitur gravida arcu ac tortor dignissim convallis aenean et. Tincidunt tortor aliquam nulla facilisi cras fermentum odio eu feugiat. Mauris augue neque gravida in fermentum et. Posuere morbi leo urna molestie at elementum eu. Nec ullamcorper sit amet risus nullam eget felis eget nunc. Nulla facilisi morbi tempus iaculis. Tellus orci ac auctor augue mauris augue neque. Viverra ipsum nunc aliquet bibendum enim. Laoreet non curabitur gravida arcu ac tortor dignissim convallis. Mollis aliquam ut porttitor leo. Donec enim diam vulputate ut pharetra sit amet aliquam. Amet facilisis magna etiam tempor orci eu lobortis elementum. Aliquet nec ullamcorper sit amet. Vestibulum mattis ullamcorper velit sed ullamcorper. Suspendisse ultrices gravida dictum fusce. Faucibus interdum posuere lorem ipsum."

                                color: "white"
                                font {
                                    family: "Arial"
                                    pixelSize: 15
                                    weight: Font.Normal
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

                        MovieReadMoreButton {
                            anchors {
                                top: movieDetailsCoreSynopsisScrollView.bottom
                                left: movieDetailsCoreSynopsisScrollView.left
                                topMargin: 5
                            }


                            MouseArea {
                                property bool isExpanded: false

                                id: movieDetailsCoreSynopsisReadMoreMouseAreaClicked
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                //hoverEnabled: true

                                onClicked: {
                                    if (isExpanded == false) {
                                        //movieDetailsRow.height = 600
                                        movieDetailsCoreSynopsis.height = 300
                                        isExpanded = true
                                    }
                                    else {
                                        //movieDetailsRow.height = 400
                                        movieDetailsCoreSynopsis.height = 100
                                        isExpanded = false
                                    }
                                }
                            }
                        }
                    }
                }
            }

            // Rectangle {
            //     id: tempRectangle1
            //     height: 200
            //     //width: 200
            //     // anchors {
            //     //     //top: movieDetailsRow.bottom
            //     //     //topMargin: 23
            //     //     left: parent.left
            //     //     right: parent.right
            //     // }
            //     color: "blue"
            //     opacity: 0.5
            // }

            // Rectangle {
            //     id: tempRectangle2
            //     height: 2000
            //     // anchors {
            //     //     //top: tempRectangle1.bottom
            //     //     //topMargin: 10
            //     //     left: parent.left
            //     //     right: parent.right
            //     // }
            //     color: "orange"
            //     opacity: 0.5
            // }
        //}
    }
}
}
