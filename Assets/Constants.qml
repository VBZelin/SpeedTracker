import QtQuick 2.9

import ArcGIS.AppFramework 1.0

Item {
    id: constants

    // Screen scale factor
    readonly property real scaleFactor: AppFramework.displayScaleFactor

    // Item loading number
    readonly property int loadingNumber: 16

    // Animation
    readonly property int slowDuration: 500
    readonly property int normalDuration: 250
    readonly property int fastDuration: 250
    readonly property int superFastDuration: 100

    // Maximum and minimum screenWidth
    property real maximumScreenWidth: app.width > 1000 * constants.scaleFactor ? 800 * constants.scaleFactor : 568 * constants.scaleFactor
    property real maximumCardHeight: app.width > 1000 * constants.scaleFactor ? 400 * constants.scaleFactor : 284 * constants.scaleFactor
    property real maximumGridCellWidth: app.width > 1000 * constants.scaleFactor ? 200 * constants.scaleFactor : 284 * constants.scaleFactor
    readonly property real minimumScreenWidth: 344 * constants.scaleFactor

    // RTL
    readonly property bool isRightToLeft: AppFramework.localeInfo().esriName === "ar" || AppFramework.localeInfo().esriName === "he"

}
