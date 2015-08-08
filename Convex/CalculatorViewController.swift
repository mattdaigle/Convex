//
//  CalculatorViewController.swift
//  Convex
//
//  Created by Matthew Daigle on 3/1/15.
//  Copyright (c) 2015 Matt Daigle. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {

	@IBOutlet weak var button0: UIButton!
	@IBOutlet weak var button1: UIButton!
	@IBOutlet weak var button2: UIButton!
	@IBOutlet weak var button3: UIButton!
	@IBOutlet weak var button4: UIButton!
	@IBOutlet weak var button5: UIButton!
	@IBOutlet weak var button6: UIButton!
	@IBOutlet weak var button7: UIButton!
	@IBOutlet weak var button8: UIButton!
	@IBOutlet weak var button9: UIButton!
	@IBOutlet weak var buttonA: UIButton!
	@IBOutlet weak var buttonB: UIButton!
	@IBOutlet weak var buttonC: UIButton!
	@IBOutlet weak var buttonD: UIButton!
	@IBOutlet weak var buttonE: UIButton!
	@IBOutlet weak var buttonF: UIButton!
	@IBOutlet weak var buttonHex: UIButton!
	@IBOutlet weak var buttonDec: UIButton!
	@IBOutlet weak var buttonOct: UIButton!
	@IBOutlet weak var buttonBin: UIButton!
	@IBOutlet weak var numberLabel: SpringLabel!
	@IBOutlet weak var binaryTopLabel: SpringLabel!
	@IBOutlet weak var binaryBottomLabel: SpringLabel!
	@IBOutlet weak var twosComplementButton: UIButton!
	@IBOutlet weak var byteFlipButton: UIButton!
	@IBOutlet weak var copyButton: UIButton!
	@IBOutlet weak var clearButton: UIButton!
	@IBOutlet weak var backspaceButton: UIButton!
	@IBOutlet weak var rightBitBottomLabel: UILabel!
	@IBOutlet weak var centerBitBottomLabel: UILabel!
	@IBOutlet weak var leftBitBottomLabel: UILabel!
	@IBOutlet weak var rightBitTopLabel: UILabel!
	@IBOutlet weak var centerBitTopLabel: UILabel!
	@IBOutlet weak var leftBitTopLabel: UILabel!
	@IBOutlet weak var binaryView: UIView!
	@IBOutlet weak var binaryLowerView: UIView!
	@IBOutlet weak var binaryUpperView: UIView!
	@IBOutlet weak var binaryLowerViewTopConstraint: NSLayoutConstraint!
	
	var displayType = "hex"
	var operationButtons = [UIButton]()
	var converterButtons = [UIButton]()
	var bitIndicatorLabels = [UILabel]()
	var hexButtons = [UIButton]()
	var decButtons = [UIButton]()
	var octButtons = [UIButton]()
	var binButtons = [UIButton]()
	var calculatorBrain = CalculatorModel()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		if calculatorBrain.cpuRegisterSize == 32 {
			// Move the top constraint from the upper binary view to the two's complement button.
			binaryView.removeConstraint(binaryLowerViewTopConstraint)
			binaryView.addConstraint(NSLayoutConstraint(item: binaryLowerView, attribute: .Top, relatedBy: .Equal, toItem: binaryView, attribute: .Top, multiplier: 1.0, constant: 15))
		}
		
		operationButtons = [twosComplementButton, byteFlipButton, copyButton, clearButton, backspaceButton]
		converterButtons = [buttonHex, buttonDec, buttonOct, buttonBin]
		binButtons = [button0, button1]
		octButtons = binButtons + [button2, button3, button4, button5, button6, button7]
		decButtons = octButtons + [button8, button9]
		hexButtons = decButtons + [buttonA, buttonB, buttonC, buttonD, buttonE, buttonF]
		bitIndicatorLabels = [rightBitBottomLabel, centerBitBottomLabel, leftBitBottomLabel, rightBitTopLabel, centerBitTopLabel, leftBitTopLabel]
		
		showNonBinaryLabel()
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		
		let numberButtonFontSize = button0.frame.height/2.3
		let converterButtonFontSize = buttonHex.frame.height/2.2
		let operationButtonFontSize = backspaceButton.frame.height/2.2
		let numberLabelFontSize = numberLabel.frame.height/2
		
		let numberButtonFont = UIFont.systemFontOfSize(numberButtonFontSize, weight: UIFontWeightThin)
		let converterButtonFont = UIFont.systemFontOfSize(converterButtonFontSize, weight: UIFontWeightLight)
		let operationButtonFont = UIFont.systemFontOfSize(operationButtonFontSize, weight: UIFontWeightLight)
		let numberLabelFont: UIFont
		let binaryLabelFont: UIFont
		let bitIndicatorFont: UIFont
		if #available(iOS 9.0, *) {
			numberLabelFont = UIFont.monospacedDigitSystemFontOfSize(numberLabelFontSize, weight: UIFontWeightUltraLight)
			binaryLabelFont = UIFont.monospacedDigitSystemFontOfSize(20, weight: UIFontWeightRegular)
			bitIndicatorFont = UIFont.monospacedDigitSystemFontOfSize(12, weight: UIFontWeightRegular)
		} else {
			numberLabelFont = UIFont.systemFontOfSize(numberLabelFontSize, weight: UIFontWeightUltraLight)
			binaryLabelFont = UIFont.systemFontOfSize(20, weight: UIFontWeightUltraLight)
			bitIndicatorFont = UIFont.systemFontOfSize(binaryTopLabel.font.capHeight, weight: UIFontWeightRegular)
		}
		
		// Adjust the font sizes.
		numberLabel.font = numberLabelFont
		binaryTopLabel.font = binaryLabelFont
		binaryBottomLabel.font = binaryLabelFont
		for button in hexButtons {
			button.titleLabel!.font = numberButtonFont
		}
		for button in converterButtons {
			button.titleLabel!.font = converterButtonFont
		}
		for button in operationButtons {
			button.titleLabel!.font = operationButtonFont
		}
		for label in bitIndicatorLabels {
			label.font = bitIndicatorFont
		}
	}
	
	func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
		return false
	}
	
	override func canBecomeFirstResponder() -> Bool {
		return true
	}
	
	override func motionBegan(motion: UIEventSubtype, withEvent event: UIEvent?) {
		if motion == .MotionShake {
			clearNumber()
		}
	}
	
	func selectButton(selectedButton: UIButton) {
		for button in converterButtons {
			if button == selectedButton {
				button.setBackgroundImage(UIImage(named: "rectangle_black"), forState: UIControlState.Normal)
				button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
			} else {
				button.setBackgroundImage(UIImage(named: "rectangle_gray_light"), forState: UIControlState.Normal)
				button.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
			}
		}
	}
	
	// MARK: Button State Handlers
	
	func enableEssentialNumberButtons() {
		var buttonsToEnable = [UIButton]()
		
		if displayType != "hex" {
			// Disable all buttons.
			for button in hexButtons {
				button.enabled = false
			}
		}
		
		// Enable the buttons needed for the current number type.
		switch(displayType) {
		case "hex":
			buttonsToEnable = hexButtons
		case "dec":
			buttonsToEnable = decButtons
		case "oct":
			buttonsToEnable = octButtons
		case "bin":
			buttonsToEnable = binButtons
		default: break
		}
		
		for button in buttonsToEnable {
			button.enabled = true
		}
	}
	
	func addSpaceEveryFourBits(binaryString: String) -> String {
		var formattedString = String()
		
		for (index, character) in binaryString.characters.enumerate() {
			if index % 4 == 0 && index > 0 {
				formattedString.append(Character(" "))
			}
			
			formattedString.append(character)
		}
		
		return formattedString
	}
	
	func padBinaryString(binaryString: String, toSize: Int) -> String {
		var padded = binaryString
		
		for _ in 0..<toSize - binaryString.characters.count {
			padded = "0" + padded
		}
		
		return padded
	}
	
	func showNonBinaryLabel() {
		numberLabel.hidden = false
		binaryView.hidden = true
	}
	
	func showBinaryLabels() {
		numberLabel.hidden = true
		binaryView.hidden = false
		binaryUpperView.hidden = calculatorBrain.cpuRegisterSize == 32 ? true : false
	}
	
	func animateLabel(label: SpringLabel, animation: String, curve: String, duration: CGFloat) {
		label.animation = animation
		label.curve = curve
		label.duration = duration
		label.animate()
	}
	
	// MARK: IBActions
	
	@IBAction func handleDoubleTap(recognizer: UITapGestureRecognizer) {
		copyNumber()
	}
	
	@IBAction func handleSwipe(recognizer: UISwipeGestureRecognizer) {
		clearNumber()
	}
	
	@IBAction func twosComplement() {
		displayValue = calculatorBrain.twosComplement(displayValue)
	}
	
	@IBAction func flipBytes() {
		displayValue = calculatorBrain.flipBytes(displayValue)
	}
	
	@IBAction func copyNumber() {
		let animation = "flash"
		let curve = "linear"
		let duration: CGFloat = 0.075
		let numberString: String
		
		// Add an animation as feedback that the number was copied.
		if displayType == "bin" {
			animateLabel(binaryTopLabel, animation: animation, curve: curve, duration: duration)
			animateLabel(binaryBottomLabel, animation: animation, curve: curve, duration: duration)
			
			numberString = calculatorBrain.cpuRegisterSize == 32 ? binaryBottomLabel.text! : binaryTopLabel.text! + " " + binaryBottomLabel.text!
		} else {
			animateLabel(numberLabel, animation: animation, curve: curve, duration: duration)
			
			numberString = numberLabel.text!
		}
		
		UIPasteboard.generalPasteboard().string = numberString
	}
	
	@IBAction func clearNumber() {
		if displayValue > 0 {
			let animation = "shake"
			let curve = "spring"
			let duration = CGFloat(0.9)
			
			// Add an animation for when the number label's text changes.
			if displayType == "bin" {
				animateLabel(binaryTopLabel, animation: animation, curve: curve, duration: duration)
				animateLabel(binaryBottomLabel, animation: animation, curve: curve, duration: duration)
			} else {
				animateLabel(numberLabel, animation: animation, curve: curve, duration: duration)
			}
			
			displayValue = 0
		}
	}
	
	@IBAction func backspace() {
		displayValue /= radixValue[displayType]!
	}
	
	@IBAction func convertNumber(sender: UIButton) {
		let currentValue = displayValue
		displayType = sender.currentTitle!
		displayValue = currentValue
		
		selectButton(sender)
		enableEssentialNumberButtons()
		if displayType == "bin" {
			showBinaryLabels()
		} else {
			showNonBinaryLabel()
		}
	}
	
	@IBAction func appendDigit(sender: UIButton) {
		displayValue = calculatorBrain.appendDigit(displayValue, digit: sender.currentTitle!, type: displayType)
	}
	
	var displayValue: UInt {
		get {
			// Remove commas from the number just in case it's a formatted decimal number.
			var number = numberLabel.text!.stringByReplacingOccurrencesOfString(",", withString: "", options: [], range: nil)
			
			if displayType == "bin" {
				// Remove spaces from the number.
				number = binaryTopLabel.text!.stringByReplacingOccurrencesOfString(" ", withString: "", options: [], range: nil) + binaryBottomLabel.text!.stringByReplacingOccurrencesOfString(" ", withString: "", options: [], range: nil)
			}
			
			return UInt(strtoul(number, nil, Int32(radixValue[displayType]!)))
		}
		
		set {
			switch(displayType) {
			case "hex":
				numberLabel.text = "0x" + String(newValue, radix: 16, uppercase: true)
			case "dec":
				var decimalString = String(newValue, radix: 10)
				var formattedDecimalString = String()
				
				// Formatting the decimal string manually because NSNumberFormatter is displaying two's complement as a negative number.
				let firstCommaIndex = decimalString.characters.count % 3
				for (index, character) in decimalString.characters.enumerate() {
					if decimalString.characters.count > 3 {
						if (index == firstCommaIndex || (index - firstCommaIndex) % 3 == 0) && index > 0 {
							formattedDecimalString.append(Character(","))
						}
					}
					
					formattedDecimalString.append(character)
				}
				
				numberLabel.text = formattedDecimalString
			case "oct":
				numberLabel.text = String(newValue, radix: 8)
			case "bin":
				var binaryString = String(newValue, radix: 2)
				var lowerString = String()
				var upperString = String()
				var formattedLowerString = String()
				var formattedUpperString = String()
				
				// Pad the string with zeroes.
				for _ in 0..<calculatorBrain.cpuRegisterSize - binaryString.characters.count {
					binaryString = "0" + binaryString
				}
				
				if calculatorBrain.cpuRegisterSize == 32 {
					formattedLowerString = addSpaceEveryFourBits(binaryString)
				} else {
					// Split the bits in half.
					upperString = binaryString.substringWithRange(Range<String.Index>(start: binaryString.startIndex, end: advance(binaryString.endIndex, -32)))
					lowerString = binaryString.substringWithRange(Range<String.Index>(start: advance(binaryString.startIndex, 32), end: binaryString.endIndex))
					
					formattedLowerString = addSpaceEveryFourBits(lowerString)
					formattedUpperString = addSpaceEveryFourBits(upperString)
				}
				
				binaryBottomLabel.text = formattedLowerString
				binaryTopLabel.text = formattedUpperString
			default: break
			}
		}
	}
	
}

