//
//  CheckInTableViewController.swift
//  My Coaster Tracker
//
//  Created by David Frischknecht on 2/18/17.
//  Copyright © 2017 David Frischknecht. All rights reserved.
//

import UIKit
import CoreData

class CheckInTableViewController: UITableViewController, DatePickerProtocol, TextEditorProtocol, PickCoasterProtocol {
	@IBOutlet weak var btnDone: UIBarButtonItem!
	@IBOutlet weak var lblPickCoaster: UILabel!
	@IBOutlet weak var lblPickDate: UILabel!
	@IBOutlet weak var lblNumRides: UILabel!
	@objc var context: NSManagedObjectContext?
	
	func setValue(for textEditorType: TextEditorType, value: String) {
		lblNumRides.text = value
		checkDoneButtonStatus()
	}
	
	@objc func setCoaster(_ coasterName: String) {
		lblPickCoaster.text = coasterName
		checkDoneButtonStatus()
	}
	
	@objc func setDate(date: Date, calendar: Calendar) {
		var dateString: String
		if calendar.isDateInToday(date) {
			dateString = "Today"
		} else if calendar.isDateInYesterday(date) {
			dateString = "Yesterday"
		} else {
			let formatter = DateFormatter()
			formatter.dateStyle = DateFormatter.Style.long
			formatter.timeStyle = DateFormatter.Style.none
			dateString = formatter.string(from: date)
		}
		lblPickDate.text = dateString
		checkDoneButtonStatus()
	}
	
	@objc func checkDoneButtonStatus() {
		var done = true
		
		if lblPickCoaster.text == "" || lblPickDate.text == "" || lblNumRides.text == "" {
			done = false
		}
		
		btnDone.isEnabled = done
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		context = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType)
		context?.parent = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
		context?.automaticallyMergesChangesFromParent = true
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	@IBAction func cancelWasTapped(_ sender: UIBarButtonItem) {
		self.dismiss(animated: true, completion: nil)
	}
	
	@IBAction func doneWasTapped(_ sender: UIBarButtonItem) {
		let coasterFetchRequest: NSFetchRequest<Coaster> = Coaster.fetchRequest()
		coasterFetchRequest.predicate = NSPredicate(format: "%K == %@", argumentArray: ["name", lblPickCoaster.text!])
		let coasters: [NSManagedObject] = try! context!.fetch(coasterFetchRequest)
		let coaster = coasters[0]
		if let buttonTitle = lblPickDate.text {
			if buttonTitle != "" {
				var date: Date
				switch buttonTitle {
				case "Today":
					date = Date()
				case "Yesterday":
					date = Date().addingTimeInterval(60 * 60 * 24 * -1)
				default:
					let formatter = DateFormatter()
					formatter.dateStyle = DateFormatter.Style.long
					formatter.timeStyle = DateFormatter.Style.none
					date = formatter.date(from: buttonTitle)!
				}
				coaster.setValue(date, forKey: "dateLastRidden")
			}
		}
		var newNumRides = Int(lblNumRides.text!)
		newNumRides = newNumRides! + (coaster.primitiveValue(forKey: "numRides") as! Int)
		coaster.setValue(newNumRides, forKey: "numRides")
		try! context?.save()
		(UIApplication.shared.delegate as! AppDelegate).saveContext()
		self.dismiss(animated: true, completion: nil)
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if indexPath.row == 2 {
			let editor = self.storyboard?.instantiateViewController(withIdentifier: "textEditorView") as! TextEditorTableViewController
			editor.textEditorProtocol = self
			editor.textEditorType = TextEditorType.NumRides
			if let value = lblNumRides.text {
				editor.previousValue = value
			}
			self.navigationController?.pushViewController(editor, animated: true)
		}
	}
	
	// MARK: - Navigation
	
	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.destination is PickDateViewController {
			let dest = segue.destination as! PickDateViewController
			dest.datePickerProtocol = self
			if let buttonTitle = lblPickDate.text {
				if buttonTitle != "" {
					var date: Date
					switch buttonTitle {
					case "Today":
						date = Date()
					case "Yesterday":
						date = Date().addingTimeInterval(60 * 60 * 24 * -1)
					default:
						let formatter = DateFormatter()
						formatter.dateStyle = DateFormatter.Style.long
						formatter.timeStyle = DateFormatter.Style.none
						date = formatter.date(from: buttonTitle)!
					}
					dest.initialDate = date
				}
			}
			return
		}
		
		if segue.identifier == "pickCoasterSegue" {
			let dest = segue.destination as! PickCoasterTableViewController
			dest.context = self.context
			dest.pickCoasterProtocol = self
			if let value = lblPickCoaster.text {
				dest.currentCoasterName = value
			}
		}
	}
}
