//
//  CustomPlayerTableViewCell.swift
//  StatTracker-Basketball
//
//  Created by Ray Paragas on 7/2/17.
//  Copyright © 2017 Ray Paragas. All rights reserved.
//

import UIKit

class CustomGameTableViewCell: UITableViewCell {

    @IBOutlet weak var customContentView: UIView!
    @IBOutlet weak var opponentLabel: UILabel!
    @IBOutlet weak var outcomeLabel: UILabel!
    
    var outcome = ""

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        determineOutcome()
        if selected == true {
            self.contentView.backgroundColor = UIColor(colorLiteralRed: 50/255, green: 64/255, blue: 101/255, alpha: 1.0)
            self.customContentView.backgroundColor = UIColor(colorLiteralRed: 50/255, green: 64/255, blue: 101/255, alpha: 1.0)
            self.textLabel?.textColor = UIColor.blue
            self.layer.borderColor = UIColor(colorLiteralRed: 50/255, green: 64/255, blue: 101/255, alpha: 1.0).cgColor
            
        } else {
            self.contentView.backgroundColor = UIColor(red: 75/255, green: 89/255, blue: 126/255, alpha: 1.0) //blue
            self.customContentView.backgroundColor = UIColor(red: 75/255, green: 89/255, blue: 126/255, alpha: 1.0)
            self.textLabel?.textColor = UIColor.white
            self.layer.borderColor = UIColor(colorLiteralRed: 50/255, green: 64/255, blue: 101/255, alpha: 1.0).cgColor // Navy
        }// Configure the view for the selected state
    }
    
    func configureCell(game: Game) {
        opponentLabel.text = "vs \(game.gameOppTeam)"
        outcome = game.gameOutcome
    }
    
    func determineOutcome() {
        if outcome == "win" {
            self.outcomeLabel.text = "W"
            self.outcomeLabel.textColor = UIColor.green
        } else if outcome == "lose" {
            self.outcomeLabel.text = "L"
            self.outcomeLabel.textColor = UIColor.red
        } else if outcome == "tie" {
            self.outcomeLabel.text = "T"
            self.outcomeLabel.textColor = UIColor.yellow
        } else {
            self.outcomeLabel.text = "-"
            self.outcomeLabel.textColor = UIColor.white
        }
    }

}
