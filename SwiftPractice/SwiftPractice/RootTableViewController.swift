//
//  RootTableViewController.swift
//  SwiftPractice
//
//  Created by xuzepei on 16/6/6.
//  Copyright © 2016年 xuzepei. All rights reserved.
//

import UIKit

class RootTableViewController: UITableViewController {
    
    //MARK: - Properties
    var items = [String]()
    
    //MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        items += loadItems()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        if Tool.isReachableViaInternet() {
            requestData()
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("root_table_cell", forIndexPath: indexPath)

        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator;
        cell.textLabel?.text = items[indexPath.row];

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true);
        
        switch indexPath.row {
        case 0:
            self.performSegueWithIdentifier("to_dynamic_height_cell_vc", sender: nil)
        case 1:
            break;
        case 2:
            self.performSegueWithIdentifier("to_popmusic_vc", sender: nil)
        case 3:
            self.performSegueWithIdentifier("to_bitwatch_vc", sender: nil)
        default:
            break;
        }
    }
    

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        
        if let cell = sender as? UITableViewCell {
        
//            if let selectedIndexPath  = self.tableView .indexPathForCell(cell) {
//            
//                if selectedIndexPath.row == 0 {
//                
//                    return true
//                }
//            }
            
            return true
        }
        
        return false
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if let cell = sender as? UITableViewCell {
            
            if let selectedIndexPath  = self.tableView .indexPathForCell(cell) {
                
                if selectedIndexPath.row == 0 {
                    
                    segue.destinationViewController.title = "Dynamic Height Cells";
                    
                } else if selectedIndexPath.row == 2{
                
                }
            }
        }
        
        NSLog("%@",segue.identifier ?? "Unknown segue.")
    }

    
    func loadItems() -> [String] {
        
        return ["Dynamic Height Table View Cell","PhotoTagger","Pop Music", "BitWatch"]
        
    }
    
    func requestData() {
    
        let url = "https://services.hugsnhearts.com/more/princessnewmommybaby/en-US/8FB40395-8F2B-48B4-BF25-478B84B0660B/?model=iPhone_Simulator&sysVer=9.0&bundleVer=1.4&bundleID=com.hugsnhearts.princessnewmommybaby&title=&v=2&top=&landscape=1"
        
        //using protocol
        let temp = HttpRequest()
//        temp.delegate = self
//        temp.request(.Get, url: url, token: nil, completion: nil)
        
        //using closure
        temp.request(.Get, url: url, token: nil) { (result, httpStatusCode, error) -> Void in
            
            if let jsonString = result as? String {
                
                if let dict = Tool.parseToDictionary(jsonString) {

                    let item0 = dict["default_app_icon"] as? String ?? ""
                    let item1 = dict["btn_img"] as? String ?? ""
                    var item2: [[String: AnyObject]]//= dict["apps"] as? [[String: AnyObject]] ?? ""
                    let item3 = dict["secondary_btn_img"] as? String ?? ""
                    let item4 = dict["test"] as? String ?? ""
                    
                    if let apps = dict["apps"] as? [[String: AnyObject]] {
                       item2 = apps
                    } else {
                       item2 = []
                    }
                    
                    NSLog("default_app_icon:%@,btn_img:%@,apps:%@,secondary_btn_img:%@,test:%@",item0,item1,item2,item3,item4)
                    
                }
                
            }
        }
    }

}

extension RootTableViewController: HttpRequestProtocol {
    
    func willStartRequest(token: AnyObject) {
        NSLog("willStartRequest")
    }
    
    func updatePercentage(percentage: Float, token: AnyObject) {
        NSLog("updatePercentage")
    }
    
    func didFinishRequest(result: AnyObject, token: AnyObject) {
        NSLog("didFinishRequest")
    }
    
    func didFailRequest(token: AnyObject) {
        NSLog("didFailRequest")
    }

}
