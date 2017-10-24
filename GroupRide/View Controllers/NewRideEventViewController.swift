//
//  NewRideEventViewController.swift
//  GroupRide
//
//  Created by Daniel Rodosky on 10/24/17.
//  Copyright © 2017 Daniel Rodosky. All rights reserved.
//

import UIKit

class NewRideEventViewController: UIViewController {
    
    
    // MARK: - Properties
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var descriptionTextArea: UITextView!
    
    // MARK: - Actions
    
    @IBAction func postRideButtonTapped(_ sender: Any) {
        
        guard let location = locationTextField.text, let description = descriptionTextArea.text else { return }
        let date = datePicker.date
        
        RideEventController.shared.create(location: location, date: date, description: description) { (error) in
            if let error = error {
                NSLog("error saving ride event to store \(error.localizedDescription)")
                return
            }
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    // MARK: - Viewcontroller life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
