//
//  ColorSelector.swift
//  SwiftDemo
//
//  Created by xuzepei on 2024/2/23.
//

import UIKit


@objc protocol ColorSelectorDelegate: AnyObject {
    func selectedColor(color: UIColor)
}

class ColorSelector: UIView {
    
    let colors: [UIColor] = [.white, UIColor.color("#4a87d7"),UIColor.color("#ea4025"),UIColor.color("#2e6bcb"),.red, UIColor.color("#94c8f5"), .green, .blue, .yellow, .purple, .orange]
    let span: CGFloat = 10.0
    let width: CGFloat = 40.0
    var selectedColor: UIColor = .white
    var itemArray: [ColorButton] = []
    weak var delegate : ColorSelectorDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = .clear
        
        // Create a UIScrollView
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .clear
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
            
            if let delegate = self.delegate {
                delegate.selectedColor(color: self.selectedColor)
            }
            
        }
    }
    
    func selectButton(index: Int) {
        if index < itemArray.count {
            
            for colorButton in itemArray {
                colorButton.updateStatus(status: .normal)
            }
            
            let selectedBtn = itemArray[index]
            self.selectedColor = selectedBtn.color
            selectedBtn.updateStatus(status: .selected)

            if let delegate = self.delegate {
                delegate.selectedColor(color: self.selectedColor)
            }
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
