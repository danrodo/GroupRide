//
//  NewRideEventViewController.swift
//  GroupRide
//
//  Created by Daniel Rodosky on 10/24/17.
//  Copyright © 2017 Daniel Rodosky. All rights reserved.
//

import UIKit

class NewRideEventViewController: UIViewController, UITextViewDelegate {
    
    
    // MARK: - Properties
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var descriptionTextArea: UITextView!
    
    @IBOutlet weak var saveButtonToTextAreaConstraint: NSLayoutConstraint!
    
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
        descriptionTextArea.delegate = self
        
        datePicker.minimumDate = Date()
        descriptionTextArea.layer.cornerRadius = 10
        
        
        // create notification observers for when keyboard is shown and when it is dismissed
        // to adjust constraints
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(keyboardWillShow(_ :)), name: .UIKeyboardWillShow, object: nil)
        nc.addObserver(self, selector: #selector(keyboardWillHide(_ :)), name: .UIKeyboardWillHide, object: nil)
    }
    
    // MARK: - TextView delegate funcs 
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "Enter description here..."
        }
    }

    // MARK: - Handle keyboard interaction
    
    @objc func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
            let animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double,
            let animationCurveRaw = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? Int,
            let animationCurve = UIViewAnimationCurve(rawValue: animationCurveRaw) else { return }
        
        
        self.view.layoutIfNeeded()
        self.saveButtonToTextAreaConstraint.constant = 25.0
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(animationDuration)
        UIView.setAnimationCurve(animationCurve)
        UIView.setAnimationBeginsFromCurrentState(true)
        
        self.view.layoutIfNeeded()
        UIView.commitAnimations()
        
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
            let animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double,
            let animationCurveRaw = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? Int,
            let animationCurve = UIViewAnimationCurve(rawValue: animationCurveRaw) else { return }
        
        
        self.view.layoutIfNeeded()
        self.saveButtonToTextAreaConstraint.constant = 45.0
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(animationDuration)
        UIView.setAnimationCurve(animationCurve)
        UIView.setAnimationBeginsFromCurrentState(true)
        
        self.view.layoutIfNeeded()
        UIView.commitAnimations()
        
        
    }

}
