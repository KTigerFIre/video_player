cmake_minimum_required(VERSION 3.16)

project(untitled3 VERSION 0.1 LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Core Quick QuickControls2 Svg)

qt_add_executable(mediaplayer
    main.cpp
)

set(resource_files
    "main.qml"
    "PlaybackControl.qml"
    "MetadataInfo.qml"
    "AudioControl.qml"
    "PlaybackSeekControl.qml"
    "PlaybackRateControl.qml"
    "PlayerMenuBar.qml"
    "TracksInfo.qml"
    "Mute_Icon.svg"
    "Speaker_Icon.svg"
    "Ruler.qml"
    "timeline.qml"
)

qt_add_resources(mediaplayer "mediaplayer"
    PREFIX
        "/"
    FILES
        ${resource_files}
)

target_sources(mediaplayer_other_files
  PRIVATE
    Ruler.qml
    timeline.qml
)

target_link_libraries(mediaplayer PRIVATE
    Qt6::Core
    Qt6::Svg
    Qt6::Quick
)

install(TARGETS mediaplayer
    RUNTIME DESTINATION "${INSTALL_EXAMPLEDIR}"
    BUNDLE DESTINATION "${INSTALL_EXAMPLEDIR}"
    LIBRARY DESTINATION "${INSTALL_EXAMPLEDIR}"
)



#find_package(Qt6 6.2 COMPONENTS Quick REQUIRED)

#qt_add_executable(appuntitled3
#    main.cpp
#)

#qt_add_qml_module(appuntitled3
#    URI untitled3
#    VERSION 1.0
#    QML_FILES main.qml
#)

#set_target_properties(appuntitled3 PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER my.example.com
#    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
#    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
#    MACOSX_BUNDLE TRUE
#    WIN32_EXECUTABLE TRUE
#)

#target_link_libraries(appuntitled3
#    PRIVATE Qt6::Quick)

#install(TARGETS appuntitled3
#    BUNDLE DESTINATION .
#    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR})
