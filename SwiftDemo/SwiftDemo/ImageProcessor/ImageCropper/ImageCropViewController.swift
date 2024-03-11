//
//  ImageCropViewController.swift
//  SwiftDemo
//
//  Created by xuzepei on 2024/3/11.
//

import UIKit

class ImageCropViewController: UIViewController {
    
    var imageCropView: ImageCropView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setup()
    }
    
    func setup() {
        initImageCropView()
        updateContent()
    }
    
    func initImageCropView() {
        
        self.imageCropView = UINib(nibName: "ImageCropView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? ImageCropView
        self.imageCropView.translatesAutoresizingMaskIntoConstraints = false
        self.imageCropView.backgroundColor = .blue
        self.view.addSubview(self.imageCropView)
        
        NSLayoutConstraint.activate([
            self.imageCropView.widthAnchor.constraint(equalToConstant: 360),
            self.imageCropView.heightAnchor.constraint(equalToConstant: 600),
            self.imageCropView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.imageCropView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
        
        self.view.layoutIfNeeded()
    }
    
    func updateContent() {
        
        self.imageCropView.updateContent(originalImage: UIImage(named: "photo")!, targetPhoto: Tool.photo1Inches)
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
