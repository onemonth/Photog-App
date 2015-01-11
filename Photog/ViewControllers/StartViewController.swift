//
//  StartViewController.swift
//  Photog
//
//  Created by One Month on 9/7/14.
//  Copyright (c) 2014 One Month. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
        
    @IBAction func didTapSignIn(sender: AnyObject)
    {
        var viewController = AuthViewController(nibName: "AuthViewController", bundle: nil)
        viewController.authMode = .SignIn
        self.navigationController?.pushViewController(viewController, animated: true)
    }

    @IBAction func didTapSignUp(sender: AnyObject)
    {
        var viewController = AuthViewController(nibName: "AuthViewController", bundle: nil)
        viewController.authMode = .SignUp
        self.navigationController?.pushViewController(viewController, animated: true)
    }

}
