//
//  ScrollView1Controller.swift
//  ScrollViewDemo2
//
//  Created by xuzepei on 2023/6/25.
//

import UIKit

//不用xib的方式，不采用Content Layout Guide and Frame Layout Guide
class ScrollView1Controller: UIViewController {
    
    private let scrollView = UIScrollView()
    private let containerView = UIView()
    private let subview1 = UIView()
    private let subview2 = UIView()
    private let subLabel = UILabel()
    private let myLabel = UILabel()
    private let subview3 = UIView()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Scroll View 1"
        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        let colors: [UIColor] = [.systemRed, .systemMint, .systemYellow, .systemBlue]
        let subviews = [subview1, subview2, myLabel, subview3]

        for (index, subview) in subviews.enumerated() {
            containerView.addSubview(subview)
            subview.translatesAutoresizingMaskIntoConstraints = false
            subview.backgroundColor = colors[index]
        }

        let padding: CGFloat = 20

        //containter view
        scrollView.addSubview(containerView)
        containerView.backgroundColor = .gray
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        
        containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: padding).isActive = true
        containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -padding).isActive = true
        
        containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -padding * 2).isActive = true
        
        
        //subview1
        subview1.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        subview1.heightAnchor.constraint(equalToConstant: 500).isActive = true
        subview1.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        subview1.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        
        //subview2
        subview2.topAnchor.constraint(equalTo: subview1.bottomAnchor, constant: padding).isActive = true
        //subview2.heightAnchor.constraint(equalToConstant: 300).isActive = true
        subview2.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        subview2.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        
        //label in subview2
        subLabel.numberOfLines = 0
        subLabel.textColor = .black
        subLabel.text = "腾讯文档是一款可多人协作的在线文档,可同时编辑Word、Excel和PPT文档,云端实时保存。可针对QQ、微信好友设置文档访问、编辑权限,支持多种版本Word、Excel和PPT文档模板。腾讯文档是一款可多人协作的在线文档,可同时编辑Word、Excel和PPT文档,云端实时保存。可针对QQ、微信好友设置文档访问、编辑权限,支持多种版本Word、Excel和PPT文档模板。腾讯文档是一款可多人协作的在线文档,可同时编辑Word、Excel和PPT文档,云端实时保存。可针对QQ、微信好友设置文档访问、编辑权限,支持多种版本Word、Excel和PPT文档模板。腾讯文档是一款可多人协作的在线文档,可同时编辑Word、Excel和PPT文档,云端实时保存。可针对QQ、微信好友设置文档访问、编辑权限,支持多种版本Word、Excel和PPT文档模板。腾讯文档是一款可多人协作的在线文档,可同时编辑Word、Excel和PPT文档,云端实时保存。可针对QQ、微信好友设置文档访问、编辑权限,支持多种版本Word、Excel和PPT文档模板。腾讯文档是一款可多人协作的在线文档,可同时编辑Word、Excel和PPT文档,云端实时保存。可针对QQ、微信好友设置文档访问、编辑权限,支持多种版本Word、Excel和PPT文档模板。腾讯文档是一款可多人协作的在线文档,可同时编辑Word、Excel和PPT文档,云端实时保存。可针对QQ、微信好友设置文档访问、编辑权限,支持多种版本Word、Excel和PPT文档模板。腾讯文档是一款可多人协作的在线文档,可同时编辑Word、Excel和PPT文档,云端实时保存。可针对QQ、微信好友设置文档访问、编辑权限,支持多种版本Word、Excel和PPT文档模板。腾讯文档是一款可多人协作的在线文档,可同时编辑Word、Excel和PPT文档,云端实时保存。可针对QQ、微信好友设置文档访问、编辑权限,支持多种版本Word、Excel和PPT文档模板。腾讯文档是一款可多人协作的在线文档,可同时编辑Word、Excel和PPT文档,云端实时保存。可针对QQ、微信好友设置文档访问、编辑权限,支持多种版本Word、Excel和PPT文档模板。腾讯文档是一款可多人协作的在线文档,可同时编辑Word、Excel和PPT文档,云端实时保存。可针对QQ、微信好友设置文档访问、编辑权限,支持多种版本Word、Excel和PPT文档模板。腾讯文档是一款可多人协作的在线文档,可同时编辑Word、Excel和PPT文档,云端实时保存。可针对QQ、微信好友设置文档访问、编辑权限,支持多种版本Word、Excel和PPT文档模板。腾讯文档是一款可多人协作的在线文档,可同时编辑Word、Excel和PPT文档,云端实时保存。可针对QQ、微信好友设置文档访问、编辑权限,支持多种版本Word、Excel和PPT文档模板。腾讯文档是一款可多人协作的在线文档,可同时编辑Word、Excel和PPT文档,云端实时保存。可针对QQ、微信好友设置文档访问、编辑权限,支持多种版本Word、Excel和PPT文档模板。腾讯文档是一款可多人协作的在线文档,可同时编辑Word、Excel和PPT文档,云端实时保存。可针对QQ、微信好友设置文档访问、编辑权限,支持多种版本Word、Excel和PPT文档模板。腾讯文档是一款可多人协作的在线文档,可同时编辑Word、Excel和PPT文档,云端实时保存。可针对QQ、微信好友设置文档访问、编辑权限,支持多种版本Word、Excel和PPT文档模板。腾讯文档是一款可多人协作的在线文档,可同时编辑Word、Excel和PPT文档,云端实时保存。可针对QQ、微信好友设置文档访问、编辑权限,支持多种版本Word、Excel和PPT文档模板。腾讯文档是一款可多人协作的在线文档,可同时编辑Word、Excel和PPT文档,云端实时保存。可针对QQ、微信好友设置文档访问、编辑权限,支持多种版本Word、Excel和PPT文档模板。腾讯文档是一款可多人协作的在线文档,可同时编辑Word、Excel和PPT文档,云端实时保存。可针对QQ、微信好友设置文档访问、编辑权限,支持多种版本Word、Excel和PPT文档模板。腾讯文档是一款可多人协作的在线文档,可同时编辑Word、Excel和PPT文档,云端实时保存。可针对QQ、微信好友设置文档访问、编辑权限,支持多种版本Word、Excel和PPT文档模板。"
        subview2.addSubview(subLabel)
        subLabel.translatesAutoresizingMaskIntoConstraints = false
        subLabel.topAnchor.constraint(equalTo: subview2.topAnchor, constant: padding).isActive = true
        subLabel.bottomAnchor.constraint(equalTo: subview2.bottomAnchor, constant: -padding).isActive = true
        subLabel.leadingAnchor.constraint(equalTo: subview2.leadingAnchor, constant: padding).isActive = true
        subLabel.trailingAnchor.constraint(equalTo: subview2.trailingAnchor, constant: -padding).isActive = true
        
        //myLabel
        myLabel.numberOfLines = 0
        myLabel.textColor = .black
        myLabel.text = "Unable to submit for verification\nThe following items are required to begin the verification process:\nYour app contains NSUserTrackingUsageDescription, which means you need to request permission to track users. To submit for verification, update your app Privacy response to indicate that the data collected by this app will be used for monitoring purposes, or update your app's binary code and upload a new build.Unable to submit for verification\nThe following items are required to begin the verification process:\nYour app contains NSUserTrackingUsageDescription, which means you need to request permission to track users. To submit for verification, update your app Privacy response to indicate that the data collected by this app will be used for monitoring purposes, or update your app's binary code and upload a new build.Unable to submit for verification\nThe following items are required to begin the verification process:\nYour app contains NSUserTrackingUsageDescription, which means you need to request permission to track users. To submit for verification, update your app Privacy response to indicate that the data collected by this app will be used for monitoring purposes, or update your app's binary code and upload a new build.Unable to submit for verification\nThe following items are required to begin the verification process:\nYour app contains NSUserTrackingUsageDescription, which means you need to request permission to track users. To submit for verification, update your app Privacy response to indicate that the data collected by this app will be used for monitoring purposes, or update your app's binary code and upload a new build."
        myLabel.topAnchor.constraint(equalTo: subview2.bottomAnchor, constant: padding).isActive = true
        myLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        myLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        
        //subview3
        subview3.topAnchor.constraint(equalTo: myLabel.bottomAnchor, constant: padding).isActive = true
        subview3.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        subview3.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        subview3.heightAnchor.constraint(equalToConstant: 1400).isActive = true
        subview3.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true

        subview1.layer.cornerRadius = 20
        subview2.layer.cornerRadius = 20
        subview3.layer.cornerRadius = 20
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
