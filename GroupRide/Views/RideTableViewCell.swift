//
//  RideTableViewCell.swift
//  GroupRide
//
//  Created by Daniel Rodosky on 10/25/17.
//  Copyright © 2017 Daniel Rodosky. All rights reserved.
//

import UIKit

class RideTableViewCell: UITableViewCell {
    
    var rideEvent: RideEvent? {
        didSet{
            self.updateViews()
        }
    }

    @IBOutlet weak var rideOwnerProfilePicture: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    
    func updateViews() {
        guard let location = rideEvent?.location, let date = rideEvent?.date, let userRef = rideEvent?.userRef else { return }
        
        let users = RideEventController.shared.userDict
        guard let user = users[userRef.recordID] else { return }
        
        nameLabel.text = "\(user.firstName) \(user.lastName)"
        rideOwnerProfilePicture.image = user.photo
        locationLabel.text = location
        dateLabel.text = date.description
    }
    

}
