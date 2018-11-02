//
//  RiddenCoastersTableViewController.swift
//  My Coaster Tracker
//
//  Created by David Frischknecht on 2/14/17.
//  Copyright © 2017 David Frischknecht. All rights reserved.
//

import UIKit
import CoreData

class RiddenCoastersTableViewController: UITableViewController {
	@objc let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
	@objc var parks: [NSManagedObject]?
	@objc var park: NSManagedObject?
	
	@objc func setPark(_ name: String, indexPath: IndexPath) {
		let fetchRequest: NSFetchRequest<State> = State.fetchRequest()
		var states: [NSManagedObject]?
		do {
			try states = context.fetch(fetchRequest)
		} catch {
		}
		park = states?[indexPath.section].mutableSetValue(forKey: "parks").allObjects[indexPath.row] as? NSManagedObject
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let model = UIDevice.current.model
		if (model == "iPhone") {
			self.navigationItem.backBarButtonItem = self.splitViewController?.displayModeButtonItem
		}
		if (model == "iPad") {
			self.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
			
			let splitViewController = self.splitViewController!
			if UIApplication.shared.statusBarOrientation == .portrait {
				UIView.animate(withDuration: 0.2, animations: {
					splitViewController.preferredDisplayMode = .primaryHidden
				})
			}
		}
		
		if (park != nil) {
			self.navigationItem.title = park?.value(forKey: "name") as? String
		}
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	// MARK: - Table view data source
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		if (park == nil) {
			let fetchRequest: NSFetchRequest<Park> = Park.fetchRequest()
			var numParks: Int = 0
			do {
				parks = try context.fetch(fetchRequest)
				numParks = (parks?.count)!
			} catch {
			}
			if numParks == 0 {
				let lblNoCoasters = UILabel()
				lblNoCoasters.text = "You have not checked in rides on any coasters."
				lblNoCoasters.font = UIFont.italicSystemFont(ofSize: lblNoCoasters.font.pointSize)
				lblNoCoasters.textAlignment = NSTextAlignment.center
				lblNoCoasters.isOpaque = false
				lblNoCoasters.lineBreakMode = NSLineBreakMode.byWordWrapping
				lblNoCoasters.numberOfLines = 0
				tableView.backgroundView = lblNoCoasters
				tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
			} else {
				tableView.backgroundView = nil
				tableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
			}
			return numParks
		}
		return 1
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if (park == nil) {
			return (parks?[section].mutableSetValue(forKey: "coasters"))!.count
		}
		return (park?.mutableSetValue(forKey: "coasters").count)!
	}
	
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		if park == nil {
			return parks?[section].value(forKey: "name") as? String
		}
		return nil
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "riddenCoasterCell")
		let lblName = cell?.contentView.subviews[0] as! UILabel
		var coaster: NSManagedObject
		if park == nil {
			coaster = parks?[indexPath.section].mutableSetValue(forKey: "coasters").allObjects[indexPath.row] as! NSManagedObject
		} else {
			coaster = park?.mutableSetValue(forKey: "coasters").allObjects[indexPath.row] as! NSManagedObject
		}
		lblName.text = coaster.value(forKey: "name") as? String
		let lblNumRides = cell?.contentView.subviews[1] as! UILabel
		lblNumRides.text = "\(coaster.value(forKey: "numRides") as! Int)"
		return cell!
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let viewController = self.storyboard?.instantiateViewController(withIdentifier: "coasterDetailsView") as! CoasterDetailsTableViewController
		viewController.setCoaster((tableView.cellForRow(at: indexPath)?.contentView.subviews[0] as! UILabel).text!, indexPath: indexPath)
		let backButton = UIBarButtonItem()
		backButton.title = self.navigationItem.title!
		self.navigationItem.backBarButtonItem = backButton
		self.navigationController?.pushViewController(viewController, animated: true)
		tableView.deselectRow(at: indexPath, animated: false)
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		self.tableView.reloadData()
	}
}
