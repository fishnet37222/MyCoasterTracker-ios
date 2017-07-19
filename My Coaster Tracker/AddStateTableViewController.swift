//
//  AddStateTableViewController.swift
//  My Coaster Tracker
//
//  Created by David Frischknecht on 2/18/17.
//  Copyright © 2017 David Frischknecht. All rights reserved.
//

import UIKit
import CoreData

class AddStateTableViewController: UITableViewController, PickCountryProtocol, TextEditorProtocol {
    @IBOutlet weak var btnDone: UIBarButtonItem!
    @IBOutlet weak var lblCountryName: UILabel!
    @IBOutlet weak var lblStateName: UILabel!
    @objc var context: NSManagedObjectContext?
    
    func setValue(for textEditorType: TextEditorType, value: String) {
        lblStateName.text = value
        checkDoneStatus()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @objc func setCountry(_ countryName: String) {
        lblCountryName.text = countryName
        checkDoneStatus()
    }
    
    @objc func checkDoneStatus() {
        var done = true
        
        if lblStateName.text == "" || lblCountryName.text == "" {
            done = false
        }
        
        btnDone.isEnabled = done
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func doneWasTapped(_ sender: UIBarButtonItem) {
        let newState = NSEntityDescription.insertNewObject(forEntityName: "State", into: context!)
        newState.setValue(lblStateName.text, forKey: "name")
        let countryFetchRequest: NSFetchRequest<Country> = Country.fetchRequest()
        countryFetchRequest.predicate = NSPredicate(format: "%K == %@", argumentArray: ["name", lblCountryName.text!])
        let countries: [NSManagedObject] = try! context!.fetch(countryFetchRequest)
        newState.setValue(countries[0], forKey: "country")
        try! context?.save()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelWasTapped(_ sender: UIBarButtonItem) {
        (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext.rollback()
        self.dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let editor = self.storyboard?.instantiateViewController(withIdentifier: "textEditorView") as! TextEditorTableViewController
            editor.textEditorType = TextEditorType.StateName
            editor.textEditorProtocol = self
            if let value = lblStateName.text {
                editor.previousValue = value
            }
            self.navigationController?.pushViewController(editor, animated: true)
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is PickCountryTableViewController {
            let dest = segue.destination as! PickCountryTableViewController
            dest.pickCountryProtocol = self
            dest.context = self.context
            if lblCountryName.text != "" {
                dest.currentCountryName = lblCountryName.text!
            }
        }
    }
}
