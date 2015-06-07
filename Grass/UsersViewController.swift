//
//  UsersViewController.swift
//  Grass
//
//  Created by Denzel Carter on 6/6/15.
//  Copyright (c) 2015 BearBrosDevelopment. All rights reserved.
//

import UIKit
import Parse
import ParseUI

var userName = ""

class UsersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet var resultsTable: UITableView!
    
    var resultsUsernameArray = [String]()
    var resultsImageFiles = [PFFile]()

    override func viewDidLoad() {
        super.viewDidLoad()
        let theWidth = view.frame.size.width
        let theHeight = view.frame.size.height
        resultsTable.frame = CGRectMake(0, 0, theWidth, theHeight)
        userName = PFUser.currentUser()!.username!
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        let predicate = NSPredicate(format: "username != '"+userName+"'")
        var query = PFQuery(className: "_User", predicate: predicate)
        var objects = query.findObjects()
        
        for object in objects! {
            
            self.resultsUsernameArray.append(object["username"] as! String)
            self.resultsImageFiles.append(object["profilePic"] as! PFFile)
            
            self.resultsTable.reloadData()
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logout_click (sender: AnyObject) {
        
        PFUser.logOut()
        self.navigationController?.popToRootViewControllerAnimated(true)

    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 120
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UserViewCell = tableView.dequeueReusableCellWithIdentifier("MainCell") as! UserViewCell
        
        cell.usernameTxt.text = self.resultsUsernameArray[indexPath.row]
        resultsImageFiles[indexPath.row].getDataInBackgroundWithBlock { (imageData:NSData?, error:NSError?) -> Void in
            
            if error == nil {
                
                let image = UIImage(data: imageData!)
                cell.profilePic.image = image 
            }
            
        }
        
        return cell 
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultsUsernameArray.count
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
