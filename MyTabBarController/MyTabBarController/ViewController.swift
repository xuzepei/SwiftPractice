//
//  ViewController.swift
//  MyTabBarController
//
//  Created by xuzepei on 2023/7/27.
//

import UIKit

class ViewController: UIViewController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setup()
    }

    func setup() {
        
        let tabBarController = MyTabBarController()
        
        tabBarController.delegate = self

        let vc1 = UIViewController()
        vc1.view.backgroundColor = .red
        //vc1.tabBarItem = UITabBarItem(title: "Case", image: UIImage(named: "case"), tag: 0)
        vc1.title = "Case"

        
        let vc2 = UIViewController()
        vc2.view.backgroundColor = .white
        //vc2.tabBarItem = UITabBarItem(title: "Workspace", image: UIImage(named: "app"), tag: 1)
        vc2.title = "Workspace"
        
        let vc3 = UIViewController()
        vc3.view.backgroundColor = .blue
        //vc3.tabBarItem = UITabBarItem(title: "Notification", image: UIImage(named: "bell3"), tag: 2)
        //vc3.tabBarItem.badgeValue = "3"
        vc2.title = "Notification"
        
        let vc4 = UIViewController()
        vc4.view.backgroundColor = .purple
        vc4.tabBarItem = UITabBarItem(title: "Me", image: UIImage(named: "user"), tag: 3)

        let viewControllers = [vc1, vc2, vc3, vc4]
        
        tabBarController.viewControllers = viewControllers
        
        addChild(tabBarController)
        view.addSubview(tabBarController.view)
        tabBarController.didMove(toParent: self)
        
        tabBarController.selectedIndex = 1
        tabBarController.tabBar.isHidden = true
        tabBarController.tabBar.tintColor = .green
        tabBarController.tabBar.backgroundColor = .yellow
        
        
        tabBarController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tabBarController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tabBarController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tabBarController.view.topAnchor.constraint(equalTo: view.topAnchor),
            tabBarController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        
    }

}

