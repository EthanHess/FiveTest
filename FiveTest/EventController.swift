//
//  EventController.swift
//  FiveTest
//
//  Created by Ethan Hess on 10/28/15.
//  Copyright © 2015 Ethan Hess. All rights reserved.
//

import UIKit
import EventKit

class EventController: NSObject {
    
    static let sharedInstance = EventController ()
    let eventStore = EKEventStore()
    
    //Move code into create method
    
    override init() {
        
        //grants permission to access calendar
        
        if EKEventStore.authorizationStatusForEntityType(.Event) != (EKAuthorizationStatus.Authorized) {
            
            eventStore.requestAccessToEntityType(.Event, completion: { (granted, error) -> Void in
                
                
            })
        } else {
            
            
        }
        
    }
    
    //creates event
    
    //FIX: doesn't call if statement, make sure authorization permission is granted
    
    func createEvent(title: String, startDate: NSDate) {
        
        let eventStore = EKEventStore()
        let event = EKEvent(eventStore: eventStore)
            
            eventStore.requestAccessToEntityType(.Event, completion: { (granted, error) -> Void in
                
                event.title = title
                event.startDate = startDate
                event.endDate = NSDate()
                event.calendar = eventStore.defaultCalendarForNewEvents
                
                do {
                    
                    try! eventStore.saveEvent(event, span: .FutureEvents)
                    
                } catch {
                    print("bad things happened")
                }
                
            })
    }
}
