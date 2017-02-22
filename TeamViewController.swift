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
    @IBOutlet weak var teamDetailsLabel: UILabel!
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
    @IBOutlet weak var playerElevenLabel: UILabel!
    @IBOutlet weak var playerTwelveLabel: UILabel!
    
    @IBOutlet weak var teamView: UIView!
    
    @IBOutlet weak var teamsTableView: UITableView!
    @IBOutlet weak var editRosterButton: UIButton!
    @IBOutlet weak var editTeamButton: UIButton!
    @IBOutlet weak var addTeamButton: UIBarButtonItem!
    
    var selectedRoster = [Player]()
    var selectedTeam : Team? = nil
    var teams = [Team]()
    var selectedIndex = IndexPath()
    var teamTextField : UITextField = UITextField()
    var deleteCellIndexPath: IndexPath? = nil
    
    var labelArray = [UILabel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        teamsTableView.dataSource = self
        teamsTableView.delegate = self
        hideButtons()
        labelArray = [playerOneLabel, playerTwoLabel, playerThreeLabel, playerFourLabel, playerFiveLabel, playerSixLabel, playerSevenLabel, playerEightLabel, playerNineLabel, playerTenLabel, playerElevenLabel, playerTwelveLabel]
        hidePlayerLabels()
        hideTeamView()
        getTeams()
        createGestureRecognizer()
    }

    func createGestureRecognizer() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(closeTableViewEditing))
        gestureRecognizer.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(gestureRecognizer)
    }
    
    func closeTableViewEditing() {
        teamsTableView.setEditing(false, animated: true)
    }
    
    func hidePlayerLabels() {
        for index in 0...11 {
            labelArray[index].isHidden = true
        }
    }
    
    func hideTeamView() {
        teamView.isHidden = true
    }
    
    func hideButtons() {
        editTeamButton.isHidden = true
        editRosterButton.isHidden = true
    }
    
    func updateDisplayedRoster() {
        hidePlayerLabels()
        var count = 0
        for player in selectedRoster {
            labelArray[count].isHidden = false
            labelArray[count].text = "#\(player.playerNumber). \(player.playerFirstName) \(player.playerLastName)"
            labelArray[count].sizeToFit()
            count = count + 1
        }
        editTeamButton.isHidden = false
        editRosterButton.isHidden = false
        teamView.isHidden = false
    }
 
    func getTeams() {
        teams.removeAll()
        FIRDatabase.database().reference().child(FIRAuth.auth()!.currentUser!.uid).child("teams").observe(FIRDataEventType.childAdded, with: {(snapshot) in
            let team = Team()
            team.teamID = snapshot.key
            team.teamName = (snapshot.value as! NSDictionary)["teamName"] as! String
            team.teamSeason = (snapshot.value as! NSDictionary)["teamSeason"] as! String
            team.teamType = (snapshot.value as! NSDictionary)["teamType"] as! String
            team.teamDivision = (snapshot.value as! NSDictionary)["teamDivision"] as! String
            team.teamYear = (snapshot.value as! NSDictionary)["teamYear"] as! String
            self.teams.append(team)
            self.teamsTableView.reloadData()
        })
    }
    
    // update view as the data comes in
    func getPlayers() {
        if selectedRoster.isEmpty != true {
            selectedRoster.removeAll()
        }
        FIRDatabase.database().reference().child(FIRAuth.auth()!.currentUser!.uid).child("players").child(selectedTeam!.teamID).observe(FIRDataEventType.childAdded, with: {(snapshot) in
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTeamTableViewCell", for: indexPath) as! CustomTeamTableViewCell
        let team = teams[indexPath.row]
        cell.setTeamName(team: team)
        cell.setTeamDetails(team: team)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Teams"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedTeam = teams[indexPath.row]
        selectedIndex = indexPath
        getPlayers()
        updateDisplayedRoster()
        createTeamNameLabel()
        //getTeamStats() // resolve later
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteCellIndexPath = indexPath
            let teamToDelete = teams[indexPath.row].teamName
            confirmDelete(team: teamToDelete)
            
        }
    }
    
    func confirmDelete(team: String) {
        let alertController = UIAlertController(title: "Deleting a Team.", message: "Are you sure you want to delete \(team)?", preferredStyle: UIAlertControllerStyle.actionSheet)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: handleDelete)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: cancelDelete)
        
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        // Support display in iPad
        alertController.popoverPresentationController?.sourceView = self.view
        let rectOfCellInTableView = teamsTableView.rectForRow(at: deleteCellIndexPath!)
        let rectOfCellInSuperview = teamsTableView.convert(rectOfCellInTableView, to: teamsTableView.superview)
        let x = rectOfCellInSuperview.origin.x + (teamsTableView.cellForRow(at: deleteCellIndexPath!)?.contentView.bounds.width)!
        let y = rectOfCellInSuperview.origin.y + ((teamsTableView.cellForRow(at: deleteCellIndexPath!)?.contentView.bounds.height)! / 2.0)
        alertController.popoverPresentationController?.sourceRect = CGRect(x: x, y: y, width: 1.0, height: 1.0)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func handleDelete(alertAction: UIAlertAction!) -> Void {
        if let indexPath = deleteCellIndexPath {
            teamsTableView.beginUpdates()
            FIRDatabase.database().reference().child(FIRAuth.auth()!.currentUser!.uid).child("teams").child(teams[indexPath.row].teamID).removeValue()
            FIRDatabase.database().reference().child(FIRAuth.auth()!.currentUser!.uid).child("players").child(teams[indexPath.row].teamID).removeValue()
            FIRDatabase.database().reference().child(FIRAuth.auth()!.currentUser!.uid).child("games").child(teams[indexPath.row].teamID).removeValue()
            FIRDatabase.database().reference().child(FIRAuth.auth()!.currentUser!.uid).child("gameResults").child(teams[indexPath.row].teamID).removeValue()
            teams.remove(at: indexPath.row)
            teamsTableView.deleteRows(at: [indexPath], with: .automatic)
            deleteCellIndexPath = nil
            teamsTableView.endUpdates()
        }
    }
    
    func cancelDelete(alertAction: UIAlertAction!) -> Void {
        deleteCellIndexPath = nil
        closeTableViewEditing()
    }
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editRosterSegue" {
            let nextVC = segue.destination as! RosterViewController
            nextVC.team = selectedTeam!
            nextVC.previousVC = self
        } else if segue.identifier == "editTeamSegue" {
            let nextVC = segue.destination as! AddTeamViewController
            nextVC.editMode = true
            nextVC.selectedTeam = selectedTeam!
            nextVC.previousVC = self
        } else if segue.identifier == "addTeamSegue" {
            let nextVC = segue.destination as! AddTeamViewController
            nextVC.editMode = false
        }

    }
    
    @IBAction func addTapped(_ sender: Any) {
        performSegue(withIdentifier: "addTeamSegue", sender: nil)
    }

    @IBAction func editTeamTapped(_ sender: Any) {
        performSegue(withIdentifier: "editTeamSegue", sender: selectedTeam)
    }

    @IBAction func editRosterTapped(_ sender: Any) {
        performSegue(withIdentifier: "editRosterSegue", sender: selectedTeam)
    }

    func createTeamNameLabel() {
        teamNameLabel.text = selectedTeam?.teamName
        teamDetailsLabel.text = "\(selectedTeam!.teamType) | \(selectedTeam!.teamDivision) | \(selectedTeam!.teamSeason) '\(selectedTeam!.teamYear)"
    }
}
