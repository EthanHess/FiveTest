//
//  Event.swift
//  FiveTest
//
//  Created by Ethan Hess on 9/3/15.
//  Copyright (c) 2015 Ethan Hess. All rights reserved.
//

import UIKit
import Parse

class Event: PFObject {
    
    @NSManaged var eventImage : PFFile
    @NSManaged var user : PFUser
    @NSManaged var atendeeArray : [PFUser]
    @NSManaged var eventDescription : String?
    @NSManaged var eventTitle : String?
    @NSManaged var eventDate: NSDate?
    
    var location : CLLocationCoordinate2D?
    var eventIsFull : Bool!
   
    override class func query() -> PFQuery? {
        
        let query = PFQuery(className: Event.parseClassName())
        query.includeKey("user")
        query.orderByAscending("createdAt")
        
        return query
    }
    
    init(image: PFFile, user: PFUser, comment: String?, title: String?, date: NSDate?) {
        super.init()
        
        //eventually init with location, atendee array, date and full boolean
        
        self.eventImage = image
        self.user = user
        self.eventDescription = comment;
        self.eventTitle = title;
        self.eventDate = date;
        
    }
    
    override init() {
        super.init()
    }
}

    extension Event : PFSubclassing {

        class func parseClassName() -> String {
            
            return "Event"
        }

        override class func initialize() {
            var onceToken: dispatch_once_t = 0
            dispatch_once(&onceToken) {
                self.registerSubclass()
            }
        }
    }