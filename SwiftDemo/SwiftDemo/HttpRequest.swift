

import UIKit

@objc protocol HttpRequestProtocol {
    @objc optional func willStartHttpRequest(_ token : Any)
    @objc optional func didFinishHttpRequest(_ token : Any)
    @objc optional func didFailHttpRequest(_ token : Any)
}

open class HttpRequest: NSObject{

    static let shared = HttpRequest()
    static let kHttpStatusCode = "http_status_code"
    
    var isRequesting = false
    var resultSelector : Selector? = nil
    var resultBlock: ((Dictionary<String, AnyObject>?) -> Void)? = nil
    var token : [String : Any]?
    var requestUrlString : String = ""
    var dataTask : URLSessionDataTask?
    var uploadTask : URLSessionUploadTask?
    weak var delegate : AnyObject?
    
    override init() {
    
    }
    
    init(delegate: AnyObject?) {
        self.delegate =  delegate
    }
    
    func get(_ urlString : String, resultBlock : @escaping ((Dictionary<String, AnyObject>?) -> Void), token : [String : Any]?) -> Bool {
    
        if urlString.count == 0 || self.isRequesting {
            return false
        }
        
        print("request-get:", urlString)
        
        self.resultBlock = resultBlock
        self.token = token
        self.requestUrlString = urlString
        
        let urlString = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!

        let request = NSMutableURLRequest()
        request.url = URL(string: urlString)
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        request.timeoutInterval = 20.0
        request.httpShouldHandleCookies = false
        request.httpMethod = "GET"
        request.setValue("*/*", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        //request.setValue(User.shared.authorization, forHTTPHeaderField: "Authorization")

        
        self.isRequesting = true

        
        let session = URLSession.shared
        self.dataTask = session.dataTask(
            with: request as URLRequest, completionHandler: { (data : Data?, response : URLResponse?, error : Error?) in
                
                if let requestError = error {
                    
                    print("Http request error:", requestError.localizedDescription)
                }
                
                if let httpURLResponse = response as? HTTPURLResponse {
                    
                    print("HTTP status code:", httpURLResponse.statusCode)
                }
                
                var dict: Dictionary<String, AnyObject>? = nil
                
                if let receivedData = data {
                    
                    //let jsonString = String(data: receivedData, encoding: String.Encoding.utf8) ?? ""
                    //debugPrint(jsonString)
                    
                    dict = Tool.parseToDictionary(jsonData: receivedData)
                    
                }
                
                self.dataTask = nil
                self.isRequesting = false
                
                DispatchQueue.main.async {
                    if let resultBlock = self.resultBlock {
                        resultBlock(dict)
                    }
                }
        })
        
        self.dataTask?.resume()
  
        return true
    }
    
    func post(_ urlString : String, resultBlock : @escaping ((Dictionary<String, AnyObject>?) -> Void), token : [String : Any]?) -> Bool {
        
        if urlString.count == 0 || self.isRequesting {
            return false
        }
        
        print("request-post:", urlString)
        
        self.resultBlock = resultBlock
        self.token = token
        self.requestUrlString = urlString
        
        let urlString = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!

        let request = NSMutableURLRequest()
        request.url = URL(string: urlString)
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        //request.timeoutInterval = 20.0
        request.httpShouldHandleCookies = false
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        //request.setValue(User.shared.authorization, forHTTPHeaderField: "Authorization")
        
        if let dataString = self.token?["bodyString"] as? String {
            request.httpBody = dataString.data(using: .utf8)
        } else {
            if let bodyData = self.token?["bodyData"] as? Data {
                request.httpBody = bodyData
            }
        }
        
        
        self.isRequesting = true
  
//        DispatchQueue.main.async(execute: {
//            UIApplication.shared.isNetworkActivityIndicatorVisible = true
//        })
        
        let session = URLSession.shared
        self.dataTask = session.dataTask(
            with: request as URLRequest, completionHandler: { (data : Data?, response : URLResponse?, error : Error?) in
                
                if let requestError = error {
                    
                    print("Http request error:", requestError.localizedDescription)
                }
                
                if let httpURLResponse = response as? HTTPURLResponse {
                    
                    print("HTTP status code:", httpURLResponse.statusCode)
                }
                
                var dict: Dictionary<String, AnyObject>? = nil
                
                if let receivedData = data {
                    
                    //jsonString = String(data: receivedData, encoding: String.Encoding.utf8) ?? ""
                    dict = Tool.parseToDictionary(jsonData: receivedData)
                    
                    debugPrint(dict)
                    
                }
                
                self.dataTask = nil
                self.isRequesting = false
                
                DispatchQueue.main.async {
                    if let resultBlock = self.resultBlock {
                        resultBlock(dict)
                    }
                }
        })
        
        self.dataTask?.resume()
        
        return true
        
    }
    
    func put(_ urlString : String, resultBlock : @escaping ((Dictionary<String, AnyObject>?) -> Void), token : [String : Any]?) -> Bool {
    
        if urlString.count == 0 || self.isRequesting {
            return false
        }
        
        print("request-put:", urlString)
        
        self.resultBlock = resultBlock
        self.token = token
        self.requestUrlString = urlString
        
        let urlString = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!

        let request = NSMutableURLRequest()
        request.url = URL(string: urlString)
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        request.timeoutInterval = 20.0
        request.httpShouldHandleCookies = false
        request.httpMethod = "PUT"
        request.setValue("*/*", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        //request.setValue(User.shared.authorization, forHTTPHeaderField: "Authorization")
        
        if let dataString = self.token?["bodyString"] as? String {
            request.httpBody = dataString.data(using: .utf8)
        } else {
            if let bodyData = self.token?["bodyData"] as? Data {
                request.httpBody = bodyData
            }
        }
        
        self.isRequesting = true
        
        let session = URLSession.shared
        self.dataTask = session.dataTask(
            with: request as URLRequest, completionHandler: { (data : Data?, response : URLResponse?, error : Error?) in
                
                if let requestError = error {
                    
                    print("Http request error:", requestError.localizedDescription)
                }
                
                if let httpURLResponse = response as? HTTPURLResponse {
                    
                    print("HTTP status code:", httpURLResponse.statusCode)
                }
                
                var dict: Dictionary<String, AnyObject>? = nil
                
                if let receivedData = data {
                    
                    //let jsonString = String(data: receivedData, encoding: String.Encoding.utf8) ?? ""
                    //debugPrint(jsonString)
                    
                    dict = Tool.parseToDictionary(jsonData: receivedData)
                    
                }
                
                self.dataTask = nil
                self.isRequesting = false
                
                DispatchQueue.main.async {
                    if let resultBlock = self.resultBlock {
                        resultBlock(dict)
                    }
                }
        })
        
        self.dataTask?.resume()
  
        return true
    }
    
    func refreshImage(_ urlString : String, resultBlock : @escaping ((Dictionary<String, AnyObject>?) -> Void), token : [String : Any]?) -> Bool {
    
        if urlString.count == 0 || self.isRequesting {
            return false
        }
        
        print("request-refresh_image:", urlString)
        
        self.resultBlock = resultBlock
        self.token = token
        self.requestUrlString = urlString
        
        let urlString = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!

        let request = NSMutableURLRequest()
        request.url = URL(string: urlString)
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        request.timeoutInterval = 20.0
        request.httpShouldHandleCookies = false
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        //request.setValue(User.shared.authorization, forHTTPHeaderField: "Authorization")
        
        self.isRequesting = true

//        DispatchQueue.main.async(execute: {
//            UIApplication.shared.isNetworkActivityIndicatorVisible = true
//        })
        
        let session = URLSession.shared
        self.dataTask = session.dataTask(
            with: request as URLRequest, completionHandler: { (data : Data?, response : URLResponse?, error : Error?) in
                
                
                var resultDict: Dictionary<String, AnyObject>? = nil
                
                if let requestError = error {
                
                    print("HTTP request error:", requestError.localizedDescription)
                }
                
                
                if let httpURLResponse = response as? HTTPURLResponse {
                    
                    print("HTTP status code:", httpURLResponse.statusCode)
                    
                    if httpURLResponse.statusCode == 200 {
                        
                        if let receivedData = data {
                            
                            if let jsonString = String(data: receivedData, encoding: String.Encoding.utf8) {
                                debugPrint(jsonString)
                            } else {

                                if let photo_id = self.token?["photo_id"] as? String {
                                    let filepath = Tool.documentDirectoryPath.appending("/\(photo_id).mp4")
                                    
                                    var dict = [String: AnyObject]()
                                    dict["result"] = "1" as AnyObject
                                    dict["filepath"] = filepath as AnyObject
                                    dict["photo_id"] = photo_id as AnyObject
                                    resultDict = dict
                                    
                                    if let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("/\(photo_id).mp4") {
                                        do {
                                            try receivedData.write(to: fileURL)
                                            print("Data written successfully to file!")
                                        } catch {
                                            print("Error writing data to file: \(error)")
                                        }
                                    }
                                }
                                
                            }
                        }
                    }
                }

                self.dataTask = nil
                self.isRequesting = false
                
                DispatchQueue.main.async {
                    
                    if let resultBlock = self.resultBlock {
                        resultBlock(resultDict)
                    }
                }
        })
        
        self.dataTask?.resume()
  
        return true
    }

    
    func downloadImage(_ urlString : String, token : [String : Any]?, result: ((Data?, NSDictionary?, Error?) -> Void)?) -> Bool {
    
        print("downloadImage:", urlString)
        
        //let urlString = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!

        if urlString.count == 0 || self.isRequesting {
            return false
        }
        
        self.token = token
        self.requestUrlString = urlString
        
        
        var request = URLRequest(url: URL(string: self.requestUrlString)!, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 5)
        request.httpShouldHandleCookies = false
        request.httpMethod = "GET"
        
        self.isRequesting = true
        

        let session = URLSession.shared
        self.dataTask = session.dataTask(
            with: request, completionHandler: { (data : Data?, response : URLResponse?, error : Error?) in
                
                let dict = NSMutableDictionary()
                
                if let requestError = error {
                    
                    print("Http request error:", requestError.localizedDescription)
                }
                
                if let httpURLResponse = response as? HTTPURLResponse {
                    
                    print("HTTP status code:", httpURLResponse.statusCode)
                    
                    dict.setValue("\(httpURLResponse.statusCode)", forKey: HttpRequest.kHttpStatusCode)
                }

                self.dataTask = nil
                self.isRequesting = false
                
                
                if result != nil {
                    
                    if let token = self.token {
                        dict.addEntries(from: token)
                    }
                    
                    DispatchQueue.main.async {
                        result!(data, dict, error)
                    }
                    
                }
        })
        
        self.dataTask?.resume()
        
        return true
    
    }

}
