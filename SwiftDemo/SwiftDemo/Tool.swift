

//for md5
import var CommonCrypto.CC_MD5_DIGEST_LENGTH
import func CommonCrypto.CC_MD5
import typealias CommonCrypto.CC_LONG

import UIKit
import StoreKit
import AudioToolbox
import AVKit
import Photos
import Vision


enum Region {
    case Unknown
    case China
    case Europe
    case America
    case Other
}

enum Setting {
    case Notification
    case PrivacyPolicy
    case TermsOfUse
    case About
}

enum CellType: Int {
    case UserInfo = 0
    case Organization
    case OrganizationContact
}

@objcMembers class Tool: NSObject, AVAudioPlayerDelegate {
    
    @objc static let shared = Tool()
    
    //key
    static let updating_photo_key = "updating_photo_data"
    static let notification_filter_key = "notification_filter"
    
    //color
    static let textHighlightColor = UIColor(red: 0.34, green: 0.366, blue: 0.983, alpha: 1)
    static let navigationBarColor = UIColor(red:0.98, green:0.26, blue:0.59, alpha:1)
    static let navigationBarTitleColor = UIColor.white;
    static let tableViewCellSelectedColor = UIColor(red: 0, green: 0, blue: 1.0, alpha: 1.0)
    static let mainTextColor = UIColor(red:0.52, green:0.14, blue:0.91, alpha:1)
    static let subTitleColor = UIColor(red:0.72, green:0.56, blue:0.98, alpha:1)
    static let defaultImageColor = UIColor(red:0.85, green:0.85, blue:0.85, alpha:1)
    static let settingsTextColor = UIColor(red:0.52, green:0.14, blue:0.91, alpha:1)

    static let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
    
    var hud: MBProgressHUD? = nil
    var audioPlayer: AVAudioPlayer? = nil
    var completeBlock: (()->Void)? = nil
    
    class func md5(_ sourceString:String?) -> String {
        
        if let data = sourceString?.data(using: String.Encoding.utf8) {
            
            var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
            CC_MD5((data as NSData).bytes, CC_LONG(data.count), &digest)
            
            var digestHex = ""
            for index in 0..<Int(CC_MD5_DIGEST_LENGTH) {
                digestHex += String(format: "%02x", digest[index])
            }
            
            return String(describing: digest).lowercased()
        }

        return ""
    }
    
