
//
//  LocationsViewController.swift
//  FiveTest
//
//  Created by Ethan Hess on 9/22/15.
//  Copyright (c) 2015 Ethan Hess. All rights reserved.
//

import UIKit
import Parse

class LocationsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var clientID = "IGUHLSKLHZZ5JXA30TT0DNXVGPGQWRZQS1RBA5RBMS1K5GLA"
    var clientSecret = "ZGLNT1RJWNU5H1TLQ5HMS2QFQGRHBR5QTU451JILSOIYTIMY"
    var foursquareVersion = "20130815"
    var latitudeLong = "37.770802,-122.403902" // Zynga HQ in CA
    var section = "coffee"
    
    var locationLatitude = Double()
    var locationLongitude = Double()
    
    var responseItems : [NSDictionary]! = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let url = NSURL(string: "https://api.foursquare.com/v2/venues/explore?client_id=\(clientID)&client_secret=\(clientSecret)&v=\(foursquareVersion)&ll=\(latitudeLong)&section=\(section)")!
        let request = NSURLRequest(URL: url)
        
//        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response, data, error) in
            
            
            // Dictionaries are like ogres. Unwrap the layers.
            
//            var dictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as! NSDictionary
            
            let dictionary = try! NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as! NSDictionary
            
            let response = dictionary["response"] as? NSDictionary
            let groups = response!["groups"] as! NSArray
            if groups.count > 0 {
                let group = groups[0] as! NSDictionary // This should grab the "recommended" group
                _ = group["items"] as! NSArray
                self.responseItems = group["items"] as! [NSDictionary]
                
                for item in self.responseItems {
                    let venue = item["venue"] as! NSDictionary
                    _ = venue["name"] as! String
                    
                    self.tableView.reloadData()
                    
                }
            }
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! LocationCell
        
        let item = self.responseItems[indexPath.row]
        let venue = item["venue"] as! NSDictionary
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
        
        if let responseVenue = responseItem["venue"] as? NSDictionary {
        
            let name = responseVenue["name"]
            
            if let location = responseVenue["location"] as? NSDictionary {
                
                let distance = location["distance"]
                let city = location["city"]
                
//                print(name, location, city, distance, String(locationLatitude), String(locationLongitude))
                
            }
            
            
        }
        
        let alertController = UIAlertController(title: "Location selected", message: "Options", preferredStyle: UIAlertControllerStyle.Alert)
        
        let eventVCAction = UIAlertAction(title: "Confirm location", style: UIAlertActionStyle.Default) { _ in
            
            self.performSegueWithIdentifier("pushBackToEventVC", sender: self)
            
        }
        
        alertController.addAction(eventVCAction)
        
        let mapsAction = UIAlertAction(title: "Show on Map", style: UIAlertActionStyle.Default) { _ in
            
            self.performSegueWithIdentifier("pushToGoogleMaps", sender: self)
            
        }
        alertController.addAction(mapsAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { _ in
            
        }
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let indexPath = self.tableView.indexPathForSelectedRow
        
        let item = self.responseItems![indexPath!.row]
        
        var eventVC = CreateEventViewController()
        
        if segue.identifier == "pushBackToEventVC" {
            
            eventVC = segue.destinationViewController as! CreateEventViewController
            
            if let venue = item["venue"] as? NSDictionary {
                
                let locationString = venue["name"] as! String
                let location = venue["location"] as! NSDictionary
                
                //get lat/long strings
                
//                print(location)
                
//                eventVC.updateWithLocation(locationString)
//                eventVC.updateWithGeoPoint(PFGeoPoint(latitude: locationLatitude, longitude: locationLongitude))
                
                eventVC.eventLocationString = locationString
                
                locationLatitude = location["lat"] as! Double
                locationLongitude = location["lng"] as! Double
                
                eventVC.eventLocation = (PFGeoPoint(latitude: locationLatitude, longitude: locationLongitude))
                
                //ask quan about this
            }
            
            
            
            //pass location coordinates 
        }
        
        if segue.identifier == "pushToGoogleMaps" {
            
            let ldvc : LocationsDetailViewController = segue.destinationViewController as! LocationsDetailViewController
            
            if let venue = item["venue"] as? NSDictionary {
                
                let locationString = venue["name"] as! String
                let location = venue["location"] as! NSDictionary
                
                ldvc.eventLatitude = location["lat"] as! Double
                ldvc.eventLongitude = location["lng"] as! Double
                
            }
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
