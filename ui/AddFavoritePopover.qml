import QtQuick 2.0
import Ubuntu.Components 1.1
import Ubuntu.Components.ListItems 1.0 as ListItem
import Ubuntu.Components.Popups 1.0

Component {
    id: popoverComponent
    Popover {
        y: units.gu(15)
        height: units.gu(20)
        anchors {//lo colocamos en medio
            left: parent.left
            right: parent.right
            margins: {
                leftMargin: units.gu(5)
                rightMargin: units.gu(5)
            }
            //horizontalCenter: parent.horizontalCenter
            //verticalCenter: parent.verticalCenter
        }

        Text {
            id:txt
            anchors {
                horizontalCenter: parent.horizontalCenter
                verticalCenter: parent.verticalCenter
            }
            text: "Add favorite succesful"
        }
        Icon{
            id:icono
            width: units.gu(3)
            height: units.gu(3)
            anchors {
                left: txt.right
                verticalCenter: parent.verticalCenter
            }
            name:"favorite-selected"
        }
    }
}
