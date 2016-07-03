//
//  UIColorEx.swift
//  BadMovie
//
//  Created by shou wei on 04/07/16.
//  Copyright © 2016年 shou wei. All rights reserved.
//

import UIKit

extension UIColor {
    
    class func globalPooRateColor(rate: CGFloat) -> UIColor
    {
        let red  = 0.2 + 0.7 * rate
        let green = 0.2 + 0.4 * rate
        return UIColor(red: red, green: green, blue: 0.1, alpha: 1)
    }
    
    class func globalPooRateColor(rate: CGFloat, alpha: CGFloat) -> UIColor
    {
//        0.6 0.5 0.2
//        0.2 0.2 0.2
        let red  = 0.2 + 0.4 * rate
        let green = 0.2 + 0.3 * rate
        return UIColor(red: red, green: green, blue: 0.2, alpha: alpha)
    }
    
    
    class func globalPooColor(alpha: CGFloat) -> UIColor
    {
        return UIColor(red: 0.54, green: 0.4, blue: 0.06, alpha: alpha)
    }
}