//
//  NetworkManager.swift
//  Photog
//
//  Created by One Month on 9/14/14.
//  Copyright (c) 2014 One Month. All rights reserved.
//

import Foundation

typealias ErrorCompletionHandler = (error: NSError?) -> ()
typealias ObjectsCompletionHandler = (objects: [AnyObject]?, error: NSError?) -> ()
typealias ImageCompletionHandler = (image: UIImage?, error: NSError?) -> ()
typealias BooleanCompletionHandler = (isFollowing: Bool?, error: NSError?) -> ()

public class NetworkManager
{
    public class var sharedInstance: NetworkManager
    {
        struct Singleton
        {
            static let instance = NetworkManager()
        }
            
        return Singleton.instance
    }
    
    func follow(user: PFUser, completionHandler: ErrorCompletionHandler)
    {
        var relation = PFUser.currentUser().relationForKey("following")
        relation.addObject(user)
        PFUser.currentUser().saveInBackgroundWithBlock {
            (success, error) -> Void in
            
            completionHandler(error: error)
            
        }
    }
    
    func fetchFeed(completionHandler: ObjectsCompletionHandler)
    {
        var relation = PFUser.currentUser().relationForKey("following")
        var query = relation.query()
        query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]!, error: NSError!) -> Void in
            
            if let constError = error
            {
                println("error fetching following")
                completionHandler(objects: nil, error: constError)
            }
            else
            {
                println(objects)
                
                var postQuery = PFQuery(className: "Post")
                postQuery.whereKey("User", containedIn: objects)
                postQuery.orderByDescending("createdAt")
                postQuery.findObjectsInBackgroundWithBlock({ (objects: [AnyObject]!, error: NSError!) -> Void in

                    completionHandler(objects: objects, error: error)
                    
                })
            }
        }
    }

    func fetchImage(post: PFObject, completionHandler: ImageCompletionHandler)
    {
        var imageReference = post["Image"] as? PFFile
        if let constImageRef = imageReference
        {
            constImageRef.getDataInBackgroundWithBlock {
                (data, error) -> Void in
                
                if let constError = error
                {
                    println("Error fetching image \(constError.localizedDescription)")
                    completionHandler(image: nil, error: constError)
                }
                else
                {
                    let image = UIImage(data: data)
                    completionHandler(image:image, error: nil)
                }
            }
        }
    }
    
    func findUsers(searchTerm: String, completionHandler: ObjectsCompletionHandler)
    {
        var query = PFUser.query()
        query.whereKey("username", containsString: searchTerm)
        
        var descriptor = NSSortDescriptor(key: "username", ascending: false)
        query.orderBySortDescriptor(descriptor)
        
        query.findObjectsInBackgroundWithBlock {
            (objects, error) -> Void in
         
            completionHandler(objects: objects, error: error)

        }
    }
    
    func isFollowing(user: PFUser, completionHandler: BooleanCompletionHandler)
    {
        var relation = PFUser.currentUser().relationForKey("following")
        var query = relation.query()
        query.whereKey("username", equalTo: user.username)
        query.findObjectsInBackgroundWithBlock {
            (objects, error) -> Void in
            
            if let constError = error
            {
                println("error determining if currentUser follows other user")
                completionHandler(isFollowing: false, error: error)
            }
            else
            {
                var isFollowing = objects.count > 0
                completionHandler(isFollowing:isFollowing, error: nil)
            }
        }
    }
    
    func updateFollowValue(value: Bool, user: PFUser, completionHandler: ErrorCompletionHandler)
    {
        var relation = PFUser.currentUser().relationForKey("following")
        
        if value == true
        {
            relation.addObject(user)
        }
        else
        {
            relation.removeObject(user)
        }
        
        PFUser.currentUser().saveInBackgroundWithBlock {
            (success, error) -> Void in
            
            completionHandler(error: error)
        }
    }
    
    func fetchPosts(user: PFUser, completionHandler: ObjectsCompletionHandler)
    {
        var postQuery = PFQuery(className: "Post")
        postQuery.whereKey("User", equalTo: user)
        postQuery.orderByDescending("createdAt")
        postQuery.findObjectsInBackgroundWithBlock({ (objects: [AnyObject]!, error: NSError!) -> Void in
            
            completionHandler(objects: objects, error: error)
            
        })
    }
    
    func postImage(image: UIImage, completionHandler: ErrorCompletionHandler)
    {
        var imageData = UIImagePNGRepresentation(image) // returns NSData
        var imageFile = PFFile(name: "image.png", data: imageData)
        
        var post = PFObject(className: "Post")
        post["Image"] = imageFile
        post["User"] = PFUser.currentUser()
        
        post.saveInBackgroundWithBlock {
            (success, error) -> Void in
            
            if let constError = error
            {
                println("Error uploading post object")
            }
            
            completionHandler(error: error)
        }
    }
    
}