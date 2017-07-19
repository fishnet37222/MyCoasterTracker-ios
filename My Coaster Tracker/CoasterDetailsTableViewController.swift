//
//  CoasterDetailsTableViewController.swift
//  My Coaster Tracker
//
//  Created by David Frischknecht on 2/19/17.
//  Copyright © 2017 David Frischknecht. All rights reserved.
//

import UIKit
import CoreData

class CoasterDetailsTableViewController: UITableViewController {
    @objc var editButton: UIBarButtonItem?
    @objc let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    @objc var coaster: NSManagedObject?
    @IBOutlet weak var lblNumInversions: UILabel!
    @IBOutlet weak var lblMaxSpeed: UILabel!
    @IBOutlet weak var lblMaxHeight: UILabel!
    @IBOutlet weak var lblMaxDropAngle: UILabel!
    @IBOutlet weak var lblPark: UILabel!
    @IBOutlet weak var lblState: UILabel!
    @IBOutlet weak var lblCountry: UILabel!
    @IBOutlet weak var lblManufacturer: UILabel!
    @IBOutlet weak var lblLayout: UILabel!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var lblPropulsion: UILabel!
    @IBOutlet weak var lblStructure: UILabel!
    @IBOutlet weak var lblTrack: UILabel!
    
    @objc func setCoaster(_ name: String, indexPath: IndexPath) {
        let fetchRequest: NSFetchRequest<Park> = Park.fetchRequest()
        var parks: [NSManagedObject]?
        do {
            try parks = context.fetch(fetchRequest)
        } catch {
        }
        coaster = parks?[indexPath.section].mutableSetValue(forKey: "coasters").allObjects[indexPath.row] as? NSManagedObject
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    @objc func loadData() {
        let park = coaster?.value(forKey: "park") as! NSManagedObject
        let state = park.value(forKey: "state") as! NSManagedObject
        let country = state.value(forKey: "country") as! NSManagedObject
        let manufacturer = coaster?.value(forKey: "manufacturer") as! NSManagedObject
        let layout = coaster?.value(forKey: "layout") as! NSManagedObject
        let coasterType = coaster?.value(forKey: "coasterType") as! NSManagedObject
        let propulsion = coaster?.value(forKey: "propulsion") as! NSManagedObject
        let structure = coaster?.value(forKey: "structureMaterial") as! NSManagedObject
        let track = coaster?.value(forKey: "trackMaterial") as! NSManagedObject
        editButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.edit, target: self, action: #selector(editWasTapped))
        self.navigationItem.rightBarButtonItem = editButton
        lblNumInversions.text = "\(coaster?.value(forKey: "numInversions") as! Int)"
        lblMaxSpeed.text = "\(coaster?.value(forKey: "maxSpeedInMph") as! Int)"
        lblMaxHeight.text = "\(coaster?.value(forKey: "maxHeightInFeet") as! Int)"
        lblMaxDropAngle.text = "\(coaster?.value(forKey: "angleOfSteepestDrop") as! Int)"
        lblPark.text = park.value(forKey: "name") as? String
        lblState.text = state.value(forKey: "name") as? String
        lblCountry.text = country.value(forKey: "name") as? String
        lblManufacturer.text = manufacturer.value(forKey: "name") as? String
        lblLayout.text = layout.value(forKey: "name") as? String
        lblType.text = coasterType.value(forKey: "name") as? String
        lblPropulsion.text = propulsion.value(forKey: "name") as? String
        lblStructure.text = structure.value(forKey: "name") as? String
        lblTrack.text = track.value(forKey: "name") as? String
        self.navigationItem.title = coaster?.value(forKey: "name") as? String
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func editWasTapped() {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "editCoasterNavigationController") as! UINavigationController
        let dest = viewController.topViewController as! EditCoasterTableViewController
        dest.context = context
        dest.coaster = coaster
        self.present(viewController, animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadData()
    }
}
