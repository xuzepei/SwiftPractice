//
//  MyTabBarItem.swift
//
//  Created by xuzepei on 2023/7/27.
//

import UIKit

class MyTabBarItem: UIView {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var button: UIButton!
    
    var item: Dictionary<String, String>!
    
    var textBubbleLayer: TextBubbleLayer!
    var bubbleLayer: BubbleLayer!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
    
    func setup() {
        
        self.backgroundColor = .clear
        self.titleLabel.textAlignment = .center
        
        let badge = 0
        let font: UIFont = UIFont.boldSystemFont(ofSize: 12)

//        textBubbleLayer = TextBubbleLayer(badge: badge, font: font)
//        NSLog("textBubbleLayer.frame.size.width: \(textBubbleLayer.frame.size.width)")
//        textBubbleLayer.position = CGPoint(x: self.bounds.size.width - 13, y: 10)
//        self.layer.addSublayer(textBubbleLayer)
        
        
        bubbleLayer = BubbleLayer()
        NSLog("bubbleLayer.frame.size.width: \(bubbleLayer.frame.size.width)")
        bubbleLayer.position = CGPoint(x: self.bounds.size.width - 16, y:10)
        self.layer.addSublayer(bubbleLayer)
    }

    func updateContent(isSelected: Bool = false) {
        
        if isSelected {
            self.imageView.image = UIImage(named: self.item["image"] ?? "")?.withTintColor(Tool.mainColor)
            
            //self.textBubbleLayer.updateContent(badge: self.bubbleLayer.badge + 1)
            self.bubbleLayer.badge += 1
        } else {
            self.imageView.image = UIImage(named: self.item["image"] ?? "")?.withTintColor(UIColor.systemGray2)
        }
        
        self.titleLabel.isHidden = true
    }
   
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
