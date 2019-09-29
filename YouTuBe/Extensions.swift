//
//  Extensions.swift
//  MVVMClosuresDemo
//
//  Created by max on 2019/9/5.
//  Copyright © 2019 w!zzard. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    /// EZSE: init method with RGB values from 0 to 255, instead of 0 to 1. With alpha(default:1)
    public convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat = 1) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
    }
    
    /// EZSE: init method with hex string and alpha(default: 1)
    public convenience init?(hexString: String, alpha: CGFloat = 1.0) {
        var formatted = hexString.replacingOccurrences(of: "0x", with: "")
        formatted = formatted.replacingOccurrences(of: "#", with: "")
        if let hex = Int(formatted, radix: 16) {
            let red = CGFloat(CGFloat((hex & 0xFF0000) >> 16)/255.0)
            let green = CGFloat(CGFloat((hex & 0x00FF00) >> 8)/255.0)
            let blue = CGFloat(CGFloat((hex & 0x0000FF) >> 0)/255.0)
            self.init(red: red, green: green, blue: blue, alpha: alpha)        } else {
            return nil
        }
    }
    
    /// EZSE: init method from Gray value and alpha(default:1)
    public convenience init(gray: CGFloat, alpha: CGFloat = 1) {
        self.init(red: gray/255, green: gray/255, blue: gray/255, alpha: alpha)
    }
    
    /// EZSE: Red component of UIColor (get-only)
    public var redComponent: Int {
        var r: CGFloat = 0
        getRed(&r, green: nil, blue: nil, alpha: nil)
        return Int(r * 255)
    }
    
    /// EZSE: Green component of UIColor (get-only)
    public var greenComponent: Int {
        var g: CGFloat = 0
        getRed(nil, green: &g, blue: nil, alpha: nil)
        return Int(g * 255)
    }
    
    /// EZSE: blue component of UIColor (get-only)
    public var blueComponent: Int {
        var b: CGFloat = 0
        getRed(nil, green: nil, blue: &b, alpha: nil)
        return Int(b * 255)
    }
    
    /// EZSE: Alpha of UIColor (get-only)
    public var alpha: CGFloat {
        var a: CGFloat = 0
        getRed(nil, green: nil, blue: nil, alpha: &a)
        return a
    }
    
    /// EZSE: Returns random UIColor with random alpha(default: false)
    public static func random(randomAlpha: Bool = false) -> UIColor {
        let randomRed = CGFloat.random()
        let randomGreen = CGFloat.random()
        let randomBlue = CGFloat.random()
        let alpha = randomAlpha ? CGFloat.random() : 1.0
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: alpha)
    }
    
}

extension Int {
    func secondsToFormattedString() -> String {
        let hours = self / 3600
        let minutes = (self % 3600) / 60
        let second = (self % 3600) % 60
        let hoursString: String = {
            let hs = String(hours)
            return hs
        }()
        
        let minutesString: String = {
            var ms = ""
            if  (minutes <= 9 && minutes >= 0) {
                ms = "0\(minutes)"
            } else{
                ms = String(minutes)
            }
            return ms
        }()
        
        let secondsString: String = {
            var ss = ""
            if  (second <= 9 && second >= 0) {
                ss = "0\(second)"
            } else{
                ss = String(second)
            }
            return ss
        }()
        
        var label = ""
        if hours == 0 {
            label =  minutesString + ":" + secondsString
        } else{
            label = hoursString + ":" + minutesString + ":" + secondsString
        }
        return label
    }
}

extension CGFloat {
    public static func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / Float(0xFFFFFFFF))
    }
}


enum StateOfVC {
    case minimized
    case fullScreen
    case hidden
}

enum Direction {
    case up, left, none
}
