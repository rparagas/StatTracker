//
//  CustomTableViewCell.swift
//  StatTracker-Basketball
//
//  Created by Ray Paragas on 7/2/17.
//  Copyright © 2017 Ray Paragas. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected == true {
            self.contentView.backgroundColor = UIColor(colorLiteralRed: 50/255, green: 64/255, blue: 101/255, alpha: 1.0)
            self.textLabel?.textColor = UIColor.blue
            self.layer.borderColor = UIColor(colorLiteralRed: 50/255, green: 64/255, blue: 101/255, alpha: 1.0).cgColor
        } else {
            self.contentView.backgroundColor = UIColor(red: 75/255, green: 89/255, blue: 126/255, alpha: 1.0) //blue
            self.textLabel?.textColor = UIColor.white
            self.layer.borderColor = UIColor(colorLiteralRed: 50/255, green: 64/255, blue: 101/255, alpha: 1.0).cgColor // Navy
        }// Configure the view for the selected state
    }
}
