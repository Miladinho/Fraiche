//
//  Users.swift
//  Fraiche
//
//  Created by Milad  on 11/22/16.
//  Copyright © 2016 Milad . All rights reserved.
//

import Foundation


class User : ModelBase {
    var cId : NSNumber? // this is a dummy because neither Int? not NSNumber? would work...wtf!
    var cFullname : String?
    var cFacebookId : String?
    var cEmail : String?
    
    
    override func objectMapping() -> Dictionary<String, String>{
        
        let objecMapping = [
            "cId":"id",
            "cFullname":"fullname",
            "cFacebookId":"facebook_id",
            "cEmail":"email"
        ]
        
        return objecMapping
        
    }
}
