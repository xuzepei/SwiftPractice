//
//  DataManager.swift
//  SwiftPractice
//
//  Created by xuzepei on 16/6/30.
//  Copyright © 2016年 xuzepei. All rights reserved.
//

import UIKit

class DataManager: NSObject {
    
    static let sharedInstance = DataManager();
    
    private let archivePath = Tool.documentDirectory() + "/albums"
    private let archivePath2 = Tool.documentDirectory() + "/selected_album"
    private var albums = [Album]()
    var selectedAlbum: Album!
    
    override init() {
        super.init()
        
        loadAlbums()
    }
    
    func loadAlbums() {
        
        if let albums = NSKeyedUnarchiver.unarchiveObjectWithFile(archivePath) as? [Album] {
            self.albums = albums
            
            if let album = NSKeyedUnarchiver.unarchiveObjectWithFile(archivePath2) as? Album {
                self.selectedAlbum = album
            }
        }
        else  {
            let album1 = Album(title: "Best of Bowie",
                artist: "David Bowie",
                genre: "Pop",
                coverUrl: "http://a4.att.hudong.com/55/92/01300542281695138572924404362.jpg",
                year: "1992")
            
            selectedAlbum = album1;
            
            let album2 = Album(title: "It's My Life",
                artist: "No Doubt",
                genre: "Pop",
                coverUrl: "http://imgsrc.baidu.com/baike/pic/item/3a86813db20bb26abba167e6.jpg",
                year: "2003")
            
            let album3 = Album(title: "Nothing Like The Sun",
                artist: "Sting",
                genre: "Pop",
                coverUrl: "http://imgsrc.baidu.com/baike/pic/item/a8ad94136543729cf7039e95.jpg",
                year: "1999")
            
            let album4 = Album(title: "Staring at the Sun",
                artist: "U2",
                genre: "Pop",
                coverUrl: "http://cdn.duitang.com/uploads/blog/201407/01/20140701214627_UPRKL.jpeg",
                year: "2010")
            
            let album5 = Album(title: "American Pie",
                artist: "Madonna",
                genre: "Pop",
                coverUrl: "http://imgsrc.baidu.com/baike/pic/item/42e89c268f38b5598b82a130.jpg",
                year: "2000")
            self.albums = [album1, album2, album3, album4, album5]
            
            saveAlbums()
            saveSelectedAlbum()
        }
    }
    
    func getAlbums() -> [Album] {
        return albums
    }
    
    func saveAlbums() {
        let isSuccessful = NSKeyedArchiver.archiveRootObject(albums, toFile: archivePath)
        if isSuccessful == false {
            NSLog("Failed to save albums!")
        }
    }
    
    func addAlbum(album: Album, atIndex index: Int) {
        if albums.count >= index {
            albums.insert(album, atIndex: index)
        } else {
            albums.append(album)
        }
        
        saveAlbums()
    }
    
    func deleteAlbumAtIndex(index: Int) {
        if albums.count < index {
            albums.removeAtIndex(index)
            
            saveAlbums()
        }
    }
    
    func saveSelectedAlbum() {
        
        let isSuccessful = NSKeyedArchiver.archiveRootObject(selectedAlbum, toFile: archivePath2)
        if isSuccessful == false {
            NSLog("Failed to save selected album!")
        }
    }

}
