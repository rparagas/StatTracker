//
//  CustomTableViewCell.swift
//  StatTracker-Basketball
//
//  Created by Ray Paragas on 7/2/17.
//  Copyright © 2017 Ray Paragas. All rights reserved.
//

import UIKit

class CustomPlayerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var customContentView: UIView!
    @IBOutlet weak var playerLabel: UILabel!
    @IBOutlet weak var playerMinutesLabel: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected == true {
            self.contentView.backgroundColor = UIColor(colorLiteralRed: 50/255, green: 64/255, blue: 101/255, alpha: 1.0)
            self.customContentView.backgroundColor = UIColor(colorLiteralRed: 50/255, green: 64/255, blue: 101/255, alpha: 1.0)
            self.playerLabel.textColor = UIColor.blue
            self.playerMinutesLabel.textColor = UIColor.blue
            self.layer.borderColor = UIColor(colorLiteralRed: 50/255, green: 64/255, blue: 101/255, alpha: 1.0).cgColor
        } else {
            self.contentView.backgroundColor = UIColor(red: 75/255, green: 89/255, blue: 126/255, alpha: 1.0) //blue
            self.customContentView.backgroundColor = UIColor(red: 75/255, green: 89/255, blue: 126/255, alpha: 1.0)
            self.playerLabel.textColor = UIColor.white
            self.playerMinutesLabel.textColor = UIColor.white
            self.layer.borderColor = UIColor(colorLiteralRed: 50/255, green: 64/255, blue: 101/255, alpha: 1.0).cgColor // Navy
        }// Configure the view for the selected state
    }
    
    func configureCell(player: Player, stats: Stats) {
        playerLabel.text = "# \(player.playerNumber) \(player.playerFirstName)"
        refreshTimer(seconds: stats.playingTimeInSeconds)
    }
    
    func refreshTimer(seconds: Int) {
        let (minutes, seconds) = calMinutesSeconds(seconds: seconds)
        displayTime(m: minutes, s: seconds)
    }
    
    func displayTime(m: Int, s: Int) {
        if s < 10 {
            playerMinutesLabel.text = "\(m) : 0\(s)"
        } else {
            playerMinutesLabel.text = "\(m) : \(s)"
        }
    }
    
    func calMinutesSeconds (seconds: Int) -> (Int,Int) {
        return ((seconds % 3600) / 60, (seconds % 3600) % 60)
    }
}
