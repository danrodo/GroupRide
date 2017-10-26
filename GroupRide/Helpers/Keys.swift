//
//  Keys.swift
//  GroupRide
//
//  Created by Daniel Rodosky on 10/22/17.
//  Copyright © 2017 Daniel Rodosky. All rights reserved.
//

import Foundation


struct UserKeys {
    
    // User keys
    
    static let firstNameKey = "firstName"
    static let lastNameKey = "lastName"
    static let photoDataKey = "photoData"
    static let appleUserRefKey = "appleUserReference"
    static let recordTypeKey = "User"
    static let assetKey = "asset"
    static let attendingRidesKey = "attendingRides" 
    
    // MARK: - Notification
    
    static let currentUserWasSetNotification = Notification.Name("currentUserWasSet")
    
    
}

struct RideEventKeys {
    
    // Ride keys
    
    static let locationKey = "location"
    static let dateKey = "date"
    static let descriptionKey = "description"
    static let recordTypeKey = "RideEvent"
    static let userRefKey = "userRef"
    
    // MARK: - Notification
    
    static let rideEventFeedWasSetNotification = Notification.Name("rideEventFeedWasSet")
    
}
