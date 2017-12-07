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
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 34
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    let locationLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .left
        return label
    }()
    
    
    func updateViews() {
        
        self.backgroundColor = UIColor(white: 255.0/255.0, alpha: 0.5)
        guard let location = rideEvent?.location, let date = rideEvent?.date, let userRef = rideEvent?.userRef else { return }
        
        let users = RideEventController.shared.userDict
        guard let user = users[userRef.recordID] else { return }
        
        addSubview(profileImageView)
        
        setUpContainerView(user: user, date: date.description, location: location)
        
        profileImageView.image = user.photo
                
        addConstraintsWithFormat(format: "H:|-12-[v0(68)]", views: profileImageView)
        addConstraintsWithFormat(format: "V:|-12-[v0(68)]", views: profileImageView)
        
        addConstraint(NSLayoutConstraint(item: profileImageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        
    }
    
    private func setUpContainerView(user: User, date: String, location: String) {
        
        let containerView = UIView()
//        containerView.backgroundColor = UIColor.red
        addSubview(containerView)
        
        addConstraintsWithFormat(format: "H:|-90-[v0]|", views: containerView)
        addConstraintsWithFormat(format: "V:[v0(50)]", views: containerView)
        
        addConstraint(NSLayoutConstraint(item: containerView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        
        containerView.addSubview(nameLabel)
        containerView.addSubview(dateLabel)
        containerView.addSubview(locationLabel)
        
        DateFormatHelper.shared.formatDate(date: date.description, completion: { (success, date) in
            if !success {
                NSLog("error formating date string")
                return
            }
            DispatchQueue.main.async {
                self.dateLabel.text = date
                self.nameLabel.text = "\(user.firstName) \(user.lastName)"
                self.locationLabel.text = location
            }
        })

        containerView.addConstraintsWithFormat(format: "H:|[v0][v1(110)]-12-|", views: nameLabel, dateLabel)
        containerView.addConstraintsWithFormat(format: "V:|[v0][v1(24)]|", views: nameLabel, locationLabel)
        
        containerView.addConstraintsWithFormat(format: "H:|[v0]-12-|", views: locationLabel)
        
        containerView.addConstraintsWithFormat(format: "V:|[v0(20)]", views: dateLabel)
        
    }
    

}
