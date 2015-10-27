//
//  EventCell.swift
//  FiveTest
//
//  Created by Ethan Hess on 9/3/15.
//  Copyright (c) 2015 Ethan Hess. All rights reserved.
//

import UIKit
import Parse

class EventCell: UICollectionViewCell {
    
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var eventBackgroundImage: UIImageView!
    @IBOutlet weak var eventDescriptionLabel: UILabel!
    @IBOutlet weak var eventDateLabel: UILabel!
    @IBOutlet weak var creatorImageView: UIImageView!
    @IBOutlet weak var attendButton: UIButton!
    
    @IBOutlet weak var categoryImageView: UIImageView!
    
    @IBOutlet var imageViewArray: [UIImageView]!
//    var atendeeArray : [PFUser]!
    
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
        creatorImageView.hidden = true
        categoryImageView.hidden = true
            
        eventDateLabel.hidden = false
        eventDescriptionLabel.hidden = false
        attendButton.hidden = false
            
        for imageView in imageViewArray {
            imageView.hidden = false
        }
            
        self.isFlipped = true
            
        }
        
        else {
            
            eventTitleLabel.hidden = false
            eventBackgroundImage.hidden = false
            creatorImageView.hidden = false
            categoryImageView.hidden = false
            
            eventDateLabel.hidden = true
            eventDescriptionLabel.hidden = true
            attendButton.hidden = true
            
            for imageView in imageViewArray {
                imageView.hidden = true
            }
            
            self.isFlipped = false
            
        }
    }
    
    override func applyLayoutAttributes(layoutAttributes: (UICollectionViewLayoutAttributes)) {
        
        super.applyLayoutAttributes(layoutAttributes)
        let circularlayoutAttributes = layoutAttributes as! CollectionViewLayoutAttributes
        self.layer.anchorPoint = circularlayoutAttributes.anchorPoint
        self.center.y += (circularlayoutAttributes.anchorPoint.y - 0.5) * CGRectGetHeight(self.bounds)
        
        creatorImageView.layer.cornerRadius = creatorImageView.frame.size.height / 2
        creatorImageView.layer.borderColor = UIColor.blackColor().CGColor
        creatorImageView.layer.borderWidth = 1
        creatorImageView.layer.masksToBounds = true
        
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

        
        for imageView in imageViewArray {
            
            imageView.layer.cornerRadius = 15
            imageView.layer.borderColor = UIColor.blackColor().CGColor
            imageView.layer.borderWidth = 1
            imageView.layer.masksToBounds = true
        }
        
//        categoryImageView.layer.cornerRadius = 10
//        categoryImageView.layer.borderColor = UIColor.blackColor().CGColor
//        categoryImageView.layer.borderWidth = 1
//        categoryImageView.layer.masksToBounds = true
        
    }
}
