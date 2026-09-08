// tez-minimal — stripped-down GitHub-dark SDDM greeter
// Palette: #0d1117 bg / #e6edf3 fg / #7ee787 green / #79c0ff blue / #8b949e dim
import QtQuick 2.15
import SddmComponents 2.0

Rectangle {
    id: root
    color: config.bgColor ? config.bgColor : "#0d1117"

    readonly property color fg:     config.fgColor     ? config.fgColor     : "#e6edf3"
    readonly property color accent: config.accentColor ? config.accentColor : "#7ee787"
    readonly property color blue:   config.blueColor   ? config.blueColor   : "#79c0ff"
    readonly property color dim:    config.dimColor    ? config.dimColor    : "#8b949e"

    property string fontFamily: config.fontFamily ? config.fontFamily : "JetBrains Mono"
    property string username: userModel.lastUser ? userModel.lastUser : ""
    property int sessionIndex: sessionModel.lastIndex

    TextConstants { id: textConstants }

    function attemptLogin() {
        statusLabel.text = "..."
        statusLabel.color = root.dim
        sddm.login(userInput.visible ? userInput.text : root.username,
                   passwordInput.text, sessionIndex)
    }

    // optional wallpaper — off by default (theme.conf: useBackground=true to enable)
    Image {
        anchors.fill: parent
        visible: config.useBackground === "true" && config.background
        source: config.background ? config.background : ""
        fillMode: Image.PreserveAspectCrop
        smooth: true

        Rectangle {
            anchors.fill: parent
            color: "#b30d1117"   // 70% scrim
        }
    }

    // click anywhere focuses the password field
    MouseArea {
        anchors.fill: parent
        onClicked: passwordInput.forceActiveFocus()
    }

    // clock + date, upper center
    Column {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: parent.height * 0.18
        spacing: 8

        Text {
            id: clockText
            color: root.fg
            font.family: root.fontFamily
            font.pixelSize: 48
            font.weight: Font.DemiBold
            renderType: Text.QtRendering
            text: Qt.formatDateTime(new Date(), "HH:mm")
        }
        Text {
            id: dateText
            color: root.dim
            font.family: root.fontFamily
            font.pixelSize: 14
            renderType: Text.QtRendering
            text: Qt.formatDateTime(new Date(), "dddd, MMMM d")
        }
    }
    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            clockText.text = Qt.formatDateTime(new Date(), "HH:mm")
            dateText.text = Qt.formatDateTime(new Date(), "dddd, MMMM d")
        }
    }

    // centered login column — no card, bare elements
    Column {
        id: loginColumn
        anchors.centerIn: parent
        width: 320
        spacing: 14

        // username: fixed text when pre-filled, editable field otherwise
        TextInput {
            id: userInput
            visible: root.username === ""
            width: parent.width
            color: root.fg
            clip: true
            font.family: root.fontFamily
            font.pixelSize: 14
            verticalAlignment: TextInput.AlignVCenter
            onAccepted: passwordInput.forceActiveFocus()
        }
        Text {
            visible: root.username !== ""
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            color: root.fg
            font.family: root.fontFamily
            font.pixelSize: 14
            text: root.username
        }

        // password: bare underlined field
        Item {
            width: parent.width
            height: 34

            TextInput {
                id: passwordInput
                anchors.fill: parent
                color: root.fg
                clip: true
                font.family: root.fontFamily
                font.pixelSize: 14
                echoMode: TextInput.Password
                passwordCharacter: "*"
                verticalAlignment: TextInput.AlignVCenter
                focus: true
                onAccepted: root.attemptLogin()
            }

            // dim placeholder while empty
            Text {
                anchors.fill: parent
                verticalAlignment: Text.AlignVCenter
                visible: passwordInput.text === "" && !passwordInput.activeFocus
                color: root.dim
                opacity: 0.5
                font.family: root.fontFamily
                font.pixelSize: 14
                text: textConstants.prompt
            }

            Rectangle {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                height: 1
                color: passwordInput.activeFocus ? root.accent : "#30363d"
            }
        }

        // caps lock warning
        Text {
            horizontalAlignment: Text.AlignHCenter
            width: parent.width
            height: 12
            visible: keyboard.capsLock
            color: "#e3b341"
            font.family: root.fontFamily
            font.pixelSize: 11
            text: "caps lock is on"
        }

        // status line (login failed / messages) — fixed height, no layout jump
        Text {
            id: statusLabel
            horizontalAlignment: Text.AlignHCenter
            width: parent.width
            height: 16
            color: root.dim
            font.family: root.fontFamily
            font.pixelSize: 12
        }
    }

    // bottom hint line: session (click to cycle) · layout
    Item {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 32
        width: sessionText.width + layoutText.width + 40
        height: 16

        Text {
            id: sessionText
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            color: root.dim
            font.family: root.fontFamily
            font.pixelSize: 12
            text: (sessionIndex >= 0 && sessionModel.get(sessionIndex)) ? sessionModel.get(sessionIndex).name : "oxwm"

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    if (sessionModel.count > 0)
                        sessionIndex = (sessionIndex + 1) % sessionModel.count
                }
            }
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            color: "#30363d"
            font.family: root.fontFamily
            font.pixelSize: 12
            text: "·"
        }

        Text {
            id: layoutText
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            color: root.dim
            font.family: root.fontFamily
            font.pixelSize: 12
            text: keyboard.layout
        }
    }

    // login result feedback
    Connections {
        target: sddm
        onLoginSucceeded: {
            statusLabel.text = textConstants.loginSucceeded
            statusLabel.color = root.accent
        }
        onLoginFailed: {
            statusLabel.text = textConstants.loginFailed
            statusLabel.color = "#f85149"
            passwordInput.selectAll()
        }
        onInformationMessage: {
            statusLabel.text = message
            statusLabel.color = "#f85149"
        }
    }
}
