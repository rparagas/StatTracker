//
//  CustomProgressButton.swift
//  StatTracker-Basketball
//
//  Created by Ray Paragas on 10/2/17.
//  Copyright © 2017 Ray Paragas. All rights reserved.
//

import UIKit

class CustomProgressButton: UIButton {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.layer.cornerRadius = 5.0
        self.layer.shadowOpacity = 0.8
        self.layer.shadowRadius = 3.0
        self.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        self.backgroundColor = UIColor(red: 75/255, green: 89/255, blue: 126/255, alpha: 1.0)
        self.tintColor = UIColor.white
        createMask()
        createProgressBar()
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
    
    func createProgressBar() {
        let (barWidth,barHeight) = (self.frame.width, self.frame.height / 15)
        let barSize = CGSize(width: barWidth, height: barHeight)
        
        let progressBarTotal = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: self.frame.height-barHeight), size: barSize))
        let progressBarCurrent = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: self.frame.height-barHeight), size: barSize)) // revisit y origin
        
        progressBarTotal.tag = 100
        progressBarCurrent.tag = 50
        
        progressBarTotal.backgroundColor = UIColor(colorLiteralRed: 50/255, green: 64/255, blue: 101/255, alpha: 1.0)  // Navy
        progressBarCurrent.backgroundColor = UIColor(colorLiteralRed: 255/255, green: 178/255, blue: 70/255, alpha: 1.0)  // Yellow
        self.addSubview(progressBarTotal)
        self.addSubview(progressBarCurrent)
    }
    
    func buttonIsSelected() {
        self.backgroundColor = UIColor(colorLiteralRed: 50/255, green: 64/255, blue: 101/255, alpha: 1.0)
        let totalProgressBar = self.viewWithTag(100)
        totalProgressBar?.backgroundColor = UIColor(red: 75/255, green: 89/255, blue: 126/255, alpha: 1.0)
        self.tintColor = UIColor.blue
    }
    
    func buttonIsDeselected() {
        self.backgroundColor = UIColor(red: 75/255, green: 89/255, blue: 126/255, alpha: 1.0)
        let totalProgressBar = self.viewWithTag(100)
        totalProgressBar?.backgroundColor = UIColor(colorLiteralRed: 50/255, green: 64/255, blue: 101/255, alpha: 1.0)
        self.tintColor = UIColor.white
    }
    
    
    func updateProgressBar(currentTime: Int, totalTime: Int) {
        let (minutes, seconds) = calMinutesSeconds(seconds: currentTime)
        displayTime(m: minutes, s: seconds)
        
        let percentage : Double = Double(currentTime) / Double(totalTime)
        
        let (barWidth,barHeight) = (self.frame.width * CGFloat(percentage), self.frame.height / 15)
        let barSize = CGSize(width: barWidth, height: barHeight)
        
        let progressBarCurrent = self.viewWithTag(50)
        
        progressBarCurrent?.frame = CGRect(origin: CGPoint(x: 0, y: self.frame.height-barHeight), size: barSize)
    }
    
    func calMinutesSeconds (seconds: Int) -> (Int,Int) {
        return ((seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    func displayTime(m: Int, s: Int) {
        if s < 10 {
            self.setTitle("\(m) : 0\(s)", for: .normal)
        } else {
            self.setTitle("\(m) : \(s)", for: .normal)
        }
    }
    
    func resetProgresBar(totalTime: Int) {
        let (minutes, seconds) = calMinutesSeconds(seconds: totalTime)
        displayTime(m: minutes, s: seconds)
        let (barWidth,barHeight) = (self.frame.width, self.frame.height / 15)
        let barSize = CGSize(width: barWidth, height: barHeight)
        
        let progressBarCurrent = self.viewWithTag(50)
        
        progressBarCurrent?.frame = CGRect(origin: CGPoint(x: 0, y: self.frame.height-barHeight), size: barSize)
    }
}
