
//
//  ViewController.swift
//  FiveTest
//
//  Created by Ethan Hess on 9/2/15.
//  Copyright (c) 2015 Ethan Hess. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton:UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        emailTextField.delegate = self
        
        activityIndicatorView.hidden = true
        passwordTextField.secureTextEntry = true
        
    }

    @IBAction func SignIn(sender: AnyObject) {
        
        PFUser.logInWithUsernameInBackground(self.usernameTextField.text!, password: self.passwordTextField.text!) { (user, error) -> Void in
            
            if user != nil {
                
                self.performSegueWithIdentifier("pushTabBar", sender: self)
            }
            
            else {
                
                let alertController : UIAlertController = UIAlertController(title: "Error", message: "User not found", preferredStyle: UIAlertControllerStyle.Alert)
                
                let cancelAction = UIAlertAction(title: "Okay", style: UIAlertActionStyle.Cancel) {  _ in
                    
                    
                }
            
                alertController.addAction(cancelAction)
                self.presentViewController(alertController, animated: true, completion: nil)
            
            }
        }
    }
    

    @IBAction func SignUp(sender: AnyObject) {
        
        activityIndicatorView.hidden = false
        activityIndicatorView.startAnimating()
        
        let user = PFUser()
        
        user.username = self.usernameTextField.text
        user.password = self.passwordTextField.text
        user.email = self.emailTextField.text
        
        user.signUpInBackgroundWithBlock { (success, error) -> Void in
            
            if error == nil {
                
                //test
                user["location"] = PFGeoPoint(latitude: 77, longitude: 88)
                
                self.performSegueWithIdentifier("pushTabBar", sender: self)
                
            }
            
            else {
                
                self.activityIndicatorView.stopAnimating()
                
                let alertController : UIAlertController = UIAlertController(title: "Oops", message: error?.description, preferredStyle: UIAlertControllerStyle.Alert)
                
                let cancelAction = UIAlertAction(title: "Okay", style: UIAlertActionStyle.Cancel) {  _ in
                    
                }
                
                alertController.addAction(cancelAction)
                self.presentViewController(alertController, animated: true, completion: nil)
                
            }
            
        }
    
    }
    
    @IBAction func resendPassword(sender: AnyObject) {
        
        let alertController : UIAlertController = UIAlertController(title: "Forgot Password?", message: "Enter your email", preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            textField.placeholder = "Email"
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        alertController.addAction(cancelAction)
        
        let sendAction = UIAlertAction(title: "Send", style: UIAlertActionStyle.Default) { _ in
            // below is how you access the textField
            let emailTextField = alertController.textFields![0] 
            if let email = emailTextField.text {
                PFUser.requestPasswordResetForEmailInBackground(email)
            }
        }
        
        alertController.addAction(sendAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)

    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
