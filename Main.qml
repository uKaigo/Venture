import QtQuick 2.8
import QtQuick.Controls 2.8
import QtQuick.Controls 1.4 as Q1
import QtQuick.Controls.Styles 1.4
import SddmComponents 2.0
import "."
Rectangle {
    id : container
    LayoutMirroring.enabled : Qt.locale().textDirection == Qt.RightToLeft
    LayoutMirroring.childrenInherit : true

    property int sessionIndex : session.index

    TextConstants {
        id : textConstants
    }

    FontLoader {
        id : basefont
        source : "NotoSans-Regular.ttf"
    }

    Connections {
        target : sddm
        onLoginSucceeded : {
            errorMessage.color = "#33ff99"
            errorMessage.text = textConstants.loginSucceeded
        }
        onLoginFailed : {
            password.text = ""
            errorMessage.color = "#ff99cc"
            errorMessage.text = textConstants.loginFailed
            errorMessage.bold = true
        }
    }

    Background {
        anchors.fill : parent
        source : config.background
        fillMode : Image.Stretch
        onStatusChanged : {
            if (status == Image.Error && source != config.defaultBackground) {
                source = config.defaultBackground
            }
        }
    }

    Text {
        anchors.top : parent.top
        anchors.horizontalCenter :parent.horizontalCenter
        font.pointSize : 14
        anchors.topMargin : 24
        color : "#e2e2ea"
        text : textConstants.welcomeText.arg(sddm.hostName)
    }

    Row {
        anchors.verticalCenter : parent.verticalCenter
        anchors.horizontalCenter : parent.horizontalCenter
        spacing: 96

        Clock2 {
            id : clock
            anchors.verticalCenter : parent.verticalCenter
            color : "#e2e2ea"
            timeFont.family : basefont.name
            dateFont.family : basefont.name
        }

        Column {
            anchors.verticalCenter : parent.verticalCenter

            Text {
                id : lblLoginName
                text : textConstants.promptUser
                font.pointSize : 10
                verticalAlignment : Text.AlignVCenter
                color : "#e2e2ea"
                font.family : basefont.name
                bottomPadding : 5
            }

            TextBox {
                id : name
                font.family : basefont.name
                width : 320
                borderColor : "#9760bb"
                color : "#10e2e2ea"
                textColor : "#e2e2ea"
                hoverColor : "#c07aee"
                focusColor : "#a369cc"
                text : userModel.lastUser
                font.pointSize : 12
                KeyNavigation.backtab : rebootButton
                KeyNavigation.tab : password

                Keys.onPressed : {
                    if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                        sddm.login(name.text, password.text, sessionIndex)
                        event.accepted = true
                    }
                }
            }

            Rectangle {
                height : 12
                width : 12
                color : "transparent"
            }

            Text {
                id : lblLoginPassword
                bottomPadding : 5
                text : textConstants.promptPassword
                verticalAlignment : Text.AlignVCenter
                color : "#e2e2ea"
                font.pointSize : 10
                font.family : basefont.name
            }

            Row {
                spacing : 4
                TextBox {
                    id : password
                    font.pointSize : 12
                    echoMode : TextInput.Password
                    font.family : basefont.name
                    width : 320
                    borderColor : "#9760bb"
                    color : "#10e2e2ea"
                    textColor : "#e2e2ea"
                    hoverColor : "#c07aee"
                    focusColor : "#a369cc"
                    KeyNavigation.backtab : name
                    KeyNavigation.tab : loginButton

                    Keys.onPressed : {
                        if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                            sddm.login(name.text, password.text, sessionIndex)
                            event.accepted = true
                        }
                    }
                }

                Image {
                    id : loginButton
                    width : 32
                    height : 32
                    source : "buttonup.svg"

                    MouseArea {
                        anchors.fill : parent
                        hoverEnabled : true
                        onEntered : {
                            parent.source = "buttonhover.svg"
                        }
                        onExited : {
                            parent.source = "buttonup.svg"
                        }
                        onPressed : {
                            parent.source = "buttondown.svg"
                            sddm.login(name.text, password.text, sessionIndex)
                        }
                        onReleased : {
                            parent.source = "buttonup.svg"
                        }
                    }
                    KeyNavigation.backtab : password
                    KeyNavigation.tab : shutdownButton
                }
            }
        }
    }

    Column {
        anchors.right : parent.right
        anchors.rightMargin : 24
        anchors.topMargin : 6
        anchors.top : parent.top
        width : 180

        Text {
            height : 30
            id : lblSession
            width : parent.width
            text : textConstants.session
            font.pointSize : 10
            verticalAlignment : Text.AlignVCenter
            color : "white"
        }

        ComboBox {
            id : session
            width : parent.width
            font.pointSize : 10
            font.family : basefont.name
            arrowIcon : "comboarrow.svg"
            model : sessionModel
            index : sessionModel.lastIndex
                    borderColor : "#9760bb"
                    color : "#10e2e2ea"
                    textColor : "#e2e2ea"
                    hoverColor : "#c07aee"
                    focusColor : "#a369cc"
                    menuColor: "#9760bb"
            KeyNavigation.backtab : password
            KeyNavigation.tab : shutdownButton
        }
    }

    Row {
        anchors.bottom : parent.bottom
        anchors.right : parent.right
        anchors.bottomMargin : 18
        anchors.rightMargin : 24
        height : 64
        spacing : 24

        Column {
            width : 72

            Text {
                id : rebootName2
                anchors.horizontalCenter : parent.horizontalCenter
                height : 26
                text : textConstants.shutdown
                font.family : basefont.name
                font.pointSize : 10
                verticalAlignment : Text.AlignVCenter
                color : "white"
            }

            Q1.Button {
                id : shutdownButton
                anchors.horizontalCenter : parent.horizontalCenter
                height : 44
                width : 44

                style : ButtonStyle {
                    background : Image {
                        source : control.hovered
                            ? "shutdownpressed.svg"
                            : "shutdown.svg"
                    }
                }
                onClicked : sddm.powerOff()
                KeyNavigation.backtab : loginButton
                KeyNavigation.tab : rebootButton
            }
        }

        Column {

            Text {
                id : rebootName
                anchors.horizontalCenter : parent.horizontalCenter
                height : 26
                text : textConstants.reboot
                font.family : basefont.name
                font.pointSize : 10
                verticalAlignment : Text.AlignVCenter
                color : "white"
            }

            Q1.Button {
                id : rebootButton
                anchors.horizontalCenter : parent.horizontalCenter
                height : 44
                width : 44

                style : ButtonStyle {
                    background : Image {
                        source : control.hovered
                            ? "rebootpressed.svg"
                            : "reboot.svg"
                    }
                }
                onClicked : sddm.reboot()
                KeyNavigation.backtab : shutdownButton
                KeyNavigation.tab : name
            }
        }
    }

    Component.onCompleted : {
        if (name.text == "")
            name.focus = true
         else
            password.focus = true

    }
}
