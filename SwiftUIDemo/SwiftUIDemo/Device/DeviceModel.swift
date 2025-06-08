//
//  Device.swift
//  PandaUnion
//
//  Created by xuzepei on 2025/6/5.
//

import UIKit


struct Device {
    
    var data: Dictionary<String,AnyObject>? = nil
    var number: String = ""
    var name: String = ""
    var registerTime = ""
    var lifeTime = "" //保修时间
    var expireTime = ""
    var activeTime = ""
    var status: Int = -1
    var isEndUser: Bool = false
    var encryptType: Int = -1 //1是未加密  2是加密
    var scanType = ""
    var ownerType = "" //owner  auth
    var memo = ""
    var region = ""
    
    var authorizationData: Dictionary<String,AnyObject>? = nil
    var authorizationId = ""
    var authorizedUserName = ""
    var authorizedUserId = ""
    var authorizationTime = ""
    var authorizationExpireTime = ""
    var authorizedUserPhone = ""
    var authorizedUserEmail = ""
    var userId = ""
    
    init(data: Dictionary<String, AnyObject>? = nil) {
        self.data = data

        if let temp = data?["number"] as? String, temp.count > 0 {
            number = temp
        }
        
        if let temp = data?["name"] as? String, temp.count > 0 {
            name = temp
        }
        
        if let temp = data?["registTime"] as? String, temp.count > 0 {
            registerTime = temp
        } else if let temp = data?["registTime"] as? NSNumber {
            let strValue = temp.stringValue
            if !strValue.isEmpty {
                registerTime = strValue
            }
        }
        
        if let temp = data?["activeTime"] as? String, temp.count > 0 {
            activeTime = temp
        } else if let temp = data?["activeTime"] as? NSNumber {
            let strValue = temp.stringValue
            if !strValue.isEmpty {
                activeTime = strValue
            }
        }
        
        if let temp = data?["lifeTime"] as? String, temp.count > 0 {
            lifeTime = temp
        } else if let temp = data?["lifeTime"] as? NSNumber {
            let strValue = temp.stringValue
            if !strValue.isEmpty {
                lifeTime = strValue
            }
        }
        
        if let temp = data?["expireTime"] as? String, temp.count > 0 {
            expireTime = temp
        } else if let temp = data?["expireTime"] as? NSNumber {
            let strValue = temp.stringValue
            if !strValue.isEmpty {
                expireTime = strValue
            }
        }
        
        if let temp = data?["status"] as? NSNumber {
            status = temp.intValue
        }
        
        if let temp = data?["isEndUser"] as? NSNumber {
            isEndUser = temp.boolValue
        }
        
        if let temp = data?["encryptType"] as? NSNumber {
            encryptType = temp.intValue
        }
        
        if let temp = data?["scanType"] as? String, temp.count > 0 {
            scanType = temp
        }
        
        if let temp = data?["ownerType"] as? String, temp.count > 0 {
            ownerType = temp
        }
        
        if let temp = data?["memo"] as? String, temp.count > 0 {
            memo = temp
        }
        
        if let temp = data?["region"] as? String, temp.count > 0 {
            region = temp
        }
    }
    
    
    func getExpirationDateText() -> String {
         
        return "2025-06-08"
    }
    
    func getExpirationTip() -> (String, UIColor)? {
        return ("Expired", .red)
    }
    

}

class DeviceModel: ObservableObject {
    @Published var devices:[Device] = []
    @Published var isLoading = false
    @Published var isLoadingMore = false
    @Published var errorMsg = ""
    @Published var lastItemIndex: Int = 9
    
    let pageItemCount: Int = 10
    var currentPageIndex: Int = 1
    var completion: (()->Void)? = nil

    func asyncFetch(listType: Int, keyword: String) async {
        await withCheckedContinuation { continuation in
            fetch(listType: listType, keyword: keyword) {
                continuation.resume()
            }
        }
    }
    
    func fetch(listType: Int, keyword: String, completion: @escaping () -> Void) {
        
        if self.isLoading == true {
            completion()
            return
        }
        
        if self.isLoadingMore == true {
            completion()
            return
        }
        
        self.completion = completion
        
        
        DispatchQueue.main.async {
            self.isLoading = true
            self.lastItemIndex = 9
        }
        
        var newDevices:[Device] = []
        for i in 1...10 {
            var d = Device()
            d.name = "测试设备 \(i)"
            d.number = String(i)
            newDevices.append(d)
        }

        handleFetchSucceeded(newDevices: newDevices)

    }
    
    func handleFetchSucceeded(newDevices: [Device]) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            
            self.devices.removeAll()
            self.devices.append(contentsOf: newDevices)
            self.sort()
            
            self.isLoading = false
            
            self.currentPageIndex = 1
            self.completion?()
        }
    }
    
    func handleFetchFailed(errorMsg: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.isLoading = false
            self.errorMsg = errorMsg
            self.completion?()
        }
    }
    
    func sort() {
        devices.sort { Int($0.number) ?? 0 < Int($1.number) ?? 0 }
    }
    
    func loadMore(listType: Int, keyword: String, completion: @escaping () -> Void) {
        
        if self.isLoading == true {
            completion()
            return
        }
        
        if self.isLoadingMore == true {
            completion()
            return
        }
        
        self.completion = completion
        
        DispatchQueue.main.async {
            self.isLoadingMore = true
            self.lastItemIndex = self.pageItemCount * (self.currentPageIndex + 1) - 1
        }

        var newDevices:[Device] = []
        for i in 1...10 {
            var d = Device()
            let j = self.currentPageIndex*10 + i
            d.name = "测试设备 \(j)"
            d.number = String(j)
            newDevices.append(d)
        }
                                
        handleLoadMoreSucceeded(newDevices: newDevices)

    }
    
    func handleLoadMoreSucceeded(newDevices: [Device]) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.devices.append(contentsOf: newDevices)
            self.sort()
            
            self.isLoadingMore = false
            self.currentPageIndex += 1
            self.completion?()
            
        }
    }
    
    func handleLoadMoreFailed(errorMsg: String) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.isLoadingMore = false
            self.errorMsg = errorMsg
            self.completion?()
        }
        
    }
}
