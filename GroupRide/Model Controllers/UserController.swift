//
//  UserController.swift
//  GroupRide
//
//  Created by Daniel Rodosky on 10/23/17.
//  Copyright © 2017 Daniel Rodosky. All rights reserved.
//

import Foundation
import UIKit
import CloudKit

class UserController {
    
    static let shared = UserController()
    
    let cloudKitManager: CloudKitManager = {
        return CloudKitManager()
    }()
    
    var currentUser: User? {
        didSet{
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: UserKeys.currentUserWasSetNotification, object: nil)
            }
        }
    }
    
    // MARK: - Create User with custom properties
    
    func createUser(firstName: String, lastName: String, profilePicture: UIImage, completion: @escaping (_ success: Bool) -> Void) {
        CKContainer.default().fetchUserRecordID { (appleUsersRecordID, error) in
            guard let appleUsersRecordID = appleUsersRecordID else { return }
            
            let appleUserRef = CKReference(recordID: appleUsersRecordID, action: .deleteSelf)
            let user = User(firstName: firstName, lastName: lastName, appleUserRef: appleUserRef, profilePicture: profilePicture)
            
            let userRecord = CKRecord(user: user)
            
            CKContainer.default().publicCloudDatabase.save(userRecord, completionHandler: { (record, error) in
                if let error = error {
                    print(error.localizedDescription)
                }
                guard let record = record, let currentUser = User(cloudKitRecord: record) else {
                    completion(false)
                    return
                }
                self.currentUser = currentUser
                completion(true)
            })
        }
    }
    
    // MARK: - Fetch the current user
    
    func fetchCurrentUser(completion: @escaping (_ success: Bool) -> Void = { _ in }) {
        CKContainer.default().fetchUserRecordID { (appleUserRecordID, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            guard let appleUserRecordID = appleUserRecordID else {
                completion(false)
                return
            }
            
            let appleUserReference = CKReference(recordID: appleUserRecordID, action: .deleteSelf)
            
            let predicate = NSPredicate(format: "appleUserRef == %@", appleUserReference)
            
            self.cloudKitManager.fetchRecordsWithType(UserKeys.recordTypeKey, predicate: predicate, recordFetchedBlock: nil, completion: { (records, error) in
                if let error = error {
                    print(error.localizedDescription)
                }
                guard let currentUserRecord = records?.first else {
                    completion(false)
                    return
                }
                let currentUser = User(cloudKitRecord: currentUserRecord)
                self.currentUser = currentUser
                completion(true)
            })
        }
    }
}




































