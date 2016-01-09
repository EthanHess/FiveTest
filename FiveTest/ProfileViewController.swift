//
//  ProfileViewController.swift
//  FiveTest
//
//  Created by Ethan Hess on 11/3/15.
//  Copyright © 2015 Ethan Hess. All rights reserved.
//

import UIKit
import Parse
import MessageUI

class ProfileViewController: UIViewController, MFMailComposeViewControllerDelegate {

    //outlet properties
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var messageButton: UIButton!
    @IBOutlet var emailButton: UIButton!

    //other properties
    var profilesUser : PFUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImage.layer.cornerRadius = 10
        profileImage.layer.borderColor = UIColor.blackColor().CGColor
        profileImage.layer.masksToBounds = true
        profileImage.layer.borderWidth = 2
    
        //test
        
        //print(profilesUser)

        //query user
        
        profilesUser.fetchInBackgroundWithBlock { (objects, error) -> Void in
            
            if error != nil {
                print(error?.localizedDescription)
            }
            
            else {
                
                if let imageData = self.profilesUser.objectForKey("profilePicture") as? PFFile {
                    
                    imageData.getDataInBackgroundWithBlock({ (data, error) -> Void in
                        
                        if error != nil {
                            print(error)
                        }
                        
                        else {
            
                            self.profileImage.image = UIImage(data: data!)
                        }
                    })
                    
                    self.usernameLabel.text = self.profilesUser.objectForKey("displayName") as? String
                    self.descriptionLabel.text = self.profilesUser.objectForKey("description") as? String
                    
                }
            }
        }
        
    }
    
    @IBAction func emailUser(sender: AnyObject) {
        
        let mailComp = MFMailComposeViewController()
        mailComp.mailComposeDelegate = self
        
        if MFMailComposeViewController.canSendMail() {
            
            let profileUserEmail = profilesUser["email"] as? String
            
            mailComp.setToRecipients(NSArray(object: profileUserEmail!) as? [String])
            mailComp.setSubject("")
            mailComp.setMessageBody("", isHTML: false)
            mailComp.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
            self.presentViewController(mailComp, animated: true, completion: nil)
            
        }
    }

    @IBAction func messageUser(sender: AnyObject) {
        
        //implement messaging here through push notifications
    }
    
    //delegate method
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        
        //do something here
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
