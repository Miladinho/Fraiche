//
//  MarketViewController.swift
//  Fraiche
//
//  Created by Milad  on 11/22/16.
//  Copyright © 2016 Milad . All rights reserved.
//

import UIKit

class MarketViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    fileprivate var posts : Array<Post>!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var loadingView : UIView!
    var actInd : UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadingView = UIView()
        loadingView!.frame = CGRect(x: 0,y: 0, width: 100, height: 80)
        loadingView?.center = view.center
        loadingView?.alpha = 0.6
        loadingView?.backgroundColor = UIColor.black
        loadingView.layer.cornerRadius = 10
        loadingView.isHidden = true
        view.addSubview(loadingView)
        
        actInd = UIActivityIndicatorView(frame: CGRect(x: 0,y: 0, width: 150, height: 150)) as UIActivityIndicatorView
        actInd.center = self.view.center
        actInd.hidesWhenStopped = true
        actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        view.addSubview(actInd)

        self.navigationItem.title = "Market"
        
        loadMarketplaceData()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadMarketplaceData() {
        var bt = UIBackgroundTaskInvalid
        bt = UIApplication.shared.beginBackgroundTask(expirationHandler: {
            ()->Void in
            UIApplication.shared.endBackgroundTask(bt)
            bt = UIBackgroundTaskInvalid
        })
        
        PostsManager.readPostsWithHandler{
            (posts : Array<Post>?, error: AnyObject?) in
            
            self.posts = posts
            
            DispatchQueue.main.async(execute: {
                () -> Void in
                
                self.tableView.reloadData()
                print("loaded in background")
                
            })
        }
        UIApplication.shared.endBackgroundTask(bt)
        bt = UIBackgroundTaskInvalid
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let posts = posts {
            return posts.count
            
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let post : Post = self.posts[(indexPath as NSIndexPath).row]
        
        cell.textLabel?.text = post.cTitle
        cell.detailTextLabel?.text = post.cDescription
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let contact = UITableViewRowAction(style: .normal, title: "Contact") { action, index in
            
            let post : Post = (self.posts?[indexPath.row])!
            
            let user = User()
            user.cId = post.cUserId
            
            self.loadingView.isHidden = false
            self.actInd.startAnimating()
            UsersManager.getUser(user, withHandler: {
                (success,user) -> () in
                
                let alert : UIAlertController = UIAlertController(title: "Contact Info", message: "Message", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Got it!", style: UIAlertActionStyle.default) { (_) in
                    self.loadingView.isHidden = true
                    self.actInd.stopAnimating()
                })
                
                if success {
                    alert.message = "Contact \(user!.cFullname!) at \(user!.cEmail!)"
                    self.present(alert, animated: true, completion: nil)
                } else {
                    print("failed data load for user contact info")
                    alert.message = "Unable to retrieve contact info for this post :("
                    self.present(alert, animated: true, completion: nil)
                }
            })

            
        }
        return [contact]
    }

}
