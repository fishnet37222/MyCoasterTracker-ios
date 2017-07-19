//
//  AddCoasterTableViewController.swift
//  My Coaster Tracker
//
//  Created by David Frischknecht on 2/18/17.
//  Copyright © 2017 David Frischknecht. All rights reserved.
//

import UIKit
import CoreData

class AddCoasterTableViewController: UITableViewController, PickParkProtocol, TextEditorProtocol, PickItemProtocol {
	@IBOutlet weak var lblCoasterName: UILabel!
	@IBOutlet weak var lblNumInversions: UILabel!
	@IBOutlet weak var lblMaxSpeed: UILabel!
	@IBOutlet weak var lblMaxHeight: UILabel!
	@IBOutlet weak var lblMaxDropAngle: UILabel!
	@IBOutlet weak var lblParkName: UILabel!
	@IBOutlet weak var lblManufacturerName: UILabel!
	@IBOutlet weak var lblLayoutName: UILabel!
	@IBOutlet weak var lblCoasterType: UILabel!
	@IBOutlet weak var lblPropulsion: UILabel!
	@IBOutlet weak var lblStructureMaterial: UILabel!
	@IBOutlet weak var lblTrackMaterial: UILabel!
	@IBOutlet weak var btnDone: UIBarButtonItem!
	@objc var context: NSManagedObjectContext?
	
	func setValue(for textEditorType: TextEditorType, value: String) {
		switch textEditorType {
		case TextEditorType.CoasterName:
			lblCoasterName.text = value
			break
		case TextEditorType.NumInversions:
			lblNumInversions.text = value
			break
		case TextEditorType.MaxSpeed:
			lblMaxSpeed.text = value
			break
		case TextEditorType.MaxHeight:
			lblMaxHeight.text = value
			break
		case TextEditorType.MaxDropAngle:
			lblMaxDropAngle.text = value
			break
		default:
			break
		}
		checkDoneStatus()
	}
	
	func setValue(for pickItemType: PickItemType, value: String) {
		switch pickItemType {
		case PickItemType.CoasterType:
			lblCoasterType.text = value
			break
		case PickItemType.Layout:
			lblLayoutName.text = value
			break
		case PickItemType.Manufacturer:
			lblManufacturerName.text = value
			break
		case PickItemType.Propulsion:
			lblPropulsion.text = value
			break
		case PickItemType.Structure:
			lblStructureMaterial.text = value
			break
		case PickItemType.Track:
			lblTrackMaterial.text = value
			break
		}
		checkDoneStatus()
	}
	
	@objc func setPark(_ parkName: String) {
		lblParkName.text = parkName
		checkDoneStatus()
	}
	
