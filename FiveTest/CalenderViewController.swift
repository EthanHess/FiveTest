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
    var eventsCreated : [Event]? = []
    var refresher = UIRefreshControl()
    
    @IBOutlet weak var eventsTableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func viewWillAppear(animated: Bool) {
        
        refresh()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresher.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        self.eventsTableView.addSubview(refresher)
        
        //maybe change
        
        if let eventsCreatedList : PFRelation = PFUser.currentUser()?.relationForKey("Events") {
            
            eventsCreatedList.query()?.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                
                if objects != nil {
                    
                    self.eventsCreated = objects as? [Event]
                    print(self.eventsCreated)
                }
                
                else if (error != nil) {
                    print(error)
                }
                
            })
        }
        
        
            if let eventsToAttendList : PFRelation = PFUser.currentUser()?.relationForKey("eventsToAttendList") {
                
                eventsToAttendList.query()?.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                    
                    if objects != nil {
                        
                        self.eventsToAttend = objects as? [Event]
                    }
                        
                    else if (error != nil) {
                        
                        print(error)
                    }
                    
                    
                })
        }
        
        
        
        registerForNotifications()
        
    }
    
    func registerForNotifications() {
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "refresh", name: "reloadTableView", object: nil)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell : EventCellTwo = tableView.dequeueReusableCellWithIdentifier("cell") as! EventCellTwo
        
        if (segmentedControl.selectedSegmentIndex == 0) {
            
            let eventToAttend : Event = self.eventsToAttend![indexPath.row]
            
            eventToAttend.eventImage.getDataInBackgroundWithBlock { (data, error) -> Void in
                
                if let data = data, image = UIImage(data: data) {
                    
                    cell.eventImageView.image = image
                    cell.eventTitleLabel.text = eventToAttend.eventTitle
                }
                
            }
            
        } else if (segmentedControl.selectedSegmentIndex == 1) {
            
            let eventCreated : Event = self.eventsCreated![indexPath.row]
            
            eventCreated.eventImage.getDataInBackgroundWithBlock({ (data, error) -> Void in
                
                if let data = data, image = UIImage(data: data) {
                    
                    cell.eventImageView.image = image
                    cell.eventTitleLabel.text = eventCreated.eventTitle
                }
                
            })
        }
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (segmentedControl.selectedSegmentIndex == 0) {
            
            if let eventsToAttend = self.eventsToAttend {
                
                return eventsToAttend.count
            }
        }

        else if (segmentedControl.selectedSegmentIndex == 1) {
            
            if let eventsCreated = self.eventsCreated {
                
                return eventsCreated.count
            }
        }
        
        return 0
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 400
    }
    
    @IBAction func addToCalendar(sender: AnyObject) {
        
        let button = sender as! UIButton
        let view = button.superview
        let cell = view?.superview as! EventCellTwo
        let indexPath = eventsTableView.indexPathForCell(cell)
        
        if let indexPath = indexPath {
            
            if let eventToAttend = eventsToAttend?[indexPath.row] {
                
                //calendar method does nothing, fix this eventually
                
                EventController.sharedInstance.createEvent(eventToAttend.eventTitle!, startDate: eventToAttend.eventDate!)
                
                print(eventToAttend.eventTitle)
                
            }
        }
    }
    
    @IBAction func removeEvent(sender: AnyObject) {
        
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // pop alert view
    }
    
    func popAlertView(event: Event) {
        
    
        
    }
    
    @IBAction func segmentSelected(sender: UISegmentedControl) {
        
        if (sender == 0) {
            
            refresh()
        }
        
        if (sender == 1) {
            
            refresh()
        }
    }
    
    func refresh() {
        
        eventsTableView.reloadData()
        refresher.endRefreshing()
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
