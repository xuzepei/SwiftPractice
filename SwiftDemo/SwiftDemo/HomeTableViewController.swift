//
//  HomeTableViewController.swift
//  SwiftDemo
//
//  Created by xuzepei on 2023/7/11.
//

import UIKit
import PowerplayToastKit
import SnapKit
import ZLImageEditor

class HomeTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var itemArray = NSMutableArray()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        itemArray.addObjects(from: ["AutoLayout-UIStackView","UICollectionView","ScanAnimation","Toast","ImageEditor","TagListView","ImageProcessor","ImageCropper","ImageCropView", "Select Photo Size", "ImageViewer", "ThreeDotsIndicator", "UIMenu"])
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

        } else if indexPath.row == 4 {
            
            ZLImageEditorConfiguration.default()
                .editImageTools([.draw, .clip, .imageSticker, .textSticker])
                .adjustTools([.brightness, .contrast, .saturation])

            ZLEditImageViewController.showEditImageVC(parentVC: self, image: UIImage(named: "tes")!, editModel: nil) { [weak self] (resImage, editModel) in
                NSLog("done.")
            }
            
        } else if indexPath.row == 5 {
            let vc = TagViewController()
            vc.title = getItemByIndex(indexPath: indexPath)
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 6 {
            let vc = ImageProcessorViewController()
            vc.title = getItemByIndex(indexPath: indexPath)
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 7 {
            
            let photo = UIImage(named: "photo")!
            
            guard let figure = ImageCropperConfiguration.ImageCropperFigureType(rawValue: 8) else { return }
            
            
            var config = ImageCropperConfiguration(with: photo, and: figure, cornerRadius: 0)
            config.showGrid = false
            if figure == .customRect {
                
                //一寸照295*413
              config.customRatio = CGSize(width: 16, height: 9)
            }
            
            config.backTintColor = .red
            config.backTitle = ""
            
            var croppedImage = photo
            let vc = ImageCropperViewController.initialize(with: config, completionHandler: { _croppedImage in
                guard let _img = _croppedImage else {
                    return
                }
                
                if let image = Tool.resizeImageByDPI(image: _img, target: Tool.photo2Inches)
                {
                    Tool.saveImageToPhotoLibrary(image: image, rootVC: self)
                }
                
            })
            vc.title = getItemByIndex(indexPath: indexPath)
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 8 {
            
            selectImage()
            
//            ImageProcessor.shared.removeBackground(from: image, completion: { (resultImage) in
//                if let resultImage = resultImage {
//                    self.outputIV.image = resultImage
//                } else {
//                    print("####Failed to remove background")
//                }
//            }, withBgColor: self.colorSelector.selectedColor)
//            
//            
//            let vc = ImageCropViewController()
//            vc.title = getItemByIndex(indexPath: indexPath)
//            vc.targetPhoto = Tool.photo1Inches
//            
//            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 9 {
            let vc = PhoteSizeSelectionViewController()
            vc.title = getItemByIndex(indexPath: indexPath)
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 10 {
//            let vc = ImageViewerViewController()
//            self.navigationController?.pushViewController(vc, animated: true)
            
            let images = [UIImage(named: "photo")!, UIImage(named: "photo2")!, UIImage(named: "tes")!]
            ImageViewer.show(with: images, from: nil)
            
//            let viewer = ImageViewer()
//            viewer.translatesAutoresizingMaskIntoConstraints = false
//            view.addSubview(viewer)
//            viewer.images = images
//            
//
//            NSLayoutConstraint.activate([
//                viewer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
//                viewer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
//                viewer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//                viewer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
//            ])
        } else if indexPath.row == 11  {
            let vc = ThreeDotsIndicatorViewController()
            vc.title = getItemByIndex(indexPath: indexPath)
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = MenuDemoViewController()
            vc.title = getItemByIndex(indexPath: indexPath)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func selectImage() {
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

            Tool.detectFaces(in: image!) { result in
                if result == false {
                    DispatchQueue.main.async {
                        Tool.showAlert(LS("Tip"), message: LS("The photo must contain a human face. Please select a portrait facial photo."), rootVC: self)
                    }

                } else {
                    DispatchQueue.main.async {
                        self.processImageToRemoveBg(image: image!)
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
    
    func processImageToRemoveBg(image: UIImage) {
//        ImageProcessor.shared.removeBackground(from: image, completion: { (resultImage) in
//            if let resultImage = resultImage {
//                DispatchQueue.main.async {
//                    let vc = ImageCropViewController()
//                    vc.title = "ImageCropView"
//                    vc.targetPhoto = Tool.photo2Inches
//                    vc.originalImage = resultImage
//        
//                    self.navigationController?.pushViewController(vc, animated: true)
//                }
//
//            } else {
//                print("####Failed to remove background")
//            }
//        }, withBgColor: .white)
    }
    
    func getDefaultDPI(for image: UIImage) -> CGFloat {
        // 获取图像的尺寸（以点为单位）
        let sizeInPoints = image.size
        
        // 获取图像的缩放比例（通常为1.0或2.0）
        let scale = image.scale
        
        // 计算图像的尺寸（以像素为单位）
        let widthInPixels = sizeInPoints.width * scale
        let heightInPixels = sizeInPoints.height * scale
        
        // 计算图像的默认 DPI
        let defaultDPI: CGFloat = 72.0 // iOS 设备的标准 DPI
        
        return max(widthInPixels, heightInPixels) / max(sizeInPoints.width, sizeInPoints.height) * defaultDPI
    }

    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage? {
        let newSize = targetSize
        let rect = CGRect(origin: .zero, size: newSize)

        UIGraphicsBeginImageContextWithOptions(targetSize, true, image.scale)
        defer { UIGraphicsEndImageContext() }

        image.draw(in: rect)

        guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }

        return newImage
    }
    
    func resizeImage2(image: UIImage, targetSize: CGSize) -> UIImage? {
        let newSize = targetSize
        
        // Define the physical size of the image in inches
        let imageSizeInInches = CGSize(width: Tool.millimetersToInches(newSize.width), height: Tool.millimetersToInches(newSize.height))
        
        // Calculate the image size in points (1 point = 1/72 inch)
        let imageSizeInPoints = CGSize(width: imageSizeInInches.width * 300.0, height: imageSizeInInches.height * 300.0)

        // Create a graphics context with the specified size and resolution (DPI)
        UIGraphicsBeginImageContextWithOptions(imageSizeInPoints, false, 1.0)
        defer { UIGraphicsEndImageContext() }

        image.draw(in: CGRect(origin: .zero, size: imageSizeInPoints))

        guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }

        return newImage
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
