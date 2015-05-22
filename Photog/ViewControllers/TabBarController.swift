//
//  TabBarController.swift
//  Photog
//
//  Created by One Month on 9/10/14.
//  Copyright (c) 2014 One Month. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    override func viewDidLoad()
    {
        super.viewDidLoad()

        var feedViewController = FeedViewController(nibName: "FeedViewController", bundle: nil)
        
        var profileViewController = ProfileViewController(nibName: "ProfileViewController", bundle: nil)
        profileViewController.user = PFUser.currentUser()
        
        var searchViewController = SearchViewController(nibName: "SearchViewController", bundle: nil)
        
        var cameraViewController = UIViewController()
        cameraViewController.view.backgroundColor = UIColor.purpleColor()
        
        var viewControllers = [feedViewController, profileViewController, searchViewController, cameraViewController]
        self.setViewControllers(viewControllers, animated: true)
        
        var imageNames = ["FeedIcon", "ProfileIcon", "SearchIcon", "CameraIcon"]
        
        let tabItems = tabBar.items as! [UITabBarItem]
        for (index, value) in enumerate(tabItems)
        {
            var imageName = imageNames[index]
            value.image = UIImage(named: imageName)
            value.imageInsets = UIEdgeInsetsMake(5.0, 0, -5.0, 0)
        }
        
        self.edgesForExtendedLayout = UIRectEdge.None
        self.navigationItem.hidesBackButton = true
        self.tabBar.translucent = false
        
        self.delegate = self
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .Done, target: self, action: "didTapSignOut:")
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
    
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationItem.title = "Photog"
    }
        
    func didTapSignOut(sender: AnyObject)
    {
        PFUser.logOut()
        
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool
    {
        var cameraViewController = self.viewControllers![3] as? UIViewController
        if viewController == cameraViewController
        {
            showCamera()
            return false
        }
        
        return true
    }
    
    func showCamera()
    {
        if !UIImagePickerController.isSourceTypeAvailable(.Camera)
        {
            self.showAlert("Camera is not available")
            return
        }
        
        var viewController = UIImagePickerController()
        viewController.sourceType = .Camera
        viewController.delegate = self
        
        self.presentViewController(viewController, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject])
    {
        var image: UIImage? = info[UIImagePickerControllerOriginalImage] as? UIImage
        if let constImage = image
        {
            var targetWidth = UIScreen.mainScreen().scale * UIScreen.mainScreen().bounds.size.width
            var resizedImage = constImage.resize(targetWidth)
            
            picker.dismissViewControllerAnimated(true, completion: {
                () -> Void in
                
                NetworkManager.sharedInstance.postImage(resizedImage, completionHandler: {
                    (error) -> () in
                    
                    if let constError = error
                    {
                        self.showAlert(constError.localizedDescription)
                    }
                })
                
            })
        }
        else
        {
            // Handle error
        }
    }
}
