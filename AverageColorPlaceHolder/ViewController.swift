//
//  ViewController.swift
//  AverageColorPlaceHolder
//
//  Created by Dan Hogan on 7/12/15.
//  Copyright (c) 2015 Dan Hogan. All rights reserved.
//

import UIKit

let kCollectionViewCell = "cell"

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate, UIGestureRecognizerDelegate {
    
    var yOffset: CGFloat = 0.0
    
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
        UIImage(named: "12")!
    ]
    
    var animationImages = [ UIImage ]()
    
    let pan = UIPanGestureRecognizer()
    let alphaView = UIView(frame: CGRectZero)
    let fullSizeImageView = UIImageView()
    var frame = CGRectZero

    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 1...16 {
            let image = UIImage(named: "win_\(i)")
            animationImages.append(image!)
        }
    
        view.addSubview({
            self.collectionView.alwaysBounceVertical = true
            self.collectionView.backgroundColor = UIColor.whiteColor()
            self.collectionView.showsHorizontalScrollIndicator = false
            self.collectionView.showsVerticalScrollIndicator = false
            self.collectionView.dataSource = self
            self.collectionView.delegate = self
            self.collectionView.frame = CGRectMake(
                10.0,
                0.0,
                self.view.bounds.width - 20.0,
                self.view.bounds.height
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
        if indexPath.row == 3 {
            cell.animateImage(animationImages[0])
        } else {
            cell.animateImage(images[indexPath.row])
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(collectionView.frame.width/2 - 5.0, collectionView.frame.width/2 + 210.0)
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
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSizeMake(collectionView.frame.width, 5.0)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        var frame = CGRectZero
        for cell in collectionView.visibleCells() {
            if collectionView.indexPathForCell(cell) == indexPath {
                let cell = cell as! CollectionViewCell
                frame = CGRectMake(
                    cell.frame.origin.x + 10.0,
                    cell.frame.origin.y - yOffset,
                    cell.frame.width,
                    cell.frame.height - 5.0
                )
                self.frame = frame
            }
        }
        
        self.view.addSubview({
            self.alphaView.backgroundColor = UIColor.blackColor()
            self.alphaView.frame = CGRectMake(
                0.0,
                0.0,
                self.view.frame.width,
                self.view.frame.height
            )

            self.alphaView.alpha = 0.0
            
            return self.alphaView
            }()
        )

        view.addSubview({
            self.fullSizeImageView.frame = frame
            if indexPath.row == 3 {
                self.fullSizeImageView.image = self.animationImages[0]
            } else {
                self.fullSizeImageView.image = self.images[indexPath.row]
            }
            self.fullSizeImageView.contentMode = .ScaleAspectFill
            self.fullSizeImageView.clipsToBounds = true
            self.fullSizeImageView.userInteractionEnabled = true
            
            self.fullSizeImageView.addGestureRecognizer({
                self.pan.addTarget(self, action: "handlePan")
                
                return self.pan
                }())

            return self.fullSizeImageView
            }()
        )
        
        UIView.animateWithDuration(
            0.5,
            animations: { () -> Void in
                self.fullSizeImageView.frame = CGRectMake(
                    0.0,
                    0.0,
                    self.view.frame.width,
                    self.view.frame.height
                )
            }) { finished in
                self.alphaView.alpha = 1.0
        }
    }
    
    //MARK:- ScrollViewDelegate 
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        yOffset = scrollView.contentOffset.y
        
        let offsetDelta: Int = Int(abs(round(yOffset))) / 8

        for cell in collectionView.visibleCells() {
            if collectionView.indexPathForCell(cell)!.row == 3 {
                let cell = cell as! CollectionViewCell
                cell.imageView.image = animationImages[offsetDelta % animationImages.count]
            }
        }
    }
    
    //MARK:- Action Handlers
    
    func handlePan() {
        if pan.state == .Ended {
            UIView.animateWithDuration(
                0.3,
                animations: { () -> Void in
                    if abs(self.pan.translationInView(self.view).y) >= 30.0 {
                        self.fullSizeImageView.frame = self.frame
                        self.alphaView.alpha = 0.0
                    } else {
                        self.fullSizeImageView.frame = CGRectMake(
                            0.0,
                            0.0,
                            self.view.frame.width,
                            self.view.frame.height
                        )
                    }
                }) { finished in
                    if abs(self.pan.translationInView(self.view).y) >= 30.0 {
                        self.fullSizeImageView.removeFromSuperview()
                        self.fullSizeImageView.removeGestureRecognizer(self.pan)
                        self.alphaView.removeFromSuperview()
                    }
            }
        } else {
            alphaView.alpha = (1200.0 - abs(pan.translationInView(self.view).y))/1200.0
            fullSizeImageView.frame = CGRectMake(
                pan.translationInView(self.view).x,
                pan.translationInView(self.view).y,
                fullSizeImageView.frame.width,
                fullSizeImageView.frame.height
            )
        }
    }
    
    //MARK:- Status Bar
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
