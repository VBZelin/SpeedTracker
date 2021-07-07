import QtQuick 2.15
import QtQuick.Controls 2.15

import ArcGIS.AppFramework 1.0

Item {
    id: mainUI

    anchors.fill: parent

    Rectangle {
        anchors.fill: parent

        color: colors.black
    }

    Speedometer {
        anchors.fill: parent
    }
}
