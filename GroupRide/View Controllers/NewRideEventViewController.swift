//
//  NewRideEventViewController.swift
//  GroupRide
//
//  Created by Daniel Rodosky on 10/24/17.
//  Copyright © 2017 Daniel Rodosky. All rights reserved.
//

import UIKit

class NewRideEventViewController: UITableViewController, UITextViewDelegate {
    
    var location = ""
    
    // MARK: - Properties
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var descriptionTextArea: UITextView!
    
    @IBOutlet weak var saveButtonToTextAreaConstraint: NSLayoutConstraint!
    
    // MARK: - Actions
    
    @IBAction func postRideButtonTapped(_ sender: Any) {
        
        guard let location = locationTextField.text, let description = descriptionTextArea.text else { return }
        let date = datePicker.date
        let currentDate = Date()
        
        if date > currentDate {
            
            RideEventController.shared.create(location: location, date: date, description: description) { (error) in
                if let error = error {
                    NSLog("error saving ride event to store \(error.localizedDescription)")
                    return
                }
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
                
            }
        } else {
            // Presetn alert here to tell user not to make a event with the current date or sooner
            
        }
    }
    
    // MARK: - Viewcontroller life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        descriptionTextArea.delegate = self
        
        datePicker.minimumDate = Date()
        descriptionTextArea.layer.cornerRadius = 10
        
        locationTextField.text = location
        
        locationTextField.isEnabled = false 
        
        // Set up tap gesture to dismiss keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        tapGesture.cancelsTouchesInView = false
        
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - TextView delegate funcs 
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Enter description here..." {
            textView.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "Enter description here..."
        }
    }


}
