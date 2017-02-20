//
//  CustomLeaderCollectionViewCell.swift
//  StatTracker-Basketball
//
//  Created by Ray Paragas on 20/2/17.
//  Copyright © 2017 Ray Paragas. All rights reserved.
//

import UIKit

class CustomLeaderCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var statLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var playerLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        /*
        statLabel.textColor = UIColor(colorLiteralRed: 255/255, green: 74/255, blue: 102/255, alpha: 1.0)
        numberLabel.textColor = UIColor(colorLiteralRed: 0/255, green: 171/255, blue: 175/255, alpha: 1.0)
        playerLabel.textColor = UIColor(colorLiteralRed: 255/255, green: 178/255, blue: 70/255, alpha: 1.0)
         */
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func setLeader(stat: String, number: Int, player: String) {
        statLabel.text = stat
        numberLabel.text = "\(number)"
        playerLabel.text = player
    }

}
