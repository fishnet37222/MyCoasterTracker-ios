//
//  EditCoasterTableViewController.swift
//  My Coaster Tracker
//
//  Created by David Frischknecht on 2/19/17.
//  Copyright © 2017 David Frischknecht. All rights reserved.
//

import UIKit
import CoreData

class EditCoasterTableViewController: UITableViewController, PickParkProtocol, TextEditorProtocol, PickItemProtocol {
	@IBOutlet weak var doneButton: UIBarButtonItem!
	@IBOutlet weak var coasterNameLabel: UILabel!
	@IBOutlet weak var numInversionsLabel: UILabel!
	@IBOutlet weak var maxSpeedLabel: UILabel!
	@IBOutlet weak var maxHeightLabel: UILabel!
	@IBOutlet weak var maxDropAngleLabel: UILabel!
	@IBOutlet weak var parkNameLabel: UILabel!
	@IBOutlet weak var manufacturerNameLabel: UILabel!
	@IBOutlet weak var layoutNameLabel: UILabel!
	@IBOutlet weak var coasterTypeNameLabel: UILabel!
	@IBOutlet weak var propulsionNameLabel: UILabel!
	@IBOutlet weak var structureMaterialNameLabel: UILabel!
	@IBOutlet weak var trackMaterialNameLabel: UILabel!
	@objc var context: NSManagedObjectContext?
	@objc var coaster: NSManagedObject?
	
	fileprivate var _coasterName: String?
	fileprivate var _numInversions: String?
	fileprivate var _maxSpeed: String?
	fileprivate var _maxHeight: String?
	fileprivate var _maxDropAngle: String?
	fileprivate var _parkName: String?
	fileprivate var _manufacturerName: String?
	fileprivate var _layoutName: String?
	fileprivate var _coasterTypeName: String?
	fileprivate var _propulsionName: String?
	fileprivate var _structureMaterialName: String?
	fileprivate var _trackMaterialName: String?
	
	func setValue(for textEditorType: TextEditorType, value: String) {
		switch textEditorType {
		case TextEditorType.CoasterName:
			coasterNameLabel.text = value
			break
		case TextEditorType.NumInversions:
			numInversionsLabel.text = value
			break
		case TextEditorType.MaxSpeed:
			maxSpeedLabel.text = value
			break
		case TextEditorType.MaxHeight:
			maxHeightLabel.text = value
			break
		case TextEditorType.MaxDropAngle:
			maxDropAngleLabel.text = value
			break
		default:
			break
		}
		checkDoneStatus()
	}
	
	func setValue(for pickItemType: PickItemType, value: String) {
		switch pickItemType {
		case PickItemType.CoasterType:
			coasterTypeNameLabel.text = value
			break
		case PickItemType.Layout:
			layoutNameLabel.text = value
			break
		case PickItemType.Manufacturer:
			manufacturerNameLabel.text = value
			break
		case PickItemType.Propulsion:
			propulsionNameLabel.text = value
			break
		case PickItemType.Structure:
			structureMaterialNameLabel.text = value
			break
		case PickItemType.Track:
			trackMaterialNameLabel.text = value
			break
		}
		checkDoneStatus()
	}
	
	@objc func setPark(_ parkName: String) {
		parkNameLabel.text = parkName
		checkDoneStatus()
	}
	
