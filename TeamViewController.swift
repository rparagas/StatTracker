//
//  TeamViewController.swift
//  StatTracker-Basketball
//
//  Created by Ray Paragas on 14/12/16.
//  Copyright © 2016 Ray Paragas. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import FirebaseDatabase

class TeamViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var teamNameLabel: UILabel!
    @IBOutlet weak var playerOneLabel: UILabel!
    @IBOutlet weak var playerTwoLabel: UILabel!
    @IBOutlet weak var playerThreeLabel: UILabel!
    @IBOutlet weak var playerFourLabel: UILabel!
    @IBOutlet weak var playerFiveLabel: UILabel!
    @IBOutlet weak var playerSixLabel: UILabel!
    @IBOutlet weak var playerSevenLabel: UILabel!
    @IBOutlet weak var playerEightLabel: UILabel!
    @IBOutlet weak var playerNineLabel: UILabel!
    @IBOutlet weak var playerTenLabel: UILabel!
    @IBOutlet weak var teamsTableView: UITableView!
    @IBOutlet weak var editRosterButton: UIButton!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    var selectedRoster = [Player]()
    var selectedTeam : Team? = nil
    var teams = [Team]()
    var editMode = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        teamsTableView.dataSource = self
        teamsTableView.delegate = self
        
        teamNameLabel.isHidden = true
        playerOneLabel.isHidden = true
        playerTwoLabel.isHidden = true
        playerThreeLabel.isHidden = true
        playerFourLabel.isHidden = true
        playerFiveLabel.isHidden = true
        playerSixLabel.isHidden = true
        playerSevenLabel.isHidden = true
        playerEightLabel.isHidden = true
        playerNineLabel.isHidden = true
        playerTenLabel.isHidden = true
        editRosterButton.isHidden = true
        getTeams()
    }
    
    
    func updateDisplayedRoster() {
        teamNameLabel.isHidden = false
        teamNameLabel.text = selectedTeam?.teamName
        let labelArray = [playerOneLabel, playerTwoLabel, playerThreeLabel, playerFourLabel, playerFiveLabel, playerSixLabel, playerSevenLabel, playerEightLabel, playerNineLabel, playerTenLabel]
        var count : Int = 0
        for player in selectedRoster {
            labelArray[count]?.isHidden = false
            labelArray[count]?.text = "#\(player.playerNumber). \(player.playerFirstName) \(player.playerLastName)"
            count = count + 1
        }
        editRosterButton.isHidden = false
    }
 
    func getTeams() {
        FIRDatabase.database().reference().child("teams").observe(FIRDataEventType.childAdded, with: {(snapshot) in
            let team = Team()
            team.teamID = snapshot.key
            team.teamName = (snapshot.value as! NSDictionary)["teamName"] as! String
            self.teams.append(team)
            self.teamsTableView.reloadData()
        })
    }
    
    
    // update view as the data comes in
    func getPlayers() {
        if selectedRoster.isEmpty != true {
            selectedRoster.removeAll()
        }
        FIRDatabase.database().reference().child("players").child(selectedTeam!.teamID).observe(FIRDataEventType.childAdded, with: {(snapshot) in
            let player = Player()
            player.playerID = snapshot.key
            player.playerFirstName = (snapshot.value as! NSDictionary)["playerFirstName"] as! String
            player.playerLastName = (snapshot.value as! NSDictionary)["playerLastName"] as! String
            player.playerNumber = (snapshot.value as! NSDictionary)["playerNumber"] as! String
            player.playerPosition = (snapshot.value as! NSDictionary)["playerPosition"] as! String
            player.playerTeam = self.selectedTeam!.teamID
            self.selectedRoster.append(player)
            self.updateDisplayedRoster()
        })
    }
    
    // tableView delegate functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teams.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let team = teams[indexPath.row]
        cell.textLabel?.text = team.teamName
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedTeam = teams[indexPath.row]
        getPlayers()
        updateDisplayedRoster()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editRosterSegue" {
            let nextVC = segue.destination as! RosterViewController
            nextVC.team = selectedTeam!
        }
    }
    
    // work on later, if editmode is on then perform segue
    @IBAction func editAddTapped(_ sender: Any) {
        performSegue(withIdentifier: "addTeamSegue", sender: nil)
    }

    
    @IBAction func editRosterTapped(_ sender: Any) {
        performSegue(withIdentifier: "editRosterSegue", sender: selectedTeam)
    }

}
