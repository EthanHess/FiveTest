//
//  CalenderViewController.swift
//  FiveTest
//
//  Created by Ethan Hess on 9/3/15.
//  Copyright (c) 2015 Ethan Hess. All rights reserved.
//

import UIKit
import Parse

class CalenderViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var eventsToAttend : [Event]? = []
    var user = PFUser.currentUser()
    var responseObjects : [AnyObject]? = []
    
    @IBOutlet weak var eventsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        var query = PFUser.query()
//        
//        query?.includeKey("Events")

        if let events = PFUser.currentUser()?["eventsToAttend"] as? [String] {
        self.responseObjects = [Event]()
        for eventId in events {
            if let event = PFObject(withoutDataWithClassName: "Event", objectId: eventId) as? Event {
            self.responseObjects?.append(event)
            }
        }
        }
//        let obj = query?.getFirstObject()?.objectForKey("Events")
//        
//        query?.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
//            
//            self.responseObjects = objects
//            
////            self.responseObjects = query?.findObjects()
//            
//        })
        
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
        
//        user?.objectForKey("Events")
        
        var event : Event = self.responseObjects![indexPath.row] as! Event
        
        cell.textLabel?.text = event.eventTitle
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
//        if let eventsToAttend = self.eventsToAttend {
//            return eventsToAttend.count
//        }
        
        return responseObjects!.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
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
