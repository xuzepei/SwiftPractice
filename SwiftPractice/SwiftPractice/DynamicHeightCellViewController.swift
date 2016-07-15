//
//  DynamicHeightCellViewController.swift
//  SwiftPractice
//
//  Created by xuzepei on 16/6/6.
//  Copyright © 2016年 xuzepei. All rights reserved.
//

import UIKit

class DynamicHeightCellViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate {
    
    //MARK:- Properties
    @IBOutlet weak var tableView:UITableView!
    
    var items = [[String:String]]()

    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Dynamic Height Cells"

        // Do any additional setup after loading the view.
        items += loadItems()
        configureTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- UITableView
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }
    
//    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        return 100.0
//    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
            //cell loaded from xib
            let cell = tableView.dequeueReusableCellWithIdentifier("RCCellFromXibId", forIndexPath: indexPath) as! RCCellFromXib
            //cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator;
            //cell.backgroundColor = UIColor.yellowColor()
            //cell.textLabel?.text = items[indexPath.row]["title"];
            cell.titleTV.delegate = self;
            cell.descriptionTV.delegate = self;
            cell.myLabel.text = items[indexPath.row]["title"]
            cell.titleTV.text = items[indexPath.row]["title"]
            cell.descriptionTV.text = items[indexPath.row]["description"]

            
            return cell

    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true);
        
        
    }
    
    func configureTableView() {
    
        //register xib of cell
        tableView.registerNib(UINib(nibName: "RCCellFromXib", bundle: nil), forCellReuseIdentifier: "RCCellFromXibId")
        
        //Only for iOS8+
        tableView.rowHeight = UITableViewAutomaticDimension;
        tableView.estimatedRowHeight = 44.0
    }
    
    func loadItems() -> [[String: String]]{
        
        return [["title":"title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1aaaaaaa", "description":"description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1aaaaaaaaaaaaaaaaaaaaaaaadescription1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1aaaaaaaaaaaaaaaaaaaaaaaadescription1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1aaaaaaaaaaaaaaaaaaaaaaaadescription1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1aaaaaaaaaaaaaaaaaaaaaaaadescription1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1aaaaaaaaaaaaaaaaaaaaaaaadescription1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1aaaaaaaaaaaaaaaaaaaaaaaadescription1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1aaaaaaaaaaaaaaaaaaaaaaaadescription1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1aaaaaaaaaaaaaaaaaaaaaaaadescription1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1aaaaaaaaaaaaaaaaaaaaaaaadescription1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1aaaaaaaaaaaaaaaaaaaaaaaadescription1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1bbbbbbbbbbbbbbbbb"],["title":"title2", "description":"description2"]]
    }
    
    func textViewDidChange(textView: UITextView) {
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
//    func textDidChange(textView:UITextView) {
//    
//        var bounds = textView.bounds
//        let maxSize = CGSizeMake(bounds.size.width, CGFloat.max)
//        let newSize = textView .sizeThatFits(maxSize)
//        bounds.size = newSize
//        
//        textView.bounds = bounds
//        
//        tableView.beginUpdates()
//        tableView.endUpdates()
//        
//        
//    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */

}
