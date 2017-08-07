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
    @objc let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    @objc var states: [NSManagedObject]?
    @objc var state: NSManagedObject?
    
    @objc func setState(_ name: String, indexPath: IndexPath) {
        let fetchRequest: NSFetchRequest<Country> = Country.fetchRequest()
        var countries: [NSManagedObject]?
        do {
            try countries = context.fetch(fetchRequest)
        } catch {
        }
        state = countries?[indexPath.section].mutableSetValue(forKey: "states").allObjects[indexPath.row] as? NSManagedObject
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
        
        if (state != nil) {
            self.navigationItem.title = state?.value(forKey: "name") as? String
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
                lblNoParks.text = "You have not visited any parks."
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "riddenCoastersView") as! RiddenCoastersTableViewController
        viewController.setPark((tableView.cellForRow(at: indexPath)?.contentView.subviews[0] as! UILabel).text!, indexPath: indexPath)
        self.navigationController?.pushViewController(viewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
    }
}
