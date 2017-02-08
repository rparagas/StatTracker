//
//  CustomStatBarView.swift
//  StatTracker-Basketball
//
//  Created by Ray Paragas on 8/2/17.
//  Copyright © 2017 Ray Paragas. All rights reserved.
//

import UIKit

class CustomStatBarView: UIView {
    
    var barKey = 0

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.layer.shadowRadius = 3.0
        self.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
    }
    
    @IBInspectable var BarType: Int {
        get {
            return barKey
        }
        set {
            barKey = newValue
            switch barKey {
                case 1:
                    self.backgroundColor = UIColor(colorLiteralRed: 0/255, green: 171/255, blue: 175/255, alpha: 1.0) //Blue
                    break
                case 2:
                    self.backgroundColor = UIColor(colorLiteralRed: 255/255, green: 74/255, blue: 102/255, alpha: 1.0) // Red
                    break
                default: break
            }
        }
    }
        
    func adjustSize(currentValue: Double, max: Int) {
        let percentage : Double = currentValue / Double(max)
        let width = Double(250) * percentage
        let size = CGSize(width: width , height: 21)
        var xPoint: CGFloat = 0.0
        if barKey == 1 {
            // will need to change 310 x position
            let offset = 310 - width
            xPoint = CGFloat(offset)
        } else {
            xPoint = self.frame.origin.x
        }
        let origin = CGPoint(x: xPoint, y: self.frame.origin.y)
        self.frame = CGRect(origin: origin, size: size)
    }
    
}
