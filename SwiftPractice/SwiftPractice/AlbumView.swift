//
//  AlbumView.swift
//  SwiftPractice
//
//  Created by xuzepei on 16/6/30.
//  Copyright © 2016年 xuzepei. All rights reserved.
//

import UIKit

class AlbumView: UIView {
    
    private var coverImageView: UIImageView!
    private var indictaor: UIActivityIndicatorView!
    var album: Album!
    
    deinit {
        coverImageView.removeObserver(self, forKeyPath: "image")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    func commonInit() {self
        backgroundColor = UIColor.blackColor()
        
        //image view
        if coverImageView == nil {
            coverImageView = UIImageView(frame: CGRect(x: 5, y: 5, width: frame.size.width - 10, height: frame.size.height - 10))
            addSubview(coverImageView)
            
            coverImageView.addObserver(self, forKeyPath: "image", options: [], context: nil)
        }
        
        //indicator
        indictaor = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        indictaor.frame = CGRectMake((frame.size.width - indictaor.bounds.size.width)/2.0,(frame.size.height - indictaor.bounds.size.height)/2.0, indictaor.bounds.size.width, indictaor.bounds.size.height)
        indictaor.startAnimating()
        addSubview(indictaor)
    }
    
    func highlightAlbum(didHighlight: Bool) {
    
        if didHighlight == true {
            backgroundColor = UIColor.whiteColor()
        } else {
            backgroundColor = UIColor.blackColor()
        }
    }
    
    
    func updateContent(album: Album) {
        
        self.album = album
        if self.album.coverUrl.characters.count > 0 {
            //ImageLoader.sharedInstance.downloadImageByUrl(self.album.coverUrl, delegate: self)
            ImageLoader.sharedInstance.downloadImageByUrl(self.album.coverUrl, completionWith: { (image) -> Void in
                self.coverImageView.image = image
            })
            
        }
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        if keyPath == "image" {
            indictaor.stopAnimating()
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        
        NSNotificationCenter.defaultCenter().postNotificationName("HighlightAlbum", object: nil, userInfo: ["albumView": self])
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}

extension AlbumView: ImageLoaderProtocol {

    func downloadedImageSuccessfully(imageUrl: String, token: AnyObject?) {
        if self.album.coverUrl == imageUrl {
            self.coverImageView.image = Tool.getImageFromLocal(imageUrl)
        }
    }
    
    func failedToDownloadImage(imageUrl: String, token: AnyObject?) {
        NSLog("failedToDownloadImage:%@", imageUrl)
    }
}
