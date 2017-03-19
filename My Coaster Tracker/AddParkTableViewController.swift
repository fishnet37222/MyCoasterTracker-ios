//
//  AddParkTableViewController.swift
//  My Coaster Tracker
//
//  Created by David Frischknecht on 2/18/17.
//  Copyright © 2017 David Frischknecht. All rights reserved.
//

import UIKit
import CoreData

class AddParkTableViewController: UITableViewController, PickStateProtocol, TextEditorProtocol {
	@IBOutlet weak var lblStateName: UILabel!
	@IBOutlet weak var btnDone: UIBarButtonItem!
	@IBOutlet weak var lblParkName: UILabel!
	var context: NSManagedObjectContext?
	
	func setValue(for textEditorType: TextEditorType, value: String) {
		lblParkName.text = value
		checkDoneStatus()
	}
	
	func setState(_ stateName: String) {
		lblStateName.text = stateName
		checkDoneStatus()
	}
	
	func checkDoneStatus() {
		var done = true
		
		if lblStateName.text == "" || lblParkName.text == "" {
			done = false
		}
		
		btnDone.isEnabled = done
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.endEditing(true)
		btnDone.isEnabled = (textField.text?.characters.count)! > 0
		return true
	}
	
	@IBAction func doneWasTapped(_ sender: UIBarButtonItem) {
		let newPark = NSEntityDescription.insertNewObject(forEntityName: "Park", into: context!)
		newPark.setValue(lblParkName.text, forKey: "name")
		let stateFetchRequest: NSFetchRequest<State> = State.fetchRequest()
		stateFetchRequest.predicate = NSPredicate(format: "%K == %@", argumentArray: ["name", lblStateName.text!])
		let states: [NSManagedObject] = try! context!.fetch(stateFetchRequest)
		newPark.setValue(states[0], forKey: "state")
		try! context?.save()
		self.dismiss(animated: true, completion: nil)
	}
	
	@IBAction func cancelWasTapped(_ sender: UIBarButtonItem) {
		(UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext.rollback()
		self.dismiss(animated: true, completion: nil)
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if indexPath.row == 0 {
			let editor = self.storyboard?.instantiateViewController(withIdentifier: "textEditorView") as! TextEditorTableViewController
			editor.textEditorType = TextEditorType.ParkName
			editor.textEditorProtocol = self
			if let value = lblParkName.text {
				editor.previousValue = value
			}
			self.navigationController?.pushViewController(editor, animated: true)
		}
	}
	
	// MARK: - Navigation
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.destination is PickStateTableViewController {
			let dest = segue.destination as! PickStateTableViewController
			dest.pickStateProtocol = self
			dest.context = self.context
			if lblStateName.text != "" {
				dest.currentStateName = lblStateName.text!
			}
		}
	}
}
