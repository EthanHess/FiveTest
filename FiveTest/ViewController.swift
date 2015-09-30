
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

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton:UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(named: "bar_background"),
            forBarMetrics: UIBarMetrics.Default)
        
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        
        activityIndicatorView.hidden = true
        passwordTextField.secureTextEntry = true
        
    }

    @IBAction func SignIn(sender: AnyObject) {
        
        PFUser.logInWithUsernameInBackground(self.usernameTextField.text, password: self.passwordTextField.text) { (user, error) -> Void in
            
            if user != nil {
                
                self.performSegueWithIdentifier("pushTabBar", sender: self)
            }
            
            else {
                
                var alertView = UIAlertView()
                
                alertView.title = "Error!"
                alertView.message = "User not found"
                alertView.addButtonWithTitle("Okay!")
                
                alertView.show()
                
            }
        }
    }
    

    @IBAction func SignUp(sender: AnyObject) {
        
        activityIndicatorView.hidden = false
        activityIndicatorView.startAnimating()
        
        var user = PFUser()
        
        user.username = self.usernameTextField.text
        user.password = self.passwordTextField.text
        
        user.signUpInBackgroundWithBlock { (success, error) -> Void in
            
            if error == nil {
                
                self.performSegueWithIdentifier("pushTabBar", sender: self)
                
            }
            
            else {
                
                self.activityIndicatorView.stopAnimating()
                
                var alertView = UIAlertView(title: "Oops!", message: error?.description, delegate: nil, cancelButtonTitle: "Okay")
            }
            
        }
    
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
