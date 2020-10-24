import QtQuick 2.1

import qb.base 1.0
import qb.components 1.0
import BasicUIControls 1.0;

// was TemperatureModeSet

Column {
	id: thermostatModeSet

	width: Math.round(165 * horizontalScaling);
	spacing: Math.round(4 * verticalScaling)

//	property alias label: label.text
//	property alias color: modeColor.color
	property alias temperature: modeValue.value
	property int textColorGap: 2
//	property string kpiPrefix: "TemperaturePresetScreen." + label.text + "."

/*
	Text {
		id: label

		font.family: qfont.semiBold.name
		font.pixelSize: qfont.navigationTitle

		color: colors.tpModeLabel
	}

	Item {
		height: Math.round(textColorGap * verticalScaling)
		width: 1
	}

	StyledRectangle {
		id: modeColor

		width:parent.width
		height: Math.round(16 * verticalScaling)
		radius: designElements.radius
		bottomLeftRadiusRatio: 0
		bottomRightRadiusRatio: 0
	}
*/
	NumberSpinner {
		id: modeValue

		height: Math.round(58 * verticalScaling)
		width:parent.width

		spacing: Math.round(4 * horizontalScaling)
		radius: designElements.radius
		buttonWidth: Math.round(53 * verticalScaling)

		anchors.topMargin: Math.round(4 * verticalScaling)

		topLeftRadiusRatio: 0
		topRightRadiusRatio: 0

		fontFamily: qfont.regular.name
		fontPixelSize: qfont.spinnerText
		fontColor: colors.tpModeValue
		textBaseline: Math.round(44 * verticalScaling)

		backgroundColor:            colors.tpBackgroundValue
		backgroundColorButtonsUp:   colors.tpBackgroundButtonsUp
		backgroundColorButtonsDown: colors.tpBackgroundButtonsDown
		overlayColorButtonsUp:      colors.tpOverlayButtonsUp
		overlayColorButtonsDown:    colors.tpOverlayButtonsDown

		rangeMin: 20
		rangeMax: 80
		maxValidDecimals: 0
		disableButtonAtMaximum: true
		disableButtonAtMinimum: true
		increment: 1
		valueSuffix: "°"
	}
}
