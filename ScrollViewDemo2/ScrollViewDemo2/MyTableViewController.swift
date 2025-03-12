//
//  MyTableViewController.swift
//  ScrollViewDemo2
//
//  Created by xuzepei on 2023/6/26.
//

import UIKit

class MyTableViewController: UITableViewController {
    
    
    var itemArray:[String] = ["ScrollView without xib", "ScrollView without content layout guid", "ScrollView with content layout guid", "ScrollView Expanding","ScrollView Sticky"]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        self.title = "ScrollView Demo"
        
        self.tableView.rowHeight = 60
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return itemArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mycell", for: indexPath) as UITableViewCell

        // Configure the cell...
        
        cell.textLabel?.text = self.itemArray[indexPath.row]
        cell.accessoryType = .disclosureIndicator

        return cell
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            let vc = ScrollView1Controller()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if indexPath.row == 1 {
            let vc = ScrollView2Controller()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if indexPath.row == 2 {
            let vc = ScrollView3Controller()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if indexPath.row == 3 {
            let vc = ExpandingScrollViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if indexPath.row == 4 {
            let vc = ScrollViewStickyController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
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