	@objc func checkDoneStatus() {
		var done = true
		
		if coasterNameLabel.text == _coasterName &&
			numInversionsLabel.text == _numInversions &&
			maxSpeedLabel.text == _maxSpeed &&
			maxHeightLabel.text == _maxHeight &&
			maxDropAngleLabel.text == _maxDropAngle &&
			parkNameLabel.text == _parkName &&
			manufacturerNameLabel.text == _manufacturerName &&
			layoutNameLabel.text == _layoutName &&
			coasterTypeNameLabel.text == _coasterTypeName &&
			propulsionNameLabel.text == _propulsionName &&
			structureMaterialNameLabel.text == _structureMaterialName &&
			trackMaterialNameLabel.text == _trackMaterialName {
			done = false
		}
		
		doneButton.isEnabled = done
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.navigationItem.title = "Edit"
		let park = coaster?.value(forKey: "park") as! NSManagedObject
		let manufacturer = coaster?.value(forKey: "manufacturer") as! NSManagedObject
		let layout = coaster?.value(forKey: "layout") as! NSManagedObject
		let coasterType = coaster?.value(forKey: "coasterType") as! NSManagedObject
		let propulsion = coaster?.value(forKey: "propulsion") as! NSManagedObject
		let structure = coaster?.value(forKey: "structureMaterial") as! NSManagedObject
		let track = coaster?.value(forKey: "trackMaterial") as! NSManagedObject
		_coasterName = coaster?.value(forKey: "name") as? String
		_numInversions = "\(coaster?.value(forKey: "numInversions") as! Int)"
		_maxSpeed = "\(coaster?.value(forKey: "maxSpeedInMph") as! Int)"
		_maxHeight = "\(coaster?.value(forKey: "maxHeightInFeet") as! Int)"
		_maxDropAngle = "\(coaster?.value(forKey: "angleOfSteepestDrop") as! Int)"
		_parkName = park.value(forKey: "name") as? String
		_manufacturerName = manufacturer.value(forKey: "name") as? String
		_layoutName = layout.value(forKey: "name") as? String
		_coasterTypeName = coasterType.value(forKey: "name") as? String
		_propulsionName = propulsion.value(forKey: "name") as? String
		_structureMaterialName = structure.value(forKey: "name") as? String
		_trackMaterialName = track.value(forKey: "name") as? String
		coasterNameLabel.text = _coasterName
		numInversionsLabel.text = _numInversions
		maxSpeedLabel.text = _maxSpeed
		maxHeightLabel.text = _maxHeight
		maxDropAngleLabel.text = _maxDropAngle
		parkNameLabel.text = _parkName
		manufacturerNameLabel.text = _manufacturerName
		layoutNameLabel.text = _layoutName
		coasterTypeNameLabel.text = _coasterTypeName
		propulsionNameLabel.text = _propulsionName
		structureMaterialNameLabel.text = _structureMaterialName
		trackMaterialNameLabel.text = _trackMaterialName
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		switch indexPath.row {
		case 0:
			let editor = self.storyboard?.instantiateViewController(withIdentifier: "textEditorView") as! TextEditorTableViewController
			editor.textEditorProtocol = self
			editor.textEditorType = TextEditorType.CoasterName
			if let value = coasterNameLabel.text {
				editor.previousValue = value
			}
			self.navigationController?.pushViewController(editor, animated: true)
			break
		case 1:
			let editor = self.storyboard?.instantiateViewController(withIdentifier: "textEditorView") as! TextEditorTableViewController
			editor.textEditorProtocol = self
			editor.textEditorType = TextEditorType.NumInversions
			if let value = numInversionsLabel.text {
				editor.previousValue = value
			}
			self.navigationController?.pushViewController(editor, animated: true)
			break
		case 2:
			let editor = self.storyboard?.instantiateViewController(withIdentifier: "textEditorView") as! TextEditorTableViewController
			editor.textEditorProtocol = self
			editor.textEditorType = TextEditorType.MaxSpeed
			if let value = maxSpeedLabel.text {
				editor.previousValue = value
			}
			self.navigationController?.pushViewController(editor, animated: true)
			break
		case 3:
			let editor = self.storyboard?.instantiateViewController(withIdentifier: "textEditorView") as! TextEditorTableViewController
			editor.textEditorProtocol = self
			editor.textEditorType = TextEditorType.MaxHeight
			if let value = maxHeightLabel.text {
				editor.previousValue = value
			}
			self.navigationController?.pushViewController(editor, animated: true)
			break
		case 4:
			let editor = self.storyboard?.instantiateViewController(withIdentifier: "textEditorView") as! TextEditorTableViewController
			editor.textEditorProtocol = self
			editor.textEditorType = TextEditorType.MaxDropAngle
			if let value = maxDropAngleLabel.text {
				editor.previousValue = value
			}
			self.navigationController?.pushViewController(editor, animated: true)
			break
		case 5:
			let picker = self.storyboard?.instantiateViewController(withIdentifier: "selectParkViewController") as! PickParkTableViewController
			picker.pickParkProtocol = self
			picker.context = self.context
			if let value = parkNameLabel.text {
				picker.currentParkName = value
			}
			self.navigationController?.pushViewController(picker, animated: true)
			break
		case 6:
			let picker = self.storyboard?.instantiateViewController(withIdentifier: "pickItemViewController") as! PickItemTableViewController
			picker.pickItemProtocol = self
			picker.pickItemType = PickItemType.Manufacturer
			picker.context = self.context
			if let value = manufacturerNameLabel.text {
				picker.currentItemName = value
			}
			self.navigationController?.pushViewController(picker, animated: true)
			break
		case 7:
			let picker = self.storyboard?.instantiateViewController(withIdentifier: "pickItemViewController") as! PickItemTableViewController
			picker.pickItemProtocol = self
			picker.pickItemType = PickItemType.Layout
			picker.context = self.context
			if let value = layoutNameLabel.text {
				picker.currentItemName = value
			}
			self.navigationController?.pushViewController(picker, animated: true)
			break
		case 8:
			let picker = self.storyboard?.instantiateViewController(withIdentifier: "pickItemViewController") as! PickItemTableViewController
			picker.pickItemProtocol = self
			picker.pickItemType = PickItemType.CoasterType
			picker.context = self.context
			if let value = coasterTypeNameLabel.text {
				picker.currentItemName = value
			}
			self.navigationController?.pushViewController(picker, animated: true)
			break
		case 9:
			let picker = self.storyboard?.instantiateViewController(withIdentifier: "pickItemViewController") as! PickItemTableViewController
			picker.pickItemProtocol = self
			picker.pickItemType = PickItemType.Propulsion
			picker.context = self.context
			if let value = propulsionNameLabel.text {
				picker.currentItemName = value
			}
			self.navigationController?.pushViewController(picker, animated: true)
			break
		case 10:
			let picker = self.storyboard?.instantiateViewController(withIdentifier: "pickItemViewController") as! PickItemTableViewController
			picker.pickItemProtocol = self
			picker.pickItemType = PickItemType.Structure
			picker.context = self.context
			if let value = structureMaterialNameLabel.text {
				picker.currentItemName = value
			}
			self.navigationController?.pushViewController(picker, animated: true)
			break
		case 11:
			let picker = self.storyboard?.instantiateViewController(withIdentifier: "pickItemViewController") as! PickItemTableViewController
			picker.pickItemProtocol = self
			picker.pickItemType = PickItemType.Track
			picker.context = self.context
			if let value = trackMaterialNameLabel.text {
				picker.currentItemName = value
			}
			self.navigationController?.pushViewController(picker, animated: true)
			break
		default:
			break
		}
	}
	
