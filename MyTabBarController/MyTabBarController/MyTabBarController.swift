//
//  MyTabBarController.swift
//
//  Created by xuzepei on 2023/7/27.
//

import UIKit

class MyTabBarController: UITabBarController {
    
    var myTabBar: MyTabBar!
    
    let tabBarItemInfoArray = [
        ["index":"0","title":"Case","image":"case","selectedImage":"image0_selected"],["index":"1","title":"DSD","image":"app","selectedImage":"image1_selected"],
        ["index":"2","title":"Notification","image":"bell3","selectedImage":"image2_selected"],
        ["index":"3","title":"Me","image":"user","selectedImage":"image3_selected"],
    ]
    
    var tabBarItems = [MyTabBarItem]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setup()
    }
    
    func setup() {
        let nib = UINib(nibName: "MyTabBar", bundle: nil)
        self.myTabBar = nib.instantiate(withOwner: self, options: nil).first as? MyTabBar
        self.myTabBar.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.myTabBar)
        
        NSLayoutConstraint.activate([
            self.myTabBar.widthAnchor.constraint(equalToConstant: 300),
            self.myTabBar.heightAnchor.constraint(equalToConstant: 50),
            self.myTabBar.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.myTabBar.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -50)
        ])
        
        var index = 0
        for tabBarItemInfo in tabBarItemInfoArray {
            let nib = UINib(nibName: "MyTabBarItem", bundle: nil)
            if let myTabBarItem = nib.instantiate(withOwner: self, options: nil).first as? MyTabBarItem {
                myTabBarItem.translatesAutoresizingMaskIntoConstraints = false
                myTabBarItem.item = tabBarItemInfo
                myTabBarItem.button.tag = index
                myTabBarItem.button.addTarget(self, action: #selector(clickedTabBarItem(_:)), for: .touchUpInside)
                myTabBarItem.updateContent()
                self.myTabBar.stackView.addArrangedSubview(myTabBarItem)
                index = index + 1
                self.tabBarItems.append(myTabBarItem)
            }
        }
        
        self.view.layoutIfNeeded()
    }
    
    func updateContent() {
        
    }
    
    @objc func clickedTabBarItem(_ sender: Any) {
        
        if let button = sender as? UIButton {
            switch(button.tag) {
            case 0:
                self.selectedIndex = 0
                for (i, tabBarItem) in self.tabBarItems.enumerated() {
                    tabBarItem.updateContent(isSelected: (i == self.selectedIndex) ? true : false)
                }
            case 1:
                self.selectedIndex = 1
                for (i, tabBarItem) in self.tabBarItems.enumerated() {
                    tabBarItem.updateContent(isSelected: (i == self.selectedIndex) ? true : false)
                }
            case 2:
                self.selectedIndex = 2
                for (i, tabBarItem) in self.tabBarItems.enumerated() {
                    tabBarItem.updateContent(isSelected: (i == self.selectedIndex) ? true : false)
                }
            case 3:
                self.selectedIndex = 3
                for (i, tabBarItem) in self.tabBarItems.enumerated() {
                    tabBarItem.updateContent(isSelected: (i == self.selectedIndex) ? true : false)
                }
            case 4:
                self.selectedIndex = 4
                for (i, tabBarItem) in self.tabBarItems.enumerated() {
                    tabBarItem.updateContent(isSelected: (i == self.selectedIndex) ? true : false)
                }
            default:
                return
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
