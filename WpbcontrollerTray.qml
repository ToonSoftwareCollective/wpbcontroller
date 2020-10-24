import QtQuick 2.1

import qb.components 1.0
import qb.base 1.0

SystrayIcon {
	id: wpbcontrollerSystrayIcon
	posIndex: 9000
	property string objectName: "wpbcontrollerSystray"
	visible: app.enableSystray

	onClicked: {
		stage.openFullscreen(app.wpbcontrollerScreenUrl);
	}

	Image {
		id: imgNewMessage
		anchors.centerIn: parent
		source: "file:///qmf/qml/apps/wpbcontroller/drawables/wpbcontrollerSmall.png"
		width: 25
		height: 25
		fillMode: Image.PreserveAspectFit

	}
}
