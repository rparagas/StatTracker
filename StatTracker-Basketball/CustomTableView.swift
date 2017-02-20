//
//  CustomTableView.swift
//  StatTracker-Basketball
//
//  Created by Ray Paragas on 7/2/17.
//  Copyright © 2017 Ray Paragas. All rights reserved.
//

import UIKit

class CustomTableView: UITableView {

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.layer.cornerRadius = 5.0
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 5.0
        self.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        self.backgroundColor = UIColor(red: 75/255, green: 89/255, blue: 126/255, alpha: 1.0) //blue
        self.tableHeaderView?.backgroundColor = UIColor(colorLiteralRed: 0/255, green: 171/255, blue: 175/255, alpha: 1.0) // Blue
    }
}
