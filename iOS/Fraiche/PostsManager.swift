//
//  PostsManager.swift
//  Fraiche
//
//  Created by Milad  on 11/22/16.
//  Copyright © 2016 Milad . All rights reserved.
//

import Foundation

class PostsManager : ManagerBase {
    
    
    class func readPostsWithHandler(_ user: User? = nil, _ callback:@escaping (_ posts : Array<Post>?, _ error: AnyObject?)->()){
        var resourceURL : String!
        if user != nil {
            resourceURL = "posts/users/\(user!.cId!)"
        } else {
            resourceURL = "posts"
        }
        
        ServerAPIManager.sharedInstance.readResource(resourceURL) {
            (data, error) -> () in
            
            if error != nil{
                callback(nil, error)
            }else{
                var posts : Array<Post> = [Post]()
                print(data)
                if let items = data as? Array<NSDictionary> {
                    for item in items {
                        let post : Post = Post()
                        post.fromDictionary(item as! Dictionary<String, AnyObject>)
                        //print("post = \(post)")
                        posts.append(post)
                    }
                }
                callback(posts, nil)
            }
        }
    }
    
    class func deletePost(_ post: Post, withHandler callback:@escaping (_ success : Bool, _ post : Post?) -> Void){
        print("Post id = \(post.cId)")
        
        ServerAPIManager.sharedInstance.deleteResource("posts/\((post.cId?.intValue)!)", callback: {
            (data, error) -> () in
            
            if (error != nil) {
                callback(false, nil)
                
            }else{
                var posts : Array<Post> = [Post]()
                if let items = data as? Array<NSDictionary> {
                    for item in items {
                        let post : Post = Post()
                        post.fromDictionary(item as! Dictionary<String,AnyObject>)
                        posts.append(post)
                    }
                }
                callback(true, nil) //post[0] is out of range
            }
        })
    }
    
    class func createPost(_ post : Post, withHandler callback: @escaping (_ success : Bool, _ post: Post?) -> Void){
        
        let postData = post.toDictionary()
        
        // create the resource
        ServerAPIManager.sharedInstance.createResource("posts", data: postData) {
            (data, error) -> () in
            
            if error != nil{
                
                callback(false, nil)
                
            }else{
                var posts : Array<Post> = [Post]()
                if let items = data as? Array<NSDictionary> {
                    for item in items {
                        let post : Post = Post()
                        post.fromDictionary(item as! Dictionary<String,AnyObject>)
                        posts.append(post)
                    }
                }
                callback(true, nil) //post[0] is out of range
            }
        }
    }
    
    class func updatePost(_ post : Post, withHandler callback: @escaping (_ success : Bool, _ post: Post?) -> Void){
        
        let postData = post.toDictionary()
        
        // create the resource
        ServerAPIManager.sharedInstance.updateResource("posts/\(post.cId!.intValue)", data: postData) {
            (data, error) -> () in
            
            if error != nil{
                
                callback(false, nil)
                
            }else{
                var posts : Array<Post> = [Post]()
                if let items = data as? Array<NSDictionary> {
                    for item in items {
                        let post : Post = Post()
                        post.fromDictionary(item as! Dictionary<String,AnyObject>)
                        posts.append(post)
                    }
                }
                callback(true, nil) //post[0] is out of range
            }
        }
    }
    
    
}
