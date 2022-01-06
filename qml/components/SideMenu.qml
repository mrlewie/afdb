import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 2.15

import "../buttons"

Item {
    id: sideMenu
    width: 200
    anchors {
        top: parent.top
        bottom: parent.bottom
        left: parent.left
        topMargin: 5
        leftMargin: 5
        bottomMargin: 5
    }
    clip: true

    Rectangle {
        id: sideMenuFillColor
        anchors.fill: parent
        color: "black"
        radius: 5
        opacity: 0.15
    }

    Column {
        id: sideMenuColumn
        anchors {
            top: parent.top
            bottom: parent.bottom
            left: parent.left
            right: parent.right
            topMargin: 10
        }
        spacing: 10

        SideMenuButton {
            id: sideMenuHomeButton
            inIconSource: "../../images/svg_images/home.svg"
            inButtonText: "Home"
            onClicked: {
                sideMenuActorsButton.resetButton();
                sideMenuMoviesButton.resetButton();
                sideMenuScenesButton.resetButton();
                sideMenuSettingsButton.resetButton();
                mainLoader.source = ""
            }
        }

        SideMenuButton {
            id: sideMenuActorsButton
            inIconSource: "../../images/svg_images/actors.svg"
            inButtonText: "Actors"
            onClicked: {
                sideMenuHomeButton.resetButton();
                sideMenuMoviesButton.resetButton();
                sideMenuScenesButton.resetButton();
                sideMenuSettingsButton.resetButton();
                mainLoader.source = "pages/actors_stack.qml"
            }
        }

        SideMenuButton {
            id: sideMenuMoviesButton
            inIconSource: "../../images/svg_images/movies.svg"
            inButtonText: "Movies"
            onClicked: {
                sideMenuHomeButton.resetButton();
                sideMenuActorsButton.resetButton();
                sideMenuScenesButton.resetButton();
                sideMenuSettingsButton.resetButton();
                mainLoader.source = "pages/movies_stack.qml"
            }
        }

        SideMenuButton {
            id: sideMenuScenesButton
            inIconSource: "../../images/svg_images/scenes.svg"
            inButtonText: "Scenes"
            onClicked: {
                sideMenuHomeButton.resetButton();
                sideMenuActorsButton.resetButton();
                sideMenuMoviesButton.resetButton();
                sideMenuSettingsButton.resetButton();
                mainLoader.source = ""
            }
        }
    }

    SideMenuButton {
        id: sideMenuSettingsButton
        anchors {
            bottom: parent.bottom
            bottomMargin: 10
        }
        inIconSource: "../../images/svg_images/settings.svg"
        inButtonText: "Settings"
        onClicked: {
            sideMenuHomeButton.resetButton();
            sideMenuActorsButton.resetButton();
            sideMenuMoviesButton.resetButton();
            sideMenuScenesButton.resetButton();
            mainLoader.source = ""
        }
    }
}
