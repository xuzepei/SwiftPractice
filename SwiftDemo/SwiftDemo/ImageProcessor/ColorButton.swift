//
//  ColorButton.swift
//  SwiftDemo
//
//  Created by xuzepei on 2024/2/27.
//

import UIKit

enum ColorButtonStatus: Int {
    case normal = 0
    case selected
}

class ColorButton: UIButton {
    
    var color: UIColor!
    var tickImage: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupTickImageView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupTickImageView() {
        
        tickImage = UIImageView()
        tickImage.isHidden = true
        tickImage.image = UIImage(named: "tick")
        tickImage.contentMode = .scaleAspectFit
        tickImage.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(tickImage)
        
        NSLayoutConstraint.activate([
            tickImage.widthAnchor.constraint(equalToConstant: 30), // Adjust width as needed
            tickImage.heightAnchor.constraint(equalToConstant: 30), // Adjust height as needed
            tickImage.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            tickImage.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
    }
    
    func setColor(color: UIColor)
    {
        self.color = color
        
        let colorImage = self.makeRoundImageWithBorder(diameter: 30, color: self.color, borderWidth: 2, borderColor: .black)
        self.setImage(colorImage, for: .normal)
    }
    
    func updateStatus(status: ColorButtonStatus)
    {
        if status == .selected {
            self.tickImage.isHidden = false
        } else {
            self.tickImage.isHidden = true
        }
    }
    
    func makeRoundImageWithBorder(diameter: CGFloat, color: UIColor, borderWidth: CGFloat, borderColor: UIColor) -> UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: diameter, height: diameter), false, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }

        // Draw the outer circle (border)
        let outerRect = CGRect(x: 0, y: 0, width: diameter, height: diameter)
        context.setFillColor(borderColor.cgColor)
        context.fillEllipse(in: outerRect)

        // Draw the inner circle (image)
        let innerRect = CGRect(x: borderWidth, y: borderWidth, width: diameter - 2 * borderWidth, height: diameter - 2 * borderWidth)
        context.setFillColor(color.cgColor) // Fill inner circle with white color
        context.fillEllipse(in: innerRect)

        // Convert drawn image to UIImage
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
