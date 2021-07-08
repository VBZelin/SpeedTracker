import QtQuick 2.15

import ArcGIS.AppFramework 1.0

Item {
    id: fonts

    property bool useDefaultFont: AppFramework.localeInfo().esriName === "vi"|| AppFramework.localeInfo().esriName === "el"

    readonly property string fontName: useDefaultFont ? "" : app.info.propertyValue("fontFamily", "")

    property var regular_fontFamily: fontName > "" ? fontName : system_fontFamily
    property var demi_fontFamily: fontName > "" ? fontName : system_fontFamily
    property var system_fontFamily: Qt.application.font.family

    Component {
        id: fontLoaderComponent

        FontLoader {
            property string fileName

            source: folder.fileUrl(fileName)

            onStatusChanged: {
                if (status === FontLoader.Ready)
                    addFamily(fileName, name);
            }
        }
    }

    FileFolder {
        id: folder

        url: "fonts"
    }

    Component.onCompleted: {
        init();
    }

    function init() {
        if (!useDefaultFont)
            loadFonts();
    }

    function loadFonts() {
        if (!folder.exists)
            return;

        let fileNames = folder.fileNames("*.ttf");

        fileNames.forEach(loadFont);
    }

    function loadFont(fileName) {
        fontLoaderComponent.createObject(fonts, {
                                             fileName: fileName
                                         });
    }

    function addFamily(fileName, name) {
        // WORKAROUND: remove the workaround once it is fixed
        Qt.callLater(() => {
                         if (fileName.indexOf("Demi") > -1)
                         demi_fontFamily = name;

                         if (fileName.indexOf("Regular") > -1)
                         regular_fontFamily = name;
                     });
    }
}
