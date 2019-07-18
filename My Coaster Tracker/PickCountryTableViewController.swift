//
//  PickCountryTableViewController.swift
//  My Coaster Tracker
//
//  Created by David Frischknecht on 2/18/17.
//  Copyright © 2017 David Frischknecht. All rights reserved.
//

import UIKit
import CoreData

protocol PickCountryProtocol {
	func setCountry(_ countryName: String)
}

class PickCountryTableViewController: UITableViewController {
	@objc var countries: [NSManagedObject]?
	@objc var currentCountryName: String = ""
	var pickCountryProtocol: PickCountryProtocol?
	@objc var context: NSManagedObjectContext?
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	// MARK: - Table view data source
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		let fetchRequest: NSFetchRequest<Country> = Country.fetchRequest()
		var numCountries = 0
		do {
			try countries = context?.fetch(fetchRequest)
			numCountries = (countries?.count)!
		} catch {
		}
		if numCountries == 0 {
			let lblNoCountries = UILabel()
			lblNoCountries.text = "You have not added any countries."
			lblNoCountries.font = UIFont.italicSystemFont(ofSize: lblNoCountries.font.pointSize)
			lblNoCountries.textAlignment = NSTextAlignment.center
			lblNoCountries.isOpaque = false
			lblNoCountries.lineBreakMode = NSLineBreakMode.byWordWrapping
			lblNoCountries.numberOfLines = 0
			tableView.backgroundView = lblNoCountries
			tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
		} else {
			tableView.backgroundView = nil
			tableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
		}
		return numCountries
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "pickCountryCell", for: indexPath)
		let label = cell.contentView.subviews[0] as! UILabel
		let labelText = countries?[indexPath.row].value(forKey: "name") as! String
		label.text = labelText
		if labelText == currentCountryName {
			cell.accessoryType = UITableViewCell.AccessoryType.checkmark
		}
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let cell = tableView.cellForRow(at: indexPath)
		cell?.accessoryType = UITableViewCell.AccessoryType.checkmark
		currentCountryName = (cell?.contentView.subviews[0] as! UILabel).text!
		_ = self.navigationController?.popViewController(animated: true)
	}
	
	override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
		tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.none
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		if let delegate = pickCountryProtocol {
			delegate.setCountry(currentCountryName)
		}
	}
	
	public func reloadData() {
		self.tableView.reloadData()
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "addCountrySegue" {
			let dest = ((segue.destination as! UINavigationController).topViewController as! AddCountryTableViewController)
			let childContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType)
			childContext.parent = self.context
			childContext.automaticallyMergesChangesFromParent = true
			dest.context = childContext
            dest.parentView = self
		}
	}
}
