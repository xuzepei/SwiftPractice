//
//  ImageProcessor.swift
//  MyCamera
//
//  Created by xuzepei on 2024/2/20.
//

import UIKit
import CoreML
import Vision
import CoreImage.CIFilterBuiltins

/// A structure that provides an RGB color intensity value for the roll, pitch, and yaw angles.
struct AngleColors {
    
    let red: CGFloat
    let blue: CGFloat
    let green: CGFloat
    
    init(roll: NSNumber?, pitch: NSNumber?, yaw: NSNumber?) {
        red = AngleColors.convert(value: roll, with: -.pi, and: .pi)
        blue = AngleColors.convert(value: pitch, with: -.pi / 2, and: .pi / 2)
        green = AngleColors.convert(value: yaw, with: -.pi / 2, and: .pi / 2)
    }
    
    static func convert(value: NSNumber?, with minValue: CGFloat, and maxValue: CGFloat) -> CGFloat {
        guard let value = value else { return 0 }
        let maxValue = maxValue * 0.8
        let minValue = minValue + (maxValue * 0.2)
        let facePoseRange = maxValue - minValue
        
        guard facePoseRange != 0 else { return 0 } // protect from zero division
        
        let colorRange: CGFloat = 1
        return (((CGFloat(truncating: value) - minValue) * colorRange) / facePoseRange)
    }
}

@objcMembers class ImageProcessor: NSObject {
    
    @objc static let shared = ImageProcessor()
    
    var inputImage: UIImage!
    var removedBgImage: UIImage!
    var outputImage: UIImage!
    var bgColor: UIColor!
    
    private var colors: AngleColors?
    
    private func getDeepLabV3Model() -> DeepLabV3? {
        do {
            let config = MLModelConfiguration()
            return try DeepLabV3(configuration: config)
        } catch {
            print("Error loading model: \(error)")
            return nil
        }
    }
    
    // Function to remove the background from an image using DeepLabV3 model
    func removeBackground(from image: UIImage, completion: @escaping (UIImage?) -> Void) {
        
        self.inputImage = image
        
        guard let ciImage = CIImage(image: image) else {
            completion(nil)
            return
        }
        
        
        guard let model = try? VNCoreMLModel(for: DeepLabV3(configuration: .init()).model) else {
            completion(nil)
            return
        }
        
        let request = VNCoreMLRequest(model: model) { request, error in
            DispatchQueue.main.async {
                if let observations = request.results as? [VNCoreMLFeatureValueObservation],
                   let segmentationmap = observations.first?.featureValue.multiArrayValue {
                    
                    let segmentationMask = segmentationmap.image(min: 0, max: 1)
                    
                    self.removedBgImage = segmentationMask!.resizedImage(for: self.inputImage.size)!
                    //self.removedBgImage = self.removedBgImage.removeBlackColor(withTolerance: 0.5)
                    
                    //completion(self.removedBgImage)
                    self.maskInputImage(completion: completion)
                    
                    
                    
                    return
                }
            }
        }
        
        request.imageCropAndScaleOption = VNImageCropAndScaleOption.scaleFill
        DispatchQueue.main.async {
            
            let handler = VNImageRequestHandler(cgImage: image.cgImage!, options: [:])
            
            do {
                try handler.perform([request])
            }catch {
                print(error)
            }
        }
    }
    
