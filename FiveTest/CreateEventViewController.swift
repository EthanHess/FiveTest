//
//  CreateEventViewController.swift
//  FiveTest
//
//  Created by Ethan Hess on 9/3/15.
//  Copyright (c) 2015 Ethan Hess. All rights reserved.
//

import UIKit
import Parse

class CreateEventViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var event : Event?
    var chosenImage : UIImage?
    var imagePicker : UIImagePickerController?
    var eventDate : NSDate?
    var locationString : String?
    var categoryArray : [String]? = []
    var categoryImages : [String]? = []
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var eventTitleField: UITextField!
    @IBOutlet weak var eventDescriptionField: UITextView!
    @IBOutlet weak var eventSaveButton: UIButton!
    @IBOutlet weak var eventCategoryField: UITextField!
    @IBOutlet weak var popImagePickerButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imagePicker = UIImagePickerController()
        imagePicker?.delegate = self
        imagePicker?.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        imagePicker?.allowsEditing = false
        
        eventImage.layer.cornerRadius = 10
        eventImage.layer.borderColor = UIColor.blackColor().CGColor
        eventImage.layer.masksToBounds = true
        eventImage.layer.borderWidth = 2
        
        eventSaveButton.layer.cornerRadius = 10
        eventSaveButton.layer.borderColor = UIColor.blackColor().CGColor
        eventSaveButton.layer.borderWidth = 2
        
        popImagePickerButton.layer.cornerRadius = 10
        popImagePickerButton.layer.borderColor = UIColor.blackColor().CGColor
        popImagePickerButton.layer.borderWidth = 2
        
        eventDescriptionField.layer.cornerRadius = 10
        eventDescriptionField.layer.borderColor = UIColor.blackColor().CGColor
        eventDescriptionField.layer.borderWidth = 2
        
        tableView.layer.cornerRadius = 10
        tableView.layer.borderColor = UIColor.blackColor().CGColor
        tableView.layer.borderWidth = 2
        
        scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: 1000)
        
        //gets category array value
        
        categoryArray = ["Food & Drinks","Entertainment","Academics","Science","Sports","The Outdoors","The Arts","Other"]
        
        categoryImages = ["Food","Bowling","University","Physics","Exercise","Landscape","Comedy","Dice"]

        // fix this eventually
        
        if locationString != nil {
            
            self.updateWithLocation(self.locationString!)
        }
        
    }
    
    func updateWithLocation(location: String) {
        
        locationTextField.text = locationString
    }
    
    @IBAction func saveEvent(sender: AnyObject) {
        
        let pictureData = UIImagePNGRepresentation(eventImage.image!)
        
        let file = PFFile(name: "eventImage", data: pictureData!)
        
        file!.saveInBackgroundWithBlock { (succeeded, error) -> Void in
            
            if !(error != nil) {
                self.saveEventToParse(file!)
            }
            
            else if let error = error {
                print("error: \(error.localizedDescription)")
            }
            
        }
        
        
    }
    
    func saveEventToParse(file: PFFile) {
        
        let event = Event(image: file, user: PFUser.currentUser()!, comment: eventDescriptionField.text, title: eventTitleField.text, date: datePicker.date, category: eventCategoryField.text!)
        
        event.saveInBackgroundWithBlock { (success, error) -> Void in
            if success {
                
                let relation = event.user.relationForKey("Events")
                relation.addObject(event)
                event.user.saveInBackground()
                
                let alertView = UIAlertView(title: "Event saved!", message: "Success", delegate: nil, cancelButtonTitle: "Okay!")
                alertView.show()
            }
            else {
                print("error: \(error?.localizedDescription)")
            }
            
        }
    }
    
    @IBAction func popImagePicker(sender: AnyObject) {
        
        self.presentImagePicker()
    }
    
    func presentImagePicker() {
        
         presentViewController(imagePicker!, animated: true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        
        chosenImage = image
        eventImage.image = chosenImage
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        if textField == eventTitleField {
            return
        }
            
        if textField == eventCategoryField {
            self.tableView.hidden = false
        }
        
        else if textField == locationTextField {
        self.performSegueWithIdentifier("locationSegue", sender: locationTextField)
        }
        
    }
    
    //sets up tableView
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell!
        
        cell.textLabel?.text = categoryArray![indexPath.row]
        cell.imageView?.image = UIImage(named: categoryImages![indexPath.row])
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let categories = categoryArray {
            return categories.count
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.eventCategoryField.text = categoryArray![indexPath.row]
        
        tableView.hidden = true
        
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
