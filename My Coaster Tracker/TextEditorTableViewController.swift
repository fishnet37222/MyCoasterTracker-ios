//
//  TextEditorTableViewController.swift
//  My Coaster Tracker
//
//  Created by David Frischknecht on 2/18/17.
//  Copyright © 2017 David Frischknecht. All rights reserved.
//

import UIKit

enum TextEditorType {
    case CoasterName
    case NumInversions
    case MaxSpeed
    case MaxHeight
    case MaxDropAngle
    case ParkName
    case StateName
    case CountryName
    case NumRides
    case Manufacturer
    case Layout
    case Propulsion
    case Structure
    case Track
    case CoasterType
}

protocol TextEditorProtocol {
    func setValue(for textEditorType: TextEditorType, value: String)
}

class TextEditorTableViewController: UITableViewController, UITextFieldDelegate {
    var textEditorType: TextEditorType?
    var keyboardToolbar: UIToolbar?
    var textEditorProtocol: TextEditorProtocol?
    var previousValue: String?
    @IBOutlet weak var txtValue: UITextField!
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        txtValue.delegate = self
        keyboardToolbar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: 44.0))
        var items: [UIBarButtonItem] = []
        items.append(UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil))
        items.append(UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(TextEditorTableViewController.dismissKeyboard)))
        keyboardToolbar?.setItems(items, animated: false)
        if let value = previousValue {
            txtValue.text = value
        }
        txtValue.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillAppear(_ animated: Bool) {
        switch textEditorType! {
        case TextEditorType.CoasterName:
            txtValue.placeholder = "Coaster Name"
            txtValue.autocapitalizationType = UITextAutocapitalizationType.words
            self.navigationItem.title = "Coaster Name"
            break
        case TextEditorType.MaxDropAngle:
            txtValue.placeholder = "Maximum Drop Angle"
            txtValue.keyboardType = UIKeyboardType.numberPad
            txtValue.inputAccessoryView = keyboardToolbar
            self.navigationItem.title = "Maximum Drop Angle"
            break
        case TextEditorType.MaxHeight:
            txtValue.placeholder = "Maximum Height (feet)"
            txtValue.keyboardType = UIKeyboardType.numberPad
            txtValue.inputAccessoryView = keyboardToolbar
            self.navigationItem.title = "Maximum Height (feet)"
            break
        case TextEditorType.MaxSpeed:
            txtValue.placeholder = "Maximum Speed (mph)"
            txtValue.keyboardType = UIKeyboardType.numberPad
            txtValue.inputAccessoryView = keyboardToolbar
            self.navigationItem.title = "Maximum Speed (mph)"
            break
        case TextEditorType.NumInversions:
            txtValue.placeholder = "Number of Inversions"
            txtValue.keyboardType = UIKeyboardType.numberPad
            txtValue.inputAccessoryView = keyboardToolbar
            self.navigationItem.title = "Number of Inversions"
            break
        case TextEditorType.NumRides:
            txtValue.placeholder = "Number of Rides"
            txtValue.keyboardType = UIKeyboardType.numberPad
            txtValue.inputAccessoryView = keyboardToolbar
            self.navigationItem.title = "Number of Rides"
            break
        case TextEditorType.ParkName:
            txtValue.placeholder = "Park Name"
            txtValue.autocapitalizationType = UITextAutocapitalizationType.words
            self.navigationItem.title = "Park Name"
            break
        case TextEditorType.StateName:
            txtValue.placeholder = "State Name"
            txtValue.autocapitalizationType = UITextAutocapitalizationType.words
            self.navigationItem.title = "State Name"
            break
        case TextEditorType.CountryName:
            txtValue.placeholder = "Country Name"
            txtValue.autocapitalizationType = UITextAutocapitalizationType.words
            self.navigationItem.title = "Country Name"
            break
        case TextEditorType.Manufacturer:
            txtValue.placeholder = "Manufacturer"
            txtValue.autocapitalizationType = UITextAutocapitalizationType.words
            self.navigationItem.title = "Manufacturer"
            break
        case TextEditorType.Layout:
            txtValue.placeholder = "Layout"
            txtValue.autocapitalizationType = UITextAutocapitalizationType.words
            self.navigationItem.title = "Layout"
            break
        case TextEditorType.Propulsion:
            txtValue.placeholder = "Propulsion"
            txtValue.autocapitalizationType = UITextAutocapitalizationType.words
            self.navigationItem.title = "Propulsion"
            break
        case TextEditorType.CoasterType:
            txtValue.placeholder = "Coaster Type"
            txtValue.autocapitalizationType = UITextAutocapitalizationType.words
            self.navigationItem.title = "Coaster Type"
            break
        case TextEditorType.Structure:
            txtValue.placeholder = "Structure"
            txtValue.autocapitalizationType = UITextAutocapitalizationType.words
            self.navigationItem.title = "Structure"
            break
        case TextEditorType.Track:
            txtValue.placeholder = "Track"
            txtValue.autocapitalizationType = UITextAutocapitalizationType.words
            self.navigationItem.title = "Track"
            break
        }
        super.viewWillAppear(animated)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let value = txtValue.text?.trimmingCharacters(in: CharacterSet.whitespaces)
        if let delegate = textEditorProtocol {
            delegate.setValue(for: textEditorType!, value: value!)
        }
    }
}
