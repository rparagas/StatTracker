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
    
    @IBOutlet weak var boxScoreCollection: UICollectionView!
    @IBOutlet weak var boxScoreView: CustomBoxScoreView!
    
    var selectedTeam = Team()
    var roster = [Player]()
    var stats = [Stats]()
    var oppStats = Stats()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        boxScoreCollection.collectionViewLayout = CustomBoxScoreCollectionViewLayout()
        boxScoreCollection.delegate = self
        boxScoreCollection.dataSource = self
        
        //boxScoreCollection = self
        self.edgesForExtendedLayout = UIRectEdge.bottom
    }
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        let sections = roster.count + 2
        return sections
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 21
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CustomBoxScoreCollectionViewCell
        
        if indexPath.section == 0 {
            cell.label.text = createHeaderString(indexPath: indexPath)
        } else if indexPath.section == (roster.count+1) {
            //FIND BETTER WAY TO DO ABOVE
            cell.label.text = createTotalString(indexPath: indexPath)
        } else {
            cell.label.text = createStatString(indexPath: indexPath)
        }
        cell.label.sizeToFit()
        //cell.label.text = "Section:\(indexPath.section) Item: \(indexPath.item)"
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
    // MARK: UICollectionViewDelegate
    
    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment this method to specify if the specified item should be selected
     override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
     
     }
     */
    
}
