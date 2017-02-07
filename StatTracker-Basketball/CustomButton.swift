//
//  CustomSystemButton.swift
//  StatTracker-Basketball
//
//  Created by Ray Paragas on 3/2/17.
//  Copyright © 2017 Ray Paragas. All rights reserved.
//

import UIKit

class CustomButton: UIButton {
    
    var buttonKey = 0
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.layer.cornerRadius = 5.0
        self.layer.shadowOpacity = 0.8
        self.layer.shadowRadius = 3.0
        self.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        self.backgroundColor = UIColor(red: 75/255, green: 89/255, blue: 126/255, alpha: 1.0)
        self.tintColor = UIColor.white
        createMask()
        
    }
    
    @IBInspectable var ButtonType : Int {
        get {
            return buttonKey
        }
        set {
            buttonKey = newValue
            
            let (barWidth,barHeight) = (self.frame.width, self.frame.height / 15)
            let barSize = CGSize(width: barWidth, height: barHeight)
            let barView = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: self.frame.height-barHeight), size: barSize)) // revisit y origin
            switch buttonKey {
            case 1:
                barView.backgroundColor = UIColor(colorLiteralRed: 0/255, green: 171/255, blue: 175/255, alpha: 1.0) // Blue
                break
            case 2:
                barView.backgroundColor = UIColor(colorLiteralRed: 255/255, green: 74/255, blue: 102/255, alpha: 1.0) // Red
                break
            case 3:
                barView.backgroundColor = UIColor(colorLiteralRed: 255/255, green: 178/255, blue: 70/255, alpha: 1.0)  // Yellow
                break
            default: break
            }
            self.addSubview(barView)
        }
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
