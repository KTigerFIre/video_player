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

    implicitHeight: 20

    // Calculate the optimal tick intervals
    property var tickIntervals: root.calculateOptimalTickInterval(
                                    mediaPlayer.duration / 1000)

    RowLayout {
        anchors.fill: parent

        Slider {
            id: mediaSlider
            Layout.fillWidth: true
            enabled: mediaPlayer.seekable
            to: 1.0
            value: mediaPlayer.position / mediaPlayer.duration

            onMoved: mediaPlayer.setPosition(value * mediaPlayer.duration)

            // Tick marks and time labels
            Repeater {
                model: Math.ceil(
                           mediaPlayer.duration / 1000
                           / root.tickIntervals[0]) // Generate main tick marks

                delegate: Rectangle {
                    width: 2
                    height: 8
                    color: "black"
                    x: mediaSlider.width * index
                       / (Math.ceil(
                              mediaPlayer.duration / 1000 / root.tickIntervals[0])) - width / 2

                    // Time labels
                    Text {
                        text: root.formatTime(index * root.tickIntervals[0])
                        font.pixelSize: 10
                        color: "black"
                        anchors.top: parent.bottom
                        anchors.horizontalCenter: parent.horizontalCenter
                        visible: true // Display time labels for all main tick marks
                    }
                }
            }

            // Minor tick marks without labels
            Repeater {
                model: root.tickIntervals[1] ? Math.ceil(
                                                   mediaPlayer.duration / 1000 / root.tickIntervals[1]) : 0 // Generate minor tick marks

                delegate: Rectangle {
                    width: 1
                    height: 4
                    color: "black"
                    x: mediaSlider.width * index
                       / (Math.ceil(
                              mediaPlayer.duration / 1000 / root.tickIntervals[1])) - width / 2
                }
            }
        }
    }

    function calculateOptimalTickInterval(durationSeconds) {
        // Define the thresholds for different tick intervals
        var thresholds = [10, 30, 60, 300, 600, 3600, 18000, 36000]
        var mainTickIntervals = [1, 5, 10, 30, 60, 300, 600, 3600]
        var minorTickIntervals = [null, 1, 1, 5, 10, 30, 60, 300]

        var mainTickInterval = 1
        var minorTickInterval = null

        // Iterate over the thresholds to find the suitable tick intervals
        for (var i = 0; i < thresholds.length; ++i) {
            if (durationSeconds <= thresholds[i]) {
                mainTickInterval = mainTickIntervals[i]
                minorTickInterval = minorTickIntervals[i]
                break
            }
        }

        // Return the main and minor tick intervals
        return [mainTickInterval, minorTickInterval]
    }

    //    function calculateOptimalTickInterval(durationSeconds) {
    //        // Calculate the base-10 logarithm of the duration
    //        var log10 = Math.log(durationSeconds) / Math.log(10)

    //        // Calculate the optimal tick interval
    //        var tickInterval = Math.pow(10, Math.floor(log10))

    //        // Adjust the tick interval for durations that are close to multiples of 5
    //        if (log10 - Math.floor(log10) >= Math.log(5) / Math.log(10)) {
    //            tickInterval *= 5
    //        }

    //        return tickInterval
    //    }
    function formatTime(seconds) {
        var minutes = Math.floor(
                    seconds / 60) // Calculate the number of minutes
        var remainingSeconds = seconds % 60 // Calculate the remaining seconds
        return pad(minutes,
                   2) + ":" + pad(remainingSeconds,
                                  2) // Return the formatted time as mm:ss
    }

    function pad(num, size) {
        var s = num.toString() // Convert the number to a string
        while (s.length < size)
            s = "0" + s // Add leading zeros until the string reaches the desired size
        return s // Return the padded string
    }
}
