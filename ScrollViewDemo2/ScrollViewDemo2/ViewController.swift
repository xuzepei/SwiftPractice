//
//  ViewController.swift
//  ScrollViewDemo2
//
//  Created by xuzepei on 2023/6/21.
//

import UIKit

class ViewController: UIViewController {


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func clickedScrollView1(_ sender: Any) {
        
        let vc = ScrollView1Controller()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func clickedScrollView2(_ sender: Any) {
        
        let vc = ScrollView2Controller()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func clickedScrollView3(_ sender: Any) {
        
        let vc = ScrollView3Controller()
        self.navigationController?.pushViewController(vc, animated: true)
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
