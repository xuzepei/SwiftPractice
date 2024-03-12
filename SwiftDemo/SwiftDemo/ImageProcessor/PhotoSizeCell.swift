//
//  PhotoSizeCell.swift
//

import UIKit
import TTGTags

@objc protocol PhotoSizeCellDelegate: AnyObject {
    func clickedCell(data: Dictionary<String,AnyObject>?, sender:Any?)
    @objc optional func longPressedCell(data: Dictionary<String,AnyObject>?, sender:Any?)
    @objc optional func refreshCell(sender:Any?)
}


class PhotoSizeCell: UITableViewCell {
    
    @IBOutlet weak var toothImageView: UIImageView!
    @IBOutlet weak var badgeView: UIView!
    
    @IBOutlet weak var clinicLabel: UILabel!
    @IBOutlet weak var patientLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var tagsView: TagsView!
    @IBOutlet weak var tagsViewConstraintHeight: NSLayoutConstraint!
    
    var data: Dictionary<String,AnyObject>? = nil
    
    weak var delegate : PhotoSizeCellDelegate?
    
    var indexPath: IndexPath?
    var expiredLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.clinicLabel.backgroundColor = .clear
        self.patientLabel.backgroundColor = .clear
        self.dateLabel.backgroundColor = .clear

        badgeView.layer.cornerRadius = badgeView.bounds.width * 0.5
        
        expiredLabel = UILabel(frame: CGRectMake(UIDevice.screenWidth - 100, 20, 150, 15))
        expiredLabel.translatesAutoresizingMaskIntoConstraints = true
        expiredLabel.backgroundColor = .orange
        expiredLabel.text = LS("Expired")
        expiredLabel.textColor = .black
        expiredLabel.font = UIFont.systemFont(ofSize: 12)
        expiredLabel.textAlignment = .center
        expiredLabel.transform = CGAffineTransform(rotationAngle: .pi / 4)
        self.contentView.addSubview(expiredLabel)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateContent(data: Dictionary<String,AnyObject>?, delegate : PhotoSizeCellDelegate?) {
        
//        self.delegate = delegate
//        self.tagsView.removeAllTags()
//        self.badgeView.isHidden = true
//        //NSLog("####self.tagsView.lineWidth : \(UIDevice.screenWidth - 92)")
//        
//        self.tagsView.lineWidth = UIDevice.screenWidth - 92
//        self.tagsViewConstraintHeight.constant = 0
//        self.tagsView.setNeedsLayout()
//        self.tagsView.layoutIfNeeded()
//        
//        
//        self.data = data
//        
//        let clinicName = Tool.selectOrgName(data: self.data)
//        if let patientName = self.data?["patientName"] as? String, patientName.count > 0, clinicName.count > 0 {
//            let temp = patientName + " | " + clinicName
//            self.clinicLabel.text = temp
//        } else {
//            self.clinicLabel.text = clinicName
//        }
//        
//        if let editTime = self.data?["edit"] as? String, editTime.count > 0 {
//            self.dateLabel.text = editTime
//        } else {
//            self.dateLabel.text = self.data?["time"] as? String
//        }
//        
//        expiredLabel.isHidden = true
//        self.contentView.backgroundColor = .white
//
//        
//        /*caseType
//        0: 未知
//        1: 正畸
//        2: 种植
//        3: 修复*/
//        
//        
//        if let caseTypeNum = self.data?["caseType"] as? NSNumber {
//            let caseType = caseTypeNum.intValue
//            
//            var imageName = ""
//            switch caseType {
//            case 1:
//                imageName = "tooth1"
//            case 2:
//                imageName = "tooth2"
//            case 3:
//                imageName = "tooth3"
//            default:
//                imageName = ""
//            }
//            
//            self.toothImageView.image = UIImage(named: imageName)//?.withTintColor(UIColor.systemGray2)
//            
//            self.setLabelByType(type: caseType)
//        }
//        
//        let caseId = self.data?["id"] as? String ?? ""
        //setBadge(caseId: caseId)
    }
    
    func getTextWidth(text:String?, font: UIFont?, height: CGFloat = 30) -> CGFloat {
        
        guard let text = text else {
            return 0
        }
        
        let font = font ?? UIFont.systemFont(ofSize: 13)
        
        let attributes: [NSAttributedString.Key: Any] = [.font: font]
        let attributedText = NSAttributedString(string: text, attributes: attributes)

        let maxSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: height)
        let boundingRect = attributedText.boundingRect(with: maxSize, options: [.usesLineFragmentOrigin], context: nil)

        return ceil(boundingRect.width)
    }
    
}
