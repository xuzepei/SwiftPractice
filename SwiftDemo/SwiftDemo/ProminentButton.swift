//
//  ProminentButton.swift
//  SwiftDemo
//
//  Created by xuzepei on 2025/9/23.
//

class ProminentButton: UIButton {
    
    private var blurView: UIVisualEffectView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStyle()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupStyle()
    }
    
    private func setupStyle() {
        // 毛玻璃背景
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurView.isUserInteractionEnabled = false
        blurView.layer.cornerRadius = 12
        blurView.layer.masksToBounds = true
        insertSubview(blurView, at: 0)
        self.blurView = blurView
        
        // 圆角 + 边框
        layer.cornerRadius = 12
        layer.masksToBounds = true
        
        // 字体和颜色
        setTitleColor(.white, for: .normal)
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        
        // 高亮效果
        addTarget(self, action: #selector(touchDown), for: [.touchDown, .touchDragEnter])
        addTarget(self, action: #selector(touchUp), for: [.touchUpInside, .touchCancel, .touchDragExit])
    }
    
    @objc private func touchDown() {
        // 按下时轻微暗化
        blurView?.alpha = 0.7
    }
    
    @objc private func touchUp() {
        // 恢复原状
        blurView?.alpha = 1.0
    }
}
