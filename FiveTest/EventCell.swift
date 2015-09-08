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
    @IBOutlet weak var userImageView: UIImageView!
    
    var isFlipped : Bool?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        userImageView.layer.cornerRadius = userImageView.frame.size.height / 2
        userImageView.layer.borderColor = UIColor.blackColor().CGColor
        userImageView.layer.borderWidth = 2
        
        
//        eventBackgroundImage = UIImageView(frame: self.bounds)
//        self.addSubview(eventBackgroundImage)
//        
//        eventTitleLabel = UILabel(frame: CGRectMake(0, self.frame.size.height / 3, self.frame.size.width, self.frame.size.height / 4))
//        eventTitleLabel.textColor = UIColor.blackColor()
//        eventTitleLabel.backgroundColor = UIColor.whiteColor()
//        self.addSubview(eventTitleLabel)
        
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes!) {
        super.applyLayoutAttributes(layoutAttributes)
        let circularlayoutAttributes = layoutAttributes as! CollectionViewLayoutAttributes
        self.layer.anchorPoint = circularlayoutAttributes.anchorPoint
        self.center.y += (circularlayoutAttributes.anchorPoint.y - 0.5) * CGRectGetHeight(self.bounds)
    }

    
}
