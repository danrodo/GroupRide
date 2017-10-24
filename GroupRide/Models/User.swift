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
    var firstName: String
    var lastName: String
    var photoData: Data?
    
    var cloudKitRecordID: CKRecordID?
    var appleUserReference: CKReference
    
    var photo: UIImage? {
        guard let photoData = self.photoData else { return nil }
        return UIImage(data: photoData)
    }
    
    init(firstName: String, lastName: String, appleUserRef: CKReference, photoData: Data?) {
        self.firstName = firstName
        self.lastName = lastName
        self.photoData = photoData
        self.appleUserReference = appleUserRef
    }
}

// MARK: - CloudKit init section

extension User {
    
    init?(cloudKitRecord: CKRecord) {
        
        guard let firstName = cloudKitRecord[UserKeys.firstNameKey] as? String,
            let lastName = cloudKitRecord[UserKeys.lastNameKey] as? String,
            let photoData = cloudKitRecord[UserKeys.photoDataKey] as? Data?,
            let appleUserRef = cloudKitRecord[UserKeys.appleUserRefKey] as? CKReference else { return nil }
        
        self.firstName = firstName
        self.lastName = lastName
        self.photoData = photoData
        self.appleUserReference = appleUserRef
    }
}

//MARK: - create a CKRecord from a User

extension CKRecord {
    
    convenience init(user: User) {
        
        let recordID = user.cloudKitRecordID ?? CKRecordID(recordName: UUID().uuidString)
        self.init(recordType: UserKeys.recordTypeKey, recordID: recordID)
        
        self.setValue(user.firstName, forKey: UserKeys.firstNameKey)
        self.setValue(user.lastName, forKey: UserKeys.lastNameKey)
        self.setValue(user.photoData, forKey: UserKeys.photoDataKey)
        self.setValue(user.appleUserReference, forKey: UserKeys.appleUserRefKey)
    }
}



































