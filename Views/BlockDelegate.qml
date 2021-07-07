import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.12
import QtQuick.Layouts 1.15
import QtGraphicalEffects 1.12

import ArcGIS.AppFramework 1.0

Item {
    width: parent.width
    height: 94 * scaleFactor

    property string blockTitle: "Duration"
    property string numberContent: "1:39"
    property string blockUnits: "hours"

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: 20 * scaleFactor

            Label {
                width: parent.width
                height: parent.height

                text: blockTitle

                font.pixelSize: 16 * scaleFactor
                color: colors.white_90

                wrapMode: Text.Wrap

                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: 8 * scaleFactor
        }

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: 38 * scaleFactor

            Label {
                width: parent.width
                height: parent.height

                text: numberContent

                font.pixelSize: 32 * scaleFactor
                font.bold: true
                color: colors.theme

                wrapMode: Text.Wrap

                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
        }


        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: 8 * scaleFactor
        }

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: 20 * scaleFactor

            Label {
                width: parent.width
                height: parent.height

                text: blockUnits

                font.pixelSize: 16 * scaleFactor
                color: colors.white_90

                wrapMode: Text.Wrap

                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }
        }
    }
}
