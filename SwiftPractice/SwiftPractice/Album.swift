//
//  Album.swift
//  SwiftPractice
//
//  Created by xuzepei on 16/6/30.
//  Copyright © 2016年 xuzepei. All rights reserved.
//

import UIKit

struct AlbumPropertyKey {
    static let kTitle = "title"
    static let kArtist = "artist"
    static let kGenre = "genre"
    static let kCoverUrl = "coverUrl"
    static let kYear = "year"
}

class Album: NSObject, NSCoding {
    
    var title: String!
    var artist: String!
    var genre: String!
    var coverUrl: String!
    var year: String!

    init(title: String, artist: String, genre: String, coverUrl: String, year: String) {
        super.init()
        self.title = title
        self.artist = artist
        self.genre = genre
        self.coverUrl = coverUrl
        self.year = year
    }
    
    override var description: String {
        return "title:\(title)" + "artist:\(artist)" + "genre:\(genre)" + "coverUrl:\(coverUrl)" + "year:\(year)"
    }
    
    func formattedData() -> (titles:[String], values:[String]) {
        return (["Artist", "Album", "Genre", "Year"], [artist, title, genre, year])
    }
    
    //MARK: - NSCoding
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(title, forKey: AlbumPropertyKey.kTitle)
        aCoder.encodeObject(artist, forKey: AlbumPropertyKey.kArtist)
        aCoder.encodeObject(genre, forKey: AlbumPropertyKey.kGenre)
        aCoder.encodeObject(coverUrl, forKey: AlbumPropertyKey.kCoverUrl)
        aCoder.encodeObject(year, forKey: AlbumPropertyKey.kYear)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        let title = aDecoder.decodeObjectForKey(AlbumPropertyKey.kTitle) as! String
        let artist = aDecoder.decodeObjectForKey(AlbumPropertyKey.kArtist) as! String
        let genre = aDecoder.decodeObjectForKey(AlbumPropertyKey.kGenre) as! String
        let coverUrl = aDecoder.decodeObjectForKey(AlbumPropertyKey.kCoverUrl) as! String
        let year = aDecoder.decodeObjectForKey(AlbumPropertyKey.kYear) as! String
        
        self.init(title: title, artist: artist, genre: genre, coverUrl: coverUrl, year: year)
    }
}
