//
//  ScrollView2Controller.swift
//  ScrollViewDemo2
//
//  Created by xuzepei on 2023/6/25.
//

import UIKit

//用现有的xib，关闭Content Layout Guide and Frame Layout Guide
class ScrollView2Controller: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var containerView: UIView!
    
    private let subview1 = UIView()
    private let subview2 = UIView()
    private let subLabel = UILabel()
    private let myLabel = UILabel()
    private let subview3 = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.title = "Scroll View 2"
        view.backgroundColor = .white
        
        //清除原有的约束
//        scrollView.cleanConstraints()
//        scrollView.translatesAutoresizingMaskIntoConstraints = false
//        scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
//        scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
//        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
//        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        

        let padding: CGFloat = 20

        //containter view
        //scrollView.addSubview(containerView)
        //清除原有的约束
//        containerView.cleanConstraints()
//
//        containerView.backgroundColor = .gray
//        containerView.translatesAutoresizingMaskIntoConstraints = false
//
//        containerView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
//        containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
//
//        containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: padding).isActive = true
//        containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -padding).isActive = true
//
//        containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -padding * 2).isActive = true
        
        
        
        
        self.containerView.addSubview(subview1)
        subview1.backgroundColor = .red
        subview1.translatesAutoresizingMaskIntoConstraints = false
        
        //subview1
        subview1.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        subview1.heightAnchor.constraint(equalToConstant: 1500).isActive = true
        subview1.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10).isActive = true
        subview1.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10).isActive = true
        //subview1.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true

        //myLabel
        self.containerView.addSubview(myLabel)
        myLabel.backgroundColor = .systemBlue
        myLabel.translatesAutoresizingMaskIntoConstraints = false
        myLabel.numberOfLines = 0
        myLabel.textColor = .black
        myLabel.text = "Unable to submit for verification\nThe following items are required to begin the verification process:\nYour app contains NSUserTrackingUsageDescription, which means you need to request permission to track users. To submit for verification, update your app Privacy response to indicate that the data collected by this app will be used for monitoring purposes, or update your app's binary code and upload a new build.Unable to submit for verification\nThe following items are required to begin the verification process:\nYour app contains NSUserTrackingUsageDescription, which means you need to request permission to track users. To submit for verification, update your app Privacy response to indicate that the data collected by this app will be used for monitoring purposes, or update your app's binary code and upload a new build.Unable to submit for verification\nThe following items are required to begin the verification process:\nYour app contains NSUserTrackingUsageDescription, which means you need to request permission to track users. To submit for verification, update your app Privacy response to indicate that the data collected by this app will be used for monitoring purposes, or update your app's binary code and upload a new build."
        myLabel.topAnchor.constraint(equalTo: subview1.bottomAnchor, constant: 20).isActive = true
        myLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10).isActive = true
        myLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10).isActive = true
        myLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        
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
