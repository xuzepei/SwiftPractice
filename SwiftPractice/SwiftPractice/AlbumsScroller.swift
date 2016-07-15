//
//  AlbumsScroller.swift
//  SwiftPractice
//
//  Created by xuzepei on 16/6/30.
//  Copyright © 2016年 xuzepei. All rights reserved.
//

import UIKit

class AlbumsScroller: UIView, UIScrollViewDelegate {
    
    private var scroller: UIScrollView!
    private var albums = [Album]()
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didSelectAlbum:", name: "HighlightAlbum", object: nil)
        loadAlbumViews()
    }
    
    func initScroller () {
    
        //1
        scroller = UIScrollView()
        scroller.frame = CGRectMake(0, 0, self.bounds.width, self.bounds.height)
        addSubview(scroller)
        
        //2
        scroller.translatesAutoresizingMaskIntoConstraints = false
        //3
        self.addConstraint(NSLayoutConstraint(item: scroller, attribute: .Leading, relatedBy: .Equal, toItem: self, attribute: .Leading, multiplier: 1.0, constant: 0.0))
        self.addConstraint(NSLayoutConstraint(item: scroller, attribute: .Trailing, relatedBy: .Equal, toItem: self, attribute: .Trailing, multiplier: 1.0, constant: 0.0))
        self.addConstraint(NSLayoutConstraint(item: scroller, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1.0, constant: 0.0))
        self.addConstraint(NSLayoutConstraint(item: scroller, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1.0, constant: 0.0))
    
    }
    
    func loadAlbumViews() {
        
        initScroller()
        
        let albumHeight = self.bounds.height
        let padding = 10.0
        albums = DataManager.sharedInstance.getAlbums()
        scroller.contentSize = CGSize(width: CGFloat(albums.count + 2) * (albumHeight + CGFloat(padding)), height: albumHeight)
        
        var offsetX = self.bounds.height + CGFloat(padding)
        var index:Int = 0
        for album in albums {
            
            let albumView = AlbumView(frame: CGRectMake(offsetX, 0, albumHeight, albumHeight))
            albumView.updateContent(album)
            
            let selectedAlbum = DataManager.sharedInstance.selectedAlbum
            if selectedAlbum.coverUrl == album.coverUrl {
                albumView.highlightAlbum(true)
            }
            
            scroller.addSubview(albumView)
            offsetX += albumHeight + CGFloat(padding)
            
            index++;
        }
        
        
    }
    
    func didSelectAlbum(notification: NSNotification) {
        
        if let userInfo = notification.userInfo {
        
            let willHighlightAlum = userInfo["albumView"] as! AlbumView
            
            let albumViews = scroller.subviews
            for albumView in albumViews {
                if let albumView = albumView as? AlbumView {
                    
                    albumView.highlightAlbum((willHighlightAlum == albumView) ? true : false)
                    
                }
            }
        }
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
