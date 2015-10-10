
//
//  EventCollectionViewController.swift
//  FiveTest
//
//  Created by Ethan Hess on 9/3/15.
//  Copyright (c) 2015 Ethan Hess. All rights reserved.
//

import UIKit
import Parse

class EventCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var events : [Event]? = []
    var profiles : [Profile]? = []
    var testEvents : [String]? = []
    var testImages : [String]? = []
    var user = PFUser.currentUser()
    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(named: "bar_background"),
            forBarMetrics: UIBarMetrics.Default)
    
        
        //queries for parse objects (events)
        
        let query = Event.query()
        
        query?.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            
            if let objects = objects as? [Event] {
                self.events = objects
                self.collectionView.reloadData()
            }
            else if let error = error {
                println("error: \(error.localizedDescription)")
            }
        })
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 30, left: 20, bottom: 30, right: 20)
        layout.itemSize = CGSize(width: self.view.frame.size.width / 2.5, height: 120)

        collectionView.reloadData()
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        if let events = self.events {
            return events.count
        }
        
        return 0
    
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        //sets up cell
        
        var cell : EventCell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! EventCell
        
        //adds attend action
        
        cell.attendButton.addTarget(self, action: "buttonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        
        //sets up swipe gesture recognizer
        
//        let upSwipe = UISwipeGestureRecognizer(target: self, action: "didSwipe:")
//        upSwipe.direction = UISwipeGestureRecognizerDirection.Up
//        cell.addGestureRecognizer(upSwipe)
        
    
        //queries parse for events
        
        var event = events?[indexPath.row]
        
        event?.eventImage.getDataInBackgroundWithBlock({ (data, error) -> Void in
            
            if let data = data, image = UIImage(data: data) {
                
                if cell.isFlipped == false {
                
                cell.eventBackgroundImage.image = image
                cell.eventTitleLabel.text = event?.eventTitle
                    
                cell.imageView.image = UIImage(named: "homer")
                    
                //sets correct category for cell image
                
                    if event?.category == "" {
                        
                        cell.categoryImageView.image = nil
                    }
                    
                    if event?.category == "The Arts" {
                    
                        cell.categoryImageView.image = UIImage(named: "University")
                    }
                    
                    if event?.category == "The Outdoors" {
                        
                        cell.categoryImageView.image = UIImage(named: "Landscape")
                    }
                    
                    //TODO finish categories
                
                }
                
                else if cell.isFlipped == true {
                    
//                    let date = event?.eventDate
//                    var dateFormatter = NSDateFormatter()
//                    dateFormatter.dateFormat = "hh:mm"
//                    var dateString = dateFormatter.stringFromDate(date!)
                    
                    cell.eventDescriptionLabel.text = event?.eventDescription
//                    cell.eventDateLabel.text = dateString
                    
//                    cell.imageViewOne.image = UIImage(named: self.testImages![0])
//                    cell.imageViewTwo.image = UIImage(named: self.testImages![1])
//                    cell.imageViewThree.image = UIImage(named: self.testImages![2])
//                    cell.imageViewFour.image = UIImage(named: self.testImages![3])
//                    cell.imageViewFive.image = UIImage(named: self.testImages![4])
                    
                    
                }
            }
        })
        
        
        //query parse for profiles 
        
//        var profile = profiles?[indexPath.row]
//        
//        profile?.image.getDataInBackgroundWithBlock({ (data, error) -> Void in
//            
//            if let data = data, image = UIImage(data: data) {
//                
//                cell.imageView.image = image
//                
//            }
//            
//            else {
//                cell.imageView.image = nil
//            }
//        })
        
        cell.layer.cornerRadius = 20
        
//        var subviews : NSArray = cell.contentView.subviews
//        
//        for view in subviews {
//            view.removeFromSuperview()
//        }
        
        return cell
        
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        //flip cell when selected
        
        var cell : EventCell = collectionView.cellForItemAtIndexPath(indexPath) as! EventCell
        
//        self.view.bringSubviewToFront(cell)
        
        UIView.transitionWithView(cell, duration: 0.5, options: UIViewAnimationOptions.TransitionFlipFromLeft, animations: { () -> Void in
            
        }) { (success) -> Void in
            
            cell.flipCell()
            
            if cell.isFlipped == true {
                cell.backgroundColor = UIColor.lightGrayColor()
            }
            
            else if cell.isFlipped == false {
                cell.backgroundColor = UIColor.clearColor()
            }
            
            
        }
        
    }
    
    //get index path of button
    
    func buttonTapped(sender: AnyObject) {
        
        let button = sender as! UIButton
        let view = button.superview
        let cell = view?.superview as! EventCell
        let indexPath = collectionView.indexPathForCell(cell)
        
        print(indexPath)
        if let indexPath = indexPath {
            if let event = events?[indexPath.row] {
                
                var attendees = [String]()
                if let attendeesTmp = event["attendees"] as?[String] {
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
                        attendees.append(objId)
                        event["attendees"] = attendees;
                        event.saveInBackground()
                    }
                }
                
                if let user = PFUser.currentUser() {
                    var eventsAttending = [String]()
                    if let eventsAttendingTmp = user["eventsToAttend"] as?[String] {
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
                        eventsAttending.append(eventId)
                        user["eventsToAttend"] = eventsAttending;
                        user.saveInBackground()
                        }
                    }
                }
            }
            
        }
        
        
        
    }
    
    //pop alert through storyboards
    
//    @IBAction func popAlertView(sender: AnyObject) {
//        
//        var alertViewController = UIAlertController(title: "Attend event?", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
//        
//        alertViewController.addAction(UIAlertAction(title: "Yes!", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
//            
//            
//            
//            // save event to array of events of user
//        }))
//        
//        alertViewController.addAction(UIAlertAction(title: "No thanks", style: UIAlertActionStyle.Cancel, handler: { (action) -> Void in
//            
//            
//        }))
//        
//        self.presentViewController(alertViewController, animated: true) { () -> Void in
//            
//            // finish up here
//        }
//    }
    
    // remove event
    
    func didSwipe(sender: UISwipeGestureRecognizer) {
        
        let cell = sender.view as! UICollectionViewCell
        let i = self.collectionView.indexPathForCell(cell)!.item
        
        
        
        //code to remove here
        
        self.collectionView.reloadData()
        
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


