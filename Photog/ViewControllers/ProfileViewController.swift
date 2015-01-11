//
//  ProfileViewController.swift
//  Photog
//
//  Created by One Month on 9/18/14.
//  Copyright (c) 2014 One Month. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDataSource {

    var items = []
    var user: PFUser?
    
    @IBOutlet var tableView: UITableView?

    override func viewDidLoad()
    {
        super.viewDidLoad()

        var nib = UINib(nibName: "PostCell", bundle: nil)
        tableView?.registerNib(nib, forCellReuseIdentifier: "PostCellIdentifier")
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
    
        NetworkManager.sharedInstance.fetchPosts(self.user!, completionHandler: { (objects, error) -> () in
            
            if let constError = error
            {
                self.showAlert("Unable to fetch posts")
            }
            else
            {
                self.items = objects!
                self.tableView?.reloadData()
            }
            
        })
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("PostCellIdentifier") as PostCell
        var item = items[indexPath.row] as PFObject
        
        cell.post = item
        
        return cell
    }

}
