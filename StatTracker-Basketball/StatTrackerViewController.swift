//
//  StatTrackerViewController.swift
//  StatTracker-Basketball
//
//  Created by Ray Paragas on 5/1/17.
//  Copyright © 2017 Ray Paragas. All rights reserved.
//

import UIKit
import Firebase

class StatTrackerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var selectedTeamTableView: UITableView!
    @IBOutlet weak var opponentTeamTableView: UITableView!
    @IBOutlet weak var timeButton: UIButton!
    @IBOutlet weak var selectedPlayerStatsView: UIView!
    @IBOutlet weak var statsButtonView: UIView!
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var playerPointsLabel: UILabel!
    @IBOutlet weak var playerPercentageLabel: UILabel!
    @IBOutlet weak var playerAssistLabel: UILabel!
    @IBOutlet weak var playerReboundLabel: UILabel!
    @IBOutlet weak var playerStealsLabel: UILabel!
    @IBOutlet weak var playerBlocksLabel: UILabel!
    @IBOutlet weak var playerTurnoverLabel: UILabel!
    
    var selectedGame : Game = Game()
    var selectedTeam : Team = Team()
    var opponentTeam : Team = Team()
    var selectedActiveRoster : [Player] = []
    var selectedInActiveRoster : [Player] = []
    var opponentActiveRoster : [Player] = []
    var opponentInActiveRoster : [Player] = []
    var selectedPlayer : Player = Player()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        selectedTeamTableView.delegate = self
        selectedTeamTableView.dataSource = self
        opponentTeamTableView.delegate = self
        opponentTeamTableView.dataSource = self
        getPlayers()
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberRows = 0
        if tableView == self.selectedTeamTableView {
            numberRows = selectedActiveRoster.count
        }
        if tableView == self.opponentTeamTableView {
            numberRows = opponentActiveRoster.count
        }
        return numberRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let player = selectedActiveRoster[indexPath.row]
        cell.textLabel?.text = "# \(player.playerNumber) \(player.playerFirstName)"
        return cell
    }
    
    func getPlayers() {
        FIRDatabase.database().reference().child("players").child(selectedGame.gameSelectedTeam).observe(FIRDataEventType.childAdded, with: {(snapshot) in
            let player = Player()
            player.playerID = snapshot.key
            player.playerFirstName = (snapshot.value as! NSDictionary)["playerFirstName"] as! String
            player.playerLastName = (snapshot.value as! NSDictionary)["playerLastName"] as! String
            player.playerNumber = (snapshot.value as! NSDictionary)["playerNumber"] as! String
            player.playerPosition = (snapshot.value as! NSDictionary)["playerPosition"] as! String
            player.playerTeam = self.selectedTeam.teamID
            self.selectedActiveRoster.append(player)
            self.selectedTeamTableView.reloadData()
        })
    }
    
    @IBAction func timerTapped(_ sender: Any) {
    }
    @IBAction func nextPeriodTapped(_ sender: Any) {
    }
    @IBAction func madeOneTapped(_ sender: Any) {
    }
    @IBAction func madeTwoTapped(_ sender: Any) {
    }
    @IBAction func madeThreeTapped(_ sender: Any) {
    }
    @IBAction func missOneTapped(_ sender: Any) {
    }
    @IBAction func missTwotapped(_ sender: Any) {
    }
    @IBAction func missThreeTapped(_ sender: Any) {
    }
    @IBAction func offReboundTapped(_ sender: Any) {
    }
    @IBAction func defReboundTapped(_ sender: Any) {
    }
    @IBAction func assistTapped(_ sender: Any) {
    }
    @IBAction func blockTapped(_ sender: Any) {
    }
    @IBAction func stealTapped(_ sender: Any) {
    }
    @IBAction func turnoverTapped(_ sender: Any) {
    }
    @IBAction func foulTapped(_ sender: Any) {
    }
    @IBAction func fixTapped(_ sender: Any) {
    }
    

    
    

}
