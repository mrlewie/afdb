import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import Qt5Compat.GraphicalEffects

import "controls"
import "components"
import "pages"

Window {
    property string backgroundImageUrl: ""

    id: mainWindow
    title: "AFDB"
    width: Screen.width / 2
    height: Screen.height / 2
    color: "#333e54"
    visible: true

    Image {
        id: backgroundImage
        anchors.fill: parent
        source: backgroundImageUrl
        opacity: 0.1
        asynchronous: true
        fillMode: Image.PreserveAspectCrop
        z: 0

        layer.enabled: true
        layer.effect:

            // blur effect
            FastBlur {
            anchors.fill: parent
            source: backgroundImage
            radius: 140
        }
    }

    TopBar {
        id: topBar
    }

    SideMenu {
        id: sideMenu
        anchors {
            top: topBar.bottom
        }
    }

    Loader {
        id: mainLoader
        anchors {
            top: topBar.bottom
            bottom: parent.bottom
            left: sideMenu.right
            right: parent.right
        }
        source: "pages/home.qml"
        //source: "pages/movies_stack.qml"
    }
}
