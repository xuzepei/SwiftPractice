//
//  VideoPlayer.swift
//  VideoPlayerTest
//
//  Created by xuzepei on 2023/5/28.
//

import UIKit
import AVKit
import AVFoundation

class VideoPlayer: NSObject {
    
    var player: AVPlayer? = nil
    var playerLayer: AVPlayerLayer? = nil
    var playImageLayer: CALayer = CALayer()
    weak var container: UIView? = nil
    var filepath: String = ""
    
    override init() {
        super.init()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        if let player = self.player {
            player.removeObserver(self, forKeyPath: "timeControlStatus")
            self.player?.pause()
            self.player = nil
        }
        
        self.playerLayer?.removeFromSuperlayer()
        self.playerLayer = nil
        self.container = nil
    }
    
    func setup(filepath: String, container: UIView) {
        
        if nil == self.player {
            self.container = container
            self.filepath = filepath
            
            //1.
            // Create an AVPlayerItem with the URL
            let playerItem = AVPlayerItem(url: URL(fileURLWithPath: self.filepath))
            
            // Initialize the AVPlayer with the AVPlayerItem
            self.player = AVPlayer(playerItem: playerItem)
            
            // Set up the AVPlayerLayer to display the video
            self.playerLayer = AVPlayerLayer(player: self.player)
            self.playerLayer?.frame = self.container!.bounds
            self.playerLayer?.cornerRadius = 20
            
            self.container!.layer.addSublayer(self.playerLayer!)
            
            // Set actionAtItemEnd to .none so that the video automatically restarts from the beginning
            self.player?.actionAtItemEnd = .none
            
            // Add a UITapGestureRecognizer to the playerLayer's view
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(playerLayerTapped))
            self.container!.addGestureRecognizer(tapGestureRecognizer)
            

            //2.
            // Create a new CALayer for the image overlay
            playImageLayer.contents = UIImage(named: "play")?.cgImage // Set the layer's contents to an image
            playImageLayer.frame = CGRect(x: (self.playerLayer!.bounds.size.width - 40)/2.0, y: (self.playerLayer!.bounds.size.height - 40)/2.0, width: 40, height: 40) // Set the layer's frame

            //playImageLayer.isHidden = true
            // Add the image layer as a sublayer of the playerLayer
            self.playerLayer?.addSublayer(playImageLayer)
            
            
            //3.
            // Add an observer for when the video ends
            NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidPlayToEndTime), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
            
            self.player?.addObserver(self, forKeyPath: "timeControlStatus", options: [.initial, .new], context: nil)
            
            
            // Start playing the video
            self.player?.play()
        }
        
    }
    
    @objc func playerItemDidPlayToEndTime(noti: NSNotification) {
        // Restart the video from the beginning
        self.player?.seek(to: CMTime.zero)
        self.player?.play()
    }
    
    // Handle the tap gesture
    @objc func playerLayerTapped() {
        // Handle the playerLayer click event
        print("Player layer tapped!")
        
        if self.player?.timeControlStatus == .playing {
            self.player?.pause()
            //playImageLayer.isHidden = true
        } else if self.player?.timeControlStatus == .paused {
            self.player?.play()
        }
    }
    
    // Handle changes to the player's timeControlStatus property
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "timeControlStatus" {
            if let statusNumber = change?[.newKey] as? NSNumber, let status = AVPlayer.TimeControlStatus(rawValue: statusNumber.intValue) {
                switch status {
                case .paused:
                    // Handle paused status
                    playImageLayer.isHidden = false
                    break
                case .playing:
                    // Handle playing status
                    playImageLayer.isHidden = true
                    break
                case .waitingToPlayAtSpecifiedRate:
                    // Handle waiting status
                    break
                @unknown default:
                    // Handle any future statuses that may be added to the enum
                    break
                }
            }
        }
    }

}
