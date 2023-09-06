//
//  ScanningLineView.swift
//  SwiftDemo
//
//  Created by xuzepei on 2023/8/30.
//

import UIKit

class ScanningLineView: UIView {
    
    private let scanLayer = CALayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupScanLayer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupScanLayer()
    }
    
    private func setupScanLayer() {
        let scanLayerWidth: CGFloat = bounds.width * 0.8
        let scanLayerHeight: CGFloat = 4.0
        let scanLayerX = (bounds.width - scanLayerWidth) / 2
        let scanLayerY = (bounds.height - scanLayerHeight) / 2
        
        scanLayer.bounds = CGRect(x: 0, y: 0, width: scanLayerWidth, height: scanLayerHeight)
        scanLayer.position = CGPoint(x: scanLayerX, y: scanLayerY)
        scanLayer.backgroundColor = UIColor.green.cgColor
        
        layer.addSublayer(scanLayer)
        
        animateScanLayer()
    }
    
    private func animateScanLayer() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.fromValue = NSValue(cgPoint: CGPoint(x: scanLayer.position.x, y: 0))
        animation.toValue = NSValue(cgPoint: CGPoint(x: scanLayer.position.x, y: bounds.height))
        animation.duration = 3.0
        animation.repeatCount = .infinity
        
        scanLayer.add(animation, forKey: "scanAnimation")
    }
}
