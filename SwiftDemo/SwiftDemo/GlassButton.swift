//
//  GlassButton.swift
//  XiaoMei
//
//  Created by xuzepei on 2025/9/23.
//

class GlassButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStyle()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupStyle()
    }
    
    private func setupStyle() {
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = bounds
        blurView.isUserInteractionEnabled = false
        blurView.layer.cornerRadius = 16
        blurView.layer.masksToBounds = true
        insertSubview(blurView, at: 0)
        
        layer.cornerRadius = 16
        layer.masksToBounds = true
        setTitleColor(.white, for: .normal)
    }
}
