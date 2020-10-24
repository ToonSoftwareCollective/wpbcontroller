import QtQuick 2.1
import qb.components 1.0

Tile {
	id: wpbcontrollerTile

	onClicked: {
		if ( app.wpbcontrollerUrlTemp.length == 0 || app.wpbcontrollerUrlWPBOn.length == 0 || app.wpbcontrollerUrlWPBOff.length == 0 ||app.wpbcontrollerExpressieTemp.length == 0) {
			qdialog.showDialog(qdialog.SizeLarge, "WPB controller configuratie mededeling", "De configuratie is niet compleet ingevuld. Ga naar het instellingen scherm.");	
		}
		stage.openFullscreen(app.wpbcontrollerScreenUrl);
	}


	Text {
		id: tiletitle
		text: "WPB Controller"
		anchors {
			baseline: parent.top
			baselineOffset: isNxt ? 30 : 24
			horizontalCenter: parent.horizontalCenter
		}
		font {
			family: qfont.bold.name
			pixelSize: isNxt ? 25 : 20
		}
		color: colors.waTileTextColor
       	visible: !dimState
	}

	Text {
		id: txtTemp
		text: app.wpbTemp + " graden"
		color: colors.clockTileColor
		anchors {
			top: tiletitle.bottom
			horizontalCenter: parent.horizontalCenter
		}
		font.pixelSize: isNxt ? 20 : 16
		font.family: qfont.italic.name
       	visible: !dimState
		clip: true
	}

	Text {
		id: statusText
		text: "Status"
		anchors {
			bottom: txtStatus.top
			horizontalCenter: parent.horizontalCenter
		}
		font {
			family: qfont.bold.name
			pixelSize: isNxt ? 22 : 18
		}
		color: colors.waTileTextColor
       	visible: !dimState
	}

	Text {
		id: txtStatus
		text: app.tileStatus
		color: colors.clockTileColor
		anchors {
			bottom: parent.bottom
			bottomMargin: 10
			horizontalCenter: parent.horizontalCenter
		}
		font.pixelSize: isNxt ? 20 : 16
		font.family: qfont.italic.name
       	visible: !dimState
	}
}
