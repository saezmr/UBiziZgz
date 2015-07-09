import QtQuick 2.0
import Ubuntu.Components 1.1
import Ubuntu.Components.ListItems 1.0 as ListItem
import Ubuntu.Components.Popups 1.0

Component {
    id: popoverComponent

    Popover {
        id: aboutPopover

        Column {
            id: aboutColumn

            anchors {
                left: parent.left
                right: parent.right
            }

            ListItem.Header {
                text: "BiziZgz\tv" + version
            }

            ListItem.Standard {
                text: "Written by anDprSoft"

                onClicked: Qt.openUrlExternally("https://github.com/andprsoft/UBiziZgz")
            }

            ListItem.Standard {
                text: "Based on DublinWheels by Aaron Hastings (thecosmicfrog)"

                onClicked: Qt.openUrlExternally("https://github.com/thecosmicfrog")
            }

            ListItem.Standard {
                text: "License: GNU GPLv3"
            }

            ListItem.Standard {
                text: "Source code, bugs and feature requests:<br>
                       <a href=\"https://github.com/andprsoft/UBiziZgz\">github.com/andprsoft/UBiziZgz</a>"

                onClicked: Qt.openUrlExternally("https://github.com/andprsoft/UBiziZgz")
            }

            ListItem.SingleControl {
                highlightWhenPressed: false

                control: Button {
                    text: "Close"
                    onClicked: PopupUtils.close(aboutPopover)
                }
            }
        }
    }
}
