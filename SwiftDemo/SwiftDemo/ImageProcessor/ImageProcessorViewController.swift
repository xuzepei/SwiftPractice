//
//  ImageProcessorViewController.swift
//  SwiftDemo
//
//  Created by xuzepei on 2024/2/21.
//

import UIKit

class ImageProcessorViewController: UIViewController {

    @IBOutlet weak var inputIV: UIImageView!
    @IBOutlet weak var inputIV2: UIImageView!
    @IBOutlet weak var outputIV: UIImageView!
    @IBOutlet weak var processBtn: UIButton!
    
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var colorSelector: ColorSelector!
    
    let imageProcessor = ImageProcessor.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.inputIV.image = UIImage(named: "photo")!
        self.inputIV2.isHidden = true
        
        slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        
        // Create a UIBarButtonItem
        let rightBarButtonItem = UIBarButtonItem(title: "Export", style: .plain, target: self, action: #selector(clickedExportBtn))
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        
    }
    
    @objc func clickedExportBtn() {
        
        if let outputImage = self.outputIV.image {
            Tool.saveImageToPhotoLibrary(image: outputImage, rootVC: self)
        }
        
    }
    
    @IBAction func clickedProcessBtn(_ sender: Any) {
        
        if let image = self.inputIV.image {
            imageProcessor.removeBackground(from: image, completion: { (resultImage) in
                if let resultImage = resultImage {
                    self.outputIV.image = resultImage
                } else {
                    print("####Failed to remove background")
                }
            }, withBgColor: self.colorSelector.selectedColor)
            

        }

    }
    
    @objc func sliderValueChanged(_ sender: UISlider) {
        // Handle slider value change
        let value = sender.value
        
        
        print("Slider value changed: \(value)")
        imageProcessor.maskInputImage(completion: { resultImage in
            if let resultImage = resultImage {
                self.outputIV.image = resultImage
            } else {
                print("####Failed to mask input image")
            }
        }, bgColor: self.colorSelector.selectedColor, bgAlpha: CGFloat(value))
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
