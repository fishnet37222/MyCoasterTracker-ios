//
//  VisitedCountriesTableViewController.swift
//  My Coaster Tracker
//
//  Created by David Frischknecht on 4/30/17.
//  Copyright © 2017 David Frischknecht. All rights reserved.
//

import UIKit
import CoreData

class VisitedCountriesTableViewController: UITableViewController {
    @objc let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    @objc var countries: [NSManagedObject]?

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
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let fetchRequest: NSFetchRequest<Country> = Country.fetchRequest()
        var numCountries: Int = 0
        do {
            countries = try context.fetch(fetchRequest)
            numCountries = (countries?.count)!
        } catch {
        }
        if numCountries == 0 {
            let lblNoCountries = UILabel()
            lblNoCountries.text = "You have not visited any countries."
            lblNoCountries.font = UIFont.italicSystemFont(ofSize: lblNoCountries.font.pointSize)
            lblNoCountries.textAlignment = NSTextAlignment.center
            lblNoCountries.isOpaque = false
            lblNoCountries.lineBreakMode = NSLineBreakMode.byWordWrapping
            lblNoCountries.numberOfLines = 0
            tableView.backgroundView = lblNoCountries
            tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        } else {
            tableView.backgroundView = nil
            tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        }
        return numCountries
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "visitedCountriesCell")
        let lblName = cell?.contentView.subviews[0] as! UILabel
        lblName.text = countries?[indexPath.row].value(forKey: "name") as? String
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "visitedStatesView") as! VisitedStatesTableViewController
        viewController.setCountry((tableView.cellForRow(at: indexPath)?.contentView.subviews[0] as! UILabel).text!, indexPath: indexPath)
        self.navigationController?.pushViewController(viewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
    }
}
