//
//  LaunchScreenCopyViewController.swift
//  GroupRide
//
//  Created by Daniel Rodosky on 10/23/17.
//  Copyright © 2017 Daniel Rodosky. All rights reserved.
//

import UIKit

class LaunchScreenCopyViewController: UIViewController {
    
    // FIXME : custom segues broken

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewController = myStoryboard.instantiateViewController(withIdentifier: "InitialViewController")
        let feedTableViewController = myStoryboard.instantiateViewController(withIdentifier: "FeedTableViewController")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        if checkForCurrentUser() == false {
            appDelegate.window?.rootViewController = initialViewController
        } else {
            appDelegate.window?.rootViewController = feedTableViewController
        }
    }
    
    // MARK: - Private functions
    
    func checkForCurrentUser() -> Bool {
        var isSuccess = false
        let _ = UserController.shared.fetchCurrentUser(completion: { (success) in
            if !success {
                isSuccess = false
                return
            }
            isSuccess = true
            return
        })
        return isSuccess
    }
}
