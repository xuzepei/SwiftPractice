import UIKit

class FaceScanImageView: UIImageView {
    private let gradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupScanEffect()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupScanEffect()
    }
    
    private func setupScanEffect() {
        contentMode = .scaleAspectFit
        clipsToBounds = true
        
        // 渐变光带层
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.white.withAlphaComponent(0.6).cgColor,
            UIColor.clear.cgColor
        ]
        gradientLayer.locations = [0, 0.5, 1]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.frame = bounds
        gradientLayer.opacity = 0.8
        layer.addSublayer(gradientLayer)
        
        startScanAnimation()
    }
    
    private func startScanAnimation() {
        let animation = CABasicAnimation(keyPath: "position.y")
        animation.fromValue = -bounds.height
        animation.toValue = bounds.height * 2
        animation.duration = 2.5
        animation.repeatCount = .infinity
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        gradientLayer.add(animation, forKey: "scan")
    }
}

class FaceScanViewController: UIViewController {
    let imageView = FaceScanImageView(frame: CGRectMake(40, 100, 300,300))
    let gradientLayer = CAGradientLayer()
    let shapeLayer = CAShapeLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        // 显示人脸图片
        imageView.image = UIImage(named: "face") // 换成你的图片
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 0, y: 100, width: view.bounds.width, height: 400)
        view.addSubview(imageView)
        
        // 添加轮廓光效果
        //setupOutlineLight()
    }
    
    
}
