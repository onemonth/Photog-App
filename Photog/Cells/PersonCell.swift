//
//  PersonCell.swift
//  Photog
//
//  Created by One Month on 9/17/14.
//  Copyright (c) 2014 One Month. All rights reserved.
//

import UIKit

class PersonCell: UITableViewCell {

    @IBOutlet var followButton: UIButton?
    
    var isFollowing: Bool?
    
    var user: PFUser?
    {
        didSet
        {
            self.configure()
        }
    }
    
    override func awakeFromNib()
    {
        super.awakeFromNib()

        self.isFollowing = false
        self.followButton?.hidden = true
    }

    override func prepareForReuse()
    {
        super.prepareForReuse()

        self.isFollowing = false
        self.followButton?.hidden = true
        self.textLabel?.text = ""
        self.user = nil
    }
    
    func configure()
    {
        if let constUser = user
        {
            self.textLabel?.text = constUser.username

            // are we following this person?

            NetworkManager.sharedInstance.isFollowing(constUser, completionHandler: {
                (isFollowing, error) -> () in
                
                if let constError = error
                {
                    // Alert the user, or otherwise modify the UI
                }
                else
                {
                    self.isFollowing = isFollowing
                    
                    if isFollowing == true
                    {
                        var image = UIImage(named: "UnfollowButton")
                        self.followButton?.setImage(image, forState: .Normal)
                    }
                    else
                    {
                        var image = UIImage(named: "FollowButton")
                        self.followButton?.setImage(image, forState: .Normal)
                    }
                    
                    self.followButton?.hidden = false
                }
                
            })
        }
    }

    @IBAction func didTapFollow(sender: UIButton)
    {
        self.followButton?.enabled = false
        
        var newValue = !(self.isFollowing == true)
        NetworkManager.sharedInstance.updateFollowValue(newValue, user: self.user!) { (error) -> () in
            
            self.followButton?.enabled = true
            
            var image = (newValue == true) ? UIImage(named: "UnfollowButton") : UIImage(named: "FollowButton")
            self.followButton?.setImage(image, forState: .Normal)
            
            self.isFollowing = newValue
        }
    }
    
}
