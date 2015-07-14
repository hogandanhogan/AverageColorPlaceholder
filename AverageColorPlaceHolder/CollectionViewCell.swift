//
//  CollectionViewCell.swift
//  AverageColorPlaceHolder
//
//  Created by Dan Hogan on 7/12/15.
//  Copyright (c) 2015 Dan Hogan. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    let imageView = UIImageView()
    let theBackgroundView = UIView(frame: CGRectZero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview({
            self.theBackgroundView.clipsToBounds = true
            self.theBackgroundView.layer.cornerRadius = 4.0
            self.theBackgroundView.frame = CGRectMake(
                0.0,
                0.0,
                self.contentView.frame.width,
                self.contentView.frame.height - 5.0
            )
            
            return self.theBackgroundView
            }()
        )

        contentView.addSubview({
            self.imageView.clipsToBounds = true
            self.imageView.layer.cornerRadius = 4.0
            self.imageView.contentMode = .ScaleAspectFill
            self.imageView.frame = CGRectMake(
                0.0,
                0.0,
                self.contentView.frame.width,
                self.contentView.frame.height - 5.0
            )
            
            return self.imageView
            }()
        )
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animateImage(image: UIImage) {
        theBackgroundView.backgroundColor = image.averageColor()
        imageView.image = image
        imageView.alpha = 0.0
        UIView.animateWithDuration(
            0.5,
            delay: 1.0,
            options: UIViewAnimationOptions.CurveLinear,
            animations: { () -> Void in
            self.imageView.alpha = 1.0
        }, completion: nil)
    }
}
