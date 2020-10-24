import QtQuick 2.1
import qb.components 1.0
 

Screen {
	id: wpbcontrollerScreen
	screenTitle: "WPB controller"

	property alias wpbcontrollerListModel: wpbcontrollerModel

	function refreshButtonEnabled(enabled) {
		refreshButton.enabled = enabled;
	}

	function controllerAuto(enabled) {
		enableAutoOnLabel.visible = enabled;	
		enableAutoOnToggle.visible = enabled;
		btnHelpAutoOn.visible = enabled;
		tempWPBOn.visible = enabled;

		enableAutoOffLabel.visible = enabled;	
		enableAutoOffToggle.visible = enabled;
		btnHelpAutoOff.visible = enabled;
		tempWPBOff.visible = enabled;

	}

	anchors.fill: parent

	Component.onCompleted: {

	}


	onShown: {
		if (app.debugOutput) console.log("********* WPBController WPBControllerScreen onShown");
		controllerAuto(app.enableWPB);
		addCustomTopRightButton("Instellingen");
		tempWPBOn.temperature = app.tempWPBOn;
		tempWPBOff.temperature = app.tempWPBOff;
		enableAutoOnToggle.isSwitchedOn = app.enableWPBAutoOn;
		enableAutoOffToggle.isSwitchedOn = app.enableWPBAutoOff;
		app.settingChanged = false;
	}

	onHidden: {
		if (tempWPBOn.temperature != app.tempWPBOn) {
			app.settingChanged = true;
			app.tempWPBOn = tempWPBOn.temperature;
		}

		if (tempWPBOff.temperature != app.tempWPBOff) {
			app.settingChanged = true;
			app.tempWPBOff = tempWPBOff.temperature;
		}

		if (enableAutoOnToggle.isSwitchedOn != app.enableWPBAutoOn) {
			app.settingChanged = true;
			app.enableWPBAutoOn = enableAutoOnToggle.isSwitchedOn;
		}
		
		if (enableAutoOffToggle.isSwitchedOn != app.enableWPBAutoOff) {
			app.settingChanged = true;
			app.enableWPBAutoOff = enableAutoOffToggle.isSwitchedOn;
		}
		
		if (app.settingChanged) {
			app.saveSettings();
			if (app.debugOutput) console.log("********* WPBController WPBControllerScreen onHidden savesettings()");
		}
		
	}
	onCustomButtonClicked: {
		if (app.wpbcontrollerConfigurationScreen) app.wpbcontrollerConfigurationScreen.show();
	}


	Text {
		id: txtTemp
		text: "Gemeten temperatuur " + app.wpbTemp + "°"
		color: colors.clockTileColor
		anchors {
			baseline: parent.top
			horizontalCenter: parent.horizontalCenter
		}
		font.pixelSize: isNxt ? 25 : 20
		font.family: qfont.italic.name
       	visible: !dimState
		clip: true
	}

	IconButton {
		id: refreshButton
		anchors {
			right: parent.right
			top: parent.top
			rightMargin: 40
		}
		
		leftClickMargin: 3
		bottomClickMargin: 5
		iconSource: "qrc:/tsc/refresh.svg"
		onClicked: {
			app.getTemp();
		}
	}

	
	Text {
		id: switchWPBText
		text: "Schakel WPB handmatig:"
		font.family: qfont.semiBold.name
		font.pixelSize: isNxt ? 25 : 20
		anchors {
			left: parent.left
			leftMargin: 40
			top: parent.top
			topMargin: 10
		}
	}

	StandardButton {
		id: switchWPBOnButton
		text: "Aan"
		anchors {
			left: switchWPBText.right
			leftMargin: 6
			top: switchWPBText.top
		}
		rightClickMargin: 2
		bottomClickMargin: 5
		width: 75

		selected: false
		visible : true

		onClicked: {
			app.setWPBOn(false);
		}
	}
	
	StandardButton {
		id: switchWPBOffButton
		text: "Uit"
		anchors {
			left: switchWPBOnButton.right
			leftMargin: 6
			top: switchWPBOnButton.top
		}
		rightClickMargin: 2
		bottomClickMargin: 5
		width: 75

		selected: false
		visible : true

		onClicked: {
			app.setWPBOff(false);
		}
	}
	
	StandardButton {
		id: btnHelpInterval
		text: "?"
		anchors.left: switchWPBOffButton.right
		anchors.bottom: switchWPBOffButton.bottom
		anchors.leftMargin: 10
		onClicked: {
			qdialog.showDialog(qdialog.SizeLarge, "WPB handmatig bedienen", "Hiermee wordt de URL voor WPB aan- of uitschakelen aangeroepen. Let op: verdere werking is afhankelijk van wat er achter deze URL zit.\n", "Sluiten");
		}
	}

	
	Text {
		id: enableAutoOnLabel
//		width: isNxt ? 240 : 200
		height: isNxt ? 45 : 36
		text: "Schakel automatisch aan: "
		font.family: qfont.semiBold.name
		font.pixelSize: isNxt ? 25 : 20
		anchors {
			left: switchWPBText.left
			leftMargin: 0
			top: switchWPBText.bottom
			topMargin: 30
		}
	}
	
	OnOffToggle {
		id: enableAutoOnToggle
		height: isNxt ? 45 : 36
		anchors.left: enableAutoOnLabel.right
		anchors.leftMargin: 10
		anchors.bottom: enableAutoOnLabel.bottom
		leftIsSwitchedOn: false
		onSelectedChangedByUser: {
		}
	}	

	StandardButton {
		id: btnHelpAutoOn
		text: "?"
		anchors.left: enableAutoOnToggle.right
		anchors.bottom: enableAutoOnToggle.bottom
		anchors.leftMargin: 10
		onClicked: {
			qdialog.showDialog(qdialog.SizeLarge, "WPB automatisch aan", "Hiermee wordt de URL voor WPB aanschakelen aangeroepen als de temperatuur lager of gelijk is aan de ingestelde temperatuur. Er wordt alleen eenmalig geschakeld als de temperatuur eerst boven deze ingestelde temperatuur is gestegen. Let op: verdere werking is afhankelijk van wat er achter deze URL zit.\n", "Sluiten");
		}
	}

	TemperatureSet {
		id: tempWPBOn
		anchors {
			left: enableAutoOnLabel.left
			leftMargin: 30
			top: enableAutoOnLabel.bottom
			topMargin: 5
		}
//		label: "WPB aan"
//			color: app.thermStateColor[app.thermStateAway]
		temperature: app.tempWPBOn
		onTemperatureChanged: {
			if (tempWPBOn.temperature >= (tempWPBOff.temperature - 5) ) {
				tempWPBOn.temperature = tempWPBOff.temperature - 5
			}
		}

	}
	
	Text {
		id: enableAutoOffLabel
//		width: isNxt ? 240 : 200
		height: isNxt ? 45 : 36
		text: "Schakel automatisch uit: "
		font.family: qfont.semiBold.name
		font.pixelSize: isNxt ? 25 : 20
		anchors {
			left: enableAutoOnToggle.right
			leftMargin: 50
			top: enableAutoOnLabel.top
		}
	}
	
	OnOffToggle {
		id: enableAutoOffToggle
		height: isNxt ? 45 : 36
		anchors.left: enableAutoOffLabel.right
		anchors.leftMargin: 10
		anchors.bottom: enableAutoOffLabel.bottom
		leftIsSwitchedOn: false
		onSelectedChangedByUser: {
		}
	}	

	StandardButton {
		id: btnHelpAutoOff
		text: "?"
		anchors.left: enableAutoOffToggle.right
		anchors.bottom: enableAutoOffToggle.bottom
		anchors.leftMargin: 10
		onClicked: {
			qdialog.showDialog(qdialog.SizeLarge, "WPB automatisch uit", "Hiermee wordt de URL voor WPB uitschakelen aangeroepen als de ingestelde temperatuur wordt bereikt. Er wordt alleen eenmalig geschakeld als de temperatuur eerst 2 graden onder deze ingestelde temperatuur is gezakt. Let op: verdere werking is afhankelijk van wat er achter deze URL zit.\n", "Sluiten");
		}
	}


	TemperatureSet {
		id: tempWPBOff
		anchors {
			left: enableAutoOffLabel.left
			leftMargin: 30
			top: enableAutoOffLabel.bottom
			topMargin: 5
		}
//		label: "WPB uit"
//			color: app.thermStateColor[app.thermStateAway]
		temperature: app.tempWPBOff

		onTemperatureChanged: {
			if (tempWPBOff.temperature <= (tempWPBOn.temperature + 5) ) {
				tempWPBOff.temperature = tempWPBOn.temperature + 5
			}
		}
	}



	Item {
		id: header
		height: isNxt ? 240 : 210
		anchors.horizontalCenter: parent.horizontalCenter
		width: isNxt ? parent.width - 95 : parent.width - 76

		Text {
			id: headerText1
			text: "Tijdstip"
			font.family: qfont.semiBold.name
			font.pixelSize: isNxt ? 25 : 20
			anchors {
				left: header.left
				bottom: parent.bottom
			}
		}
		Text {
			id: headerText2
			text: "Temp."
			font.family: qfont.semiBold.name
			font.pixelSize: isNxt ? 25 : 20
			anchors {
				left: headerText1.right
				leftMargin: 85
				bottom: parent.bottom
			}
			width: isNxt ? 120 : 90
		}
		Text {
			id: headerText3
			text: "Actie"
			font.family: qfont.semiBold.name
			font.pixelSize: isNxt ? 25 : 20
			anchors {
				left: headerText2.right
				leftMargin: 5
				bottom: parent.bottom
			}
			width: isNxt ? 400 :300
		}

	}

    ListView {
            id: wpbcontrollerListView

            model: wpbcontrollerModel
            delegate: Rectangle
                {
                    width:  parent.width
                    height: 30

                    Text {
                        id: txtTime
                        text: time
                        font.pixelSize:  isNxt ? 20 : 16
                        font.family: qfont.regular.name
//                        color: colors.clockTileColor
                        anchors {
                            top: parent.top
                            left: parent.left
                            leftMargin: 5
                        }
                    }

                    Text {
                        id: txtTemperature
                        text: temperature
                        font.pixelSize:  isNxt ? 20 : 16
                        font.family: qfont.regular.name
//                        color: colors.clockTileColor
                        anchors {
                            top: parent.top
                            left: txtTime.right
                            leftMargin: 25
                        }
                        width: isNxt ? 100 : 70
                    }

                    Text {
                        id: txtAction
                        text: action
                        font.pixelSize:  isNxt ? 20 : 16
                        font.family: qfont.regular.name
//                        color: colors.clockTileColor
                        anchors {
                            top: parent.top
                            left: txtTemperature.right
                            leftMargin: 5
                        }
						clip: true
                        width: isNxt ? 600 :500
                    }
                }

            visible: true

            anchors {
                top: header.bottom
                bottom: parent.bottom
                left: parent.left
                right: parent.right
                topMargin: 5
                leftMargin:  20
                rightMargin:  20
            }
    }


	Text {
		id: footer
		text: "Laatste gelukte update van: " + ((app.wpbcontrollerLastUpdateTime.length == 0 ) ? "N/A" : app.wpbcontrollerLastUpdateTime) + ". Verversing elke " + app.wpbcontrollerRefreshIntervalMinutes + " min. Laatste responscode: " + app.wpbcontrollerLastResponseStatus
		anchors {
			baseline: parent.bottom
			baselineOffset: -5
			right: parent.right
			rightMargin: 15
		}
		font {
			pixelSize: isNxt ? 18 : 15
			family: qfont.italic.name
		}
	}

    ListModel {
            id: wpbcontrollerModel
    }

}