    // Performs the blend operation.
    private func blend(original framePixelBuffer: CVPixelBuffer,
                       mask maskPixelBuffer: CVPixelBuffer) {
        
        // Remove the optionality from generated color intensities or exit early.
        guard let colors = colors else { return }
        
        // Create CIImage objects for the video frame and the segmentation mask.
        let originalImage = CIImage(cvPixelBuffer: framePixelBuffer).oriented(.right)
        var maskImage = CIImage(cvPixelBuffer: maskPixelBuffer)
        
        // Scale the mask image to fit the bounds of the video frame.
        let scaleX = originalImage.extent.width / maskImage.extent.width
        let scaleY = originalImage.extent.height / maskImage.extent.height
        maskImage = maskImage.transformed(by: .init(scaleX: scaleX, y: scaleY))
        
        // Define RGB vectors for CIColorMatrix filter.
        let vectors = [
            "inputRVector": CIVector(x: 0, y: 0, z: 0, w: colors.red),
            "inputGVector": CIVector(x: 0, y: 0, z: 0, w: colors.green),
            "inputBVector": CIVector(x: 0, y: 0, z: 0, w: colors.blue)
        ]
        
        // Create a colored background image.
        let backgroundImage = maskImage.applyingFilter("CIColorMatrix",
                                                       parameters: vectors)
        
        // Blend the original, background, and mask images.
        let blendFilter = CIFilter.blendWithRedMask()
        blendFilter.inputImage = originalImage
        blendFilter.backgroundImage = backgroundImage
        blendFilter.maskImage = maskImage
        
        // Set the new, blended image as current.
        let currentCIImage = blendFilter.outputImage?.oriented(.left)
    }
    
//    func maskInputImage(completion: @escaping (UIImage?) -> Void, bgColor:UIColor = .red, bgAlpha:CGFloat = 1.0){
//        
//        //self.removedBgImage = self.removedBgImage.removeEdgeColors(withBackgroundColor: bgColor, tolerance: 1.0)
//        //self.removedBgImage = self.removedBgImage.removeEdgeNoise2(dx: 10, dy: 0)
//        //self.removedBgImage = self.removedBgImage.removeEdgeNoise2(dx: -50, dy: 0)
//        
//        var bgImage = UIImage.imageFromColor(color: bgColor.withAlphaComponent(bgAlpha), size: self.removedBgImage.size, scale: self.removedBgImage.scale)!
//        let beginImage = CIImage(cgImage: inputImage.cgImage!)
//        let background = CIImage(cgImage: bgImage.cgImage!)
//        let mask = CIImage(cgImage: self.removedBgImage.cgImage!)
//        
//        if let compositeImage = CIFilter(name: "CIBlendWithMask", parameters: [
//            kCIInputImageKey: beginImage,
//            kCIInputBackgroundImageKey:background,
//            kCIInputMaskImageKey:mask])?.outputImage
//        {
//            
//            let ciContext = CIContext(options: nil)
//            let filteredImageRef = ciContext.createCGImage(compositeImage, from: compositeImage.extent)
//            
//            let outputImage = UIImage(cgImage: filteredImageRef!)
//            
//            completion(outputImage)
//        } else {
//            completion(nil)
//        }
//    }
    
    func maskInputImage(completion: @escaping (UIImage?) -> Void, bgColor:UIColor = .white, bgAlpha:CGFloat = 1.0){
    
        self.bgColor = bgColor
        
        
        let bgImage = UIImage.imageFromColor(color: self.bgColor.withAlphaComponent((self.bgColor == .clear) ? 0.0:bgAlpha), size: self.removedBgImage.size, scale: self.removedBgImage.scale)!
        let beginImage = CIImage(cgImage: inputImage.cgImage!)
        let background = CIImage(cgImage: bgImage.cgImage!)
        let mask = CIImage(cgImage: self.removedBgImage.cgImage!)
        
        guard let output = blendImages(
            background: background,
            foreground: beginImage,
          mask: mask) else {
            print("Error blending images")
            return
        }
        
        if let photoResult = renderAsUIImage(output) {
            completion(photoResult)
        }
        
//        if let compositeImage = CIFilter(name: "CIBlendWithMask", parameters: [
//            kCIInputImageKey: beginImage,
//            kCIInputBackgroundImageKey:background,
//            kCIInputMaskImageKey:mask])?.outputImage
//        {
//            
//            let ciContext = CIContext(options: nil)
//            let filteredImageRef = ciContext.createCGImage(compositeImage, from: compositeImage.extent)
//            
//            let outputImage = UIImage(cgImage: filteredImageRef!)
//            
//            completion(outputImage)
//        } else {
//            completion(nil)
//        }
    }
    
    func blendImages(
      background: CIImage,
      foreground: CIImage,
      mask: CIImage,
      isRedMask: Bool = false
    ) -> CIImage? {
      // scale mask
      let maskScaleX = foreground.extent.width / mask.extent.width
      let maskScaleY = foreground.extent.height / mask.extent.height
      let maskScaled = mask.transformed(by: __CGAffineTransformMake(maskScaleX, 0, 0, maskScaleY, 0, 0))

      // scale background
      let backgroundScaleX = (foreground.extent.width / background.extent.width)
      let backgroundScaleY = (foreground.extent.height / background.extent.height)
      let backgroundScaled = background.transformed(
        by: __CGAffineTransformMake(backgroundScaleX, 0, 0, backgroundScaleY, 0, 0))

      let blendFilter = isRedMask ? CIFilter.blendWithRedMask() : CIFilter.blendWithMask()
      blendFilter.inputImage = foreground
      blendFilter.backgroundImage = backgroundScaled
      blendFilter.maskImage = maskScaled

      return blendFilter.outputImage
    }
    
