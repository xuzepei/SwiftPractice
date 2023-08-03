//
//  TextBubbleLayer.swift
//  MyTabBarController
//
//  Created by xuzepei on 2023/7/28.
//

import UIKit

class BubbleLayer: CALayer {
    
    var badge: Int = 0 {
        willSet {
            self.isHidden = (newValue <= 0) ? true:false
        }
    }
    
    var color: UIColor!
    var size: CGFloat!

    init(color: UIColor = UIColor.red, size: CGFloat = 12) {
        
        self.color = color
        self.size = size
        
        super.init()
        
        setup()
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
        // Custom initialization code using the copied properties from the given layer
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        self.bounds = CGRect(x: 0, y: 0, width: size, height: size)
        self.cornerRadius = self.bounds.height / 2
        self.backgroundColor = self.color.cgColor
        
        self.isHidden = (self.badge <= 0) ? true:false
    }
    
}
