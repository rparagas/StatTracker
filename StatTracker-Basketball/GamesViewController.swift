//
//  GamesViewController.swift
//  StatTracker-Basketball
//
//  Created by Ray Paragas on 31/12/16.
//  Copyright © 2016 Ray Paragas. All rights reserved.
//

import UIKit
import Firebase

class GamesViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource {


    /* *******************************************************************************************************************
     // VIEW CONTROLLER - VIEW OUTLETS
     ******************************************************************************************************************* */
    
    @IBOutlet weak var gamesTableView: UITableView!
    @IBOutlet weak var teamsPickerView: UIPickerView!
    @IBOutlet weak var gameSummaryView: UIView!
    
    /* *******************************************************************************************************************
     // VIEW CONTROLLER - BUTTON OUTLETS
     ******************************************************************************************************************* */
    @IBOutlet weak var beginBoxScoreButton: UIButton!
    @IBOutlet weak var newGameButton: UIBarButtonItem!
    
    /* *******************************************************************************************************************
     // VIEW CONTROLLER - LABEL OUTLETS
     ******************************************************************************************************************* */
    
    @IBOutlet weak var selectedTeamNameLabel: UILabel!
    @IBOutlet weak var opponentTeamNameLabel: UILabel!
    @IBOutlet weak var selectedTeamScoreLabel: UILabel!
    @IBOutlet weak var selectedTeamFieldGoalLabel: UILabel!
    @IBOutlet weak var selectedTeamThreePointLabel: UILabel!
    @IBOutlet weak var selectedTeamFreeThrowLabel: UILabel!
    @IBOutlet weak var selectedTeamReboundLabel: UILabel!
    @IBOutlet weak var selectedTeamAssistLabel: UILabel!
    @IBOutlet weak var opponentTeamScoreLabel: UILabel!
    @IBOutlet weak var opponentTeamFieldGoalLabel: UILabel!
    @IBOutlet weak var opponentTeamThreePointLabel: UILabel!
    @IBOutlet weak var opponentTeamFreeThrowLabel: UILabel!
    @IBOutlet weak var opponentTeamReboundLabel: UILabel!
    @IBOutlet weak var opponentTeamAssistLabel: UILabel!
    @IBOutlet weak var gameDateLabel: UILabel!
    @IBOutlet weak var gamePeriodsLabel: UILabel!
    @IBOutlet weak var gamePeriodLengthLabel: UILabel!
    @IBOutlet weak var gameFoulsLabel: UILabel!

    /* *******************************************************************************************************************
     // VIEW CONTROLLER - GOLBAL VARIABLES
     ******************************************************************************************************************* */
    
    var teams = [Team]()
    var selectedTeamGames = [Game]()
    var selectedTeam : Team? = nil
    var selectedGame : Game? = nil
    var selectedTeamGameStats = [Stats]()
    var selectedOpponentGameStats = Stats()
    
    /* *******************************************************************************************************************
     // VIEW CONTROLLER - BOILERPLATE
     ******************************************************************************************************************* */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        teamsPickerView.delegate = self
        teamsPickerView.dataSource = self
        gamesTableView.delegate = self
        gamesTableView.dataSource = self
        getTeams()
        newGameButton.isEnabled = false
        gameSummaryView.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    /* *******************************************************************************************************************
     // VIEW CONTROLLER - PICKERVIEW FUNCTIONS
     ******************************************************************************************************************* */
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return teams.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let team = teams[row]
        return team.teamName
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedTeam = teams[row]
        if selectedTeam != nil {
            newGameButton.isEnabled = true
        }
        
