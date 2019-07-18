//
//  AddItemTableViewController.swift
//  My Coaster Tracker
//
//  Created by David Frischknecht on 2/18/17.
//  Copyright © 2017 David Frischknecht. All rights reserved.
//

import UIKit
import CoreData

class AddItemTableViewController: UITableViewController, TextEditorProtocol {
	@IBOutlet weak var lblItemName: UILabel!
	@IBOutlet weak var btnDone: UIBarButtonItem!
	@objc var context: NSManagedObjectContext?
	var pickItemType: PickItemType?
	var parentView: PickItemTableViewController?
	
	func setValue(for textEditorType: TextEditorType, value: String) {
		lblItemName.text = value
		btnDone.isEnabled = value != ""
	}
	
	@IBAction func cancelWasTapped(_ sender: UIBarButtonItem) {
		self.dismiss(animated: true, completion: nil)
	}
	
	@IBAction func doneWasTapped(_ sender: UIBarButtonItem) {
		var newItem: NSManagedObject?
		switch pickItemType! {
		case PickItemType.CoasterType:
			newItem = NSEntityDescription.insertNewObject(forEntityName: "CoasterType", into: context!)
			break
		case PickItemType.Layout:
			newItem = NSEntityDescription.insertNewObject(forEntityName: "Layout", into: context!)
			break
		case PickItemType.Manufacturer:
			newItem = NSEntityDescription.insertNewObject(forEntityName: "Manufacturer", into: context!)
			break
		case PickItemType.Propulsion:
			newItem = NSEntityDescription.insertNewObject(forEntityName: "Propulsion", into: context!)
			break
		case PickItemType.Structure:
			newItem = NSEntityDescription.insertNewObject(forEntityName: "StructureMaterial", into: context!)
			break
		case PickItemType.Track:
			newItem = NSEntityDescription.insertNewObject(forEntityName: "TrackMaterial", into: context!)
			break
		}
		newItem?.setValue(lblItemName.text, forKey: "name")
		try! context?.save()
		parentView?.reloadData()
		self.dismiss(animated: true, completion: nil)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		switch pickItemType! {
		case PickItemType.CoasterType:
			self.navigationItem.title = "Add a Coaster Type"
			break
		case PickItemType.Layout:
			self.navigationItem.title = "Add a Layout"
			break
		case PickItemType.Manufacturer:
			self.navigationItem.title = "Add a Manufacturer"
			break
		case PickItemType.Propulsion:
			self.navigationItem.title = "Add a Propulsion"
			break
		case PickItemType.Structure:
			self.navigationItem.title = "Add a Structure"
			break
		case PickItemType.Track:
			self.navigationItem.title = "Add a Track"
			break
		}
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let editor = self.storyboard?.instantiateViewController(withIdentifier: "textEditorView") as! TextEditorTableViewController
		editor.textEditorProtocol = self
		if let value = lblItemName.text {
			editor.previousValue = value
		}
		switch pickItemType! {
		case PickItemType.CoasterType:
			editor.textEditorType = TextEditorType.CoasterType
			break
		case PickItemType.Layout:
			editor.textEditorType = TextEditorType.Layout
			break
		case PickItemType.Manufacturer:
			editor.textEditorType = TextEditorType.Manufacturer
			break
		case PickItemType.Propulsion:
			editor.textEditorType = TextEditorType.Propulsion
			break
		case PickItemType.Structure:
			editor.textEditorType = TextEditorType.Structure
			break
		case PickItemType.Track:
			editor.textEditorType = TextEditorType.Track
			break
		}
		self.navigationController?.pushViewController(editor, animated: true)
	}
}
