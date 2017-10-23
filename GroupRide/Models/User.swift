//
//  User.swift
//  GroupRide
//
//  Created by Daniel Rodosky on 10/22/17.
//  Copyright © 2017 Daniel Rodosky. All rights reserved.
//

import Foundation
import UIKit
import CloudKit

struct User {
    let firstName: String
    let lastName: String
    let profilePicture: UIImage?
    
    var cloudKitRecordID: CKRecordID?
    var appleUserReference: CKReference
    
    init(firstName: String, lastName: String, appleUserRef: CKReference, profilePicture: UIImage) {
        self.firstName = firstName
        self.lastName = lastName
        self.profilePicture = profilePicture
        self.appleUserReference = appleUserRef
    }
}


