// Copyright (C) 2021 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR BSD-3-Clause
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtMultimedia

import QtQuick 2.0
import QtQuick.Controls 2.15

Item {
    id: root

    required property MediaPlayer mediaPlayer

    Flickable {
        id: flickable
        anchors.fill: parent
        contentWidth: timeline.width
        contentHeight: timeline.height
        boundsBehavior: Flickable.StopAtBounds

        Repeater {
            id: timeline
            width: Math.ceil(mediaPlayer.duration / 1000)
                   * 10 // Adjust the multiplier as needed for the desired width
            height: 30 // Adjust the height as needed
            model: Math.ceil(
                       mediaPlayer.duration / 1000) // Generate tick marks every 1 second

            delegate: Rectangle {
                width: 2
                height: 8
                color: "black"
                x: timeline.width * index / (Math.ceil(
                                                 mediaPlayer.duration / 1000)) - width / 2

                Text {
                    text: formatTime(index)
                    font.pixelSize: 15
                    color: "black"
                    anchors.top: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    visible: index % 10 === 0 // Display time labels every 10 seconds
                }
            }
        }

        Slider {
            id: mediaSlider
            width: flickable.width
            height: 20
            anchors {
                left: parent.left
                right: parent.right
                bottom: scrollBar.top
            }
            enabled: mediaPlayer.seekable
            to: 1.0

            value: mediaPlayer.position / mediaPlayer.duration

            onMoved: {
                mediaPlayer.setPosition(value * mediaPlayer.duration)
                flickable.contentX = value * (flickable.contentWidth - flickable.width)
            }
        }

        //        ScrollBar {
        //            id: scrollBar
        //            orientation: Qt.Horizontal
        //            width: flickable.width
        //            height: 20
        //            anchors.bottom: parent.bottom
        //            contentItem: Rectangle {
        //                width: flickable.width * flickable.width / flickable.contentWidth
        //                height: parent.height
        //                color: "lightgray"
        //                radius: height / 2
        //            }
        //            position: flickable.contentX / (flickable.contentWidth - flickable.width)
        //            onPositionChanged: flickable.contentX = position
        //                               * (flickable.contentWidth - flickable.width)
        //            stepSize: flickable.width / flickable.contentWidth
        //        }
    }

    function formatTime(seconds) {
        var minutes = Math.floor(seconds / 60)
        var remainingSeconds = seconds % 60
        return pad(minutes, 2) + ":" + pad(remainingSeconds, 2)
    }

    function pad(num, size) {
        var s = num.toString()
        while (s.length < size)
            s = "0" + s
        return s
    }
}
