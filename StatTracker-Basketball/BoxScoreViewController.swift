//
//  BoxScoreViewController.swift
//  StatTracker-Basketball
//
//  Created by Ray Paragas on 13/2/17.
//  Copyright © 2017 Ray Paragas. All rights reserved.
//

//
//  BoxScoreCollectionViewController.swift
//  StatTracker-Basketball
//
//  Created by Ray Paragas on 30/1/17.
//  Copyright © 2017 Ray Paragas. All rights reserved.
//

import UIKit

private let reuseIdentifier = "customCell"

class BoxScoreViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    /* *******************************************************************************************************************
     // VIEW CONTROLLER - TABLEVIEW FUNCTIONS
     ******************************************************************************************************************* */
    
    @IBOutlet weak var boxScoreCollection: UICollectionView!
    @IBOutlet weak var boxScoreView: CustomBoxScoreView!
    
    /* *******************************************************************************************************************
     // VIEW CONTROLLER - TABLEVIEW FUNCTIONS
     ******************************************************************************************************************* */
    
    @IBOutlet weak var pointsLeaderStatLabel: UILabel!
    @IBOutlet weak var assistsLeaderStatLabel: UILabel!
    @IBOutlet weak var reboundsLeaderStatLabel: UILabel!
    @IBOutlet weak var blocksLeaderStatLabel: UILabel!
    @IBOutlet weak var stealsLeaderStatLabel: UILabel!
    
    /* *******************************************************************************************************************
     // VIEW CONTROLLER - TABLEVIEW FUNCTIONS
     ******************************************************************************************************************* */
    
    @IBOutlet weak var pointsLeaderNumberLabel: UILabel!
    @IBOutlet weak var assistsLeaderNumberLabel: UILabel!
    @IBOutlet weak var reboundsLeaderNumberLabel: UILabel!
    @IBOutlet weak var blocksLeaderNumberLabel: UILabel!
    @IBOutlet weak var stealsLeaderNumberLabel: UILabel!
    
    /* *******************************************************************************************************************
     // VIEW CONTROLLER - TABLEVIEW FUNCTIONS
     ******************************************************************************************************************* */
    
    @IBOutlet weak var pointsLeaderNameLabel: UILabel!
    @IBOutlet weak var assistsLeaderNameLabel: UILabel!
    @IBOutlet weak var reboundsLeaderNameLabel: UILabel!
    @IBOutlet weak var blocksLeaderNameLabel: UILabel!
    @IBOutlet weak var stealsLeaderNameLabel: UILabel!
    
    var selectedTeam = Team()
    var roster = [Player]()
    var stats = [Stats]()
    var oppStats = Stats()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        boxScoreCollection.collectionViewLayout = CustomBoxScoreCollectionViewLayout()
        boxScoreCollection.delegate = self
        boxScoreCollection.dataSource = self
        calculateLeaders()
        //boxScoreCollection = self
        self.edgesForExtendedLayout = UIRectEdge.bottom
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        let sections = roster.count + 3
        return sections
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 21
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customCell", for: indexPath) as! CustomBoxScoreCollectionViewCell
        if indexPath.section == 0 {
            cell.setHeader()
            cell.label.text = createHeaderString(indexPath: indexPath)
        } else if indexPath.section == (roster.count+1) {
            //FIND BETTER WAY TO DO ABOVE
            cell.setBar()
            if indexPath.item == 0 {
                cell.setTotal()
            }
            cell.label.text = createTotalString(indexPath: indexPath)
        } else if indexPath.section == (roster.count+2) {
            //FIND BETTER WAY TO DO ABOVE
            cell.setBar()
            if indexPath.item == 0 {
                cell.setOpponent()
            }
            cell.label.text = createOpponentString(indexPath: indexPath)
        } else {
            if indexPath.item == 0 {
                cell.setBar()
                cell.label.text = createStatString(indexPath: indexPath)
            } else {
                cell.setBody()
                cell.label.text = createStatString(indexPath: indexPath)
                //print("section:\(indexPath.section),item:\(indexPath.item) - \(cell.backgroundColor!)")
            }
        }
        cell.label.sizeToFit()
        return cell
    }
    
    func createHeaderString(indexPath: IndexPath) -> String {
        var string = ""
        switch indexPath.item {
        case 0:
            string = "Player"
            break
        case 1:
            string = "MIN"
            break
        case 2:
            string = "PTS"
            break
        case 3:
            string = "REB"
            break
        case 4:
            string = "AST"
            break
        case 5:
            string = "STL"
            break
        case 6:
            string = "BLK"
            break
        case 7:
            string = "FGM"
            break
        case 8:
            string = "FGA"
            break
        case 9:
            string = "FG%"
            break
        case 10:
            string = "3PM"
            break
        case 11:
            string = "3PA"
            break
        case 12:
            string = "3P%"
            break
        case 13:
            string = "FTM"
            break
        case 14:
            string = "FTA"
            break
        case 15:
            string = "FT%"
            break
        case 16:
            string = "OREB"
            break
        case 17:
            string = "DREB"
            break
        case 18:
            string = "TOV"
            break
        case 19:
            string = "PF"
            break
        default: break
        }
        return string
    }
    
    func createOpponentString(indexPath: IndexPath) -> String {
        var string = ""
        var total = 0
            switch indexPath.item {
            case 2:
                total += calPoints(stat: oppStats)
                break
            case 3:
                total += calRebounds(stat: oppStats)
                break
            case 4:
                total += calAssist(stat: oppStats)
                break
            case 5:
                total += calSteals(stat: oppStats)
                break
            case 6:
                total += calBlocks(stat: oppStats)
                break
            case 7:
                total += calFGMade(stat: oppStats)
                break
            case 8:
                total += calFGAttempted(stat: oppStats)
                break
            case 9:
                string = checkIfNaN(calculatedPercentage: calFGPercent(stat: oppStats))
                break
            case 10:
                total += cal3PMade(stat: oppStats)
                break
            case 11:
                total += cal3PAttempted(stat: oppStats)
                break
            case 12:
                string = checkIfNaN(calculatedPercentage: cal3PPercent(stat: oppStats))
                break
            case 13:
                total += calFTMade(stat: oppStats)
                break
            case 14:
                total += calFTAttempted(stat: oppStats)
                break
            case 15:
                string = checkIfNaN(calculatedPercentage: calFTPercent(stat: oppStats))
                break
            case 16:
                total += calOffRebounds(stat: oppStats)
                break
            case 17:
                total += calDefRebounds(stat: oppStats)
                break
            case 18:
                total += calTurnovers(stat: oppStats)
                break
            case 19:
                total += calFouls(stat: oppStats)
                break
            default: break
            }
        if indexPath.item == 0 {
            string = "Opponent"
        } else if indexPath.item == 1 {
            let (minutes,seconds) = calTeamMinutes()
            if seconds < 10 {
                string = "\(minutes):0\(seconds)"
            } else {
                string = "\(minutes):\(seconds)"
            }
        } else if indexPath.item == 9{
            string = checkIfNaN(calculatedPercentage: calOppFGPercent())
        } else if indexPath.item == 12{
            string = checkIfNaN(calculatedPercentage: calOpp3PPercent())
        } else if indexPath.item == 15{
            string = checkIfNaN(calculatedPercentage: calOppFTPercent())
        } else {
            string = "\(total)"
        }
        return string
    }

    func createTotalString(indexPath: IndexPath) -> String {
        var string = ""
        var total = 0
        for stat in stats {
            switch indexPath.item {
            case 2:
                total += calPoints(stat: stat)
                break
            case 3:
                total += calRebounds(stat: stat)
                break
            case 4:
                total += calAssist(stat: stat)
                break
            case 5:
                total += calSteals(stat: stat)
                break
            case 6:
                total += calBlocks(stat: stat)
                break
            case 7:
                total += calFGMade(stat: stat)
                break
            case 8:
                total += calFGAttempted(stat: stat)
                break
            case 9:
                string = checkIfNaN(calculatedPercentage: calFGPercent(stat: stat))
                break
            case 10:
                total += cal3PMade(stat: stat)
                break
            case 11:
                total += cal3PAttempted(stat: stat)
                break
            case 12:
                string = checkIfNaN(calculatedPercentage: cal3PPercent(stat: stat))
                break
            case 13:
                total += calFTMade(stat: stat)
                break
            case 14:
                total += calFTAttempted(stat: stat)
                break
            case 15:
                string = checkIfNaN(calculatedPercentage: calFTPercent(stat: stat))
                break
            case 16:
                total += calOffRebounds(stat: stat)
                break
            case 17:
                total += calDefRebounds(stat: stat)
                break
            case 18:
                total += calTurnovers(stat: stat)
                break
            case 19:
                total += calFouls(stat: stat)
                break
            default: break
            }
        }
        if indexPath.item == 0 {
            string = "Total"
        } else if indexPath.item == 1 {
            let (minutes,seconds) = calTeamMinutes()
            if seconds < 10 {
                string = "\(minutes):0\(seconds)"
            } else {
                string = "\(minutes):\(seconds)"
            }
        } else if indexPath.item == 9{
            string = checkIfNaN(calculatedPercentage: calTeamFGPercent())
        } else if indexPath.item == 12{
            string = checkIfNaN(calculatedPercentage: calTeam3PPercent())
        } else if indexPath.item == 15{
            string = checkIfNaN(calculatedPercentage: calTeamFTPercent())
        } else {
            string = "\(total)"
        }
        return string
    }
    
    func createStatString(indexPath: IndexPath) -> String {
        var string = ""
        for stat in stats {
            if stat.playerID == roster[indexPath.section-1].playerID {
                switch indexPath.item {
                case 0:
                    string = createPlayerString(indexPath: indexPath)
                    break
                case 1:
                    let (minutes,seconds) = calMinutes(stat: stat)
                    if seconds < 10 {
                        string = "\(minutes):0\(seconds)"
                    } else {
                        string = "\(minutes):\(seconds)"
                    }
                    break
                case 2:
                    string = "\(calPoints(stat: stat))"
                    break
                case 3:
                    string = "\(calRebounds(stat: stat))"
                    break
                case 4:
                    string = "\(calAssist(stat: stat))"
                    break
                case 5:
                    string = "\(calSteals(stat: stat))"
                    break
                case 6:
                    string = "\(calBlocks(stat: stat))"
                    break
                case 7:
                    string = "\(calFGMade(stat: stat))"
                    break
                case 8:
                    string = "\(calFGAttempted(stat: stat))"
                    break
                case 9:
                    string = checkIfNaN(calculatedPercentage: calFGPercent(stat: stat))
                    break
                case 10:
                    string = "\(cal3PMade(stat: stat))"
                    break
                case 11:
                    string = "\(cal3PAttempted(stat: stat))"
                    break
                case 12:
                    string = checkIfNaN(calculatedPercentage: cal3PPercent(stat: stat))
                    break
                case 13:
                    string = "\(calFTMade(stat: stat))"
                    break
                case 14:
                    string = "\(calFTAttempted(stat: stat))"
                    break
                case 15:
                    string = checkIfNaN(calculatedPercentage: calFTPercent(stat: stat))
                    break
                case 16:
                    string = "\(calOffRebounds(stat: stat))"
                    break
                case 17:
                    string = "\(calDefRebounds(stat: stat))"
                    break
                case 18:
                    string = "\(calTurnovers(stat: stat))"
                    break
                case 19:
                    string = "\(calFouls(stat: stat))"
                    break
                default: break
                }
            }
        }
        return string
    }
    
    func calTeamMinutes() -> (Int,Int) {
        var totalSeconds = 0
        for stat in stats {
            totalSeconds += stat.playingTimeInSeconds
        }
        return ((totalSeconds % 3600) / 60,(totalSeconds % 3600) % 60)
    }
    
    func calTeamFGPercent() -> Double {
        var made = 0
        var total = 0
        for stat in stats {
            made += stat.madeTwoPoints + stat.madeThreePoints
            total += stat.madeTwoPoints + stat.madeThreePoints + stat.missedTwoPoints + stat.missedThreePoints
        }
        return Double(made) / Double(total)
    }
    
    func calTeam3PPercent() -> Double {
        var made = 0
        var total = 0
        for stat in stats {
            made += stat.madeThreePoints
            total += stat.madeThreePoints + stat.missedThreePoints
        }
        return Double(made) / Double(total)
    }
    
    func calTeamFTPercent() -> Double {
        var made = 0
        var total = 0
        for stat in stats {
            made += stat.madeOnePoints
            total += stat.madeOnePoints + stat.missedOnePoints
        }
        return Double(made) / Double(total)
    }
    
    func calOppFGPercent() -> Double {
        let made = oppStats.madeTwoPoints + oppStats.madeThreePoints
        let total = oppStats.madeTwoPoints + oppStats.madeThreePoints + oppStats.missedTwoPoints + oppStats.missedThreePoints
        return Double(made) / Double(total)
    }
    
    func calOpp3PPercent() -> Double {
        let made = oppStats.madeThreePoints
        let total = oppStats.madeThreePoints + oppStats.missedThreePoints
        return Double(made) / Double(total)
    }
    
    func calOppFTPercent() -> Double {
        let made = oppStats.madeOnePoints
        let total = oppStats.madeOnePoints + oppStats.missedOnePoints
        return Double(made) / Double(total)
    }
    
    func createPlayerString(indexPath: IndexPath) -> String {
        return "#\(roster[indexPath.section-1].playerNumber) - \(roster[indexPath.section-1].playerFirstName) \(roster[indexPath.section-1].playerLastName)"
    }
    
    func calMinutes(stat: Stats) -> (Int,Int) {
        return ((stat.playingTimeInSeconds % 3600) / 60,(stat.playingTimeInSeconds % 3600) % 60)
    }
    
    func calPoints(stat: Stats) -> Int {
        return stat.madeOnePoints + stat.madeTwoPoints * 2 + stat.madeThreePoints * 3
    }
    
    func calRebounds(stat: Stats) -> Int {
        return stat.offRebounds + stat.defRebounds
    }
    
    func calAssist(stat: Stats) -> Int {
        return stat.assists
    }
    
    func calSteals(stat: Stats) -> Int {
        return stat.steals
    }
    
    func calBlocks(stat: Stats) -> Int {
        return stat.blocks
    }
    
    func calFGMade(stat: Stats) -> Int {
        return stat.madeTwoPoints + stat.madeThreePoints
    }
    
    func calFGAttempted(stat: Stats) -> Int {
        return stat.madeTwoPoints + stat.madeThreePoints + stat.missedTwoPoints + stat.missedThreePoints
    }
    
    func calFGPercent(stat: Stats) -> Double {
        let calculatedPercentage : Double = Double(stat.madeTwoPoints + stat.madeThreePoints) / Double(stat.madeTwoPoints + stat.madeThreePoints + stat.missedTwoPoints + stat.missedThreePoints)
        return calculatedPercentage
    }
    
    func cal3PMade(stat: Stats) -> Int {
        return stat.madeThreePoints
    }
    
    func cal3PAttempted(stat: Stats) -> Int {
        return stat.madeThreePoints + stat.missedThreePoints
    }
    
    func cal3PPercent(stat: Stats) -> Double {
        let calculatedPercentage : Double = Double(stat.madeThreePoints) / Double(stat.madeThreePoints + stat.missedThreePoints)
        return calculatedPercentage
    }
    
    func calFTMade(stat: Stats) -> Int {
        return stat.madeOnePoints
    }
    
    func calFTAttempted(stat: Stats) -> Int {
        return stat.madeOnePoints + stat.missedOnePoints
    }
    
    func calFTPercent(stat: Stats) -> Double {
        let calculatedPercentage : Double = Double(stat.madeOnePoints) / Double(stat.madeOnePoints + stat.missedOnePoints)
        return calculatedPercentage
    }
    
    func calOffRebounds(stat: Stats) -> Int {
        return stat.offRebounds
    }
    
    func calDefRebounds(stat: Stats) -> Int {
        return stat.defRebounds
    }
    
    func calTurnovers(stat: Stats) -> Int {
        return stat.turnovers
    }
    
    func calFouls(stat: Stats) -> Int {
        return stat.fouls
    }
    
    func checkIfNaN(calculatedPercentage: Double) -> String {
        if calculatedPercentage.isNaN == true {
            return "0.0"
        } else {
            return "\(Double(round(calculatedPercentage * 1000)/1000) * 100)"
        }
    }
    
    func calculateLeaders() {
        calculatePointsLeader()
        calculateAssistsLeader()
        calculateReboundsLeader()
        calculateBlocksLeader()
        calculateStealsLeader()
    }
    
    func calculatePointsLeader() {
        var highest = 0
        var leadersArray = [""]
        for stat in stats {
            let points = calPoints(stat: stat)
            if  points > highest {
                leadersArray.removeAll()
                leadersArray.append(stat.playerID)
                highest = points
            } else if points == highest {
                leadersArray.append(stat.playerID)
            }
        }
        if leadersArray.count == 1 {
            for player in roster {
                if player.playerID == leadersArray[0] {
                    pointsLeaderStatLabel.text = "\(highest)"
                    pointsLeaderNumberLabel.text = "# \(player.playerNumber)"
                    pointsLeaderNameLabel.text = "\(player.playerFirstName) \(player.playerLastName)"
                }
            }
        } else {
            var string = ""
            for player in roster {
                if leadersArray.contains(player.playerID) {
                    string += " # \(player.playerNumber) "
                }
                pointsLeaderStatLabel.text = "\(highest)"
                pointsLeaderNumberLabel.text = string
                pointsLeaderNameLabel.text = "Multiple Players"
            }
        }
    }
    
    func calculateAssistsLeader() {
        var highest = 0
        var leadersArray = [""]
        for stat in stats {
            let assists = stat.assists
            if  assists > highest {
                leadersArray.removeAll()
                leadersArray.append(stat.playerID)
                highest = assists
            } else if assists == highest {
                leadersArray.append(stat.playerID)
            }
        }
        if leadersArray.count == 1 {
            for player in roster {
                if player.playerID == leadersArray[0] {
                    assistsLeaderStatLabel.text = "\(highest)"
                    assistsLeaderNumberLabel.text = "# \(player.playerNumber)"
                    assistsLeaderNameLabel.text = "\(player.playerFirstName) \(player.playerLastName)"
                }
            }
        } else {
            var string = ""
            for player in roster {
                if leadersArray.contains(player.playerID) {
                    string += " # \(player.playerNumber) "
                }
                assistsLeaderStatLabel.text = "\(highest)"
                assistsLeaderNumberLabel.text = string
                assistsLeaderNameLabel.text = "Multiple Players"
            }
        }
    }
    
    func calculateReboundsLeader() {
        var highest = 0
        var leadersArray = [""]
        for stat in stats {
            let rebounds = calRebounds(stat: stat)
            if  rebounds > highest {
                leadersArray.removeAll()
                leadersArray.append(stat.playerID)
                highest = rebounds
            } else if rebounds == highest {
                leadersArray.append(stat.playerID)
            }
        }
        if leadersArray.count == 1 {
            for player in roster {
                if player.playerID == leadersArray[0] {
                    reboundsLeaderStatLabel.text = "\(highest)"
                    reboundsLeaderNumberLabel.text = "# \(player.playerNumber)"
                    reboundsLeaderNameLabel.text = "\(player.playerFirstName) \(player.playerLastName)"
                }
            }
        } else {
            var string = ""
            for player in roster {
                if leadersArray.contains(player.playerID) {
                        string += " # \(player.playerNumber) "
                }
                reboundsLeaderStatLabel.text = "\(highest)"
                reboundsLeaderNumberLabel.text = string
                reboundsLeaderNameLabel.text = "Multiple Players"
            }
        }
    }
    
    func calculateBlocksLeader() {
        var highest = 0
        var leadersArray = [""]
        for stat in stats {
            let blocks = stat.blocks
            if  blocks > highest {
                leadersArray.removeAll()
                leadersArray.append(stat.playerID)
                highest = blocks
            } else if blocks == highest {
                leadersArray.append(stat.playerID)
            }
        }
        if leadersArray.count == 1 {
            for player in roster {
                if player.playerID == leadersArray[0] {
                    blocksLeaderStatLabel.text = "\(highest)"
                    blocksLeaderNumberLabel.text = "# \(player.playerNumber)"
                    blocksLeaderNameLabel.text = "\(player.playerFirstName) \(player.playerLastName)"
                }
            }
        } else {
            var string = ""
            for player in roster {
                if leadersArray.contains(player.playerID) {
                    string += " # \(player.playerNumber) "
                }
                blocksLeaderStatLabel.text = "\(highest)"
                blocksLeaderNumberLabel.text = string
                blocksLeaderNameLabel.text = "Multiple Players"
            }
        }
    }
    
    func calculateStealsLeader() {
        var highest = 0
        var leadersArray = [""]
        for stat in stats {
            let steals = stat.steals
            if  steals > highest {
                leadersArray.removeAll()
                leadersArray.append(stat.playerID)
                highest = steals
            } else if steals == highest {
                leadersArray.append(stat.playerID)
            }
        }
        if leadersArray.count == 1 {
            for player in roster {
                if player.playerID == leadersArray[0] {
                    stealsLeaderStatLabel.text = "\(highest)"
                    stealsLeaderNumberLabel.text = "# \(player.playerNumber)"
                    stealsLeaderNameLabel.text = "\(player.playerFirstName) \(player.playerLastName)"
                }
            }
        } else {
            var string = ""
            for player in roster {
                if leadersArray.contains(player.playerID) {
                    string += " # \(player.playerNumber) "
                }
                stealsLeaderStatLabel.text = "\(highest)"
                stealsLeaderNumberLabel.text = string
                stealsLeaderNameLabel.text = "Multiple Players"
            }
        }
    }
}
