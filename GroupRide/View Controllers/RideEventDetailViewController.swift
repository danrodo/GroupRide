//
//  RideEventDetailViewController.swift
//  GroupRide
//
//  Created by Daniel Rodosky on 10/25/17.
//  Copyright © 2017 Daniel Rodosky. All rights reserved.
//

import UIKit

class RideEventDetailViewController: UIViewController {
    
    var rideEvent: RideEvent?
    var user: User?
    
    // MARK: - Properties
    
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        updateViews()
    }
    
    // MARK: - Actions
    
    @IBAction func joinRideButtonTapped(_ sender: Any) {
        
        guard let rideEvent = rideEvent else { return }
//        UserController.shared.joinRideEvent(rideEvent: rideEvent)
        
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - initial view setup
    
    func updateViews() {
        
        guard let rideEvent = rideEvent, let user = user else { return }
        
        profilePictureImageView.image = user.photo
        firstNameLabel.text = user.firstName
        lastNameLabel.text = user.lastName
        locationLabel.text = rideEvent.location
        dateLabel.text = rideEvent.date.description
        descriptionLabel.text = rideEvent.description
        
    }

}
