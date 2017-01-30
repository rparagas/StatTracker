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
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    func setup() {
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.cornerRadius = 5.0
    }
}
