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
    
    func nextPeriod() {
        periodTimer.invalidate()
        currentPeriodTimeInSeconds = Int(selectedGame.gamePeriodLength)! * 60
        isTimeout = true
        currentPeriod += 1
        let (minutes, seconds) = calMinutesSeconds(seconds: currentPeriodTimeInSeconds)
        displayTime(m: minutes, s: seconds)
    }
    
    /* *******************************************************************************************************************
     // FIREBASE - RETRIEVE QUERY FUNCTIONS
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
        let fieldGoal : Double = Double(made) / Double(total)
        return Double(round(fieldGoal * 1000)/1000) * 100
    }
    
    func calSelectedTeamFreeThrow() -> (Double) {
        var made = 0.0
        var total = 0.0
        for player in selectedRosterStats {
            made += Double(player.madeOnePoints)
            total += (Double(player.madeOnePoints) + Double(player.missedOnePoints))
        }
        let freeThrow : Double = Double(made) / Double(total)
        return Double(round(freeThrow * 1000)/1000) * 100
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
        if currentPeriodTimeInSeconds == 0 {
            nextPeriod()
        }
        if currentPeriod > Int(selectedGame.gameNumPeriods)! {
            // GAME FINISHED
            // pass values to next screen
            // on next screen, upload values
        }
        displayCurrentPeriod()
    }
    
    func displayTime(m: Int, s: Int) {
        if s < 10 {
            timeButton.setTitle("\(m) : 0\(s)", for: .normal)
        } else {
            timeButton.setTitle("\(m) : \(s)", for: .normal)
        }
    }
    
    func preventSelection() {
        selectedTeamTableView.deselectRow(at: selectedPlayerIndexPath, animated: true)
        selectedTeamBenchTableView.allowsSelection = false
    }
    
    func hideTrackerViews() {
        statsButtonView.isHidden = true
        selectedPlayerStatsView.isHidden = true
    }
    
    func displayTrackerViews() {
        statsButtonView.isHidden = true
        selectedPlayerStatsView.isHidden = true
    }
    
    func reloadRosters() {
        self.selectedTeamTableView.reloadData()
        self.selectedTeamBenchTableView.reloadData()
    }
    
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
    
    func displayPlayerDetails() {
        playerNameLabel.text = "#\(selectedPlayer.playerNumber) \(selectedPlayer.playerFirstName) \(selectedPlayer.playerLastName)"
    }
    
    func displayPlayerPoints(stat: Stats) {
        let points = calPoints(stat: stat)
        playerPointsLabel.text = "\(points)"
    }
    
    func displayPlayerFieldGoal(stat: Stats) {
        let fieldGoal = calFieldGoal(stat: stat)
        if fieldGoal.isNaN == true {
            playerPercentageLabel.text = "0.0"
        } else {
            playerPercentageLabel.text = "\(fieldGoal)"
        }
    }
    
    func displayPlayerFreeThrow(stat: Stats) {
        let freeThrow = calFreeThrow(stat: stat)
        if freeThrow.isNaN == true {
            playerFreeThrowPercentLabe.text = "0.0"
        } else {
            playerFreeThrowPercentLabe.text = "\(freeThrow)"
        }
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
    
    func displayPlayerMinutes(stat: Stats) {
        let (m,s) = calMinutesSeconds(seconds: stat.playingTimeInSeconds)
        if s < 10  {
            playerMinutesLabel.text = "\(m):0\(s)"
        } else {
            playerMinutesLabel.text = "\(m):\(s)"
        }
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
            displayPlayerTurnovers(stat: stat)
            displayPlayerFouls(stat: stat)
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
        nextPeriod()
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
        displayTeamFouls()
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
