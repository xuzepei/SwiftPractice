//
//  RCCellFromXib.swift
//  SwiftPractice
//
//  Created by xuzepei on 16/6/7.
//  Copyright © 2016年 xuzepei. All rights reserved.
//

import UIKit

class RCCellFromXib: UITableViewCell {
    
    //MARK:- Properties
    @IBOutlet weak var titleTV:UITextView!
    @IBOutlet weak var descriptionTV:UITextView!

    //MARK:-
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
