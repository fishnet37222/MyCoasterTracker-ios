//
//  VisitedParksTableViewController.swift
//  My Coaster Tracker
//
//  Created by David Frischknecht on 4/29/17.
//  Copyright © 2017 David Frischknecht. All rights reserved.
//

import UIKit
import CoreData

class VisitedParksTableViewController: UITableViewController {
	let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
	var states: [NSManagedObject]?
	var state: NSManagedObject?

    override func viewDidLoad() {
        super.viewDidLoad()

		let model = UIDevice.current.model
		if (model == "iPhone") {
			self.navigationItem.backBarButtonItem = self.splitViewController?.displayModeButtonItem
		}
		if (model == "iPad") {
			self.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
		}
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
		if (state == nil) {
			let fetchRequest: NSFetchRequest<State> = State.fetchRequest()
			var numStates: Int = 0
			do {
				states = try context.fetch(fetchRequest)
				numStates = (states?.count)!
			} catch {
			}
			if numStates == 0 {
				let lblNoParks = UILabel()
				lblNoParks.text = "You have not checked in rides on any coasters."
				lblNoParks.font = UIFont.italicSystemFont(ofSize: lblNoParks.font.pointSize)
				lblNoParks.textAlignment = NSTextAlignment.center
				lblNoParks.isOpaque = false
				lblNoParks.lineBreakMode = NSLineBreakMode.byWordWrapping
				lblNoParks.numberOfLines = 0
				tableView.backgroundView = lblNoParks
				tableView.separatorStyle = UITableViewCellSeparatorStyle.none
			} else {
				tableView.backgroundView = nil
				tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
			}
			return numStates
		}
		return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if (state == nil) {
			return (states?[section].mutableSetValue(forKey: "parks"))!.count
		}
		return (state?.mutableSetValue(forKey: "parks").count)!
    }
	
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		if state == nil {
			let country = states?[section].value(forKey: "country") as? NSManagedObject
			let countryName = country?.value(forKey: "name") as? String
			let stateName = states?[section].value(forKey: "name") as? String
			return "\(countryName!) - \(stateName!)"
		}
		return nil
	}

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "visitedParkCell")
		let lblName = cell?.contentView.subviews[0] as! UILabel
		var park: NSManagedObject
		if state == nil {
			park = states?[indexPath.section].mutableSetValue(forKey: "parks").allObjects[indexPath.row] as! NSManagedObject
		} else {
			park = state?.mutableSetValue(forKey: "parks").allObjects[indexPath.row] as! NSManagedObject
		}
		lblName.text = park.value(forKey: "name") as? String
		return cell!
    }
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		self.tableView.reloadData()
	}
}
