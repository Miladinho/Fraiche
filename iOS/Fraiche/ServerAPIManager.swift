//
//  ServerAPIManager.swift
//  Fraiche
//
//  Created by Milad  on 11/22/16.
//  Copyright © 2016 Milad . All rights reserved.
//

import Foundation

class ServerAPIManager : ManagerBase{
    
    static var instance : ServerAPIManager!
    
    //let baseUrl = "http://localhost:3000/api/1"
    let baseUrl = "http://ec2-35-163-70-242.us-west-2.compute.amazonaws.com/api/1"
    
    enum Resources : String {
        case Posts = "posts",
             Users = "users"
    }
    
    // Ideally, I should read the errors returned from the server instead of sending of checking for status code
    // so that the error message is correctley relayed from server to user
    
    static let sharedInstance = ServerAPIManager()
    
    func readResource(_ resource : String, callback:@escaping (_ data : AnyObject?, _ error: AnyObject?)->()) -> Void{
        
        
        let request : URLRequest = URLRequest(url: URL(string: "\(baseUrl)/\(resource)")!)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: {
            (data, response, error) -> Void in
            
            if error != nil {
                callback(nil, error as AnyObject?)
            } else {
                //test
                let json = NSString(data: data!, encoding: String.Encoding.utf8.rawValue /*String.Encoding.isoLatin1.rawValue*/)
                print("PRINTING DATA \(json)")
                
                if let data = data{
                    print("printing data from readResource \(data)")
                    let dict = self.convertJsonDataToDictionary(data)
                    print("print dict = \(dict)")
                    callback(dict as AnyObject?, nil)
                    
                }else{
                    
                    callback(nil, nil)
                    
                }
                
            }
            
        })
        task.resume()
    }
    
    func deleteResource(_ resource : String, callback:@escaping (_ data : AnyObject?, _ error: AnyObject?)->()) -> Void {
        
        var request = URLRequest(url: URL(string: "\(baseUrl)/\(resource)")!, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 30.0)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {
            (data, response, error) -> Void in
            
            print(error)
            print(response)
            print(data)
            
            if error != nil {
                callback(nil, error as AnyObject?)
            } else {
                let httpResponse = response as! HTTPURLResponse
                let statusCode = httpResponse.statusCode
                if let data = data {
                    if statusCode <= 204 { // 204 No Content - not good data or errors
                        print("deleteReource: \(resource) succeeded with status code \(statusCode)")
                        let dict = self.convertJsonDataToDictionary(data)
                        callback(dict as AnyObject?,nil)
                    }else{
                        print("deleteReource: \(resource) failed Request with status code \(statusCode)")
                        callback(nil,error as AnyObject?)
                        
                    }
                }
            }
            
        })
        
        task.resume()
    }
    
    func createResource(_ resource : String, data : Dictionary<String, AnyObject>, callback:@escaping (_ data : AnyObject?, _ error: AnyObject?)->()) -> Void{
        
        let postData = convertDictionaryToJsonData(data)
        
        var request = URLRequest(url: URL(string: "\(baseUrl)/\(resource)")!, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 30.0)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        
        let task = session.uploadTask(with: request as URLRequest, from: postData, completionHandler: {
            (data, response, error) -> Void in
            
            
            if error != nil {
                callback(nil, error as AnyObject?)
            } else {
                
                let httpResponse = response as! HTTPURLResponse
                let statusCode = httpResponse.statusCode
                
                if let data = data{
                    
                    //print("data = \(data)")
                    //let json = NSString(data: data, encoding: String.Encoding.utf8.rawValue /*String.Encoding.isoLatin1.rawValue*/)
                    //print("PRINTING DATA \(json)")
                    
                    if statusCode <= 204 { // 204 No Content - not good data or errors
                        //print("createReource: \(resource) succeeded with status code \(statusCode)")
                        let dict = self.convertJsonDataToDictionary(data)
                        //print("servermanagerapi dict = \(dict)")
                        callback(dict as AnyObject?,nil)
                        
                    }else{
                        print("createReource: \(resource) failed Request with status code \(statusCode)")
                        callback(nil,error as AnyObject?)
                    }
                    
                }else{
                    callback(nil, nil)
                }
            }
            
        }) 
        task.resume()
        
    }
    
    func updateResource(_ resource : String, data : Dictionary<String, AnyObject>, callback:@escaping (_ data : AnyObject?, _ error: AnyObject?)->()) -> Void{
        
        let postData = convertDictionaryToJsonData(data)
        
        var request = URLRequest(url: URL(string: "\(baseUrl)/\(resource)")!, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 30.0)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        
        let task = session.uploadTask(with: request as URLRequest, from: postData, completionHandler: {
            (data, response, error) -> Void in
            
            
            let httpResponse = response as! HTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if error != nil {
                callback(nil, error as AnyObject?)
            } else {
                if let data = data{
                    
                    //print("data = \(data)")
                    //let json = NSString(data: data, encoding: String.Encoding.utf8.rawValue /*String.Encoding.isoLatin1.rawValue*/)
                    //print("PRINTING DATA \(json)")
                    
                    if statusCode <= 204 { // 204 No Content - not good data or errors
                        print("updateReource: \(resource) succeeded with status code \(statusCode)")
                        let dict = self.convertJsonDataToDictionary(data)
                        //print("servermanagerapi dict = \(dict)")
                        callback(dict as AnyObject?,nil)
                        
                    }else{
                        print("updateReource: \(resource) failed Request with status code \(statusCode)")
                        callback(nil,error as AnyObject?)
                    }
                    
                }else{
                    callback(nil, nil)
                }
            }
            
        })
        task.resume()
        
    }
    
    func convertDataToString(_ inputData : Data) -> NSString?{
        
        let returnString = String(data: inputData, encoding: String.Encoding.utf8)
        //print(returnString)
        return returnString as NSString?
        
    }
    
    
    func convertDictionaryToJsonData(_ inputDict : Dictionary<String, AnyObject>) -> Data?{
        
        do{
            return try JSONSerialization.data(withJSONObject: inputDict, options:JSONSerialization.WritingOptions.prettyPrinted)
            
        }catch let error as NSError{
            print(error)
            
        }
        
        return nil
    }
    
    
    func convertJsonDataToDictionary(_ inputData : Data) -> Array<[String:AnyObject]>? {
        guard inputData.count > 1 else{ return nil }  // avoid processing empty responses
        
        do {
            return try JSONSerialization.jsonObject(with: inputData, options: []) as? Array<Dictionary<String, AnyObject>>
        }catch let error as NSError{
            print(error)
            
        }
        return nil
    }
    
    func convertJsonStringToDictionary(_ text: String) -> Array<Dictionary<String, AnyObject>>? {
        
        if let data = text.data(using: String.Encoding.utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? Array<Dictionary<String, AnyObject>>
            } catch let error as NSError {
                print(error)
            }
        }
        return nil
    }
}
