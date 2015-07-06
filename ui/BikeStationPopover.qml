import QtQuick 2.0
import Ubuntu.Components 1.1
import Ubuntu.Components.ListItems 1.0 as ListItem
import Ubuntu.Components.Popups 1.0

Component {
    id: popoverComponent

    Popover {
        id: stationPopover

        Column {
            id: stationColumn

            anchors {
                left: parent.left
                right: parent.right
            }

            ListItem.Header {
                text: title
            }

            ListItem.Standard {
                text: bicisDisponibles + " bizis disponibles"
            }

            ListItem.Standard {
                text: anclajesDisponibles + " anclajes disponibles"
            }

            ListItem.SingleControl {
                highlightWhenPressed: false

                control: Button {
                    text: "Cerrar"
                    onClicked: PopupUtils.close(stationPopover)
                }
            }
        }
    }
}
