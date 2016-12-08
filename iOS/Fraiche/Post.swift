//
//  Posts.swift
//  Fraiche
//
//  Created by Milad  on 11/22/16.
//  Copyright © 2016 Milad . All rights reserved.
//

import Foundation

class Posts : ModelBase {
    var cId : NSNumber? // this is a dummy because neither Int? not NSNumber? would work...wtf!
    var cTitle : String?
    var cDescription : String?
    var cUserId: NSNumber?
    
    
    override func objectMapping() -> Dictionary<String, String>{
        
        let objecMapping = [
            "cId":"id",
            "cTitle":"title",
            "cDescription":"description",
            "cUserId":"userId"
        ]
        
        return objecMapping
        
    }
}
