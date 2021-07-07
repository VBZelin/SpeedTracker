import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

import ArcGIS.AppFramework 1.0

Item {
    width: parent.width
    height: 94 * constants.scaleFactor

    property string blockTitle: "Duration"
    property string numberContent: "1:39"
    property string blockUnits: "hours"

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: 20 * constants.scaleFactor

            Label {
                width: parent.width
                height: parent.height
                text: blockTitle
                wrapMode: Text.Wrap
                font.pixelSize: 16 * constants.scaleFactor
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                color: colors.textColor
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: 8 * constants.scaleFactor
        }

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: 38 * constants.scaleFactor

            Label {
                width: parent.width
                height: parent.height
                text: numberContent
                wrapMode: Text.Wrap
                font.pixelSize: 32 * constants.scaleFactor
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.bold: true
                color: colors.themeColor
            }
        }


        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: 8 * constants.scaleFactor
        }

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: 20 * constants.scaleFactor

            Label {
                width: parent.width
                height: parent.height
                text: blockUnits
                wrapMode: Text.Wrap
                font.pixelSize: 16 * constants.scaleFactor
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                color: colors.textColor
            }
        }
    }
}