	@objc func checkDoneStatus() {
		var done = true
		
		if lblCoasterName.text == "" || lblNumInversions.text == "" || lblMaxSpeed.text == "" || lblMaxHeight.text == "" || lblMaxDropAngle.text == "" || lblParkName.text == "" || lblManufacturerName.text == "" || lblLayoutName.text == "" || lblCoasterType.text == "" || lblPropulsion.text == "" || lblStructureMaterial.text == "" || lblTrackMaterial.text == "" {
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
	
	@IBAction func cancelWasTapped(_ sender: UIBarButtonItem) {
		self.presentingViewController?.dismiss(animated: true, completion: nil)
	}
	
	@IBAction func doneWasTapped(_ sender: UIBarButtonItem) {
		let parkFetchRequest: NSFetchRequest<Park> = Park.fetchRequest()
		parkFetchRequest.predicate = NSPredicate(format: "%K == %@", argumentArray: ["name", lblParkName.text!])
		let parks: [NSManagedObject] = try! context!.fetch(parkFetchRequest)
		
		let mfFetchRequest: NSFetchRequest<Manufacturer> = Manufacturer.fetchRequest()
		mfFetchRequest.predicate = NSPredicate(format: "%K == %@", argumentArray: ["name", lblManufacturerName.text!])
		let manufacturers: [NSManagedObject] = try! context!.fetch(mfFetchRequest)
		
		let layoutFetchRequest: NSFetchRequest<Layout> = Layout.fetchRequest()
		layoutFetchRequest.predicate = NSPredicate(format: "%K == %@", argumentArray: ["name", lblLayoutName.text!])
		let layouts: [NSManagedObject] = try! context!.fetch(layoutFetchRequest)
		
		let ctFetchRequest: NSFetchRequest<CoasterType> = CoasterType.fetchRequest()
		ctFetchRequest.predicate = NSPredicate(format: "%K == %@", argumentArray: ["name", lblCoasterType.text!])
		let coasterTypes: [NSManagedObject] = try! context!.fetch(ctFetchRequest)
		
		let propFetchRequest: NSFetchRequest<Propulsion> = Propulsion.fetchRequest()
		propFetchRequest.predicate = NSPredicate(format: "%K == %@", argumentArray: ["name", lblPropulsion.text!])
		let propulsions: [NSManagedObject] = try! context!.fetch(propFetchRequest)
		
		let smFetchRequest: NSFetchRequest<StructureMaterial> = StructureMaterial.fetchRequest()
		smFetchRequest.predicate = NSPredicate(format: "%K == %@", argumentArray: ["name", lblStructureMaterial.text!])
		let structureMaterials: [NSManagedObject] = try! context!.fetch(smFetchRequest)
		
		let tmFetchRequest: NSFetchRequest<TrackMaterial> = TrackMaterial.fetchRequest()
		tmFetchRequest.predicate = NSPredicate(format: "%K == %@", argumentArray: ["name", lblTrackMaterial.text!])
		let trackMaterials: [NSManagedObject] = try! context!.fetch(tmFetchRequest)
		
		let newCoaster = NSEntityDescription.insertNewObject(forEntityName: "Coaster", into: context!)
		newCoaster.setValue(lblCoasterName.text!, forKey: "name")
		newCoaster.setValue(Int(lblMaxDropAngle.text!), forKey: "angleOfSteepestDrop")
		newCoaster.setValue(Int(lblMaxHeight.text!), forKey: "maxHeightInFeet")
		newCoaster.setValue(Int(lblMaxSpeed.text!), forKey: "maxSpeedInMph")
		newCoaster.setValue(Int(lblNumInversions.text!), forKey: "numInversions")
		newCoaster.setValue(parks[0], forKey: "park")
		newCoaster.setValue(manufacturers[0], forKey: "manufacturer")
		newCoaster.setValue(layouts[0], forKey: "layout")
		newCoaster.setValue(coasterTypes[0], forKey: "coasterType")
		newCoaster.setValue(propulsions[0], forKey: "propulsion")
		newCoaster.setValue(structureMaterials[0], forKey: "structureMaterial")
		newCoaster.setValue(trackMaterials[0], forKey: "trackMaterial")
		
		try! context?.save()
		
		self.dismiss(animated: true, completion: nil)
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		switch indexPath.row {
		case 0:
			let editor = self.storyboard?.instantiateViewController(withIdentifier: "textEditorView") as! TextEditorTableViewController
			editor.textEditorProtocol = self
			editor.textEditorType = TextEditorType.CoasterName
			if let value = lblCoasterName.text {
				editor.previousValue = value
			}
			self.navigationController?.pushViewController(editor, animated: true)
			break
		case 1:
			let editor = self.storyboard?.instantiateViewController(withIdentifier: "textEditorView") as! TextEditorTableViewController
			editor.textEditorProtocol = self
			editor.textEditorType = TextEditorType.NumInversions
			if let value = lblNumInversions.text {
				editor.previousValue = value
			}
			self.navigationController?.pushViewController(editor, animated: true)
			break
		case 2:
			let editor = self.storyboard?.instantiateViewController(withIdentifier: "textEditorView") as! TextEditorTableViewController
			editor.textEditorProtocol = self
			editor.textEditorType = TextEditorType.MaxSpeed
			if let value = lblMaxSpeed.text {
				editor.previousValue = value
			}
			self.navigationController?.pushViewController(editor, animated: true)
			break
		case 3:
			let editor = self.storyboard?.instantiateViewController(withIdentifier: "textEditorView") as! TextEditorTableViewController
			editor.textEditorProtocol = self
			editor.textEditorType = TextEditorType.MaxHeight
			if let value = lblMaxHeight.text {
				editor.previousValue = value
			}
			self.navigationController?.pushViewController(editor, animated: true)
			break
		case 4:
			let editor = self.storyboard?.instantiateViewController(withIdentifier: "textEditorView") as! TextEditorTableViewController
			editor.textEditorProtocol = self
			editor.textEditorType = TextEditorType.MaxDropAngle
			if let value = lblMaxDropAngle.text {
				editor.previousValue = value
			}
			self.navigationController?.pushViewController(editor, animated: true)
			break
		case 6:
			let picker = self.storyboard?.instantiateViewController(withIdentifier: "pickItemViewController") as! PickItemTableViewController
			picker.pickItemProtocol = self
			picker.pickItemType = PickItemType.Manufacturer
			picker.context = self.context
			if let value = lblManufacturerName.text {
				picker.currentItemName = value
			}
			self.navigationController?.pushViewController(picker, animated: true)
			break
		case 7:
			let picker = self.storyboard?.instantiateViewController(withIdentifier: "pickItemViewController") as! PickItemTableViewController
			picker.pickItemProtocol = self
			picker.pickItemType = PickItemType.Layout
			picker.context = self.context
			if let value = lblLayoutName.text {
				picker.currentItemName = value
			}
			self.navigationController?.pushViewController(picker, animated: true)
			break
		case 8:
			let picker = self.storyboard?.instantiateViewController(withIdentifier: "pickItemViewController") as! PickItemTableViewController
			picker.pickItemProtocol = self
			picker.pickItemType = PickItemType.CoasterType
			picker.context = self.context
			if let value = lblCoasterType.text {
				picker.currentItemName = value
			}
			self.navigationController?.pushViewController(picker, animated: true)
			break
		case 9:
			let picker = self.storyboard?.instantiateViewController(withIdentifier: "pickItemViewController") as! PickItemTableViewController
			picker.pickItemProtocol = self
			picker.pickItemType = PickItemType.Propulsion
			picker.context = self.context
			if let value = lblPropulsion.text {
				picker.currentItemName = value
			}
			self.navigationController?.pushViewController(picker, animated: true)
			break
		case 10:
			let picker = self.storyboard?.instantiateViewController(withIdentifier: "pickItemViewController") as! PickItemTableViewController
			picker.pickItemProtocol = self
			picker.pickItemType = PickItemType.Structure
			picker.context = self.context
			if let value = lblStructureMaterial.text {
				picker.currentItemName = value
			}
			self.navigationController?.pushViewController(picker, animated: true)
			break
		case 11:
			let picker = self.storyboard?.instantiateViewController(withIdentifier: "pickItemViewController") as! PickItemTableViewController
			picker.pickItemProtocol = self
			picker.pickItemType = PickItemType.Track
			picker.context = self.context
			if let value = lblTrackMaterial.text {
				picker.currentItemName = value
			}
			self.navigationController?.pushViewController(picker, animated: true)
			break
		default:
			break
		}
	}
	
	// MARK: - Navigation
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.destination is PickParkTableViewController {
			let dest = segue.destination as! PickParkTableViewController
			dest.pickParkProtocol = self
			dest.context = self.context
			if lblParkName.text != "" {
				dest.currentParkName = lblParkName.text!
			}
		}
	}
}
