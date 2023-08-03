//
//  TextBubbleLayer.swift
//  MyTabBarController
//
//  Created by xuzepei on 2023/7/28.
//

import UIKit

class TextBubbleLayer: CALayer {
    
    var badge: Int = 0
    var font: UIFont = UIFont.boldSystemFont(ofSize: 12)
    var textLayer: CATextLayer!
    
    init(badge: Int, font: UIFont) {
        
        self.badge = badge
        self.font = font
        
        super.init()
        
        
        setup()
    }

//    override init() {
//        super.init()
//
//
//    }
    
    override init(layer: Any) {
        super.init(layer: layer)
        // Custom initialization code using the copied properties from the given layer
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        
        let text = String(badge)
        // Calculate the size of the text layer
        let textSize = text.size(withAttributes: [.font: self.font])
        
        self.bounds = CGRect(x: 0, y: 0, width: max(textSize.width + 4, 20), height: 20)
        self.cornerRadius = self.bounds.height / 2
        self.backgroundColor = UIColor.red.cgColor
        
        textLayer = CATextLayer()
        textLayer.frame = CGRect(x: 0, y: 0, width: max(textSize.width + 4, 20), height: textSize.height)
        textLayer.foregroundColor = UIColor.white.cgColor
        textLayer.contentsScale = UIScreen.main.scale //解决文字模糊问题
        textLayer.alignmentMode = .center
        textLayer.font = self.font
        textLayer.fontSize = self.font.pointSize
        textLayer.string = text
        //textLayer.frame.origin.y += 2.5
        textLayer.position = CGPoint(x: textLayer.position.x, y: textSize.height/2.0 + 2.5)
        self.addSublayer(textLayer)
        
        
        self.isHidden = (self.badge <= 0) ? true:false
    }
    
    func updateContent(badge: Int = 0) {
        
        self.badge = badge
        let text = String(self.badge)
        
        // Calculate the size of the text layer
        let textSize = text.size(withAttributes: [.font: self.font])
        self.bounds = CGRect(x: 0, y: 0, width: max(textSize.width + 4, 20), height: 20)
        self.cornerRadius = self.bounds.height / 2
        
        textLayer.frame = CGRect(x: 0, y: 0, width: max(textSize.width + 4, 20), height: textSize.height)
        textLayer.string = text
        textLayer.position = CGPoint(x: textLayer.position.x, y: textSize.height/2.0 + 2.5)
        
        
        self.isHidden = (self.badge <= 0) ? true:false
    }
    
}
