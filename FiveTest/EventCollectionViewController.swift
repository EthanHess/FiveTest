
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
                print("error: \(error.localizedDescription)")
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
        
        let cell : EventCell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! EventCell
        
        //adds attend action
        
        cell.attendButton.addTarget(self, action: "buttonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        
        //sets up swipe gesture recognizer
        
//        let upSwipe = UISwipeGestureRecognizer(target: self, action: "didSwipe:")
//        upSwipe.direction = UISwipeGestureRecognizerDirection.Up
//        cell.addGestureRecognizer(upSwipe)
        
        //queries parse for events
        
        let event = events?[indexPath.row]
        
        event?.eventImage.getDataInBackgroundWithBlock({ (data, error) -> Void in
            
            if let data = data, image = UIImage(data: data) {
                
                cell.eventBackgroundImage.image = image
                cell.eventTitleLabel.text = event?.eventTitle
                
                //gets profile picture of events creator
                
                if let eventCreator = event?.objectForKey("user") as? PFUser {
                    if let creatorImage = eventCreator.objectForKey("profilePicture") as? PFFile {
                        
                            creatorImage.getDataInBackgroundWithBlock({ (data, error) -> Void in
                            
                            cell.creatorImageView.image = UIImage(data: data!)
                            
                        })
                    }
                }
                
                //gets profile pictures for image view array on back of cell
                
//                if let attendeeArray = event?.objectForKey("attendees") as? [PFUser] {
//                    
//                    for var index = 0; index < attendeeArray.count; ++index {
//                        var profileImageView = cell.imageViewArray[index]
//                        var user : PFUser = attendeeArray[index] as? PFUser
//                        
//                        if let picture = user.objectForKey("profilePicture") as? PFFile {
//                            
//                            profileImageView.image = picture
//                            
//                            //get data in background with block then do UIImage(data: data)
//
//                        }
//                    
//                }

                //sets correct category for cell image
                
                if event?.category == "" {
                    cell.categoryImageView.image = nil
                }
                    
                if event?.category == "The Arts" {
                    cell.categoryImageView.image = UIImage(named: "Comedy")
                }
                    
                if event?.category == "The Outdoors" {
                    cell.categoryImageView.image = UIImage(named: "Landscape")
                }
                
                if event?.category == "Other" {
                    cell.categoryImageView.image = UIImage(named: "Dice")
                }
                
                if event?.category == "Sports" {
                    cell.categoryImageView.image = UIImage(named: "Exercise")
                }
                
                if event?.category == "Academics" {
                    cell.categoryImageView.image = UIImage(named: "University")
                }
                
                if event?.category == "Science" {
                    cell.categoryImageView.image = UIImage(named: "Physics")
                }
                
                if event?.category == "Entertainment" {
                    cell.categoryImageView.image = UIImage(named: "Bowling")
                }
                
                if event?.category == "Food & Drinks" {
                    cell.categoryImageView.image = UIImage(named: "Food")
                }
                
                if let date = event?.eventDate {
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    
                    cell.eventDescriptionLabel.text = event?.eventDescription
                    cell.eventDateLabel.text = dateFormatter.stringFromDate(date)
                }
            }
        })
        
        cell.layer.cornerRadius = 20
        
        //not sure if necessary
        
//        let subviews : NSArray = cell.contentView.subviews
//        
//        for view in subviews {
//            view.removeFromSuperview()
//        }
        
        return cell
        
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        //flip cell when selected
        
        let cell : EventCell = collectionView.cellForItemAtIndexPath(indexPath) as! EventCell
        
        UIView.transitionWithView(cell, duration: 0.5, options: UIViewAnimationOptions.TransitionFlipFromLeft, animations: { () -> Void in
            
        }) { (success) -> Void in
            
            cell.flipCell()
            
            if cell.isFlipped == true {
                cell.backgroundColor = UIColor.whiteColor()
            }
            
            else if cell.isFlipped == false {
                cell.backgroundColor = UIColor.clearColor()
            }
            
            
        }
        
    }
    
    //get index path of button (DON'T NEED THIS METHOD ANYMORE)
    
    func buttonTapped(sender: AnyObject) {
        
        let button = sender as! UIButton
        let view = button.superview
        let cell = view?.superview as! EventCell
        let indexPath = collectionView.indexPathForCell(cell)
        
        if let indexPath = indexPath {
            if let event = events?[indexPath.row] {
                
                //pops alert vc
                
                let alertController : UIAlertController = UIAlertController(title: event.eventTitle, message: nil, preferredStyle: UIAlertControllerStyle.Alert)
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
                
                alertController.addAction(cancelAction)
                
                let saveUserToEvent = UIAlertAction(title: "Yes", style: .Default) { _ in
                    
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
                
                alertController.addAction(saveUserToEvent)
                
                
//                self.presentViewController(alertController, animated: true, completion: nil)
                
            }
            
        }
    }
    
    //THIS METHOD TAKES BUTTONTAPPED's PLACE
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let button = sender as! UIButton
        let view = button.superview
        let cell = view?.superview as! EventCell
        let indexPath = collectionView.indexPathForCell(cell)
        
        if let indexPath = indexPath {
            if let event = events?[indexPath.row] {
                
                if (segue.identifier == "presentConfirmScreen") {
                    
                    let modalVC = segue.destinationViewController as! ModalViewController
                    
                    modalVC.event = event
                }
            }
        }
    }
    
    // remove event
    
    func didSwipe(sender: UISwipeGestureRecognizer) {
        
        let cell = sender.view as! UICollectionViewCell
        _ = self.collectionView.indexPathForCell(cell)!.item
        
        
        
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


