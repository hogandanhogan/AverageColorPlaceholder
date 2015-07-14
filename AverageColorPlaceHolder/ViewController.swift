//
//  ViewController.swift
//  AverageColorPlaceHolder
//
//  Created by Dan Hogan on 7/12/15.
//  Copyright (c) 2015 Dan Hogan. All rights reserved.
//

import UIKit

let kCollectionViewCell = "cell"

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: {
        var flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = UICollectionViewScrollDirection.Vertical
        return flowLayout
        }()
    )
    
    let images: [ UIImage ] = [
        UIImage(named: "2")!,
        UIImage(named: "3")!,
        UIImage(named: "4")!,
        UIImage(named: "5")!,
        UIImage(named: "6")!,
        UIImage(named: "7")!,
        UIImage(named: "1")!,
        UIImage(named: "8")!,
        UIImage(named: "9")!,
        UIImage(named: "10")!,
        UIImage(named: "11")!,
        UIImage(named: "12")!,
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.addSubview({
            self.collectionView.alwaysBounceVertical = true
            self.collectionView.backgroundColor = UIColor.whiteColor()
            self.collectionView.showsHorizontalScrollIndicator = false
            self.collectionView.showsVerticalScrollIndicator = false
            self.collectionView.dataSource = self
            self.collectionView.delegate = self
            self.collectionView.frame = CGRectMake(
                10.0,
                20.0,
                self.view.bounds.width - 20.0,
                self.view.bounds.height - 20.0
            )
            
            return self.collectionView
            }()
        )
        
        registerReusableViews(self.collectionView)
    }
        
    //MARK:- DataSource
    
    func registerReusableViews(collectionView: UICollectionView) {
        collectionView.registerClass(CollectionViewCell.self, forCellWithReuseIdentifier: kCollectionViewCell)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(kCollectionViewCell, forIndexPath: indexPath) as! CollectionViewCell
        cell.animateImage(images[indexPath.row])
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(collectionView.frame.width/2 - 5.0, collectionView.frame.width/2 + 90.0)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 5.0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 10.0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSizeMake(collectionView.frame.width, 10.0)
    }
}

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

extension UIColor {
    
    func image(size: CGSize = CGSizeMake(1, 1)) -> UIImage {
        UIGraphicsBeginImageContext(size)
        let currentContext = UIGraphicsGetCurrentContext()
        
        let fillRect = CGRectMake(0, 0, size.width, size.height)
        CGContextSetFillColorWithColor(currentContext, self.CGColor)
        
        CGContextFillRect(currentContext, fillRect)
        
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return result
    }
}
