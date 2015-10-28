
//
//  LocationsViewController.swift
//  FiveTest
//
//  Created by Ethan Hess on 9/22/15.
//  Copyright (c) 2015 Ethan Hess. All rights reserved.
//

import UIKit

class LocationsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var clientID = "IGUHLSKLHZZ5JXA30TT0DNXVGPGQWRZQS1RBA5RBMS1K5GLA"
    var clientSecret = "ZGLNT1RJWNU5H1TLQ5HMS2QFQGRHBR5QTU451JILSOIYTIMY"
    var foursquareVersion = "20130815"
    var latitudeLong = "37.770802,-122.403902" // Zynga HQ in CA
    var section = "coffee"
    
    var responseItems : [NSDictionary]! = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let url = NSURL(string: "https://api.foursquare.com/v2/venues/explore?client_id=\(clientID)&client_secret=\(clientSecret)&v=\(foursquareVersion)&ll=\(latitudeLong)&section=\(section)")!
        let request = NSURLRequest(URL: url)
        
//        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response, data, error) in
            
            // Dictionaries are like ogres. Unwrap the layers.
            
//            var dictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as! NSDictionary
            
            let dictionary = try! NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
            
            let response = dictionary["response"] as! NSDictionary
            let groups = response["groups"] as! NSArray
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
        
//        let item = self.responseItems[indexPath.row]
//        let venue = item["venue"] as! NSDictionary
//        let name = venue["name"] as! String
        
        let alertController = UIAlertController(title: "Location selected", message: "Options", preferredStyle: UIAlertControllerStyle.Alert)
        
        let eventVCAction = UIAlertAction(title: "Confirm location", style: UIAlertActionStyle.Default) { _ in
            
            // change later
            
//            self.storyboard?.instantiateViewControllerWithIdentifier("locationsVC")
            
            let viewController:CreateEventViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("locationsVC") as! CreateEventViewController
            self.presentViewController(viewController, animated: false, completion: nil)
        }
        alertController.addAction(eventVCAction)
        
        let mapsAction = UIAlertAction(title: "Show on Map", style: UIAlertActionStyle.Default) { _ in
            
//            self.storyboard?.instantiateViewControllerWithIdentifier("mapVC")
            
            let viewController:LocationsDetailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("mapVC") as! LocationsDetailViewController
            self.presentViewController(viewController, animated: false, completion: nil)
        }
        alertController.addAction(mapsAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { _ in
            
        }
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
        
        
//        self.performSegueWithIdentifier("pushToGoogleMaps", sender: self)
        
//        let lat = item["lat"] as! String
//        let lon = item["long"] as! String
        
//        print("\(lat)","\(lon)","\(name)")
        
//        let createVC = CreateEventViewController()
//        
//        createVC.locationString = name
        
//        make sure this doesn't break

//        self.navigationController?.pushViewController(createVC, animated: true)
        
    }
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        
//        if (segue.identifier == "pushToGoogleMaps") {
//            
//            let ldvc : LocationsDetailViewController = segue.destinationViewController as! LocationsDetailViewController
//            let indexPath = self.tableView.indexPathForSelectedRow
//            
//        }
//    }
    
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
