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
                    cell.removeEventButton.setTitle("Retract", forState: UIControlState.Normal)
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
        
        //make sure only creator can delete their own event
        
        let button = sender as! UIButton
        let view = button.superview
        let cell = view?.superview as! EventCellTwo
        let indexPath = eventsTableView.indexPathForCell(cell)
        
        if let indexPath = indexPath {
            
            if (segmentedControl.selectedSegmentIndex == 1) {
            
            if let eventCreated = eventsCreated?[indexPath.row] {
                
                let alertController = UIAlertController(title: "Remove event?", message: "Are you sure you want to delete this event?", preferredStyle: UIAlertControllerStyle.Alert)
                let deleteAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                    
                    eventCreated.deleteInBackgroundWithBlock({ (success, error) -> Void in
                        
                        if error != nil {
                            print(error)
                        }
                        
                        else {
                            let successAlertController = UIAlertController(title: "Event deleted", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
                            let okayAction = UIAlertAction(title: "Okay", style: UIAlertActionStyle.Cancel, handler: nil)
                            successAlertController.addAction(okayAction)
                            
                            self.presentViewController(successAlertController, animated: true, completion: nil)
                            
                            self.eventsTableView.reloadData()
                        }
                    })
                    
                })
                
                let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
                alertController.addAction(deleteAction)
                alertController.addAction(cancelAction)
                
                self.presentViewController(alertController, animated: true, completion: nil)
            }
            
          }
            
        else if (segmentedControl.selectedSegmentIndex == 0) {
                
                //delete relation for key
                if let eventToAttend = eventsToAttend?[indexPath.row] {
                   
                    let attendeeRelation = PFUser.currentUser()?.relationForKey("eventsToAttendList")
                    attendeeRelation?.removeObject(eventToAttend)
                    
                    let eventRelation = eventToAttend.relationForKey("eventAttendees")
                    eventRelation.removeObject(PFUser.currentUser()!)
                    eventToAttend.saveInBackground()
                    
                    PFUser.currentUser()?.saveInBackgroundWithBlock({ (success, error) -> Void in
                        
                        if error != nil {
                            print(error)
                        }
                        
                        else {
                            
                            let retractionAlertController = UIAlertController(title: "Attendence retracted", message: "You are no longer attending this event", preferredStyle: UIAlertControllerStyle.Alert)
                            let okayAction = UIAlertAction(title: "Okay", style: UIAlertActionStyle.Cancel, handler: nil)
                            retractionAlertController.addAction(okayAction)
                            
                            self.presentViewController(retractionAlertController, animated: true, completion: nil)
                    
                            self.eventsTableView.reloadData()
                            
                            //reloads main collection view
                            NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "reloadCollectionView", object: nil))
                        }
                    })
                }
            }
        }
    }
    
    @IBAction func segmentSelected(sender: UISegmentedControl) {
        
        if (sender.selectedSegmentIndex == 0) {
            
            refresh()
        }
        
        if (sender.selectedSegmentIndex == 1) {
            
            refresh()
        }
    }
    
    func refresh() {
        
        eventsTableView.reloadData()
        refresher.endRefreshing()
    }
    
    func displayAlert(title: String, message: String) {
        
        //fill in eventually to clean up code
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
