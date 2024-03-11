//
//  Photo.swift
//  SwiftDemo
//
//  Created by xuzepei on 2024/3/1.
//

import UIKit



class Photo: NSObject {
    var pixelSize: CGSize
    var physicalSize: CGSize
    var dpi: CGFloat
    var millimetersToInches: Double
    
    init(pixelSize: CGSize, physicalSize: CGSize, dpi: CGFloat = Tool.photoDPI) {
        self.pixelSize = pixelSize
        self.physicalSize = physicalSize
        self.millimetersToInches = self.pixelSize.height / dpi / physicalSize.height
        self.dpi = dpi
    }
}
