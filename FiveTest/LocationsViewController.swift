
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

        var url = NSURL(string: "https://api.foursquare.com/v2/venues/explore?client_id=\(clientID)&client_secret=\(clientSecret)&v=\(foursquareVersion)&ll=\(latitudeLong)&section=\(section)")!
        var request = NSURLRequest(URL: url)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            
            // Dictionaries are like ogres. Unwrap the layers.
            var dictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as! NSDictionary
            var response = dictionary["response"] as! NSDictionary
            var groups = response["groups"] as! NSArray
            if groups.count > 0 {
                var group = groups[0] as! NSDictionary // This should grab the "recommended" group
                var items = group["items"] as! NSArray
                self.responseItems = group["items"] as! [NSDictionary]
                
                for item in self.responseItems {
                    var venue = item["venue"] as! NSDictionary
                    var name = venue["name"] as! String
                    self.tableView.reloadData()
                    
                    
                }
            }

        
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("cell") as! LocationCell
        
        var item = self.responseItems[indexPath.row]
        var venue = item["venue"] as! NSDictionary
        var name = venue["name"] as! String
        cell.textLabel?.text = name
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return responseItems.count
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var item = self.responseItems[indexPath.row]
        var venue = item["venue"] as! NSDictionary
        var name = venue["name"] as! String
        
        var createVC = CreateEventViewController.new()
        
        createVC.updateWithLocation(name)
        
        //make sure this doesn't break
        
        self.navigationController?.popToViewController(createVC, animated: true)
        
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
