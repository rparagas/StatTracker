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


    @IBOutlet weak var playerInfoView: CustomView!
    @IBOutlet weak var playerFirstNameLabel: UILabel!
    @IBOutlet weak var playerLastNameLabel: UILabel!
    @IBOutlet weak var playerNumberLabel: UILabel!
    @IBOutlet weak var playerPositionLabel: UILabel!
    @IBOutlet weak var rosterTableView: UITableView!
    @IBOutlet weak var updateButton: UIButton!
    
    var selectedPlayer : Player = Player()
    var selectedPlayerIndex = IndexPath()
    var roster = [Player]()
    var team : Team = Team()
    var previousVC = TeamViewController()
    var deleteCellIndexPath: IndexPath? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rosterTableView.dataSource = self
        rosterTableView.delegate = self
        hidePlayerDetails()
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
        displayPlayerDetails()
        selectedPlayerIndex = indexPath
        updateButton.isHidden = false
    }
    
    func displayPlayerDetails() {
        playerInfoView.isHidden = false
        playerFirstNameLabel.text = selectedPlayer.playerFirstName
        playerLastNameLabel.text = selectedPlayer.playerLastName
        playerNumberLabel.text = "# \(selectedPlayer.playerNumber)"
        playerPositionLabel.text = selectedPlayer.playerPosition
        updateButton.isHidden = false
    }
    
    func hidePlayerDetails() {
        playerInfoView.isHidden = true
        updateButton.isHidden = true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteCellIndexPath = indexPath
            let playerToDelete = "\(roster[indexPath.row].playerFirstName) \(roster[indexPath.row].playerLastName)"
            confirmDelete(player: playerToDelete)
        }
    }
    
    func confirmDelete(player: String) {
        let alertController = UIAlertController(title: "Deleting a Player.", message: "Are you sure you want to delete \(player)?", preferredStyle: UIAlertControllerStyle.actionSheet)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: handleDelete)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: cancelDelete)
        
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        // Support display in iPad
        alertController.popoverPresentationController?.sourceView = self.view
        let rectOfCellInTableView = rosterTableView.rectForRow(at: deleteCellIndexPath!)
        let rectOfCellInSuperview = rosterTableView.convert(rectOfCellInTableView, to: rosterTableView.superview)
        let x = rectOfCellInSuperview.origin.x + (rosterTableView.cellForRow(at: deleteCellIndexPath!)?.contentView.bounds.width)!
        let y = rectOfCellInSuperview.origin.y + ((rosterTableView.cellForRow(at: deleteCellIndexPath!)?.contentView.bounds.height)! / 2.0)
        alertController.popoverPresentationController?.sourceRect = CGRect(x: x, y: y, width: 1.0, height: 1.0)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func handleDelete(alertAction: UIAlertAction!) -> Void {
        if let indexPath = deleteCellIndexPath {
            rosterTableView.beginUpdates()
        FIRDatabase.database().reference().child(FIRAuth.auth()!.currentUser!.uid).child("players").child(team.teamID).child(roster[indexPath.row].playerID).removeValue()
            roster.remove(at: indexPath.row)
            rosterTableView.deleteRows(at: [indexPath], with: .automatic)
            deleteCellIndexPath = nil
            rosterTableView.endUpdates()
            previousVC.selectedRoster = roster
            previousVC.hidePlayerLabels()
            previousVC.updateDisplayedRoster()
        }
    }
    
    func cancelDelete(alertAction: UIAlertAction!) -> Void {
        deleteCellIndexPath = nil
        closeTableViewEditing()
    }
    
    func closeTableViewEditing() {
        rosterTableView.setEditing(false, animated: true)
    }
    

    func getPlayers() {
        previousVC.hidePlayerLabels()
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
            self.previousVC.selectedRoster = self.roster
            self.previousVC.updateDisplayedRoster()
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addPlayerSegue" {
            let nextVC = segue.destination as! AddPlayerViewController
            nextVC.selectedTeam = team
            nextVC.previousVC = self
        } else if segue.identifier == "editPlayerSegue" {
            let nextVC = segue.destination as! AddPlayerViewController
            nextVC.selectedTeam = team
            nextVC.selectedPlayer = selectedPlayer
            nextVC.selectedPlayerIndex = selectedPlayerIndex
            nextVC.editMode = true
            nextVC.previousVC = self
        }
    }

    @IBAction func addPlayerTapped(_ sender: Any) {
        performSegue(withIdentifier: "addPlayerSegue", sender: nil)
    }
    @IBAction func editPlayerTapped(_ sender: Any) {
        performSegue(withIdentifier: "editPlayerSegue", sender: nil)
    }
}
