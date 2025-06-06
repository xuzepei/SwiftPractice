//
//  DeviceManagementViewController.swift
//  PandaUnion
//
//  Created by xuzepei on 2025/6/4.
//

import UIKit
import SwiftUI

class DeviceManagementViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let cv = DeviceManagementView()
        let hostingController = UIHostingController(rootView: cv)
        
        // 添加为子视图控制器
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)

        // 设置约束（或使用 frame）
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
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
