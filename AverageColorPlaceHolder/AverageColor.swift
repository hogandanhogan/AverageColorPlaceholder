//
//  AverageColor.swift
//  AverageColorPlaceHolder
//
//  Created by Dan Hogan on 7/16/15.
//  Copyright (c) 2015 Dan Hogan. All rights reserved.
//

import UIKit

extension UIImage {
    
    func averageColor() -> UIColor {
        let rgba = UnsafeMutablePointer<CUnsignedChar>.alloc(4)
        let colorSpace: CGColorSpaceRef = CGColorSpaceCreateDeviceRGB()
        let info = CGBitmapInfo(CGImageAlphaInfo.PremultipliedLast.rawValue)
        let context: CGContextRef = CGBitmapContextCreate(rgba, 1, 1, 8, 4, colorSpace, info)
        
        CGContextDrawImage(context, CGRectMake(0, 0, 1, 1), self.CGImage)
        
        if rgba[3] > 0 {
            let alpha: CGFloat = CGFloat(rgba[3])/255.0
            let multiplier: CGFloat = alpha/255.0
            
            return UIColor(
                red: CGFloat(rgba[0]) * multiplier,
                green: CGFloat(rgba[1]) * multiplier,
                blue: CGFloat(rgba[2]) * multiplier,
                alpha: alpha
            )
        } else {
            return UIColor(
                red: CGFloat(rgba[0])/255.0,
                green: CGFloat(rgba[1])/255.0,
                blue: CGFloat(rgba[2])/255.0,
                alpha: CGFloat(rgba[3])/255.0
            )
        }
    }
}