//
//  CollectionViewController.swift
//  SwiftDemo
//
//  Created by xuzepei on 2023/7/11.
//

import UIKit

class CollectionViewController: UIViewController, UISearchBarDelegate {
    
    
    //https://www.flickr.com/
    static let apiKey = "53cdf3d1f8c1caad9fcce1cda5ad8f69"
    private let itemsPerRow: CGFloat = 3
    
    let itemArray = NSMutableArray()
    
    private let sectionInsets = UIEdgeInsets(
      top: 50.0,
      left: 10.0,
      bottom: 50.0,
      right: 10.0)
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .brown
        
        // 注册单元格类型
        let nib = UINib(nibName: String(describing: CollectionViewCell.self), bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: CollectionViewCell.reuseIdentifier)
        
        
        //updateContent()
    }
    
    
    func updateContent(keyword: String) {
        
        let urlString = "https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key=53cdf3d1f8c1caad9fcce1cda5ad8f69&text=\(keyword)&format=json&nojsoncallback=1"
        HttpRequest.shared.get(urlString, resultBlock: { data in
            //print("data: \(data)")
            
            if let dict = data?["photos"] as? Dictionary<String, AnyObject> {
                if let items = dict["photo"] as? [Dictionary<String, AnyObject>] {
                    self.itemArray.removeAllObjects()
                    self.itemArray.addObjects(from: items)
                    
                    self.collectionView.reloadData()
                }
            }
        }, token: nil)
    }
    
    func getItemDataByIndex(indexPath: IndexPath) -> Dictionary<String, AnyObject>? {
        if indexPath.row < self.itemArray.count {
            return self.itemArray[indexPath.row] as? Dictionary<String, AnyObject>
        }
        
        return nil
    }
    
    
    // Implement the searchBarSearchButtonClicked method
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        // Access the user's query
        if let searchText = searchBar.text {
            print("Search button clicked with query: \(searchText)")
            
            if searchText.count > 0 {
                updateContent(keyword: searchText)
            }
        }
        
        // Dismiss the keyboard
        searchBar.resignFirstResponder()
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

extension CollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {

    // MARK: - UICollectionViewDataSource
    // 1
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // 2
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    // 3
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(
//            withReuseIdentifier: reuseIdentifier,
//            for: indexPath)
//        cell.backgroundColor = .black
        
        // 1
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CollectionViewCell.reuseIdentifier,
          for: indexPath
        ) as! CollectionViewCell
        cell.backgroundColor = .black
        cell.updateContent(data: getItemDataByIndex(indexPath: indexPath))
        
        // 2
//        let flickrPhoto = photo(for: indexPath)
//        cell.backgroundColor = .white
        // 3
//        cell.imageView.image = flickrPhoto.thumbnail
        
        
        return cell
    }
    
    // MARK: - Collection View Flow Layout Delegate
    // 1
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      // 2
      let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
      let availableWidth = view.frame.width - paddingSpace
      let widthPerItem = availableWidth / itemsPerRow
      
      return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    // 3
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    // 4
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
}
