//
//  SwiftTool.swift
//  Test1
//
//  Created by xuzepei on 2023/5/17.
//

import UIKit
import SwiftSignalRClient

@objcMembers class SwiftTool: NSObject {
    
    @objc static let shared = SwiftTool()
    
    private var connection: HubConnection;
    private var isConnecting: Bool = false;
    
    deinit {
        connection.stop()
        isConnecting = false
    }
    
    override init() {
    
        let url = URL(string: "http://4134d577z4.zicp.vip:51930/dsdapi/hubs/notify")
        connection = HubConnectionBuilder(url: url!).withHttpConnectionOptions(configureHttpOptions: { httpConnectionOptions in
            httpConnectionOptions.accessTokenProvider = {
                
                if let temp = UserDefaults.standard.object(forKey: "access_token") as? NSDictionary {
                    if let accessToken = temp.object(forKey: "access_token") as? String {
                        return accessToken
                    }
                }
                
                return ""
            }
        }).withLogging(minLogLevel: .error).build()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func connect() {
        
        if isConnecting == true
        {
            return;
        }
        
        isConnecting = true
        
        NSLog("####SignalR: connect");
        connection.on(method: "Completed", callback: { (message: String) in
            NSLog("####SignalR: message from Completed callback: \(message)")
        })
        
        connection.start()
    }
    

    
    public func uploadImage(_ image: UIImage) {
        var semaphore = DispatchSemaphore (value: 0)
        
        let urlString = "http://172.58.168.91:5000/"
        var request = URLRequest(url: URL(string: urlString)!,timeoutInterval: Double.infinity)
        
        if let imageData = image.jpegData(compressionQuality: 1.0) {

            let base64String = imageData.base64EncodedString()
            
            let boundary = UUID().uuidString
            // Set Content-Type header
            let contentType = "multipart/form-data; boundary=\(boundary)"
            request.setValue(contentType, forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            
            var body = ""
            // Add image data to form field
            body += "--\(boundary)\r\n"
            body += "Content-Disposition: form-data; name=\"image\"; filename=\"example.jpg\"\r\n"
            body += "Content-Type: image/jpeg\r\n\r\n"
            body += "\(base64String)\r\n"

            // Add any additional form fields here...

            // Close the form data
            body += "--\(boundary)--"
            
            request.httpBody = body.data(using: .utf8)
            
        } else {
            
            //semaphore.signal()
            return
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
           guard let data = data else {
              print(String(describing: error))
              semaphore.signal()
              return
           }

            let fileManager = FileManager.default
            let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let filePath = documentsDirectory.appendingPathComponent("myFile2.mp4")

            do {
                // Write the data to the file path
                try data.write(to: filePath)
            } catch {
                print("Error writing to file: \(error)")
            }
           semaphore.signal()
        }

        task.resume()
        semaphore.wait()
    }
    
    private func createForm(for imageData: Data) -> Data {
        let boundary = UUID().uuidString

        var body = Data()
//        body.append("--\(boundary)\r\n")
//        body.append("Content-Disposition: form-data; name=\"image\"; filename=\"image.jpg\"\r\n")
//        body.append("Content-Type: image/jpeg\r\n\r\n")
//        body.append(imageData)
//        body.append("\r\n--\(boundary)--\r\n")

        return body
    }
}
