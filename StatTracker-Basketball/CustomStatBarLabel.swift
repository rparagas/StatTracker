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
    
    func adjustPosition(currentValue: Double, max: Int, rightBarOrigin: CGPoint) {
        let percentage : Double = currentValue / Double(max)
        let barWidth = Double(250) * percentage
        var xPoint: CGFloat = 0.0
        if labelKey == 1 {
            // will need to change 310 x position
            var offset = 310 - barWidth // width of bar
            offset -= 5 // padding between bar and label
            xPoint = CGFloat(offset) - frame.size.width // width of self (label)
        } else {
            xPoint = rightBarOrigin.x + CGFloat(barWidth)
            xPoint += CGFloat(5)
        }
        let origin = CGPoint(x: xPoint, y: self.frame.origin.y)
        self.frame = CGRect(origin: origin, size: self.frame.size)
    }
    

}
