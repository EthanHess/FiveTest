
//
//  ViewController.swift
//  FiveTest
//
//  Created by Ethan Hess on 9/2/15.
//  Copyright (c) 2015 Ethan Hess. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton:UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    

    @IBAction func SignIn(sender: AnyObject) {
        
        
        
    }
    

    @IBAction func SignUp(sender: AnyObject) {
        
        var user = PFUser()
        
        user.username = self.usernameTextField.text
        user.password = self.passwordTextField.text
        
        user.signUpInBackgroundWithBlock { (success, error) -> Void in
            
            
            
        }
        
        performSegueWithIdentifier("pushTabBar", sender: self)
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    



}

