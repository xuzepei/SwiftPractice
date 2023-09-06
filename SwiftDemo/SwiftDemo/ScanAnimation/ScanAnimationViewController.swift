//
//  ScanAnimationViewController.swift
//  SwiftDemo
//
//  Created by xuzepei on 2023/8/30.
//

import UIKit

class ScanAnimationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let v1 = FaceScanAnimationView(frame: CGRect(x: 100, y: 100, width: 200, height: 200))
        v1.backgroundColor = .black
        v1.translatesAutoresizingMaskIntoConstraints = true
        view.addSubview(v1)
        
        let v2 = ScanningLineView(frame: CGRect(x: 100, y: 400, width: 200, height: 200))
        v2.backgroundColor = .black
        v2.translatesAutoresizingMaskIntoConstraints = true
        view.addSubview(v2)
        
        createScanningIndicator()
        
    }
    
    func createScanningIndicator() {
       
       let height: CGFloat = 15
       let opacity: Float = 0.4
       let topColor = UIColor.green.withAlphaComponent(0)
       let bottomColor = UIColor.green

       let layer = CAGradientLayer()
       layer.colors = [topColor.cgColor, bottomColor.cgColor]
       layer.opacity = opacity
       
       let squareWidth = view.frame.width * 0.6
       let xOffset = view.frame.width * 0.2
       let yOffset = view.frame.midY - (squareWidth / 2)
       layer.frame = CGRect(x: xOffset, y: yOffset, width: squareWidth, height: height)
       
       self.view.layer.insertSublayer(layer, at: 0)

       let initialYPosition = layer.position.y
       let finalYPosition = initialYPosition + squareWidth - height
       let duration: CFTimeInterval = 2

       let animation = CABasicAnimation(keyPath: "position.y")
       animation.fromValue = initialYPosition as NSNumber
       animation.toValue = finalYPosition as NSNumber
       animation.duration = duration
       animation.repeatCount = .infinity
       animation.isRemovedOnCompletion = false
       
       layer.add(animation, forKey: nil)
   }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
