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
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let events = PFUser.currentUser()?["eventsToAttend"] as? [String] {
        self.responseObjects = [Event]()
        for eventId in events {
            if let event = PFObject(withoutDataWithClassName: "Event", objectId: eventId) as? Event {
            self.responseObjects?.append(event)
            }
        }
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell : EventCellTwo = tableView.dequeueReusableCellWithIdentifier("cell") as! EventCellTwo
        
        var event : Event = self.responseObjects![indexPath.row] as! Event
        
//        cell.textLabel?.text = event.eventTitle
        
        event.eventImage.getDataInBackgroundWithBlock { (data, error) -> Void in
            
            if let data = data, image = UIImage(data: data) {
                
                cell.eventImageView.image = image
                cell.eventTitleLabel.text = event.eventTitle
            }
            
        }
        
        
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (segmentedControl.selectedSegmentIndex == 0) {
        
        return responseObjects!.count
            
        }
        
        else if (segmentedControl.selectedSegmentIndex == 1) {
        
        return 0
            
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 300
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // pop alert view
    }
    
    func popAlertView(event: Event) {
        
    
        
    }
    
    @IBAction func segmentSelected(sender: UISegmentedControl) {
        
        if (sender == 0) {
            
            eventsTableView.reloadData()
        }
        
        if (sender == 1) {
            
            eventsTableView.reloadData()
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
