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
    @IBOutlet weak var selectedTeamFieldGoalLabel: CustomStatBarLabel!
    @IBOutlet weak var selectedTeamThreePointLabel: CustomStatBarLabel!
    @IBOutlet weak var selectedTeamFreeThrowLabel: CustomStatBarLabel!
    @IBOutlet weak var selectedTeamReboundLabel: CustomStatBarLabel!
    @IBOutlet weak var selectedTeamAssistLabel: CustomStatBarLabel!
    @IBOutlet weak var opponentTeamScoreLabel: UILabel!
    @IBOutlet weak var opponentTeamFieldGoalLabel: CustomStatBarLabel!
    @IBOutlet weak var opponentTeamThreePointLabel: CustomStatBarLabel!
    @IBOutlet weak var opponentTeamFreeThrowLabel: CustomStatBarLabel!
    @IBOutlet weak var opponentTeamReboundLabel: CustomStatBarLabel!
    @IBOutlet weak var opponentTeamAssistLabel: CustomStatBarLabel!
    @IBOutlet weak var gameDateLabel: UILabel!
    @IBOutlet weak var gamePeriodsLabel: UILabel!
    @IBOutlet weak var gamePeriodLengthLabel: UILabel!
    @IBOutlet weak var gameFoulsLabel: UILabel!

    /* *******************************************************************************************************************
     // VIEW CONTROLLER - BAR OUTLETS
     ******************************************************************************************************************* */
    
    @IBOutlet weak var selectedTeamFGBar: CustomStatBarView!
    @IBOutlet weak var selectedTeam3PBar: CustomStatBarView!
    @IBOutlet weak var selectedTeamFTBar: CustomStatBarView!
    @IBOutlet weak var selectedTeamRebBar: CustomStatBarView!
    @IBOutlet weak var selectedTeamAstBar: CustomStatBarView!
    @IBOutlet weak var opponentTeamFGBar: CustomStatBarView!
    @IBOutlet weak var opponentTeam3PBar: CustomStatBarView!
    @IBOutlet weak var opponentTeamFTBar: CustomStatBarView!
    @IBOutlet weak var opponentTeamRebBar: CustomStatBarView!
    @IBOutlet weak var opponentTeamAstBar: CustomStatBarView!
    
    /* *******************************************************************************************************************
     // VIEW CONTROLLER - GOLBAL VARIABLES
     ******************************************************************************************************************* */
    
    var teams = [Team]()
    var selectedTeamGames = [Game]()
    var selectedTeam : Team? = nil
    var selectedGame : Game? = nil
    var selectedTeamGameStats = [Stats]()
    var selectedOpponentGameStats = Stats()
    var roster = [Player]()
    
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
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Games"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomGameTableViewCell", for: indexPath) as! CustomGameTableViewCell
        var game = Game()
        game = selectedTeamGames[indexPath.row]
        cell.configureCell(game: game)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        gameSummaryView.isHidden = false
        selectedGame = selectedTeamGames[indexPath.row]
        displayGameInfo()
        selectedTeamGameStats = [Stats]()
        getGameSummary()
        checkGameStatus()
        getPlayers()
    }
    
    /* *******************************************************************************************************************
     // FIREBASE - DATABASE QUERY
     ******************************************************************************************************************* */
    
    func getTeams() {
        FIRDatabase.database().reference().child(FIRAuth.auth()!.currentUser!.uid).child("teams").observe(FIRDataEventType.childAdded, with: {(snapshot) in
            let team = Team()
            team.teamID = snapshot.key
            team.teamName = (snapshot.value as! NSDictionary)["teamName"] as! String
            self.teams.append(team)
            self.teamsPickerView.reloadAllComponents()
        })
    }
    
    func getGames() {
        FIRDatabase.database().reference().child(FIRAuth.auth()!.currentUser!.uid).child("games").child((selectedTeam?.teamID)!).observe(FIRDataEventType.childAdded, with: {(snapshot) in
            let game = Game()
            
            game.gameID = snapshot.key
            game.gameDateTime = (snapshot.value as! NSDictionary)["gameDate"] as! String
            game.gameNumFouls = (snapshot.value as! NSDictionary)["gameFouls"] as! String
            game.gameNumPeriods = (snapshot.value as! NSDictionary)["gameNumPeriods"] as! String
            game.gameSelectedTeam = (self.selectedTeam?.teamID)!
            game.gameOppTeam = (snapshot.value as! NSDictionary)["gameOpponent"] as! String
            game.gamePeriodLength = (snapshot.value as! NSDictionary)["gamePeriodLength"] as! String
            game.gameStatus = (snapshot.value as! NSDictionary)["gameStatus"] as! String
            game.gameOutcome = (snapshot.value as! NSDictionary)["gameOutcome"] as! String
            self.selectedTeamGames.append(game)
            self.gamesTableView.reloadData()
        })
    }
    
    func getGameSummary() {
        FIRDatabase.database().reference().child(FIRAuth.auth()!.currentUser!.uid).child("gameResults").child((selectedTeam?.teamID)!).child((selectedGame?.gameID)!).observe(FIRDataEventType.childAdded, with: {(snapshot) in
            let stats = Stats()
            
            stats.playerID = snapshot.key
            stats.playingTimeInSeconds = (snapshot.value as! NSDictionary)["playingTime"] as! Int
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
    
    func getPlayers() {
        roster.removeAll()
        FIRDatabase.database().reference().child(FIRAuth.auth()!.currentUser!.uid).child("players").child(selectedTeam!.teamID).observe(FIRDataEventType.childAdded, with: {(snapshot) in
            let player = Player()
            player.playerID = snapshot.key
            player.playerFirstName = (snapshot.value as! NSDictionary)["playerFirstName"] as! String
            player.playerLastName = (snapshot.value as! NSDictionary)["playerLastName"] as! String
            player.playerNumber = (snapshot.value as! NSDictionary)["playerNumber"] as! String
            player.playerPosition = (snapshot.value as! NSDictionary)["playerPosition"] as! String
            player.playerTeam = self.selectedTeam!.teamID
            self.roster.append(player)
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
        return Double(made) / Double(total)
    }
    
    func calSelectedTeamThreePoint() -> (Double) {
        var made = 0.0
        var total = 0.0
        for player in selectedTeamGameStats {
            made += Double(player.madeThreePoints)
            total += (Double(player.madeThreePoints) + Double(player.missedThreePoints))
        }
        return Double(made) / Double (total)
    }
    
    func calSelectedTeamFreeThrow() -> (Double) {
        var made = 0.0
        var total = 0.0
        for player in selectedTeamGameStats {
            made += Double(player.madeOnePoints)
            total += (Double(player.madeOnePoints) + Double(player.missedOnePoints))
        }
        return Double(made) / Double(total)
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
        //selectedTeamNameLabel.sizeToFit()
        opponentTeamNameLabel.text = selectedGame?.gameOppTeam
        //opponentTeamNameLabel.sizeToFit()
        gameDateLabel.text = selectedGame?.gameDateTime
        gameDateLabel.sizeToFit()
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
        var selectedFieldGoalCal : Double = Double(calSelectedTeamFieldGoal())
        var opponentFieldGoalCal : Double = Double(selectedOpponentGameStats.madeTwoPoints + selectedOpponentGameStats.madeThreePoints) / Double(selectedOpponentGameStats.madeTwoPoints + selectedOpponentGameStats.madeThreePoints + selectedOpponentGameStats.missedTwoPoints + selectedOpponentGameStats.missedThreePoints)
        
        selectedTeamFieldGoalLabel.text = checkIfNaN(calculatedPercentage: calSelectedTeamFieldGoal())
        opponentTeamFieldGoalLabel.text = checkIfNaN(calculatedPercentage: opponentFieldGoalCal)
        
        if selectedFieldGoalCal.isNaN == true {
            selectedFieldGoalCal = 0.0
        }
        if opponentFieldGoalCal.isNaN == true {
            opponentFieldGoalCal = 0.0
        }
        
        UIView.animate(withDuration: 0.5,
                        delay: 0.1,
                        options: UIViewAnimationOptions.beginFromCurrentState,
                        animations: { () -> Void in
                            // adjust bars
                            self.selectedTeamFGBar.adjustSize(currentValue: selectedFieldGoalCal * 100, max: 100)
                            self.opponentTeamFGBar.adjustSize(currentValue: opponentFieldGoalCal * 100, max: 100)
                            
                            //adjust labels
                            self.selectedTeamFieldGoalLabel.adjustPosition(currentValue: selectedFieldGoalCal * 100, max: 100, leftBarOrigin: self.selectedTeamFGBar.frame.origin)
                            self.opponentTeamFieldGoalLabel.adjustPosition(currentValue: opponentFieldGoalCal * 100, max: 100, rightBarOrigin: self.opponentTeamFGBar.frame.origin)
        }, completion: { (finished) -> Void in
                
        })
    }
    
    
    func displayTeamThreePoint() {
        var selectedThreePointCal : Double = calSelectedTeamThreePoint()
        var opponentThreePointCal : Double = Double(selectedOpponentGameStats.madeThreePoints) / Double(selectedOpponentGameStats.madeThreePoints + selectedOpponentGameStats.missedThreePoints)
        
        selectedTeamThreePointLabel.text = checkIfNaN(calculatedPercentage: selectedThreePointCal)
        opponentTeamThreePointLabel.text = checkIfNaN(calculatedPercentage: opponentThreePointCal)
        
        if selectedThreePointCal.isNaN == true {
            selectedThreePointCal = 0.0
        }
        if opponentThreePointCal.isNaN == true {
            opponentThreePointCal = 0.0
        }
        
        UIView.animate(withDuration: 0.5,
                       delay: 0.1,
                       options: UIViewAnimationOptions.beginFromCurrentState,
                       animations: { () -> Void in
                        // adjust bars
                        self.selectedTeam3PBar.adjustSize(currentValue: selectedThreePointCal * 100, max: 100)
                        self.opponentTeam3PBar.adjustSize(currentValue: opponentThreePointCal * 100, max: 100)
                        
                        //adjust labels
                        self.selectedTeamThreePointLabel.adjustPosition(currentValue: selectedThreePointCal * 100, max: 100, leftBarOrigin: self.selectedTeam3PBar.frame.origin)
                        self.opponentTeamThreePointLabel.adjustPosition(currentValue: opponentThreePointCal * 100, max: 100, rightBarOrigin: self.opponentTeam3PBar.frame.origin)
        }, completion: { (finished) -> Void in
            
        })
    }
    
    func displayTeamFreeThrow() {
        var selectedFreeThrowCal : Double = Double(calSelectedTeamFreeThrow())
        var opponentFreeThrowCal : Double = Double(selectedOpponentGameStats.madeOnePoints) / Double(selectedOpponentGameStats.madeOnePoints + selectedOpponentGameStats.missedOnePoints)
        
        selectedTeamFreeThrowLabel.text = checkIfNaN(calculatedPercentage: calSelectedTeamFreeThrow())
        opponentTeamFreeThrowLabel.text = checkIfNaN(calculatedPercentage: opponentFreeThrowCal)
        
        if selectedFreeThrowCal.isNaN == true {
            selectedFreeThrowCal = 0.0
        }
        if opponentFreeThrowCal.isNaN == true {
            opponentFreeThrowCal = 0.0
        }
        
        UIView.animate(withDuration: 0.5,
                       delay: 0.1,
                       options: UIViewAnimationOptions.beginFromCurrentState,
                       animations: { () -> Void in
                        
                        //adjust bars
                        self.selectedTeamFTBar.adjustSize(currentValue: selectedFreeThrowCal * 100, max: 100)
                        self.opponentTeamFTBar.adjustSize(currentValue: opponentFreeThrowCal * 100, max: 100)
        
                        //adjust labels
                        self.selectedTeamFreeThrowLabel.adjustPosition(currentValue: selectedFreeThrowCal * 100, max: 100, leftBarOrigin: self.selectedTeamFTBar.frame.origin)
                        self.opponentTeamFreeThrowLabel.adjustPosition(currentValue: opponentFreeThrowCal * 100, max: 100, rightBarOrigin: self.opponentTeamFTBar.frame.origin)
        }, completion: { (finished) -> Void in
            
        })
    }
    
    func displayTeamAssists() {
        let selectedAssistCal : Int = calSelectedTeamAssists()
        let opponentAssistCal : Int = selectedOpponentGameStats.assists
        
        selectedTeamAssistLabel.text = "\(selectedAssistCal)"
        opponentTeamAssistLabel.text = "\(opponentAssistCal)"
        
        
        UIView.animate(withDuration: 0.5,
                       delay: 0.1,
                       options: UIViewAnimationOptions.beginFromCurrentState,
                       animations: { () -> Void in
                        // adjustbars
                        self.selectedTeamAstBar.adjustSize(currentValue: Double(selectedAssistCal), max: 50)
                        self.opponentTeamAstBar.adjustSize(currentValue: Double(opponentAssistCal), max: 50)
                        
                        //adjust labels
                        self.selectedTeamAssistLabel.adjustPosition(currentValue: Double(selectedAssistCal), max: 50, leftBarOrigin: self.selectedTeamAstBar.frame.origin)
                        self.opponentTeamAssistLabel.adjustPosition(currentValue: Double(opponentAssistCal), max: 50, rightBarOrigin: self.opponentTeamAstBar.frame.origin)
        }, completion: { (finished) -> Void in
            
        })

    }
    
    func displayTeamRebounds() {
        let selectedReboundCal : Int = calSelectedTeamRebounds()
        let opponentReboundCal : Int = selectedOpponentGameStats.defRebounds + selectedOpponentGameStats.offRebounds
            
        selectedTeamReboundLabel.text = "\(selectedReboundCal)"
        opponentTeamReboundLabel.text = "\(opponentReboundCal)"
        
        UIView.animate(withDuration: 0.5,
                       delay: 0.1,
                       options: UIViewAnimationOptions.beginFromCurrentState,
                       animations: { () -> Void in
                        // adjust bars
                        self.selectedTeamRebBar.adjustSize(currentValue: Double(selectedReboundCal), max: 50)
                        self.opponentTeamRebBar.adjustSize(currentValue: Double(opponentReboundCal), max: 50)
        
        
                        //adjust labels
                        self.selectedTeamReboundLabel.adjustPosition(currentValue: Double(selectedReboundCal), max: 50, leftBarOrigin: self.selectedTeamRebBar.frame.origin)
                        self.opponentTeamReboundLabel.adjustPosition(currentValue: Double(opponentReboundCal), max: 50, rightBarOrigin: self.opponentTeamRebBar.frame.origin)
        }, completion: { (finished) -> Void in
            
        })
        
    }
    
    func checkIfNaN(calculatedPercentage: Double) -> String {
        if calculatedPercentage.isNaN == true {
            return "0.0"
        } else {
            return "\(Double(round(calculatedPercentage * 1000)/1000) * 100)"
        }
    }
    /* *******************************************************************************************************************
     // VIEW CONTROLLER - ACTION BUTTONS
     ******************************************************************************************************************* */
    
    func checkGameStatus() {
        if selectedGame?.gameStatus == "complete"
        {
            beginBoxScoreButton.setTitle("Box Score", for: .normal)
        } else {
            beginBoxScoreButton.setTitle("Begin Game", for: .normal)
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
            let nextVC = segue.destination as! BoxScoreViewController
            nextVC.selectedTeam = selectedTeam!
            nextVC.stats = selectedTeamGameStats
            nextVC.oppStats = selectedOpponentGameStats
            nextVC.roster = roster
        }
    }
    
    @IBAction func newGameTapped(_ sender: Any) {
        performSegue(withIdentifier: "newGameSegue", sender: selectedTeam)
    }
    
    @IBAction func beginGameTapped(_ sender: Any) {
        if selectedGame?.gameStatus == "complete" {
            performSegue(withIdentifier: "boxScoreSegue", sender: nil)
        } else {
            performSegue(withIdentifier: "beginGameSegue", sender: selectedGame)
        }
    }
    
    
    
}
