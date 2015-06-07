//
//  ViewController.swift
//  Grass
//
//  Created by Denzel Carter on 6/5/15.
//  Copyright (c) 2015 BearBrosDevelopment. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class LoginViewController: UIViewController , UITextFieldDelegate{
    
    @IBOutlet var usernameTxt: UITextField!
    
    @IBOutlet var passwordTxt: UITextField!
    
    var signupActive = true
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    func displayAlert(title:String, error:String) {
        
        var alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func create_account(sender:AnyObject) {
        self.performSegueWithIdentifier("GoCreate", sender: self)
        
    }
    
    
    
    @IBAction func login_click(sender: AnyObject) {
        var error = ""
        
        if usernameTxt.text == "" || passwordTxt.text == ""{
            
            error = "Please enter username, password, and email"
            
        }
        
        
        if error != "" {
            
            displayAlert("Error In Form", error: error)
            
        } else {
            PFUser.logInWithUsernameInBackground(usernameTxt.text as String!, password:passwordTxt.text as String!) {
                (user: PFUser?, signupError: NSError?) -> Void in
                
                
                self.activityIndicator.stopAnimating()
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
                
                if signupError == nil {
                    
                    self.performSegueWithIdentifier("SignInUser", sender: self)
                    
                    println("logged in")
                    
                } else {
                    
                    if let errorString = signupError!.userInfo?["error"] as? NSString {
                        
                        // Update - added as! String
                        
                        error = errorString as String
                        
                    } else {
                        
                        error = "Please try again later."
                        
                    }
                    
                    self.displayAlert("Could Not Log In", error: error)
                    
                    
                }
            }
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        usernameTxt.resignFirstResponder()
        passwordTxt.resignFirstResponder()
        return true
        
    }
    
    
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        if ( (PFUser.currentUser() ) != nil) {
        //            pushToMainViewController()
        //        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        
        if PFUser.currentUser() != nil {
            
            self.performSegueWithIdentifier("SignInUser", sender: self)
            
        }
        
    }
    
    
}

