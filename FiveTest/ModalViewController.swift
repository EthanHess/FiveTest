//
//  ModalViewController.swift
//  FiveTest
//
//  Created by Ethan Hess on 10/27/15.
//  Copyright © 2015 Ethan Hess. All rights reserved.
//

import UIKit
import Parse
import EventKit

class ModalViewController: UIViewController {
    
    @IBOutlet var saveButton: UIButton!
    var event = Event()

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        print(event)
        saveButton.layer.cornerRadius = 10
        saveButton.layer.borderWidth = 1
        saveButton.layer.borderColor = UIColor.whiteColor().CGColor
        
    }

    @IBAction func saveEventToCalender(sender: AnyObject) {
        
        var attendees = [PFUser]()
        if let attendeesTmp = event["attendees"] as? [PFUser] {
            attendees = attendeesTmp;
        }
        if let objId = PFUser.currentUser()?.objectId {
            var found = false
            for objIdd in attendees {
                if objIdd == objId {
                    found = true
                    break;
                }
            }
            if !found {
//                attendees.append(objId)
                event["attendees"] = attendees;
                event.saveInBackground()
            }
        }
        
        if let user = PFUser.currentUser() {
            var eventsAttending = [Event]()
            if let eventsAttendingTmp = user["eventsToAttend"] as?[Event] {
                eventsAttending = eventsAttendingTmp;
            }
            if let eventId = event.objectId {
                var found = false
                for eventIdd in eventsAttending {
                    if eventIdd == eventId {
                        found = true
                        break;
                    }
                }
                if !found {
//                    eventsAttending.append(eventId)
                    user["eventsToAttend"] = eventsAttending;
                    user.saveInBackground()
                }
                
            }
        }
    }
    
    
    @IBAction func addToCalendar(sender: AnyObject) {
        
        EventController.sharedInstance.createEvent(event.eventTitle!, startDate: event.eventDate!)
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
