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
    @IBOutlet weak var addUpdateButton: CustomButton!
    
    var preFill = false
    var editMode = false
    var selectedPlayerIndex = IndexPath()
    
    var selectedTeam = Team()
    var selectedPlayer = Player()
    var previousVC = RosterViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if editMode == true {
            playerFirstNameLabel.text = selectedPlayer.playerFirstName
            playerLastNameLabel.text = selectedPlayer.playerLastName
            playerPositionLabel.text = selectedPlayer.playerPosition
            playerNumberLabel.text = selectedPlayer.playerNumber
            addUpdateButton.setTitle("Update", for: .normal)
        }
        // Do any additional setup after loading the view.
    }

    @IBAction func saveTapped(_ sender: Any) {
        let uuid = NSUUID().uuidString
        let player = ["playerFirstName": playerFirstNameLabel.text,
                      "playerLastName": playerLastNameLabel.text,
                      "playerNumber": playerNumberLabel.text,
                      "playerPosition": playerPositionLabel.text]
        
        if editMode == true {
            let updatedPlayer = Player()
            updatedPlayer.playerID = selectedPlayer.playerID
            updatedPlayer.playerFirstName = playerFirstNameLabel.text!
            updatedPlayer.playerLastName = playerLastNameLabel.text!
            updatedPlayer.playerPosition = playerPositionLabel.text!
            updatedPlayer.playerNumber = playerNumberLabel.text!
            FIRDatabase.database().reference().child(FIRAuth.auth()!.currentUser!.uid).child("players").child(selectedTeam.teamID).child(selectedPlayer.playerID).setValue(player)
            previousVC.hidePlayerDetails()
            previousVC.roster[selectedPlayerIndex.row] = updatedPlayer
        } else {
            FIRDatabase.database().reference().child(FIRAuth.auth()!.currentUser!.uid).child("players").child(selectedTeam.teamID).child(uuid).setValue(player)
        }
        previousVC.rosterTableView.reloadData()
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func cancelTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
