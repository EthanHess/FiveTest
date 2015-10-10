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

    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        eventImageView.layer.cornerRadius = 10
        eventImageView.layer.masksToBounds = true
    }

}
