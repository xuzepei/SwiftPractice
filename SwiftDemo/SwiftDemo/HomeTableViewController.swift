//
//  HomeTableViewController.swift
//  SwiftDemo
//
//  Created by xuzepei on 2023/7/11.
//

import UIKit
import PowerplayToastKit
import SnapKit

class HomeTableViewController: UITableViewController {
    
    var itemArray = NSMutableArray()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        itemArray.addObjects(from: ["AutoLayout-UIStackView","UICollectionView","ScanAnimation","Toast"])
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
        } else if indexPath.row == 3 {
            
//            let attributes = [
//                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),
//                NSAttributedString.Key.foregroundColor: UIColor.black
//            ]
//            let attributedString  = NSMutableAttributedString(string: "You can use The Swift Package Manager to install Toast-Swift by adding the description to your Package.swift file" , attributes: attributes)
//
//            let subtitleAttributes = [
//                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12),
//                NSAttributedString.Key.foregroundColor: UIColor.systemGray
//            ]
//            let subtitle = NSMutableAttributedString(string: "subtitle" , attributes: subtitleAttributes)
//            let toast = Toast.default(image:UIImage(named: "error")!,title:attributedString, subtitle:nil, viewConfig: .init(minHeight: 40, lightBackgroundColor: UIColor.errorToastSecondaryColor, titleNumberOfLines: 0, cornerRadius: 8),config: .init(
//                direction: .bottom,
//                dismissBy: [.time(time: 2)]))
//            toast.show()
            
            Tool.showToast(text: "You can use The Swift Package Manager to install Toast-Swift by adding the description to your Package.swift file", type: .Info)
            
            
            
            
            //toast.show(haptic: .success, after: 1)
            // success Toast at top
//            let heading = "Success"
//            let message = "This method was a success"
//            PowerplayToastKit
//                .shared
//                .showToast(of: .success(title: "", message: message), at: .center)

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
