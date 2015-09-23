
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

//        testEvents = ["homer","marge","bart","lisa","maggie"]
//        testImages = ["homer", "marge", "bart", "lisa", "maggie"]

        collectionView.reloadData()
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

//        return testEvents!.count
        
        if let events = self.events {
            return events.count
        }
        
        return 0
    
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        //sets up cell
        
        var cell : EventCell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! EventCell
        
        //queries parse for events
        
        var event = events?[indexPath.row]
        
        event?.eventImage.getDataInBackgroundWithBlock({ (data, error) -> Void in
            
            if let data = data, image = UIImage(data: data) {
                
                if cell.isFlipped == false {
                
                cell.eventBackgroundImage.image = image
                cell.eventTitleLabel.text = event?.eventTitle
                    
                cell.imageView.image = UIImage(named: "homer")
                    
                }
                
                else {
                    
                    let date = event?.eventDate
                    var dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "hh:mm"
                    var dateString = dateFormatter.stringFromDate(date!)
                    
                    cell.eventDescriptionLabel.text = event?.eventDescription
                    cell.eventDateLabel.text = dateString
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
        
        return cell
        
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        //flip cell when selected
        
        var cell : EventCell = collectionView.cellForItemAtIndexPath(indexPath) as! EventCell
        
        UIView.transitionWithView(cell, duration: 0.5, options: UIViewAnimationOptions.TransitionFlipFromLeft, animations: { () -> Void in
            
        }) { (success) -> Void in
            
            cell.flipCell()
            
            cell.backgroundColor = UIColor.whiteColor()
            
            
        }
        
    }
    
    @IBAction func popAlertView(sender: AnyObject) {
        
        var alertViewController = UIAlertController(title: "Attend event?", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        
        alertViewController.addAction(UIAlertAction(title: "Yes!", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            
            
            
            // save event to array of events of user
        }))
        
        alertViewController.addAction(UIAlertAction(title: "No thanks", style: UIAlertActionStyle.Cancel, handler: { (action) -> Void in
            
            
        }))
        
        self.presentViewController(alertViewController, animated: true) { () -> Void in
            
            // finish up here
        }
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

// test images

//        cell.eventTitleLabel.text = testEvents?[indexPath.row]
//        cell.eventBackgroundImage.image = UIImage(named: testImages![indexPath.row])

//        SWITCH TESTING

//        switch indexPath.row {
//
//        case 0:
//            cell.backgroundColor = UIColor.redColor()
//
//        case 1:
//            cell.backgroundColor = UIColor.yellowColor()
//
//        case 2:
//            cell.backgroundColor = UIColor.greenColor()
//
//        case 3:
//            cell.backgroundColor = UIColor.blackColor()
//
//        case 4:
//            cell.backgroundColor = UIColor.orangeColor()
//
//        default:
//
//            break
//
//        }

//        cell.userImageView.image = UIImage(named: self.testImages![indexPath.row])
