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
    var id : NSNumber?
    
    // overide from subclass
    func objectMapping() -> Dictionary<String, String>{
        let objecMapping = Dictionary<String, String>()
        return objecMapping
    }
    
    func fromDictionary(_ dict: Dictionary<String, AnyObject>, withRootNode rootNode: String){
        
        let propertyBag = dict[rootNode] as! Dictionary<String, AnyObject>
        
        fromDictionary(propertyBag)
        
    }
    
    func fromDictionary(_ dict : Dictionary<String, AnyObject>){
        
        // loop through each one of the mappings
        for (objectKey, jsonKey)  in self.objectMapping() {
            
            // set the value
            let jsonValue = dict[jsonKey]
            //print("Printing JSON value")
            //print(jsonKey)
            //print(objectKey)
            //let x = jsonValue as! Int
            // if it's NSNull type then just skip it
            if(jsonValue is NSNull){
                continue
            }
            
            self.setValue(jsonValue, forKey: objectKey )
            
        }
        
    }
    
    func toDictionary(withRootNode rootNode: String) -> Dictionary<String, AnyObject>{
        
        let propertyBag = toDictionary()
        
        return [rootNode: propertyBag as AnyObject]
        
    }
    
    
    func toDictionary() -> Dictionary<String, AnyObject>{
        
        var dictionary = Dictionary<String, AnyObject>()
        
        // loop through each one of the mappings
        for (objectKey, jsonKey)  in self.objectMapping() {
            
            // set the value
            let objValue = self.value(forKey: objectKey)
            
            // if it's NSNull type then just skip it
            if(objValue is NSNull){
                continue
            }
            
            dictionary[jsonKey] = objValue as AnyObject?
            
        }
        
        return dictionary
        
    }
}
