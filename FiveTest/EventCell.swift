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
    
    var isFlipped = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func flipCell() {
        
        if isFlipped == false {
        
        eventTitleLabel.hidden = true
        eventBackgroundImage.hidden = true
        
        eventDateLabel.hidden = false
        eventDescriptionLabel.hidden = false
        
        self.isFlipped = true
            
        }
        
        else {
            
            eventTitleLabel.hidden = false
            eventBackgroundImage.hidden = false
            
            eventDateLabel.hidden = true
            eventDescriptionLabel.hidden = true
            
            self.isFlipped = false
            
        }
    }
    
    override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes!) {
        super.applyLayoutAttributes(layoutAttributes)
        let circularlayoutAttributes = layoutAttributes as! CollectionViewLayoutAttributes
        self.layer.anchorPoint = circularlayoutAttributes.anchorPoint
        self.center.y += (circularlayoutAttributes.anchorPoint.y - 0.5) * CGRectGetHeight(self.bounds)
    }

    
}
