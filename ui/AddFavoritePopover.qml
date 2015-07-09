import QtQuick 2.0
import Ubuntu.Components 1.1
import Ubuntu.Components.ListItems 1.0 as ListItem
import Ubuntu.Components.Popups 1.0

Component {
    id: popoverComponent


    Popover {
        id: addFavPopover
        y:100
        height: 100
        Column {
            id: addFavColumn
            anchors {
                left: parent.left
                right: parent.right
            }
            ListItem.Standard {
                text: "Add favorite succesful"
            }
        }
    }
}
