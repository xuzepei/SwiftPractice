//
//  FaceScanAnimationView.swift
//  SwiftDemo
//
//  Created by xuzepei on 2023/8/30.
//

import UIKit

class FaceScanAnimationView: UIView {
    
    private let scanningImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupScanningImageView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupScanningImageView()
    }
    
    private func setupScanningImageView() {
        let image = UIImage(named: "scanning_line") // Replace with your own image
        
        scanningImageView.image = image
        scanningImageView.contentMode = .scaleAspectFit
        scanningImageView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: 10)
        addSubview(scanningImageView)
        
        startScanningAnimation()
    }
    
    private func startScanningAnimation() {
        let duration: TimeInterval = 2.0
        let delay: TimeInterval = 0.3
        let options: UIView.AnimationOptions = [.curveEaseInOut, .autoreverse, .repeat]
        
        UIView.animate(withDuration: duration, delay: delay, options: options, animations: { [weak self] in
            self?.scanningImageView.transform = CGAffineTransform(translationX: 0, y: self?.bounds.height ?? 0 - 10)
        }, completion: nil)
    }
}
