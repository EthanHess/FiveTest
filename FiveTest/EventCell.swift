//
//  EventCell.swift
//  FiveTest
//
//  Created by Ethan Hess on 9/3/15.
//  Copyright (c) 2015 Ethan Hess. All rights reserved.
//

import UIKit

class EventCell: UICollectionViewCell {
    
    var eventBackgroundImage : UIImageView!
    var eventTitleLabel : UILabel!
    var isFlipped : Bool?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
