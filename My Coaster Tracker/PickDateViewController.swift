//
//  PickDateViewController.swift
//  My Coaster Tracker
//
//  Created by David Frischknecht on 2/18/17.
//  Copyright © 2017 David Frischknecht. All rights reserved.
//

import UIKit

protocol DatePickerProtocol {
	func setDate(date: Date, calendar: Calendar)
}

class PickDateViewController: UIViewController {
	@IBOutlet weak var datePicker: UIDatePicker!
	var datePickerProtocol: DatePickerProtocol?
	@objc var initialDate: Date?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		if let date = initialDate {
			datePicker.setDate(date, animated: false)
		}
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		if let delegate = datePickerProtocol {
			delegate.setDate(date: datePicker.date, calendar: datePicker.calendar)
		}
	}
}
