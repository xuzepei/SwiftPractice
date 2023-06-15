//
//  CircleProgressView.swift
//  VideoPlayerTest
//
//  Created by xuzepei on 2023/6/13.
//

import UIKit

class CircleProgressView: UIView {
    
    private var circleLayer = CAShapeLayer()
    private var progressLayer = CAShapeLayer()
    private var textLayer = CATextLayer()
    private var progress: CGFloat = 0
    
    var startAngle: CGFloat = CGFloat(-Double.pi / 2) //-90 degress
    var endAngle: CGFloat = CGFloat(3 * Double.pi / 2) //270 degress
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initTextLayer()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func initTextLayer() {
        let text = "1/3"
        let attrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 16),
            .foregroundColor: UIColor.black,
        ]
        let attrString = NSAttributedString(string: text, attributes: attrs)

        // 创建CATextLayer
        let textLayerWidth:CGFloat = 30
        //let textLayerHeight:CGFloat = 30
        let textSize = (text as NSString).size(withAttributes: attrs)
        textLayer.backgroundColor = UIColor.blue.cgColor
        textLayer.string = attrString
        textLayer.alignmentMode = .center
        textLayer.frame = CGRect(x: 0, y: 0, width: textLayerWidth, height: textSize.height)
        textLayer.position = CGPoint(x: layer.bounds.midX, y: layer.bounds.midY)
        layer.addSublayer(textLayer)
    }
    
    func progressAnimation(duration: TimeInterval) {
        // created circularProgressAnimation with keyPath
        let circularProgressAnimation = CABasicAnimation(keyPath: "strokeEnd")
        // set the end time
        circularProgressAnimation.duration = duration
        circularProgressAnimation.toValue = self.progress
        circularProgressAnimation.fillMode = .forwards
        circularProgressAnimation.isRemovedOnCompletion = false
        progressLayer.add(circularProgressAnimation, forKey: "progressAnim")
    }
    
    func updateContent(progress: CGFloat, progressColor: UIColor, circleBgColor: UIColor = .black) {
        
        self.progress = progress
        
        // created circularPath for circleLayer and progressLayer
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: self.bounds.size.width * 0.5, y:  self.bounds.size.height * 0.5), radius: self.bounds.size.height * 0.5, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        // circleLayer path defined to circularPath
        circleLayer.path = circularPath.cgPath
        // ui edits
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineCap = .round
        circleLayer.lineWidth = 8.0
        circleLayer.strokeEnd = 1.0 //进度，1为满圈
        circleLayer.strokeColor = UIColor.white.cgColor
        // added circleLayer to layer
        layer.addSublayer(circleLayer)
        
        // progressLayer path defined to circularPath
        progressLayer.path = circularPath.cgPath
        // ui edits
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineCap = .round
        progressLayer.lineWidth = 6.0
        progressLayer.strokeEnd = 0
        progressLayer.strokeColor = progressColor.cgColor
        // added progressLayer to layer
        layer.addSublayer(progressLayer)
        
        progressAnimation(duration: 2*self.progress)
        
    }
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}
