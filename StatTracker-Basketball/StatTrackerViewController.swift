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

    /* *******************************************************************************************************************
     // VIEW CONTROLLER - BUTTON OUTLETS
     ******************************************************************************************************************* */
    
    @IBOutlet weak var timeButton: UIButton!
    
    /* *******************************************************************************************************************
     // VIEW CONTROLLER - VIEW OUTLETS
     ******************************************************************************************************************* */
    
    @IBOutlet weak var statsButtonView: UIView!
    @IBOutlet weak var selectedPlayerStatsView: UIView!
    
    /* *******************************************************************************************************************
     // VIEW CONTROLLER - TABLEVIEW OUTLETS
     ******************************************************************************************************************* */

    @IBOutlet weak var selectedTeamBenchTableView: UITableView!
    @IBOutlet weak var selectedTeamTableView: UITableView!
    
    /* *******************************************************************************************************************
     // VIEW CONTROLLER - INDIVIDUAL STATS OUTLET
     ******************************************************************************************************************* */
    
    @IBOutlet weak var playerMinutesLabel: UILabel!
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var playerPointsLabel: UILabel!
    @IBOutlet weak var playerPercentageLabel: UILabel!
    @IBOutlet weak var playerFreeThrowPercentLabe: UILabel!
    @IBOutlet weak var playerAssistLabel: UILabel!
    @IBOutlet weak var playerReboundLabel: UILabel!
    @IBOutlet weak var playerStealsLabel: UILabel!
    @IBOutlet weak var playerBlocksLabel: UILabel!
    @IBOutlet weak var playerTurnoverLabel: UILabel!
    @IBOutlet weak var playerFoulsLabel: UILabel!
    
    /* *******************************************************************************************************************
     // VIEW CONTROLLER - TEAM STATS OUTLET
     ******************************************************************************************************************* */
    
    @IBOutlet weak var selectedTeamNameLabel: UILabel!
    @IBOutlet weak var selectedTeamScoreLabel: UILabel!
    @IBOutlet weak var selectedTeamFieldGoalLabel: UILabel!
    @IBOutlet weak var selectedTeamFreeThrowLabel: UILabel!
    @IBOutlet weak var selectedTeamAssistLabel: UILabel!
    @IBOutlet weak var selectedTeamReboundLabel: UILabel!
    @IBOutlet weak var selectedTeamBlocksLabel: UILabel!
    @IBOutlet weak var selectedTeamStealsLabel: UILabel!
    @IBOutlet weak var selectedTeamTurnoversLabel: UILabel!
    @IBOutlet weak var selectedTeamFoulsLabel: UILabel!
    @IBOutlet weak var opponentTeamNameLabel: UILabel!
    @IBOutlet weak var opponentTeamScoreLabel: UILabel!
    @IBOutlet weak var opponentTeamFieldGoalLabel: UILabel!
    @IBOutlet weak var opponentTeamFreeThrowLabel: UILabel!
    @IBOutlet weak var opponentTeamAssistLabel: UILabel!
    @IBOutlet weak var opponentTeamReboundLabel: UILabel!
    @IBOutlet weak var opponentTeamBlocksLabel: UILabel!
    @IBOutlet weak var opponentTeamStealsLabel: UILabel!
    @IBOutlet weak var opponentTeamTurnoversLabel: UILabel!
    @IBOutlet weak var opponentTeamFoulsLabel: UILabel!
    
    /* *******************************************************************************************************************
     // VIEW CONTROLLER - GLOBAL VARIABLES
     ******************************************************************************************************************* */
    
    var selectedGame : Game = Game()
    
    var selectedTeam : Team = Team()
    
    var selectedActiveRoster : [Player] = []
    var selectedInActiveRoster : [Player] = []
    var selectedRosterStats : [Stats] = []
    
    var opponent : Stats = Stats()
    var opponentButtonSelected = false
    
    var selectedPlayer : Player = Player()
    var selectedPlayerIndexPath : IndexPath = IndexPath()
    
    /* *******************************************************************************************************************
     // VIEW CONTROLLER - BOILER PLATE
     ******************************************************************************************************************* */
    
    override func viewDidLoad() {
        super.viewDidLoad()

        selectedTeamTableView.delegate = self
        selectedTeamTableView.dataSource = self
        selectedTeamBenchTableView.delegate = self
        selectedTeamBenchTableView.dataSource = self
        getPlayers()
        statsButtonView.isHidden = true
        selectedPlayerStatsView.isHidden = true
        selectedTeamBenchTableView.allowsSelection = false
        selectedTeamNameLabel.text = "\(selectedTeam.teamName)"
        opponentTeamNameLabel.text = "\(selectedGame.gameOppTeam)"
        // Do any additional setup after loading the view.
    }
    
    /* *******************************************************************************************************************
     // VIEW CONTROLLER - TABLEVIEW FUNCTIONS
    ******************************************************************************************************************* */
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var sectionName = ""
        if tableView == self.selectedTeamTableView {
            sectionName = "On Court"
        }
        if tableView == self.selectedTeamBenchTableView {
            sectionName = "Bench"
        }
        return sectionName
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberRows = 0
        if tableView == self.selectedTeamTableView {
            numberRows = selectedActiveRoster.count
        } else {
            numberRows = selectedInActiveRoster.count
        }
        return numberRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var player = Player()
        if tableView == self.selectedTeamTableView {
            player = selectedActiveRoster[indexPath.row]
        } else {
            player = selectedInActiveRoster[indexPath.row]
        }
        cell.textLabel?.text = "# \(player.playerNumber) \(player.playerFirstName)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.selectedTeamTableView {
            selectedPlayer = selectedActiveRoster[indexPath.row]
            statsButtonView.isHidden = false
            selectedPlayerStatsView.isHidden = false
            for stat in selectedRosterStats{
                displayIndividualStats(stat: stat)
            }
            selectedPlayerIndexPath = indexPath
            selectedTeamBenchTableView.allowsSelection = true
        }
        if tableView == self.selectedTeamBenchTableView {
            let temp = selectedActiveRoster[selectedPlayerIndexPath.row]
            selectedActiveRoster.remove(at: selectedPlayerIndexPath.row)
            selectedActiveRoster.append(selectedInActiveRoster[indexPath.row])
            selectedInActiveRoster.remove(at: indexPath.row)
            selectedInActiveRoster.append(temp)
            selectedPlayer = Player()
            selectedPlayerIndexPath = IndexPath()
            statsButtonView.isHidden = true
            selectedPlayerStatsView.isHidden = true
            selectedTeamTableView.reloadData()
            selectedTeamBenchTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        selectedPlayer = Player()
    }
    
    /* *******************************************************************************************************************
     // FIREBASE - RETRIEVE QUERY FUNCTIONS
     ******************************************************************************************************************* */
    
    func getPlayers() {
        var starters = 0
        FIRDatabase.database().reference().child("players").child(selectedGame.gameSelectedTeam).observe(FIRDataEventType.childAdded, with: {(snapshot) in
            let player = Player()
            let playerStats = Stats()
            player.playerID = snapshot.key
            playerStats.playerID = snapshot.key
            player.playerFirstName = (snapshot.value as! NSDictionary)["playerFirstName"] as! String
            player.playerLastName = (snapshot.value as! NSDictionary)["playerLastName"] as! String
            player.playerNumber = (snapshot.value as! NSDictionary)["playerNumber"] as! String
            player.playerPosition = (snapshot.value as! NSDictionary)["playerPosition"] as! String
            player.playerTeam = self.selectedTeam.teamID
            if starters < 5 {
                self.selectedActiveRoster.append(player)
            } else {
                self.selectedInActiveRoster.append(player)
            }
            self.selectedRosterStats.append(playerStats)
            self.selectedTeamTableView.reloadData()
            self.selectedTeamBenchTableView.reloadData()
            starters = starters + 1
        })
    }
    
    /* *******************************************************************************************************************
     // VIEW CONTROLLER - CALCULATE STATISTICS FUNCTIONS
    ******************************************************************************************************************* */
    
    func calSelectedTeamScore() -> (Int) {
        var score = 0
        for player in selectedRosterStats {
            score = score + player.madeOnePoints
            score = score + player.madeTwoPoints * 2
            score = score + player.madeThreePoints * 3
        }
        return score
    }
    
    func calSelectedTeamFieldGoal() -> (Double) {
        var made = 0.0
        var total = 0.0
        for player in selectedRosterStats {
            made = made + Double(player.madeTwoPoints) + Double(player.madeThreePoints)
            total = total + Double(player.madeTwoPoints) + Double(player.madeThreePoints) + Double(player.missedTwoPoints) + Double(player.missedThreePoints)
        }
        let fieldGoal : Double = Double(made) / Double(total)
        return Double(round(fieldGoal * 1000)/1000) * 100
    }
    
    func calSelectedTeamFreeThrow() -> (Double) {
        var made = 0.0
        var total = 0.0
        for player in selectedRosterStats {
            made = made + Double(player.madeOnePoints)
            total = total + Double(player.madeOnePoints) + Double(player.missedOnePoints)
        }
        let freeThrow : Double = Double(made) / Double(total)
        return Double(round(freeThrow * 1000)/1000) * 100
    }
    
    func calSelectedTeamAssists() -> (Int) {
        var assists = 0
        for player in selectedRosterStats {
            assists = assists + player.assists
        }
        return assists
    }
    
    func calSelectedTeamRebounds() -> (Int) {
        var rebounds = 0
        for player in selectedRosterStats{
            rebounds = rebounds + player.defRebounds + player.offRebounds
        }
        return rebounds
    }
    
    func calSelectedTeamBlocks() -> (Int) {
        var blocks = 0
        for player in selectedRosterStats{
            blocks = blocks + player.blocks
        }
        return blocks
    }
    
    func calSelectedTeamSteals() -> (Int) {
        var steals = 0
        for player in selectedRosterStats{
            steals = steals + player.steals
        }
        return steals
    }
    
    func calSelectedTeamFouls() -> (Int) {
        var fouls = 0
        for player in selectedRosterStats{
            fouls = fouls + player.fouls
        }
        return fouls
    }
    
    func calSelectedTeamTurnovers() -> (Int) {
        var turnovers = 0
        for player in selectedRosterStats{
            turnovers = turnovers + player.turnovers
        }
        return turnovers
    }
    
    func calPoints(stat:Stats) -> (Int) {
        return stat.madeOnePoints + (2*stat.madeTwoPoints) + (3*stat.madeThreePoints)
    }
    
    func calFieldGoal(stat: Stats) -> (Double) {
        let made = stat.madeTwoPoints + stat.madeThreePoints
        let total = stat.madeTwoPoints + stat.madeThreePoints + stat.missedTwoPoints + stat.missedThreePoints
        let fieldGoalCal : Double = Double(made) / Double(total)
        return Double(round(fieldGoalCal * 1000)/1000) * 100
    }
    
    func calFreeThrow(stat: Stats) -> (Double) {
        let total = stat.madeOnePoints + stat.missedOnePoints
        let freeThrowCal : Double = Double(stat.madeOnePoints) / Double(total)
        return Double(round(freeThrowCal * 1000)/1000) * 100
    }
    
    func calRebounds(stat: Stats) -> (Int) {
        return stat.offRebounds + stat.defRebounds
    }
    
    /* *******************************************************************************************************************
     // VIEW CONTROLLER - DISPLAY STATISTICS FUNCTIONS
     ******************************************************************************************************************* */
    
    func displayTeamScore() {
        selectedTeamScoreLabel.text = "\(calSelectedTeamScore())"
        opponentTeamScoreLabel.text = "\(opponent.madeOnePoints + (opponent.madeTwoPoints * 2) + (opponent.madeThreePoints * 3))"
    }
    
    func displayTeamFieldGoal() {
        selectedTeamFieldGoalLabel.text = "\(calSelectedTeamFieldGoal())"
        let opponentFieldGoalCal : Double = Double(opponent.madeTwoPoints + opponent.madeThreePoints) / Double(opponent.madeTwoPoints + opponent.madeThreePoints + opponent.missedTwoPoints + opponent.missedThreePoints)
        opponentTeamFieldGoalLabel.text = "\(Double(round(opponentFieldGoalCal * 1000)/1000) * 100)"
    }
    
    func displayTeamFreeThrow() {
        selectedTeamFreeThrowLabel.text = "\(calSelectedTeamFreeThrow())"
        let opponentFreeThrowCal : Double = Double(opponent.madeOnePoints) / Double(opponent.madeOnePoints + opponent.missedOnePoints)
        opponentTeamFreeThrowLabel.text = "\(Double(round(opponentFreeThrowCal * 1000)/1000) * 100)"
    }
    
    func displayTeamAssists() {
        selectedTeamAssistLabel.text = "\(calSelectedTeamAssists())"
        opponentTeamAssistLabel.text = "\(opponent.assists)"
    }
    
    func displayTeamRebounds(){
        selectedTeamReboundLabel.text = "\(calSelectedTeamRebounds())"
        opponentTeamReboundLabel.text = "\(opponent.defRebounds + opponent.offRebounds)"
    }
    
    func displayTeamBlocks() {
        selectedTeamBlocksLabel.text = "\(calSelectedTeamBlocks())"
        opponentTeamBlocksLabel.text = "\(opponent.blocks)"
    }
    
    func displayTeamSteals() {
        selectedTeamStealsLabel.text = "\(calSelectedTeamSteals())"
        opponentTeamStealsLabel.text = "\(opponent.steals)"
    }
    
    func displayTeamFouls() {
        selectedTeamFoulsLabel.text = "\(calSelectedTeamFouls())"
        opponentTeamFoulsLabel.text = "\(opponent.fouls)"
    }
    
    func displayTeamTurnovers() {
        selectedTeamTurnoversLabel.text = "\(calSelectedTeamTurnovers())"
        opponentTeamTurnoversLabel.text = "\(opponent.turnovers)"
    }
    
    func displayIndividualStats(stat: Stats) {
        if selectedPlayer.playerID == stat.playerID {
            playerNameLabel.text = "#\(selectedPlayer.playerNumber) \(selectedPlayer.playerFirstName) \(selectedPlayer.playerLastName)"
            let points = calPoints(stat: stat)
            playerPointsLabel.text = "\(points)"
            let fieldGoal = calFieldGoal(stat: stat)
            if fieldGoal.isNaN == true {
                playerPercentageLabel.text = "0.0"
            } else {
                playerPercentageLabel.text = "\(fieldGoal)"
            }
            let freeThrow = calFreeThrow(stat: stat)
            if freeThrow.isNaN == true {
                playerFreeThrowPercentLabe.text = "0.0"
            } else {
                playerFreeThrowPercentLabe.text = "\(freeThrow)"
            }
            playerAssistLabel.text = "\(stat.assists)"
            let rebounds = calRebounds(stat: stat)
            playerReboundLabel.text = "\(rebounds)"
            playerStealsLabel.text = "\(stat.steals)"
            playerBlocksLabel.text = "\(stat.blocks)"
            playerTurnoverLabel.text = "\(stat.turnovers)"
            playerFoulsLabel.text = "\(stat.fouls)"
        }
    }
    
    /* *******************************************************************************************************************
     // VIEW CONTROLLER - ACTION BUTTONS
    ******************************************************************************************************************* */
    
    @IBAction func opponentButtonTapped(_ sender: Any) {
        opponentButtonSelected = true
        statsButtonView.isHidden = false
    }
    
    @IBAction func timerTapped(_ sender: Any) {
        //NEED TO DO
    }
    @IBAction func nextPeriodTapped(_ sender: Any) {
        //NEED TO DO
    }
    
    @IBAction func madeOneTapped(_ sender: Any) {
        if opponentButtonSelected == true {
            opponent.madeOnePoints = opponent.madeOnePoints + 1
            opponentButtonSelected = false
        } else {
            for stat in selectedRosterStats{
                if selectedPlayer.playerID == stat.playerID {
                    stat.madeOnePoints = stat.madeOnePoints + 1
                }
            }
            selectedPlayerStatsView.isHidden = true
        }
        statsButtonView.isHidden = true
        displayTeamScore()
        displayTeamFreeThrow()
        selectedTeamTableView.deselectRow(at: selectedPlayerIndexPath, animated: true)
        selectedTeamBenchTableView.allowsSelection = false
    }
    
    @IBAction func madeTwoTapped(_ sender: Any) {
        if opponentButtonSelected == true {
            opponent.madeTwoPoints = opponent.madeTwoPoints + 1
            opponentButtonSelected = false
        } else {
            for stat in selectedRosterStats{
                if selectedPlayer.playerID == stat.playerID {
                    stat.madeTwoPoints = stat.madeTwoPoints + 1
                }
            }
            selectedPlayerStatsView.isHidden = true
        }
        statsButtonView.isHidden = true
        displayTeamScore()
        displayTeamFieldGoal()
        selectedTeamTableView.deselectRow(at: selectedPlayerIndexPath, animated: true)
        selectedTeamBenchTableView.allowsSelection = false
    }
    
    @IBAction func madeThreeTapped(_ sender: Any) {
        if opponentButtonSelected == true {
            opponent.madeThreePoints = opponent.madeThreePoints + 1
            opponentButtonSelected = false
        } else {
            for stat in selectedRosterStats{
                if selectedPlayer.playerID == stat.playerID {
                    stat.madeThreePoints = stat.madeThreePoints + 1
                }
            }
            selectedPlayerStatsView.isHidden = true
        }
        statsButtonView.isHidden = true
        displayTeamScore()
        displayTeamFieldGoal()
        selectedTeamTableView.deselectRow(at: selectedPlayerIndexPath, animated: true)
        selectedTeamBenchTableView.allowsSelection = false
    }
    
    @IBAction func missOneTapped(_ sender: Any) {
        if opponentButtonSelected == true {
            opponent.missedOnePoints = opponent.missedOnePoints + 1
            opponentButtonSelected = false
        } else {
            for stat in selectedRosterStats{
                if selectedPlayer.playerID == stat.playerID {
                    stat.missedOnePoints = stat.missedOnePoints + 1
                }
            }
            selectedPlayerStatsView.isHidden = true
        }
        statsButtonView.isHidden = true
        displayTeamFieldGoal()
        displayTeamFreeThrow()
        selectedTeamTableView.deselectRow(at: selectedPlayerIndexPath, animated: true)
        selectedTeamBenchTableView.allowsSelection = false
    }
    
    @IBAction func missTwotapped(_ sender: Any) {
        if opponentButtonSelected == true {
            opponent.missedTwoPoints = opponent.missedTwoPoints + 1
            opponentButtonSelected = false
        } else {
            for stat in selectedRosterStats{
                if selectedPlayer.playerID == stat.playerID {
                    stat.missedTwoPoints = stat.missedTwoPoints + 1
                }
            }
            selectedPlayerStatsView.isHidden = true
        }
        statsButtonView.isHidden = true
        displayTeamFieldGoal()
        selectedTeamTableView.deselectRow(at: selectedPlayerIndexPath, animated: true)
        selectedTeamBenchTableView.allowsSelection = false
    }
    
    @IBAction func missThreeTapped(_ sender: Any) {
        if opponentButtonSelected == true {
            opponent.missedThreePoints = opponent.missedThreePoints + 1
            opponentButtonSelected = false
        } else {
            for stat in selectedRosterStats{
                if selectedPlayer.playerID == stat.playerID {
                    stat.missedThreePoints = stat.missedThreePoints + 1
                }
            }
            selectedPlayerStatsView.isHidden = true
        }
        statsButtonView.isHidden = true
        displayTeamFieldGoal()
        selectedTeamTableView.deselectRow(at: selectedPlayerIndexPath, animated: true)
        selectedTeamBenchTableView.allowsSelection = false
    }
    
    @IBAction func offReboundTapped(_ sender: Any) {
        if opponentButtonSelected == true {
            opponent.offRebounds = opponent.offRebounds + 1
            opponentButtonSelected = false
        } else {
            for stat in selectedRosterStats{
                if selectedPlayer.playerID == stat.playerID {
                    stat.offRebounds = stat.offRebounds + 1
                }
            }
            selectedPlayerStatsView.isHidden = true
        }
        statsButtonView.isHidden = true
        displayTeamRebounds()
        selectedTeamTableView.deselectRow(at: selectedPlayerIndexPath, animated: true)
        selectedTeamBenchTableView.allowsSelection = false
    }
    
    @IBAction func defReboundTapped(_ sender: Any) {
        if opponentButtonSelected == true {
            opponent.defRebounds = opponent.defRebounds + 1
            opponentButtonSelected = false
        } else {
            for stat in selectedRosterStats{
                if selectedPlayer.playerID == stat.playerID {
                    stat.defRebounds = stat.defRebounds + 1
                }
            }
            selectedPlayerStatsView.isHidden = true
        }
        statsButtonView.isHidden = true
        displayTeamRebounds()
        selectedTeamTableView.deselectRow(at: selectedPlayerIndexPath, animated: true)
        selectedTeamBenchTableView.allowsSelection = false
    }
    
    @IBAction func assistTapped(_ sender: Any) {
        if opponentButtonSelected == true {
            opponent.assists = opponent.assists + 1
            opponentButtonSelected = false
        } else {
            for stat in selectedRosterStats{
                if selectedPlayer.playerID == stat.playerID {
                    stat.assists = stat.assists + 1
                }
            }
            selectedPlayerStatsView.isHidden = true
        }
        statsButtonView.isHidden = true
        displayTeamAssists()
        selectedTeamTableView.deselectRow(at: selectedPlayerIndexPath, animated: true)
        selectedTeamBenchTableView.allowsSelection = false
    }
    
    @IBAction func blockTapped(_ sender: Any) {
        if opponentButtonSelected == true {
            opponent.blocks = opponent.blocks + 1
            opponentButtonSelected = false
        } else {
            for stat in selectedRosterStats{
                if selectedPlayer.playerID == stat.playerID {
                    stat.blocks = stat.blocks + 1
                }
            }
            selectedPlayerStatsView.isHidden = true
        }
        statsButtonView.isHidden = true
        displayTeamBlocks()
        selectedTeamTableView.deselectRow(at: selectedPlayerIndexPath, animated: true)
        selectedTeamBenchTableView.allowsSelection = false
    }
    
    @IBAction func stealTapped(_ sender: Any) {
        if opponentButtonSelected == true {
            opponent.steals = opponent.steals + 1
            opponentButtonSelected = false
        } else {
            for stat in selectedRosterStats{
                if selectedPlayer.playerID == stat.playerID {
                    stat.steals = stat.steals + 1
                }
            }
            selectedPlayerStatsView.isHidden = true
        }
        statsButtonView.isHidden = true
        displayTeamSteals()
        selectedTeamTableView.deselectRow(at: selectedPlayerIndexPath, animated: true)
        selectedTeamBenchTableView.allowsSelection = false
    }
    
    @IBAction func turnoverTapped(_ sender: Any) {
        if opponentButtonSelected == true {
            opponent.turnovers = opponent.turnovers + 1
            opponentButtonSelected = false
        } else {
            for stat in selectedRosterStats{
                if selectedPlayer.playerID == stat.playerID {
                    stat.turnovers = stat.turnovers + 1
                }
            }
            selectedPlayerStatsView.isHidden = true
        }
        statsButtonView.isHidden = true
        displayTeamTurnovers()
        selectedTeamTableView.deselectRow(at: selectedPlayerIndexPath, animated: true)
        selectedTeamBenchTableView.allowsSelection = false
    }
    
    @IBAction func foulTapped(_ sender: Any) {
        if opponentButtonSelected == true {
            opponent.fouls = opponent.fouls + 1
            opponentButtonSelected = false
        } else {
            for stat in selectedRosterStats{
                if selectedPlayer.playerID == stat.playerID {
                    stat.fouls = stat.fouls + 1
                }
            }
            selectedPlayerStatsView.isHidden = true
        }
        statsButtonView.isHidden = true
        displayTeamFouls()
        selectedTeamTableView.deselectRow(at: selectedPlayerIndexPath, animated: true)
        selectedTeamBenchTableView.allowsSelection = false
    }
    
    @IBAction func fixTapped(_ sender: Any) {
        //NEED TO DO
    }
    
    
}
