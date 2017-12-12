//
//  AddCountryTableViewController.swift
//  My Coaster Tracker
//
//  Created by David Frischknecht on 2/18/17.
//  Copyright © 2017 David Frischknecht. All rights reserved.
//

import UIKit
import CoreData

class AddCountryTableViewController: UITableViewController, TextEditorProtocol {
    @IBOutlet weak var btnDone: UIBarButtonItem!
    @IBOutlet weak var lblCountryName: UILabel!
    @objc var context: NSManagedObjectContext?
    
    func setValue(for textEditorType: TextEditorType, value: String) {
        lblCountryName.text = value
        btnDone.isEnabled = value.count > 0
    }
    
    @IBAction func cancelWasTapped(_ sender: UIBarButtonItem) {
        (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext.rollback()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneWasTapped(_ sender: UIBarButtonItem) {
        let newCountry = NSEntityDescription.insertNewObject(forEntityName: "Country", into: context!)
        newCountry.setValue(lblCountryName.text, forKey: "name")
        try! context?.save()
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let editor = self.storyboard?.instantiateViewController(withIdentifier: "textEditorView") as! TextEditorTableViewController
        editor.textEditorType = TextEditorType.CountryName
        editor.textEditorProtocol = self
        if let value = lblCountryName.text {
            editor.previousValue = value
        }
        self.navigationController?.pushViewController(editor, animated: true)
    }
}
