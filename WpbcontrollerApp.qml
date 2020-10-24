import QtQuick 2.1
import qb.components 1.0
import qb.base 1.0
import FileIO 1.0
 
App {
	id: wpbcontrollerApp

	property url tileUrl : "WpbcontrollerTile.qml"
	property url thumbnailIcon: "qrc:/tsc/wpbcontrollerSmall.png"
	
	property url  wpbcontrollerScreenUrl : "WpbcontrollerScreen.qml"
	property url  wpbcontrollerConfigurationScreenUrl : "WpbcontrollerConfigurationScreen.qml"
	property url trayUrl : "WpbcontrollerTray.qml"

	property WpbcontrollerConfigurationScreen wpbcontrollerConfigurationScreen
	property WpbcontrollerScreen wpbcontrollerScreen

	// for Tile
    property string tileStatus : "Wachten op data....."
    property string tileLastcmd : ""

	// settings
	property string wpbcontrollerUrlTemp : ""
	property string wpbcontrollerUrlWPBOn : ""
	property string wpbcontrollerUrlWPBOff : ""
	property string wpbcontrollerExpressieTemp : ""
    property int wpbcontrollerRefreshIntervalMinutes  : 5	// interval to retrieve temperature
	property bool enableSystray : false
	property bool enableWPBAutoOn : false
	property bool enableWPBAutoOff : false
	property bool enableWPB : false
	property int tempWPBOn : 40
	property int tempWPBOff : 60
	

	// user settings from config file
	property variant wpbcontrollerSettingsJson 

	property bool settingChanged : false

	property string wpbTempStr 
	property int wpbTemp
	property bool allowedWPBOn : true
	property bool allowedWPBOff : true

	property string wpbcontrollerLastUpdateTime
	property string wpbcontrollerLastResponseStatus : "N/A"

	property int numberMessagesOnScreen : (isNxt ? 9 : 7)  

	property bool debugOutput : false						// Show console messages. Turn on in settings file !

	// signal, used to update the listview 
	signal wpbcontrollerUpdated()


	FileIO {
		id: wpbcontrollerSettingsFile
		source: "file:///mnt/data/tsc/wpbcontroller_userSettings.json"
 	}

	FileIO {
		id: wpbcontrollerResponse1File
		source: "file:///tmp/wpbcontroller-response1.txt"
 	}

	FileIO {
		id: wpbcontrollerResult1File
		source: "file:///tmp/wpbcontroller-result1.txt"
 	}


	
	Component.onCompleted: {
		// read user settings
		try {
			wpbcontrollerSettingsJson = JSON.parse(wpbcontrollerSettingsFile.read());
			if (wpbcontrollerSettingsJson['TrayIcon'] == "Yes") {
				enableSystray = true
			} else {
				enableSystray = false
			}
			if (wpbcontrollerSettingsJson['DebugOn'] == "Yes") {
				debugOutput = true
			} else {
				debugOutput = false
			}
			if (wpbcontrollerSettingsJson['WPBAutoOn'] == "Yes") {
				enableWPBAutoOn = true
			} else {
				enableWPBAutoOn = false
			}
			if (wpbcontrollerSettingsJson['WPBAutoOff'] == "Yes") {
				enableWPBAutoOff = true
			} else {
				enableWPBAutoOff = false
			}
			if (wpbcontrollerSettingsJson['WPB'] == "Yes") {
				enableWPB = true
			} else {
				enableWPB = false
			}

		if (debugOutput) console.log("********* WPBController onCompleted");

			wpbcontrollerUrlTemp = wpbcontrollerSettingsJson['UrlTemp'];		
			wpbcontrollerUrlWPBOn = wpbcontrollerSettingsJson['UrlWPBOn'];		
			wpbcontrollerUrlWPBOff = wpbcontrollerSettingsJson['UrlWPBOff'];		
			wpbcontrollerExpressieTemp = wpbcontrollerSettingsJson['ExpressieTemp'];	
			wpbcontrollerRefreshIntervalMinutes = wpbcontrollerSettingsJson['RefreshIntervalMinutes'];

			tempWPBOn = wpbcontrollerSettingsJson['tempWPBOn'];		
			tempWPBOff = wpbcontrollerSettingsJson['tempWPBOff'];		
			
		} catch(e) {
			if (debugOutput) console.log("********* WPBController onCompleted catch");
		}

		// clear response file
		var doc = new XMLHttpRequest();
		doc.open("PUT", "file:///tmp/wpbcontroller-response1.txt");
		doc.send("");



		startGetTempUpdatesTimer();
	}

	function init() {
		registry.registerWidget("tile", tileUrl, this, null, {thumbLabel: "Wpbcontroller", thumbIcon: thumbnailIcon, thumbCategory: "general", thumbWeight: 30, baseTileWeight: 10, thumbIconVAlignment: "center"});
		registry.registerWidget("screen", wpbcontrollerScreenUrl, this, "wpbcontrollerScreen");
		registry.registerWidget("screen", wpbcontrollerConfigurationScreenUrl, this, "wpbcontrollerConfigurationScreen");
		registry.registerWidget("systrayIcon", trayUrl, this, "wpbcontrollerTray");
	}

	function saveSettings() {
		// save user settings
		if (debugOutput) console.log("********* WPBController saveSettings");

		var tmpTrayIcon = "";
		var tmpDebugOn = "";
		var tmpWPBAutoOn = "";
		var tmpWPBAutoOff = "";
		var tmpWPB = "";
		
		if (enableSystray == true) {
			tmpTrayIcon = "Yes";
		} else {
			tmpTrayIcon = "No";
		}
		if (debugOutput == true) {
			tmpDebugOn = "Yes";
		} else {
			tmpDebugOn = "No";
		}
		if (enableWPBAutoOn == true) {
			tmpWPBAutoOn = "Yes";
		} else {
			tmpWPBAutoOn = "No";
		}
		if (enableWPBAutoOff == true) {
			tmpWPBAutoOff = "Yes";
		} else {
			tmpWPBAutoOff = "No";
		}
		if (enableWPB == true) {
			tmpWPB = "Yes";
		} else {
			tmpWPB = "No";
		}



 		var tmpUserSettingsJson = {
 			"TrayIcon"      			: tmpTrayIcon,
			"DebugOn"					: tmpDebugOn,
			"WPBAutoOn"					: tmpWPBAutoOn,
			"WPBAutoOff"				: tmpWPBAutoOff,
			"WPB"						: tmpWPB,
			"tempWPBOn"					: tempWPBOn,	
			"tempWPBOff"				: tempWPBOff,	
			"UrlTemp"      				: wpbcontrollerUrlTemp,
			"UrlWPBOn"      			: wpbcontrollerUrlWPBOn,
			"UrlWPBOff"      			: wpbcontrollerUrlWPBOff,
			"ExpressieTemp"     		: wpbcontrollerExpressieTemp,
			"RefreshIntervalMinutes" 	: wpbcontrollerRefreshIntervalMinutes

		}

  		var doc = new XMLHttpRequest();
   		doc.open("PUT", "file:///mnt/data/tsc/wpbcontroller_userSettings.json");
   		doc.send(JSON.stringify(tmpUserSettingsJson ));

	}

    function getTemp() {
		if (debugOutput) console.log("********* WPBController getTemp");

		// clear Tile
		tileStatus = "Ophalen Temp.....";
		wpbTemp = -1;
		
		// clear response file
		var doc = new XMLHttpRequest();
		doc.open("PUT", "file:///tmp/wpbcontroller-response1.txt");
		doc.send("");

		// clear result file
		var doc = new XMLHttpRequest();
		doc.open("PUT", "file:///tmp/wpbcontroller-result1.txt");
		doc.send("");

		if ( wpbcontrollerUrlTemp.length <= 0 ) {
			if (debugOutput) console.log("********* WPBController No URL configured");
			wpbTempStr = "N/A";
			return;
		}

		var xmlhttp = new XMLHttpRequest();
		
		xmlhttp.open("GET",wpbcontrollerUrlTemp, true);
        xmlhttp.onreadystatechange = function() {
            if (debugOutput) console.log("********* WPBController getTemp readyState: " + xmlhttp.readyState + " http status: " + xmlhttp.status);
            if (xmlhttp.readyState === XMLHttpRequest.DONE ) {

				wpbcontrollerLastResponseStatus = xmlhttp.status;

				// save response
				var doc = new XMLHttpRequest();
				doc.open("PUT", "file:///tmp/wpbcontroller-response1.txt");
				doc.send(xmlhttp.responseText);

				var now = new Date();
				wpbcontrollerLastUpdateTime = now.toLocaleString('nl-NL'); 

		
                if (xmlhttp.status === 200) {
                    if (debugOutput) console.log("********* WPBController getTemp response " + xmlhttp.response.replace(/\n|\r/g, "") );

                    if (debugOutput) console.log("********* WPBController getTemp wpbcontrollerExpressieTemp: " + wpbcontrollerExpressieTemp );

					try {
						var pattern = new RegExp(wpbcontrollerExpressieTemp);
						var tmpwpbTempStr = pattern.exec(xmlhttp.responseText);
					
						// save result
						var doc = new XMLHttpRequest();
						doc.open("PUT", "file:///tmp/wpbcontroller-result1.txt");
						doc.send(tmpwpbTempStr[1]);
						wpbTempStr = tmpwpbTempStr[1];
					}
					catch(e) {
						tileStatus = "Toepassen Regex mislukt.....";
						if (debugOutput) console.log("********* WPBController getTemp execute Regex failed");
						wpbTempStr = "Regex failed";
						return;
					}

					if (wpbTempStr.length === 0) {
						if (debugOutput) console.log("********* WPBController getTemp wpbTempStr is leeg");
						wpbTempStr = "Geen resultaat";
						return;
					}

                    if (debugOutput) console.log("********* WPBController getTemp wpbTempStr: " + wpbTempStr );
					
					try {
						wpbTemp = Math.round(wpbTempStr);
						if (debugOutput) console.log("********* WPBController getTemp wpbTemp: " + wpbTemp );
					}
					catch(e) {
						tileStatus = "Omzetten waarde mislukt.....";
						wpbTemp = -1;
						if (debugOutput) console.log("********* WPBController getTemp convert to number failed");
						return;
					}
					tileStatus = "Temp opgehaald.....";
					processTemp();

                } else {
                    if (debugOutput) console.log("********* WPBController getTemp fout opgetreden.");
					tileStatus = "Ophalen gegevens mislukt.....";
                }
            }
        }
        xmlhttp.send();
    }

    function processTemp() {
		if (debugOutput) console.log("********* WPBController processTemp");


		if (enableWPBAutoOff && allowedWPBOff ) {
			if (wpbTemp >= tempWPBOff ) {
				setWPBOff(true);
				allowedWPBOff = false;
				if (debugOutput) console.log("********* WPBController processTemp (enableWPBAutoOff && allowedWPBOff ) allowedWPBOff = false");
			}
		}

		if (enableWPBAutoOn && allowedWPBOn) {
			if (wpbTemp <= tempWPBOn ) {
				setWPBOn(true);
				allowedWPBOn = false;
				if (debugOutput) console.log("********* WPBController processTemp (enableWPBAutoOn && allowedWPBOn) allowedWPBOn = false");
			}
		}

		if (wpbTemp <= (tempWPBOff-2)) {
			if (debugOutput) console.log("********* WPBController processTemp (wpbTemp <= (tempWPBOff-2)) allowedWPBOff = true");
			allowedWPBOff = true;
		} 

		if (wpbTemp >= tempWPBOff) {
			allowedWPBOff = false;
			if (debugOutput) console.log("********* WPBController processTemp (wpbTemp >= tempWPBOff) allowedWPBOff = false");
		}
			
		if (wpbTemp > (tempWPBOn)) {
			if (debugOutput) console.log("********* WPBController processTemp (wpbTemp > (tempWPBOn) allowedWPBOn = true");
			allowedWPBOn = true;
		} 

	}


    function setWPBOn(automode) {
		if (debugOutput) console.log("********* WPBController setWPBOn");

		// clear Tile
		tileStatus = "WPB aan .....";
		
		if (automode){
			var action = "WPB aan, auto, TempOff: " + tempWPBOff + ", TempOn: " + tempWPBOn;
		} else {
			var action = "WPB aan, hand";
		}
		
		// clear response file
		var doc = new XMLHttpRequest();
		doc.open("PUT", "file:///tmp/wpbcontroller-response-WPBOn.txt");
		doc.send("");

		if ( wpbcontrollerUrlWPBOn.length <= 0 ) {
			if (debugOutput) console.log("********* WPBController setWPBOn No URL configured");
			return;
		}

		var xmlhttp = new XMLHttpRequest();
		
		xmlhttp.open("GET",wpbcontrollerUrlWPBOn, true);
        xmlhttp.onreadystatechange = function() {
            if (debugOutput) console.log("********* WPBController setWPBOn readyState: " + xmlhttp.readyState + " http status: " + xmlhttp.status);
            if (xmlhttp.readyState === XMLHttpRequest.DONE ) {

				// save response
				var doc = new XMLHttpRequest();
				doc.open("PUT", "file:///tmp/wpbcontroller-response-WPBOn.txt");
				doc.send(xmlhttp.responseText);

	
                if (xmlhttp.status === 200) {
                    if (debugOutput) console.log("********* WPBController setWPBOn response " + xmlhttp.response.replace(/\n|\r/g, "") );

                } else {
                    if (debugOutput) console.log("********* WPBController setWPBOn fout opgetreden.");
					tileStatus = "WPB aan mislukt.....";
                }

				action = action + ", result: " + xmlhttp.status;
				addCommandToList(action,wpbTemp);
            }
        }
        xmlhttp.send();
    }

    function setWPBOff(automode) {
		if (debugOutput) console.log("********* WPBController setWPBOff");

		// clear Tile
		tileStatus = "WPB uit .....";

		if (automode){
			var action = "WPB uit, auto, TempOff: " + tempWPBOff + ", TempOn: " + tempWPBOn;
		} else {
			var action = "WPB uit, hand";
		}
		
		// clear response file
		var doc = new XMLHttpRequest();
		doc.open("PUT", "file:///tmp/wpbcontroller-response-WPBOff.txt");
		doc.send("");

		if ( wpbcontrollerUrlWPBOff.length <= 0 ) {
			if (debugOutput) console.log("********* WPBController setWPBOff No URL configured");
			return;
		}

		var xmlhttp = new XMLHttpRequest();
		
		xmlhttp.open("GET",wpbcontrollerUrlWPBOff, true);
        xmlhttp.onreadystatechange = function() {
            if (debugOutput) console.log("********* WPBController setWPBOff readyState: " + xmlhttp.readyState + " http status: " + xmlhttp.status);
            if (xmlhttp.readyState === XMLHttpRequest.DONE ) {

				// save response
				var doc = new XMLHttpRequest();
				doc.open("PUT", "file:///tmp/wpbcontroller-response-WPBOff.txt");
				doc.send(xmlhttp.responseText);


                if (xmlhttp.status === 200) {
                    if (debugOutput) console.log("********* WPBController setWPBOff response " + xmlhttp.response.replace(/\n|\r/g, "") );

                } else {
                    if (debugOutput) console.log("********* WPBController setWPBOff fout opgetreden.");
					tileStatus = "WPB uit mislukt.....";
                }

				action = action + ", result: " + xmlhttp.status;
				addCommandToList(action,wpbTemp);
            }
        }
        xmlhttp.send();
    }



	function readResponse1File () {
        if (debugOutput) console.log("********* WPBController readResponseFile");
		return wpbcontrollerResponse1File.read();
	}

	function readResult1File () {
        if (debugOutput) console.log("********* WPBController readResultFile");
		return wpbcontrollerResult1File.read();
	}


    function addCommandToList(action,temperature) {
        if (debugOutput) console.log("********* WPBController addCommandToList");
        wpbcontrollerScreen.wpbcontrollerListModel.insert(0,{ time: (new Date().toLocaleString('nl-NL')),
                                action: action,
								temperature: temperature });
		// remove oldest message from screen
        if (wpbcontrollerScreen.wpbcontrollerListModel.count >= numberMessagesOnScreen) {
            wpbcontrollerScreen.wpbcontrollerListModel.remove(numberMessagesOnScreen-1,1);
        }
    }



	function stopGetTempUpdatesTimer() {
		getTempUpdatesTimer.stop();
	}

	function startGetTempUpdatesTimer() {
		getTempUpdatesTimer.start();
	}

		
	
	Timer {
        id: getTempUpdatesTimer
        interval: 10 * 1000;		// first update after 10 seconds
        triggeredOnStart: false
        running: false
        repeat: true
        onTriggered: {
            if (debugOutput) console.log("********* WPBController getTempUpdatesTimer triggered");
			if (wpbcontrollerRefreshIntervalMinutes < 1) {
				wpbcontrollerRefreshIntervalMinutes = 1;
			}
			interval = wpbcontrollerRefreshIntervalMinutes * 60 * 1000;
            if (enableWPB) {
				getTemp();
			} else {
				tileStatus = "Verversing uitgeschakeld";
			}
			
        }

    }
	
}
