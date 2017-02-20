//
//  RosterViewController.swift
//  StatTracker-Basketball
//
//  Created by Ray Paragas on 14/12/16.
//  Copyright © 2016 Ray Paragas. All rights reserved.
//

import UIKit
import CoreData
import Firebase

class RosterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var positionTextField: UITextField!
    @IBOutlet weak var rosterTableView: UITableView!
    @IBOutlet weak var updateButton: UIButton!
    
    var selectedPlayer : Player = Player()
    var roster = [Player]()
    var team : Team = Team()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstNameTextField.isHidden = true
        lastNameTextField.isHidden = true
        numberTextField.isHidden = true
        positionTextField.isHidden = true
        updateButton.isHidden = true
        rosterTableView.dataSource = self
        rosterTableView.delegate = self
        getPlayers()
        
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Roster"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return roster.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomRosterTableViewCell", for: indexPath) as! CustomRosterTableViewCell
        let player = roster[indexPath.row]
        cell.setPlayerDetails(player: player)
        return cell
    }    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPlayer = roster[indexPath.row]
        firstNameTextField.isHidden = false
        firstNameTextField.text = selectedPlayer.playerFirstName
        lastNameTextField.isHidden = false
        lastNameTextField.text = selectedPlayer.playerLastName
        numberTextField.isHidden = false
        numberTextField.text = selectedPlayer.playerNumber
        positionTextField.isHidden = false
        positionTextField.text = selectedPlayer.playerPosition
        updateButton.isHidden = false
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            FIRDatabase.database().reference().child("players").child(team.teamID).child(roster[indexPath.row].playerID).removeValue()
            roster.remove(at: indexPath.row)
            rosterTableView.reloadData()
        }
    }

    func getPlayers() {
        FIRDatabase.database().reference().child(FIRAuth.auth()!.currentUser!.uid).child("players").child(team.teamID).observe(FIRDataEventType.childAdded, with: {(snapshot) in
            let player = Player()
            player.playerID = snapshot.key
            player.playerFirstName = (snapshot.value as! NSDictionary)["playerFirstName"] as! String
            player.playerLastName = (snapshot.value as! NSDictionary)["playerLastName"] as! String
            player.playerNumber = (snapshot.value as! NSDictionary)["playerNumber"] as! String
            player.playerPosition = (snapshot.value as! NSDictionary)["playerPosition"] as! String
            player.playerTeam = self.team.teamID
            self.roster.append(player)
            self.rosterTableView.reloadData()
        })
    }
    
    @IBAction func updateTapped(_ sender: Any) {
     let player = ["playerFirstName": firstNameTextField.text, "playerLastName": lastNameTextField.text, "playerNumber": numberTextField.text, "playerPosition": positionTextField.text]
     FIRDatabase.database().reference().child(FIRAuth.auth()!.currentUser!.uid).child("players").child(team.teamID).child(selectedPlayer.playerID).setValue(player)
        rosterTableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextVC = segue.destination as! AddPlayerViewController
        nextVC.selectedTeam = team
    }

    @IBAction func addPlayerTapped(_ sender: Any) {
        performSegue(withIdentifier: "addPlayerSegue", sender: team)
    }
}
