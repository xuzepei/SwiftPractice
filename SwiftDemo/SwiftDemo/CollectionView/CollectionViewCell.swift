//
//  CollectionViewCell.swift
//  SwiftDemo
//
//  Created by xuzepei on 2023/7/11.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

    static let reuseIdentifier = "FlickrCell"
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    
    var data: Dictionary<String,AnyObject>? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.contentView.backgroundColor = .black
        self.bgView.backgroundColor = .black
    }
    
    func updateContent(data: Dictionary<String,AnyObject>?) {
        self.data = data
        
        if let photoId = data?["id"] as? String {
            let urlString = "https://www.flickr.com/services/rest/?method=flickr.photos.getSizes&api_key=\(CollectionViewController.apiKey)&photo_id=\(photoId)&format=json&nojsoncallback=1"
            let request = HttpRequest()
            request.get(urlString, resultBlock: { data in
                //print("data: \(data)")

                var imageUrl = ""
                if let dict = data?["sizes"] as? Dictionary<String, AnyObject> {
                    if let items = dict["size"] as? [Dictionary<String, AnyObject>] {

                        for item in items {
                            if let label = item["label"] as? String {
                                
                                if label == "Small" {
                                    if let source = item["source"] as? String {
                                        if source.count > 0 {
                                            imageUrl = source
                                            break
                                        }
                                    }
                                }

                            }
                        }

                    }
                }

                if imageUrl.count > 0 {
                    self.imageView.load(url: imageUrl)
                } else {
                    self.imageView.image = nil
                }

            }, token: nil)
            
            
        }
        
        
        
    }

}
