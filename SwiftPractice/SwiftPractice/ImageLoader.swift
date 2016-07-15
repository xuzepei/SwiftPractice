//
//  ImageLoader.swift
//  SwiftPractice
//
//  Created by xuzepei on 16/7/14.
//  Copyright © 2016年 xuzepei. All rights reserved.
//

import UIKit

@objc protocol ImageLoaderProtocol {

    optional func downloadedImageSuccessfully(imageUrl: String, token: AnyObject?)
    optional func failedToDownloadImage(imageUrl: String, token: AnyObject?)
}


class ImageLoader {
    
    static let sharedInstance = ImageLoader()
    var requestingUrls = Set<String>()
    var requestFailedUrls = Set<String>()
    
    func downloadImageByUrl(url: String?, completionWith: (image: UIImage?) -> Void) -> Bool {
        
        if let url = url where url.characters.count > 0 {
            
            if requestFailedUrls.contains(url) {
                return false
            }
            else {

                if let imageLocalPath = Tool.getImageLocalPath(url) {
                    if NSFileManager.defaultManager().fileExistsAtPath(imageLocalPath) {
                        completionWith(image: Tool.getImageFromLocal(url))
                        return true
                    }
                }
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
                    
                    if let imageData = NSData(contentsOfURL: NSURL(string: url)!) {
                        
                        if Tool.saveImage(imageData, imageUrl: url) {
                            dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                                completionWith(image: Tool.getImageFromLocal(url))
                            })
                        }
                        
                    } else {
                        dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                            completionWith(image: nil)
                        })
                    }
                })
                
                return true
            }
        }
        
        return false
    }
    
    func downloadImageByUrl(url: String?, delegate: ImageLoaderProtocol?, token: AnyObject? = nil) -> Bool {
    
        if let url = url where url.characters.count > 0 {
            
            if requestingUrls.contains(url) {
                return true
            }
            else if requestFailedUrls.contains(url) {
                return false
            }
            else {
                
                requestingUrls.insert(url)
                
                if let imageLocalPath = Tool.getImageLocalPath(url) {
                    if NSFileManager.defaultManager().fileExistsAtPath(imageLocalPath) {
                        
                        delegate?.downloadedImageSuccessfully?(url, token: token)
                        return true
                    }
                }
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
                    
                    if let imageData = NSData(contentsOfURL: NSURL(string: url)!) {

                        if Tool.saveImage(imageData, imageUrl: url) {
                            dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                                delegate?.downloadedImageSuccessfully?(url, token: token)
                            })
                        }
                        
                    } else {
                        dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                            delegate?.failedToDownloadImage?(url, token: token)
                        })
                    }
                })
                
                return true
            }
        }
        
        return false
    }
    
}