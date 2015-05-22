//
//  SearchViewController.swift
//  Photog
//
//  Created by One Month on 9/17/14.
//  Copyright (c) 2014 One Month. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource
{
    @IBOutlet var searchBar: UISearchBar?
    @IBOutlet var tableView: UITableView?
    
    var searchResults = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        var nib = UINib(nibName: "PersonCell", bundle: nil)
        self.tableView?.registerNib(nib, forCellReuseIdentifier: "PersonCellIdentifier")
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar)
    {
        searchBar.text = ""
        
        self.searchResults = []
        self.tableView?.reloadData()
        
        searchBar.setShowsCancelButton(true, animated: true)
    }

    func searchBarTextDidEndEditing(searchBar: UISearchBar)
    {
        searchBar.setShowsCancelButton(false, animated: true)
    }

    func searchBarCancelButtonClicked(searchBar: UISearchBar)
    {
        searchBar.resignFirstResponder()
    }

    func searchBarSearchButtonClicked(searchBar: UISearchBar)
    {
        searchBar.resignFirstResponder()
        
        var searchTerm = searchBar.text
        
        NetworkManager.sharedInstance.findUsers(searchTerm, completionHandler: {
            (objects, error) -> () in
            
            if let constObjects = objects
            {
                self.searchResults = constObjects
                self.tableView?.reloadData()
            }
            else if let constError = error
            {
                self.showAlert("Unable to conduct search")
            }
        })
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.searchResults.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("PersonCellIdentifier") as! PersonCell
        var user = self.searchResults[indexPath.row] as! PFUser
        
        cell.user = user
        
        return cell
    }
    
}
