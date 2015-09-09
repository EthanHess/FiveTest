//
//  Profile.swift
//  FiveTest
//
//  Created by Ethan Hess on 9/9/15.
//  Copyright (c) 2015 Ethan Hess. All rights reserved.
//

import UIKit
import Parse

class Profile: PFObject {
    
    @NSManaged var image : PFFile
    @NSManaged var user : PFUser
    @NSManaged var latitude : String?
    @NSManaged var longitude : String?
    @NSManaged var displayName : String?
   
    override class func query() -> PFQuery? {
        
        let query = PFQuery(className: Profile.parseClassName())
        query.includeKey("user")
        
        return query
    }
    
    init(image: PFFile, latitude: String, longitude: String, user: PFUser, displayName: String?) {
        super.init()
        
        self.image = image
        self.latitude = latitude
        self.longitude = longitude
        self.displayName = displayName
        self.user = user
    }
    
    override init() {
        super.init()
    }
    
}

extension Profile : PFSubclassing {
    
    class func parseClassName() -> String {
        
        return "Profile"
    }
    
    override class func initialize() {
        var onceToken: dispatch_once_t = 0
        dispatch_once(&onceToken) {
            self.registerSubclass()
        }
    }
}
