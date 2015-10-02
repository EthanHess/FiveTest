//
//  CreateProfileViewController.swift
//  FiveTest
//
//  Created by Ethan Hess on 9/3/15.
//  Copyright (c) 2015 Ethan Hess. All rights reserved.
//

import UIKit
import Parse
import CoreLocation

class CreateProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, CLLocationManagerDelegate {

    var imagePicker : UIImagePickerController?
    var chosenImage : UIImage?
    var user : PFUser!
    var userGeoPoint : PFGeoPoint!
    var scrollView : UIScrollView!
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var displayName: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var imageButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        displayName.delegate = self
        
        user = PFUser.currentUser()

        imagePicker = UIImagePickerController.new()
        imagePicker?.delegate = self
        imagePicker?.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        imagePicker?.allowsEditing = false
        
        profileImageView.image = UIImage(named: "imagePickerBackground")
        
        profileImageView.layer.cornerRadius = profileImageView.frame.size.height / 2
        profileImageView.layer.borderColor = UIColor.blackColor().CGColor
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.borderWidth = 2
        
        saveButton.layer.cornerRadius = 10
        saveButton.layer.borderColor = UIColor.blackColor().CGColor
        saveButton.layer.borderWidth = 2
        
        imageButton.layer.cornerRadius = 10
        imageButton.layer.borderColor = UIColor.blackColor().CGColor
        imageButton.layer.borderWidth = 2
        
//        self.determineCurrentUserLocation()
        
        self.getParseGeoPoint()
        
    }
    
//    func determineCurrentUserLocation() {
//        
////        locationManager = CLLocationManager()
////        locationManager.delegate = self
////        locationManager.requestAlwaysAuthorization()
////        locationManager.desiredAccuracy = kCLLocationAccuracyBest
////        locationManager.startUpdatingLocation()
//        
//
//    }
    
//    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
//        
//        location = (locations[0] as? CLLocation)!
//        let long = location.coordinate.longitude
//        let lat = location.coordinate.latitude
//        
//        //converts points into strings if needed
//        
//        longString = String(format: "@%", long)
//        latString = String(format: "@%", lat)
//        
//        //grabs value of longitute and latitude
//        
//        let point = PFGeoPoint(latitude: lat, longitude:long)
//        
//        println("\(long, lat)")
//        
//    }
    
    func getParseGeoPoint() {
        
        PFGeoPoint.geoPointForCurrentLocationInBackground { (geoPoint: PFGeoPoint?, error: NSError?) -> Void in
            
            if (error == nil) {
                
            self.userGeoPoint = geoPoint
            }
            
            else if let error = error {
                
                println("error: \(error.localizedDescription)")
            }
            
        }
        
    }
    
    
    @IBAction func saveProfile(sender: AnyObject) {
        
        let pictureData = UIImagePNGRepresentation(profileImageView.image)
        
        let file = PFFile(name: "image", data: pictureData)
        
        file.saveInBackgroundWithBlock { (success, error) -> Void in
            
            if !(error != nil) {
                self.saveProfileToParse(file)
            }
                
            else if let error = error {
                println("error: \(error.localizedDescription)")
            }
            
        }
    }
    
    func saveProfileToParse(file: PFFile) {
        
        //TODO: Fix error with location
        
//        let profile = Profile(image: file, latitude: latString!, longitude: longString!, user: PFUser.currentUser()!, displayName: displayName.text)
        
        let profile = Profile(image: file, user: PFUser.currentUser()!, displayName: displayName.text, location: userGeoPoint)
        
        profile.saveInBackgroundWithBlock { (success, error) -> Void in
            
            if success {
                var alertView = UIAlertView(title: "Profile saved!", message: "Success", delegate: nil, cancelButtonTitle: "Okay!")
                alertView.show()
            }
            else {
                println("error: \(error?.localizedDescription)")
            }
        }
    }
    
    @IBAction func presentImagePicker(sender: AnyObject) {
        
        self.presentImagePicker()
    }
    
    func presentImagePicker() {
        
        presentViewController(imagePicker!, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        
        chosenImage = image
        profileImageView.image = chosenImage
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
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