    private func renderAsUIImage(_ image: CIImage) -> UIImage? {
        let context = CIContext()
      guard let cgImage = context.createCGImage(image, from: image.extent) else {
        return nil
      }
      return UIImage(cgImage: cgImage)
    }
}

extension UIImage {
    
    func removeBlackColor(withTolerance tolerance: CGFloat) -> UIImage? {
            guard let cgImage = self.cgImage else { return nil }
            
            let width = cgImage.width
            let height = cgImage.height
            
            guard let colorSpace = cgImage.colorSpace else { return nil }
            guard let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: 8, bytesPerRow: width * 4, space: colorSpace, bitmapInfo: cgImage.bitmapInfo.rawValue) else { return nil }
            
            context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
            
            guard let data = context.data else { return nil }
            let buffer = data.bindMemory(to: UInt32.self, capacity: width * height)
            
            for y in 0..<height {
                for x in 0..<width {
                    let offset = y * width + x
                    let color = buffer[offset]
                    
                    let r = CGFloat((color >> 16) & 0xff) / 255.0
                    let g = CGFloat((color >> 8) & 0xff) / 255.0
                    let b = CGFloat(color & 0xff) / 255.0
                    
                    // Check if the pixel is close to black with the given tolerance
                    if r <= tolerance && g <= tolerance && b <= tolerance {
                        // Set the pixel to transparent
                        buffer[offset] = 0x0
                    }
                }
            }
            
