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
        let rgba = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: 4)
        let colorSpace: CGColorSpace = CGColorSpaceCreateDeviceRGB()
        let info = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        
        let context: CGContext = CGContext(data: rgba, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: info.rawValue)!
        
        context.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: 1, height: 1))
        
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
