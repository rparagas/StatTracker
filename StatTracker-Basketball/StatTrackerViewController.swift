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
    @IBOutlet weak var currentPeriodLabel: UILabel!
    @IBOutlet weak var periodButton: UIButton!
    
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
    @IBOutlet weak var selectedTeamFieldGoalLabel: CustomStatBarLabel!
    @IBOutlet weak var selectedTeamThreePointLabel: CustomStatBarLabel!
    @IBOutlet weak var selectedTeamFreeThrowLabel: CustomStatBarLabel!
    @IBOutlet weak var selectedTeamAssistLabel: CustomStatBarLabel!
    @IBOutlet weak var selectedTeamReboundLabel: CustomStatBarLabel!
    @IBOutlet weak var selectedTeamBlocksLabel: CustomStatBarLabel!
    @IBOutlet weak var selectedTeamStealsLabel: CustomStatBarLabel!
    @IBOutlet weak var selectedTeamTurnoversLabel: CustomStatBarLabel!
    @IBOutlet weak var opponentTeamNameLabel: UILabel!
    @IBOutlet weak var opponentTeamScoreLabel: UILabel!
    @IBOutlet weak var opponentTeamFieldGoalLabel: CustomStatBarLabel!
    @IBOutlet weak var opponentTeamThreePointLabel: CustomStatBarLabel!
    @IBOutlet weak var opponentTeamFreeThrowLabel: CustomStatBarLabel!
    @IBOutlet weak var opponentTeamAssistLabel: CustomStatBarLabel!
    @IBOutlet weak var opponentTeamReboundLabel: CustomStatBarLabel!
    @IBOutlet weak var opponentTeamBlocksLabel: CustomStatBarLabel!
    @IBOutlet weak var opponentTeamStealsLabel: CustomStatBarLabel!
    @IBOutlet weak var opponentTeamTurnoversLabel: CustomStatBarLabel!
    
    /* *******************************************************************************************************************
     // VIEW CONTROLLER - BAR OUTLETS
     ******************************************************************************************************************* */
    
    @IBOutlet weak var selectedTeamFGBar: CustomStatBarView!
    @IBOutlet weak var selectedTeamFTBar: CustomStatBarView!
    @IBOutlet weak var selectedTeam3PBar: CustomStatBarView!
    @IBOutlet weak var selectedTeamAstBar: CustomStatBarView!
    @IBOutlet weak var selectedTeamRebBar: CustomStatBarView!
    @IBOutlet weak var selectedTeamBlkBar: CustomStatBarView!
    @IBOutlet weak var selectedTeamStlBar: CustomStatBarView!
    @IBOutlet weak var selectedTeamTOBar: CustomStatBarView!
    @IBOutlet weak var opponentTeamFGBar: CustomStatBarView!
    @IBOutlet weak var opponentTeam3PBar: CustomStatBarView!
    @IBOutlet weak var opponentTeamFTBar: CustomStatBarView!
    @IBOutlet weak var opponentTeamAstBar: CustomStatBarView!
    @IBOutlet weak var opponentTeamRebBar: CustomStatBarView!
    @IBOutlet weak var opponentTeamBlkBar: CustomStatBarView!
    @IBOutlet weak var opponentTeamStlBar: CustomStatBarView!
    @IBOutlet weak var opponentTeamTOBar: CustomStatBarView!
    
    
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
    
    var periodTimer = Timer()
    var currentPeriodTimeInSeconds = 0
    var isTimeout = true
    
    var currentPeriod = 1
    
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
        hideTrackerViews()
        
        selectedTeamBenchTableView.allowsSelection = false
        selectedTeamNameLabel.text = "\(selectedTeam.teamName)"
        opponentTeamNameLabel.text = "\(selectedGame.gameOppTeam)"
        
        currentPeriodTimeInSeconds = Int(selectedGame.gamePeriodLength)! * 60
        let (m,s) = calMinutesSeconds(seconds: currentPeriodTimeInSeconds)
        timeButton.setTitle("\(m) : 0\(s)", for: .normal)
        displayCurrentPeriod()
        
        displayTeamFieldGoal()
        displayTeamThreePoint()
        displayTeamFreeThrow()
        displayTeamAssists()
        displayTeamRebounds()
        displayTeamBlocks()
        displayTeamSteals()
        displayTeamTurnovers()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomPlayerTableViewCell", for: indexPath) as! CustomPlayerTableViewCell
        var player = Player()
        
        if tableView == self.selectedTeamTableView {
            player = selectedActiveRoster[indexPath.row]
            for stats in selectedRosterStats {
                if stats.playerID == player.playerID {
                    cell.configureCell(player: player, stats: stats)
                }
            }
        } else {
            player = selectedInActiveRoster[indexPath.row]
            for stats in selectedRosterStats {
                if stats.playerID == player.playerID {
                    cell.configureCell(player: player, stats: stats)
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.selectedTeamTableView {
            enableStatTracking(indexPath: indexPath)
        }
        if tableView == self.selectedTeamBenchTableView {
            performSubstitution(indexPath: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        resetSelectedPlayer()
    }
    
    /* *******************************************************************************************************************
     // VIEW CONTROLLER - PERFORM FUNCTIONS
     ******************************************************************************************************************* */
    
    func nextPeriod() {
        periodTimer.invalidate()
        currentPeriodTimeInSeconds = Int(selectedGame.gamePeriodLength)! * 60
        isTimeout = true
        currentPeriod += 1
        let (minutes, seconds) = calMinutesSeconds(seconds: currentPeriodTimeInSeconds)
        displayTime(m: minutes, s: seconds)
    }
    
    func enableStatTracking(indexPath: IndexPath) {
        selectedPlayer = selectedActiveRoster[indexPath.row]
        statsButtonView.isHidden = false
        selectedPlayerStatsView.isHidden = false
        for stat in selectedRosterStats{
            displayIndividualStats(stat: stat)
        }
        selectedPlayerIndexPath = indexPath
        allowBenchSelection()
    }
    
    
    func performSubstitution(indexPath: IndexPath) {
        let temp = selectedActiveRoster[selectedPlayerIndexPath.row]
        deactivatePlayer(indexPath: indexPath)
        deactivatePlayerStats(temp: temp)
        activatePlayerStats(indexPath: indexPath)
        activatePlayer(indexPath: indexPath, temp: temp)
        resetSelectedPlayer()
        displayTrackerViews()
        reloadRosters()
        preventSelection()
    }
    
    func deactivatePlayer(indexPath: IndexPath){
        selectedActiveRoster.remove(at: selectedPlayerIndexPath.row)
        selectedActiveRoster.append(selectedInActiveRoster[indexPath.row])
    }
    
    func activatePlayer(indexPath: IndexPath, temp: Player) {
        selectedInActiveRoster.remove(at: indexPath.row)
        selectedInActiveRoster.append(temp)
    }
    
    func deactivatePlayerStats(temp: Player) {
        for stats in selectedRosterStats {
            if temp.playerID == stats.playerID {
                setPlayerToInactive(player: stats)
            }
        }
    }
    
    func activatePlayerStats(indexPath: IndexPath) {
        for stats in selectedRosterStats {
            if selectedInActiveRoster[indexPath.row].playerID == stats.playerID {
                setPlayerToActive(player: stats)
            }
        }
    }
    
    func resetSelectedPlayer() {
        selectedPlayer = Player()
        selectedPlayerIndexPath = IndexPath()
    }
    
    
    func createStatsDictionary(player: Stats) -> [String:Int] {
        let stats = ["playingTime": player.playingTimeInSeconds,
                     "madeOne": player.madeOnePoints,
                     "missOne": player.missedOnePoints,
                     "madeTwo": player.madeTwoPoints,
                     "missTwo": player.missedTwoPoints,
                     "madeThree": player.madeThreePoints,
                     "missThree": player.missedThreePoints,
                     "assists": player.assists,
                     "offRebounds": player.offRebounds,
                     "defRebounds": player.defRebounds,
                     "steals": player.steals,
                     "blocks": player.blocks,
                     "fouls": player.fouls,
                     "turnovers": player.turnovers]
        return stats
    }
    
    /* *******************************************************************************************************************
     // FIREBASE - QUERY FUNCTIONS
     ******************************************************************************************************************* */
    
    func getPlayers() {
        var starters = 0
        FIRDatabase.database().reference().child("players").child(selectedGame.gameSelectedTeam).observe(FIRDataEventType.childAdded, with: {(snapshot) in
            let player = Player()
            let playerStats = Stats()
            playerStats.playerID = snapshot.key
            player.playerID = snapshot.key
            player.playerFirstName = (snapshot.value as! NSDictionary)["playerFirstName"] as! String
            player.playerLastName = (snapshot.value as! NSDictionary)["playerLastName"] as! String
            player.playerNumber = (snapshot.value as! NSDictionary)["playerNumber"] as! String
            player.playerPosition = (snapshot.value as! NSDictionary)["playerPosition"] as! String
            player.playerTeam = self.selectedTeam.teamID
            self.setupStarters(player: player, playerStats: playerStats, starters: starters)
            starters += 1
        })
    }
    
    func setupStarters(player: Player, playerStats: Stats, starters: Int) {
        self.selectedRosterStats.append(playerStats)
        if starters < 5 {
            self.selectedActiveRoster.append(player)
        } else {
            self.selectedInActiveRoster.append(player)
            for stats in self.selectedRosterStats {
                if player.playerID == stats.playerID {
                    self.setPlayerToInactive(player: stats)
                }
            }
        }
        reloadRosters()
    }
    
    func uploadStats() {
        for player in selectedRosterStats {
            let stats = createStatsDictionary(player: player)
            FIRDatabase.database().reference().child("gameResults").child(selectedTeam.teamID).child(selectedGame.gameID).child(player.playerID).setValue(stats)
        }
        let opponentStats = createStatsDictionary(player: opponent)
        FIRDatabase.database().reference().child("gameResults").child(selectedTeam.teamID).child(selectedGame.gameID).child("opponent").setValue(opponentStats)
        
        FIRDatabase.database().reference().child("games").child(selectedTeam.teamID).child(selectedGame.gameID).child("gameStatus").setValue("complete")
        
        periodButton.setTitle("Successful", for: .normal)
        
        let homeScore = calSelectedTeamScore()
        let opponentScore = opponent.madeOnePoints + (opponent.madeTwoPoints * 2) + (opponent.madeThreePoints * 3)
        
        
        // CREATE ITS OWN FUNCTION LATER
        if opponentScore > homeScore {
            FIRDatabase.database().reference().child("games").child(selectedTeam.teamID).child(selectedGame.gameID).child("gameOutcome").setValue("lose")
        } else if opponentScore < homeScore {
            FIRDatabase.database().reference().child("games").child(selectedTeam.teamID).child(selectedGame.gameID).child("gameOutcome").setValue("win")
        } else {
            FIRDatabase.database().reference().child("games").child(selectedTeam.teamID).child(selectedGame.gameID).child("gameOutcome").setValue("tie")
        }
    }
    
    /* *******************************************************************************************************************
     // VIEW CONTROLLER - CALCULATE STATISTICS FUNCTIONS
    ******************************************************************************************************************* */
    
    func calMinutesSeconds (seconds: Int) -> (Int,Int) {
        return ((seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    func calSelectedTeamScore() -> (Int) {
        var score = 0
        for player in selectedRosterStats {
            score += player.madeOnePoints
            score += player.madeTwoPoints * 2
            score += player.madeThreePoints * 3
        }
        return score
    }
    
    func calSelectedTeamFieldGoal() -> (Double) {
        var made = 0.0
        var total = 0.0
        for player in selectedRosterStats {
            made += (Double(player.madeTwoPoints) + Double(player.madeThreePoints))
            total += (Double(player.madeTwoPoints) + Double(player.madeThreePoints) + Double(player.missedTwoPoints) + Double(player.missedThreePoints))
        }
        return Double(made) / Double(total)
    }
    
    func calSelectedTeamThreePoint() -> (Double) {
        var made = 0.0
        var total = 0.0
        for player in selectedRosterStats {
            made += Double(player.madeThreePoints)
            total += (Double(player.madeThreePoints) + Double(player.missedThreePoints))
        }
        return Double(made) / Double (total)
    }
    
    func calSelectedTeamFreeThrow() -> (Double) {
        var made = 0.0
        var total = 0.0
        for player in selectedRosterStats {
            made += Double(player.madeOnePoints)
            total += (Double(player.madeOnePoints) + Double(player.missedOnePoints))
        }
        return Double(made) / Double(total)
    }
    
    func calSelectedTeamAssists() -> (Int) {
        var assists = 0
        for player in selectedRosterStats {
            assists += player.assists
        }
        return assists
    }
    
    func calSelectedTeamRebounds() -> (Int) {
        var rebounds = 0
        for player in selectedRosterStats{
            rebounds += (player.defRebounds + player.offRebounds)
        }
        return rebounds
    }
    
    func calSelectedTeamBlocks() -> (Int) {
        var blocks = 0
        for player in selectedRosterStats{
            blocks += player.blocks
        }
        return blocks
    }
    
    func calSelectedTeamSteals() -> (Int) {
        var steals = 0
        for player in selectedRosterStats{
            steals += player.steals
        }
        return steals
    }
    
    func calSelectedTeamFouls() -> (Int) {
        var fouls = 0
        for player in selectedRosterStats{
            fouls += player.fouls
        }
        return fouls
    }
    
    func calSelectedTeamTurnovers() -> (Int) {
        var turnovers = 0
        for player in selectedRosterStats{
            turnovers += player.turnovers
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
        return fieldGoalCal
    }
    
    func calFreeThrow(stat: Stats) -> (Double) {
        let total = stat.madeOnePoints + stat.missedOnePoints
        let freeThrowCal : Double = Double(stat.madeOnePoints) / Double(total)
        return freeThrowCal
    }
    
    func calRebounds(stat: Stats) -> (Int) {
        return stat.offRebounds + stat.defRebounds
    }
    
    /* *******************************************************************************************************************
     // VIEW CONTROLLER - DISPLAY STATISTICS FUNCTIONS
     ******************************************************************************************************************* */
    
    func preventSelection() {
        selectedTeamTableView.deselectRow(at: selectedPlayerIndexPath, animated: true)
        selectedTeamBenchTableView.allowsSelection = false
    }
    
    func hideTrackerViews() {
        statsButtonView.isHidden = true
        selectedPlayerStatsView.isHidden = true
    }
    
    func displayCurrentPeriod() {
        if selectedGame.gameNumPeriods == "4" {
            currentPeriodLabel.text = "Q\(currentPeriod)"
        } else {
            currentPeriodLabel.text = "H\(currentPeriod)"
        }
    }
    
    func displayPeriodTime() {
        currentPeriodTimeInSeconds -= 1
        addPlayingTime()
        let (minutes, seconds) = calMinutesSeconds(seconds: currentPeriodTimeInSeconds)
        displayTime(m: minutes, s: seconds)
        selectedTeamTableView.reloadData()
        if currentPeriodTimeInSeconds == 0 {
            nextPeriod()
        }
        if currentPeriod > Int(selectedGame.gameNumPeriods)! {
            periodButton.setTitle("Upload", for: .normal)
            currentPeriodLabel.text = "Game Complete"
        } else {
            displayCurrentPeriod()
        }
    }
    
    func displayTime(m: Int, s: Int) {
        if s < 10 {
            timeButton.setTitle("\(m) : 0\(s)", for: .normal)
        } else {
            timeButton.setTitle("\(m) : \(s)", for: .normal)
        }
    }
    
    func displayTrackerViews() {
        statsButtonView.isHidden = true
        selectedPlayerStatsView.isHidden = true
    }
    
    
    func displayTeamScore() {
        selectedTeamScoreLabel.text = "\(calSelectedTeamScore())"
        opponentTeamScoreLabel.text = "\(opponent.madeOnePoints + (opponent.madeTwoPoints * 2) + (opponent.madeThreePoints * 3))"
    }
    
    func displayTeamFieldGoal() {
        var selectedFieldGoalCal : Double = Double(calSelectedTeamFieldGoal())
        var opponentFieldGoalCal : Double = Double(opponent.madeTwoPoints + opponent.madeThreePoints) / Double(opponent.madeTwoPoints + opponent.madeThreePoints + opponent.missedTwoPoints + opponent.missedThreePoints)
        
        selectedTeamFieldGoalLabel.text = checkIfNaN(calculatedPercentage: selectedFieldGoalCal)
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
        var opponentThreePointCal : Double = Double(opponent.madeThreePoints) / Double(opponent.madeThreePoints + opponent.missedThreePoints)
        
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
        var selectedFreeThrowCal = calSelectedTeamFreeThrow()
        var opponentFreeThrowCal : Double = Double(opponent.madeOnePoints) / Double(opponent.madeOnePoints + opponent.missedOnePoints)
        
        selectedTeamFreeThrowLabel.text = checkIfNaN(calculatedPercentage: selectedFreeThrowCal)
        
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
        let opponentAssistCal : Int = opponent.assists
        
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
        let opponentReboundCal : Int = opponent.defRebounds + opponent.offRebounds
        
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
    
    func displayTeamBlocks() {
        let selectedBlockCal : Int = calSelectedTeamBlocks()
        let opponentBlockCal : Int = opponent.blocks
        
        selectedTeamBlocksLabel.text = "\(selectedBlockCal)"
        opponentTeamBlocksLabel.text = "\(opponentBlockCal)"
        
        UIView.animate(withDuration: 0.5,
                       delay: 0.1,
                       options: UIViewAnimationOptions.beginFromCurrentState,
                       animations: { () -> Void in
                        // adjust bars
                        self.selectedTeamBlkBar.adjustSize(currentValue: Double(selectedBlockCal), max: 50)
                        self.opponentTeamBlkBar.adjustSize(currentValue: Double(opponentBlockCal), max: 50)
                        
                        //adjust labels
                        self.selectedTeamBlocksLabel.adjustPosition(currentValue: Double(selectedBlockCal), max: 50, leftBarOrigin: self.selectedTeamBlkBar.frame.origin)
                        self.opponentTeamBlocksLabel.adjustPosition(currentValue: Double(opponentBlockCal), max: 50, rightBarOrigin: self.opponentTeamBlkBar.frame.origin)
        }, completion: { (finished) -> Void in
            
        })
    }
    
    func displayTeamSteals() {
        let selectedStealCal : Int = calSelectedTeamSteals()
        let opponentStealCal : Int = opponent.steals
        
        selectedTeamStealsLabel.text = "\(selectedStealCal)"
        opponentTeamStealsLabel.text = "\(opponentStealCal)"
        
        UIView.animate(withDuration: 0.5,
                       delay: 0.1,
                       options: UIViewAnimationOptions.beginFromCurrentState,
                       animations: { () -> Void in
                        // adjust bars
                        self.selectedTeamStlBar.adjustSize(currentValue: Double(selectedStealCal), max: 50)
                        self.opponentTeamStlBar.adjustSize(currentValue: Double(opponentStealCal), max: 50)
                        
                        //adjust labels
                        self.selectedTeamStealsLabel.adjustPosition(currentValue: Double(selectedStealCal), max: 50, leftBarOrigin: self.selectedTeamStlBar.frame.origin)
                        self.opponentTeamStealsLabel.adjustPosition(currentValue: Double(opponentStealCal), max: 50, rightBarOrigin: self.opponentTeamStlBar.frame.origin)
        }, completion: { (finished) -> Void in
            
        })
    }

    
    func displayTeamTurnovers() {
        let selectedTurnoverCal : Int = calSelectedTeamTurnovers()
        let opponentTurnoverCal : Int = opponent.turnovers
        
        selectedTeamTurnoversLabel.text = "\(selectedTurnoverCal)"
        opponentTeamTurnoversLabel.text = "\(opponentTurnoverCal)"
        
        UIView.animate(withDuration: 0.5,
                       delay: 0.1,
                       options: UIViewAnimationOptions.beginFromCurrentState,
                       animations: { () -> Void in
                        // adjust bars
                        self.selectedTeamTOBar.adjustSize(currentValue: Double(selectedTurnoverCal), max: 50)
                        self.opponentTeamTOBar.adjustSize(currentValue: Double(opponentTurnoverCal), max: 50)
                        
                        //adjust labels
                        self.selectedTeamTurnoversLabel.adjustPosition(currentValue: Double(selectedTurnoverCal), max: 50, leftBarOrigin: self.selectedTeamTOBar.frame.origin)
                        self.opponentTeamTurnoversLabel.adjustPosition(currentValue: Double(opponentTurnoverCal), max: 50, rightBarOrigin: self.opponentTeamTOBar.frame.origin)
        }, completion: { (finished) -> Void in
            
        })
    }
    
    func displayPlayerDetails() {
        playerNameLabel.text = "#\(selectedPlayer.playerNumber) \(selectedPlayer.playerFirstName) \(selectedPlayer.playerLastName)"
    }
    
    func displayPlayerMinutes(stat: Stats) {
        let (m,s) = calMinutesSeconds(seconds: stat.playingTimeInSeconds)
        if s < 10  {
            playerMinutesLabel.text = "\(m):0\(s)"
        } else {
            playerMinutesLabel.text = "\(m):\(s)"
        }
    }
    
    func displayPlayerPoints(stat: Stats) {
        let points = calPoints(stat: stat)
        playerPointsLabel.text = "\(points)"
    }
    
    func displayPlayerFieldGoal(stat: Stats) {
        let fieldGoal = calFieldGoal(stat: stat)
        playerPercentageLabel.text = checkIfNaN(calculatedPercentage: fieldGoal)
    }
    
    func displayPlayerFreeThrow(stat: Stats) {
        let freeThrow = calFreeThrow(stat: stat)
        playerFreeThrowPercentLabe.text = checkIfNaN(calculatedPercentage: freeThrow)
    }
    
    func displayPlayerAssists(stat: Stats) {
        playerAssistLabel.text = "\(stat.assists)"
    }
    
    func displayPlayerRebounds(stat: Stats) {
        let rebounds = calRebounds(stat: stat)
        playerReboundLabel.text = "\(rebounds)"
    }
    
    func displayPlayerSteals(stat: Stats) {
        playerStealsLabel.text = "\(stat.steals)"
    }
    
    func displayPlayerBlocks(stat: Stats) {
        playerBlocksLabel.text = "\(stat.blocks)"
    }
    
    func displayPlayerTurnovers(stat: Stats) {
        playerTurnoverLabel.text = "\(stat.turnovers)"
    }
    
    func displayPlayerFouls(stat: Stats) {
        playerFoulsLabel.text = "\(stat.fouls)"
    }
    
    func displayIndividualStats(stat: Stats) {
        if isPlayerSame(stat: stat) {
            displayPlayerDetails()
            displayPlayerMinutes(stat: stat)
            displayPlayerPoints(stat: stat)
            displayPlayerFieldGoal(stat: stat)
            displayPlayerFreeThrow(stat: stat)
            displayPlayerAssists(stat: stat)
            displayPlayerRebounds(stat: stat)
            displayPlayerBlocks(stat: stat)
            displayPlayerSteals(stat: stat)
            displayPlayerTurnovers(stat: stat)
            displayPlayerFouls(stat: stat)
        }
    }
    
    func reloadRosters() {
        self.selectedTeamTableView.reloadData()
        self.selectedTeamBenchTableView.reloadData()
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
    
    @IBAction func opponentButtonTapped(_ sender: Any) {
        selectOpponentButton()
        statsButtonView.isHidden = false
    }
    
    @IBAction func timerTapped(_ sender: Any) {
        if isTimeout == true {
            periodTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.displayPeriodTime), userInfo: nil, repeats: true)
            isTimeout = false
        } else {
            periodTimer.invalidate()
            isTimeout = true
        }
    }
    
    @IBAction func nextPeriodTapped(_ sender: Any) {
        if periodButton.titleLabel?.text == "Upload" {
            uploadStats()
        } else {
            nextPeriod()
        }
    }
    
    @IBAction func madeOneTapped(_ sender: Any) {
        if opponentSelected() {
            addMadeOne(stat: opponent)
            deselectOpponentButton()
        } else {
            for stat in selectedRosterStats{
                if isPlayerSame(stat: stat) {
                    addMadeOne(stat: stat)
                }
            }
        }
        hideTrackerViews()
        displayTeamScore()
        displayTeamFreeThrow()
        preventSelection()
    }
    
    @IBAction func madeTwoTapped(_ sender: Any) {
        if opponentSelected() {
            addMadeTwo(stat: opponent)
            deselectOpponentButton()
        } else {
            for stat in selectedRosterStats{
                if isPlayerSame(stat: stat) {
                    addMadeTwo(stat: stat)
                }
            }
        }
        hideTrackerViews()
        displayTeamScore()
        displayTeamFieldGoal()
        preventSelection()
    }
    
    @IBAction func madeThreeTapped(_ sender: Any) {
        if opponentSelected() {
            addMadeThree(stat: opponent)
            deselectOpponentButton()
        } else {
            for stat in selectedRosterStats{
                if isPlayerSame(stat: stat) {
                    addMadeThree(stat: stat)
                }
            }
        }
        hideTrackerViews()
        displayTeamScore()
        displayTeamFieldGoal()
        displayTeamThreePoint()
        preventSelection()
    }
    
    @IBAction func missOneTapped(_ sender: Any) {
        if opponentSelected() {
            addMissOne(stat: opponent)
            deselectOpponentButton()
        } else {
            for stat in selectedRosterStats{
                if isPlayerSame(stat: stat) {
                    addMissOne(stat: stat)
                }
            }
        }
        hideTrackerViews()
        displayTeamFieldGoal()
        displayTeamFreeThrow()
        preventSelection()
    }
    
    @IBAction func missTwotapped(_ sender: Any) {
        if opponentSelected() {
            addMissTwo(stat: opponent)
            deselectOpponentButton()
        } else {
            for stat in selectedRosterStats{
                if isPlayerSame(stat: stat) {
                    addMissTwo(stat: stat)
                }
            }
        }
        hideTrackerViews()
        displayTeamFieldGoal()
        preventSelection()
    }
    
    @IBAction func missThreeTapped(_ sender: Any) {
        if opponentSelected() {
            addMissThree(stat: opponent)
            deselectOpponentButton()
        } else {
            for stat in selectedRosterStats{
                if isPlayerSame(stat: stat) {
                    addMissThree(stat: stat)
                }
            }
        }
        hideTrackerViews()
        displayTeamFieldGoal()
        displayTeamThreePoint()
        preventSelection()
    }
    
    @IBAction func offReboundTapped(_ sender: Any) {
        if opponentSelected() {
            addOffRebound(stat: opponent)
            deselectOpponentButton()
        } else {
            for stat in selectedRosterStats{
                if isPlayerSame(stat: stat) {
                    addOffRebound(stat: stat)
                }
            }
        }
        hideTrackerViews()
        displayTeamRebounds()
        preventSelection()
    }
    
    @IBAction func defReboundTapped(_ sender: Any) {
        if opponentSelected() {
            addDefRebound(stat: opponent)
            deselectOpponentButton()
        } else {
            for stat in selectedRosterStats{
                if isPlayerSame(stat: stat) {
                    addDefRebound(stat: stat)
                }
            }
        }
        hideTrackerViews()
        displayTeamRebounds()
        preventSelection()
    }
    
    @IBAction func assistTapped(_ sender: Any) {
        if opponentSelected() {
            addAssist(stat: opponent)
            deselectOpponentButton()
        } else {
            for stat in selectedRosterStats{
                if isPlayerSame(stat: stat) {
                    addAssist(stat: stat)
                }
            }
        }
        hideTrackerViews()
        displayTeamAssists()
        preventSelection()
    }
    
    @IBAction func blockTapped(_ sender: Any) {
        if opponentSelected() {
            addBlock(stat: opponent)
            deselectOpponentButton()
        } else {
            for stat in selectedRosterStats{
                if isPlayerSame(stat: stat) {
                    addBlock(stat: stat)
                }
            }
        }
        hideTrackerViews()
        displayTeamBlocks()
        preventSelection()
    }
    
    @IBAction func stealTapped(_ sender: Any) {
        if opponentSelected() {
            addSteal(stat: opponent)
            deselectOpponentButton()
        } else {
            for stat in selectedRosterStats{
                if isPlayerSame(stat: stat) {
                    addSteal(stat: stat)
                }
            }
        }
        hideTrackerViews()
        displayTeamSteals()
        preventSelection()
    }
    
    @IBAction func turnoverTapped(_ sender: Any) {
        if opponentSelected() {
            addTurnover(stat: opponent)
            deselectOpponentButton()
        } else {
            for stat in selectedRosterStats{
                if isPlayerSame(stat: stat) {
                    addTurnover(stat: stat)
                }
            }
        }
        hideTrackerViews()
        displayTeamTurnovers()
        preventSelection()
    }
    
    @IBAction func foulTapped(_ sender: Any) {
        if opponentSelected() {
            addFoul(stat: opponent)
            deselectOpponentButton()
        } else {
            for stat in selectedRosterStats{
                if isPlayerSame(stat: stat) {
                    addFoul(stat: stat)
                }
            }
        }
        hideTrackerViews()
        //displayTeamFouls()
        preventSelection()
    }
    
    @IBAction func fixTapped(_ sender: Any) {
        //NEED TO DO
    }
    
    /* *******************************************************************************************************************
     // VIEW CONTROLLER - SETTER FUNCTIONS
     ******************************************************************************************************************* */
    
    func allowBenchSelection() {
        selectedTeamBenchTableView.allowsSelection = true
    }
    
    func preventBenchSelection() {
        selectedTeamBenchTableView.allowsSelection = false
    }
    
    func selectOpponentButton() {
        opponentButtonSelected = true
    }
    
    func deselectOpponentButton() {
        opponentButtonSelected = false
    }
    
    func setPlayerToActive(player: Stats) {
        player.isActive = true
    }
    
    func setPlayerToInactive(player: Stats) {
        player.isActive = false
    }
    
    func addFoul(stat: Stats) {
        stat.fouls += 1
    }
    
    func addTurnover(stat: Stats) {
        stat.turnovers += 1
    }
    
    func addSteal(stat: Stats) {
        stat.steals += 1
    }
    
    func addBlock(stat: Stats) {
        stat.blocks += 1
    }
    
    func addAssist(stat: Stats) {
        stat.assists += 1
    }
    
    func addDefRebound(stat: Stats) {
        stat.defRebounds += 1
    }
    
    func addOffRebound(stat: Stats) {
        stat.offRebounds += 1
    }
    
    func addMadeOne(stat: Stats) {
        stat.madeOnePoints += 1
    }
    
    func addMadeTwo(stat: Stats) {
        stat.madeTwoPoints += 1
    }
    
    func addMadeThree(stat: Stats) {
        stat.madeThreePoints += 1
    }
    
    func addMissOne(stat: Stats) {
        stat.missedOnePoints += 1
    }
    
    func addMissTwo(stat: Stats) {
        stat.missedTwoPoints += 1
    }
    
    func addMissThree(stat: Stats) {
        stat.missedThreePoints += 1
    }
    
    func addPlayingTime() {
        for stats in selectedRosterStats {
            if stats.isActive == true {
                stats.playingTimeInSeconds += 1
            }
        }
    }
    
    /* *******************************************************************************************************************
     // VIEW CONTROLLER - CONDITION FUNCTIONS
     ******************************************************************************************************************* */
    
    func isPlayerSame(stat: Stats) -> (Bool){
        return selectedPlayer.playerID == stat.playerID
    }
    
    func opponentSelected() -> (Bool){
        return opponentButtonSelected
    }
}
