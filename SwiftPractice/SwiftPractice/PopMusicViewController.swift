//
//  PopMusicViewController.swift
//  SwiftPractice
//
//  Created by xuzepei on 16/6/29.
//  Copyright © 2016年 xuzepei. All rights reserved.
//

import UIKit

class PopMusicViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var scroller: UIView!
    
    private var albums = [Album]()
    private var currentAlbum: Album?
    private var currentAlbumData: (titles:[String], values:[String])?
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didSelectAlbum:", name: "HighlightAlbum", object: nil)
        
        self.title = "Pop Music"

        loadAlbums()
        
        tableView.reloadData()
        
        initToolbar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadAlbums() {
        
        albums = DataManager.sharedInstance.getAlbums()
        currentAlbum = DataManager.sharedInstance.selectedAlbum
    }
    
    func didSelectAlbum(notification: NSNotification) {
        
        if let userInfo = notification.userInfo {
            
            let didSelectAlbumView = userInfo["albumView"] as! AlbumView
            if currentAlbum?.coverUrl != didSelectAlbumView.album.coverUrl {
                DataManager.sharedInstance.selectedAlbum = didSelectAlbumView.album
                DataManager.sharedInstance.saveSelectedAlbum()
                currentAlbum = didSelectAlbumView.album
                tableView.reloadData()
            }

        }
    }
    
    
    func initToolbar() {
        let leftItem = UIBarButtonItem(barButtonSystemItem: .Undo, target: self, action: "clickedUndoButton:")
        
        let middleItem = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        
        let rightItem = UIBarButtonItem(barButtonSystemItem: .Trash, target: self, action: "clickedDeleteButton:")
        
        toolbar.setItems([leftItem, middleItem, rightItem], animated: false)
    }
    
    func clickedUndoButton(sender:AnyObject) {
        
        NSLog("clickedUndoButton:%@",sender.description)
        
    }
    
    func clickedDeleteButton(sender:AnyObject) {
        NSLog("clickedUndoButton:%@",sender.description)
        
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension PopMusicViewController: UITableViewDataSource, UITableViewDelegate {
    
//    func dataForCellByIndexPath(indexPath: NSIndexPath) -> Album? {
//        if indexPath.row < items.count {
//            return items[indexPath.row]
//        }
//        
//        return nil
//    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("album_cell", forIndexPath: indexPath)
        
        if let currentAlbum = currentAlbum {
            currentAlbumData = currentAlbum.formattedData()
            if let currentAlbumData = currentAlbumData {
                cell.textLabel?.text = currentAlbumData.titles[indexPath.row]
                cell.detailTextLabel?.text = currentAlbumData.values[indexPath.row]
            }
        }
 
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true);
        
        
    }
}
