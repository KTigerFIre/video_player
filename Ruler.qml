import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.12
import QtQuick.Shapes 1.15
import QtQuick.Window

import QtQuick
import QtQuick.Controls
import QtMultimedia

Rectangle {
    id: rulerTop

    property real timeScale: 1
    property int adjustment: 0
    property real intervalSeconds: ((timeScale > 5) ? 1 : (5 * Math.max(
                                                               1, Math.floor(
                                                                   1.5 / timeScale)))) + adjustment

    required property MediaPlayer mediaPlayer

    height: 28

    SystemPalette {
        id: activePalette
    }

    Repeater {
        model: parent.width / (intervalSeconds * timeScale * mediaPlayer.duration / 1000)

        Rectangle {
            anchors.bottom: rulerTop.bottom
            height: 18
            width: 1
            color: activePalette.windowText
            x: index * intervalSeconds * timeScale * mediaPlayer.duration / 1000
            visible: ((x + width) > tracksFlickable.contentX)
                     && (x < tracksFlickable.contentX + tracksFlickable.width)

            Label {
                anchors.left: parent.right
                anchors.leftMargin: 2
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 2
                color: activePalette.windowText
                text: formatTime(index * intervalSeconds * timeScale)
            }
        }
    }

    function formatTime(time) {
        var minutes = Math.floor(time / 60)
        var seconds = Math.floor(time % 60)
        return padZero(minutes) + ":" + padZero(seconds)
    }

    function padZero(number) {
        return (number < 10) ? "0" + number : number
    }

    Connections {
        target: mediaPlayer
        onPositionChanged: updateRuler()
        onDurationChanged: updateRuler()
    }

    function updateRuler() {
        if (mediaPlayer.duration > 0) {
            var ratio = mediaPlayer.position / mediaPlayer.duration
            mediaSlider.value = ratio
        }
    }
}
