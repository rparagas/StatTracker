//
//  CustomStatBarLabel.swift
//  StatTracker-Basketball
//
//  Created by Ray Paragas on 9/2/17.
//  Copyright © 2017 Ray Paragas. All rights reserved.
//

import UIKit

class CustomStatBarLabel: UILabel {

    var labelKey = 0
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.layer.shadowRadius = 3.0
        self.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
    }
    
    @IBInspectable var LabelType: Int {
        get {
            return labelKey
        }
        set {
            labelKey = newValue
        }
    }
    
    func adjustPosition(currentValue: Double, max: Int, leftBarOrigin: CGPoint) {
        var xPoint: CGFloat = 0.0
        let offset = leftBarOrigin.x - CGFloat(5)  // width of bar - padding
        xPoint = CGFloat(offset) - self.frame.size.width // width of self (label)
        let origin = CGPoint(x: xPoint, y: self.frame.origin.y)
        self.frame = CGRect(origin: origin, size: self.frame.size)
    }
    
    func adjustPosition(currentValue: Double, max: Int, rightBarOrigin: CGPoint) {
        let percentage : Double = currentValue / Double(max)
        let barWidth = Double(250) * percentage
        var xPoint: CGFloat = 0.0
        xPoint = rightBarOrigin.x + CGFloat(barWidth)
        xPoint += CGFloat(5)
        let origin = CGPoint(x: xPoint, y: self.frame.origin.y)
        self.frame = CGRect(origin: origin, size: self.frame.size)
    }
    

}