        if selectedTeamGames.isEmpty != true {
            selectedTeamGames.removeAll()
        }
        getGames()
    }
    
    /* *******************************************************************************************************************
     // VIEW CONTROLLER - TABLEVIEW FUNCTIONS
     ******************************************************************************************************************* */
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedTeamGames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var game = Game()
        game = selectedTeamGames[indexPath.row]
        cell.textLabel?.text = "vs \(game.gameOppTeam) - \(game.gameDateTime)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        gameSummaryView.isHidden = false
        selectedGame = selectedTeamGames[indexPath.row]
        displayGameInfo()
        getGameSummary()
        checkGameStatus()
    }
    
    /* *******************************************************************************************************************
     // FIREBASE - DATABASE QUERY
     ******************************************************************************************************************* */
    
    func getTeams() {
        FIRDatabase.database().reference().child("teams").observe(FIRDataEventType.childAdded, with: {(snapshot) in
            let team = Team()
            team.teamID = snapshot.key
            team.teamName = (snapshot.value as! NSDictionary)["teamName"] as! String
            self.teams.append(team)
            self.teamsPickerView.reloadAllComponents()
        })
    }
    
    func getGames() {
        FIRDatabase.database().reference().child("games").child((selectedTeam?.teamID)!).observe(FIRDataEventType.childAdded, with: {(snapshot) in
            let game = Game()
            
            game.gameID = snapshot.key
            game.gameDateTime = (snapshot.value as! NSDictionary)["gameDate"] as! String
            game.gameNumFouls = (snapshot.value as! NSDictionary)["gameFouls"] as! String
            game.gameNumPeriods = (snapshot.value as! NSDictionary)["gameNumPeriods"] as! String
            game.gameSelectedTeam = (self.selectedTeam?.teamID)!
            game.gameOppTeam = (snapshot.value as! NSDictionary)["gameOpponent"] as! String
            game.gamePeriodLength = (snapshot.value as! NSDictionary)["gamePeriodLength"] as! String
            game.gameStatus = (snapshot.value as! NSDictionary)["gameStatus"] as! String
            self.selectedTeamGames.append(game)
            self.gamesTableView.reloadData()
        })
    }
    
    func getGameSummary() {
        FIRDatabase.database().reference().child("gameResults").child((selectedTeam?.teamID)!).child((selectedGame?.gameID)!).observe(FIRDataEventType.childAdded, with: {(snapshot) in
            let stats = Stats()
            
            stats.playerID = snapshot.key
            stats.madeOnePoints = (snapshot.value as! NSDictionary)["madeOne"] as! Int
            stats.missedOnePoints = (snapshot.value as! NSDictionary)["missOne"] as! Int
            stats.madeTwoPoints = (snapshot.value as! NSDictionary)["madeTwo"] as! Int
            stats.missedTwoPoints = (snapshot.value as! NSDictionary)["missTwo"] as! Int
            stats.madeThreePoints = (snapshot.value as! NSDictionary)["madeThree"] as! Int
            stats.missedThreePoints = (snapshot.value as! NSDictionary)["missThree"] as! Int
            stats.assists = (snapshot.value as! NSDictionary)["assists"] as! Int
            stats.offRebounds = (snapshot.value as! NSDictionary)["offRebounds"] as! Int
            stats.defRebounds = (snapshot.value as! NSDictionary)["defRebounds"] as! Int
            stats.steals = (snapshot.value as! NSDictionary)["steals"] as! Int
            stats.blocks = (snapshot.value as! NSDictionary)["blocks"] as! Int
            stats.fouls = (snapshot.value as! NSDictionary)["fouls"] as! Int
            stats.turnovers = (snapshot.value as! NSDictionary)["turnovers"] as! Int
            
            if stats.playerID == "opponent" {
                self.selectedOpponentGameStats = stats
            } else {
                self.selectedTeamGameStats.append(stats)
            }
            self.displayTeamStats()
        })
    }
    
    /* *******************************************************************************************************************
     // VIEW CONTROLLER - CALCULATE STATISTICS FUNCTIONS
     ******************************************************************************************************************* */
    
    func calSelectedTeamScore() -> (Int) {
        var score = 0
        for player in selectedTeamGameStats {
            score += player.madeOnePoints
            score += player.madeTwoPoints * 2
            score += player.madeThreePoints * 3
        }
        return score
    }
    
    func calSelectedTeamFieldGoal() -> (Double) {
        var made = 0.0
        var total = 0.0
        for player in selectedTeamGameStats {
            made += (Double(player.madeTwoPoints) + Double(player.madeThreePoints))
            total += (Double(player.madeTwoPoints) + Double(player.madeThreePoints) + Double(player.missedTwoPoints) + Double(player.missedThreePoints))
        }
        let fieldGoal : Double = Double(made) / Double(total)
        return Double(round(fieldGoal * 1000)/1000) * 100
    }
    
    func calSelectedTeamThreePoint() -> (Double) {
        var made = 0.0
        var total = 0.0
        for player in selectedTeamGameStats {
            made += Double(player.madeThreePoints)
            total += (Double(player.madeThreePoints) + Double(player.missedThreePoints))
        }
        let threePoint : Double = Double(made) / Double (total)
        return Double(round(threePoint * 1000)/1000) * 100
    }
    
    func calSelectedTeamFreeThrow() -> (Double) {
        var made = 0.0
        var total = 0.0
        for player in selectedTeamGameStats {
            made += Double(player.madeOnePoints)
            total += (Double(player.madeOnePoints) + Double(player.missedOnePoints))
        }
        let freeThrow : Double = Double(made) / Double(total)
        return Double(round(freeThrow * 1000)/1000) * 100
    }
    
    func calSelectedTeamAssists() -> (Int) {
        var assists = 0
        for player in selectedTeamGameStats {
            assists += player.assists
        }
        return assists
    }
    
    func calSelectedTeamRebounds() -> (Int) {
        var rebounds = 0
        for player in selectedTeamGameStats{
            rebounds += (player.defRebounds + player.offRebounds)
        }
        return rebounds
    }
    
    func calSelectedTeamBlocks(selectedRosterStats: [Stats]) -> (Int) {
        var blocks = 0
        for player in selectedRosterStats {
            blocks += player.blocks
        }
        return blocks
    }
    
    func calSelectedTeamSteals() -> (Int) {
        var steals = 0
        for player in selectedTeamGameStats {
            steals += player.steals
        }
        return steals
    }
    
    func calSelectedTeamFouls() -> (Int) {
        var fouls = 0
        for player in selectedTeamGameStats {
            fouls += player.fouls
        }
        return fouls
    }
    
    func calSelectedTeamTurnovers() -> (Int) {
        var turnovers = 0
        for player in selectedTeamGameStats {
            turnovers += player.turnovers
        }
        return turnovers
    }
    
    /* *******************************************************************************************************************
     // VIEW CONTROLLER - DISPLAY FUNCTIONS
     ******************************************************************************************************************* */
    
    func displayGameInfo() {
        selectedTeamNameLabel.text = selectedTeam?.teamName
        opponentTeamNameLabel.text = selectedGame?.gameOppTeam
        gameDateLabel.text = selectedGame?.gameDateTime
        gamePeriodsLabel.text = selectedGame?.gameNumPeriods
        gamePeriodLengthLabel.text = selectedGame?.gamePeriodLength
        gameFoulsLabel.text = selectedGame?.gameNumFouls
    }
    
    func displayTeamStats() {
        displayTeamScore()
        displayTeamFieldGoal()
        displayTeamThreePoint()
        displayTeamFreeThrow()
        displayTeamAssists()
        displayTeamRebounds()
    }
    
    func displayTeamScore() {
        selectedTeamScoreLabel.text = "\(calSelectedTeamScore())"
        opponentTeamScoreLabel.text = "\(selectedOpponentGameStats.madeOnePoints + (selectedOpponentGameStats.madeTwoPoints * 2) + (selectedOpponentGameStats.madeThreePoints * 3))"
    }

    func displayTeamFieldGoal() {
        selectedTeamFieldGoalLabel.text = "\(calSelectedTeamFieldGoal())"
        let opponentFieldGoalCal : Double = Double(selectedOpponentGameStats.madeTwoPoints + selectedOpponentGameStats.madeThreePoints) / Double(selectedOpponentGameStats.madeTwoPoints + selectedOpponentGameStats.madeThreePoints + selectedOpponentGameStats.missedTwoPoints + selectedOpponentGameStats.missedThreePoints)
        opponentTeamFieldGoalLabel.text = "\(Double(round(opponentFieldGoalCal * 1000)/1000) * 100)"
    }
    
    func displayTeamThreePoint() {
        selectedTeamFieldGoalLabel.text = "\(calSelectedTeamThreePoint())"
        let opponentFieldGoalCal : Double = Double(selectedOpponentGameStats.madeThreePoints) / Double(selectedOpponentGameStats.madeThreePoints + selectedOpponentGameStats.missedThreePoints)
        opponentTeamFieldGoalLabel.text = "\(Double(round(opponentFieldGoalCal * 1000)/1000) * 100)"
    }
    
    func displayTeamFreeThrow() {
        selectedTeamFreeThrowLabel.text = "\(calSelectedTeamFreeThrow())"
        let opponentFreeThrowCal : Double = Double(selectedOpponentGameStats.madeOnePoints) / Double(selectedOpponentGameStats.madeOnePoints + selectedOpponentGameStats.missedOnePoints)
        opponentTeamFreeThrowLabel.text = "\(Double(round(opponentFreeThrowCal * 1000)/1000) * 100)"
    }
    
    func displayTeamAssists() {
        selectedTeamAssistLabel.text = "\(calSelectedTeamAssists())"
        opponentTeamAssistLabel.text = "\(selectedOpponentGameStats.assists)"
    }
    
    func displayTeamRebounds() {
        selectedTeamReboundLabel.text = "\(calSelectedTeamRebounds())"
        opponentTeamReboundLabel.text = "\(selectedOpponentGameStats.defRebounds + selectedOpponentGameStats.offRebounds)"
    }
    
    /* *******************************************************************************************************************
     // VIEW CONTROLLER - ACTION BUTTONS
     ******************************************************************************************************************* */
    
    func checkGameStatus() {
        if selectedGame?.gameStatus == "complete"
        {
            beginBoxScoreButton.setTitle("Box Score", for: .normal)
        }
    }
    
    /* *******************************************************************************************************************
     // VIEW CONTROLLER - ACTION BUTTONS
     ******************************************************************************************************************* */

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newGameSegue" {
            let nextVC = segue.destination as! AddGameViewController
            nextVC.selectedTeam = sender as! Team
        }
        if segue.identifier == "beginGameSegue" {
            let nextVC = segue.destination as! StatTrackerViewController
            nextVC.selectedGame = sender as! Game
            nextVC.selectedTeam = selectedTeam!
        }
        if segue.identifier == "boxScoreSegue" {
            let nextVC = segue.destination as! BoxScoreCollectionViewController
            //nextVC.selectedGame = sender as! Game
            //nextVC.selectedTeam = selectedTeam!
            //nextVC.stats = selectedTeamGameStats
            //nextVC.oppStats = selectedOpponentGameStats
        }
    }
    
    @IBAction func newGameTapped(_ sender: Any) {
        performSegue(withIdentifier: "newGameSegue", sender: selectedTeam)
    }
    
    @IBAction func beginGameTapped(_ sender: Any) {
        if selectedGame?.gameStatus == "complete" {
            performSegue(withIdentifier: "boxScoreSegue", sender: selectedGame)
        } else {
            performSegue(withIdentifier: "beginGameSegue", sender: selectedGame)
        }
    }
    
    
    
}
