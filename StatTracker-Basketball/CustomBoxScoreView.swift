//
//  CustomBoxScoreCollectionView.swift
//  StatTracker-Basketball
//
//  Created by Ray Paragas on 13/2/17.
//  Copyright © 2017 Ray Paragas. All rights reserved.
//

import UIKit

class CustomBoxScoreView: UIView {

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.layer.cornerRadius = 25.0
        self.layer.shadowOpacity = 0.8
        self.layer.shadowRadius = 3.0
        self.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        self.backgroundColor = UIColor(red: 75/255, green: 89/255, blue: 126/255, alpha: 1.0)
        self.tintColor = UIColor.white
        createMask()
    }
    
    func createMask() {
        // create mask layer
        let maskLayer = CAShapeLayer()
        
        // create path with the shape of view
        let path = UIBezierPath(rect: self.bounds)
        
        // give mask layer the created path
        maskLayer.path = path.cgPath
        
        //set fill rule to exclude intersected paths
        maskLayer.fillRule = kCAFillRuleEvenOdd
        
        // set mask to view and clip
        self.layer.mask = maskLayer
        self.clipsToBounds = true
    }
}
