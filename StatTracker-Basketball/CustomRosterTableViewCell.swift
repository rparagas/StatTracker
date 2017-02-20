//
//  CustomRosterTableViewCell.swift
//  StatTracker-Basketball
//
//  Created by Ray Paragas on 21/2/17.
//  Copyright © 2017 Ray Paragas. All rights reserved.
//

import UIKit

class CustomRosterTableViewCell: UITableViewCell {

    @IBOutlet weak var customContentView: UIView!
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var playerNumberPositionLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected == true {
            self.contentView.backgroundColor = UIColor(colorLiteralRed: 50/255, green: 64/255, blue: 101/255, alpha: 1.0)
            self.customContentView.backgroundColor = UIColor(colorLiteralRed: 50/255, green: 64/255, blue: 101/255, alpha: 1.0)
            self.layer.borderColor = UIColor(colorLiteralRed: 50/255, green: 64/255, blue: 101/255, alpha: 1.0).cgColor
            
        } else {
            self.contentView.backgroundColor = UIColor(red: 75/255, green: 89/255, blue: 126/255, alpha: 1.0) //blue
            self.customContentView.backgroundColor = UIColor(red: 75/255, green: 89/255, blue: 126/255, alpha: 1.0)
            self.layer.borderColor = UIColor(colorLiteralRed: 50/255, green: 64/255, blue: 101/255, alpha: 1.0).cgColor // Navy
        }// Configure the view for the selected state
    }
    
    func setPlayerDetails(player: Player) {
        playerNameLabel.text = "\(player.playerFirstName) \(player.playerLastName)"
        playerNumberPositionLabel.text = "# \(player.playerNumber) | \(player.playerPosition)"
        playerNameLabel.textColor = UIColor.white
        playerNumberPositionLabel.textColor = UIColor.white
    }

}
