//
//  PhotoSizeCell.swift
//

import UIKit

@objc protocol PhotoSizeCellDelegate: AnyObject {
    func clickedCell(data: Dictionary<String,AnyObject>?, sender:Any?)
    @objc optional func longPressedCell(data: Dictionary<String,AnyObject>?, sender:Any?)
    @objc optional func refreshCell(sender:Any?)
}


class PhotoSizeCell: UITableViewCell {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var pixelLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    
    var data: Dictionary<String,AnyObject>? = nil
    
    weak var delegate : PhotoSizeCellDelegate?
    
    var indexPath: IndexPath?
    var expiredLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        self.bgView.backgroundColor = .clear
        self.nameLabel.backgroundColor = .clear
        self.pixelLabel.backgroundColor = .clear
        self.sizeLabel.backgroundColor = .clear
        
        self.nameLabel.textColor = UIColor.black
        self.pixelLabel.textColor = UIColor.darkGray
        self.sizeLabel.textColor = UIColor.darkGray
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateContent(data: Dictionary<String,AnyObject>?, delegate : PhotoSizeCellDelegate?) {
        
        self.delegate = delegate
        self.data = data
        
        let name = self.data?["name"] as? String ?? ""
        let pixel_width = self.data?["pixel_width"] as? String ?? ""
        let pixel_height = self.data?["pixel_height"] as? String ?? ""
        let size_width = self.data?["size_width"] as? String ?? ""
        let size_height = self.data?["size_height"] as? String ?? ""
        
        self.nameLabel.text = name
        self.pixelLabel.text = "像素: \(pixel_width)x\(pixel_height)px"
        self.sizeLabel.text = "尺寸: \(size_width)x\(size_height)mm"

    }
    
}
