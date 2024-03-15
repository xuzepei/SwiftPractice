//
//  Photo.swift
//  SwiftDemo
//
//  Created by xuzepei on 2024/3/1.
//

import UIKit



class Photo: NSObject {
    var label: String
    var pixelSize: CGSize
    var physicalSize: CGSize
    var dpi: CGFloat
    var millimetersToInchesByWidth: Double
    var millimetersToInchesByHeight: Double
    
    init(pixelSize: CGSize, physicalSize: CGSize, label:String="", dpi: CGFloat = Tool.photoDPI) {
        self.pixelSize = pixelSize
        self.physicalSize = physicalSize
        self.millimetersToInchesByWidth = self.pixelSize.width / dpi / physicalSize.width
        self.millimetersToInchesByHeight = self.pixelSize.height / dpi / physicalSize.height
        self.label = label
        self.dpi = dpi
    }
}
