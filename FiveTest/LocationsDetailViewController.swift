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

class LocationsDetailViewController: UIViewController, CLLocationManagerDelegate {
    
    var locationManager : CLLocationManager!
    var userLatitude: CLLocationDegrees = 0
    var userLongitude: CLLocationDegrees = 0
    
    var eventLatitude: CLLocationDegrees = 0
    var eventLongitude: CLLocationDegrees = 0
    var eventTitle: String?
    
    
    @IBOutlet var getDirectionsButton: UIButton!
    @IBOutlet var segmentedControl: UISegmentedControl!
    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        print(eventLongitude, eventLatitude)
        
        //establish map region
        
        let userLocation = CLLocationCoordinate2DMake(userLatitude, userLongitude)
        
        let mapRegion = MKCoordinateRegion(center: userLocation, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        self.mapView.setRegion(mapRegion, animated: true)
        
        let objectAnnotation = MKPointAnnotation()
        objectAnnotation.coordinate = userLocation
        objectAnnotation.title = "You are here"
        self.mapView.addAnnotation(objectAnnotation)
    }
    
    
    @IBAction func getDirections(sender: AnyObject) {
        
        let requestLocation = CLLocation(latitude: eventLatitude, longitude: eventLongitude)
        
        CLGeocoder().reverseGeocodeLocation(requestLocation) { (placemarks, error) -> Void in
            
            if error != nil {
                print(error)
            }
            
            else {
                
                if placemarks!.count > 0 {
                    
                    let placeMark = placemarks![0]
                    
                    let mapViewPlacemark = MKPlacemark(placemark: placeMark)
                    
                    let mapItem = MKMapItem(placemark: mapViewPlacemark)
                    
                    mapItem.name = self.eventTitle
                    
                    if self.segmentedControl.selectedSegmentIndex == 0 {
                        
                        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking]
                        mapItem.openInMapsWithLaunchOptions(launchOptions)
                        
                    } else if self.segmentedControl.selectedSegmentIndex == 1 {
                        
                        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
                        mapItem.openInMapsWithLaunchOptions(launchOptions)
                        
                    } else if self.segmentedControl.selectedSegmentIndex == 2 {
                        
                        let launchOptions = [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeTransit]
                        mapItem.openInMapsWithLaunchOptions(launchOptions)
                    }
                }
            }
        }
    }
    
    //MARK Location Manager Del. 
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        //Establish users current location
        
        let location : CLLocationCoordinate2D = manager.location!.coordinate
        
        self.userLatitude = location.latitude
        self.userLongitude = location.longitude
        
        
        
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