    class func showAlert(_ title:String?, message:String?, rootVC: UIViewController?) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
        })
        alert.addAction(action)
        
        var tempRootVC = rootVC
        if let tempRootVC {
            tempRootVC.present(alert, animated: true, completion: nil)
            return
        }
        
        if let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }),
           let temp = window.rootViewController {
            // 在这里使用rootVC
            tempRootVC = temp
        } else {
            // 如果没有找到key window，可以使用其他方式来获取根视图控制器
        }
        
        if let tempRootVC {
            tempRootVC.present(alert, animated: true, completion: nil)
        }
        
    }
    
    class func saveVideoToPhotoLibrary(videoURL: URL, rootVC: UIViewController?) {
        PHPhotoLibrary.shared().performChanges({
            let request = PHAssetCreationRequest.forAsset()
            request.addResource(with: .video, fileURL: videoURL, options: nil)
        }, completionHandler: { success, error in
            if success {
                print("Video saved to Photo Library successfully!")
                DispatchQueue.main.async {
                    Tool.showAlert("Success", message: "DSD AI video has benn saved to your Photo Library successfully.", rootVC: rootVC)
                }
                
            } else {
                
                let status = PHPhotoLibrary.authorizationStatus()
                switch status {
                case .authorized:
                    break
                case .denied, .restricted, .notDetermined:
                    // User has explicitly denied or restricted access.
                    DispatchQueue.main.async {
                        Tool.showAlert("Failed", message: "Please grant access to the Photo Library in Settings first.", rootVC: rootVC)
                    }
                    break
                default:
                    break
                }
                
                print("Error saving video to Photo Library: \(error?.localizedDescription ?? "unknown error")")
            }
        })
    }

    class func detectFaces(in image: UIImage, completion: @escaping (Bool) -> Void) {
        
        
#if targetEnvironment(simulator)
        completion(true)
#else
        guard let ciImage = CIImage(image: image) else {
            completion(false)
            return
        }
        
        let options = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
        let context = CIContext(options: nil)
        let detector = CIDetector(ofType: CIDetectorTypeFace, context: context, options: options)
        
        var result = false
        if let features = detector?.features(in: ciImage) {
            if features.isEmpty == false {
                result = true
            }
        }
        
        completion(result)
#endif
        

    }
    
    class func isCN() -> Bool {
        
        if let langCode = Locale.current.languageCode {
            
            if langCode == "zh" {
                return true
            }
        }
        
        return false
    }
    
    class func appVersion() -> String {
        
        // 获取应用程序信息
        let infoDict = Bundle.main.infoDictionary

        // 获取版本号和构建号
        let version = infoDict?["CFBundleShortVersionString"] as? String ?? ""
        
        return version
        
    }
    
    // 判断设备是否支持电话功能
    func canMakePhoneCall() -> Bool {
        if UIApplication.shared.canOpenURL(URL(string: "tel://")!) {
            // Device can make a phone call
            return true
        }
        
        return false
    }
    
    func getRootViewController() -> UIViewController? {
        if let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }),
           let rootVC = window.rootViewController {
            // 在这里使用rootVC
            return rootVC
        } else {
            // 如果没有找到key window，可以使用其他方式来获取根视图控制器
        }
        
        return nil
    }
    
    class func goToSettings() {
        
        if let url = URL(string: UIApplication.openSettingsURLString + Bundle.main.bundleIdentifier!) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    class func dateDescription(for date: Date) -> String {
        let calendar = Calendar.current
        let now = Date()
        
        // 检查是否为1分钟之内
        if calendar.isDate(date, equalTo: now, toGranularity: .minute) {
            return "Just now"
        }
        
        // 检查是否为今天
        if calendar.isDateInToday(date) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"  // 自定义时间格式，如 "HH:mm:ss" 表示带秒数的时间
            return dateFormatter.string(from: date)
        }
        
        // 检查是否为昨天
        if calendar.isDateInYesterday(date) {
            return "Yesterday"
        }
        
        // 检查是否为前天
//        if calendar.isDateInDayBeforeYesterday(date) {
//            return "前天"
//        }
        
        // 检查是否为本周内的其他天
        if calendar.isDate(date, equalTo: now, toGranularity: .weekOfYear) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE"  // 星期几的全名
            return dateFormatter.string(from: date)
        }
        
        // 其他情况直接返回日期的字符串表示
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd" // 自定义日期格式
        return dateFormatter.string(from: date)
    }
    
    class func dateDetailDescription(for date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm" // 自定义日期格式
        return dateFormatter.string(from: date)
    }
    
    class func dateFromString(_ dateString: String, format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: dateString)
    }
    
    //MARK: - Parser
    class func parseToDictionary(_ jsonString:String?) -> [String:AnyObject]? {
        
        if let data = jsonString?.data(using: String.Encoding.utf8) {
            
            do {
                return try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions()) as? [String:AnyObject]
            } catch let error as NSError{
                print(error)
            }
        }
        
        return nil
    }
    
    class func parseToDictionary(jsonData: Data?) -> [String : AnyObject]? {
        
        if let data = jsonData {
            
            do {
                return try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions()) as? [String : AnyObject]
            } catch let error as NSError{
                print(error)
            }
        }
        
        return nil
    }
    
    class func parseToArray(_ jsonString:String?) -> [AnyObject]? {
    
        if let data = jsonString?.data(using: String.Encoding.utf8) {
        
            do {
                return try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions()) as? [AnyObject]
            } catch let error as NSError {
                print(error)
            }
        }
        
        return nil
    }
    
    class func parseToArray(jsonData: Data?) -> [AnyObject]? {
        
        if let data = jsonData {
            
            do {
                return try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions()) as? [AnyObject]
            } catch let error as NSError {
                print(error)
            }
        }
        
        return nil
    }
    
    //MARK: - Networking
    class func isReachableViaInternet() -> Bool {
        
//        let reaching = Reachability.forInternetConnection()
//        let networkStatus: Int = reaching!.currentReachabilityStatus().rawValue
        return true
    }
    
    class func isReachableViaWifi() -> Bool {
//        let reaching = Reachability.forInternetConnection()
//        let networkStatus: Int = reaching!.currentReachabilityStatus().rawValue
        return true
    }

    //MARK: - File Manager
    class func isExistingFile(_ path: String) -> Bool {
        return FileManager.default .fileExists(atPath: path)
    }
    
    class func saveImage(_ imageData: Data?, imageUrl: String!) -> Bool {
        
        if imageData == nil {
            return false
        }
        
        if imageUrl.count <= 0 {
            return false
        }
        
        let directoryPath = documentDirectoryPath + "/images/"
        if Tool.isExistingFile(directoryPath) == false {
            
            do {
                try FileManager.default.createDirectory(atPath: directoryPath, withIntermediateDirectories: false, attributes: nil)
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
            return ((try? imageData!.write(to: URL(fileURLWithPath: savePath), options: [.atomic])) != nil)
        }
        
        return false
    }
    
    class func getImageLocalPath(_ imageUrl: String?) -> String? {
        
        if let imageUrl = imageUrl, imageUrl.count > 0 {
            let directoryPath = documentDirectoryPath + "/images/"
            let md5String = Tool.md5(imageUrl)
            return directoryPath + "\(md5String)"
        }

        return nil
    }
    
    class func getImageFromLocal(_ imageUrl: String?) -> UIImage? {
    
        if let imageLocalPath = Tool.getImageLocalPath(imageUrl) {
        
            if FileManager.default.fileExists(atPath: imageLocalPath) {
                return UIImage(contentsOfFile: imageLocalPath)
            }
        }
        
        return nil
    }
    
    class func hasNotch() -> Bool {
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone {
            
            let ratio = UIDevice.screenHeight / UIDevice.screenWidth
            
            if ratio > 2.1 && ratio < 2.3 {
                return true
            }
        }
        
        return false
    }
    
    class func isIpad() -> Bool {
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            return true
        }
        
        return false
    }
    
    class func image(name: String) -> UIImage? {
        
        if let image = UIImage(named: name) {
            return image
        }
        
        var oldName: NSString = NSString(string:name.replacingOccurrences(of: "@2x", with: ""))
        oldName = NSString(string:oldName.replacingOccurrences(of: "@3x", with: ""))
        
        var newName: NSString = NSString(string: oldName)
        if UIScreen.main.scale >= 2.0 {
            let range = oldName.range(of: ".", options: .backwards)
            if range.location != NSNotFound {
                
                let suffix = oldName.substring(from: range.location)
                let tempName = oldName.substring(to: range.location)
                if UIScreen.main.scale >= 3.0 {
                    newName = NSString(format: "%@@3x%@",tempName,suffix)
                }
                else if UIScreen.main.scale >= 2.0 {
                    newName = NSString(format: "%@@2x%@",tempName,suffix)
                }
            }
            else{
                if UIScreen.main.scale >= 3.0 {
                    newName = NSString(format: "%@@3x%@",oldName,".png")
                }
                else if UIScreen.main.scale >= 2.0 {
                    newName = NSString(format: "%@@2x%@",name,".png")
                }
            }
        }
        
        if let resourcePath = Bundle.main.resourcePath {
            //print("filePath: \(resourcePath)/images/\(deviceModel)/\(newName)")
            
            var filePath = resourcePath + "/images/\(newName)"
            if FileManager.default.fileExists(atPath: filePath) == true {
                return UIImage(contentsOfFile: filePath)
            }
            
            filePath = resourcePath + "/images/\(name)"
            if FileManager.default.fileExists(atPath: filePath) == true {
                return UIImage(contentsOfFile: filePath)
            }
            
        }

        return nil
    }
    
    class func imageFromColor(color: UIColor) -> UIImage? {
        
        let rect = CGRect(x: 0, y: 0, width: 40, height: 40)
        var image: UIImage? = nil
        
        UIGraphicsBeginImageContext(rect.size)
        if let context = UIGraphicsGetCurrentContext() {
            context.setFillColor(color.cgColor)
            context.fill(rect)
            image = UIGraphicsGetImageFromCurrentImageContext()
        }
        
        UIGraphicsEndImageContext()
        
        return image
    }
    
    class func systemRateUs() {
        
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
            
        } else {
            // Fallback on earlier versions
            // Try any other 3rd party or manual method here.
        }
        
    }
    
    
    @objc func showHUD(text: String, imageName:String, view: UIView, autoHideAfterDelay: TimeInterval, complete:@escaping ()->Void) {
        //let imageView = UIImageView(image: UIImage(named: "tick"))
        self.completeBlock = complete
        
        self.hud = MBProgressHUD.showAdded(to: view, animated: true)
        if let hud = self.hud {
            hud.mode = .customView
            hud.customView = UIImageView(image: UIImage(named: imageName))
            hud.label.text = text;
            
            if autoHideAfterDelay > 0 {
                hud.hide(animated: true, afterDelay: autoHideAfterDelay)
                
                let delayInSeconds: Double = autoHideAfterDelay // Delay for 2 seconds
                let dispatchTime = DispatchTime.now() + delayInSeconds

                DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
                    // Code to be executed after the delay
                    if let completeBlock = self.completeBlock {
                        completeBlock()
                    }
                }
            }
        }
        
    }
    
    @objc func playSoundEffect(_ type: Int) {
        
        #if targetEnvironment(simulator)
            return
        #endif
        
        var soundName = ""
        switch type {
        case 0:
            soundName = "click"
        case 1:
            soundName = "reward"
        case 2:
            soundName = "gift"
        case 3:
            soundName = "expand"
        case 4:
            soundName = "pop"
        case 5:
            soundName = "bucket"
        case 6:
            soundName = "bomb"
        default:
            break
        }
        
        if(soundName.count == 0) {
            return
        }
        
        if let soundUrl = Bundle.main.url(forResource: soundName, withExtension: "mp3") {
            var soundId: SystemSoundID = 0
            
            AudioServicesCreateSystemSoundID(soundUrl as CFURL, &soundId)
            
            AudioServicesAddSystemSoundCompletion(soundId, nil, nil, { (soundId, clientData) -> Void in
                AudioServicesDisposeSystemSoundID(soundId)
            }, nil)
            
            AudioServicesPlaySystemSound(soundId)
        }

    }
    
            func playBackgroundMusic() {
        
//        #if targetEnvironment(simulator)
//        return
//        #endif
        
        if let audioPlayer = self.audioPlayer {
            if audioPlayer.isPlaying {
                return
            }
        }
        
        let aSound = URL(fileURLWithPath:Bundle.main.path(forResource: "bgSoundIndex", ofType: "mp3")!)
        do {
            self.audioPlayer = try AVAudioPlayer(contentsOf: aSound)
            audioPlayer?.numberOfLoops = 0
            self.audioPlayer?.delegate = self
            
            #if targetEnvironment(simulator)
            #else
                audioPlayer?.play()
            #endif
            //if audioPlayer?.prepareToPlay() == true { //不能加这句
                //audioPlayer?.play()
            //}
            
        } catch {
            print("Cannot play the file")
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
        if(flag == true) {
            
            if let audioPlayer = self.audioPlayer {
                audioPlayer.stop()
                self.audioPlayer = nil
            }
            
            print("audioPlayerDidFinishPlaying")
            self.playBackgroundMusic()
        }
    }
    
    @objc func stopBackgroundMusic() {
        
        DispatchQueue.main.async {
            
            if let audioPlayer = self.audioPlayer {
                audioPlayer.stop()
                self.audioPlayer = nil
            }
        }

    }
    
    @objc func pauseBackgroundMusic() {
        
        DispatchQueue.main.async {
            
            if let audioPlayer = self.audioPlayer {
                audioPlayer.pause()
            }
        }
        
    }
    
    @objc func resumeBackgroundMusic() {
        
        DispatchQueue.main.async {
            
            if let audioPlayer = self.audioPlayer {
                audioPlayer.play()
            }
        }
        
    }
    
    @objc class func mergedImageWith(frontImage:UIImage, bgImage: UIImage) -> UIImage? {
        
        var size = bgImage.size
        size.height += frontImage.size.height + 50
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        
        bgImage.draw(in: CGRect.init(x: 0, y: frontImage.size.height + 50, width: bgImage.size.width, height: bgImage.size.height))
        frontImage.draw(in: CGRect.init(x: 0, y: 0, width: frontImage.size.width, height: frontImage.size.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    @objc class func getTextHeight(text:String?, font: UIFont?, width: CGFloat) -> CGFloat {
        
        guard let text = text else {
            return 0
        }
        
        if width == 0 {
            return 0
        }
        
        let font = font ?? UIFont.systemFont(ofSize: 18)
        
        let attributes: [NSAttributedString.Key: Any] = [.font: font]
        let attributedText = NSAttributedString(string: text, attributes: attributes)

        let maxSize = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let boundingRect = attributedText.boundingRect(with: maxSize, options: [.usesLineFragmentOrigin], context: nil)

        return ceil(boundingRect.height)
    }
}

//MARK: -
extension UIColor {
    
    class func color(_ hexString:String) -> UIColor {
        
        //var hexString:NSString = NSString(string: hexString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).uppercased())
        
        var hexString: NSString = NSString(string: hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased())
        
        // String should be 6 or 8 characters
        if hexString.length < 6 {
            return UIColor.clear
        }
        
        // strip 0X if it appears
        if hexString.hasPrefix("0X") || hexString.hasPrefix("0x"){
            hexString = hexString.substring(from: 2) as NSString
        }
        if hexString.hasPrefix("#") {
            hexString = hexString.substring(from: 1) as NSString
        }
        if hexString.length != 6 {
            return UIColor.clear
        }
        
        // Separate into r, g, b substrings
        var range = NSRange.init(location: 0, length: 2)
        
        //r
        let rString = hexString.substring(with: range)
        
        //g
        range.location = 2;
        let gString = hexString.substring(with: range)
        
        //b
        range.location = 4;
        let bString = hexString.substring(with: range)
        
        // Scan values 
        var r, g, b: UInt32
        r = 0; g = 0; b = 0
        
        Scanner.init(string: rString).scanHexInt32(&r);
        Scanner.init(string: gString).scanHexInt32(&g);
        Scanner.init(string: bString).scanHexInt32(&b);
      
        
        return UIColor(red: CGFloat(Double(r)/255.0), green: CGFloat(Double(g)/255.0), blue: CGFloat(Double(b)/255.0), alpha: 1.0)
    }
    
    
}

//MARK: -
extension Notification.Name {
    
    //接收到的通知消息
    static let NN_RECEIVED_MESG = Notification.Name("NN_RECEIVED_MESG")
    
    static let BannerLoaded = Notification.Name("BannerLoaded")
    static let AllItemsUpdated = Notification.Name("AllItemsUpdated")
    static let MostPopluarVideosUpdated = Notification.Name("MostPopluarVideosUpdated")
    static let ThisWeekVideosUpdated = Notification.Name("ThisWeekVideosUpdated")
    static let ProductLinesUpdated = Notification.Name("ProductLinesUpdated")
    
    static let RestorePurchase = Notification.Name("RestorePurchase")
    static let PrivacyPolicy = Notification.Name("PrivacyPolicy")
    static let TermsOfUse = Notification.Name("TermsOfUse")

    static let Refresh = Notification.Name("Refresh")
    static let RefreshTools = Notification.Name("RefreshTools") //bucket and search
    static let UpdatedContent = Notification.Name("UpdatedContent") //bucket and search
    static let EnterToPlay = Notification.Name("EnterToPlay") //enter to play
    static let ExpandWhenGuidanceShow = Notification.Name("ExpandWhenGuidanceShow") //expand item in home list when guidance is showing
    static let ClosedGuidance = Notification.Name("ClosedGuidance") //guidance closed
    static let ClosedGuidanceInGame = Notification.Name("ClosedGuidanceInGame") //guidance in game closed
    static let ClickedNextButtonToExpand = Notification.Name("ClickedNextButtonToExpand") //clicked next button to expand
    static let ClickedPurchaseFromAppstore = Notification.Name("PURCHASE_FROM_APPSTORE") //clicked purchase button from appstore
    static let UpdatedButtonStatesOfSubscriptionPage = Notification.Name("UpdatedButtonStatesOfSubscriptionPage") //update button states of subscription page
    static let PurchaseSuccessfully = Notification.Name("PurchaseSuccessfully") //purchase successfully
    
    static let ScrollToIndex = Notification.Name("ScrollToIndex") //scrollview go to index
    static let SelectionBarIndexChanged = Notification.Name("SelectionBarIndexChanged") //selection bar index changed
    static let LikeStatusChanged = Notification.Name("LikeStatusChanged") //like status changed
    
}

//MARK: -
extension UIImage {
    
    class func image(withColor color: UIColor, size: CGSize = CGSizeMake(1.0, 1.0)) -> UIImage? {
        
        var image: UIImage? = nil
        let imageRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        if let context = UIGraphicsGetCurrentContext() {
            
            context.setFillColor(color.cgColor)
            context.fill(imageRect)
            
            image = UIGraphicsGetImageFromCurrentImageContext()
        }
        
        UIGraphicsEndImageContext()
        
        return image
        
    }
    
    func withColor(_ color: UIColor) -> UIImage? {
        
        var image: UIImage? = nil
        let imageRect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        if let context = UIGraphicsGetCurrentContext() {
            
            context.scaleBy(x: 1.0, y: -1.0)
            context.translateBy(x: 0, y: -1 * self.size.height)
            
            context.clip(to: imageRect, mask: self.cgImage!)
            context.setFillColor(color.cgColor)
            context.fill(imageRect)

            image = UIGraphicsGetImageFromCurrentImageContext()
        }
        
        UIGraphicsEndImageContext()
        
        return image
        
    }
    
    func scaledToWidth(width: CGFloat) -> UIImage? {
        let oldWidth = self.size.width
        let scaleFactor = width / oldWidth
        
        let newHeight = self.size.height * scaleFactor
        let newWidth = oldWidth * scaleFactor
        
        UIGraphicsBeginImageContext(CGSize(width:newWidth, height:newHeight))
        self.draw(in: CGRect(x:0, y:0, width:newWidth, height:newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
//    func rotate(radians: Double) -> UIImage? {
//        var newSize = CGRect(origin: CGPoint.zero, size: self.size).applying(CGAffineTransform(rotationAngle: CGFloat(radians))).size
//        // Trim off the extremely small float value to prevent core graphics from rounding it up
//        newSize.width = floor(newSize.width)
//        newSize.height = floor(newSize.height)
//
//        UIGraphicsBeginImageContextWithOptions(newSize, true, self.scale)
//        let context = UIGraphicsGetCurrentContext()!
//        context.clear(CGRect(x:0, y:0, width: newSize.width, height: newSize.height))
//        context.setFillColor(UIColor.white.cgColor)
//        context.fill(CGRect(x:0, y:0, width: newSize.width, height: newSize.height))
//        // Move origin to middle
//        context.translateBy(x: newSize.width/2, y: newSize.height/2)
//        // Rotate around middle
//        context.rotate(by: CGFloat(radians))
//        // Draw the image at its center
//        self.draw(in: CGRect(x: -self.size.width/2, y: -self.size.height/2, width: self.size.width, height: self.size.height))
//
//        let newImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//
//        return newImage
//    }
    
    func rotate(_ radians: CGFloat) -> UIImage {
        let cgImage = self.cgImage!
        let LARGEST_SIZE = CGFloat(max(self.size.width, self.size.height))
        let context = CGContext.init(data: nil, width:Int(LARGEST_SIZE), height:Int(LARGEST_SIZE), bitsPerComponent: cgImage.bitsPerComponent, bytesPerRow: 0, space: cgImage.colorSpace!, bitmapInfo: cgImage.bitmapInfo.rawValue)!
        
        var drawRect = CGRect.zero
        drawRect.size = self.size
        let drawOrigin = CGPoint(x: (LARGEST_SIZE - self.size.width) * 0.5,y: (LARGEST_SIZE - self.size.height) * 0.5)
        drawRect.origin = drawOrigin
        var tf = CGAffineTransform.identity
        tf = tf.translatedBy(x: LARGEST_SIZE * 0.5, y: LARGEST_SIZE * 0.5)
        tf = tf.rotated(by: CGFloat(radians))
        tf = tf.translatedBy(x: LARGEST_SIZE * -0.5, y: LARGEST_SIZE * -0.5)
        context.concatenate(tf)
        context.draw(cgImage, in: drawRect)
        var rotatedImage = context.makeImage()!
        
        drawRect = drawRect.applying(tf)
        
        rotatedImage = rotatedImage.cropping(to: drawRect)!
        let resultImage = UIImage(cgImage: rotatedImage)
        return resultImage
    }

}

//MARK: -
extension UIView {
    
    func getX() -> CGFloat {
        return self.frame.origin.x
    }
    
    func getTrailingX() -> CGFloat {
        return self.frame.origin.x + self.frame.size.width
    }
    
    func setX(_ x: CGFloat) {
        var rect = self.frame
        rect.origin.x = x
        self.frame = rect
    }
    
    func getY() -> CGFloat {
        return self.frame.origin.y
    }
    
    func getBottomY() -> CGFloat {
        return self.frame.origin.y + self.frame.size.height
    }
    
    func setY(_ y: CGFloat) {
        var rect = self.frame
        rect.origin.y = y
        self.frame = rect
    }
    
    func width() -> CGFloat {
        return self.frame.size.width
    }
    
    func setWidth(_ width: CGFloat) {
        var rect = self.frame
        rect.size.width = width
        self.frame = rect
    }
    
    func height() -> CGFloat {
        return self.frame.size.height
    }
    
    func setHeight(_ height: CGFloat) {
        var rect = self.frame
        rect.size.height = height
        self.frame = rect
    }
    
    func findConstraint(targetName:String, attribute:String) -> NSLayoutConstraint? {
        for temp in self.constraints {
            
            if attribute == ".top" {
                if temp.firstAttribute != .top {
                    continue
                }
            }
            else if attribute == ".height" {
                if temp.firstAttribute != .height {
                    continue
                }
            }
            
            let description = temp.firstAnchor.description.lowercased() as NSString
            print(description)
            if description.range(of: targetName.lowercased()).location != NSNotFound && description.range(of: attribute).location != NSNotFound {
                return temp
            }
        }
        
        return nil
    }
    
    func cleanConstraints() {
        self.removeConstraints(self.constraints)
    }
}

//MARK: -
extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
    
    func isValidEmail() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: self)
    }
    
    func isValidPhoneNumber() -> Bool {
        let phoneRegex = #"^\+?\d{1,3}[- ]?\d{3,4}[- ]?\d{4}$"#
        let predicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return predicate.evaluate(with: self)
    }
}

//MARK: -
extension CALayer {
    
    func getX() -> CGFloat {
        return self.frame.origin.x
    }
    
    func setX(_ x: CGFloat) {
        var rect = self.frame
        rect.origin.x = x
        self.frame = rect
    }
    
    func getY() -> CGFloat {
        return self.frame.origin.y
    }
    
    func setY(_ y: CGFloat) {
        var rect = self.frame
        rect.origin.y = y
        self.frame = rect
    }
    
    func width() -> CGFloat {
        return self.frame.size.width
    }
    
    func setWidth(_ width: CGFloat) {
        var rect = self.frame
        rect.size.width = width
        self.frame = rect
    }
    
    func height() -> CGFloat {
        return self.frame.size.height
    }
    
    func setHeight(_ height: CGFloat) {
        var rect = self.frame
        rect.size.height = height
        self.frame = rect
    }
}

//MARK: -
extension UIViewController {
    
}

//MARK: -
extension NSMutableAttributedString {
    
    public func setAsLink(textToFind:String, linkURL:String) -> Bool {
        
        let foundRange = self.mutableString.range(of: textToFind)
        if foundRange.location != NSNotFound {
            self.addAttribute(.link, value: linkURL, range: foundRange)
            return true
        }
        return false
    }
}

//MARK: -
extension UIButton {
    func underline() {
//        guard let text = self.titleLabel?.text else { return }
//
//        let attributedString = NSMutableAttributedString(string: text)
//
//        var attrs : [NSAttributedString.Key : Any] = [
//            NSAttributedString.Key.font : UIFont(name: GlobalDefinitions.font_PressStart2P, size: Tool.valueForBoth(10,20)),
//            NSAttributedString.Key.foregroundColor : UIColor.red,
//            NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue
//        ]
//        attributedString.addAttributes(attrs, range: NSRange(location: 0, length: text.count))
//        self.setAttributedTitle(attributedString, for: .normal)
        
        let lineLayer = CALayer()
        lineLayer.frame = CGRect(x: 15, y: self.bounds.size.height - 9, width: self.bounds.size.width - 30, height: 1.5)
        lineLayer.backgroundColor = Tool.textHighlightColor.cgColor;
        self.layer.addSublayer(lineLayer)
    }
    
    func underlineFromRect(x: CGFloat, y: CGFloat, width: CGFloat) {
        //        guard let text = self.titleLabel?.text else { return }
        //
        //        let attributedString = NSMutableAttributedString(string: text)
        //
        //        var attrs : [NSAttributedString.Key : Any] = [
        //            NSAttributedString.Key.font : UIFont(name: GlobalDefinitions.font_PressStart2P, size: Tool.valueForBoth(10,20)),
        //            NSAttributedString.Key.foregroundColor : UIColor.red,
        //            NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue
        //        ]
        //        attributedString.addAttributes(attrs, range: NSRange(location: 0, length: text.count))
        //        self.setAttributedTitle(attributedString, for: .normal)
        
        let lineLayer = CALayer()
        lineLayer.frame = CGRect(x: x, y: y, width: width, height: 1)
        lineLayer.backgroundColor = Tool.mainTextColor.cgColor;
        self.layer.addSublayer(lineLayer)
    }
}

//MARK: -
extension UIDevice {
    
    static let assumedNavigationBarHeight:CGFloat = 44.0
    static let screenWidth = min(UIScreen.main.bounds.size.width,UIScreen.main.bounds.size.height)
    static let screenHeight = max(UIScreen.main.bounds.size.width,UIScreen.main.bounds.size.height)
    static let designSize = CGSize(width: 393.0, height: 852.0)
    static let widthRatio = screenWidth / designSize.width
    static let heightRatio = screenHeight / designSize.height
    
    class func safeDistance() -> (top:CGFloat, bottom:CGFloat) {
        
        if #available(iOS 13.0, *) {
            let scene = UIApplication.shared.connectedScenes.first
            guard let windowScene = scene as? UIWindowScene else {
                return (0,0)
            }
            
            guard let window = windowScene.windows.first else {
                return (0,0)
            }
            
            return (window.safeAreaInsets.top,window.safeAreaInsets.bottom)
        } else {
            
            guard let window = UIApplication.shared.windows.first else {
                return (0,0)
            }
            return (window.safeAreaInsets.top,window.safeAreaInsets.bottom)
        }
    }
    
    class func statusBarHeight() -> CGFloat {
        
        if #available(iOS 13.0, *) {
            let scene = UIApplication.shared.connectedScenes.first
            guard let windowScene = scene as? UIWindowScene else {
                return 0
            }
            
            guard let statusBarManager = windowScene.statusBarManager else {
                return 0
            }
            
            return statusBarManager.statusBarFrame.height
        } else {
            return UIApplication.shared.statusBarFrame.height
        }
    }
}

extension UINavigationController {
    func navigationBarHeight() -> CGFloat {
        return self.navigationBar.isHidden ? 0 : self.navigationBar.frame.height
    }
}

extension UILabel{
    public func typeText(_ content: String, typingSpeedPerChar: TimeInterval = 0.1, didResetContent:Bool = true, completeCallback:(()->Void)?) {
        if (didResetContent){
            self.text = ""
        }
        
        if content.count == 0{
            completeCallback?()
        }
        DispatchQueue.global(qos: .userInteractive).async {
            for character in content {
                DispatchQueue.main.async {
                    self.text = self.text! + String(character)
                }
                Thread.sleep(forTimeInterval: typingSpeedPerChar)
            }
            completeCallback?()
        }
    }
}

extension UIImageView {
    func load(url: String) {
        // 创建URLSession并加载网络图片
        print("loading image: \(url)")
        
        //先检查是否本地已经有
        if let image = Tool.getImageFromLocal(url) {
            //self.image = image
            
            UIView.transition(with: self,
                              duration: 0.3, // Set the desired duration for the animation
                              options: .transitionFlipFromTop,
                              animations: { [weak self] in
                                    self?.image = image
                              },
                              completion: nil)
            
            return
        }
        
        let imageUrl = URL(string: url)
        let task = URLSession.shared.dataTask(with: imageUrl!) { (data, response, error) in
            if let data = data {
                DispatchQueue.main.async {
                    // 将加载的图片设置为UIImageView的image
                    if let image = UIImage(data: data) {
                        
                        Tool.saveImage(data, imageUrl: url)
                        
                        UIView.transition(with: self,
                                          duration: 0.3, // Set the desired duration for the animation
                                          options: .transitionCrossDissolve,
                                          animations: { [weak self] in
                                                self?.image = image
                                          },
                                          completion: nil)
                        
                        //self.image = image
                    }
                }
            }
        }
        
        task.resume()
    }
}