//
//  LaunchScreenCopyViewController.swift
//  GroupRide
//
//  Created by Daniel Rodosky on 10/23/17.
//  Copyright © 2017 Daniel Rodosky. All rights reserved.
//

import UIKit

class LaunchScreenCopyViewController: UIViewController {
    
    let cloudKitManager: CloudKitManager = {
        return CloudKitManager()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewController = myStoryboard.instantiateViewController(withIdentifier: "InitialViewController")
        let feedTableViewController = myStoryboard.instantiateViewController(withIdentifier: "FeedTableViewController")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        checkForCurrentUser { (success) in
            DispatchQueue.main.async {
                if !success {
                    appDelegate.window?.rootViewController = initialViewController
                } else {
                    RideEventController.shared.refreshData()
                    appDelegate.window?.rootViewController = feedTableViewController
                }
            }

        }
    }
    
    // MARK: - Private functions
    
    func checkForCurrentUser(completion: @escaping (Bool) -> Void) {
        
        let _ = UserController.shared.fetchCurrentUser(completion: { (success) in
            completion(success)
        })
    }
}
