//
//  VisitedStatesTableViewController.swift
//  My Coaster Tracker
//
//  Created by David Frischknecht on 4/30/17.
//  Copyright © 2017 David Frischknecht. All rights reserved.
//

import UIKit
import CoreData

class VisitedStatesTableViewController: UITableViewController {
	@objc let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
	@objc var countries: [NSManagedObject]?
	@objc var country: NSManagedObject?
	
	@objc func setCountry(_ name: String, indexPath: IndexPath) {
		let fetchRequest: NSFetchRequest<Country> = Country.fetchRequest()
		var countries: [NSManagedObject]?
		do {
			try countries = context.fetch(fetchRequest)
		} catch {
		}
		country = countries?[indexPath.section]
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
		
		if (country != nil) {
			self.navigationItem.title = country?.value(forKey: "name") as? String
		}
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	// MARK: - Table view data source
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		if (country == nil) {
			let fetchRequest: NSFetchRequest<Country> = Country.fetchRequest()
			var numCountries: Int = 0
			do {
				countries = try context.fetch(fetchRequest)
				numCountries = (countries?.count)!
			} catch {
			}
			if numCountries == 0 {
				let lblNoStates = UILabel()
				lblNoStates.text = "You have not visited any states."
				lblNoStates.font = UIFont.italicSystemFont(ofSize: lblNoStates.font.pointSize)
				lblNoStates.textAlignment = NSTextAlignment.center
				lblNoStates.isOpaque = false
				lblNoStates.lineBreakMode = NSLineBreakMode.byWordWrapping
				lblNoStates.numberOfLines = 0
				tableView.backgroundView = lblNoStates
				tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
			} else {
				tableView.backgroundView = nil
				tableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
			}
			return numCountries
		}
		return 1
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if (country == nil) {
			return (countries?[section].mutableSetValue(forKey: "states"))!.count
		}
		return (country?.mutableSetValue(forKey: "states"))!.count
	}
	
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		if (country == nil) {
			return countries?[section].value(forKey: "name") as? String
		}
		return nil
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "visitedStatesCell")
		let lblName = cell?.contentView.subviews[0] as! UILabel
		var state: NSManagedObject
		if (country == nil) {
			state = countries?[indexPath.section].mutableSetValue(forKey: "states").allObjects[indexPath.row] as! NSManagedObject
		} else {
			state = country?.mutableSetValue(forKey: "states").allObjects[indexPath.row] as! NSManagedObject
		}
		lblName.text = state.value(forKey: "name") as? String
		return cell!
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let viewController = self.storyboard?.instantiateViewController(withIdentifier: "visitedParksView") as! VisitedParksTableViewController
		viewController.setState((tableView.cellForRow(at: indexPath)?.contentView.subviews[0] as! UILabel).text!, indexPath: indexPath)
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
