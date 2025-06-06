//
//  Device.swift
//  PandaUnion
//
//  Created by xuzepei on 2025/6/5.
//


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
    
    func isNotInCurrentRegion() -> Bool {
        
        if !User.shared.region.isEmpty {
            
            var userRegion = ""
            if User.shared.region == Region.OTHER {
                userRegion = "en"
            } else {
                userRegion = User.shared.region
            }
            
            if !self.region.isEmpty {
                if userRegion.lowercased() != self.region.lowercased() {
                    return true
                }
            }
        }
        
        return false
    }
    
    func getExpirationDateText() -> String {
        
        if Tool.isForever(dateStr: expireTime) {
            return LS("Permanent")
        }
        
        return Tool.getOnlyDateDes(expireTime)
    }
    
    func getExpirationTip() -> (String, UIColor)? {
        if Tool.isAfterNow(expireTime) {
           if !Tool.isMoreThan5Days(expireTime) {
               return (LS("About to expire"),.systemOrange)
           }
        } else {
            return (LS("Expired"),.systemRed)
        }
        
        return nil
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
        
        var urlString = UrlConfig.shared.getDeviceCoreUrl() + "/manageable"
        if listType == 1 {
            urlString = UrlConfig.shared.getDeviceCoreUrl() + "/auths"
        } else if listType == 2 {
            urlString = UrlConfig.shared.getDeviceCoreUrl() + "/usable"
        }
        
        
        var bodyDict = [String:Any]()
        bodyDict["pageIndex"] = 1
        bodyDict["pageSize"] = pageItemCount
        
        if listType == 1 {
            bodyDict["number"] = keyword
        } else {
            bodyDict["keyword"] = keyword
        }
        
        bodyDict["sorter"] = ["number":"ascend"]
        bodyDict["filter"] = [:]
        
        DispatchQueue.main.async {
            self.isLoading = true
            self.lastItemIndex = 9
        }

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: bodyDict)
            // Use jsonData for further processing
            let request = HttpRequest()
            let b = request.post(urlString, resultBlock: { [weak self] dict in

//                defer {
//                    completion()
//                }
                
                guard let self = self else {
                    return
                }
                
                if let dict {
                    
                    Logger.logRequestResult(dict)
                    
                    if let data = dict["data"] as? Dictionary<String, AnyObject> {
                        if let array = data["records"] as? Array<Dictionary<String, AnyObject>> {
                            self.currentPageIndex = 1
                            
                            var devices:[Device] = []
                            for temp in array {
                                let device = Device(data: temp)
                                devices.append(device)
                            }
                            
                            handleFetchSucceeded(newDevices: devices)
                            return
                        }
                    }
                }
                
                handleFetchFailed(errorMsg: Errors.default_error)
                
            }, token: ["bodyData": jsonData])
            
            if b == false {
                handleFetchFailed(errorMsg: Errors.default_error)
            }
            
        } catch {
            print(error.localizedDescription)
            handleFetchFailed(errorMsg: Errors.default_error)
            
        }

    }
    
    func handleFetchSucceeded(newDevices: [Device]) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            
            self.devices.removeAll()
            self.devices.append(contentsOf: newDevices)
            self.sort()
            
            self.isLoading = false
            self.completion?()
        }
    }
    
    func handleFetchFailed(errorMsg: String) {
        
        DispatchQueue.main.async {
            self.isLoading = false
            self.errorMsg = errorMsg
            self.completion?()
        }
        
    }
    
    func sort() {
        devices.sort { $0.registerTime > $1.registerTime }
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
        
        var urlString = UrlConfig.shared.getDeviceCoreUrl() + "/manageable"
        if listType == 1 {
            urlString = UrlConfig.shared.getDeviceCoreUrl() + "/auths"
        } else if listType == 2 {
            urlString = UrlConfig.shared.getDeviceCoreUrl() + "/usable"
        }
        
        
        var bodyDict = [String:Any]()
        bodyDict["pageIndex"] = self.currentPageIndex + 1
        bodyDict["pageSize"] = pageItemCount
        
        if listType == 1 {
            bodyDict["number"] = keyword
        } else {
            bodyDict["keyword"] = keyword
        }
        
        bodyDict["sorter"] = ["number":"ascend"]
        bodyDict["filter"] = [:]
        
        DispatchQueue.main.async {
            self.isLoadingMore = true
            self.lastItemIndex = self.pageItemCount * (self.currentPageIndex + 1) - 1
        }

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: bodyDict)
            // Use jsonData for further processing
            let request = HttpRequest()
            let b = request.post(urlString, resultBlock: { [weak self] dict in

//                defer {
//                    completion()
//                }
                
                guard let self = self else {
                    return
                }
                
                if let dict {
                    
                    Logger.logRequestResult(dict)
                    
                    if let data = dict["data"] as? Dictionary<String, AnyObject> {
                        if let array = data["records"] as? Array<Dictionary<String, AnyObject>> {
                            
                            if array.count > 0 {
                                self.currentPageIndex += 1
                                
                                var devices:[Device] = []
                                for temp in array {
                                    let device = Device(data: temp)
                                    devices.append(device)
                                }
                                
                                handleLoadMoreSucceeded(newDevices: devices)
                                return
                            }
                        }
                    }
                }
                
                handleLoadMoreFailed(errorMsg: Errors.default_error)
                
            }, token: ["bodyData": jsonData])
            
            if b == false {
                handleLoadMoreFailed(errorMsg: Errors.default_error)
            }
            
        } catch {
            print(error.localizedDescription)
            handleLoadMoreFailed(errorMsg: Errors.default_error)
            
        }

    }
    
    func handleLoadMoreSucceeded(newDevices: [Device]) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.devices.append(contentsOf: newDevices)
            self.isLoadingMore = false
            self.completion?()
            self.sort()
        }
    }
    
    func handleLoadMoreFailed(errorMsg: String) {
        
        DispatchQueue.main.async {
            self.isLoadingMore = false
            self.errorMsg = errorMsg
            self.completion?()
        }
        
    }
}
