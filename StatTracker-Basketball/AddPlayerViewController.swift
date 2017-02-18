//
//  AddPlayerViewController.swift
//  StatTracker-Basketball
//
//  Created by Ray Paragas on 20/12/16.
//  Copyright © 2016 Ray Paragas. All rights reserved.
//

import UIKit
import Firebase

class AddPlayerViewController: UIViewController {

    @IBOutlet weak var playerFirstNameLabel: UITextField!
    @IBOutlet weak var playerLastNameLabel: UITextField!
    @IBOutlet weak var playerPositionLabel: UITextField!
    @IBOutlet weak var playerNumberLabel: UITextField!
    
    var selectedTeam = Team()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func saveTapped(_ sender: Any) {
        let uuid = NSUUID().uuidString
        let player = ["playerFirstName": playerFirstNameLabel.text, "playerLastName": playerLastNameLabel.text, "playerNumber": playerNumberLabel.text, "playerPosition": playerPositionLabel.text]
        FIRDatabase.database().reference().child(FIRAuth.auth()!.currentUser!.uid).child("players").child(selectedTeam.teamID).child(uuid).setValue(player)
        navigationController?.popViewController(animated: true)
    }

}
