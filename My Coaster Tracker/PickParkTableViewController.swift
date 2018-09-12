//
//  PickParkTableViewController.swift
//  My Coaster Tracker
//
//  Created by David Frischknecht on 2/18/17.
//  Copyright © 2017 David Frischknecht. All rights reserved.
//

import UIKit
import CoreData

protocol PickParkProtocol {
    func setPark(_ parkName: String)
}

class PickParkTableViewController: UITableViewController {
    @objc var states: [NSManagedObject]?
    var pickParkProtocol: PickParkProtocol?
    @objc var currentParkName: String = ""
    @objc var context: NSManagedObjectContext?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        let fetchRequest: NSFetchRequest<State> = State.fetchRequest()
        var numStates = 0
        do {
            try states = context?.fetch(fetchRequest)
            numStates = (states?.count)!
        } catch {
        }
        if numStates == 0 {
            let lblNoParks = UILabel()
            lblNoParks.text = "You have not added any parks."
            lblNoParks.font = UIFont.italicSystemFont(ofSize: lblNoParks.font.pointSize)
            lblNoParks.textAlignment = NSTextAlignment.center
            lblNoParks.isOpaque = false
            lblNoParks.lineBreakMode = NSLineBreakMode.byWordWrapping
            lblNoParks.numberOfLines = 0
            tableView.backgroundView = lblNoParks
            tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        } else {
            tableView.backgroundView = nil
            tableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
        }
        return numStates
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let parks = states?[section].mutableSetValue(forKey: "parks")
        return (parks?.count)!
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "selectParkCell", for: indexPath)
        let label = cell.contentView.subviews[0] as! UILabel
        let labelText = (states?[indexPath.section].mutableSetValue(forKey: "parks").allObjects[indexPath.row] as AnyObject).value(forKey: "name") as! String
        label.text = labelText
        if labelText == currentParkName {
            cell.accessoryType = UITableViewCell.AccessoryType.checkmark
        } else {
            cell.accessoryType = UITableViewCell.AccessoryType.none
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)!
        cell.accessoryType = UITableViewCell.AccessoryType.checkmark
        currentParkName = (cell.contentView.subviews[0] as! UILabel).text!
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.none
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return states?[section].value(forKey: "name") as? String
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let delegate = pickParkProtocol {
            delegate.setPark(currentParkName)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addParkSegue" {
            let dest = ((segue.destination as! UINavigationController).topViewController as! AddParkTableViewController)
            let childContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType)
            childContext.parent = self.context
            childContext.automaticallyMergesChangesFromParent = true
            dest.context = childContext
        }
    }
}
