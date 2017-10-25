//
//  CloudKitManager.swift
//  GroupRide
//
//  Created by Daniel Rodosky on 10/23/17.
//  Copyright © 2017 Daniel Rodosky. All rights reserved.
//

import Foundation
import CloudKit

class CloudKitManager {
    
    let publicDatabase = CKContainer.default().publicCloudDatabase
    
    func fetchRecord(withID recordID: CKRecordID, completion: ((_ record: CKRecord?, _ error: Error?) -> Void)?) {
        publicDatabase.fetch(withRecordID: recordID) { (record, error) in
            completion?(record, error)
        }
    }
    
    func fetchRecordsWithType(_ type: String,
                              predicate: NSPredicate = NSPredicate(value: true),
                              recordFetchedBlock: ((_ record: CKRecord) -> Void)?,
                              completion: ((_ records: [CKRecord]?, _ error: Error?) -> Void)?) {
        
        var fetchedRecords: [CKRecord] = []
        
        let query = CKQuery(recordType: type, predicate: predicate)
        let queryOperation = CKQueryOperation(query: query)
        
        let perRecordBlock = { (fetchedRecord: CKRecord) -> Void in
            fetchedRecords.append(fetchedRecord)
            recordFetchedBlock?(fetchedRecord)
        }
        queryOperation.recordFetchedBlock = perRecordBlock
        
        var queryCompletionBlock: (CKQueryCursor?, Error?) -> Void = { (_, _) in }
        
        queryCompletionBlock = { (queryCurser: CKQueryCursor?, error: Error?) -> Void in
            if let queryCurser = queryCurser {
                let continueQueryOperation = CKQueryOperation(cursor: queryCurser)
                continueQueryOperation.recordFetchedBlock = perRecordBlock
                continueQueryOperation.queryCompletionBlock = queryCompletionBlock
                
                self.publicDatabase.add(continueQueryOperation)
            } else {
                completion?(fetchedRecords, error)
            }
        }
        queryOperation.queryCompletionBlock = queryCompletionBlock
        
        self.publicDatabase.add(queryOperation)
    }
    
    func save(_ record: CKRecord, completion: @escaping ((Error?) -> Void) = { _ in }) {
        
        publicDatabase.save(record) { (record, error) in
            completion(error)
        }
    }
    
    func fetchRideOwners() {
        
        var recordIDs: [CKRecordID] = []
        guard let rideList = RideEventController.shared.rideList else { return }
        _ = rideList.flatMap({ recordIDs.append($0.userRef.recordID) })
        
        let fetchOperation = CKFetchRecordsOperation(recordIDs: recordIDs)
        fetchOperation.fetchRecordsCompletionBlock = { (recordsByRecordID, error) in
            // doesnt happen
            guard let records = recordsByRecordID else { return }
            for record in records {
                guard let user = User(cloudKitRecord: record.value)
                    else { return }
                RideEventController.shared.userDict[record.key] = user
                print("hi")
            }
//            _ = recordsByRecordID?.flatMap({ RideEventController.shared.userDict?[$0.key] = User(cloudKitRecord: $0.value) })
        }
        publicDatabase.add(fetchOperation)
    }
}

































