//
//  CustomView.swift
//  StatTracker-Basketball
//
//  Created by Ray Paragas on 3/2/17.
//  Copyright © 2017 Ray Paragas. All rights reserved.
//

import UIKit

class CustomView: UIView {
    
    var viewTitleBarSize = 0

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.layer.cornerRadius = 25.0
        self.layer.shadowOpacity = 0.8
        self.layer.shadowRadius = 3.0
        self.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        self.backgroundColor = UIColor(red: 75/255, green: 89/255, blue: 126/255, alpha: 1.0)
        self.tintColor = UIColor.white
        createMask()
        createBar() //removed until positioning fixed
    }
    
    @IBInspectable var ViewTitleBar : Int {
        get {
            return viewTitleBarSize
        }
        set {
            viewTitleBarSize = newValue
            createBar()
        }
    }
    
    func createBar() {
        let (barWidth, barHeight) = (self.frame.width, self.frame.height / CGFloat(viewTitleBarSize))
        let barSize = CGSize(width: barWidth, height: barHeight)
        let barView = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: barSize)) // revisit y origin
        barView.backgroundColor = UIColor(colorLiteralRed: 50/255, green: 64/255, blue: 101/255, alpha: 1.0) // Navy
        //barView.viewWithTag()
        self.addSubview(barView)
        self.sendSubview(toBack: barView)
        
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