	/*
	// MARK: - Navigation
	
	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
	// Get the new view controller using segue.destinationViewController.
	// Pass the selected object to the new view controller.
	}
	*/
	
	@IBAction func doneWasTapped(_ sender: UIBarButtonItem) {
		let parkFetchRequest: NSFetchRequest<Park> = Park.fetchRequest()
		parkFetchRequest.predicate = NSPredicate(format: "%K == %@", argumentArray: ["name", parkNameLabel.text!])
		let parks: [NSManagedObject] = try! context!.fetch(parkFetchRequest)
		
		let mfFetchRequest: NSFetchRequest<Manufacturer> = Manufacturer.fetchRequest()
		mfFetchRequest.predicate = NSPredicate(format: "%K == %@", argumentArray: ["name", manufacturerNameLabel.text!])
		let manufacturers: [NSManagedObject] = try! context!.fetch(mfFetchRequest)
		
		let layoutFetchRequest: NSFetchRequest<Layout> = Layout.fetchRequest()
		layoutFetchRequest.predicate = NSPredicate(format: "%K == %@", argumentArray: ["name", layoutNameLabel.text!])
		let layouts: [NSManagedObject] = try! context!.fetch(layoutFetchRequest)
		
		let ctFetchRequest: NSFetchRequest<CoasterType> = CoasterType.fetchRequest()
		ctFetchRequest.predicate = NSPredicate(format: "%K == %@", argumentArray: ["name", coasterTypeNameLabel.text!])
		let coasterTypes: [NSManagedObject] = try! context!.fetch(ctFetchRequest)
		
		let propFetchRequest: NSFetchRequest<Propulsion> = Propulsion.fetchRequest()
		propFetchRequest.predicate = NSPredicate(format: "%K == %@", argumentArray: ["name", propulsionNameLabel.text!])
		let propulsions: [NSManagedObject] = try! context!.fetch(propFetchRequest)
		
		let smFetchRequest: NSFetchRequest<StructureMaterial> = StructureMaterial.fetchRequest()
		smFetchRequest.predicate = NSPredicate(format: "%K == %@", argumentArray: ["name", structureMaterialNameLabel.text!])
		let structureMaterials: [NSManagedObject] = try! context!.fetch(smFetchRequest)
		
		let tmFetchRequest: NSFetchRequest<TrackMaterial> = TrackMaterial.fetchRequest()
		tmFetchRequest.predicate = NSPredicate(format: "%K == %@", argumentArray: ["name", trackMaterialNameLabel.text!])
		let trackMaterials: [NSManagedObject] = try! context!.fetch(tmFetchRequest)
		
		coaster?.setValue(coasterNameLabel.text!, forKey: "name")
		coaster?.setValue(Int(maxDropAngleLabel.text!), forKey: "angleOfSteepestDrop")
		coaster?.setValue(Int(maxHeightLabel.text!), forKey: "maxHeightInFeet")
		coaster?.setValue(Int(maxSpeedLabel.text!), forKey: "maxSpeedInMph")
		coaster?.setValue(Int(numInversionsLabel.text!), forKey: "numInversions")
		coaster?.setValue(parks[0], forKey: "park")
		coaster?.setValue(manufacturers[0], forKey: "manufacturer")
		coaster?.setValue(layouts[0], forKey: "layout")
		coaster?.setValue(coasterTypes[0], forKey: "coasterType")
		coaster?.setValue(propulsions[0], forKey: "propulsion")
		coaster?.setValue(structureMaterials[0], forKey: "structureMaterial")
		coaster?.setValue(trackMaterials[0], forKey: "trackMaterial")
		
		try! context?.save()
		
		self.dismiss(animated: true, completion: nil)
	}
	
	@IBAction func cancelWasTapped(_ sender: UIBarButtonItem) {
		(UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext.rollback()
		self.presentingViewController?.dismiss(animated: true, completion: nil)
	}
}
