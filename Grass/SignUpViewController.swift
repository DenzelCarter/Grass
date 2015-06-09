//
//  SignUpViewController.swift
//  Grass
//
//  Created by Denzel Carter on 6/6/15.
//  Copyright (c) 2015 BearBrosDevelopment. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class SignUpViewController: UIViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate  {
    
    @IBOutlet var usernameTxt: UITextField!
    @IBOutlet var emailTxt: UITextField!
    @IBOutlet var passwordTxt: UITextField!
    @IBOutlet var profilePic: UIImageView!
    
    var signupActive = true
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    func displayAlert(title:String, error:String) {
        
        var alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    
    
    @IBAction func set_photo(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        let actionSheet = UIAlertController(title: "Profile Picture", message: "Change Your Image Source", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera Roll", style: UIAlertActionStyle.Default, handler: {(action: UIAlertAction!) -> Void in
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Take Photo", style: UIAlertActionStyle.Default, handler: {(action: UIAlertAction!) -> Void in
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        
        self.presentViewController(actionSheet, animated:true, completion:nil)
        
    }
    
    
    @IBAction func signup_click(sender: AnyObject) {
        var error = ""
        
        if usernameTxt.text == "" {
            
            error = "Please enter username, password, and email"
            
        }
        
        if profilePic.image == nil {
            error = "Please choose a profile picture"
        }
        
        if passwordTxt.text == "" {
            error = "Please enter a password"
        }
        
        if emailTxt.text == "" {
            error = "Please enter an email"
        }
        
        if usernameTxt.text == "" && emailTxt.text == "" && passwordTxt.text == "" {
            error = "Please enter username, email, password"
        }
        
        if usernameTxt.text ==  "" && emailTxt.text == "" {
            error = "Please enter username and email"
        }
        
        if usernameTxt.text ==  "" && passwordTxt.text == "" {
            error = "Please enter username and password"
        }
        
        if emailTxt.text ==  "" && passwordTxt.text == "" {
            error = "Please enter email and password"
        }
        
        
        if error != "" {
            
            displayAlert("Error In Form", error: error)
            
        } else {
            
            
            var user = PFUser()
            let profileImageData = UIImageJPEGRepresentation(profilePic.image, 0.6)
            let profileImageFile =  PFFile(data: profileImageData)
            user.username = usernameTxt.text
            user.password = passwordTxt.text
            user.email = emailTxt.text
            user["photo"] = profileImageFile
            user.signUpInBackgroundWithBlock {
                (succeeded, signUpError) -> Void in
                
                if signUpError == nil {
                    let installation = PFInstallation.currentInstallation()
                    installation["user"] = user
                    installation.saveInBackgroundWithBlock(nil)
                    println("signup")
                    
                    self.performSegueWithIdentifier("SignUpUser", sender: self)
                } else {
                    
                    if let errorString = signUpError!.userInfo?["error"] as? NSString {
                        
                        // Update - added as! String
                        
                        error = errorString as String
                        
                    } else {
                        
                        error = "Please try again later."
                        
                    }
                    
                    self.displayAlert("Could Not Sign Up", error: error)
                }
                
            }
            
            
        }
        
        
    }
    
    
    @IBAction func cancel_click(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        usernameTxt.resignFirstResponder()
        emailTxt.resignFirstResponder()
        passwordTxt.resignFirstResponder()
        return true
        
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        var image = info[UIImagePickerControllerOriginalImage] as! UIImage
        let imageSize = image.size
        let width = imageSize.width
        let height = imageSize.height
        
        if width != height {
            let newDimmensions = min(width,height)
            let widthOffset = (width - newDimmensions) / 2
            let heightOffset = (height - newDimmensions) / 2
            
            UIGraphicsBeginImageContextWithOptions(CGSizeMake(newDimmensions, newDimmensions), false, 0.0)
            image.drawAtPoint(CGPointMake(-widthOffset, -heightOffset), blendMode: kCGBlendModeCopy, alpha: 1.0)
            
            image = UIGraphicsGetImageFromCurrentImageContext() as UIImage
            UIGraphicsEndImageContext()
        }
        
        UIGraphicsBeginImageContext(CGSizeMake(150, 150))
        
        let context = UIGraphicsGetCurrentContext()
        
        image.drawInRect(CGRectMake(0, 0, 150, 150))
        
        let smallImage = UIGraphicsGetImageFromCurrentImageContext()
        
        profilePic.image = smallImage
        
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let theWidth = view.frame.size.width
        let theHeight = view.frame.size.height
        profilePic.center = CGPointMake(theWidth / 2, 140)
        profilePic.layer.cornerRadius = profilePic.frame.size.width / 2
        profilePic.clipsToBounds = true
        // Do any additional setup after loading the view.
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
