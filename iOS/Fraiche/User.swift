//
//  Users.swift
//  Fraiche
//
//  Created by Milad  on 11/22/16.
//  Copyright © 2016 Milad . All rights reserved.
//

import Foundation


class Users : ModelBase {
    var cId : NSNumber? // this is a dummy because neither Int? not NSNumber? would work...wtf!
    var cName : String?
    var cMessage : String?
    var cMessageDate : String?
    
    
    override func objectMapping() -> Dictionary<String, String>{
        
        let objecMapping = [
            "cId":"id",
            "cName":"name",
            "cMessage":"message",
            "cMessageDate":"message_date"
        ]
        
        return objecMapping
        
    }
}
