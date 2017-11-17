//
//  ViewController.swift
//  FrameCounter
//
//  Created by Neil Stevens on 11/16/17.
//  Copyright © 2017 Neil Stevens. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

	@IBOutlet weak var startField : NSTextField!
	@IBOutlet weak var endField : NSTextField!
	@IBOutlet weak var totalField : NSTextField!

	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view.
	}

	override var representedObject: Any? {
		didSet {
		// Update the view, if already loaded.
		}
	}

	func secondsFromField(field: NSTextField) -> Decimal {
		let txt : String = field.stringValue
		var ary : [String] = txt.components(separatedBy: ":")
		//print("ary: \(ary)")
		//print("end: \(ary.endIndex)")
		let formatter = NumberFormatter()
		formatter.numberStyle = .decimal
		var secs = Decimal(0)
		var depth = 0
		while (ary.endIndex > 0) && (depth < 3) {
			let value = ary.last!
			//print("value: \(value)")
			//print("depth: \(depth)")
			ary.removeLast()
			if value != "" {
				var mult = Decimal(0)
				var exp = Decimal(60)
				NSDecimalPower(UnsafeMutablePointer(&mult),
				               UnsafeMutablePointer(&exp),
				               depth,
				               NSDecimalNumber.RoundingMode.plain)
				secs += mult * formatter.number(from: value)!.decimalValue
			}
			//print("secs: \(secs)")
			depth += 1
		}
		return secs
	}

	@IBAction func updateTimes(sender: NSTextField) {
		//print("Checking start")
		let start = secondsFromField(field: startField)
		//print("Checking end")
		let end = secondsFromField(field: endField)

		let total = end - start
		//print("total: \(total)")

		if(total < Decimal(0)) {
			totalField.stringValue = "0:00:00"
		} else {
			let formatter = NumberFormatter()
			formatter.roundingMode = .floor
			formatter.formatWidth = 2
			formatter.minimumIntegerDigits = 2
			formatter.maximumIntegerDigits = 2

			let secsFormatter = NumberFormatter()
			secsFormatter.roundingMode = .floor
			secsFormatter.formatWidth = 6
			secsFormatter.minimumIntegerDigits = 2
			secsFormatter.maximumIntegerDigits = 2
			secsFormatter.minimumFractionDigits = 3
			secsFormatter.maximumFractionDigits = 3

			var hours = Decimal(0)
			var hoursPart = total / Decimal(3600)
			//print("hoursPart: \(hoursPart)")
			NSDecimalRound(UnsafeMutablePointer(&hours),
			               UnsafeMutablePointer(&hoursPart),
			               0,
			               NSDecimalNumber.RoundingMode.down)
			//print("rounded: \(hours)")
			//let strhours = formatter.string(from: hours as NSDecimalNumber)!
			//print("str: \(strhours)")
			var mins = Decimal(0)
			var minsPart = (total - hours * Decimal(3600)) / Decimal(60)
			//print("minsPart: \(hoursPart)")
			NSDecimalRound(UnsafeMutablePointer(&mins),
			               UnsafeMutablePointer(&minsPart),
			               0,
			               NSDecimalNumber.RoundingMode.down)
			//print("rounded: \(mins)")
			let secs = total - hours * 3600 - mins * 60

			totalField.stringValue = String.localizedStringWithFormat(
			                         "%@:%@:%@",
			                         formatter.string(from: hours as NSDecimalNumber)!,
			                         formatter.string(from: mins as NSDecimalNumber)!,
			                         secsFormatter.string(from: secs as NSDecimalNumber)!)
		}
	}

}
