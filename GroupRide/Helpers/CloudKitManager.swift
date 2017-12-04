//
//  CloudKitManager.swift
//  GroupRide
//
//  Created by Daniel Rodosky on 10/23/17.
//  Copyright © 2017 Daniel Rodosky. All rights reserved.
//

import UIKit
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
    
    func fetchRideOwners(completion: @escaping ((Error?) -> Void) = { _ in }) {
        
        var recordIDs: [CKRecordID] = []
        guard let rideList = RideEventController.shared.rideList else { return }
        _ = rideList.flatMap({ recordIDs.append($0.userRef.recordID) })
        
        let fetchOperation = CKFetchRecordsOperation(recordIDs: recordIDs)
        fetchOperation.fetchRecordsCompletionBlock = { (recordsByRecordID, error) in
            guard let records = recordsByRecordID else { return }
            for record in records {
                guard let user = User(cloudKitRecord: record.value)
                    else { return }
                RideEventController.shared.userDict[record.key] = user
            }
        }
        publicDatabase.add(fetchOperation)
    }
    
    /// Takes is a single user and uses CKModyRecords Operation to save the CKRecord
    func modifyRecords(_ records: [CKRecord], perRecordCompletion: ((_ record: CKRecord?, _ error: Error?) -> Void)?, completion: ((_ records: [CKRecord]?, _ error: Error?) -> Void)?) {
        
        let operation = CKModifyRecordsOperation(recordsToSave: records, recordIDsToDelete: nil)
        operation.savePolicy = .changedKeys
        operation.queuePriority = .high
        operation.qualityOfService = .userInteractive
        
        operation.perRecordCompletionBlock = perRecordCompletion
        
        operation.modifyRecordsCompletionBlock = { (records, recordIDs, error) -> Void in
            (completion?(records, error))!
        }
        
        publicDatabase.add(operation)
    }
    
    // MARK: - CloudKit Permissions
    
    func checkCloudKitAvailability(completion: @escaping (_ success: Bool) -> Void = { _ in }) {
        
        CKContainer.default().accountStatus() {
            (accountStatus:CKAccountStatus, error:Error?) -> Void in
            
            switch accountStatus {
            case .available:
                print("CloudKit available. Initializing full sync.")
                completion(true)
                return
            default:
                self.handleCloudKitUnavailable(accountStatus, error: error)
                completion(false)
            }
        }
    }
    
    
    func handleCloudKitUnavailable(_ accountStatus: CKAccountStatus, error:Error?) {
        
        var errorText = "Synchronization is disabled\n"
        if let error = error {
            print("handleCloudKitUnavailable ERROR: \(error)")
            print("An error occured: \(error.localizedDescription)")
            errorText += error.localizedDescription
        }
        
        switch accountStatus {
        case .restricted:
            errorText += "iCloud is not available due to restrictions"
        case .noAccount:
            errorText += "There is no CloudKit account setup.\nYou can setup iCloud in the Settings app."
        default:
            break
        }
        
        displayCloudKitNotAvailableError(errorText)
    }
    
    func displayCloudKitNotAvailableError(_ errorText: String) {
        
        DispatchQueue.main.async(execute: {
            
            let alertController = UIAlertController(title: "iCloud Synchronization Error", message: errorText, preferredStyle: .alert)
            
            let dismissAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil);
            
            alertController.addAction(dismissAction)
            
            if let appDelegate = UIApplication.shared.delegate,
                let appWindow = appDelegate.window!,
                let rootViewController = appWindow.rootViewController {
                rootViewController.present(alertController, animated: true, completion: nil)
            }
        })
    }
    
}

































