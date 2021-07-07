import QtQuick 2.15
import QtQuick.Controls.Styles 1.4
import QtQuick.Extras 1.4

CircularGauge {
    id: speedometer

    anchors.centerIn: parent

    minimumValue: 0
    maximumValue: 200

    style: CircularGaugeStyle {
        id: style

        minorTickmarkCount: 2

        tickmark: Rectangle {
            visible: styleData.value % 10 == 0

            implicitWidth: {
                if (styleData.value % 20 == 0)
                    return outerRadius * 0.02;

                return outerRadius * 0.01;
            }

            implicitHeight: {
                if (styleData.value % 20 == 0)
                    return outerRadius * 0.08;

                return outerRadius * 0.03;
            }

            color:  {
                if (styleData.value <= speedometer.value)
                    return colors.pink;

                return colors.grey;
            }

            antialiasing: true
        }

        minorTickmark: Rectangle {
            implicitWidth: outerRadius * 0.01
            implicitHeight: outerRadius * 0.03

            color: {
                if (styleData.value <= speedometer.value)
                    return colors.pink;

                return colors.grey;
            }

            antialiasing: true
        }

        tickmarkLabel:  Text {
            visible: styleData.value % 20 == 0

            font.pixelSize: outerRadius * 0.1
            text: styleData.value

            color: {
                if (styleData.value <= speedometer.value)
                    return colors.pink;

                return colors.grey;
            }

            antialiasing: true
        }

        needle: Canvas{
            id: needle

            implicitWidth: outerRadius * 0.2
            implicitHeight: outerRadius * 0.75

            onPaint:{
                let context = getContext("2d");

                context.beginPath();
                context.moveTo(0, needle.height);
                context.lineTo(needle.width / 2, 0);
                context.lineTo(needle.width, needle.height);
                context.closePath();

                context.fillStyle = colors.pink;
                context.fill();
            }
        }

        foreground: Item {
            Rectangle {
                width: outerRadius * 0.2
                height: width
                anchors.centerIn: parent

                radius: width / 2
                color: colors.pink
            }
        }
    }
}

