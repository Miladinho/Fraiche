//
//  ViewController.swift
//  Fraiche
//
//  Created by Milad  on 11/21/16.
//  Copyright © 2016 Milad . All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    var fbLoginButton : FBSDKLoginButton!
    var loginImageView : UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let h = self.view.frame.height
        let w = self.view.frame.width
        
        self.fbLoginButton = FBSDKLoginButton()
        self.fbLoginButton.frame = CGRect(x: 40.0, y: h-80.0, width: w-80.0, height: 40.0)
        self.fbLoginButton.readPermissions = ["public_profile", "email", "user_friends"]
        self.fbLoginButton.delegate = self
        self.view.addSubview(self.fbLoginButton)
        
        self.view.backgroundColor = UIColor.black
        
        let loginImage = UIImage(imageLiteralResourceName: "LoginIcon")
        self.loginImageView = UIImageView(image: loginImage)
        self.loginImageView.frame = CGRect(x: w*0.5, y: h*0.4, width: 100.0, height: 100.0)
        //self.view.addSubview(self.loginImageView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //self.navigationController?.navigationBar.isHidden = true
    }
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
        if (error != nil) {
            //errorMessageLabel.text = "\(error)"
            
        } else if(result.token != nil) {
            self.dismiss(animated: true, completion: nil)
            //var profileVC = ProfileViewController()
            //self.performSegue(withIdentifier: "loginToProfileSegue", sender: self)
            
        } else {
            //errorMessageLabel.text = "Unknown error occured"
        }
        
        
        //self.performSegue(withIdentifier: "loginToProfileSegue", sender: self)
        print("loginButton didCompleteWith \(error)")
        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
        
    }


}

