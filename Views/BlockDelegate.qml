import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.12
import QtQuick.Layouts 1.15
import QtGraphicalEffects 1.12

import ArcGIS.AppFramework 1.0

Item {
    id: blockDelegate

    property string title: ""
    property string value: ""
    property string unit: ""

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: 20 * scaleFactor

            Label {
                width: parent.width
                height: parent.height

                text: title
                font.family: fonts.regular_fontFamily
                font.pixelSize: 16 * scaleFactor
                font.letterSpacing: -0.3 * scaleFactor
                color: colors.white_90

                wrapMode: Text.Wrap

                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter

                antialiasing: true
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

                text: value
                font.family: fonts.demi_fontFamily
                font.pixelSize: 32 * scaleFactor
                font.bold: true
                font.letterSpacing: -0.3 * scaleFactor
                color: text === "0" ? colors.white_90 : colors.theme

                wrapMode: Text.Wrap

                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter

                antialiasing: true
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

                text: unit
                font.family: fonts.regular_fontFamily
                font.pixelSize: 16 * scaleFactor
                font.letterSpacing: -0.3 * scaleFactor
                color: colors.white_90

                wrapMode: Text.Wrap

                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter

                antialiasing: true
            }
        }
    }
}
