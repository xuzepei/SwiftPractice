//
//  RCRootTableViewController.swift
//  SwiftPractice
//
//  Created by xuzepei on 16/6/6.
//  Copyright © 2016年 xuzepei. All rights reserved.
//

import UIKit

class RCRootTableViewController: UITableViewController {
    
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
        
        
    }
    

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        
        if let cell = sender as? UITableViewCell {
        
            if let selectedIndexPath  = self.tableView .indexPathForCell(cell) {
            
                if selectedIndexPath.row == 0 {
                
                    return true
                }
            }
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
                }
            }
        }
        
        NSLog("%@",segue.identifier ?? "Unknown segue.")
        
        if segue.identifier == "to_dynamic_height_cells" {
        
            
        }
    }

    
    func loadItems() -> [String] {
        
        return ["Dynamic Height Table View Cell","456","789"]
        
    }

}
