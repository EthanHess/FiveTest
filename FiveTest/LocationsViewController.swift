
//
//  LocationsViewController.swift
//  FiveTest
//
//  Created by Ethan Hess on 9/22/15.
//  Copyright (c) 2015 Ethan Hess. All rights reserved.
//

import UIKit
import Parse
import Alamofire

class LocationsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var clientID = "IGUHLSKLHZZ5JXA30TT0DNXVGPGQWRZQS1RBA5RBMS1K5GLA"
    var clientSecret = "ZGLNT1RJWNU5H1TLQ5HMS2QFQGRHBR5QTU451JILSOIYTIMY"
    var foursquareVersion = "20130815"
    var latitudeLong = "37.770802,-122.403902" // Zynga HQ in CA
    var section = "coffee"
    
    //update to current location of user via location manager
    
    var locationLatitude = Double()
    var locationLongitude = Double()

    var responseItems : [Dictionary<String, AnyObject>] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getLocationsArray()

    }
    
    func getLocationsArray() {
        
        //eventually get current location, latitudeLong is just a test
        
        let url = NSURL(string: "https://api.foursquare.com/v2/venues/explore?client_id=\(clientID)&client_secret=\(clientSecret)&v=\(foursquareVersion)&ll=\(latitudeLong)&section=\(section)")!
    
        Alamofire.request(.GET, url).responseJSON { (response) in
            
            if let dict = response.result.value as? Dictionary<String, AnyObject> {
                
                if let responseDict = dict["response"] as? Dictionary<String, AnyObject> {
                    
                    if let groups = responseDict["groups"] as? [Dictionary<String, AnyObject>] {
                        
                        if groups.count > 0 {
                            
                            let group = groups[0]
                            
                            guard let items = group["items"] as? [Dictionary<String, AnyObject>] else { return }
                            
                            self.responseItems = items
                            
                            for item in self.responseItems {
                                
                                let venue = item["venue"] as! Dictionary<String, AnyObject>
                                _ = venue["name"]
                                
                                print("YAY %@", self.responseItems)
                                
                                self.tableView.reloadData()
                            }
                            
                        }
                        
                    }
                }
            }
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! LocationCell
        
        let item = self.responseItems[indexPath.row]
        let venue = item["venue"] as! Dictionary<String, AnyObject>
        let name = venue["name"] as! String
        cell.textLabel?.text = name
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return responseItems.count
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //TEST
        
        let responseItem = responseItems[indexPath.row];
        
        if let responseVenue = responseItem["venue"] as? Dictionary<String, AnyObject> {
        
            let name = responseVenue["name"]
            
            if let location = responseVenue["location"] as? Dictionary<String, AnyObject> {
                
                let distance = location["distance"]
                let city = location["city"]
                
                //TEST
                
                print(name, location, city, distance, String(locationLatitude), String(locationLongitude))
                
            }
            
            
        }
        
        let alertController = UIAlertController(title: "Location selected", message: "Options", preferredStyle: UIAlertControllerStyle.Alert)
        
        let eventVCAction = UIAlertAction(title: "Confirm location", style: UIAlertActionStyle.Default) { _ in
            
            self.performSegueWithIdentifier("pushBackToEventVC", sender: self)
            
        }
        
        alertController.addAction(eventVCAction)
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { _ in
            
        }
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let indexPath = self.tableView.indexPathForSelectedRow
        
        let item = self.responseItems[indexPath!.row]
        
        var eventVC = CreateEventViewController()
        
        if segue.identifier == "pushBackToEventVC" {
            
            eventVC = segue.destinationViewController as! CreateEventViewController
            
            if let venue = item["venue"] as? Dictionary<String, AnyObject> {
                
                let nameString = venue["name"] as! String
                let location = venue["location"] as! Dictionary<String, AnyObject>
                
                //get lat/long strings
                
                eventVC.eventLocationString = nameString
                
                locationLatitude = location["lat"] as! Double
                locationLongitude = location["lng"] as! Double
                
                eventVC.eventLocation = (PFGeoPoint(latitude: locationLatitude, longitude: locationLongitude))
       
            }
            
            
            
            //pass location coordinates 
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
