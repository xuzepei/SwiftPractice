//
//  TagViewController.swift
//  SwiftDemo
//
//  Created by xuzepei on 2024/1/5.
//

import UIKit
import TagListView
import TTGTags

class TagViewController: UIViewController, TTGTextTagCollectionViewDelegate {
    
    
    @IBOutlet weak var tagListView: TagListView!
    @IBOutlet weak var textTagCollectionView: TTGTextTagCollectionView!
    
    @IBOutlet weak var tagsView: TagsView!
    @IBOutlet weak var tagsViewConstraintHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tagListView.addTags(["storyboard-based", "Stores", "Color","Manual","storyboard-based","application","controller","segue","object","view","preparation","navigation","TagListView"])
        //tagListView.textFont = UIFont.systemFont(ofSize: 12)
        tagListView.alignment = .leading // possible values are [.leading, .trailing, .left, .center, .right]
        //tagListView.layer.masksToBounds = true
        
        for tagView in tagListView.tagViews {
            NSLog("tagView.frame: \(tagView.frame)")
        }
        
        
        
        self.textTagCollectionView.delegate = self
        self.textTagCollectionView.scrollDirection = .horizontal
        // Create TTGTextTag object
        var style = TTGTextTagStyle()
        style.backgroundColor = .orange
        style.cornerRadius = 0
        style.borderWidth = 0
        style.shadowColor = UIColor.clear
        style.extraSpace = CGSize(width: 4, height: 2)
        
        
        
        
        for str in ["storyboard-based", "Stores", "Color","Manual","storyboard-based","application","controller","segue","object","view","preparation","navigation","TagListView"] {
            
            var content = TTGTextTagStringContent(text: str)
            content.textFont = UIFont.systemFont(ofSize: 12)
            
            let textTag = TTGTextTag(content: content, style: style)
            textTagCollectionView.addTag(textTag)
        }
         
        // Add tag
        
        // !!! Never forget this !!!
        textTagCollectionView.reload()
        
        //textTagCollectionView.scrollView.showsVerticalScrollIndicator = false
        
        tagsView.lineHeight = 20
        for str in ["storyboard-based","Manual","segue","object","controller","preparation","TagListView"] {
            tagsView.addTag(text: str)
        }
        tagsViewConstraintHeight.constant = tagsView.contentHeight
        
    }
    
    func textTagCollectionView(_ textTagCollectionView: TTGTextTagCollectionView!, canTap tag: TTGTextTag!, at index: UInt) -> Bool {
        return true
    }
    
    func textTagCollectionView(_ textTagCollectionView: TTGTextTagCollectionView!, didTap tag: TTGTextTag!, at index: UInt) {
        NSLog("didTap: index: \(index), tag: \(tag.content.getAttributedString().string)")
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
