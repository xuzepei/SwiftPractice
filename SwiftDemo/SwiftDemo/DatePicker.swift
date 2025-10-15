

import UIKit


class DatePicker: UIView {
    
    // MARK: - IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateContainer: UIStackView!
    @IBOutlet weak var buttonContainer: UIStackView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var okButton: UIButton!
    
    private var datePicker: UIDatePicker!
    
    var bgView: UIView!
    var completionBlock: ((Bool)->Void)? = nil
    var isForced = false
    
    class func instance() -> DatePicker {
        let view = UINib(nibName: String(describing: DatePicker.self), bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! DatePicker
        view.setup()
        return view
    }
    
    private func setup() {
        localize()
        
        self.backgroundColor = .white
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 0.5
        self.layer.cornerRadius = 20

        self.titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        
        
        // 添加 UIDatePicker
        datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.datePickerMode = .date  // 只选择日期
        datePicker.preferredDatePickerStyle = .inline
        dateContainer.addArrangedSubview(datePicker)
        
        // 让 datePicker 占满容器
        NSLayoutConstraint.activate([
            datePicker.leadingAnchor.constraint(equalTo: dateContainer.leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: dateContainer.trailingAnchor),
            datePicker.topAnchor.constraint(equalTo: dateContainer.topAnchor),
            datePicker.bottomAnchor.constraint(equalTo: dateContainer.bottomAnchor)
        ])
        
        
        self.cancelButton.addTarget(self, action: #selector(clickedCancelBtn(_:)), for: .touchUpInside)
        self.cancelButton.setTitleColor(UIColor.gray, for: .normal)
        self.okButton.addTarget(self, action: #selector(clickedOKBtn(_:)), for: .touchUpInside)
        
        self.layoutIfNeeded()
        self.layer.masksToBounds = true
        
//        self.okButton.backgroundColor = .systemBlue
//        //self.okButton.tintColor = .systemBlue
        self.okButton.setTitleColor(.systemBlue, for: .normal)
//        self.okButton.layer.cornerRadius = 6
//        self.okButton.layer.masksToBounds = true
    }
    
    func localize() {
        self.cancelButton.setTitle(LS("Cancel"), for: .normal)
        self.okButton.setTitle(LS("Done"), for: .normal)
    }
    
    
    func show(title: String, superView: UIView, completion: ((Bool)->Void)?) {
        
        self.completionBlock = completion
        
        bgView = UIView()
        bgView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        bgView.translatesAutoresizingMaskIntoConstraints = false
        superView.addSubview(bgView)
        
        NSLayoutConstraint.activate([
            bgView.leadingAnchor.constraint(equalTo: superView.leadingAnchor),
            bgView.trailingAnchor.constraint(equalTo: superView.trailingAnchor),
            bgView.topAnchor.constraint(equalTo: superView.topAnchor),
            bgView.bottomAnchor.constraint(equalTo: superView.bottomAnchor)
        ])
        
        self.isHidden = true
        superView.addSubview(self)
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: Tool.isIpad() ? 500:500),
            self.widthAnchor.constraint(equalToConstant: Tool.isIpad() ? 360:300),
            self.centerXAnchor.constraint(equalTo: superView.centerXAnchor),
            self.centerYAnchor.constraint(equalTo: superView.centerYAnchor)
        ])
        superView.layoutIfNeeded()
        
        self.titleLabel.text = title

        
        //确保layer计算时，位置信息已经完成autolayout
        setNeedsLayout()
        layoutIfNeeded()
        self.isHidden = false
        
        popupAnimation()
    }
    
    func popupAnimation() {
        // Make the view smaller in order to pop it in
        self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)

        // The animation part
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: .curveEaseOut, animations: {
            self.alpha = 1
            // Pop in the view by scaling it up to it's original size
            self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }, completion: nil)
    }
    
    // MARK: - Button Actions
    @objc func clickedCancelBtn(_ sender: Any) {
        NSLog("clickedCancelBtn:")
        
        self.removeFromSuperview()
        self.bgView.removeFromSuperview()
        
        DispatchQueue.main.async {
            if let completionBlock = self.completionBlock {
                completionBlock(false)
            }
        }
    }
    
    @objc func clickedOKBtn(_ sender: Any) {
        NSLog("clickedOKBtn:")
        
        let selectedDate = datePicker.date
        print("用户选择日期：\(selectedDate)")
        
        if isForced == false {
            self.removeFromSuperview()
            self.bgView.removeFromSuperview()
        }
        
        DispatchQueue.main.async {
            if let completionBlock = self.completionBlock {
                completionBlock(true)
            }
        }
    }
    
}
