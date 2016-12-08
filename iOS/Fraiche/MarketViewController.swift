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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        let delete = UITableViewRowAction(style: .default, title: "Delete") { action, index in
            
            let post : Post = (self.posts?[indexPath.row])!
            
            PostsManager.deletePost(post, withHandler: {success,error in
                
                DispatchQueue.main.async(execute: {
                    () -> Void in
                    self.posts.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    //self.tableView.reloadData()
                    
                })
                print("Done deleting.")
            })
            
        }
        return [delete]
    }

}
