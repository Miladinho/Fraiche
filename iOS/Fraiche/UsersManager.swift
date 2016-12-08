//
//  UsersManager.swift
//  Fraiche
//
//  Created by Milad  on 11/22/16.
//  Copyright © 2016 Milad . All rights reserved.
//

import Foundation

class UsersManager : ManagerBase {
    
    static var currentUser : User!
    
    class func authenticateUserWithHandler(_ user: User, _ callback:@escaping (_ authenticated: Bool, _ user : User?)->()){
        
        let userData = user.toDictionary()
        
        ServerAPIManager.sharedInstance.createResource("user/auth", data: userData) {
            (data,error) ->() in
            
            if error != nil{
                callback(false, nil)
            } else {
                if let data = data {
                    let user = getSingleUserFromData(data: data)
                    self.currentUser = user!
                    print("usermanager user: \(user?.cFacebookId)")
                    callback(true, user)
                } else {
                    callback(false, nil)
                }
            }
        }
    }
    
    class func createUser(_ user : User, withHandler callback: @escaping (_ success : Bool, _ user: User?) -> Void){
        
        let userData = user.toDictionary()
        
        // create the resource
        ServerAPIManager.sharedInstance.createResource("user/create/fb", data: userData) {
            (data, error) -> () in
            
            print(data as? Array<NSDictionary>)
            if error != nil{
                callback(false, nil)
            }else {
                if let data = data {
                    let user = getSingleUserFromData(data: data)
                    
                    self.currentUser = user!
                    print("usermanager user: \(user?.cFacebookId)")
                    callback(true, user)
                    
                }else{
                    callback(false,nil)
                }
            }
        }
        
    }
    
    class func getSingleUserFromData(data: AnyObject?) -> User? {
        var users : Array<User> = [User]()
        if let items = data as? Array<NSDictionary> {
            for item in items {
                let user : User = User()
                user.fromDictionary(item as! Dictionary<String,AnyObject>)
                users.append(user)
            }
            return users[0]
        }
        return nil
    }
}
