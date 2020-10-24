import QtQuick 2.1
import qb.components 1.0
import BasicUIControls 1.0;
 
Screen {
	id: wpbcontrollerConfigurationScreen
	screenTitle: "Instellingen WPB controller app"

	onShown: {
//		app.stopGetTempUpdatesTimer();
		addCustomTopRightButton("Opslaan");
		enableSystrayToggle.isSwitchedOn = app.enableSystray;
		enableWPBToggle.isSwitchedOn = app.enableWPB;
		urlTempLabel.inputText = app.wpbcontrollerUrlTemp;
		urlWPBOnLabel.inputText = app.wpbcontrollerUrlWPBOn;
		urlWPBOffLabel.inputText = app.wpbcontrollerUrlWPBOff;
		expressieTempLabel.inputText = app.wpbcontrollerExpressieTemp;
		intervalLabel.inputText = app.wpbcontrollerRefreshIntervalMinutes;
		showResultButton.visible = false;
		showTempButton.visible = false;
	}

	onCustomButtonClicked: {
		if (app.wpbcontrollerRefreshIntervalMinutes < 1) {
			app.wpbcontrollerRefreshIntervalMinutes = 1;
		}
		app.saveSettings();
//		app.startGetTempUpdatesTimer();
		hide();
	}


	function saveUrlTemp(text) {
		if (text) {
			app.wpbcontrollerUrlTemp = text;
			urlTempLabel.inputText = app.wpbcontrollerUrlTemp;
		}
	}

	function saveUrlWPBOn(text) {
		if (text) {
			app.wpbcontrollerUrlWPBOn = text;
			urlWPBOnLabel.inputText = app.wpbcontrollerUrlWPBOn;
		}
	}

	function saveUrlWPBOff(text) {
		if (text) {
			app.wpbcontrollerUrlWPBOff = text;
			urlWPBOffLabel.inputText = app.wpbcontrollerUrlWPBOff;
		}
	}

	function saveExpressieTemp(text) {
		if (text) {
			app.wpbcontrollerExpressieTemp = text;
			expressieTempLabel.inputText = app.wpbcontrollerExpressieTemp;
		}
	}

	function saveInterval(text) {
		if (text) {
			app.wpbcontrollerRefreshIntervalMinutes = parseInt(text);
			intervalLabel.inputText = app.wpbcontrollerRefreshIntervalMinutes;
		}
	}

	function validateInterval(text, isFinalString) {
		if (isFinalString) {
			if (parseInt(text) < 1) return {title: "Te kleine waarde", content: "Minimum aantal minuten is 1"};
		}
		if (isFinalString) {
			if (parseInt(text) > 60) return {title: "Te hoog waarde", content: "Maximum update interval is 60 minuten"};
		}
		return null;
	}

	
	EditTextLabel4421 {
		id: urlTempLabel
		width: parent.width - 170
		height: isNxt ? 45 : 35
		leftText: "Url WPB temperatuur:"
		leftTextAvailableWidth: isNxt ?  270 : 215

		anchors {
			left: parent.left
			leftMargin: 40
			top: parent.top
			topMargin: 10
		}

		onClicked: {
			qkeyboard.open("Url om WPB temperatuur op te vragen", urlTempLabel.inputText, saveUrlTemp);
			showResultButton.visible = false;
			showTempButton.visible = false;

		}
	}

	IconButton {
		id: urlTempButton
		width: isNxt ? 50 : 40

		iconSource: "qrc:/tsc/edit.png"

		anchors {
			left: urlTempLabel.right
			leftMargin: 6
			top: urlTempLabel.top
		}

		bottomClickMargin: 3
		onClicked: {
			qkeyboard.open("Url om WPB temperatuur op te vragen", urlTempLabel.inputText, saveUrlTemp);
			showResultButton.visible = false;
			showTempButton.visible = false;
		}
	}

	StandardButton {
		id: btnHelpUrlTemp
		text: "?"
		anchors.left: urlTempButton.right
		anchors.bottom: urlTempButton.bottom
		anchors.leftMargin: 10
		onClicked: {
			qdialog.showDialog(qdialog.SizeLarge, "URL temperatuur WPB", "Voer de URL in waarmee de de temperatuur van de WPB kan worden opgevraagd. Met deze URL wordt een GET request uitgevoerd. Met de reguliere expressie kan de temperatuur uit de respons worden bepaald.\n", "Sluiten");
		}
	}

	EditTextLabel4421 {
		id: urlWPBOnLabel
		width: urlTempLabel.width
		height: isNxt ? 45 : 35
		leftText: "Url WPB aan:"
		leftTextAvailableWidth: isNxt ?  270 : 215

		anchors {
			left: urlTempLabel.left
			top: urlTempLabel.bottom
			topMargin: 12
		}

		onClicked: {
			qkeyboard.open("Url om WPB aan te zetten", urlWPBOnLabel.inputText, saveUrlWPBOn);
		}
	}

	IconButton {
		id: urlWPBOnButton
		width: isNxt ? 50 : 40
		iconSource: "qrc:/tsc/edit.png"

		anchors {
			left: urlWPBOnLabel.right
			leftMargin: 6
			top: urlWPBOnLabel.top
		}

		topClickMargin: 3
		onClicked: {
			qkeyboard.open("Url om WPB aan te zetten", urlWPBOnLabel.inputText, saveUrlWPBOn);
		}
	}

	StandardButton {
		id: btnHelpUrlWPBOn
		text: "?"
		anchors.left: urlWPBOnButton.right
		anchors.bottom: urlWPBOnButton.bottom
		anchors.leftMargin: 10
		onClicked: {
			qdialog.showDialog(qdialog.SizeLarge, "URL WPB aanzetten", "De URL waarmee de WPB aan kan worden gezet. Er wordt een GET request uitgevoerd.\n", "Sluiten");
		}
	}

	EditTextLabel4421 {
		id: urlWPBOffLabel
		width: urlTempLabel.width
		height: isNxt ? 45 : 35
		leftText: "Url WPB uit:"
		leftTextAvailableWidth: isNxt ?  270 : 215

		anchors {
			left: urlWPBOnLabel.left
			top: urlWPBOnLabel.bottom
			topMargin: 12
		}

		onClicked: {
			qkeyboard.open("Url om WPB uit te zetten", urlWPBOnLabel.inputText, saveUrlWPBOn);
		}
	}

	IconButton {
		id: urlWPBOffButton
		width: isNxt ? 50 : 40
		iconSource: "qrc:/tsc/edit.png"

		anchors {
			left: urlWPBOffLabel.right
			leftMargin: 6
			top: urlWPBOffLabel.top
		}

		topClickMargin: 3
		onClicked: {
			qkeyboard.open("Url om WPB uit te zetten", urlWPBOffLabel.inputText, saveUrlWPBOff);
		}
	}

	StandardButton {
		id: btnHelpUrlWPBOff
		text: "?"
		anchors.left: urlWPBOffButton.right
		anchors.bottom: urlWPBOffButton.bottom
		anchors.leftMargin: 10
		onClicked: {
			qdialog.showDialog(qdialog.SizeLarge, "URL WPB uitzetten", "De URL waarmee de WPB uit kan worden gezet. Er wordt een GET request uitgevoerd.\n", "Sluiten");
		}
	}

	EditTextLabel4421 {
		id: expressieTempLabel
		width: urlTempLabel.width
		height: isNxt ? 45 : 35
		leftText: "Regex temperatuur:"
		leftTextAvailableWidth: isNxt ?  270 : 215

		anchors {
			left: urlWPBOffLabel.left
			top: urlWPBOffLabel.bottom
			topMargin: 12
		}

		onClicked: {
			qkeyboard.open("Reguliere expressie voor temperatuur", expressieTempLabel.inputText, saveExpressieTemp);
			showResultButton.visible = false;
			showTempButton.visible = false;
		}
	}

	IconButton {
		id: expressieTempButton
		width: isNxt ? 50 : 40
		iconSource: "qrc:/tsc/edit.png"

		anchors {
			left: expressieTempLabel.right
			leftMargin: 6
			top: expressieTempLabel.top
		}

		topClickMargin: 3
		onClicked: {
			qkeyboard.open("Reguliere expressie voor temperatuur", expressieTempLabel.inputText, saveExpressieTemp);
			showResultButton.visible = false;
			showTempButton.visible = false;
		}
	}

	StandardButton {
		id: btnHelpExpressieTemp
		text: "?"
		anchors.left: expressieTempButton.right
		anchors.bottom: expressieTempButton.bottom
		anchors.leftMargin: 10
		onClicked: {
			qdialog.showDialog(qdialog.SizeLarge, "Reguliere expressie voor temperatuur", "Voer hier de reguliere expressie in om uit de respons van de temperatuur URL de temperatuur te bepalen. In de eerste capture group moet de waarde van de temperatuur terecht komen. Er mag alleen maar een numerieke waarde uitkomen. Zie ook de beschrijving van deze app op het Toon forum. Gebruik de test knop om de reguliere expressie te controleren.\n", "Sluiten");
		}
	}

	EditTextLabel4421 {
		id: intervalLabel
		width: 325
		height: isNxt ? 45 : 35
		leftText: "Refresh temperatuur:"
		leftTextAvailableWidth: isNxt ?  270 : 215

		anchors {
			left: expressieTempLabel.left
			top: expressieTempLabel.bottom
			topMargin: 12
		}

		onClicked: {
			qnumKeyboard.open("Ververs interval temperatur in minuten", intervalLabel.inputText, app.wpbcontrollerRefreshIntervalMinutes, 1 , saveInterval, validateInterval);
		}
	}

	IconButton {
		id: intervalButton
		width: isNxt ? 50 : 40
		iconSource: "qrc:/tsc/edit.png"

		anchors {
			left: intervalLabel.right
			leftMargin: 6
			top: intervalLabel.top
		}

		topClickMargin: 3
		onClicked: {
			qnumKeyboard.open("Ververs interval temperatur in minuten", intervalLabel.inputText, app.wpbcontrollerRefreshIntervalMinutes, 1 , saveInterval, validateInterval);
		}
	}
	
	StandardButton {
		id: btnHelpInterval
		text: "?"
		anchors.left: intervalButton.right
		anchors.bottom: intervalButton.bottom
		anchors.leftMargin: 10
		onClicked: {
			qdialog.showDialog(qdialog.SizeLarge, "Refresh interval temperatuur", "Voer hier de waarde in minuten in waarmee de temperatuur moet werden ververst. Met dit interval wordt de temperatuur URL aangeroepen.\n", "Sluiten");
		}
	}

	Text {
		id: enableWPBLabel
		width: isNxt ? 330 : 270
		height: isNxt ? 45 : 36
		text: "WPB controller geactiveerd"
		font.family: qfont.semiBold.name
		font.pixelSize: isNxt ? 25 : 20
		anchors {
			left: parent.left
			leftMargin: 40
			top: intervalLabel.bottom
			topMargin: 12
		}
	}
	
	OnOffToggle {
		id: enableWPBToggle
		height: isNxt ? 45 : 36
		anchors.left: enableWPBLabel.right
		anchors.leftMargin: 10
		anchors.bottom: enableWPBLabel.bottom
		leftIsSwitchedOn: false
		onSelectedChangedByUser: {
			if (isSwitchedOn) {
				app.enableWPB = true;
			} else {
				app.enableWPB = false;
			}
		}
	}

	StandardButton {
		id: btnHelpenableWPB
		text: "?"
		anchors.left: enableWPBToggle.right
		anchors.bottom: enableWPBToggle.bottom
		anchors.leftMargin: 10
		onClicked: {
			qdialog.showDialog(qdialog.SizeLarge, "WPB controller geactiveerd", "Hiermee wordt de mogelijkheid tot het automatisch besturen van de WPB aan of uit geschakeld. Instellingen staan op het voorgaande scherm.\n", "Sluiten");
		}
	}

	Text {
		id: enableSystrayLabel
		width: isNxt ? 330 : 270
		height: isNxt ? 45 : 36
		text: "Icon in systray"
		font.family: qfont.semiBold.name
		font.pixelSize: isNxt ? 25 : 20
		anchors {
			left: parent.left
			leftMargin: 40
			top: enableWPBLabel.bottom
			topMargin: 12
		}
	}
	
	OnOffToggle {
		id: enableSystrayToggle
		height: isNxt ? 45 : 36
		anchors.left: enableSystrayLabel.right
		anchors.leftMargin: 10
		anchors.bottom: enableSystrayLabel.bottom
		leftIsSwitchedOn: false
		onSelectedChangedByUser: {
			if (isSwitchedOn) {
				app.enableSystray = true;
			} else {
				app.enableSystray = false;
			}
		}
	}

	StandardButton {
		id: testButton
		text: "Test temperatuur ophalen"
		anchors {
			left: expressieTempLabel.left
			bottom: parent.bottom
			bottomMargin: 25
		}

		rightClickMargin: 2
		bottomClickMargin: 5

		selected: false
		visible : (app.wpbcontrollerUrlTemp.length > 5 ? true : false )

		onClicked: {
			app.getTemp();
			showResultButton.visible = true;
			showTempButton.visible = true;
		}
	}

	StandardButton {
		id: showResultButton
		text: "Respons temperatuur"
		anchors {
			left: testButton.right
			leftMargin: 20
			top: testButton.top
		}

		rightClickMargin: 2
		bottomClickMargin: 5

		selected: false
		visible : false

		onClicked: {
			qdialog.showDialog(qdialog.SizeLarge, "Respons file /tmp/wpbcontroller-response1.txt", app.readResponse1File(), "Sluiten");
		}
	}

	StandardButton {
		id: showTempButton
		text: "Temperatuur string"
		anchors {
			left: showResultButton.right
			leftMargin: 20
			top: showResultButton.top
		}

		rightClickMargin: 2
		bottomClickMargin: 5

		selected: false
		visible : false

		onClicked: {
			qdialog.showDialog(qdialog.SizeLarge, "Temperatuur string", "Als hieronder niets komt te staan is de regex niet correct.\n\n" + app.readResult1File(), "Sluiten");
		}
	}


}
