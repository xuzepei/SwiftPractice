//
//  ChatReceivedCell.swift
//  ChatListDemo
//
//  Created by xuzepei on 2023/6/20.
//

import UIKit

class ChatReceivedCell: UITableViewCell {

    //聊天气泡容器
    var chatBubble: UIImageView!
    
    // 消息标签
    var messageLabel: UILabel!
    
    let margin: CGFloat = 16.0
    var max: CGFloat = UIScreen.main.bounds.size.width * 0.5 - 100
    var bubbleTopSpace: CGFloat = 20
    var textMargin: CGFloat = 10
    
    // 消息类型
    var messageType: MessageType = .sent {
        didSet {
            // 根据消息类型，设置背景色和文本颜色
            switch messageType {
            case .sent:
                messageLabel.backgroundColor = UIColor.clear
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
                messageLabel.backgroundColor = UIColor.clear
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
        
        // 创建一个 UIView 作为聊天气泡容器
        chatBubble = UIImageView()
        chatBubble.image = UIImage(named: "bubble_received")?.withTintColor(UIColor.systemGreen).resizableImage(withCapInsets: UIEdgeInsets(top: 17, left: 21, bottom: 17, right: 21),
                                                                                                        resizingMode: .stretch).withRenderingMode(.alwaysOriginal)

        // 设置气泡背景颜色和圆角
        //chatBubble.backgroundColor = UIColor.systemBlue
        //chatBubble.layer.cornerRadius = 15

        // 设置消息标签
        messageLabel = UILabel(frame: CGRect.zero)
        // 创建一个 UIEdgeInsets 对象，指定所需的上下左右边距（内边距）
        messageLabel.numberOfLines = 0
        messageLabel.font = UIFont.systemFont(ofSize: 16)
//        messageLabel.layer.cornerRadius = 5
//        messageLabel.layer.masksToBounds = true
        chatBubble.addSubview(messageLabel)
        
        // 使用 Auto Layout 约束，将文本标签放置在气泡中心
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            messageLabel.centerXAnchor.constraint(equalTo: chatBubble.centerXAnchor),
//            messageLabel.centerYAnchor.constraint(equalTo: chatBubble.centerYAnchor)
//        ])
        // 添加约束
        messageLabel.topAnchor.constraint(equalTo: chatBubble.topAnchor, constant: textMargin).isActive = true
        messageLabel.bottomAnchor.constraint(equalTo: chatBubble.bottomAnchor, constant: -textMargin).isActive = true
        
        messageLabel.leadingAnchor.constraint(greaterThanOrEqualTo: chatBubble.leadingAnchor, constant: textMargin+4).isActive = true
        messageLabel.trailingAnchor.constraint(equalTo: chatBubble.trailingAnchor, constant: -textMargin).isActive = true
        
        
        contentView.addSubview(chatBubble)
        // 使用 Auto Layout 约束，调整聊天气泡的大小和位置
        chatBubble.translatesAutoresizingMaskIntoConstraints = false
        
        // 添加约束
        chatBubble.topAnchor.constraint(equalTo: contentView.topAnchor, constant: bubbleTopSpace).isActive = true
        chatBubble.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -bubbleTopSpace).isActive = true
        chatBubble.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: margin).isActive = true
        chatBubble.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -max).isActive = true
        
        
        // 添加气泡尖角
//        let triangleLayer = CAShapeLayer()
//        let trianglePath = UIBezierPath()
//        trianglePath.move(to: CGPoint(x: chatBubble.bounds.size.width, y: 0))
//        trianglePath.addLine(to: CGPoint(x: chatBubble.bounds.size.width + 10, y: 10))
//        trianglePath.addLine(to: CGPoint(x: chatBubble.bounds.size.width, y: 20))
//        triangleLayer.path = trianglePath.cgPath
//        triangleLayer.fillColor = UIColor.red.cgColor
//        chatBubble.layer.addSublayer(triangleLayer)
        
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
