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
    
    let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: {
        var flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = UICollectionViewScrollDirection.vertical
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
    let alphaView = UIView(frame: CGRect.zero)
    let fullSizeImageView = UIImageView()
    var frame = CGRect.zero

    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 1...16 {
            let image = UIImage(named: "win_\(i)")
            animationImages.append(image!)
        }
    
        view.addSubview({
            self.collectionView.alwaysBounceVertical = true
            self.collectionView.backgroundColor = UIColor.white
            self.collectionView.showsHorizontalScrollIndicator = false
            self.collectionView.showsVerticalScrollIndicator = false
            self.collectionView.dataSource = self
            self.collectionView.delegate = self
            self.collectionView.frame = CGRect(
                x: 10.0,
                y: 0.0,
                width: self.view.bounds.width - 20.0,
                height: self.view.bounds.height
            )
            
            return self.collectionView
            }()
        )
        
        registerReusableViews(self.collectionView)
    }
        
    //MARK:- DataSource
    
    func registerReusableViews(_ collectionView: UICollectionView) {
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: kCollectionViewCell)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCollectionViewCell, for: indexPath) as! CollectionViewCell
        if indexPath.row == 3 {
            cell.animateImage(animationImages[0])
        } else {
            cell.animateImage(images[indexPath.row])
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/2 - 5.0, height: collectionView.frame.width/2 + 210.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 5.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 10.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 10.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 5.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var frame = CGRect.zero
        for cell in collectionView.visibleCells {
            if collectionView.indexPath(for: cell) == indexPath {
                let cell = cell as! CollectionViewCell
                frame = CGRect(
                    x: cell.frame.origin.x + 10.0,
                    y: cell.frame.origin.y - yOffset,
                    width: cell.frame.width,
                    height: cell.frame.height - 5.0
                )
                self.frame = frame
            }
        }
        
        self.view.addSubview({
            self.alphaView.backgroundColor = UIColor.black
            self.alphaView.frame = CGRect(
                x: 0.0,
                y: 0.0,
                width: self.view.frame.width,
                height: self.view.frame.height
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
            self.fullSizeImageView.contentMode = .scaleAspectFill
            self.fullSizeImageView.clipsToBounds = true
            self.fullSizeImageView.isUserInteractionEnabled = true
            
            self.fullSizeImageView.addGestureRecognizer({
                self.pan.addTarget(self, action: #selector(ViewController.handlePan))
                
                return self.pan
                }())

            return self.fullSizeImageView
            }()
        )
        
        UIView.animate(
            withDuration: 0.5,
            animations: { () -> Void in
                self.fullSizeImageView.frame = CGRect(
                    x: 0.0,
                    y: 0.0,
                    width: self.view.frame.width,
                    height: self.view.frame.height
                )
            }, completion: { finished in
                self.alphaView.alpha = 1.0
        }) 
    }
    
    //MARK:- ScrollViewDelegate 
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        yOffset = scrollView.contentOffset.y
        
        let offsetDelta: Int = Int(abs(round(yOffset/8)))

        for cell in collectionView.visibleCells {
            if collectionView.indexPath(for: cell)!.row == 3 {
                let cell = cell as! CollectionViewCell
                cell.imageView.image = animationImages[offsetDelta % animationImages.count]
            }
        }
    }
    
    //MARK:- Action Handlers
    
    func handlePan() {
        if pan.state == .ended {
            UIView.animate(
                withDuration: 0.3,
                animations: { () -> Void in
                    if abs(self.pan.translation(in: self.view).y) >= 30.0 {
                        self.fullSizeImageView.frame = self.frame
                        self.alphaView.alpha = 0.0
                    } else {
                        self.fullSizeImageView.frame = CGRect(
                            x: 0.0,
                            y: 0.0,
                            width: self.view.frame.width,
                            height: self.view.frame.height
                        )
                    }
                }, completion: { finished in
                    if abs(self.pan.translation(in: self.view).y) >= 30.0 {
                        self.fullSizeImageView.removeFromSuperview()
                        self.fullSizeImageView.removeGestureRecognizer(self.pan)
                        self.alphaView.removeFromSuperview()
                    }
            }) 
        } else {
            alphaView.alpha = (1200.0 - abs(pan.translation(in: self.view).y))/1200.0
            fullSizeImageView.frame = CGRect(
                x: pan.translation(in: self.view).x,
                y: pan.translation(in: self.view).y,
                width: fullSizeImageView.frame.width,
                height: fullSizeImageView.frame.height
            )
        }
    }
    
    //MARK:- Status Bar
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
}
