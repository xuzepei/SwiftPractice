//
//  PhoteSizeSelectionViewController.swift
//  SwiftDemo
//
//  Created by xuzepei on 2024/2/21.
//

import UIKit

class PhoteSizeSelectionViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: ScrollableSegmentedControl!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var itemArray: NSMutableArray = NSMutableArray()
    var selectedIndexPath: IndexPath = IndexPath(row: 0, section: 0)
    var keyword: String = ""
    
    let cellNibName = "PhotoSizeCell"
    let cellId = "photo_size_cell"
    
    var currentPageIndex: Int = 1
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setup()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        if 0 == self.itemArray.count /*&& User.shared.isLogined()*/ {
//            
//            let delayInSeconds: Double = 0.3 // Delay for 2 seconds
//            let dispatchTime = DispatchTime.now() + delayInSeconds
//            DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
//                if User.shared.isLogined() {
//                    self.updateContent()
//                }
//            }
//            
//        }
        
        self.tableView.reloadData()
    }
    
    func setup() {
        
        self.view.backgroundColor = .white
        
        initTableView()
        initSearchBar()
    }
    
    func initTableView() {
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        //self.tableView.backgroundColor = .blue
        
        var nib = UINib(nibName: cellNibName, bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: cellId)
        
    }
    
    func initSearchBar() {
        
        //self.segmentedControl.margin = 4
        self.searchBar.barStyle = .default
        self.searchBar.delegate = self
        //self.searchBar.showsCancelButton = true
        
        //remove border
        self.searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // This method is called when the user taps the search button on the keyboard
        print("Search button clicked")
        
        if let text = searchBar.text {
            self.keyword = text
        }
        
        //updateContent()
        
        
        // Perform your search operation here
        self.searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("searchText",searchText)
        self.keyword = searchText
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


// MARK: -
extension PhoteSizeSelectionViewController: UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //add or remove the no item view for like categroy
        //        if self.index == 1 {
        //            if(self.itemArray.count == 0) {
        //                if let temp = noItemImage {
        //                    self.tableView?.addSubview(temp)
        //                }
        //            } else {
        //                if let temp = noItemImage {
        //                    temp.removeFromSuperview()
        //                }
        //            }
        //        }
        
        print("self.itemArray.cout: \(self.itemArray.count)")
        
        return self.itemArray.count
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//
//        //        if(indexPath.row == 0) {
//        //            return 0
//        //            //return self.headerHeight - (Tool.hasNotch() ? 30.0 : 0) - Tool.valueForBoth(12, 12)
//        //        } else if (indexPath.row == self.itemArray.count + 1) {
//        //            return 100
//        //        }
//        //
//        return self.getCellHeight(indexPath: indexPath)
//
//        //return 80
//    }
    
    func getCellDataAtIndexPath(_ indexPath: IndexPath) -> Any? {
        
        if (indexPath.row < self.itemArray.count) {
            return self.itemArray[indexPath.row]
        }
        
        return nil
    }
    
    func getCellHeight(indexPath: IndexPath) -> CGFloat {
        
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.accessoryType = .disclosureIndicator
        let item = getCellDataAtIndexPath(indexPath) as? Dictionary<String, AnyObject>
        
        if let mycell = cell as? PhotoSizeCell {
            mycell.updateContent(data: item, delegate: nil)
        }
        
        return cell
    }
    
    //    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    //        let lastIndex = itemArray.count
    //        if (itemArray.count > 0) && indexPath.row == lastIndex {
    //            print("!!!scrolled to the last cell");
    //
    //            checkToDownload();
    //        }
    //    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.selectedIndexPath = indexPath
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        print("didSelectRowAt: \(indexPath.row)")
        
//        if let item = getCellDataAtIndexPath(indexPath) as? Dictionary<String, AnyObject> {
//            let vc = createCaseDetailVC()
//            vc.item = item
//            vc.updateContent()
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
        
    }
    
}
