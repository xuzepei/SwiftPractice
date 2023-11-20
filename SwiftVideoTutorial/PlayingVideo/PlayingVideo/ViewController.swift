//
//  ViewController.swift
//  PlayingVideo
//
//  Updated by macbookpro on 30.04.2022.
//  Copyright © 2022 halilozel. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import CoreImage
import CoreImage.CIFilterBuiltins

class ViewController: UIViewController {
    
    // A playerController object is defined to handle the AVPlayerViewController event.
    var playerController = AVPlayerViewController()
    
    // The AVPlayer object has been defined.
    var player : AVPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // The videoString value gives information about the video. -> music.mp4
        let videoString = Bundle.main.path(forResource: "music", ofType: "mp4")
        

        

    }
    
    
    // Video playback by clicking the button
    @IBAction func playVideo(_ sender: Any) {
        
        // The URL value is assigned to the player object.
        player = AVPlayer(url: NSURL.fileURL(withPath: NSTemporaryDirectory() + "/test.mp4"))
        // A player object is assigned to the player value in the PlayerController.
        playerController.player = player
        
        // Controller, animation, completion events in present action
        self.present(self.playerController, animated: true, completion: {
            
            // Start playing player object in PlayerController
            self.playerController.player?.play()
        })
    }
    
    func removeDirectory(atPath path: String) {
        let fileManager = FileManager.default
        
        do {
            try fileManager.removeItem(atPath: path)
        } catch {
            print("Error removing directory: \(error.localizedDescription)")
            return
        }
        
        print("Directory removed successfully.")
    }

    @IBAction func addWatermark(_ sender: Any) {
        
        let videoString = Bundle.main.path(forResource: "original", ofType: "mp4")
        
        let videoURL = URL(fileURLWithPath: videoString!)
        
        let videoAsset = AVURLAsset(url: videoURL)
        let composition = AVMutableComposition()
        
        let watermarkLayer = CATextLayer()
        //        watermarkLayer.contents = watermarkImage.cgImage
        //        watermarkLayer.frame = // Set the position and size of the watermark
        //
        let text = "你好"
        let attrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 20),
            .foregroundColor: UIColor.white,
        ]
        let attrString = NSAttributedString(string: text, attributes: attrs)
        
        // 创建CATextLayer
        let textLayerWidth:CGFloat = 100
        //let textLayerHeight:CGFloat = 30
        let textSize = (text as NSString).size(withAttributes: attrs)
        watermarkLayer.backgroundColor = UIColor.red.cgColor
        watermarkLayer.string = attrString
        watermarkLayer.alignmentMode = .center
        watermarkLayer.frame = CGRect(x: 0, y: 0, width: textLayerWidth, height: textSize.height)
        //        watermarkLayer.position = CGPoint(x: layer.bounds.midX, y: layer.bounds.midY)
        //        layer.addSublayer(textLayer)
        
        let outputURL = NSURL.fileURL(withPath: NSTemporaryDirectory() + "/test.mp4")
        
        removeDirectory(atPath: NSTemporaryDirectory() + "/test.mp4")
        let inputURL = videoURL
        addTextWatermark(inputURL: inputURL, outputURL: outputURL, handler: { (exportSession) in
            guard let session = exportSession else {
                // Error
                return
            }
            
            switch session.status {
            case .completed:
                guard NSData(contentsOf: outputURL) != nil else {
                    // Error
                    return
                }
            default:
                print("error: \(session.status)")
            }
        })
    }
    
    func addImageWatermark(inputURL: URL, outputURL: URL, handler:@escaping (_ exportSession: AVAssetExportSession?)-> Void) {
        let mixComposition = AVMutableComposition()
        let asset = AVAsset(url: inputURL)
        let videoTrack = asset.tracks(withMediaType: AVMediaType.video)[0]
        let timerange = CMTimeRangeMake(start: CMTime.zero, duration: asset.duration)
        
        let compositionVideoTrack:AVMutableCompositionTrack = mixComposition.addMutableTrack(withMediaType: AVMediaType.video, preferredTrackID: CMPersistentTrackID(kCMPersistentTrackID_Invalid))!
        
        do {
            try compositionVideoTrack.insertTimeRange(timerange, of: videoTrack, at: CMTime.zero)
            compositionVideoTrack.preferredTransform = videoTrack.preferredTransform
        } catch {
            print(error)
        }
        
        let watermarkFilter = CIFilter(name: "CISourceOverCompositing")!
        let watermarkImage = CIImage(image: UIImage(named: "mark")!)
        
        let videoComposition = AVVideoComposition(asset: asset) { (filteringRequest) in
            let source = filteringRequest.sourceImage.clampedToExtent()
            watermarkFilter.setValue(source, forKey: "inputBackgroundImage")
//            let transform = CGAffineTransform(translationX: filteringRequest.sourceImage.extent.width - (watermarkImage?.extent.width)! - 2, y: 0)
            
            let transform = CGAffineTransform(translationX: 0, y: 0)
            watermarkFilter.setValue(watermarkImage?.transformed(by: transform), forKey: "inputImage")
            filteringRequest.finish(with: watermarkFilter.outputImage!, context: nil)
        }
        
        guard let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPreset1280x720) else {
            handler(nil)
            
            return
        }
        
        exportSession.outputURL = outputURL
        exportSession.outputFileType = AVFileType.mp4
        exportSession.shouldOptimizeForNetworkUse = true
        exportSession.videoComposition = videoComposition
        exportSession.exportAsynchronously { () -> Void in
            handler(exportSession)
        }
    }
    
    
    func addTextWatermark(inputURL: URL, outputURL: URL, handler:@escaping (_ exportSession: AVAssetExportSession?)-> Void) {
        let mixComposition = AVMutableComposition()
        let asset = AVAsset(url: inputURL)
        let videoTrack = asset.tracks(withMediaType: AVMediaType.video)[0]
        let timerange = CMTimeRangeMake(start: CMTime.zero, duration: asset.duration)
        
        let compositionVideoTrack:AVMutableCompositionTrack = mixComposition.addMutableTrack(withMediaType: AVMediaType.video, preferredTrackID: CMPersistentTrackID(kCMPersistentTrackID_Invalid))!
        
        do {
            try compositionVideoTrack.insertTimeRange(timerange, of: videoTrack, at: CMTime.zero)
            compositionVideoTrack.preferredTransform = videoTrack.preferredTransform
        } catch {
            print(error)
        }
        
        var attrs : [NSAttributedString.Key : Any] = [
            .font : UIFont.boldSystemFont(ofSize: 20),
            NSAttributedString.Key.foregroundColor : UIColor.white.withAlphaComponent(0.5),
        ]
        
        let watermarkText = NSAttributedString(string: "Watermark", attributes: attrs)
        let textFilter = CIFilter.attributedTextImageGenerator()
        textFilter.text = watermarkText
        textFilter.scaleFactor = 2.0
        
        let videoComposition = AVVideoComposition(asset: asset) { (filteringRequest) in
            let positionedText = textFilter.outputImage!.transformed(by: CGAffineTransform(translationX: (filteringRequest.renderSize.width - textFilter.outputImage!.extent.width - 8), y: 0))
            filteringRequest.finish(with: positionedText.composited(over: filteringRequest.sourceImage), context: nil)
        }
        
        guard let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPreset1280x720) else {
            handler(nil)
            
            return
        }
        
        exportSession.outputURL = outputURL
        exportSession.outputFileType = AVFileType.mp4
        exportSession.shouldOptimizeForNetworkUse = true
        exportSession.videoComposition = videoComposition
        exportSession.exportAsynchronously { () -> Void in
            handler(exportSession)
        }
    }
}

