//
//  MyTabBar.swift
//
//  Created by xuzepei on 2023/7/27.
//

import UIKit



class MyTabBar: UIView {
    
    

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        setup()
    }
    
    func setup() {
        
        self.backgroundColor = .white
        self.layer.cornerRadius = 15
        //self.layer.masksToBounds = true
        


        // Set border properties
        //self.layer.borderWidth = 1
        //self.layer.borderColor = UIColor.blue.cgColor

        // Set shadow properties
        self.layer.shadowColor = Tool.mainColor.cgColor
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 6
        
        self.contentView.backgroundColor = .clear
    }

    func show(animated: Bool = true) {
        
    }
    
    func hide(animated: Bool = true) {
        
    }
   
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
