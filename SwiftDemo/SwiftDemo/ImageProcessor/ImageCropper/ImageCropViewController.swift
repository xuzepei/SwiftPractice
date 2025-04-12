//
//  ImageCropViewController.swift
//  SwiftDemo
//
//  Created by xuzepei on 2024/3/11.
//

import UIKit
import YUCIHighPassSkinSmoothing

class ImageCropViewController: UIViewController, ColorSelectorDelegate {

    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var processBtn: UIButton!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var colorSelector: ColorSelector!
    
    @IBOutlet weak var colorSelectorConstraintTop: NSLayoutConstraint!
    
    var imageCropView: ImageCropView!
    var targetPhoto: Photo!
    var originalImage: UIImage!
    var imageNoFilter: UIImage? = nil
    var selectedColor: UIColor = .clear

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.setup()
    }
    
    func setup() {
        
        self.view.backgroundColor = .systemGray6

        // Create a UIBarButtonItem
        let rightBarButtonItem = UIBarButtonItem(title: "Export", style: .plain, target: self, action: #selector(clickedExportBtn))
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        
        updateContent(targetPhoto: self.targetPhoto)
        
        self.colorSelector.delegate = self
        colorSelector.selectButton(index: 0)
        
        slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)

    }
    
    func initImageCropView() {
        
        self.imageCropView = UINib(nibName: "ImageCropView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? ImageCropView
        self.imageCropView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.imageCropView)
        
        let cropViewMaxWdith: CGFloat = 340
        let cropViewMaxHeight: CGFloat = 360
        
//        var size = self.targetPhoto.pixelSize
//        cropViewHeight = cropViewWdith / size.width * size.height
//        NSLog("cropViewHeight: \(cropViewHeight)")
        
        var cropViewWdith = cropViewMaxWdith
        var cropViewHeight = self.targetPhoto.pixelSize.height * cropViewMaxWdith / self.targetPhoto.pixelSize.width
        while cropViewHeight > cropViewMaxHeight {
            cropViewWdith -= 5
            cropViewHeight = self.targetPhoto.pixelSize.height * cropViewWdith / self.targetPhoto.pixelSize.width
        }
        
        NSLayoutConstraint.activate([
            self.imageCropView.widthAnchor.constraint(equalToConstant: cropViewMaxWdith),
            self.imageCropView.heightAnchor.constraint(equalToConstant: cropViewHeight),
            self.imageCropView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.imageCropView.topAnchor.constraint(equalTo: self.label2.bottomAnchor, constant: 20)
        ])
        
        self.view.layoutIfNeeded()
    }
    
    func updateContent(targetPhoto: Photo) {
        
        self.targetPhoto = targetPhoto
        
        self.label1.text = "类型: \(targetPhoto.label)"
        self.label1.textColor = UIColor.darkGray
        
        self.label2.text = "\(Int(targetPhoto.pixelSize.width))x\(Int(targetPhoto.pixelSize.height))px | \(Int(targetPhoto.physicalSize.width))x\(Int(targetPhoto.physicalSize.height))mm | \(Int(targetPhoto.dpi))dpi"
        self.label2.textColor = UIColor.darkGray
        
        initImageCropView()
        
        self.imageCropView.updateContent(originalImage: self.originalImage, targetPhoto: self.targetPhoto)
        self.imageNoFilter = self.originalImage
        
        self.colorSelectorConstraintTop.constant = UIDevice.safeDistance().top + self.imageCropView.height() + 40
        
        
    }


    @objc func clickedExportBtn() {

        //old
//        let outputImage = self.imageCropView.crop()
//        //let outputImage = self.imageCropView.imageView.image!
//        if let image = Tool.resizeImageByDPI(image: outputImage, target: self.targetPhoto)
//        {
//            Tool.saveImageToPhotoLibrary(image: image, rootVC: self)
//            
//            Tool.savePhotoToLocal(image.pngData()!, name: "myphoto.png")
//        }
        
        let outputImage = self.imageCropView.crop()
        //Tool.savePhotoToLocal(outputImage.pngData()!, name: "myphoto.png")
//        ImageProcessor.shared.removeBackground(from: outputImage, completion: { (resultImage) in
//            if let resultImage = resultImage {
//                DispatchQueue.main.async {
//                    if let image = Tool.resizeImageByDPI(image: resultImage, target: self.targetPhoto)
//                    {
//                        Tool.saveImageToPhotoLibrary(image: image, rootVC: self)
//                        //Tool.savePhotoToLocal(image.pngData()!, name: "myphoto.png")
//                    }
//                }
//            } else {
//                print("####Failed to remove background")
//            }
//        }, withBgColor: self.selectedColor)
    }
    
    func selectedColor(color: UIColor) {
        
        self.imageCropView.figureBgView.backgroundColor = color
        self.selectedColor = color
        
        //old
//        ImageProcessor.shared.removeBackground(from: self.originalImage, completion: { (resultImage) in
//            if let resultImage = resultImage {
//                self.imageCropView.imageView.image = resultImage
//                self.imageNoFilter = resultImage
//            } else {
//                print("####Failed to remove background")
//            }
//        }, withBgColor: color)
    }
    
    @IBAction func clickedProcessBtn(_ sender: Any) {
        
        //filter(amount: 1.0)

    }
    
    @objc func sliderValueChanged(_ sender: UISlider) {
        // Handle slider value change
        let value = sender.value
        print("Slider value changed: \(value)")
        
        filter(amount: value)

    }
    
    func filter(amount: Float) {
        DispatchQueue.main.async {
            
            guard let inputImage = CIImage(image: self.imageNoFilter!) else {
                return
            }
            
            let filter = YUCIHighPassSkinSmoothing()
            filter.inputImage = inputImage
            filter.inputAmount = NSNumber(value: 0.75)
            filter.inputRadius = NSNumber(value: 200 * amount)
            guard let outputImage = filter.outputImage else {
                return
            }
            //self.imageCropView.imageView.image = outputImage.toUIImage()
            
//            ImageProcessor.shared.removeBackground(from: outputImage.toUIImage()!, completion: { (resultImage) in
//                if let resultImage = resultImage {
//                    self.imageCropView.imageView.image = resultImage
//                } else {
//                    print("####Failed to remove background")
//                }
//            }, withBgColor: self.colorSelector.selectedColor)
        }
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
