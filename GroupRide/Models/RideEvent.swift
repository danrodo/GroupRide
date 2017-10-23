//
//  RideEvent.swift
//  GroupRide
//
//  Created by Daniel Rodosky on 10/22/17.
//  Copyright © 2017 Daniel Rodosky. All rights reserved.
//

import Foundation
import UIKit
import CloudKit

struct RideEvent {
    var location: String
    var date: Date
    var description: String
    
    var cloudKitRecordID: CKRecordID? 
    
    init(location: String, date: Date, description: String) {
        self.location = location
        self.date = date
        self.description = description
    }
}
