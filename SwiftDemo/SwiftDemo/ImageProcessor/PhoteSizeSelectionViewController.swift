//
//  PhoteSizeSelectionViewController.swift
//  SwiftDemo
//
//  Created by xuzepei on 2024/2/21.
//

import UIKit

class PhoteSizeSelectionViewController: UIViewController, UISearchBarDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: ScrollableSegmentedControl!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    var originalItemArray: NSMutableArray = NSMutableArray()
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
        
        setup()

        // Do any additional setup after loading the view.
        guard let fileURL = Bundle.main.url(forResource: "photo_size", withExtension: "json") else {
             print("File not found")
             return
         }
        
        do {
            // Read the contents of the file into a Data object
            let data = try Data(contentsOf: fileURL)
            if let array = Tool.parseToArray(jsonData: data) {
                self.originalItemArray.removeAllObjects()
                self.originalItemArray.addObjects(from: array)
                
                self.itemArray.removeAllObjects()
                self.itemArray.addObjects(from: array)
                
                self.tableView.reloadData()
            }
        } catch {
            print("Error reading JSON file:", error)
        }
        

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
    
    func updateContent() {
        
        self.itemArray.removeAllObjects()
        
        if self.keyword.count > 0 {
            for item in self.originalItemArray {
                if let dict = item as? Dictionary<String, AnyObject> {
                    if let name = dict["name"] as? String {
                        if let range = name.range(of: self.keyword, options: .caseInsensitive) {
                            self.itemArray.add(item)
                        } else {
                            print("No match found")
                        }
                    }
                }
            }
            
        } else {
            self.itemArray.removeAllObjects()
            self.itemArray.addObjects(from: self.originalItemArray as! [Any])
        }
        
        self.tableView.reloadData()
    }
    
    func initTableView() {
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        //self.tableView.backgroundColor = .blue
        
        let nib = UINib(nibName: cellNibName, bundle: nil)
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
        
        updateContent()
        
        
        // Perform your search operation here
        self.searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("searchText",searchText)
        self.keyword = searchText
        
        updateContent()
    }

    func selectImage() {
        
//#if DEBUG
//        DispatchQueue.main.async {
//            //self.processImageToRemoveBg(image: UIImage(named: "photo")!)
//            self.goToNext()
//        }
//        return
//#endif
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) || UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
        } else {
            // the device doesn't have a camera or the user hasn't granted permission
            Tool.showAlert(LS("Tip"), message: LS("The device doesn't have a camera or the user hasn't granted permission."), rootVC: self)
            return
        }
        
        
