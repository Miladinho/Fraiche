//
//  ProfileViewController.swift
//  Fraiche
//
//  Created by Milad  on 11/22/16.
//  Copyright © 2016 Milad . All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit


class ProfileViewController: UIViewController, FBSDKLoginButtonDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    var fbLoginButton : FBSDKLoginButton!
    @IBOutlet weak var addNewItemButton: UIButton!

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fbLoginButton = FBSDKLoginButton()
        self.fbLoginButton.frame = CGRect(x: 20.0, y: 70.0, width: 100.0, height: 20.0)
        self.fbLoginButton.delegate = self
        self.view.addSubview(self.fbLoginButton)
        //self.navigationController?.navigationBar.tit
        
        self.profileImageView.layer.borderWidth = 2
        //self.profileImageVie
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if(FBSDKAccessToken.current() == nil){
            let loginVC = LoginViewController()
            self.present(loginVC, animated: true, completion: nil)
            return
        }
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
        
        print("loginButton didCompleteWith \(error)")
        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
        //self.performSegue(withIdentifier: "loginSegue", sender: self)
        let loginVC = LoginViewController()
        self.present(loginVC, animated: true, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5 // test
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        return []
    }
    
    @IBAction func addNewItemButtonTouched(_ sender: AnyObject) {
        //self.performSegue(withIdentifier: "postItemSegue", sender: self)
    }


    @IBAction func goToMarketButtonTouched(_ sender: AnyObject) {
        //self.performSegue(withIdentifier: "goToMarketSegue", sender: self)
    }

}
