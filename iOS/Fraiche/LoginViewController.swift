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
import CoreData

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    var fbLoginButton : FBSDKLoginButton!
    var loginImageView : UIImageView!
    
    // Core Data
    var managedObjectContext : NSManagedObjectContext!

    override func viewDidLoad() {
        super.viewDidLoad()

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.managedObjectContext = appDelegate.persistentContainer.viewContext
        
        let h = self.view.frame.height
        let w = self.view.frame.width
        
        self.fbLoginButton = FBSDKLoginButton()
        self.fbLoginButton.frame = CGRect(x: 40.0, y: h-80.0, width: w-80.0, height: 40.0)
        self.fbLoginButton.readPermissions = ["public_profile", "email", "user_friends"]
        self.fbLoginButton.delegate = self
        //self.view.addSubview(self.fbLoginButton)
        
        //self.view.backgroundColor = UIColor.black
        
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
            
            setupFbUser()
            
            
        } else {
            //errorMessageLabel.text = "Unknown error occured"
        }

        print("loginButton didCompleteWith \(error)")
        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("logged out")
    }

    func setupFbUser() {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"email,name"])
        graphRequest.start(completionHandler: {
            
            (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                print("****Error: \(error)")
            }
            else
            {
                let resultDict = result as! NSDictionary
                let user = User()
                
                print("fetched user: \(result)")
                
                let userName : NSString = resultDict.value(forKey: "name") as! NSString
                user.cFullname = userName as String
                print("User Name is: \(userName)")
                
                let userId : NSString = resultDict.value(forKeyPath: "id") as! NSString
                user.cFacebookId = userId as String
                print("User Id is: \(userId)")
                
                if resultDict.value(forKeyPath: "email") == nil {
                    print("email is nil")
                    user.cEmail = "no email"
                } else {
                    let userEmail : NSString = resultDict.value(forKeyPath: "email") as! NSString
                    print("User email is: \(userEmail)")
                    user.cEmail = userEmail as String
                }
                print("loginView fblogin setup user = \(user) fbid = \(user.cFacebookId)")
                self.validateUser(appUser: user)
            }
        })
    }
    
    func validateUser(appUser: User?) {
        print("validate user \(appUser)")
        if appUser != nil {
            UsersManager.authenticateUserWithHandler(appUser!, {
                (success, existingUser) -> () in
                
                if success {
                    self.storeUserInfoToCoreData(user: existingUser!)
                    self.dismiss(animated: true, completion: nil)
                } else {
                    UsersManager.createUser(appUser!, withHandler: {
                        (success,newUser) -> () in
                        
                        if success {
                            self.storeUserInfoToCoreData(user: newUser!)
                            self.dismiss(animated: true, completion: nil)
                        } else {
                            //errorMessageLabel.text = "Error creating user"
                            print("Error creating user")
                        }
                    })
                }
            })
        }
    }
    
    func storeUserInfoToCoreData(user: User) {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        
        do {
            let results = try managedObjectContext.fetch(fetchRequest)
            let users = results as! [NSManagedObject]

            if users.count > 0 {
                for user in users {
                    managedObjectContext.delete(user)
                }
                // do not add user to entity if it already exists
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return
        }
        
            
        let entity =  NSEntityDescription.entity(forEntityName: "User",in:managedObjectContext)
        
        let person = NSManagedObject(entity: entity!,insertInto: managedObjectContext)
        person.setValue(user.cFullname , forKey: "fullname")
        person.setValue(user.cEmail, forKey: "email")
        person.setValue(user.cId, forKey: "id")
        person.setValue(user.cFacebookId, forKey: "facebook_id")
        do {
            try self.managedObjectContext.save()
            print("saved user to Core Data")
            
        } catch let error as NSError  {
            print("Could not save user to Core Data\(error), \(error.userInfo)")
            
        }
    }
}

