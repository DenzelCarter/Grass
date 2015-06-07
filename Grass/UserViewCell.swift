//
//  UserViewCell.swift
//  Grass
//
//  Created by Denzel Carter on 6/6/15.
//  Copyright (c) 2015 BearBrosDevelopment. All rights reserved.
//

import UIKit

class UserViewCell: UITableViewCell {
    
    @IBOutlet var profilePic: UIImageView!
    
    @IBOutlet var usernameTxt: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        let theWidth = UIScreen.mainScreen().bounds.width
        contentView.frame = CGRectMake(0, 0, theWidth, 64)
        profilePic.center = CGPointMake(52, 52)
        profilePic.layer.cornerRadius = profilePic.frame.width / 2
        profilePic.clipsToBounds = true


        // Initialization code
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
