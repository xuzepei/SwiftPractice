//
//  HomeTableViewController.swift
//  SwiftDemo
//
//  Created by xuzepei on 2023/7/11.
//

import UIKit

class HomeTableViewController: UITableViewController {
    
    var itemArray = NSMutableArray()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        itemArray.addObjects(from: ["AutoLayout-UIStackView","UICollectionView","ScanAnimation"])
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
    
    
    func getItemByIndex(indexPath: IndexPath) -> String? {
        return self.itemArray[indexPath.row] as? String
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mycell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = getItemByIndex(indexPath: indexPath)
        cell.accessoryType = .disclosureIndicator

        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            let vc = AutoLayoutViewController()
            vc.title = getItemByIndex(indexPath: indexPath)
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 1 {
            let vc = CollectionViewController()
            vc.title = getItemByIndex(indexPath: indexPath)
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 2 {
            let vc = ScanAnimationViewController()
            vc.title = getItemByIndex(indexPath: indexPath)
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
