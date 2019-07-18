//
//  PickItemTableViewController.swift
//  My Coaster Tracker
//
//  Created by David Frischknecht on 2/18/17.
//  Copyright © 2017 David Frischknecht. All rights reserved.
//

import UIKit
import CoreData

enum PickItemType {
	case Manufacturer
	case Layout
	case CoasterType
	case Propulsion
	case Structure
	case Track
}

protocol PickItemProtocol {
	func setValue(for pickItemType: PickItemType, value: String)
}

class PickItemTableViewController: UITableViewController {
	var pickItemProtocol: PickItemProtocol?
	var pickItemType: PickItemType?
	@objc var btnAdd: UIBarButtonItem?
	@objc var items: [NSManagedObject]?
	@objc var context: NSManagedObjectContext?
	@objc var currentItemName: String = ""
	
	override func viewDidLoad() {
		super.viewDidLoad()
		btnAdd = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(PickItemTableViewController.addWasTapped))
		self.navigationItem.rightBarButtonItem = btnAdd
		switch pickItemType! {
		case PickItemType.CoasterType:
			self.navigationItem.title = "Select a Type"
			break
		case PickItemType.Layout:
			self.navigationItem.title = "Select a Layout"
			break
		case PickItemType.Manufacturer:
			self.navigationItem.title = "Select a Manufacturer"
			break
		case PickItemType.Propulsion:
			self.navigationItem.title = "Select a Propulsion"
			break
		case PickItemType.Structure:
			self.navigationItem.title = "Select a Structure"
			break
		case PickItemType.Track:
			self.navigationItem.title = "Select a Track"
			break
		}
	}
	
	@objc func addWasTapped() {
		let addDialog = self.storyboard?.instantiateViewController(withIdentifier: "addItemViewController") as! UINavigationController
		let dest = addDialog.topViewController as! AddItemTableViewController
		let childContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType)
		childContext.parent = self.context
		childContext.automaticallyMergesChangesFromParent = true
		dest.context = childContext
		dest.pickItemType = self.pickItemType
		dest.parentView = self
		self.present(addDialog, animated: true, completion: nil)
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	// MARK: - Table view data source
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		var numRows = 0
		switch pickItemType! {
		case PickItemType.CoasterType:
			let fetchRequest: NSFetchRequest<CoasterType> = CoasterType.fetchRequest()
			do {
				try items = context?.fetch(fetchRequest)
				numRows = (items?.count)!
			} catch {
			}
			if numRows == 0 {
				let lblNoItems = UILabel()
				lblNoItems.text = "You have not added any coaster types."
				lblNoItems.font = UIFont.italicSystemFont(ofSize: lblNoItems.font.pointSize)
				lblNoItems.textAlignment = NSTextAlignment.center
				lblNoItems.isOpaque = false
				lblNoItems.lineBreakMode = NSLineBreakMode.byWordWrapping
				lblNoItems.numberOfLines = 0
				tableView.backgroundView = lblNoItems
				tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
			} else {
				tableView.backgroundView = nil
				tableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
			}
			break
		case PickItemType.Layout:
			let fetchRequest: NSFetchRequest<Layout> = Layout.fetchRequest()
			do {
				try items = context?.fetch(fetchRequest)
				numRows = (items?.count)!
			} catch {
			}
			if numRows == 0 {
				let lblNoItems = UILabel()
				lblNoItems.text = "You have not added any layouts."
				lblNoItems.font = UIFont.italicSystemFont(ofSize: lblNoItems.font.pointSize)
				lblNoItems.textAlignment = NSTextAlignment.center
				lblNoItems.isOpaque = false
				lblNoItems.lineBreakMode = NSLineBreakMode.byWordWrapping
				lblNoItems.numberOfLines = 0
				tableView.backgroundView = lblNoItems
				tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
			} else {
				tableView.backgroundView = nil
				tableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
			}
			break
		case PickItemType.Manufacturer:
			let fetchRequest: NSFetchRequest<Manufacturer> = Manufacturer.fetchRequest()
			do {
				try items = context?.fetch(fetchRequest)
				numRows = (items?.count)!
			} catch {
			}
			if numRows == 0 {
				let lblNoItems = UILabel()
				lblNoItems.text = "You have not added any manufacturers."
				lblNoItems.font = UIFont.italicSystemFont(ofSize: lblNoItems.font.pointSize)
				lblNoItems.textAlignment = NSTextAlignment.center
				lblNoItems.isOpaque = false
				lblNoItems.lineBreakMode = NSLineBreakMode.byWordWrapping
				lblNoItems.numberOfLines = 0
				tableView.backgroundView = lblNoItems
				tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
			} else {
				tableView.backgroundView = nil
				tableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
			}
			break
		case PickItemType.Propulsion:
			let fetchRequest: NSFetchRequest<Propulsion> = Propulsion.fetchRequest()
			do {
				try items = context?.fetch(fetchRequest)
				numRows = (items?.count)!
			} catch {
			}
			if numRows == 0 {
				let lblNoItems = UILabel()
				lblNoItems.text = "You have not added any propulsions."
				lblNoItems.font = UIFont.italicSystemFont(ofSize: lblNoItems.font.pointSize)
				lblNoItems.textAlignment = NSTextAlignment.center
				lblNoItems.isOpaque = false
				lblNoItems.lineBreakMode = NSLineBreakMode.byWordWrapping
				lblNoItems.numberOfLines = 0
				tableView.backgroundView = lblNoItems
				tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
			} else {
				tableView.backgroundView = nil
				tableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
			}
			break
		case PickItemType.Structure:
			let fetchRequest: NSFetchRequest<StructureMaterial> = StructureMaterial.fetchRequest()
			do {
				try items = context?.fetch(fetchRequest)
				numRows = (items?.count)!
			} catch {
			}
			if numRows == 0 {
				let lblNoItems = UILabel()
				lblNoItems.text = "You have not added any structures."
				lblNoItems.font = UIFont.italicSystemFont(ofSize: lblNoItems.font.pointSize)
				lblNoItems.textAlignment = NSTextAlignment.center
				lblNoItems.isOpaque = false
				lblNoItems.lineBreakMode = NSLineBreakMode.byWordWrapping
				lblNoItems.numberOfLines = 0
				tableView.backgroundView = lblNoItems
				tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
			} else {
				tableView.backgroundView = nil
				tableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
			}
			break
		case PickItemType.Track:
			let fetchRequest: NSFetchRequest<TrackMaterial> = TrackMaterial.fetchRequest()
			do {
				try items = context?.fetch(fetchRequest)
				numRows = (items?.count)!
			} catch {
			}
			if numRows == 0 {
				let lblNoItems = UILabel()
				lblNoItems.text = "You have not added any tracks."
				lblNoItems.font = UIFont.italicSystemFont(ofSize: lblNoItems.font.pointSize)
				lblNoItems.textAlignment = NSTextAlignment.center
				lblNoItems.isOpaque = false
				lblNoItems.lineBreakMode = NSLineBreakMode.byWordWrapping
				lblNoItems.numberOfLines = 0
				tableView.backgroundView = lblNoItems
				tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
			} else {
				tableView.backgroundView = nil
				tableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
			}
			break
		}
		return numRows
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "pickItemCell", for: indexPath)
		let label = cell.contentView.subviews[0] as! UILabel
		label.text = items?[indexPath.row].value(forKey: "name") as? String
		if label.text == currentItemName {
			cell.accessoryType = UITableViewCell.AccessoryType.checkmark
		}
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let cell = tableView.cellForRow(at: indexPath)
		cell?.accessoryType = UITableViewCell.AccessoryType.checkmark
		currentItemName = (cell?.contentView.subviews[0] as! UILabel).text!
		_ = self.navigationController?.popViewController(animated: true)
	}
	
	override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
		tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.none
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		if let delegate = pickItemProtocol {
			delegate.setValue(for: pickItemType!, value: currentItemName)
		}
	}
	
	public func reloadData() {
		self.tableView.reloadData()
	}
}
