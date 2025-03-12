//
//  ScrollView3Controller.swift
//  ScrollViewDemo2
//
//  Created by xuzepei on 2023/6/25.
//

import UIKit

//用xib的方式，采用Content Layout Guide and Frame Layout Guide
class ScrollViewStickyController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var myLabel: UILabel!
    
    let stickyView = UIView() // 需要固定的 View
    var stickyViewTopConstraint: NSLayoutConstraint!
    let stickyThreshold: CGFloat = 200 // 滚动到这个位置后固定

    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.delegate = self
        
        self.title = "Scroll View Sticky"
        view.backgroundColor = .white
        
        //1. 需要固定的 StickyView, 注意：stickyView 直接加到 view，而不是 scrollView
        stickyView.translatesAutoresizingMaskIntoConstraints = false
        stickyView.backgroundColor = .red
        view.addSubview(stickyView) // 注意：stickyView 直接加到 view，而不是 scrollView
        
        //2. 约束：stickyView（默认情况下它在 ScrollView 里）
        stickyViewTopConstraint = stickyView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: stickyThreshold) // 初始位置
        NSLayoutConstraint.activate([
            stickyViewTopConstraint,
            stickyView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stickyView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stickyView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        // 添加一些测试内容
        let dummyContent = UIView()
        dummyContent.translatesAutoresizingMaskIntoConstraints = false
        dummyContent.backgroundColor = .green
        contentView.addSubview(dummyContent)
        
        // 约束：dummyContent（添加一些占位内容）
        NSLayoutConstraint.activate([
            dummyContent.topAnchor.constraint(equalTo: myLabel.bottomAnchor, constant: 300),
            dummyContent.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            dummyContent.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            dummyContent.heightAnchor.constraint(equalToConstant: 2000),
            dummyContent.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 20),
        ])
        
        self.view.layoutIfNeeded()

    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        
        let offsetY = scrollView.contentOffset.y
        
        print("#### offsetY: \(offsetY)")
        
        if offsetY >= stickyThreshold {
            
            print("#### 111111")
            
            // 当 stickyView 滚动到顶部时，固定在 safeArea 顶部
//            stickyViewTopConstraint = stickyView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.safeAreaInsets.top)
//            NSLayoutConstraint.activate([
//                stickyViewTopConstraint,
//            ])
            
            stickyViewTopConstraint.constant = offsetY
            
            print("#### stickyViewTopConstraint.constant: \(stickyViewTopConstraint.constant)")
            print("#### view.safeAreaInsets.top: \(view.safeAreaInsets.top)")
            
//            if stickyViewTopConstraint.constant < view.safeAreaInsets.top {
//                stickyViewTopConstraint.constant = view.safeAreaInsets.top
//            }

        } else {
            
            print("#### 222222")
            
            stickyViewTopConstraint.constant = stickyThreshold
            
            // 恢复到正常滚动状态
//            stickyViewTopConstraint.constant = 100
//            
//            // 当 stickyView 滚动到顶部时，固定在 safeArea 顶部
//            stickyViewTopConstraint = stickyView.topAnchor.constraint(equalTo: myLabel.topAnchor, constant: 100)
//            NSLayoutConstraint.activate([
//                stickyViewTopConstraint,
//            ])
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
