//
//  PickCoasterTableViewController.swift
//  My Coaster Tracker
//
//  Created by David Frischknecht on 2/18/17.
//  Copyright © 2017 David Frischknecht. All rights reserved.
//

import UIKit
import CoreData

protocol PickCoasterProtocol {
    func setCoaster(_ coasterName: String)
}

class PickCoasterTableViewController: UITableViewController {
    @objc var parks: [NSManagedObject]?
    var pickCoasterProtocol: PickCoasterProtocol?
    @objc var currentCoasterName: String = ""
    @objc var context: NSManagedObjectContext?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        let fetchRequest: NSFetchRequest<Park> = Park.fetchRequest()
        var numParks = 0
        do {
            try parks = context?.fetch(fetchRequest)
            numParks = (parks?.count)!
        } catch {
        }
        if numParks == 0 {
            let lblNoCoasters = UILabel()
            lblNoCoasters.text = "You have not added any coasters."
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

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (parks?[section].mutableSetValue(forKey: "coasters").count)!
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pickCoasterCell", for: indexPath)
        let label = cell.contentView.subviews[0] as! UILabel
        let labelText = (parks?[indexPath.section].mutableSetValue(forKey: "coasters").allObjects[indexPath.row] as AnyObject).value(forKey: "name") as! String
        label.text = labelText
        if labelText == currentCoasterName {
            cell.accessoryType = UITableViewCell.AccessoryType.checkmark
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return parks?[section].value(forKey: "name") as? String
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)!
        cell.accessoryType = UITableViewCell.AccessoryType.checkmark
        currentCoasterName = (cell.contentView.subviews[0] as! UILabel).text!
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.none
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let delegate = pickCoasterProtocol {
            delegate.setCoaster(currentCoasterName)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addCoasterSegue" {
            let dest = ((segue.destination as! UINavigationController).topViewController as! AddCoasterTableViewController)
            let childContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType)
            childContext.parent = self.context
            childContext.automaticallyMergesChangesFromParent = true
            dest.context = childContext
        }
    }
}
