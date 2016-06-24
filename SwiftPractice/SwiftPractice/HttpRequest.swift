//
//  HttpRequest.swift
//  SwiftPractice
//
//  Created by xuzepei on 16/6/22.
//  Copyright © 2016年 xuzepei. All rights reserved.
//

import UIKit

@objc protocol HttpRequestProtocol {
    optional func willStartRequest(token: AnyObject)
    optional func updatePercentage(percentage: Float, token: AnyObject)
    optional func didFinishRequest(result: AnyObject, token: AnyObject)
    optional func didFailRequest(token: AnyObject)
}

enum RequestMethod {
    case Get,Post
}

class HttpRequest: NSObject {
    
    //MARK:- Properties
    static let sharedInstance = HttpRequest()
    
    var url: String?
    weak var delegate: AnyObject?
    var completionClosure: ((result: AnyObject, httpStatusCode: Int, error: String) -> Void)?
    var token: AnyObject?
    var isConnecting = false
    var receivedData = NSMutableData()
    var connection: NSURLConnection?
    var statusCode = 0
    
    //MARK:- Methods
    func request(method: RequestMethod, url: String, token: AnyObject?, completion: ((result: AnyObject, httpStatusCode: Int, error: String) -> Void)?) -> Bool {
        
        if url.characters.count == 0 {
            return false
        }
        
        self.url = url
        self.completionClosure = completion
        self.token = token
        
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.cachePolicy = .ReloadIgnoringCacheData
        request.timeoutInterval = 20
        request.HTTPShouldHandleCookies = false
        
        if method == .Get {
            
            request.HTTPMethod = "GET"
            
        } else if method == .Post {
            
            request.HTTPMethod = "POST"
            
            if let body = token as? String {
                request.HTTPBody = body.dataUsingEncoding(NSUTF8StringEncoding)
            }
            
        } else {
            return false
        }
        
        
        if let connection = NSURLConnection(request: request, delegate: self, startImmediately: true) {
            
            self.connection = connection
            self.isConnecting = true
            self.receivedData.length = 0
            
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            
            if true == self.delegate?.respondsToSelector(Selector("willStartRequest:")) {
                self.delegate?.willStartRequest!(self.token ?? "")
            }
        }
        
        return false
        
    }
    
    func cancel() {
        
        if let connection = self.connection {
            connection.cancel()
        }
        
    }
    
}

//MARK:- NSURLConnectionDelegate & NSURLConnectionDataDelegate
extension  HttpRequest: NSURLConnectionDelegate, NSURLConnectionDataDelegate {
    
    func connection(connection: NSURLConnection, didReceiveResponse response: NSURLResponse) {
        
        if let response = response as? NSHTTPURLResponse {
            
            self.statusCode = response.statusCode
        }
    }
    
    func connection(connection: NSURLConnection, didReceiveData data: NSData) {
        self.receivedData.appendData(data)
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection) {
        
        var jsonString: String?
        if self.statusCode == 200 {
            jsonString = NSString(data: self.receivedData, encoding: NSUTF8StringEncoding) as? String
        }
        
        self.isConnecting = false
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        self.receivedData.length = 0
        
        var result: AnyObject
        if let token = self.token {
            result = ["json":jsonString ?? "","token":token]
        } else {
            result = jsonString ?? ""
        }
        
        if true == self.delegate?.respondsToSelector(Selector("didFinishRequest:token:")) {
            self.delegate?.didFinishRequest!(jsonString ?? "", token: self.token ?? "")
        }
        
        if let completionClosure = self.completionClosure {
            completionClosure(result: result, httpStatusCode: self.statusCode, error: "")
        }
    }
    
    func connection(connection: NSURLConnection, didFailWithError error: NSError) {
        
        self.isConnecting = false
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        self.receivedData.length = 0
        
        if true == self.delegate?.respondsToSelector(Selector("didFailRequest:")) {
            self.delegate?.didFailRequest!(self.token ?? "")
        }
        
        if let completionClosure = self.completionClosure {
            
            completionClosure(result: "", httpStatusCode: self.statusCode, error: error.localizedDescription)
        }
        
    }
}
