//
//  FeedTableViewController.swift
//  GroupRide
//
//  Created by Daniel Rodosky on 10/23/17.
//  Copyright © 2017 Daniel Rodosky. All rights reserved.
//

import UIKit

class FeedTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNamelabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var profilePictureImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(ridesWereSet), name: RideEventKeys.rideEventFeedWasSetNotification, object: nil)
        
        firstNameLabel.text = UserController.shared.currentUser?.firstName
        lastNamelabel.text = UserController.shared.currentUser?.lastName
        profilePictureImageView.image = UserController.shared.currentUser?.photo
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        tableView.reloadData()
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let rides = RideEventController.shared.rideList else { return 0 }
        return rides.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "rideCell", for: indexPath) as? RideTableViewCell else { return RideTableViewCell() }

        guard let rides = RideEventController.shared.rideList else { return RideTableViewCell() }
        let ride = rides[indexPath.row]
        
        cell.rideEvent = ride

        return cell
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Retrueve the selected ride and the user that created the ride then send it to the detail VC
        
        if segue.identifier == "rideCellToDetailView" {
            
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            
            guard let rideEvents = RideEventController.shared.rideList else { return }
            let rideEvent = rideEvents[indexPath.row]
            
            guard let user = RideEventController.shared.userDict[rideEvent.userRef.recordID] else { return }
            guard let destinationVC = segue.destination as? RideEventDetailViewController else { return }
            
            destinationVC.rideEvent = rideEvent
            destinationVC.user = user
        }
        
    }
    
    // MARK: - Private helper funcs
    
    @objc func ridesWereSet() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
 

}
