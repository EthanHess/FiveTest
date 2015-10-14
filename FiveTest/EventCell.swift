//
//  EventCell.swift
//  FiveTest
//
//  Created by Ethan Hess on 9/3/15.
//  Copyright (c) 2015 Ethan Hess. All rights reserved.
//

import UIKit

class EventCell: UICollectionViewCell {
    
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var eventBackgroundImage: UIImageView!
    @IBOutlet weak var eventDescriptionLabel: UILabel!
    @IBOutlet weak var eventDateLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var attendButton: UIButton!
    
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var imageViewOne: UIImageView!
    @IBOutlet weak var imageViewTwo: UIImageView!
    @IBOutlet weak var imageViewThree: UIImageView!
    @IBOutlet weak var imageViewFour: UIImageView!
    @IBOutlet weak var imageViewFive: UIImageView!
    
    var isFlipped = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func flipCell() {
        
        if isFlipped == false {
        
        eventTitleLabel.hidden = true
        eventBackgroundImage.hidden = true
        imageView.hidden = true
        categoryImageView.hidden = true
            
        imageViewOne.hidden = false
        imageViewTwo.hidden = false
        imageViewThree.hidden = false
        imageViewFour.hidden = false
        imageViewFive.hidden = false
            
        eventDateLabel.hidden = false
        eventDescriptionLabel.hidden = false
        attendButton.hidden = false
            
        self.isFlipped = true
            
        }
        
        else {
            
            eventTitleLabel.hidden = false
            eventBackgroundImage.hidden = false
            imageView.hidden = false
            categoryImageView.hidden = false
            
            imageViewOne.hidden = true
            imageViewTwo.hidden = true
            imageViewThree.hidden = true
            imageViewFour.hidden = true
            imageViewFive.hidden = true
            
            eventDateLabel.hidden = true
            eventDescriptionLabel.hidden = true
            attendButton.hidden = true
            
            self.isFlipped = false
            
        }
    }
    
    override func applyLayoutAttributes(layoutAttributes: (UICollectionViewLayoutAttributes)) {
        
        super.applyLayoutAttributes(layoutAttributes)
        let circularlayoutAttributes = layoutAttributes as! CollectionViewLayoutAttributes
        self.layer.anchorPoint = circularlayoutAttributes.anchorPoint
        self.center.y += (circularlayoutAttributes.anchorPoint.y - 0.5) * CGRectGetHeight(self.bounds)
        
        imageView.layer.cornerRadius = imageView.frame.size.height / 2
        
        attendButton.layer.cornerRadius = attendButton.frame.size.height / 2
        
        eventTitleLabel.layer.cornerRadius = 15
        eventTitleLabel.layer.masksToBounds = true
        eventTitleLabel.layer.borderColor = UIColor.blackColor().CGColor
        eventTitleLabel.layer.borderWidth = 1
        
        eventDescriptionLabel.layer.cornerRadius = 15
        eventDescriptionLabel.layer.masksToBounds = true
        eventDescriptionLabel.layer.borderColor = UIColor.blackColor().CGColor
        eventDescriptionLabel.layer.borderWidth = 1
        
        eventDateLabel.layer.cornerRadius = 15
        eventDateLabel.layer.masksToBounds = true
        eventDateLabel.layer.borderColor = UIColor.blackColor().CGColor
        eventDateLabel.layer.borderWidth = 1
        
        eventBackgroundImage.layer.cornerRadius = 20
        eventBackgroundImage.layer.masksToBounds = true
        
        imageViewOne.layer.cornerRadius = 15
        imageViewOne.layer.borderColor = UIColor.blackColor().CGColor
        imageViewOne.layer.borderWidth = 1
        imageViewOne.layer.masksToBounds = true
        
        imageViewTwo.layer.cornerRadius = 15
        imageViewTwo.layer.borderColor = UIColor.blackColor().CGColor
        imageViewTwo.layer.borderWidth = 1
        imageViewTwo.layer.masksToBounds = true
        
        imageViewThree.layer.cornerRadius = 15
        imageViewThree.layer.borderColor = UIColor.blackColor().CGColor
        imageViewThree.layer.borderWidth = 1
        imageViewThree.layer.masksToBounds = true
        
        imageViewFour.layer.cornerRadius = 15
        imageViewFour.layer.borderColor = UIColor.blackColor().CGColor
        imageViewFour.layer.borderWidth = 1
        imageViewFour.layer.masksToBounds = true
        
        imageViewFive.layer.cornerRadius = 15
        imageViewFive.layer.borderColor = UIColor.blackColor().CGColor
        imageViewFive.layer.borderWidth = 1
        imageViewFive.layer.masksToBounds = true
        
        categoryImageView.layer.cornerRadius = 10
        categoryImageView.layer.borderColor = UIColor.blackColor().CGColor
        categoryImageView.layer.borderWidth = 1
        categoryImageView.layer.masksToBounds = true
        
//        categoryImageView.image = UIImage(named: "Food")
    }

    
}
