//
//  CreateEventViewController.swift
//  FiveTest
//
//  Created by Ethan Hess on 9/3/15.
//  Copyright (c) 2015 Ethan Hess. All rights reserved.
//

import UIKit

class CreateEventViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UITextViewDelegate {
    
    var event : Event?
    var imagePicker : UIImagePickerController?
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var eventTitleField: UITextField!
    @IBOutlet weak var eventDescriptionField: UITextView!
    @IBOutlet weak var eventSaveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eventTitleField.delegate = self

        imagePicker?.delegate = self
        
        eventImage.layer.cornerRadius = 50
        eventImage.layer.borderColor = UIColor.blackColor().CGColor
        eventImage.layer.borderWidth = 2
        
        eventSaveButton.layer.cornerRadius = 10
        eventSaveButton.layer.borderColor = UIColor.blackColor().CGColor
        eventSaveButton.layer.borderWidth = 2
        
        eventDescriptionField.layer.cornerRadius = 10
        eventDescriptionField.layer.borderColor = UIColor.blackColor().CGColor
        eventDescriptionField.layer.borderWidth = 2
    }
    
    
    @IBAction func saveEvent(sender: AnyObject) {
        
        
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
