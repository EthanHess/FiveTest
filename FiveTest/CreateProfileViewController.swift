//
//  CreateProfileViewController.swift
//  FiveTest
//
//  Created by Ethan Hess on 9/3/15.
//  Copyright (c) 2015 Ethan Hess. All rights reserved.
//

import UIKit
import Parse

class CreateProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    var imagePicker : UIImagePickerController?
    var chosenImage : UIImage?
    var user : PFUser!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var displayName: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        displayName.delegate = self

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
        
    }
    
    @IBAction func saveProfile(sender: AnyObject) {
        
        
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
