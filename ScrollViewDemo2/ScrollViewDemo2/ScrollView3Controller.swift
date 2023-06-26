//
//  ScrollView3Controller.swift
//  ScrollViewDemo2
//
//  Created by xuzepei on 2023/6/25.
//

import UIKit

//用xib的方式，采用Content Layout Guide and Frame Layout Guide
class ScrollView3Controller: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var myLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.title = "Scroll View 3"
        view.backgroundColor = .white
        
        //Tip: It’s time for the most important configuration. The Equal Heights constraint of content view should have a priority 250 instead of 1000. This is because we will not need to force the height be as the screen.
        
        myLabel.text = "Unable to submit for verification\nThe following items are required to begin the verification process:\nYour app contains NSUserTrackingUsageDescription, which means you need to request permission to track users. To submit for verification, update your app Privacy response to indicate that the data collected by this app will be used for monitoring purposes, or update your app's binary code and upload a new build.Unable to submit for verification\nThe following items are required to begin the verification process:\nYour app contains NSUserTrackingUsageDescription, which means you need to request permission to track users. To submit for verification, update your app Privacy response to indicate that the data collected by this app will be used for monitoring purposes, or update your app's binary code and upload a new build.Unable to submit for verification\nThe following items are required to begin the verification process:\nYour app contains NSUserTrackingUsageDescription, which means you need to request permission to track users. To submit for verification, update your app Privacy response to indicate that the data collected by this app will be used for monitoring purposes, or update your app's binary code and upload a new build.Unable to submit for verification\nThe following items are required to begin the verification process:\nYour app contains NSUserTrackingUsageDescription, which means you need to request permission to track users. To submit for verification, update your app Privacy response to indicate that the data collected by this app will be used for monitoring purposes, or update your app's binary code and upload a new build.Unable to submit for verification\nThe following items are required to begin the verification process:\nYour app contains NSUserTrackingUsageDescription, which means you need to request permission to track users. To submit for verification, update your app Privacy response to indicate that the data collected by this app will be used for monitoring purposes, or update your app's binary code and upload a new build.Unable to submit for verification\nThe following items are required to begin the verification process:\nYour app contains NSUserTrackingUsageDescription, which means you need to request permission to track users. To submit for verification, update your app Privacy response to indicate that the data collected by this app will be used for monitoring purposes, or update your app's binary code and upload a new build."
        
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
