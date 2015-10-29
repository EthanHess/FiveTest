//
//  EventCellTwo.swift
//  FiveTest
//
//  Created by Ethan Hess on 10/6/15.
//  Copyright (c) 2015 Ethan Hess. All rights reserved.
//

import UIKit

class EventCellTwo: UITableViewCell {

    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet var addToCalendarButton: UIButton!
    @IBOutlet var removeEventButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        eventImageView.layer.cornerRadius = 10
        eventImageView.layer.masksToBounds = true
        
        addToCalendarButton.layer.cornerRadius = 10
        addToCalendarButton.layer.borderColor = UIColor.whiteColor().CGColor
        addToCalendarButton.layer.borderWidth = 1
        
        removeEventButton.layer.cornerRadius = 10
        removeEventButton.layer.borderColor = UIColor.whiteColor().CGColor
        removeEventButton.layer.borderWidth = 1
    }

}
