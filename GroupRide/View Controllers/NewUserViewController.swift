//
//  NewUserViewController.swift
//  GroupRide
//
//  Created by Daniel Rodosky on 10/23/17.
//  Copyright © 2017 Daniel Rodosky. All rights reserved.
//

import UIKit

class NewUserViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - Properties
    let picker = UIImagePickerController()
    
    var profilePicture = UIImage()
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var selectPhotoButton: UIButton!
    
    @IBOutlet weak var saveButtonTopSpaceCOnstraint: NSLayoutConstraint!
    
    // MARK: - View Controller life cycle functions

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // textField setup
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        
        // ImagePicker settup
        picker.delegate = self
        
        // create notification observers for when keyboard is shown and when it is dismissed
        // to adjust constraints
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(keyboardWillShow(_ :)), name: .UIKeyboardWillShow, object: nil)
        nc.addObserver(self, selector: #selector(keyboardWillHide(_ :)), name: .UIKeyboardWillHide, object: nil)
        
    }
    
    // MARK: - Actions
    
    @IBAction func selectPhotoButtonTapped(_ sender: Any) {
        
        presentPicker()
        
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        guard let firstName = firstNameTextField.text, let lastName = lastNameTextField.text else {
            self.presentSimpleAlert(title: "Unable to save your info", message: "Please check that you filled everything in correctly")
            return
        }
        
        if firstName == "" || lastName == "" || firstName == "Enter first name here..." || lastName == "Enter last name here..." {
            self.presentSimpleAlert(title: "Unable to save your info", message: "Please check that you filled everything in correctly")
            return
        }
        
        if profilePictureImageView.image != #imageLiteral(resourceName: "bike_icon") {
            profilePicture = profilePictureImageView.image!
        } else {
            profilePicture = #imageLiteral(resourceName: "bike_icon")
        }
        
        
        let photoData = UIImagePNGRepresentation(profilePicture)
        
        let myStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let feedTableViewController = myStoryboard.instantiateViewController(withIdentifier: "FeedTableViewController")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let _ = UserController.shared.createUser(firstName: firstName, lastName: lastName, photoData: photoData) { (success) in
            DispatchQueue.main.async {
                if !success {
                    self.presentSimpleAlert(title: "Unable to save your info", message: "There was an issue connecting to GroupRide's data store, try again when you have service")
                }
                appDelegate.window?.rootViewController = feedTableViewController
                
            }
        }
    }
    
    // MARK: - image picker private settup
    
    func presentPicker() {
        
        let pickerAlert = UIAlertController(title: "Image selection options.", message: "Choose a photo from your library or take one now", preferredStyle: .alert)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (camera) in
            self.picker.allowsEditing = false
            self.picker.sourceType = .camera
            self.picker.cameraCaptureMode = .photo
        }
        
        let photoLibraryAction = UIAlertAction(title: "Library.", style: .default) { (photoLibrary) in
            self.picker.allowsEditing = false
            self.picker.sourceType = .photoLibrary
            self.present(self.picker, animated: true, completion: nil)
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            pickerAlert.addAction(cameraAction)
        }
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            pickerAlert.addAction(photoLibraryAction)
        }
        present(pickerAlert, animated: true, completion: nil)
    }
    
    // MARK: - image picker Delegate functions
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        profilePicture = chosenImage
        profilePictureImageView.image = chosenImage
        DispatchQueue.main.async {
            self.profilePictureImageView.alpha = 1.0
            self.selectPhotoButton.setTitle("", for: .normal)
        }
        dismiss(animated: true, completion: nil)
    }
    
    @objc func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - UITextField delegate functions
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }
    
    // MARK: - Error handeling views
    
    func presentSimpleAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(dismissAction)
        self.present(alert, animated: true, completion: nil)
        self.firstNameTextField.text = "Enter first name here..."
        self.lastNameTextField.text = "Enter last name here..."
    }
    
    // MARK: - Handle keyboard interaction
    
    // FIXME: - implement
    
    @objc func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
            let animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double,
            let animationCurveRaw = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? Int,
            let animationCurve = UIViewAnimationCurve(rawValue: animationCurveRaw) else { return }
        
       
        self.view.layoutIfNeeded()
        self.saveButtonTopSpaceCOnstraint.constant = 40.0
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
        self.saveButtonTopSpaceCOnstraint.constant = 90.0
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(animationDuration)
        UIView.setAnimationCurve(animationCurve)
        UIView.setAnimationBeginsFromCurrentState(true)
        
        self.view.layoutIfNeeded()
        UIView.commitAnimations()
        

    }

}

























