import UIKit

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
