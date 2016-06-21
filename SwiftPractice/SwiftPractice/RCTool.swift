//
//  RCTool.swift
//  SwiftPractice
//
//  Created by xuzepei on 16/6/20.
//  Copyright © 2016年 xuzepei. All rights reserved.
//

import UIKit

class RCTool {
    
    static let sharedInstance = RCTool()
    
    class func writableDirectoryPath() -> String {
        
        return NSTemporaryDirectory();
    }
    
    class func md5(sourceString:String?) -> String {
        
        if let data = sourceString?.dataUsingEncoding(NSUTF8StringEncoding) {
            
            var digest = [UInt8](count: Int(CC_MD5_DIGEST_LENGTH), repeatedValue: 0)
            CC_MD5(data.bytes, CC_LONG(data.length), &digest)
            
            var digestHex = ""
            for index in 0..<Int(CC_MD5_DIGEST_LENGTH) {
                digestHex += String(format: "%02x", digest[index])
            }
            
            return String(digest)
        }

        return ""
    }
    
    class func parseToDictionary(jsonString:String?) -> [String:AnyObject]? {
        
        if let data = jsonString?.dataUsingEncoding(NSUTF8StringEncoding) {
            
            do {
                return try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions()) as? [String:AnyObject]
            } catch let error as NSError{
                print(error)
            }
        }
        
        return nil
    }
    
    class func parseToArray(jsonString:String?) -> [AnyObject]? {
    
        if let data = jsonString?.dataUsingEncoding(NSUTF8StringEncoding) {
        
            do {
                return try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions()) as? [AnyObject]
            } catch let error as NSError {
                print(error)
            }
        }
        
        return nil
    }
    
    class func showAlert(title:String?, message:String?) {
    
        let alert = UIAlertView(title: title, message: message
            , delegate: nil, cancelButtonTitle: "OK")
        alert.tag = 110
        alert.show()
    }
    
}
