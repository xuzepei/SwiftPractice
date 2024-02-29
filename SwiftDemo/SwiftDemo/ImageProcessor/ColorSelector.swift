//
//  ColorSelector.swift
//  SwiftDemo
//
//  Created by xuzepei on 2024/2/23.
//

import UIKit

class ColorSelector: UIView {
    
    let colors: [UIColor] = [.white, .red, .green, .blue, .yellow, .purple, .orange]
    let span: CGFloat = 10.0
    let width: CGFloat = 40.0
    var selectedColor: UIColor = .white
    var itemArray: [ColorButton] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Create a UIScrollView
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .gray
        scrollView.showsHorizontalScrollIndicator = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
//        scrollView.showsHorizontalScrollIndicator = false
//        scrollView.isScrollEnabled = true
        self.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            scrollView.heightAnchor.constraint(equalToConstant: width) // Adjust height as needed
        ])
        
        // Create buttons for each color
        var leadingAnchor = scrollView.leadingAnchor
        var index = 1
        for color in colors {
            let button = ColorButton(type: .custom)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setColor(color: color)

            button.addTarget(self, action: #selector(colorButtonTapped(_:)), for: .touchUpInside)
            scrollView.addSubview(button)
            
            NSLayoutConstraint.activate([
                button.widthAnchor.constraint(equalToConstant: width), // Adjust width as needed
                button.heightAnchor.constraint(equalToConstant: width), // Adjust height as needed
                button.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 5),
                button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: span),
            ])
            
            button.layoutIfNeeded()
            leadingAnchor = button.trailingAnchor
            index += 1
            
            self.itemArray.append(button)
        }
        
        scrollView.layoutIfNeeded()
        scrollView.contentSize = CGSize(width: span + CGFloat(colors.count) * (width + span), height: width)
        
        self.layoutIfNeeded()
    }
    
    @objc func colorButtonTapped(_ sender: UIButton) {
        
        if let colorBtn = sender as? ColorButton {
            guard let color = colorBtn.color else { return }
            
            print("####Selected color: \(color)")
            self.selectedColor = color
            
            
            for colorButton in itemArray {
                colorButton.updateStatus(status: .normal)
            }
            
            colorBtn.updateStatus(status: .selected)
            
        }
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
