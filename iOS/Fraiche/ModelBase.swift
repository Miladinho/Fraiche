//
//  ModelBase.swift
//  Fraiche
//
//  Created by Milad  on 11/22/16.
//  Copyright © 2016 Milad . All rights reserved.
//

import Foundation

protocol ModelProtocol {
    // protocol definition goes here
    
    func objectMapping() -> Dictionary<String, String>
    
}

class ModelBase : NSObject {
    var name : String?
    var message : String?
    
    
    // overide from subclass
    func objectMapping() -> Dictionary<String, String>{
        let objecMapping = Dictionary<String, String>()
        return objecMapping
    }
}
