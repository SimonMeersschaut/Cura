import QtQuick 2.10
import QtQuick.Controls 2.0
import UM 1.5 as UM
import Cura 1.1 as Cura

Rectangle
{
    id: viewportOverlay

    property var machineManager: machineManager
    property var activeMachine: machineManager ? machineManager.activeMachine : null
    property bool isMachineConnected: activeMachine ? activeMachine.is_connected : false

    property var grblController: grblController
    property bool isConnected: grblController ? grblController.is_connected : false

    // Add a debug message property
    property string debugMessage: !machineManager ? "machineManager is not set!" :
                                  !activeMachine ? "activeMachine is not set!" :
                                  !grblController ? "grblController is not set!" :
                                  ""

    color: "#FAFAFA"
    anchors.fill: parent

    UM.I18nCatalog
    {
        id: catalog
        name: "cura"
    }

    Column
    {
        anchors.centerIn: parent
        spacing: 10

        // Show debug message if there is an error
        Text {
            visible: debugMessage.length > 0
            text: debugMessage
            color: "red"
            font.pointSize: 16
            anchors.horizontalCenter: parent.horizontalCenter
        }

        // Connection control
        Row {
            spacing: 10
            Button {
                text: isConnected ? "Disconnect" : "Connect"
                onClicked: {
                    if (grblController) {
                        if (!isConnected) {
                            grblController.connect()
                        } else {
                            grblController.disconnect()
                        }
                    }
                }
            }
            Text {
                text: isConnected ? "Connected" : "Disconnected"
                color: isConnected ? "green" : "red"
                font.pointSize: 16
            }
        }

        // Graph Placeholder
        Rectangle
        {
            width: 400
            height: 200
            color: "gray"
            Text
            {
                anchors.centerIn: parent
                text: "Graph Placeholder"
                color: "white"
                font.pointSize: 18
            }
        }

        // Command Buttons
        Column
        {
            spacing: 5
            Text { text: "Command Buttons"; color: "white"; font.pointSize: 16 }
            Row {
                spacing: 5
                Button { text: "Z+" }
                Button { text: "Z-" }
            }
            Row {
                spacing: 5
                Button { text: "X+" }
                Button { text: "X-" }
            }
            Row {
                spacing: 5
                Button { text: "Y+" }
                Button { text: "Y-" }
            }
        }

        // Run Buttons
        Row
        {
            spacing: 10
            Text { text: "Printer Control"; color: "white"; font.pointSize: 16 }
            Button { text: "Start Printer" }
            Button { text: "Stop Printer" }
        }
    }
}