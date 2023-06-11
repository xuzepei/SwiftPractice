//
//  ViewController.swift
//  ScrollViewDemo
//
//  Created by xuzepei on 2023/6/9.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var expandedView: UIView!
    @IBOutlet weak var arrow: UIImageView!
    
    @IBOutlet weak var contentViewConstraintHeight: NSLayoutConstraint!
    @IBOutlet weak var expandedViewConstraintHeight: NSLayoutConstraint!
    
    var isExpanded = false
    var isAnimating = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func clickedButton(_ sender: Any) {
        print("clickedButton")
        
        if isAnimating {
            return
        }
        
        self.isAnimating = true
        
        UIView.animate(withDuration: 0.5) {
            self.arrow.transform = CGAffineTransform(rotationAngle: self.isExpanded ? 0 : -CGFloat.pi / 2 )
        }
        
        //约束的修改要放在动画外
        self.expandedViewConstraintHeight.constant = self.isExpanded ? 0 : 400
        
        print("self.contentViewConstraintHeight.constant: \(self.contentViewConstraintHeight.constant)")
        print("self.scrollView.contentSize.height: \(self.scrollView.contentSize.height)")
        print("self.contentView.height: \(self.contentView.bounds.size.height)")
        
        var offsetY:CGFloat = 0
        //759是contentView在iphone14pro上的设计高度，subview展开后contentView增加250高
        if self.contentView.bounds.size.height <= (759 + 250) {
            offsetY = self.isExpanded ? -250 : 250
            self.contentViewConstraintHeight.constant = self.contentViewConstraintHeight.constant + offsetY
        }
        

        UIView.animate(withDuration: 0.5) {
            self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width, self.contentViewConstraintHeight.constant)
            
            print("self.contentViewConstraintHeight.constant: \(self.contentViewConstraintHeight.constant)")
            print("self.scrollView.contentSize.height: \(self.scrollView.contentSize.height)")
            print("self.contentView.height: \(self.contentView.bounds.size.height)")
            
            //伴随展开View的同时，滚动到View的最下方可视位置
            self.scrollView.contentOffset = CGPoint(x: self.scrollView.contentOffset.x, y: self.scrollView.contentOffset.y + offsetY)
            
            self.view.layoutIfNeeded()
        } completion: { b in


            self.isAnimating = false
            self.isExpanded = self.isExpanded ? false : true
            

        }

    }
}

