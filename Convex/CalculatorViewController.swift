//
//  CalculatorViewController.swift
//  Convex
//
//  Created by Matthew Daigle on 3/1/15.
//  Copyright (c) 2015 Matt Daigle. All rights reserved.
//

import UIKit
import MessageUI

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
			binaryView.addConstraint(NSLayoutConstraint(item: binaryLowerView, attribute: .top, relatedBy: .equal, toItem: binaryView, attribute: .top, multiplier: 1.0, constant: 15))
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
		
		let numberButtonFont = UIFont.systemFont(ofSize: numberButtonFontSize, weight: UIFontWeightThin)
		let converterButtonFont = UIFont.systemFont(ofSize: converterButtonFontSize, weight: UIFontWeightLight)
		let operationButtonFont = UIFont.systemFont(ofSize: operationButtonFontSize, weight: UIFontWeightLight)
		let numberLabelFont: UIFont
		let binaryLabelFont: UIFont
		let bitIndicatorFont: UIFont
		if #available(iOS 9.0, *) {
			numberLabelFont = UIFont.monospacedDigitSystemFont(ofSize: numberLabelFontSize, weight: UIFontWeightUltraLight)
			binaryLabelFont = UIFont.monospacedDigitSystemFont(ofSize: 20, weight: UIFontWeightRegular)
			bitIndicatorFont = UIFont.monospacedDigitSystemFont(ofSize: 12, weight: UIFontWeightRegular)
		} else {
			numberLabelFont = UIFont.systemFont(ofSize: numberLabelFontSize, weight: UIFontWeightUltraLight)
			binaryLabelFont = UIFont.systemFont(ofSize: 20, weight: UIFontWeightUltraLight)
			bitIndicatorFont = UIFont.systemFont(ofSize: binaryTopLabel.font.capHeight, weight: UIFontWeightRegular)
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
	
	func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
		return false
	}
	
	override var canBecomeFirstResponder : Bool {
		return true
	}
	
	override func motionBegan(_ motion: UIEventSubtype, with event: UIEvent?) {
		if motion == .motionShake {
			clearNumber()
		}
	}
	
	func selectButton(selectedButton: UIButton) {
		for button in converterButtons {
			if button == selectedButton {
				button.setBackgroundImage(UIImage(named: "rectangle_black"), for: UIControlState())
				button.setTitleColor(UIColor.white, for: UIControlState())
			} else {
				button.setBackgroundImage(UIImage(named: "rectangle_gray_light"), for: UIControlState())
				button.setTitleColor(UIColor.black, for: UIControlState())
			}
		}
	}
	
	// MARK: - Button State Handlers
	
	func enableEssentialNumberButtons() {
		var buttonsToEnable = [UIButton]()
		
		if displayType != "hex" {
			// Disable all buttons.
			for button in hexButtons {
				button.isEnabled = false
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
			button.isEnabled = true
		}
	}
	
	func addSpaceEveryFourBits(binaryString: String) -> String {
		var formattedString = String()
		
		for (index, character) in binaryString.characters.enumerated() {
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
		numberLabel.isHidden = false
		binaryView.isHidden = true
	}
	
	func showBinaryLabels() {
		numberLabel.isHidden = true
		binaryView.isHidden = false
		binaryUpperView.isHidden = calculatorBrain.cpuRegisterSize == 32 ? true : false
	}
	
	func animateLabel(label: SpringLabel, animation: String, curve: String, duration: CGFloat) {
		label.animation = animation
		label.curve = curve
		label.duration = duration
		label.animate()
	}
	
	// MARK: - IBActions
	
	@IBAction func handleDoubleTap(_ recognizer: UITapGestureRecognizer) {
		if recognizer.state == .ended {
			copyNumber()
		}
	}
	
	@IBAction func handleSwipe(_ recognizer: UISwipeGestureRecognizer) {
		if recognizer.state == .ended {
			clearNumber()
		}
	}
	
	@IBAction func twosComplement() {
		displayValue = calculatorBrain.twosComplement(value: displayValue)
	}
	
	@IBAction func flipBytes() {
		displayValue = calculatorBrain.flipBytes(value: displayValue)
	}
	
	@IBAction func copyNumber() {
		let animation = "flash"
		let curve = "linear"
		let duration: CGFloat = 0.075
		let numberString: String
		
		// Add an animation as feedback that the number was copied.
		if displayType == "bin" {
			animateLabel(label: binaryTopLabel, animation: animation, curve: curve, duration: duration)
			animateLabel(label: binaryBottomLabel, animation: animation, curve: curve, duration: duration)
			
			numberString = calculatorBrain.cpuRegisterSize == 32 ? binaryBottomLabel.text! : binaryTopLabel.text! + " " + binaryBottomLabel.text!
		} else {
			animateLabel(label: numberLabel, animation: animation, curve: curve, duration: duration)
			
			numberString = numberLabel.text!
		}
        
        UIPasteboard.general.string = numberString
	}
	
	@IBAction func clearNumber() {
		if displayValue > 0 {
			let animation = "shake"
			let curve = "spring"
			let duration = CGFloat(0.9)
			
			// Add an animation for when the number label's text changes.
			if displayType == "bin" {
				animateLabel(label: binaryTopLabel, animation: animation, curve: curve, duration: duration)
				animateLabel(label: binaryBottomLabel, animation: animation, curve: curve, duration: duration)
			} else {
				animateLabel(label: numberLabel, animation: animation, curve: curve, duration: duration)
			}
			
			displayValue = 0
            
            promptForAppRatingIfNeeded()
		}
	}
	
	@IBAction func backspace() {
		displayValue /= radixValue[displayType]!
	}
	
	@IBAction func convertNumber(_ sender: UIButton) {
		let currentValue = displayValue
		displayType = sender.currentTitle!
		displayValue = currentValue
		
		selectButton(selectedButton: sender)
		enableEssentialNumberButtons()
		if displayType == "bin" {
			showBinaryLabels()
		} else {
			showNonBinaryLabel()
		}
        
        if displayValue > 0 {
            UserPreferences.hasConverted = true
        }
	}
	
	
    @IBAction func appendDigit(_ sender: UIButton) {
        displayValue = calculatorBrain.appendDigit(value: displayValue, digit: sender.currentTitle!, type: displayType)
    }
	
	var displayValue: UInt {
		get {
			// Remove commas from the number just in case it's a formatted decimal number.
			var number = numberLabel.text!.replacingOccurrences(of: ",", with: "", options: [], range: nil)
			
			if displayType == "bin" {
				// Remove spaces from the number.
				number = binaryTopLabel.text!.replacingOccurrences(of: " ", with: "", options: [], range: nil) + binaryBottomLabel.text!.replacingOccurrences(of: " ", with: "", options: [], range: nil)
			}
			
			return UInt(strtoul(number, nil, Int32(radixValue[displayType]!)))
		}
		
		set {
			switch(displayType) {
			case "hex":
				numberLabel.text = "0x" + String(newValue, radix: 16, uppercase: true)
			case "dec":
				let decimalString = String(newValue, radix: 10)
				var formattedDecimalString = String()
				
				// Formatting the decimal string manually because NSNumberFormatter is displaying two's complement as a negative number.
				let firstCommaIndex = decimalString.characters.count % 3
				for (index, character) in decimalString.characters.enumerated() {
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
					formattedLowerString = addSpaceEveryFourBits(binaryString: binaryString)
				} else {
					// Split the bits in half.
					upperString = binaryString.substring(with: (binaryString.startIndex ..< binaryString.characters.index(binaryString.endIndex, offsetBy: -32)))
					lowerString = binaryString.substring(with: (binaryString.characters.index(binaryString.startIndex, offsetBy: 32) ..< binaryString.endIndex))
					
					formattedLowerString = addSpaceEveryFourBits(binaryString: lowerString)
					formattedUpperString = addSpaceEveryFourBits(binaryString: upperString)
				}
				
				binaryBottomLabel.text = formattedLowerString
				binaryTopLabel.text = formattedUpperString
			default: break
			}
		}
	}
	
    // MARK: - App Rating
    private func promptForAppRatingIfNeeded() {
        guard shouldPromptForAppRating() else { return }
        
        let actionSheet = UIAlertController(title: NSLocalizedString("POLL_EXPERIENCE_TITLE", comment: ""), message: NSLocalizedString("POLL_EXPERIENCE_MESSAGE", comment: ""), preferredStyle: .alert)
        
        let notAwesome = UIAlertAction(title: NSLocalizedString("NOT_AWESOME", comment: ""), style: .default) { (action) -> Void in
            self.askToLeaveFeedback()
        }
        actionSheet.addAction(notAwesome)
        
        let awesome = UIAlertAction(title: NSLocalizedString("AWESOME", comment: ""), style: .default) { (action) -> Void in
            self.askToRateApp()
        }
        actionSheet.addAction(awesome)
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    private func shouldPromptForAppRating() -> Bool {
        let firstAppLaunchDate = UserPreferences.firstAppLaunchDate ?? Date()
        let calendar = NSCalendar.current
        let date1 = calendar.startOfDay(for: firstAppLaunchDate)
        let date2 = calendar.startOfDay(for: NSDate() as Date)
        let daysWithApp = calendar.dateComponents([.day], from: date1, to: date2).day ?? 0
        
        guard !UserPreferences.haveAskedToRateApp else { return false }
        guard UserPreferences.hasConverted else { return false }
        guard UserPreferences.numberOfSessions >= Constants.AppRatingThresholds.sessions else { return false }
        guard daysWithApp >= Constants.AppRatingThresholds.daysWithApp else { return false }
        
        UserPreferences.haveAskedToRateApp = true
        
        return true
    }
    
    private func askToRateApp() {
        let actionSheet = UIAlertController(title: NSLocalizedString("ASK_TO_RATE_APP_TITLE", comment: ""), message: NSLocalizedString("ASK_TO_RATE_APP_MESSAGE", comment: ""), preferredStyle: .alert)
        
        let maybeLater = UIAlertAction(title: NSLocalizedString("MAYBE_LATER", comment: ""), style: .cancel) { (action) -> Void in
            // TODO: Reset time until we ask again.
        }
        actionSheet.addAction(maybeLater)
        
        let ok = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default) { (action) -> Void in
            self.openAppStore()
        }
        actionSheet.addAction(ok)
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    private func askToLeaveFeedback() {
        let actionSheet = UIAlertController(title: NSLocalizedString("ASK_TO_LEAVE_FEEDBACK_TITLE", comment: ""), message: NSLocalizedString("ASK_TO_LEAVE_FEEDBACK_MESSAGE", comment: ""), preferredStyle: .alert)
        
        let maybeLater = UIAlertAction(title: NSLocalizedString("MAYBE_LATER", comment: ""), style: .cancel) { (action) -> Void in
            // TODO: Reset time until we ask again.
        }
        actionSheet.addAction(maybeLater)
        
        let ok = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default) { (action) -> Void in
            self.sendEmail()
        }
        actionSheet.addAction(ok)
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    private func openAppStore() {
        guard let url = URL(string : "itms-apps://itunes.apple.com/app/id1021414602") else { return }
        UIApplication.shared.openURL(url)
    }
    
    private func sendEmail() {
        guard MFMailComposeViewController.canSendMail() else {
            // TODO: Show failure alert.
            return
        }
        
        let mailVC = MFMailComposeViewController()
        mailVC.mailComposeDelegate = self
        mailVC.setToRecipients(["m+convex@mattxdaigle.com"])
        mailVC.setSubject("iOS App Feedback")
        
        present(mailVC, animated: true, completion: nil)
    }
}

// MARK: - MFMailComposeViewControllerDelegate Methods
extension CalculatorViewController: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}

