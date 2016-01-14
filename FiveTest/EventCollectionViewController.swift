
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
    var tempArray : [PFUser]? = []
    var locationTestArray : [Event]? = []
    
    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //register for notifications 
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "refresh", name: "reloadCollectionView", object: nil)
        
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(named: "bar_background"),
            forBarMetrics: UIBarMetrics.Default)
        
        //user/ event test query for location 
        
        let testQuery = Event.query()
        
        if let latitude = PFUser.currentUser()?["location"].latitude {
            
            if let longitude = PFUser.currentUser()?["location"].longitude {
                
                testQuery?.whereKey("location", withinGeoBoxFromSouthwest: PFGeoPoint(latitude: latitude - 3, longitude: longitude - 3), toNortheast: PFGeoPoint(latitude: latitude + 3, longitude: longitude + 3))
                
                testQuery?.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                    
                    if error != nil {
                        print(error)
                    }
                    else {
                        
                        self.locationTestArray = objects as? [Event]
                        print(self.locationTestArray)
                    }
                })
            }
        }
    
    
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
                
                if let attendeeRelation : PFRelation = event?.relationForKey("eventAttendees") {
                    
                    attendeeRelation.query()?.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                        
                        if ((objects) != nil) {
                            
                            self.tempArray = objects as? [PFUser]
//                            let testArray = objects as? [PFUser]
                            
                            for var index = 0; index < objects!.count; ++index {
                                
//                                let profileImageView = cell.imageViewArray[index]
                                let buttonView = cell.userButtonsArray[index]
                                
                                let usr : PFUser = (self.tempArray?[index] as PFUser?)!
                                
                                usr.fetchIfNeededInBackgroundWithBlock({ (object, error) -> Void in
                                    
                                    if let picture = object!.objectForKey("profilePicture") as? PFFile {
                                        picture.getDataInBackgroundWithBlock({ (data, error) -> Void in
                                            
//                                            profileImageView.image = UIImage(data: data!)
                                            
                                            buttonView.setBackgroundImage(UIImage(data: data!), forState: UIControlState.Normal)
                                            buttonView.user = usr
                                            
                                            //test
                                            buttonView.addTarget(self, action: "buttonClicked:", forControlEvents: UIControlEvents.TouchUpInside)
                                        })
                                    }
                                })
                            }
                        }
                        
                        else {
                            
                            print(error)
                        }
                        
                    })
                    
                }
        

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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
                if (segue.identifier == "presentConfirmScreen") {
                    
                    //gets attend button from cell with event object
                    
                    let button = sender as! UIButton
                    let view = button.superview
                    let cell = view?.superview as! EventCell
                    let indexPath = collectionView.indexPathForCell(cell)
                    
                    if let indexPath = indexPath {
                        if let event = events?[indexPath.row] {
                    
                    let modalVC = segue.destinationViewController as! ModalViewController
                    
                    modalVC.event = event
                            
                }
            }
        }
            
            if (segue.identifier == "pushToProfile") {
                
                //get index of button here then push to profile VC with correct user
                
                //gets userButton from custom button array
                
                let userButton = sender as! UserButton
                let user = userButton.user as PFUser?
                
                if user != nil {
                
                let profileVC = segue.destinationViewController as! ProfileViewController
                
                profileVC.profilesUser = user
            
        }
        
        else {
                
            print("No User")
        
        }
      }
    }
    
    //button test method 
    
    func buttonClicked(sender: UserButton?) {
        
        if let user = sender?.user {
            
            print(user)
        }
        
        else {
            print("No User")
        }
    }
    
    // remove event
    
    func didSwipe(sender: UISwipeGestureRecognizer) {
        
        let cell = sender.view as! UICollectionViewCell
        _ = self.collectionView.indexPathForCell(cell)!.item
        
        
        
        //code to remove here
        
        self.collectionView.reloadData()
        
    }
    
    func refresh() {
        
        collectionView.reloadData()
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


