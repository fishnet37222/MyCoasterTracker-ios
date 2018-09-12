//
//  PickStateTableViewController.swift
//  My Coaster Tracker
//
//  Created by David Frischknecht on 2/18/17.
//  Copyright © 2017 David Frischknecht. All rights reserved.
//

import UIKit
import CoreData

protocol PickStateProtocol {
    func setState(_ stateName: String)
}

class PickStateTableViewController: UITableViewController {
    @objc var countries: [NSManagedObject]?
    var pickStateProtocol: PickStateProtocol?
    @objc var currentStateName: String = ""
    @objc var context: NSManagedObjectContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        let fetchRequest: NSFetchRequest<Country> = Country.fetchRequest()
        var numCountries = 0
        do {
            try countries = context?.fetch(fetchRequest)
            numCountries = (countries?.count)!
        } catch {
        }
        if numCountries == 0 {
            let lblNoStates = UILabel()
            lblNoStates.text = "You have not added any states."
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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let country = countries?[section]
        let states = country?.mutableSetValue(forKey: "states")
        let numStates = states?.count
        return numStates!
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pickStateCell", for: indexPath)
        let label = cell.contentView.subviews[0] as! UILabel
        let country = countries?[indexPath.section]
        let labelText = (country?.mutableSetValue(forKey: "states").allObjects[indexPath.row] as AnyObject).value(forKey: "name") as! String
        label.text = labelText
        if labelText == currentStateName {
            cell.accessoryType = UITableViewCell.AccessoryType.checkmark
        } else {
            cell.accessoryType = UITableViewCell.AccessoryType.none
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)!
        cell.accessoryType = UITableViewCell.AccessoryType.checkmark
        currentStateName = (cell.contentView.subviews[0] as! UILabel).text!
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.none
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return countries?[section].value(forKey: "name") as? String
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let delegate = pickStateProtocol {
            delegate.setState(currentStateName)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addStateSegue" {
            let dest = ((segue.destination as! UINavigationController).topViewController as! AddStateTableViewController)
            let childContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType)
            childContext.parent = self.context
            childContext.automaticallyMergesChangesFromParent = true
            dest.context = childContext
        }
    }
}
