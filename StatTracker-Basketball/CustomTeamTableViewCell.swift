//
//  CustomTeamTableViewCell.swift
//  StatTracker-Basketball
//
//  Created by Ray Paragas on 20/2/17.
//  Copyright © 2017 Ray Paragas. All rights reserved.
//

import UIKit

class CustomTeamTableViewCell: UITableViewCell {

    @IBOutlet weak var customContentView: UIView!
    @IBOutlet weak var teamNameLabel: UILabel!
    @IBOutlet weak var teamTypeLabel: UILabel!
    @IBOutlet weak var teamDivSeasonLabel: UILabel!
    
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
    
    func setTeamName(team: Team) {
        teamNameLabel.text = team.teamName
        teamNameLabel.textColor = UIColor.white
    }
    
    func setTeamDetails(team: Team) {
        teamTypeLabel.text = team.teamType
        teamDivSeasonLabel.text = "\(team.teamDivision) | \(team.teamSeason) '\(team.teamYear)"
        teamTypeLabel.textColor = UIColor.white
        teamDivSeasonLabel.textColor = UIColor.white
    }

}
