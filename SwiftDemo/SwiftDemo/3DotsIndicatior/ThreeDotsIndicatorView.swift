//
//  TreeDotsIndicator.swift
//  SwiftDemo
//
//  Created by xuzepei on 2025/4/7.
//

class ThreeDotsIndicatorView: UIView {

    private let dotCount = 3
    private let dotSize: CGFloat = 8
    private let dotSpacing: CGFloat = 10
    private var dotViews: [UIView] = []

    private let bubblePadding = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
    let backgroundView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        // 气泡背景
        backgroundView.backgroundColor = UIColor.systemGray6
        backgroundView.layer.cornerRadius = 10
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(backgroundView)

        // dot 容器
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = dotSpacing
        stack.alignment = .center
        stack.distribution = .equalSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.addSubview(stack)

        for i in 0..<dotCount {
            let dot = UIView()
            dot.backgroundColor = UIColor.red
            dot.layer.cornerRadius = dotSize / 2
            dot.translatesAutoresizingMaskIntoConstraints = false
            dot.widthAnchor.constraint(equalToConstant: dotSize).isActive = true
            dot.heightAnchor.constraint(equalToConstant: dotSize).isActive = true

            stack.addArrangedSubview(dot)
            dotViews.append(dot)

            animate(dot: dot, at: i)
        }

        // 约束布局
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: bubblePadding.top),
            stack.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -bubblePadding.bottom),
            stack.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: bubblePadding.left),
            stack.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -bubblePadding.right),

            backgroundView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            backgroundView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
        layoutIfNeeded()
        
        backgroundView.layer.cornerRadius = backgroundView.height() * 0.5
    }

    private func animate(dot: UIView, at index: Int) {
        let delay = Double(index) * 0.2

        let scaleAnim = CABasicAnimation(keyPath: "transform.scale")
        scaleAnim.fromValue = 0.5
        scaleAnim.toValue = 1.5
        scaleAnim.duration = 0.6
        scaleAnim.autoreverses = true
        scaleAnim.repeatCount = .infinity
        scaleAnim.beginTime = CACurrentMediaTime() + delay

        let opacityAnim = CABasicAnimation(keyPath: "opacity")
        opacityAnim.fromValue = 0.2
        opacityAnim.toValue = 1.0
        opacityAnim.duration = 0.6
        opacityAnim.autoreverses = true
        opacityAnim.repeatCount = .infinity
        opacityAnim.beginTime = CACurrentMediaTime() + delay

        dot.layer.add(scaleAnim, forKey: "scale")
        dot.layer.add(opacityAnim, forKey: "opacity")
    }
}
