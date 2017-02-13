//
//  CustomBoxScoreCollectionViewCell.swift
//  StatTracker-Basketball
//
//  Created by Ray Paragas on 30/1/17.
//  Copyright © 2017 Ray Paragas. All rights reserved.
//

import UIKit

@IBDesignable
class CustomBoxScoreCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var label: UILabel!
    var cellType = ""
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func setHeader() {
        self.backgroundColor = UIColor(colorLiteralRed: 50/255, green: 64/255, blue: 101/255, alpha: 1.0)
    }
    
    func setBar() {
        createBar()
        self.backgroundColor = UIColor(red: 75/255, green: 89/255, blue: 126/255, alpha: 1.0)
    }
    
    func setTotal() {
        self.backgroundColor = UIColor(colorLiteralRed: 0/255, green: 171/255, blue: 175/255, alpha: 1.0)
    }
    
    func setOpponent() {
        self.backgroundColor = UIColor(colorLiteralRed: 255/255, green: 74/255, blue: 102/255, alpha: 1.0) // Red
    }
    
    func setBody() {
        self.backgroundColor = UIColor(red: 75/255, green: 89/255, blue: 126/255, alpha: 1.0)
    }
    
    func createBar() {
        let barSize = CGSize(width: 0.5, height: self.frame.height)
        let barView = UIImageView(frame: CGRect(origin: CGPoint(x: self.frame.maxX - 0.5, y: 0), size: barSize)) // revisit y origin
        barView.backgroundColor = UIColor.white // Navy
        self.addSubview(barView)
    }
}
