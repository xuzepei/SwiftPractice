//
//  Tool.swift
//  SwiftPractice
//
//  Created by xuzepei on 16/6/20.
//  Copyright © 2016年 xuzepei. All rights reserved.
//

import UIKit

class Tool {
    
    static let sharedInstance = Tool()
    
    class func documentDirectory() -> String {
        
        return NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0];
    }
    
    class func md5(sourceString:String?) -> String {
        
        if let data = sourceString?.dataUsingEncoding(NSUTF8StringEncoding) {
            
            var digest = [UInt8](count: Int(CC_MD5_DIGEST_LENGTH), repeatedValue: 0)
            CC_MD5(data.bytes, CC_LONG(data.length), &digest)
            
            var digestHex = ""
            for index in 0..<Int(CC_MD5_DIGEST_LENGTH) {
                digestHex += String(format: "%02x", digest[index])
            }
            
            return String(digest).lowercaseString
        }

        return ""
    }
    
    class func showAlert(title:String?, message:String?) {
        
        let alert = UIAlertView(title: title, message: message
            , delegate: nil, cancelButtonTitle: "OK")
        alert.tag = 110
        alert.show()
    }
    
    //MARK: - Parser
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
    
    //MARK: - Networking
    class func isReachableViaInternet() -> Bool {
        
        let reaching = Reachability.reachabilityForInternetConnection()
        let networkStatus: Int = reaching.currentReachabilityStatus().rawValue
        return networkStatus != 0
    }
    
    class func isReachableViaWifi() -> Bool {
        let reaching = Reachability.reachabilityForInternetConnection()
        let networkStatus: Int = reaching.currentReachabilityStatus().rawValue
        return networkStatus == 1
    }

    //MARK: - File Manager
    class func isExistingFile(path: String) -> Bool {
        return NSFileManager.defaultManager() .fileExistsAtPath(path)
    }
    
    class func saveImage(imageData: NSData!, imageUrl: String!) -> Bool {
        
        if imageUrl.characters.count <= 0 {
            return false
        }
        
        let directoryPath = NSTemporaryDirectory() + "/images/"
        if Tool.isExistingFile(directoryPath) == false {
            
            do {
                try NSFileManager.defaultManager().createDirectoryAtPath(directoryPath, withIntermediateDirectories: false, attributes: nil)
            } catch {
                return false
            }
        }
        
//        var suffix = "";
//        var range = imageUrl.rangeOfString(".", options: NSStringCompareOptions.BackwardsSearch, range: nil, locale: nil)
//        if let range = range where range.count <= 4 {
//            suffix = imageUrl.substringFromIndex(range.startIndex)
//        }
        
        if let savePath = Tool.getImageLocalPath(imageUrl) {
            return imageData.writeToFile(savePath, atomically: true)
        }
        
        return false
    }
    
    class func getImageLocalPath(imageUrl: String?) -> String? {
        
        if let imageUrl = imageUrl where imageUrl.characters.count > 0 {
            let directoryPath = NSTemporaryDirectory() + "/images/"
            let md5String = Tool.md5(imageUrl)
            return directoryPath + "\(md5String)"
        }

        return nil
    }
    
    class func getImageFromLocal(imageUrl: String?) -> UIImage? {
    
        if let imageLocalPath = Tool.getImageLocalPath(imageUrl) {
        
            if NSFileManager.defaultManager().fileExistsAtPath(imageLocalPath) {
                return UIImage(contentsOfFile: imageLocalPath)
            }
        }
        
        return nil
    }

    
}
