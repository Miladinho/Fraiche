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
import CoreData
import CoreLocation
import MapKit


class ProfileViewController: UIViewController, FBSDKLoginButtonDelegate, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var addNewItemButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userLocationLabel: UILabel!
    
    var fbLoginButton : FBSDKLoginButton!
    
    var userPosts : [Post] = [Post]()
    
    var locationManager: CLLocationManager!
    var geocoder: CLGeocoder!
    // Core Data
    var managedObjectContext : NSManagedObjectContext!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 100.0  //meters
        locationManager.startUpdatingLocation()
        locationManager.requestWhenInUseAuthorization()
        
        self.fbLoginButton = FBSDKLoginButton()
        self.fbLoginButton.frame = CGRect(x: 20.0, y: 70.0, width: 100.0, height: 20.0)
        self.fbLoginButton.delegate = self
        self.view.addSubview(self.fbLoginButton)

        
        self.profileImageView.layer.borderWidth = 2
        //self.profileImageVie
        
        // Load user data from persistent storage
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.managedObjectContext = appDelegate.persistentContainer.viewContext
        
        // sets UsersManager.currentUser
        retrieveUserFromCoreData()
        self.navigationItem.title = UsersManager.currentUser.cFullname
        self.userEmailLabel.text = UsersManager.currentUser.cEmail
        
        print("viewDidLoad currentUser.cFacebookId = \(UsersManager.currentUser.cFacebookId)")
        if(/*FBSDKAccessToken.current() == nil*/ UsersManager.currentUser == nil) {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let loginViewController = storyBoard.instantiateViewController(withIdentifier: "loginViewController") as! LoginViewController
            self.present(loginViewController, animated:true, completion:nil)
            //return
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        // load currentUser's posts
        getUserPosts()
        
        // Query db to get updated User info to display on profile and cache
        // ex) if at login a new user was created, the user id value is returned as null, need to re authenticate to set this value
        print("current user = \(UsersManager.currentUser.cFullname)")
        UsersManager.authenticateUserWithHandler(UsersManager.currentUser, {
            (success, user) -> () in
            
            print("got results from user auth in profile")
            DispatchQueue.main.async(execute: {
                () -> Void in
                if success {
                    self.navigationItem.title = UsersManager.currentUser.cFullname
                    self.userEmailLabel.text = UsersManager.currentUser.cEmail
                    UsersManager.currentUser = user
                } else {
                    // should always return success
                    // should log user out though in case of error, loggin back in will auth user with all user info
                    print("failed data load for profile")
                }
            })
        })

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
        
        print("loginButton didCompleteWith \(error)")
        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
        //self.performSegue(withIdentifier: "loginSegue", sender: self)
        let loginVC = LoginViewController()
        self.present(loginVC, animated: true, completion: nil)
    }
    
    func retrieveUserFromCoreData() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        
        do {
            let results = try managedObjectContext.fetch(fetchRequest)
            let users = results as! [NSManagedObject]
            for user in users {
                let appUser = User()
                appUser.cId = user.value(forKey: "id") as! NSNumber?
                appUser.cFullname = user.value(forKey: "fullname") as! String?
                appUser.cEmail = user.value(forKey: "email") as! String?
                appUser.cFacebookId = user.value(forKey: "facebook_id") as! String?
                UsersManager.currentUser = appUser
                print(" Retrieved user from core data \(UsersManager.currentUser.cId) -- \(UsersManager.currentUser.cFullname) -- \(UsersManager.currentUser.cFacebookId)")
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    func getUserPosts() {
        PostsManager.readPostsWithHandler(UsersManager.currentUser, {
            (posts : Array<Post>?, error: AnyObject?) -> () in
            
            self.userPosts = posts!
            
            DispatchQueue.main.async(execute: {
                () -> Void in
                
                self.tableView.reloadData()
                
            })
        })
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userPosts.count
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath)
        
        let post : Post = self.userPosts[(indexPath as NSIndexPath).row]
        
        cell.textLabel?.text = post.cTitle
        cell.detailTextLabel?.text = post.cDescription
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .default, title: "Delete") { action, index in
            
            let post : Post = (self.userPosts[indexPath.row])
            
            PostsManager.deletePost(post, withHandler: {success,error in
                
                DispatchQueue.main.async(execute: {
                    () -> Void in
                    self.userPosts.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    //self.tableView.reloadData()
                    
                })
                print("Done deleting.")
            })
            
        }
        
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { action, index in
            
            let post : Post = (self.userPosts[indexPath.row])
            
            PostsManager.updatePost(post, withHandler: {success,error in
                
                DispatchQueue.main.async(execute: {
                    () -> Void in
                    //self.userPosts.remove(at: indexPath.row)
                    let loginPageView = self.storyboard?.instantiateViewController(withIdentifier: "postViewController") as! PostViewController
                    self.navigationController?.pushViewController(loginPageView, animated: true)
                    self.tableView.reloadData()
                    
                })
                print("Done editing.")
            })
            
        }
        return [delete, edit]
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        DispatchQueue.main.async(execute: {
            () -> Void in
            if status == .authorizedWhenInUse {
                if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                    if CLLocationManager.isRangingAvailable() {
                        // geocode location and get city name from location
                        self.userLocationLabel.text = "got location"
                    }
                } else {
                    self.userLocationLabel.text = "location monitoring not available"
                }
            } else {
                self.userLocationLabel.text = "not authorized"
            }
        })
    }
    
    @IBAction func addNewItemButtonTouched(_ sender: AnyObject) {
        //self.performSegue(withIdentifier: "postItemSegue", sender: self)
        // action in story board
    }


    @IBAction func goToMarketButtonTouched(_ sender: AnyObject) {
        //self.performSegue(withIdentifier: "goToMarketSegue", sender: self)
        // action in storyboard
    }

}