            guard let outputCGImage = context.makeImage() else { return nil }
            let outputImage = UIImage(cgImage: outputCGImage)
            return outputImage
        }
    
    func imageWithPadding(padding: UIEdgeInsets, backgroundColor: UIColor = .clear) -> UIImage? {
        let newSize = CGSize(width: size.width + padding.left + padding.right,
                             height: size.height + padding.top + padding.bottom)
        
        UIGraphicsBeginImageContextWithOptions(newSize, true, scale)
        defer { UIGraphicsEndImageContext() }
        
        backgroundColor.setFill()
        UIRectFill(CGRect(origin: .zero, size: newSize))
        
        draw(in: CGRect(origin: CGPoint(x: padding.left, y: padding.top), size: size))
        
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    func imageWithBorder(width: CGFloat, color: UIColor) -> UIImage? {
            // 计算新图像的大小
            let newSize = CGSize(width: size.width + 2 * width, height: size.height + 2 * width)
            
            // 创建一个透明的图形上下文
            UIGraphicsBeginImageContextWithOptions(newSize, false, scale)
            
            // 在图形上下文中绘制边框
            let context = UIGraphicsGetCurrentContext()!
            context.setStrokeColor(color.cgColor)
            context.setLineWidth(width)
            let rect = CGRect(x: width, y: width, width: size.width, height: size.height)
            context.stroke(rect)
            
            // 在图形上下文中绘制图像
            draw(in: CGRect(x: width, y: width, width: size.width, height: size.height))
            
            // 从图形上下文中获取新图像
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            
            // 结束图形上下文
            UIGraphicsEndImageContext()
            
            return newImage
        }
    
    func resizedImage(for size: CGSize) -> UIImage? {
        let image = self.cgImage
        let context = CGContext(data: nil,
                                width: Int(size.width),
                                height: Int(size.height),
                                bitsPerComponent: image!.bitsPerComponent,
                                bytesPerRow: Int(size.width),
                                space: image?.colorSpace ?? CGColorSpace(name: CGColorSpace.sRGB)!,
                                bitmapInfo: image!.bitmapInfo.rawValue)
        context?.interpolationQuality = .high
        context?.draw(image!, in: CGRect(origin: .zero, size: size))
        
        guard let scaledImage = context?.makeImage() else { return nil }
        
        return UIImage(cgImage: scaledImage)
    }
    
    class func imageFromColor(color: UIColor, size: CGSize=CGSize(width: 1, height: 1), scale: CGFloat) -> UIImage? {
            UIGraphicsBeginImageContextWithOptions(size, false, scale)
            color.setFill()
            UIRectFill(CGRect(origin: CGPoint.zero, size: size))
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return image
        }
    
    func imageByApplyingAlpha(_ alpha: CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        guard let ctx = UIGraphicsGetCurrentContext(), let cgImage = cgImage else {
            return self
        }

        let area = CGRect(x: 0, y: 0, width: size.width, height: size.height)

        ctx.scaleBy(x: 1, y: -1)
        ctx.translateBy(x: 0, y: -area.size.height)

        ctx.setBlendMode(.multiply)
        ctx.setAlpha(alpha)

        ctx.draw(cgImage, in: area)

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage ?? self
    }
    
    func smoothed(withRadius radius: CGFloat) -> UIImage? {
        guard let ciImage = CIImage(image: self) else {
            return nil
        }
        
        let context = CIContext(options: nil)
        let clampFilter = CIFilter(name: "CIAffineClamp")
        clampFilter?.setValue(ciImage, forKey: kCIInputImageKey)
        
        let blurFilter = CIFilter(name: "CIGaussianBlur")
        blurFilter?.setValue(clampFilter?.outputImage, forKey: kCIInputImageKey)
        blurFilter?.setValue(radius, forKey: kCIInputRadiusKey)
        
        if let outputImage = blurFilter?.outputImage,
           let cgImage = context.createCGImage(outputImage, from: ciImage.extent) {
            return UIImage(cgImage: cgImage)
        }
        
        return nil
    }
    
    func removeEdgeNoise2(dx: CGFloat = 0.0, dy:CGFloat = 0.0) -> UIImage? {
        guard let ciImage = CIImage(image: self) else {
            return nil
        }

        // 使用 CICrop 滤镜去除图像边缘的像素
        var croppedImage = ciImage.cropped(to: ciImage.extent.insetBy(dx: dx, dy: dy))
        //croppedImage = ciImage.cropped(to: ciImage.extent.insetBy(dx: -15, dy: 0))

        // 使用 CIDither 滤镜平滑边缘
        let ditherFilter = CIFilter(name: "CIDither")
        ditherFilter?.setValue(croppedImage, forKey: kCIInputImageKey)

        if let outputImage = ditherFilter?.outputImage,
           let cgImage = CIContext().createCGImage(outputImage, from: outputImage.extent) {
            return UIImage(cgImage: cgImage)
        }

        return nil
    }
    
    func removeEdgeNoise() -> UIImage? {
        guard let ciImage = CIImage(image: self) else {
            return nil
        }

        // 使用 CIReductionFilter 滤镜减少图像边缘的噪点
        if let noiseReductionFilter = CIFilter(name: "CIReductionFilter") {
            noiseReductionFilter.setValue(ciImage, forKey: kCIInputImageKey)
            //noiseReductionFilter.setValue(0.5, forKey: "inputAmount") // 调整参数以控制噪点减少的程度
//            noiseReductionFilter.inputImage = self
//            noiseReductionFilter.noiseLevel = 0.2
//            noiseReductionFilter.sharpness = 0.4
            //return noiseReductionFilter.outputImage
            
            if let outputImage = noiseReductionFilter.outputImage,
               let cgImage = CIContext().createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgImage)
            }
        }




        return nil
        
//        let noiseReductionfilter = CIFilter.noiseReduction()
//        noiseReductionfilter.inputImage = self
//        noiseReductionfilter.noiseLevel = 0.2
//        noiseReductionfilter.sharpness = 0.4
//        return noiseReductionfilter.outputImage
    }
    
    func removeEdgeColors(withBackgroundColor backgroundColor: UIColor, tolerance: CGFloat) -> UIImage? {
            guard let ciImage = CIImage(image: self) else {
                return nil
            }
            
            // Create a solid color image for the background
            let colorImage = CIImage(color: CIColor(color: backgroundColor))
            
            // Apply a mask to the original image
            let mask = ciImage.clampedToExtent().applyingFilter("CIMaskToAlpha")
            
            // Composite the original image with the background color
            let compositedImage = colorImage.composited(over: ciImage)
            
            // Apply the mask to the composited image
            let maskedImage = compositedImage.applyingFilter("CIBlendWithMask", parameters: [
                kCIInputMaskImageKey: mask
            ])
            
            // Convert the result to UIImage
            let context = CIContext(options: nil)
            if let cgImage = context.createCGImage(maskedImage, from: ciImage.extent) {
                return UIImage(cgImage: cgImage)
            }
            
            return nil
        }
}
