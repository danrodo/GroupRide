//
//  RideEventController.swift
//  GroupRide
//
//  Created by Daniel Rodosky on 10/24/17.
//  Copyright © 2017 Daniel Rodosky. All rights reserved.
//

import Foundation
import CloudKit

class RideEventController {
    
    static let shared = UserController()
    
    let cloudKitManager: CloudKitManager = {
        return CloudKitManager()
    }()
    
    var rideList: [RideEvent]? {
        didSet{
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: RideEventKeys.rideEventFeedWasSetNotification, object: nil)
            }
        }
    }
    
    init() {
        refreshData()
    }
    
    func create(rideEvent: RideEvent, completion: @escaping ((Error?) -> Void) = { _ in }) {
        
        let record = CKRecord(rideEvent: rideEvent)
        
        cloudKitManager.save(record) { (error) in
            defer { completion(error) }
            
            if let error = error {
                NSLog("Error creating a ride event and saving it to store. \(error.localizedDescription)")
                return
            }
            self.rideList?.insert(rideEvent, at: 0)
        }
    }
    
    func refreshData(completion: @escaping ((Error?) -> Void) = { _ in }) {
        
        cloudKitManager.fetchRecordsWithType(RideEventKeys.recordTypeKey, predicate: NSPredicate(value: true), recordFetchedBlock: nil) { (records, error) in
            defer { completion(error) }
            
            if let error = error {
                NSLog("Error fetching ride events from data store \(error.localizedDescription)")
                return
            }
            guard let records = records else { return }
            self.rideList = records.flatMap({ RideEvent(cloudKitRecord: $0) })
        }
    }
}



