//        if(self.isRequesting) {
//            return
//        }
//
//
//        if(self.isUpdatingImage) {
//            Tool.showAlert(LS("Tip"), message: LS("Current image is updating, please wait for a moment."), rootVC: self)
//            return
//        }
        
        //只有相册
        if UIImagePickerController.isSourceTypeAvailable(.camera) == false &&  UIImagePickerController.isSourceTypeAvailable(.photoLibrary) == true {
            showImagePicker(sourceType: .photoLibrary)
            return
        }
        
        var alertStyle = UIAlertController.Style.actionSheet
        if (Tool.isIpad()) {
          alertStyle = UIAlertController.Style.alert
        }
        
        //两个都有
        let alert = UIAlertController(title: LS("Choose Photo Source"), message: nil, preferredStyle: alertStyle)
        alert.addAction(UIAlertAction(title: LS("Camera"), style: .default, handler: { _ in
            self.showImagePicker(sourceType: .camera)
        }))
        
        alert.addAction(UIAlertAction(title: LS("Photo Library"), style: .default, handler: { _ in
            self.showImagePicker(sourceType: .photoLibrary)
        }))
        
        alert.addAction(UIAlertAction(title: LS("Cancel"), style: .cancel))
        
        present(alert, animated: true)
    }
    
    func showImagePicker(sourceType: UIImagePickerController.SourceType) {
        
        let picker = UIImagePickerController()
        picker.modalPresentationStyle = .fullScreen
        picker.delegate = self
        picker.allowsEditing = false
        
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            picker.sourceType = sourceType
            if sourceType == .camera {
                picker.cameraCaptureMode = .photo
                picker.cameraDevice = .front
                picker.cameraFlashMode = .off
                picker.fixCannotMoveEditingBox()
            }
        } else {
            picker.sourceType = .photoLibrary
        }
        
        self.present(picker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        //先取编辑的图片
        var image: UIImage? = info[.editedImage] as? UIImage
        if image == nil {
            image = info[.originalImage] as? UIImage
        }
        
        
        if image != nil {

            let fixedImage = image!.fixOrientation()
            Tool.detectFaces(in: fixedImage) { result in
                if result == false {
                    DispatchQueue.main.async {
                        Tool.showAlert(LS("Tip"), message: LS("The photo must contain a human face. Please select a portrait facial photo."), rootVC: self)
                    }

                } else {
                    DispatchQueue.main.async {
                        self.processImageToRemoveBg(image: fixedImage)
                    }
                }
            }
        } else {

        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)  {
        
        dismiss(animated: true, completion: nil)
    }
    
    
    func goToNext() {
        if let resultImage = UIImage(named: "photo") {
            DispatchQueue.main.async {
                if let item = self.getCellDataAtIndexPath(self.selectedIndexPath) as? Dictionary<String, AnyObject> {
                    
                    let name = item["name"] as? String ?? ""
                    let pxielWidth = Double(item["pixel_width"] as? String ?? "0") ?? 0
                    let pxielHeight = Double(item["pixel_height"] as? String ?? "0") ?? 0
                    let sizeWidth = Double(item["size_width"] as? String ?? "0") ?? 0
                    let sizeHeight = Double(item["size_height"] as? String ?? "0") ?? 0
                    
                    let photo = Photo(pixelSize: CGSizeMake(pxielWidth, pxielHeight), physicalSize: CGSizeMake(sizeWidth, sizeHeight), label: name)
                    let vc = ImageCropViewController()
                    vc.title = "ImageCropView"
                    vc.targetPhoto = photo
                    vc.originalImage = resultImage
        
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }

        } else {
            print("####Failed to remove background")
        }
    }
    
    
    func processImageToRemoveBg(image: UIImage) {
//        ImageProcessor.shared.removeBackground(from: image, completion: { (resultImage) in
//            if let resultImage = resultImage {
//                DispatchQueue.main.async {
//                    
//                    if let item = self.getCellDataAtIndexPath(self.selectedIndexPath) as? Dictionary<String, AnyObject> {
//                        
//                        let name = item["name"] as? String ?? ""
//                        let pxielWidth = Double(item["pixel_width"] as? String ?? "0") ?? 0
//                        let pxielHeight = Double(item["pixel_height"] as? String ?? "0") ?? 0
//                        let sizeWidth = Double(item["size_width"] as? String ?? "0") ?? 0
//                        let sizeHeight = Double(item["size_height"] as? String ?? "0") ?? 0
//                        
//                        let photo = Photo(pixelSize: CGSizeMake(pxielWidth, pxielHeight), physicalSize: CGSizeMake(sizeWidth, sizeHeight), label: name)
//                        let vc = ImageCropViewController()
//                        vc.title = "ImageCropView"
//                        vc.targetPhoto = photo
//                        vc.originalImage = resultImage
//            
//                        self.navigationController?.pushViewController(vc, animated: true)
//                    }
//                }
//
//            } else {
//                print("####Failed to remove background")
//            }
//        }, withBgColor: .clear)
    }

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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func getCellDataAtIndexPath(_ indexPath: IndexPath) -> Any? {
        
        if (indexPath.row < self.itemArray.count) {
            return self.itemArray[indexPath.row]
        }
        
        return nil
    }
    
//    func getCellHeight(indexPath: IndexPath) -> CGFloat {
//        
//        return 100
//    }
    
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
        
        selectImage()
        
    }
    
}
