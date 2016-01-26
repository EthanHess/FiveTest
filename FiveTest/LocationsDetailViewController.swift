//
//  LocationsDetailViewController.swift
//  FiveTest
//
//  Created by Ethan Hess on 10/27/15.
//  Copyright © 2015 Ethan Hess. All rights reserved.
//

import UIKit
import GoogleMaps
import MapKit


class LocationsDetailViewController: UIViewController {
    
    let locationManager = CLLocationManager()
    var firstLocationUpdate = Bool?()
    
    
    @IBOutlet var getDirectionsButton: UIButton!
    @IBOutlet var segmentedControl: UISegmentedControl!
    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    @IBAction func getDirections(sender: AnyObject) {
        
        
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
