//
//  ChatTableViewCell.swift
//  ChatListDemo
//
//  Created by xuzepei on 2023/6/20.
//

import UIKit

// 单元格类型
enum MessageType {
    case sent
    case received
}

class ChatTableViewCell: UITableViewCell {
    
    // 消息标签
    var messageLabel: UILabel!
    
    let margin: CGFloat = 16.0
    var max: CGFloat = UIScreen.main.bounds.size.width * 0.5 - 100
    var topSpace: CGFloat = 20
    
    // 消息类型
    var messageType: MessageType = .sent {
        didSet {
            // 根据消息类型，设置背景色和文本颜色
            switch messageType {
            case .sent:
                messageLabel.backgroundColor = UIColor.systemBlue
                messageLabel.textColor = .white
                
//                // 移除已存在的约束
//                messageLabel.removeConstraints(messageLabel.constraints)
//
//                // 移除已存在的约束
//                //messageLabel.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor).isActive = false
//                //messageLabel.leadingAnchor.constraint(equalTo: contentView.superview!.leadingAnchor).isActive = false
//
//                // 重新设置
//                messageLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20).isActive = true
//                messageLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20).isActive = true
//
//                print("self.max: \(self.max)")
//                messageLabel.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: self.max).isActive = true
//                messageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -margin).isActive = true
                
                
            case .received:
                messageLabel.backgroundColor = UIColor.systemGreen
                messageLabel.textColor = .white
                
//                // 移除已存在的约束
//                messageLabel.removeConstraints(messageLabel.constraints)
//
//                // 重新设置
//                messageLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20).isActive = true
//                messageLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20).isActive = true
//
//                messageLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: margin).isActive = true
//
//                print("self.max: \(self.max)")
//                messageLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -self.max).isActive = true

            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        // 设置消息标签
        messageLabel = UILabel(frame: CGRect.zero)
        // 创建一个 UIEdgeInsets 对象，指定所需的上下左右边距（内边距）
        let padding = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)

        // 将 UIEdgeInsets 应用到 UILabel 的 frame 中，将其缩小为给定的矩形范围（去除内边距后的矩形范围）
        messageLabel.frame = messageLabel.frame.inset(by: padding)
        
        messageLabel.numberOfLines = 0
        messageLabel.font = UIFont.systemFont(ofSize: 16)
        messageLabel.layer.cornerRadius = 5
        messageLabel.layer.masksToBounds = true
        contentView.addSubview(messageLabel)
        
        //contentView.backgroundColor = .red
        
        // 添加约束
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: topSpace).isActive = true
        messageLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -topSpace).isActive = true

        //self.max = UIScreen.main.bounds.size.width * 0.5
        
        //messageLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -(margin+50)).isActive = true
        messageLabel.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: max).isActive = true
        messageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -margin).isActive = true
        
//        switch messageType {
//        case .sent:
//            //messageLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -(margin+50)).isActive = true
//            messageLabel.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: margin).isActive = true
//            messageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -margin).isActive = true
//        case .received:
//            messageLabel.trailingAnchor.constraint(greaterThanOrEqualTo: contentView.trailingAnchor, constant: margin).isActive = true
//            messageLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: margin).isActive = true
//            //messageLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -(margin+50)).isActive = true
//        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
