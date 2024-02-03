//
//  TagsView.swift
//  PandaUnion
//
//  Created by xuzepei on 2024/1/9.
//

import UIKit

class TagsView: UIView {
    
    var tagArray: NSMutableArray = NSMutableArray()
    var font = UIFont.systemFont(ofSize: 13)
    var lineHeight: CGFloat = 30
    var offset_x: CGFloat = 0
    var numberOfLines: CGFloat = 1
    var space_x: CGFloat = 4
    var space_y: CGFloat = 4
    var padding: CGFloat = 4
    var contentHeight: CGFloat = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func addTag(text: String) {
        if text.count > 0 {
            let textWidth = self.getTextWidth(text: text, font: self.font) + padding * 2
            if textWidth > 0 {
                
                let temp_x = offset_x + textWidth + space_x
                
                NSLog("####: TagsView-width:\(self.bounds.width)")
                NSLog("####: temp_x:\(offset_x)")
                
                if temp_x <= self.bounds.width {
                    
                    NSLog("####: 11111")

                    let label = UILabel()
                    label.backgroundColor = .red
                    label.translatesAutoresizingMaskIntoConstraints = false
                    label.font = self.font
                    label.text = text
                    label.textAlignment = .center
                    self.addSubview(label)
                    
                    let offset_y: CGFloat = (lineHeight + space_y) * (numberOfLines - 1)
                    NSLayoutConstraint.activate([
                        label.topAnchor.constraint(equalTo: self.topAnchor, constant: offset_y),
                        label.heightAnchor.constraint(equalToConstant: lineHeight),
                        label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: offset_x),
                        //label.trailingAnchor.constraint(equalTo: self.trailingAnchor)
                        label.widthAnchor.constraint(equalToConstant: textWidth),
                    ])
                    
                    offset_x += textWidth + space_x
                    
                } else {
                    
                    offset_x = 0
                    numberOfLines += 1
                    
                    NSLog("####: 22222")
                    
                    let label = UILabel()
                    label.backgroundColor = .red
                    label.translatesAutoresizingMaskIntoConstraints = false
                    label.font = self.font
                    label.text = text
                    label.textAlignment = .center
                    self.addSubview(label)
                    
                    let offset_y: CGFloat = (lineHeight + space_y) * (numberOfLines - 1)
                    NSLayoutConstraint.activate([
                        label.topAnchor.constraint(equalTo: self.topAnchor, constant: offset_y),
                        label.heightAnchor.constraint(equalToConstant: lineHeight),
                        label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: offset_x),
                        //label.trailingAnchor.constraint(equalTo: self.trailingAnchor)
                        label.widthAnchor.constraint(equalToConstant: textWidth),
                    ])
                    
                    offset_x += textWidth + space_x
                }

            }
            
            contentHeight = (lineHeight + space_y) * numberOfLines
            self.layoutIfNeeded()
            
        }
    }
    
    func getTextWidth(text:String?, font: UIFont?, height: CGFloat = 30) -> CGFloat {
        
        guard let text = text else {
            return 0
        }
        
        let font = font ?? UIFont.systemFont(ofSize: 13)
        
        let attributes: [NSAttributedString.Key: Any] = [.font: font]
        let attributedText = NSAttributedString(string: text, attributes: attributes)

        let maxSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: height)
        let boundingRect = attributedText.boundingRect(with: maxSize, options: [.usesLineFragmentOrigin], context: nil)

        return ceil(boundingRect.width)
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
