//
//  LocationsDetailViewController.swift
//  FiveTest
//
//  Created by Ethan Hess on 10/27/15.
//  Copyright © 2015 Ethan Hess. All rights reserved.
//

import UIKit
import MapKit

class LocationsDetailViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    var locationManager : CLLocationManager!
    var userLocation: CLLocationCoordinate2D?
    var eventLocation: CLLocationCoordinate2D?

    var eventTitle: String?
    
    
    @IBOutlet var getDirectionsButton: UIButton!
    @IBOutlet var segmentedControl: UISegmentedControl!
    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dispatch_async(dispatch_get_main_queue()) { 
            
            if CLLocationManager.locationServicesEnabled() {
                
                //change always in Plist file
                
                self.locationManager = CLLocationManager()
                self.locationManager.delegate = self
                self.locationManager.requestWhenInUseAuthorization()
                self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
                self.locationManager.startUpdatingLocation()
                
            }
        }
        
        print(eventLocation)
        
        
    }
    
    
    @IBAction func getDirections(sender: AnyObject) {
        
        mapView.removeAnnotations(mapView.annotations)
        
        mapView.removeOverlays(mapView.overlays)
        
        let geoCoder = CLGeocoder()
        
        let destLocation = CLLocation(latitude: eventLocation!.latitude, longitude: eventLocation!.longitude)
        
        geoCoder.reverseGeocodeLocation(destLocation) { (placemarks, error) in
            
            if let placemark : CLPlacemark = placemarks![0] {
                
                self.mapView.addAnnotation(MKPlacemark(placemark: placemark))
                self.locationManager.startUpdatingLocation()
                
                self.getDirections()
            }
            
        }

    }
    
    func getDirections() {
        
        let fromPlacemark = MKPlacemark(coordinate: userLocation!, addressDictionary: nil)
        let toPlacemark = MKPlacemark(coordinate: eventLocation!, addressDictionary: nil)
        
        let fromItem = MKMapItem(placemark: fromPlacemark)
        let toItem = MKMapItem(placemark: toPlacemark)
        
        let request = MKDirectionsRequest()
        
        request.source = fromItem
        request.destination = toItem
        
        //any for now but allow user to pick eventually
        
        request.requestsAlternateRoutes = false
        request.transportType = MKDirectionsTransportType.Any
        
        let directions = MKDirections(request: request)
        
        directions.calculateDirectionsWithCompletionHandler { (response, error) -> Void in
            
            if (error != nil || response!.routes.isEmpty) {
                
                print(error?.localizedDescription)
            }
            
            let route : MKRoute = response!.routes[0]
            
            self.mapView.addOverlay(route.polyline)
            
            self.showUserAndDestinationOnMap()
            
        }
    }
    
    func showUserAndDestinationOnMap() {
        
        let maxLatitude : Double = fmax(userLocation!.latitude,  eventLocation!.latitude)
        let maxLongitude : Double = fmax(userLocation!.longitude, eventLocation!.longitude)
        let minLatitude : Double = fmin(userLocation!.latitude,  eventLocation!.latitude)
        let minLongitude : Double = fmin(userLocation!.longitude, eventLocation!.longitude)
        
        let mapMargin : Double = 1.5
        let leastCoordSpan : Double = 0.005
        let span_x : Double = fmax(leastCoordSpan, fabs(maxLatitude - minLatitude) * mapMargin);
        let span_y : Double = fmax(leastCoordSpan, fabs(maxLongitude - minLongitude) * mapMargin);
        
        let span = MKCoordinateSpanMake(span_x, span_y)
        
        let center : CLLocationCoordinate2D = CLLocationCoordinate2DMake((maxLatitude + minLatitude) / 2, (maxLongitude + minLongitude) / 2)
        let region : MKCoordinateRegion = MKCoordinateRegionMake(center, span)
        
        mapView.setRegion(mapView.regionThatFits(region), animated:true)
    }
    
    //MARK Location Manager Del.
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        
        if let location : CLLocation = newLocation {
            
            userLocation = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
            
            print("ready!")
        }
        
        let userAnnotation = MKPointAnnotation()
        userAnnotation.coordinate = userLocation!
        userAnnotation.title = "You're here!"
        mapView.addAnnotation(userAnnotation)
        
    }
    
    //adds line to map
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        
        let overlay = MKPolyline()
        
        let polyRenderer = MKPolylineRenderer(overlay: overlay)
        
        polyRenderer.strokeColor = UIColor.redColor()
        polyRenderer.lineWidth = 3
        
        return polyRenderer
    }
    
    //self explanatory
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        
        print(error.localizedDescription)
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
