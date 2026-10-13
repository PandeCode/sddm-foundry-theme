import QtQuick
import QtMultimedia
import "components"

Rectangle {
    id: root

    width: 1920
    height: 1080
    color: "#000000"

    // sddm hands every config value over as a string
    function flag(value) {
        return value === true || value === "true"
    }

    function number(value, fallback) {
        const n = Number(value)
        return value === undefined || value === "" || isNaN(n) ? fallback : n
    }

    function login() {
        status.text = ""
        sddm.login(username.text, password.text, session.currentIndex)
    }

    readonly property string background: config.Background || ""
    readonly property string extension: background.split(".").pop().toLowerCase()
    readonly property bool isVideo: ["avi", "mp4", "mov", "mkv", "m4v", "webm"].indexOf(extension) >= 0
    readonly property bool isAnimated: extension === "gif" || extension === "webp"

    FontLoader { source: "fonts/TitilliumWeb-Regular.ttf" }
    FontLoader { source: "fonts/TitilliumWeb-SemiBold.ttf" }
    FontLoader { source: "fonts/TitilliumWeb-Bold.ttf" }

    Image {
        anchors.fill: parent
        visible: root.isVideo
        source: root.isVideo ? (config.BackgroundPlaceholder || "") : ""
        fillMode: Image.PreserveAspectCrop
    }

    Image {
        anchors.fill: parent
        visible: !root.isVideo && !root.isAnimated
        source: visible ? root.background : ""
        fillMode: Image.PreserveAspectCrop
    }

    AnimatedImage {
        anchors.fill: parent
        visible: root.isAnimated
        source: visible ? root.background : ""
        fillMode: Image.PreserveAspectCrop
    }

    MediaPlayer {
        id: player
        source: root.isVideo ? Qt.resolvedUrl(root.background) : ""
        videoOutput: video
        loops: MediaPlayer.Infinite
        playbackRate: root.number(config.BackgroundSpeed, 1)
        Component.onCompleted: if (root.isVideo) play()
    }

    VideoOutput {
        id: video
        anchors.fill: parent
        fillMode: VideoOutput.PreserveAspectCrop
    }

    Rectangle {
        anchors.fill: parent
        color: "#000000"
        opacity: root.number(config.Dim, 0)
    }

    Panel {
        id: window
        visible: primaryScreen
        x: (root.width - width) * root.number(config.WindowX, 0.5)
        // status lines grow the panel downwards instead of moving it
        y: (root.height - height + messages) * root.number(config.WindowY, 0.55)
        readonly property real messages: (status.visible ? status.height + 8 : 0) + (caps.visible ? caps.height + 8 : 0)
        title: config.Title || "Main menu"

        Inset {
            Grid {
                columns: 2
                columnSpacing: 12
                rowSpacing: 8
                verticalItemAlignment: Grid.AlignVCenter

                Text {
                    id: userLabel
                    width: 76
                    text: "Username"
                    font.family: Style.font
                    font.pixelSize: 15
                    font.weight: Font.DemiBold
                    color: Style.text
                }
                Field {
                    id: username
                    width: 320 - 24 - userLabel.width - 12
                    text: userModel.lastUser
                    KeyNavigation.tab: password
                    onAccepted: password.forceFocus()
                }

                Text {
                    text: "Password"
                    font: userLabel.font
                    color: Style.text
                }
                Field {
                    id: password
                    width: username.width
                    echoMode: TextInput.Password
                    KeyNavigation.tab: session.visible ? session : loginButton
                    onAccepted: root.login()
                }

                Text {
                    visible: session.visible
                    text: "Session"
                    font: userLabel.font
                    color: Style.text
                }
                Dropdown {
                    id: session
                    visible: root.flag(config.ShowSession)
                    width: username.width
                    model: sessionModel
                    textRole: "name"
                    currentIndex: sessionModel.lastIndex
                    KeyNavigation.tab: loginButton
                }
            }

            Text {
                id: status
                width: 320 - 24
                visible: text !== ""
                wrapMode: Text.Wrap
                font.family: Style.font
                font.pixelSize: 15
                font.weight: Font.Bold
                color: Style.red
            }

            Text {
                id: caps
                visible: keyboard.capsLock
                text: "Caps Lock is on"
                font: status.font
                color: Style.orange
            }
        }

        Column {
            spacing: 4

            MenuButton {
                id: loginButton
                text: "Log in"
                kind: "green"
                onClicked: root.login()
            }

            MenuButton {
                visible: root.flag(config.ShowSuspend) && sddm.canSuspend
                text: "Suspend"
                onClicked: sddm.suspend()
            }

            MenuButton {
                visible: root.flag(config.ShowReboot) && sddm.canReboot
                text: "Reboot"
                onClicked: sddm.reboot()
            }

            MenuButton {
                visible: root.flag(config.ShowShutdown) && sddm.canPowerOff
                text: "Shut down"
                onClicked: sddm.powerOff()
            }
        }
    }

    Text {
        id: corner
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 12
        font.family: Style.font
        font.pixelSize: 15
        font.weight: Font.DemiBold
        color: Style.text
        style: Text.Outline
        styleColor: "#80000000"

        function update() {
            const now = new Date()
            text = sddm.hostName + "    "
                + Qt.formatDate(now, config.DateFormat || "dddd d MMMM") + "    "
                + Qt.formatTime(now, config.ClockFormat || "HH:mm")
        }

        Component.onCompleted: update()
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: corner.update()
    }

    Connections {
        target: sddm

        function onLoginFailed() {
            password.text = ""
            status.text = "Login failed"
            password.forceFocus()
        }

        function onInformationMessage(message) {
            status.text = message
        }
    }

    Component.onCompleted: {
        if (username.text === "")
            username.forceFocus()
        else
            password.forceFocus()
    }
}
