# Copyright (c) 2017 Ultimaker B.V.
# Cura is released under the terms of the LGPLv3 or higher.
import os.path
from UM.Application import Application
from cura.Stages.CuraStage import CuraStage
from .GrblController import GrblController # New import


class MonitorStage(CuraStage):
    """Stage for monitoring a 3D printing while it's printing."""

    def __init__(self, parent = None):
        super().__init__(parent)

        # Wait until QML engine is created, otherwise creating the new QML components will fail
        Application.getInstance().engineCreatedSignal.connect(self._onEngineCreated)
        self._grbl_controller = None # New member variable

    def _onOutputDevicesChanged(self):
        if self._grbl_controller is None:  # Only instantiate once
            self._grbl_controller = GrblController()
            self._grbl_controller.connect()

            # Expose GrblController to QML right here
            app = Application.getInstance()
            app.getQmlEngine().rootContext().setContextProperty("grblController", self._grbl_controller)

    def _onConnectionStatusChanged(self, is_connected: bool):
        self.setOutputDeviceConnected(is_connected)

    def _onEngineCreated(self):
        app = Application.getInstance()
        app.getMachineManager().outputDevicesChanged.connect(self._onOutputDevicesChanged)
        self._onOutputDevicesChanged()

        plugin_path = app.getPluginRegistry().getPluginPath(self.getPluginId())
        if plugin_path is not None:
            menu_component_path = os.path.join(plugin_path, "MonitorMenu.qml")
            main_component_path = os.path.join(plugin_path, "MonitorMain.qml")
            self.addDisplayComponent("menu", menu_component_path)
            self.addDisplayComponent("main", main_component_path)
