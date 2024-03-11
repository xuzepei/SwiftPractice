//
//  ImageCropViewController.swift
//  SwiftDemo
//
//  Created by xuzepei on 2024/3/11.
//

import UIKit

class ImageCropViewController: UIViewController {
    
    var imageCropView: ImageCropView!
    var targetPhoto: Photo!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.setup()
    }
    
    func setup() {
        
        updateContent(targetPhoto: Tool.photo4Inches)
    }
    
    func initImageCropView() {
        
        self.imageCropView = UINib(nibName: "ImageCropView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? ImageCropView
        self.imageCropView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.imageCropView)
        
//        var cropViewWdith: CGFloat = 300
//        var cropViewHeight: CGFloat = 300
//        
//        var size = self.targetPhoto.pixelSize
//        cropViewHeight = cropViewWdith / size.width * size.height
//        
//        NSLog("cropViewHeight: \(cropViewHeight)")
        
        NSLayoutConstraint.activate([
            self.imageCropView.widthAnchor.constraint(equalToConstant: 280),
            self.imageCropView.heightAnchor.constraint(equalToConstant: 320),
            self.imageCropView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.imageCropView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100)
        ])
        
        self.view.layoutIfNeeded()
    }
    
    func updateContent(targetPhoto: Photo) {
        
        self.targetPhoto = targetPhoto
        
        initImageCropView()
        
        self.imageCropView.updateContent(originalImage: UIImage(named: "photo")!, targetPhoto: self.targetPhoto)
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
